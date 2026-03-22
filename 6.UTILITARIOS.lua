setDefaultTab("LNS")

local iconUtilitys = setupUI([[
Panel
  height: 18
  margin-top: 2
  
  Button
    id: settings
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: UTILITARIOS
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green
]])

extrasButton = setupUI([[
Panel
  height: 18

  Button
    id: vBotExtras
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: VBOT SETTINGS
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green
]])

extrasButton.vBotExtras.onClick = function()
  extrasWindow:show()
  extrasWindow:raise()
  extrasWindow:focus()
end

utilityInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 400 360
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

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
    !text: tr('LNS Custom | Utilitys Setup')
    font: verdana-11px-rounded
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f
  
  Panel
    id: iconPanel
    anchors.top: parent.top
    anchors.left: parent.left
    size: 60 60
    margin-top: -19
    margin-left: -15

  UIButton
    id: closePanel
    anchors.top: topPanel.top
    anchors.right: parent.right
    size: 18 18
    margin-top: 6
    margin-right: 10
    background-color: orange
    text: X
    color: white
    opacity: 1.00
    $hover:
      color: black
      opacity: 0.80

  Panel
    id: content
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-left: 10
    margin-bottom: 5
    margin-top: 12
    margin-right: 10
    background-color: #1b1b1b
    border: 1 #3b2a10
    opacity: 0.95

    Panel
      id: leftMacros
      anchors.top: parent.top
      anchors.left: parent.left
      height: 321
      width: 190
      margin-top: -1
      layout: verticalBox
      padding: 5

    VerticalSeparator
      id: vsep
      anchors.left: prev.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom

    Panel
      id: rightMacros
      anchors.top: parent.top
      anchors.left: leftMacros.right
      height: 320
      margin-left: 1
      width: 190
      layout: verticalBox
      padding: 5
      padding-right: 5
      
]], g_ui.getRootWidget())
utilityInterface:hide()

utilityInterface.closePanel.onClick = function()
  utilityInterface:hide()
end

iconUtilitys.settings.onClick = function()
  if not utilityInterface:isVisible() then
    utilityInterface:show()
    utilityInterface:raise()
    utilityInterface:focus()
  end
end

local destLeft = utilityInterface.content.leftMacros
local destRight = utilityInterface.content.rightMacros

-- =====================================================
-- LNS UTIL <-> ICONS (registro automático)
-- =====================================================
local function getMyConfigNameSafe()
  local cfg = "default"
  if modules and modules.game_bot and modules.game_bot.contentsPanel
    and modules.game_bot.contentsPanel.config
    and modules.game_bot.contentsPanel.config.getCurrentOption then
    local opt = modules.game_bot.contentsPanel.config:getCurrentOption()
    if opt and opt.text then cfg = opt.text end
  end
  return cfg
end

local MyConfigName = getMyConfigNameSafe()

storage.lnsUtilIcons = storage.lnsUtilIcons or {}
storage.lnsUtilIcons[MyConfigName] = storage.lnsUtilIcons[MyConfigName] or {}

local function utilIconIdFromKey(key)
  key = tostring(key or "")
  if key == "" then return nil end
  return "lnsUtil_" .. key
end

local function registerUtilityIcon(text, key)
  local iconId = utilIconIdFromKey(key)
  if not iconId then return end

  local label = tostring(text or key):upper()

  storage.lnsUtilIcons[MyConfigName][iconId] = {
    id = iconId,
    label = label,
    iconText = label,
    storeKey = tostring(key)
  }
end

storage.utilityToggles = storage.utilityToggles or {}

-- referência dos BotSwitch criados no painel
utilSwitches = utilSwitches or {} -- [key] = widget

function setUtilityToggle(key, state)
  key = tostring(key or "")
  if key == "" then return end

  state = (state == true)
  storage.utilityToggles[key] = state

  local w = utilSwitches[key]
  if w and w.setOn then
    w:setOn(state)
  end

  local cfgName = getMyConfigNameSafe()
  local iconDb = storage.lnsIconsDB
    and storage.lnsIconsDB[cfgName]

  local iconId = utilIconIdFromKey(key)
  local iconKey = iconId and ("show_" .. iconId) or nil

  local allowIconUpdate = iconDb
    and iconDb.iconConfig
    and iconKey
    and iconDb.iconConfig[iconKey] == true

  if LnsUtilIcons and type(LnsUtilIcons.onToggleChanged) == "function" then
    LnsUtilIcons.onToggleChanged(key, state)
  end
  
end

-- =========================
-- PRESETS (estilo padrão)
-- =========================
local BotSwitchPresets = {
  default = {
    width = 110,
    height = 18,
    font = "verdana-9px",
    imageSource = "/images/ui/button_rounded",
    off = { textColor = "white"},
    on  = { textColor = "white"},
  },
}

local function applyState(sw, preset, isOn)
  local st = isOn and preset.on or preset.off
  if sw.setFont and preset.font then sw:setFont(preset.font) end
  if sw.setColor and st.textColor then sw:setColor(st.textColor) end
end

-- =========================
-- createBotSwitch("preset", parent, "Texto", storageTable, "key")
-- (AJUSTADO: sem double-toggle + registra ícone)
-- =========================
function createBotSwitch(presetName, parent, text, store, key)
  local preset = BotSwitchPresets[presetName or "default"] or BotSwitchPresets.default
  local sw = g_ui.createWidget("BotSwitch", parent)
  if not sw then return nil end

  key = tostring(key or "")
  if key == "" then return sw end

  -- registra esse toggle como ícone no ICONS
  registerUtilityIcon(text, key)

  if sw.setText then sw:setText(text or "") end
  if sw.setWidth and preset.width then sw:setWidth(preset.width) end
  if sw.setHeight and preset.height then sw:setHeight(preset.height) end
  if sw.setImageSource and preset.imageSource then sw:setImageSource(preset.imageSource) end

  -- garante tabela e inicial (compatível com store antigo)
  if store and key then
    store[key] = (store[key] == true)
    if storage.utilityToggles[key] == nil then
      storage.utilityToggles[key] = store[key]
    end
  end

  local initial = (storage.utilityToggles[key] == true)

  if sw.setOn then sw:setOn(initial) end
  applyState(sw, preset, initial)

  utilSwitches[key] = sw

  -- clique: usa o setter único (sem double toggle)
  sw.onClick = function(widget)
    local newState = not (storage.utilityToggles[key] == true)
    setUtilityToggle(key, newState)
    applyState(widget, preset, newState)
  end

  return sw
end

if not storage.proximaBpID then storage.proximaBpID = {{id=2854}} end
if type(storage.transformarCoin) ~= "table" then storage.transformarCoin = {3031, 3035, 3043} end
if type(storage.proximaBpID) == "table" then
  for i, v in ipairs(storage.proximaBpID) do
    if type(v) == "number" then storage.proximaBpID[i] = {id = v} end
  end
end
if not storage.doorIds then storage.doorIds = { 5129, 5102, 5111, 5120, 11246 } end

local function properTable(t)
  local r = {}
  for _, entry in pairs(t) do
    table.insert(r, entry.id)
  end
  return r
end

-- LADO ESQUERDO
createBotSwitch("default", destLeft, "Hold Target", storage.utilityToggles, "holdTarget")
createBotSwitch("default", destLeft, "Summon Familiar", storage.utilityToggles, "summonFamiliar")
createBotSwitch("default", destLeft, "Super Dash", storage.utilityToggles, "superDash")
UI.Separator(destLeft)
createBotSwitch("default", destLeft, "Esconder Sprites", storage.utilityToggles, "esconderSprites")
createBotSwitch("default", destLeft, "Esconder Textos", storage.utilityToggles, "esconderTextos")
createBotSwitch("default", destLeft, "Montar Automatico", storage.utilityToggles, "autoMont")
UI.Separator(destLeft)
createBotSwitch("default", destLeft, "Hold Position", storage.utilityToggles, "holdPosition")
createBotSwitch("default", destLeft, "Sleep Mode", storage.utilityToggles, "sleepMode")
createBotSwitch("default", destLeft, "Dancing", storage.utilityToggles, "dancingMode")
UI.Separator(destLeft)
label = UI.Label("ID Potion Mana:", destLeft) label:setFont("verdana-9px") label:setMarginTop(0)
potionText = addTextEdit("mi", storage.mi or "23373", function(widget, text) if tonumber(text) then mi = tonumber(text) end storage.mi = tonumber(text) end, destLeft) potionText:setImageColor("#828282") potionText:setMarginLeft(1) potionText:setMarginRight(2) potionText:setFont("verdana-9px")  potionText:setHeight(18)
createBotSwitch("default", destLeft, "Mana Train ED/MS", storage.utilityToggles, "manaTrainMage")
UI.Separator(destLeft)
local utevoLux = UI.TextEdit(storage.utevoLuxText or "Utevo Lux", function(widget, text)
  storage.utevoLuxText = text
end,destLeft)
utevoLux:setImageColor("#828282") utevoLux:setMarginLeft(1) utevoLux:setMarginRight(2) utevoLux:setFont("verdana-9px")  utevoLux:setHeight(18)
createBotSwitch("default", destLeft, "Utevo Lux", storage.utilityToggles, "utevoLux")
macro(500, function()
  if storage.utilityToggles["utevoLux"] ~= true then return end
  say(storage.utevoLuxText)
  delay(60000)
end)


-- LADO DIREITO
local nextBpContainer = UI.ContainerEx(function(widget, items) storage.proximaBpID = items end, true, destRight) nextBpContainer:setHeight(46) nextBpContainer:setItems(storage.proximaBpID)
createBotSwitch("default", destRight, "Abrir Proxima BP", storage.utilityToggles, "proximaBP")
local transformCoin = UI.ContainerEx(function(widget, items) storage.transformarCoin = items end, true, destRight) transformCoin:setHeight(46) transformCoin:setItems(storage.transformarCoin) transformCoin:setMarginTop(4)
createBotSwitch("default", destRight, "Transformar Coin", storage.utilityToggles, "transformCoin")
UI.Separator(destRight)
local doorContainer = UI.ContainerEx(function(widget, items) storage.doorIds = items doorId = properTable(storage.doorIds) end, true, destRight) doorContainer:setHeight(46) doorContainer:setItems(storage.doorIds) doorId = properTable(storage.doorIds)
createBotSwitch("default", destRight, "Abrir Portas", storage.utilityToggles, "abrirPortas")
UI.Separator(destRight)
manaText = addTextEdit("Mana Train", storage.manaTrainText, function(widget, text) storage.manaTrainText = text end, destRight) manaText:setImageColor("#828282") manaText:setMarginLeft(1) manaText:setMarginRight(2) manaText:setFont("verdana-9px")  manaText:setHeight(18)
createBotSwitch("default", destRight, "Mana Train", storage.utilityToggles, "manaTrain")
UI.Separator(destRight)
local msgTradeText = UI.TextEdit(storage.autoTradeMessage or "INSET MSG TRADE!", function(widget, text)
  storage.autoTradeMessage = text
end,destRight)
msgTradeText:setImageColor("#828282") msgTradeText:setMarginLeft(1) msgTradeText:setMarginRight(2) msgTradeText:setFont("verdana-9px")  msgTradeText:setHeight(18)
createBotSwitch("default", destRight, "Message Trade", storage.utilityToggles, "msgTrade")

macro(1000, function()
  if storage.utilityToggles["msgTrade"] ~= true then return end
  local trade = getChannelId("advertising")
  if not trade then
    trade = getChannelId("trade")
  end
  if trade and storage.autoTradeMessage:len() > 0 then    
    sayChannel(trade, storage.autoTradeMessage)
    delay(20000)
  end
end)



local function getNextBpIdList()
  local ids = {}
  for _, entry in pairs(storage.proximaBpID or {}) do
    table.insert(ids, entry.id or entry)
  end
  return ids
end

macro(500, function()
  if storage.utilityToggles["dancingMode"] ~= true then return end
  turn(math.random(0,3))
end)

macro(500, function()
  posToHold = posToHold or pos()
  schedule(50, function() if storage.utilityToggles["holdPosition"] ~= true then posToHold = nil end end) 
  if table.equals(posToHold, pos()) then return end
  autoWalk(posToHold, 127, {ignoreNonPathable=true, precision=2, ignoreStairs=true})
end)

local function trim(s)
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function parseTwoSpells(text)
  text = tostring(text or "")

  local a, b = text:match("^%s*([^,]+)%s*,%s*([^,]+)%s*$")
  if a then
    a = trim(a)
    b = trim(b or "")
    return a, b
  end

  local single = trim(text)
  return single, ""
end

local mtStep = 1
macro(1000, function()
  if storage.utilityToggles["manaTrain"] ~= true then return end

  local s1, s2 = parseTwoSpells(storage.manaTrainText)
  if s1 == "" then return end

  if s2 == "" then
    say(s1)
    delay(500)
    return
  end

  if mtStep == 1 then
    say(s1)
    mtStep = 2
    delay(500)
  else
    say(s2)
    mtStep = 1
    delay(500)
  end
end)

local manaPercent = 30
local heal1 = "Utana Vid"
local heal2 = "Exura vita"
local voc = player:getVocation()

local train = macro(200, function()
  if storage.utilityToggles["manaTrainMage"] ~= true then return end
  for i, npc in ipairs(getSpectators()) do
    if npc:isNpc() and (getDistanceBetween(pos(), npc:getPosition()) <= 5) then
      say(heal1)
      say(heal2)
    end
    if manapercent() <= manaPercent then
      usewith(storage.mi, player) 
    end
  end
end)

onTextMessage(function(mode, text)
  if train.isOff() then return end
  local mp = 'Using one of ([0-9]*)'
  local re1 = regexMatch(text, mp)
  local tmp = ""
  if #re1 ~= 0 then
    tmp = tonumber(re1[1][2])
    for i, npc2 in ipairs(getSpectators()) do
      if npc2:isNpc() and (getDistanceBetween(pos(), npc2:getPosition()) <= 3) then
        if tmp <= 50 then
          NPC.say("hi")
          schedule(1000, function() NPC.say("trade") end)
          schedule(1500, function() NPC.buy(storage.mi, 250) end)
          schedule(2000, function() NPC.say("bye") end)
          schedule(2500, function() NPC.closeTrade() end)
        end
      end
    end
  end
end)

macro(1000, function()
  if storage.utilityToggles["proximaBP"] ~= true then return end
  local containerIds = getNextBpIdList()
  if #containerIds == 0 then return end
  for _, container in pairs(getContainers()) do
    local containerItem = container:getContainerItem()
    if containerItem and table.contains(containerIds, containerItem:getId()) then
      if container:getCapacity() == #container:getItems() then
        for _, item in ipairs(container:getItems()) do
          if table.contains(containerIds, item:getId()) then
            g_game.open(item, container)
            delay(200)
            break
          end
        end
      end
    end
  end
end)

macro(500, function()
  if storage.utilityToggles["transformCoin"] ~= true then return end
  if not storage.transformarCoin[1] then return end
  local containers = g_game.getContainers()
  for index, container in pairs(containers) do
    if not container.lootContainer then
      for i, item in ipairs(container:getItems()) do
        if item:getCount() == 100 then
          for m, moneyId in ipairs(storage.transformarCoin) do
            if item:getId() == moneyId.id then
              return g_game.use(item)            
            end
          end
        end
      end
    end
  end
end)

local targetID = nil

onKeyPress(function(keys)
  if keys == "Escape" and targetID then
    targetID = nil
  end
end)

macro(100, function()
  if storage.utilityToggles["holdTarget"] ~= true then return end

  if target() and target():getPosition().z == posz() and not target():isNpc() then
    targetID = target():getId()
  elseif not target() then
    if not targetID then return end

    for i, spec in ipairs(getSpectators()) do
      local sameFloor = spec:getPosition().z == posz()
      local oldTarget = spec:getId() == targetID

      if sameFloor and oldTarget then
        attack(spec)
      end
    end
  end
end)

local vocationsMap = {
  [1] = "Knight", [2] = "Paladin", [3] = "Sorcerer", [4] = "Druid",
  [5] = "Monk",
  [6] = "Elite Knight", [7] = "Royal Paladin", [8] = "Master Sorcerer", [9] = "Elder Druid",
  [10] = "Exalted Monk"
}

local function getVocationType(playerObj)
  if not playerObj then return "knight" end
  local vocId = playerObj:getVocation()
  local vocName = vocationsMap[vocId] or "Unknown"

  if vocName == "Knight" or vocName == "Elite Knight" then
    return "knight"
  elseif vocName == "Paladin" or vocName == "Royal Paladin" then
    return "paladin"
  elseif vocName == "Sorcerer" or vocName == "Master Sorcerer" then
    return "sorcerer"
  elseif vocName == "Druid" or vocName == "Elder Druid" then
    return "druid"
  elseif vocName == "Monk" or vocName == "Exalted Monk" then
    return "monk"
  end

  return "knight"
end

local familiarSpellByVoc = {
  knight   = "utevo gran res eq",
  paladin  = "utevo gran res sac",
  sorcerer = "utevo gran res ven",
  druid    = " utevo gran res dru",
  monk     = "utevo gran res tio"
}

local lastSummon = 0
local summonCooldown = 1 * 60 * 1000

macro(500, function()
  if storage.utilityToggles["summonFamiliar"] ~= true then return end
  if isInPz() then return end

  local playerObj = g_game.getLocalPlayer()
  if not playerObj then return end

  local vocType = getVocationType(playerObj)
  local spell = familiarSpellByVoc[vocType]
  if not spell or spell == "" then return end

  say(spell)
  delay(10000)
end)

macro(500, function()
  if storage.utilityToggles["autoMont"] ~= true then return end
  if isInPz() then return end
  local pOutifit = player:getOutfit()
  local isMounted = pOutifit.mount ~= nil and pOutifit.mount > 0
  if not isMounted then
    player:mount()
  end
end)

local moveTime = 1000
local moveDist = 1
local useTime = 1000
local useDistance = 1
local waitTime = 1000

macro(200, function()
  if storage.utilityToggles["abrirPortas"] ~= true then return end
  for i, tile in ipairs(g_map.getTiles(posz())) do
    local item = tile:getTopUseThing()
    if item and table.find(doorId, item:getId()) then
      local tPos = tile:getPosition()
      local distance = getDistanceBetween(pos(), tPos)
      if (distance <= useDistance) then
        use(item)
        return delay(useTime)
      end

      if (distance <= moveDist and distance > useDistance) then
        if findPath(pos(), tPos, moveDist, { ignoreNonPathable = true, precision = 1 }) then
          autoWalk(tPos, moveTime, { ignoreNonPathable = true, precision = 1 })
          return delay(waitTime)
        end
      end
    end
  end
end, destRight)

local secondsToIdle = 5
local activeFPS = 60
local afkFPS = 5

function botPrintMessage(message)
  modules.game_textmessage.displayGameMessage(message)
end

local function isSameMousePos(p1,p2)
  return p1.x == p2.x and p1.y == p2.y
end

local function setAfk()
  modules.client_options.setOption("backgroundFrameRate", afkFPS)
  modules.game_interface.gameMapPanel:hide()
end

local function setActive()
  modules.client_options.setOption("backgroundFrameRate", activeFPS)
  modules.game_interface.gameMapPanel:show()
end

local lastMousePos = nil
local finalMousePos = nil
local idleCount = 0
local maxIdle = secondsToIdle * 4
macro(250, function()
  if storage.utilityToggles["sleepMode"] ~= true then return end
  local currentMousePos = g_window.getMousePosition()

  if finalMousePos then
    if isSameMousePos(finalMousePos, currentMousePos) then return end
    setActive()
    finalMousePos = nil
  end

  if lastMousePos and isSameMousePos(lastMousePos, currentMousePos) then
    idleCount = idleCount + 1
  else
    lastMousePos = currentMousePos
    idleCount = 0
  end

  if idleCount == maxIdle then
    setAfk()
    finalMousePos = currentMousePos
    idleCount = 0
  end
end)

onAddThing(function(tile, thing)
  if storage.utilityToggles["esconderSprites"] ~= true then return end
  if thing:isEffect() then
    thing:hide()
  end
end)

onStaticText(function(thing, text)
  if storage.utilityToggles["esconderTextos"] ~= true then return end
  if not text:find('says:') then
    g_map.cleanTexts()
  end
end)

onTextMessage(function(mode, text)
  if storage.utilityToggles["esconderTextos"] ~= true then return end
  modules.game_textmessage.clearMessages()
  g_map.cleanTexts()
end)

BugMap = {}

local consoleTextEdit = g_ui.getRootWidget():recursiveGetChildById('consoleTextEdit')

local availableKeys = {
  ['W'] = { 0, -3 },
  ['S'] = { 0, 3 },
  ['A'] = { -3, 0 },
  ['D'] = { 3, 0 },
  ['C'] = { 3, 3 },
  ['Z'] = { -3, 3 },
  ['Q'] = { -3, -3 },
  ['E'] = { 3, -3 }
}

local function safeIsMobile()
  if g_app and type(g_app.isMobile) == "function" then
    local ok, res = pcall(function() return g_app:isMobile() end)
    if ok then return res == true end
  end
  return false
end

local isMobile = safeIsMobile()

macro(100, function()
  if storage.utilityToggles["superDash"] ~= true or isMobile then return end
  if modules.game_console:isChatEnabled() then return end
  local playerPos = pos()
  local tile
  for key, value in pairs(availableKeys) do
    if (modules.corelib.g_keyboard.isKeyPressed(key)) then
      playerPos.x = playerPos.x + value[1]
      playerPos.y = playerPos.y + value[2]
      tile = g_map.getTile(playerPos)
      break
    end
  end
  if (not tile) then return end
  g_game.use(tile:getTopUseThing())

  local item = tile:getTopUseThing()
  if item then
    g_game.useWith(item, g_game.getLocalPlayer())
    g_game.use(item)
  end
end)

local function checkPos(x, y)
  local xyz = g_game.getLocalPlayer():getPosition()
  xyz.x = xyz.x + x
  xyz.y = xyz.y + y
  local tile = g_map.getTile(xyz)
  if tile then
    return g_game.use(tile:getTopUseThing())
  else
    return false
  end
end

macro(200, function()
  if modules.corelib.g_keyboard.isKeyPressed('W') then
    turn(0)
  elseif modules.corelib.g_keyboard.isKeyPressed('S') then
    turn(2)
  elseif modules.corelib.g_keyboard.isKeyPressed('A') then
    turn(3)
  elseif modules.corelib.g_keyboard.isKeyPressed('D') then
    turn(1)
  end
end)

local cursorWidget = g_ui.getRootWidget():recursiveGetChildById('pointer')
if not cursorWidget then
  return
end

local initialPos = {
  x = cursorWidget:getPosition().x / cursorWidget:getWidth(),
  y = cursorWidget:getPosition().y / cursorWidget:getHeight()
}

local availableKeys2 = {
  Up    = { 0, -6 },
  Down  = { 0,  6 },
  Left  = { -7, 0 },
  Right = { 7,  0 }
}

macro(100, function()
  if storage.utilityToggles["superDash"] ~= true then return end
  local myPos = pos()
  if not myPos then return end

  local keypadPos = {
    x = cursorWidget:getPosition().x / cursorWidget:getWidth(),
    y = cursorWidget:getPosition().y / cursorWidget:getHeight()
  }

  local diffPos = {
    x = initialPos.x - keypadPos.x,
    y = initialPos.y - keypadPos.y
  }

  if (diffPos.y < 0.46 and diffPos.y > -0.46) then
    if diffPos.x > 0 then
      myPos.x = myPos.x + availableKeys2.Left[1]
    elseif diffPos.x < 0 then
      myPos.x = myPos.x + availableKeys2.Right[1]
    else
      return
    end
  elseif (diffPos.x < 0.46 and diffPos.x > -0.46) then
    if diffPos.y > 0 then
      myPos.y = myPos.y + availableKeys2.Up[2]
    elseif diffPos.y < 0 then
      myPos.y = myPos.y + availableKeys2.Down[2]
    else
      return
    end
  else
    return
  end

  local tile = g_map.getTile(myPos)
  if not tile then return end

  local top = tile:getTopUseThing()
  if not top then return end

  g_game.use(top)
end)
