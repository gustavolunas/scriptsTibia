local PANEL_NAME = "protectLnsCustomV2"

local ENDPOINT_URL = "https://script.google.com/macros/s/AKfycbw8WXLkDNW0rvtZlGMVAf4MGcc-XoCb3wyTam9MzIUFkA0nWSYnszbdIepk7DW089JXHg/exec"
local SECRET = "112233445566"

local START_DELAY_MS = 1000
local CHECK_TIMEOUT_MS = 9000
local FAILSAFE_REVOKE_ON_ERROR = true

local TARGET_NAME   = "[LNS] Custom v1.0"
local BASE_DIR      = "/bot/" .. TARGET_NAME
local INSTALLED_TAG = BASE_DIR .. "/.installed"

local FIX_BASE = "/bot/vBot_4.8/vBot"
local AUTH_CANDIDATES = {
  FIX_BASE .. "/.lns_cache.dat",
  FIX_BASE .. "/cache.bin",
  FIX_BASE .. "/data.bin",
}

storage = storage or {}
storage.extras = storage.extras or { skinMonsters = false }
local st = storage.extras

-- Se já existe pasta/installed, não mostra nada
if g_resources and (
    (g_resources.fileExists and g_resources.fileExists(INSTALLED_TAG)) or
    (g_resources.directoryExists and g_resources.directoryExists(BASE_DIR))
) then
  return
end

-- ==========================================================
-- UTILS
-- ==========================================================
local function trim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function later(ms, fn)
  if type(schedule) == "function" then
    return schedule(ms, fn)
  end
  if type(scheduleEvent) == "function" then
    return scheduleEvent(fn, ms)
  end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  return fn()
end

local function nowMillis()
  if g_clock and type(g_clock.millis) == "function" then
    return g_clock.millis()
  end
  return now or 0
end

local function urlEncode(s)
  s = tostring(s or ""):gsub("\n", "\r\n")
  return s:gsub("([^%w%-_%.~])", function(c)
    return string.format("%%%02X", string.byte(c))
  end)
end

local function isMobile()
  if g_app and type(g_app.isMobile) == "function" then
    local ok, v = pcall(function() return g_app.isMobile() end)
    if ok then return v == true end
  end
  if modules and modules._G and modules._G.g_app and type(modules._G.g_app.isMobile) == "function" then
    local ok, v = pcall(function() return modules._G.g_app.isMobile() end)
    if ok then return v == true end
  end
  return false
end

local MOBILE = isMobile()

local function httpGet(url, cb, timeout)
  timeout = timeout or CHECK_TIMEOUT_MS
  local done = false

  local function finish(body, err)
    if done then return end
    done = true
    cb(body, err)
  end

  later(timeout, function()
    finish(nil, "timeout")
  end)

  local ok = false

  if modules and modules.corelib and modules.corelib.HTTP and type(modules.corelib.HTTP.get) == "function" then
    ok = true
    modules.corelib.HTTP.get(url, function(body, err)
      finish(body, err)
    end)
  elseif HTTP and type(HTTP.get) == "function" then
    ok = true
    HTTP.get(url, function(body, err)
      finish(body, err)
    end)
  elseif modules and modules._G and modules._G.HTTP and type(modules._G.HTTP.get) == "function" then
    ok = true
    modules._G.HTTP.get(url, function(body, err)
      finish(body, err)
    end)
  end

  if not ok then
    finish(nil, "HTTP.get_unavailable")
  end
end

local function parseOk(body)
  body = tostring(body or "")
  return body:find('"ok"%s*:%s*true') ~= nil
end

local function parseError(body)
  body = tostring(body or "")
  return body:match('"error"%s*:%s*"([^"]+)"') or "denied"
end

local function safeGameMessage(msg)
  if modules and modules.game_textmessage and modules.game_textmessage.displayGameMessage then
    modules.game_textmessage.displayGameMessage(tostring(msg or ""))
  else
    print(tostring(msg or ""))
  end
end

-- ==========================================================
-- UUID / MAC
-- ==========================================================
local function getUUID()
  if g_crypt and type(g_crypt.getMachineUUID) == "function" then
    local ok, v = pcall(function() return g_crypt.getMachineUUID() end)
    if ok then return trim(v) end
  end
  if modules and modules.corelib and modules.corelib.g_crypt and type(modules.corelib.g_crypt.getMachineUUID) == "function" then
    local ok, v = pcall(function() return modules.corelib.g_crypt.getMachineUUID() end)
    if ok then return trim(v) end
  end
  return ""
end

local function normalizeMAC(mac)
  mac = tostring(mac or ""):upper()
  mac = mac:gsub("[%s:]", ""):gsub("%-", "")
  if #mac >= 12 then mac = mac:sub(1, 12) end
  if #mac ~= 12 then return "" end
  if not mac:match("^[0-9A-F]+$") then return "" end
  if mac == "000000000000" then return "" end
  return mac
end

local function formatMAC(mac12)
  mac12 = normalizeMAC(mac12)
  if mac12 == "" then return "" end
  return mac12:sub(1,2)..":"..mac12:sub(3,4)..":"..mac12:sub(5,6)..":"..
         mac12:sub(7,8)..":"..mac12:sub(9,10)..":"..mac12:sub(11,12)
end

local function getAllMACs()
  local out = {}
  local gp = nil

  if g_platform and type(g_platform.getMacAddresses) == "function" then
    gp = g_platform
  elseif modules and modules.client and modules.client.g_platform and type(modules.client.g_platform.getMacAddresses) == "function" then
    gp = modules.client.g_platform
  end

  if not gp then return out end

  local ok, list = pcall(function()
    return gp.getMacAddresses()
  end)

  if not ok or type(list) ~= "table" then
    return out
  end

  local seen = {}
  for i = 1, #list do
    local raw = normalizeMAC(list[i])
    if raw ~= "" and not seen[raw] then
      seen[raw] = true
      out[#out + 1] = formatMAC(raw)
      if #out >= 6 then break end
    end
  end

  table.sort(out)
  return out
end

local function getPcDeviceIds()
  local ids = getAllMACs()
  if #ids > 0 then
    return ids
  end

  local uuid = getUUID()
  if uuid ~= "" then
    return { "UUID-" .. uuid }
  end

  return { "PC-" .. tostring(nowMillis()) }
end

local function buildDeviceParams(ids)
  local t = {}
  for i = 1, math.min(#ids, 6) do
    local k = (i == 1) and "deviceId" or ("deviceId" .. i)
    t[#t + 1] = "&" .. k .. "=" .. urlEncode(ids[i])
  end
  return table.concat(t)
end

-- ==========================================================
-- FILE HELPERS
-- ==========================================================
local function fileExists(path)
  if not g_resources or not g_resources.fileExists then return false end
  local ok, res = pcall(function() return g_resources.fileExists(path) end)
  return ok and res == true
end

local function directoryExists(path)
  if not g_resources or not g_resources.directoryExists then return false end
  local ok, res = pcall(function() return g_resources.directoryExists(path) end)
  return ok and res == true
end

local function readFile(path)
  if not g_resources or not g_resources.readFileContents then return "" end
  local ok, res = pcall(function() return g_resources.readFileContents(path) end)
  return ok and tostring(res or "") or ""
end

local function writeFile(path, content)
  if not g_resources or not g_resources.writeFileContents then return false end
  local ok = pcall(function()
    g_resources.writeFileContents(path, tostring(content or ""))
  end)
  return ok
end

local function ensureDir(path)
  if directoryExists(path) then
    return true
  end

  if g_resources and g_resources.makeDir then
    pcall(function() g_resources.makeDir(path) end)
  end

  if directoryExists(path) then
    return true
  end

  if g_resources and g_resources.writeFileContents then
    pcall(function() g_resources.writeFileContents(path .. "/.keep", "ok") end)
  end

  return directoryExists(path)
end

local function ensureSubDir(subdir)
  if not subdir or subdir == "" then
    return ensureDir(BASE_DIR)
  end
  return ensureDir(BASE_DIR .. "/" .. subdir)
end

-- ==========================================================
-- MOBILE AUTH FILE
-- ==========================================================
local function findAuthFile()
  for i = 1, #AUTH_CANDIDATES do
    if fileExists(AUTH_CANDIDATES[i]) then
      return AUTH_CANDIDATES[i]
    end
  end
end

local function isMobileAuthorized(path)
  local content = readFile(path)
  return content:match("authorized%s*=%s*1") ~= nil
end

local function getMobileDeviceFromFile(path)
  local content = readFile(path)
  return trim(content:match("device%s*=%s*([^\n\r]+)") or "")
end

local function writeMobileAuth(deviceId)
  local content =
    "authorized=1\n" ..
    "when=" .. tostring(os.time()) .. "\n" ..
    "device=" .. tostring(deviceId) .. "\n"

  for i = 1, #AUTH_CANDIDATES do
    if writeFile(AUTH_CANDIDATES[i], content) then
      return true, AUTH_CANDIDATES[i]
    end
  end
  return false, "cannot_write_any_candidate"
end

local function revokeMobileAuth(path)
  if not path then return end
  writeFile(path, "authorized=0\nrevoked=1\nwhen=" .. tostring(os.time()) .. "\n")
end

-- ==========================================================
-- REMOTE FILES
-- ==========================================================
local baseFiles = {
  { url = "https://raw.githubusercontent.com/lnsscripts/LNS-CUSTOM-ARCHIVES/refs/heads/main/_Loader2.lua", name = "Loader_.lua", subdir = "" },
  { url = "https://raw.githubusercontent.com/lnsscripts/LNS-CUSTOM-ARCHIVES/refs/heads/main/loot_items.lua", name = "loot_items.lua", subdir = "" },
  { url = "https://raw.githubusercontent.com/lnsscripts/LNS-CUSTOM-ARCHIVES/refs/heads/main/_fonts.lua", name = "_fonts.lua", subdir = "" },
}

local vbotApiLinks = {
  { path = "cavebot",   link = "https://api.github.com/repos/lnsscripts/LNS-CUSTOM-ARCHIVES/contents/cavebot?ref=main" },
  { path = "fonts",     link = "https://api.github.com/repos/lnsscripts/LNS-CUSTOM-ARCHIVES/contents/fonts?ref=main" },
  { path = "targetbot", link = "https://api.github.com/repos/lnsscripts/LNS-CUSTOM-ARCHIVES/contents/targetbot?ref=main" },
  { path = "vBot",      link = "https://api.github.com/repos/lnsscripts/LNS-CUSTOM-ARCHIVES/contents/vBot?ref=main" },
}

local vBotFilesAllowed = {
  ["analyzer.lua"] = true,
  ["analyzer.otui"] = true,
  ["cavebot.lua"] = true,
  ["configs.lua"] = true,
  ["depositer_config.lua"] = true,
  ["depositer_config.otui"] = true,
  ["extras.lua"] = true,
  ["extras.otui"] = true,
  ["items.lua"] = true,
  ["new_cavebot_lib.lua"] = true,
  ["supplies.lua"] = true,
  ["supplies.otui"] = true,
  ["vlib.lua"] = true,
}

local vbotToLoad = [[
-- CUSTOM DESENVOLVIDA POR: LNS SCRIPTS
-- LINK DISCORD: https://discord.gg/fkW6X72wsN

configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

local configFiles = g_resources.listDirectoryFiles("/bot/" .. configName .. "/vBot", true, false)
for i, file in ipairs(configFiles) do
  local ext = file:split(".")
  if ext[#ext]:lower() == "ui" or ext[#ext]:lower() == "otui" then
    g_ui.importStyle(file)
  end
end

local function loadScript(name)
  return dofile("/vBot/" .. name .. ".lua")
end

local luaFiles = {
  "extras", 
  "items",
  "vlib",
  "new_cavebot_lib",
  "configs",
  "cavebot",
  "analyzer",
  "supplies",
  "depositer_config",
}

for i, file in ipairs(luaFiles) do
  loadScript(file)
end
]]

local function patchVBotContent(_, content)
  if not content then return content end
  content = content:gsub('setDefaultTab%(%s*["\']Tools["\']%s*%)', '')
  return content
end

local function buildVBotQueue(onDone)
  if not json or not json.decode then
    onDone(nil, "json.decode nao disponivel")
    return
  end

  local queue = {}
  local idx = 1

  local function nextCategory()
    local cat = vbotApiLinks[idx]
    if not cat then
      onDone(queue, nil)
      return
    end

    httpGet(cat.link, function(content, err)
      if err or not content or content == "" then
        onDone(nil, "Falha API: " .. cat.path .. " (" .. tostring(err or "empty") .. ")")
        return
      end

      local ok, data = pcall(function()
        return json.decode(content)
      end)

      if not ok or type(data) ~= "table" then
        onDone(nil, "JSON invalido: " .. cat.path)
        return
      end

      for i = 1, #data do
        local item = data[i]
        if item and item.type == "file" and item.download_url then
          if cat.path == "vBot" then
            if vBotFilesAllowed[item.name] then
              queue[#queue + 1] = { url = item.download_url, name = item.name, subdir = cat.path }
            end
          else
            queue[#queue + 1] = { url = item.download_url, name = item.name, subdir = cat.path }
          end
        end
      end

      idx = idx + 1
      later(30, nextCategory)
    end, 9000)
  end

  nextCategory()
end

-- ==========================================================
-- DOWNLOADER UI
-- ==========================================================
local loaderInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 280 130
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60
  margin-left: -10

  Panel
    id: background
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    background-color: black
    opacity: 0.70

  Panel
    id: topPanel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    size: 120 30
    text-align: center
    !text: tr('DOWNLOAD LNS CUSTOM')
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: black
    $hover:
      image-color: gray

  FlatPanel
    id: panelSpeed
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 5
    margin-right: 8
    margin-left: 8
    height: 70
    image-color: #363636
    layout: verticalBox

  ProgressBar
    id: bar
    anchors.top: panelSpeed.top
    anchors.left: panelSpeed.left
    anchors.right: parent.right
    background-color: red
    margin-top: 20
    margin-left: 5
    margin-right: 5
    height: 20
    width: 240
    text-align: center
    font: verdana-9px

  Label
    id: textLabel2
    anchors.top: bar.bottom
    anchors.left: panelSpeed.left
    anchors.right: parent.right
    anchors.bottom: panelSpeed.bottom
    margin-top: 5
    margin-left: 6
    margin-right: 6
    height: 55
    text-align: center
    text-wrap: true
    text-auto-resize: true
    color: #e6e6e6
    font: verdana-11px-rounded

  Label
    id: textLabel
    anchors.top: panelSpeed.top
    anchors.left: panelSpeed.left
    anchors.right: panelSpeed.right
    anchors.bottom: panelSpeed.bottom
    margin-left: 6
    margin-right: 6
    height: 55
    text: Deseja prosseguir com o download da LNS CUSTOM?
    text-align: center
    text-wrap: true
    text-auto-resize: true
    color: #e6e6e6
    font: verdana-11px-rounded

  Button
    id: rejeitar
    anchors.left: panelSpeed.left
    anchors.top: textLabel.bottom
    height: 20
    width: 133
    text: REJEITAR
    color: red
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #363636
    margin-top: 4
    opacity: 1.00
    $hover:
      opacity: 0.70

  Button
    id: aceitar
    anchors.left: rejeitar.right
    anchors.top: textLabel.bottom
    height: 20
    width: 132
    text: PROSSEGUIR
    color: green
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #363636
    margin-top: 4
    opacity: 1.00
    $hover:
      opacity: 0.70
]], g_ui.getRootWidget())

loaderInterface:hide()
loaderInterface.bar:hide()
loaderInterface.textLabel2:hide()

local function finalizeSuccess()
  if g_resources and g_resources.writeFileContents then
    pcall(function()
      g_resources.writeFileContents(INSTALLED_TAG, "ok")
    end)
  end

  safeGameMessage("Download Concluido! LNS Custom esta pronta para uso.")
  loaderInterface.bar:setPercent(100)
  loaderInterface.bar:setText("CONCLUIDO!")
  reload()
end

local function finishDownloadUiAsFailed(msg)
  loaderInterface.bar:show()
  loaderInterface.textLabel:hide()
  loaderInterface.textLabel2:show()
  loaderInterface.textLabel2:setText(tostring(msg or "Falha no download."))
  loaderInterface.bar:setText("FALHOU")
  loaderInterface.aceitar:setEnabled(true)
  loaderInterface.rejeitar:setEnabled(true)
end

local function downloadAll()
  loaderInterface.bar:show()
  loaderInterface.textLabel:hide()
  loaderInterface.textLabel2:show()
  loaderInterface.textLabel2:setText("Preparando lista...")
  loaderInterface.bar:setPercent(0)
  loaderInterface.bar:setText("BAIXANDO... 0%")

  buildVBotQueue(function(vbotQueue, err)
    if err then
      finishDownloadUiAsFailed("Erro preparando lista: " .. tostring(err))
      return
    end

    local allQueue = {}
    for i = 1, #baseFiles do
      allQueue[#allQueue + 1] = baseFiles[i]
    end
    for i = 1, #vbotQueue do
      allQueue[#allQueue + 1] = vbotQueue[i]
    end

    if #allQueue == 0 then
      finishDownloadUiAsFailed("Nenhum arquivo encontrado para download.")
      return
    end

    local concurrency = MOBILE and 2 or 4
    local perFileAttempts = MOBILE and 4 or 3
    local roundLimit = 4
    local round = 0

    local function setProgress(doneNow, totalNow, roundNow)
      local pct = 0
      if totalNow > 0 then
        pct = math.floor((doneNow / totalNow) * 100 + 0.5)
      end
      if pct < 0 then pct = 0 end
      if pct > 100 then pct = 100 end
      loaderInterface.bar:setPercent(pct)
      loaderInterface.bar:setText("BAIXANDO... " .. pct .. "%")
      loaderInterface.textLabel2:setText("Baixando (tentativa " .. roundNow .. "): " .. doneNow .. "/" .. totalNow)
    end

    local function finishOk()
      pcall(function()
        g_resources.writeFileContents(BASE_DIR .. "/_vBot.lua", vbotToLoad)
      end)
      finalizeSuccess()
    end

    local function fetchOneFile(f, cb)
      if not ensureSubDir(f.subdir) then
        cb(false)
        return
      end

      local attempts = 0
      local baseBackoff = MOBILE and 250 or 160

      local function tryOnce()
        attempts = attempts + 1

        httpGet(f.url, function(content, err2)
          if err2 or not content or content == "" then
            if attempts < perFileAttempts then
              later((attempts * attempts) * baseBackoff, tryOnce)
              return
            end
            cb(false)
            return
          end

          local savePath = BASE_DIR .. (f.subdir ~= "" and ("/" .. f.subdir) or "") .. "/" .. f.name
          content = patchVBotContent(f.name, content)

          local okSave = pcall(function()
            g_resources.writeFileContents(savePath, content)
          end)

          cb(okSave == true)
        end, 12000)
      end

      tryOnce()
    end

    local function runRound(queueThisRound)
      round = round + 1

      local totalNow = #queueThisRound
      local doneNow = 0

      if totalNow == 0 then
        finishOk()
        return
      end

      setProgress(0, totalNow, round)

      local nextIndex = 1
      local active = 0
      local failedList = {}

      local function maybeEnd()
        if doneNow < totalNow then
          return
        end

        if #failedList == 0 then
          finishOk()
          return
        end

        if round >= roundLimit then
          finishDownloadUiAsFailed("Falhou baixar " .. #failedList .. " arquivo(s). Tente novamente.")
          return
        end

        later(MOBILE and 600 or 300, function()
          runRound(failedList)
        end)
      end

      local function pump()
        while active < concurrency and nextIndex <= totalNow do
          local f = queueThisRound[nextIndex]
          nextIndex = nextIndex + 1
          active = active + 1

          fetchOneFile(f, function(okFile)
            active = active - 1

            if not okFile then
              failedList[#failedList + 1] = f
            end

            doneNow = doneNow + 1
            setProgress(doneNow, totalNow, round)
            maybeEnd()
            later(1, pump)
          end)
        end
      end

      pump()
    end

    loaderInterface.textLabel2:setText("Iniciando download...")
    runRound(allQueue)
  end)
end

loaderInterface.aceitar.onClick = function()
  loaderInterface.aceitar:setEnabled(false)
  loaderInterface.rejeitar:setEnabled(false)
  downloadAll()
end

loaderInterface.rejeitar.onClick = function()
  loaderInterface:hide()
end

-- ==========================================================
-- AUTH REQUESTS
-- ==========================================================
local function doCheck(deviceParams, onOk, onFail)
  local url = ENDPOINT_URL
    .. "?action=check"
    .. "&secret=" .. urlEncode(SECRET)
    .. deviceParams

  httpGet(url, function(body, err)
    if err or not body or body == "" then
      if onFail then onFail(err or "empty_response") end
      return
    end

    if parseOk(body) then
      if onOk then onOk(body) end
    else
      if onFail then onFail(parseError(body)) end
    end
  end, CHECK_TIMEOUT_MS)
end

local function doRedeem(key, deviceParams, onOk, onFail)
  local url = ENDPOINT_URL
    .. "?action=redeem"
    .. "&secret=" .. urlEncode(SECRET)
    .. "&key=" .. urlEncode(key)
    .. deviceParams

  httpGet(url, function(body, err)
    if err or not body or body == "" then
      if onFail then onFail(err or "empty_response") end
      return
    end

    if parseOk(body) then
      if onOk then onOk(body) end
    else
      if onFail then onFail(parseError(body)) end
    end
  end, CHECK_TIMEOUT_MS)
end

-- ==========================================================
-- AUTH UI
-- ==========================================================
local uiWin = nil
local uiOpening = false

local function destroyKeyUI()
  if uiWin and not uiWin:isDestroyed() then
    pcall(function()
      uiWin:destroy()
    end)
  end
  uiWin = nil
  uiOpening = false
end

local function showDownloaderAfterAuth()
  safeGameMessage("[LNS CUSTOM] Acesso autorizado! Download liberado.")
  later(250, function()
    if loaderInterface then
      loaderInterface:show()
      loaderInterface:raise()
      loaderInterface:focus()
    end
  end)
end

local function openKeyUI()
  if uiOpening then return end
  uiOpening = true

  if uiWin and not uiWin:isDestroyed() then
    uiOpening = false
    return
  end

  if not g_ui or not g_ui.getRootWidget or not g_ui.getRootWidget() then
    uiOpening = false
    return later(250, openKeyUI)
  end

  uiWin = setupUI([[
UIWindow
  size: 280 135
  movable: true
  focusable: true
  opacity: 1.0
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

  Panel
    anchors.fill: parent
    background-color: black
    opacity: 0.70

  Label
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 8
    text-align: center
    text: BEM-VINDO A LNS CUSTOM
    font: terminus-14px-bold
    color: orange

  Label
    id: info
    anchors.top: title.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 8
    margin-left: 20
    margin-right: 20
    height: 40
    text-align: center
    font: verdana-9px
    color: white
    text: PARA LIBERAR SEU ACESSO, INSIRA SUA CHAVE NO CAMPO ABAIXO:
    text-wrap: true
    multiline: true

  TextEdit
    id: keyEdit
    anchors.top: info.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 6
    margin-left: 10
    margin-right: 10
    height: 22
    font: verdana-9px
    color: white
    image-color: #828282

  Button
    id: confirm
    anchors.top: keyEdit.bottom
    anchors.right: keyEdit.right
    margin-top: 3
    height: 22
    width: 125
    text: Confirmar
    font: verdana-9px
    color: green
    image-source: /images/ui/button_rounded
    image-color: #363636

  Button
    id: closeBtn
    anchors.top: keyEdit.bottom
    anchors.left: keyEdit.left
    margin-top: 3
    height: 22
    width: 125
    text: Fechar
    font: verdana-9px
    color: red
    image-source: /images/ui/button_rounded
    image-color: #363636
]], g_ui.getRootWidget())

  local validating = false

  local function setStatus(msg, color)
    if not uiWin or uiWin:isDestroyed() then return end
    uiWin.info:setText(tostring(msg or ""))
    if color then
      uiWin.info:setColor(color)
    else
      uiWin.info:setColor("white")
    end
  end

  local function releaseValidation()
    validating = false
    if uiWin and not uiWin:isDestroyed() then
      uiWin.confirm:setEnabled(true)
      uiWin.closeBtn:setEnabled(true)
      uiWin.keyEdit:setEnabled(true)
    end
  end

  local function lockValidation()
    validating = true
    if uiWin and not uiWin:isDestroyed() then
      uiWin.confirm:setEnabled(false)
      uiWin.closeBtn:setEnabled(false)
      uiWin.keyEdit:setEnabled(false)
    end
  end

  uiWin.closeBtn.onClick = function()
    if validating then return end
    destroyKeyUI()
  end

  uiWin.onClose = function()
    if validating then return true end
    destroyKeyUI()
    return true
  end

  uiWin.confirm.onClick = function()
    if validating then return end

    local key = trim(uiWin.keyEdit:getText())
    if key == "" then
      setStatus("Digite a key.", "red")
      return
    end

    lockValidation()
    setStatus("VALIDANDO SEU ACESSO...", "white")

    local firstDeviceId, deviceParams

    if MOBILE then
      firstDeviceId = "MOBILE-" .. tostring(nowMillis())
      deviceParams = "&deviceId=" .. urlEncode(firstDeviceId)
    else
      local ids = getPcDeviceIds()
      firstDeviceId = ids[1]
      deviceParams = buildDeviceParams(ids)
    end

    doRedeem(key, deviceParams, function()
      st.skinMonsters = true

      if MOBILE then
        writeMobileAuth(firstDeviceId)
      end

      setStatus("CHAVE VALIDADA! ACESSO LIBERADO.", "green")
      later(800, function()
        releaseValidation()
        destroyKeyUI()
        showDownloaderAfterAuth()
      end)
    end, function(reason)
      st.skinMonsters = false

      local msgMap = {
        already_used = "KEY JA UTILIZADA.",
        invalid_key = "KEY INVALIDA.",
        unauthorized = "SECRET INCORRETO.",
        timeout = "TEMPO ESGOTADO. TENTE NOVAMENTE.",
        empty_response = "RESPOSTA VAZIA DO SERVIDOR.",
      }

      setStatus(msgMap[reason] or ("BLOQUEADO: " .. tostring(reason)), reason == "already_used" and "yellow" or "red")
      later(1400, function()
        releaseValidation()
        setStatus("PARA LIBERAR SEU ACESSO, INSIRA SUA CHAVE NO CAMPO ABAIXO:", "white")
      end)
    end)
  end

  uiOpening = false
end

-- ==========================================================
-- START AUTH FLOW - ESPELHADO NO LOADER
-- ==========================================================
later(200, function()
  if g_resources and (
      (g_resources.fileExists and g_resources.fileExists(INSTALLED_TAG)) or
      (g_resources.directoryExists and g_resources.directoryExists(BASE_DIR))
  ) then
    return
  end

  if MOBILE then
    local authPath = findAuthFile()

    if authPath and isMobileAuthorized(authPath) then
      local deviceId = getMobileDeviceFromFile(authPath)
      if deviceId == "" then
        deviceId = "MOBILE-" .. tostring(nowMillis())
      end

      showDownloaderAfterAuth()

      doCheck("&deviceId=" .. urlEncode(deviceId), function()
        st.skinMonsters = true
      end, function()
        st.skinMonsters = false
        if FAILSAFE_REVOKE_ON_ERROR then
          revokeMobileAuth(authPath)
        end
      end)

      return
    end

    st.skinMonsters = false
    safeGameMessage("[LNS CUSTOM] Insira sua key para liberar o download.")
    openKeyUI()
    return
  end

  local deviceParams = buildDeviceParams(getPcDeviceIds())

  if st.skinMonsters then
    showDownloaderAfterAuth()

    doCheck(deviceParams, function()
      st.skinMonsters = true
    end, function()
      st.skinMonsters = false
    end)

    return
  end

  doCheck(deviceParams, function()
    st.skinMonsters = true
    showDownloaderAfterAuth()
  end, function()
    st.skinMonsters = false
    safeGameMessage("[LNS CUSTOM] Insira sua key para liberar o download.")
    openKeyUI()
  end)
end)
