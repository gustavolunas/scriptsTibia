local PANEL_NAME = "lnsFollow"
local FOLLOW_SWITCH_ID = "followButton"

local category = "lns"
local MW_RUNE_ID = 3180
local WG_RUNE_ID = 3156
local SD_RUNE_ID = 3155
local ATTACKBOT_SWITCH_ID = "comboButton"
local MINI_WINDOW_NAME = "ingameScriptWindow"
local HOLD_STORAGE_KEY = "lnsLeaderHoldMwWg"
local COMBO_STORAGE_KEY = "lnsLeaderCombo"
local leaderCommandDelay = 200
local lastLeaderCommand = 0

if modules.game_interface and modules.game_interface.removeMenuHook then
  modules.game_interface.removeMenuHook(category)
end

storage[HOLD_STORAGE_KEY] = storage[HOLD_STORAGE_KEY] or {
  enabled = { mw = false, wg = false },
  marks = {}
}

storage[COMBO_STORAGE_KEY] = storage[COMBO_STORAGE_KEY] or {
  pauseUntil = 0,
  token = 0,
  active = false,
  kind = "",
  targetId = 0,
  spell = ""
}

local function normalizeText(s)
  s = tostring(s or "")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

local function lowerText(s)
  return normalizeText(s):lower()
end

local function getPanelDb()
  storage[PANEL_NAME] = storage[PANEL_NAME] or {}
  storage[PANEL_NAME].texts = storage[PANEL_NAME].texts or {}
  storage[PANEL_NAME].switches = storage[PANEL_NAME].switches or {}
  return storage[PANEL_NAME]
end

local function getLeaderName()
  local db = getPanelDb()
  return lowerText(db.texts.navLeader)
end

local function findWidgetById(id)
  local root = g_ui and g_ui.getRootWidget and g_ui.getRootWidget()
  if not root or not root.recursiveGetChildById then return nil end
  return root:recursiveGetChildById(id)
end

local function getHookPos(pos, lookThing, useThing, creatureThing)
  if pos and pos.x and pos.y and pos.z then
    return pos
  end

  for _, thing in ipairs({lookThing, useThing, creatureThing}) do
    if thing and thing.getPosition then
      local p = thing:getPosition()
      if p and p.x and p.y and p.z then
        return p
      end
    end
  end

  return nil
end

local function parseCommandPos(text, prefix)
  local pattern = "^" .. prefix .. "%s*:%s*(%-?%d+)%s*,%s*(%-?%d+)%s*,%s*(%-?%d+)%s*$"
  local x, y, z = normalizeText(text):match(pattern)
  if not x then return nil end
  return {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
end

local function sayHookPos(prefix, pos, lookThing, useThing, creatureThing)
  local p = getHookPos(pos, lookThing, useThing, creatureThing)
  if not p then return end
  sayChannel(1, string.format("%s: %d,%d,%d", prefix, p.x, p.y, p.z))
end

local function useRuneOnPos(itemId, pos)
  if not itemId or not pos then return false end
  if not findItem(itemId) then return false end

  local tile = g_map.getTile(pos)
  if not tile then return false end

  local topThing = tile:getTopUseThing()
  if not topThing then return false end

  return useWith(itemId, topThing) and true or false
end

local function syncSwitchVisual(panelGlobal, switchId, state)
  if panelGlobal and panelGlobal.title and panelGlobal.title.setOn then
    panelGlobal.title:setOn(state)
    return
  end

  local panel = findWidgetById(switchId)
  if not panel then return end

  local title = panel.getChildById and panel:getChildById("title")
  if not title then return end

  title:setOn(state)
end

local function setAttackBotState(state)
  state = state == true
  storage[ATTACKBOT_SWITCH_ID] = storage[ATTACKBOT_SWITCH_ID] or {}
  storage[ATTACKBOT_SWITCH_ID].enabled = state

  if comboButton and comboButton.title and comboButton.title.setOn then
    comboButton.title:setOn(state)
  else
    syncSwitchVisual(comboButton, ATTACKBOT_SWITCH_ID, state)
  end
end

local function setFollowState(state)
  state = state == true
  storage[FOLLOW_SWITCH_ID] = storage[FOLLOW_SWITCH_ID] or {}
  storage[FOLLOW_SWITCH_ID].enabled = state

  if not state then
    g_game.cancelFollow()
  end

  if followButton and followButton.title and followButton.title.setOn then
    followButton.title:setOn(state)
  else
    syncSwitchVisual(followButton, FOLLOW_SWITCH_ID, state)
  end
end

local function getHoldDb()
  storage[HOLD_STORAGE_KEY] = storage[HOLD_STORAGE_KEY] or {}
  storage[HOLD_STORAGE_KEY].enabled = storage[HOLD_STORAGE_KEY].enabled or { mw = false, wg = false }
  storage[HOLD_STORAGE_KEY].marks = storage[HOLD_STORAGE_KEY].marks or {}
  return storage[HOLD_STORAGE_KEY]
end

local function holdPosKey(pos)
  return string.format("%d,%d,%d", pos.x, pos.y, pos.z)
end

local function splitHoldPosKey(key)
  local x, y, z = tostring(key):match("^(%-?%d+),(%-?%d+),(%-?%d+)$")
  if not x then return nil end
  return {x = tonumber(x), y = tonumber(y), z = tonumber(z)}
end

local function isHoldMwEnabled()
  return getHoldDb().enabled.mw == true
end

local function isHoldWgEnabled()
  return getHoldDb().enabled.wg == true
end

local function addHoldMark(pos, text)
  if not pos or not text then return end
  getHoldDb().marks[holdPosKey(pos)] = text
end

local function clearHoldMarksByText(text)
  local db = getHoldDb()
  for key, value in pairs(db.marks) do
    if value == text then
      local pos = splitHoldPosKey(key)
      local tile = pos and g_map.getTile(pos)
      if tile and tile:getText() == text then
        tile:setText("")
      end
      db.marks[key] = nil
    end
  end
end

local function setHoldMwState(state)
  state = state == true
  local db = getHoldDb()
  db.enabled.mw = state
  if not state then
    clearHoldMarksByText("HOLD MW")
  end
end

local function setHoldWgState(state)
  state = state == true
  local db = getHoldDb()
  db.enabled.wg = state
  if not state then
    clearHoldMarksByText("HOLD WG")
  end
end

local function tileHasHoldField(tile)
  if not tile then return false end
  local items = tile:getItems()
  if not items then return false end

  for i = 1, #items do
    local item = items[i]
    if item and item.getId then
      local id = item:getId()
      if id == 2129 or id == 2130 then
        return true
      end
    end
  end

  return false
end

local function canUseHoldOnTile(tile)
  if not tile then return false end
  if isInPz() then return false end
  if not tile:canShoot() then return false end
  if not tile:isWalkable() then return false end

  local top = tile:getTopUseThing()
  if not top then return false end
  if top:getId() == 2130 then return false end

  local ppos = player and player:getPosition()
  local tpos = tile:getPosition()
  if not ppos or not tpos then return false end
  if ppos.z ~= tpos.z then return false end
  if math.abs(ppos.x - tpos.x) >= 8 or math.abs(ppos.y - tpos.y) >= 6 then return false end

  return true
end

local HOLD_CAST_COOLDOWN_MS = 200
local HOLD_TILE_COOLDOWN_MS = 200
local HOLD_FAIL_COOLDOWN_MS = 100
local HOLD_REMOVE_DEBOUNCE_MS = 170
local lastHoldCastAt = 0
local lastHoldCastByTile = {}

local function tryUseHold(tile, holdText)
  if not tile or not holdText then return false end

  local runeId = nil
  if holdText == "HOLD MW" then
    if not isHoldMwEnabled() then return false end
    runeId = MW_RUNE_ID
  elseif holdText == "HOLD WG" then
    if not isHoldWgEnabled() then return false end
    runeId = WG_RUNE_ID
  else
    return false
  end

  if tileHasHoldField(tile) then return false end
  if not canUseHoldOnTile(tile) then return false end
  if now - lastHoldCastAt < HOLD_CAST_COOLDOWN_MS then return false end

  local pos = tile:getPosition()
  local key = holdPosKey(pos)
  local lastTileCast = lastHoldCastByTile[key] or 0
  if lastTileCast > now then return false end
  if now - lastTileCast < HOLD_TILE_COOLDOWN_MS then return false end

  local used = useWith(runeId, tile:getTopUseThing())
  lastHoldCastAt = now

  if used then
    lastHoldCastByTile[key] = now
    return true
  end

  lastHoldCastByTile[key] = now + HOLD_FAIL_COOLDOWN_MS
  return false
end

local function getComboDb()
  storage[COMBO_STORAGE_KEY] = storage[COMBO_STORAGE_KEY] or {
    pauseUntil = 0,
    token = 0,
    active = false,
    kind = "",
    targetId = 0,
    spell = "",
    castTries = 0,
    startedAt = 0
  }
  return storage[COMBO_STORAGE_KEY]
end

local function clearComboState(token)
  local db = getComboDb()
  if token and db.token ~= token then return end
  db.active = false
  db.kind = ""
  db.targetId = 0
  db.spell = ""
  db.castTries = 0
  db.startedAt = 0
end

local function startComboCommon(kind)
  local db = getComboDb()
  if (tonumber(db.pauseUntil) or 0) > now then
    return nil
  end

  db.pauseUntil = now + 3600
  db.token = (tonumber(db.token) or 0) + 1
  db.active = true
  db.kind = kind or ""
  db.targetId = 0
  db.spell = ""
  db.castTries = 0
  db.startedAt = now
  return db.token
end

local function triggerComboUE()
  local panelDb = getPanelDb()
  local ueSpell = normalizeText(panelDb.texts.UESpell or "")
  local ueEnabled = panelDb.switches.useUEcheck == true

  if not ueEnabled then
    return false
  end

  if ueSpell == "" then
    return false
  end

  local token = startComboCommon("ue")
  if not token then
    return false
  end

  local db = getComboDb()
  db.spell = ueSpell
  db.castTries = 0
  db.startedAt = now

  local firstDelay = 2450
  local retryDelay = 160
  local maxTries = 4
  local hardTimeout = now + 3400

  local function tryCastUE()
    local comboDb = getComboDb()
    if comboDb.token ~= token then return end
    if comboDb.kind ~= "ue" then return end
    if now > hardTimeout then
      clearComboState(token)
      return
    end

    local currentPanelDb = getPanelDb()
    local currentEnabled = currentPanelDb.switches.useUEcheck == true
    local spellToCast = normalizeText(comboDb.spell or "")

    if not currentEnabled then
      clearComboState(token)
      return
    end

    if spellToCast == "" then
      clearComboState(token)
      return
    end

    comboDb.castTries = (tonumber(comboDb.castTries) or 0) + 1
    say(spellToCast)

    if comboDb.castTries >= maxTries then
      clearComboState(token)
      return
    end

    schedule(retryDelay, function()
      local checkDb = getComboDb()
      if checkDb.token ~= token then return end
      if checkDb.kind ~= "ue" then return end
      tryCastUE()
    end)
  end

  schedule(firstDelay, function()
    local comboDb = getComboDb()
    if comboDb.token ~= token then return end
    if comboDb.kind ~= "ue" then return end
    tryCastUE()
  end)

  schedule(3600, function()
    clearComboState(token)
  end)

  return true
end

local function triggerComboSD()
  local currentTarget = g_game.getAttackingCreature()
  if not currentTarget then
    return false
  end

  if not findItem(SD_RUNE_ID) then
    return false
  end

  local token = startComboCommon("sd")
  if not token then
    return false
  end

  local db = getComboDb()
  db.targetId = currentTarget:getId()
  db.castTries = 0
  db.startedAt = now

  local firstDelay = 2450
  local retryDelay = 140
  local maxTries = 4
  local hardTimeout = now + 3400

  local function tryCastSD()
    local comboDb = getComboDb()
    if comboDb.token ~= token then return end
    if comboDb.kind ~= "sd" then return end
    if now > hardTimeout then
      clearComboState(token)
      return
    end

    if not findItem(SD_RUNE_ID) then
      clearComboState(token)
      return
    end

    local target = nil

    if comboDb.targetId and comboDb.targetId > 0 then
      target = getCreatureById(comboDb.targetId)
    end

    if not target then
      target = g_game.getAttackingCreature()
    end

    if not target then
      clearComboState(token)
      return
    end

    comboDb.castTries = (tonumber(comboDb.castTries) or 0) + 1
    useWith(SD_RUNE_ID, target)

    if comboDb.castTries >= maxTries then
      clearComboState(token)
      return
    end

    schedule(retryDelay, function()
      local checkDb = getComboDb()
      if checkDb.token ~= token then return end
      if checkDb.kind ~= "sd" then return end
      tryCastSD()
    end)
  end

  schedule(firstDelay, function()
    local comboDb = getComboDb()
    if comboDb.token ~= token then return end
    if comboDb.kind ~= "sd" then return end
    tryCastSD()
  end)

  schedule(3600, function()
    clearComboState(token)
  end)

  return true
end

local function executeLeaderCommand(text)
  local msg = normalizeText(text)
  local msgLower = msg:lower()

  if msgLower == "set: attackbot [on]" then
    setAttackBotState(true)
    return true
  end

  if msgLower == "set: attackbot [off]" then
    setAttackBotState(false)
    return true
  end

  if msgLower == "set: follow [on]" then
    setFollowState(true)
    return true
  end

  if msgLower == "set: follow [off]" then
    setFollowState(false)
    return true
  end

  if msgLower == "set: targetbot [on]" then
    if TargetBot and TargetBot.setOn then
      TargetBot.setOn()
    end
    return true
  end

  if msgLower == "set: targetbot [off]" then
    if TargetBot and TargetBot.setOff then
      TargetBot.setOff()
    end
    return true
  end

  if msgLower == "set: cavebot [on]" then
    if CaveBot and CaveBot.setOn then
      CaveBot.setOn()
    end
    return true
  end

  if msgLower == "set: cavebot [off]" then
    if CaveBot and CaveBot.setOff then
      CaveBot.setOff()
    end
    return true
  end

  if msgLower == "set: combo ue [on]" then
    triggerComboUE()
    return true
  end

  if msgLower == "set: combo sd [on]" then
    triggerComboSD()
    return true
  end

  if msgLower == "set: stop attack" then
    g_game.cancelAttack()
    oldTarget = nil
    targetID = nil
    return true
  end

  if msgLower == "set: hold mw [on]" or msgLower == "hold mw on" then
    setHoldMwState(true)
    return true
  end

  if msgLower == "set: hold mw [off]" or msgLower == "hold mw off" then
    setHoldMwState(false)
    return true
  end

  if msgLower == "set: hold wg [on]" or msgLower == "hold wg on" then
    setHoldWgState(true)
    return true
  end

  if msgLower == "set: hold wg [off]" or msgLower == "hold wg off" then
    setHoldWgState(false)
    return true
  end

  local movePos = parseCommandPos(msg, "MOVE POS")
  if movePos then
    if movePos.z ~= posz() then return true end
    autoWalk(movePos, 100, {ignoreNonPathable=true, precision=1})
    return true
  end

  local mwPos = parseCommandPos(msg, "MW IN")
  if mwPos then
    useRuneOnPos(MW_RUNE_ID, mwPos)
    return true
  end

  local wgPos = parseCommandPos(msg, "WG IN")
  if wgPos then
    useRuneOnPos(WG_RUNE_ID, wgPos)
    return true
  end

  local travelCity = msg:match("Travel to:%s*(.+)")
  if travelCity then
    travelCity = normalizeText(travelCity)

    schedule(200, function()
      NPC.say("hi")
      schedule(200, function()
        NPC.say(travelCity)
        schedule(200, function()
          NPC.say("yes")
          schedule(200, function()
            NPC.say("yes")
          end)
        end)
      end)
    end)

    return true
  end

  return false
end

local hooks = {
  {label = "LNS | MC Use Here", prefix = "USE TO"},
  {label = "LNS | Move Pos", prefix = "MOVE POS"},
  {label = "LNS | MC Use MW", prefix = "MW IN"},
  {label = "LNS | MC Use WG", prefix = "WG IN"},
}

for i = 1, #hooks do
  local hook = hooks[i]
  modules.game_interface.addMenuHook(category, hook.label, function(pos, lookThing, useThing, creatureThing)
    sayHookPos(hook.prefix, pos, lookThing, useThing, creatureThing)
  end, function() return true end)
end

onTalk(function(name, level, mode, text, channelId, pos)
  if channelId ~= 1 then return end

  local leaderName = lowerText(getPanelDb().texts.navAttack or "")
  if leaderName == "" then return end
  if lowerText(name) ~= leaderName then return end

  if now < lastLeaderCommand then return end
  lastLeaderCommand = now + leaderCommandDelay

  executeLeaderCommand(text)
end)

onUseWith(function(pos, itemId, target)
  if not target or not target.getPosition then return end

  if itemId == MW_RUNE_ID then
    if not isHoldMwEnabled() then return end
    local tpos = target:getPosition()
    if not tpos then return end
    local tile = g_map.getTile(tpos)
    if not tile then return end
    tile:setText("HOLD MW")
    addHoldMark(tpos, "HOLD MW")
    return
  end

  if itemId == WG_RUNE_ID then
    if not isHoldWgEnabled() then return end
    local tpos = target:getPosition()
    if not tpos then return end
    local tile = g_map.getTile(tpos)
    if not tile then return end
    tile:setText("HOLD WG")
    addHoldMark(tpos, "HOLD WG")
    return
  end
end)

onRemoveThing(function(tile, thing)
  if not tile or not thing or not thing.getId then return end

  local id = thing:getId()
  if id ~= 2129 and id ~= 2130 then return end

  local txt = tile:getText()
  if txt ~= "HOLD MW" and txt ~= "HOLD WG" then return end

  local pos = tile:getPosition()
  if not pos then return end

  local key = holdPosKey(pos)
  local current = lastHoldCastByTile[key] or 0
  lastHoldCastByTile[key] = math.max(current, now + HOLD_REMOVE_DEBOUNCE_MS)
end)

macro(20, function()
  local db = getHoldDb()

  for key, holdText in pairs(db.marks) do
    local pos = splitHoldPosKey(key)
    if pos then
      local tile = g_map.getTile(pos)
      if tile then
        if tile:getText() ~= holdText then
          tile:setText(holdText)
        end
        if tryUseHold(tile, holdText) then
          return
        end
      end
    end
  end
end)

toolsScripts = setupUI([[
MiniWindow
  id: toolsScripts
  text: Leader Control
  height: 270
  width: 175
  icon: /images/topbuttons/combatcontrols
  icon-size: 15 15

  Panel
    id: panelScripts
    anchors.fill: parent
    margin-top: 20
    margin-left: 5
    margin-right: 5
    margin-bottom: 5
    layout:
      type: verticalBox
]], g_ui.getRootWidget())

g_ui.loadUIFromString([[
LeaderRow < Panel
  height: 22
  margin-top: 2

  HorizontalSeparator
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    anchors.left: parent.left

  Label
    id: label
    anchors.left: parent.left
    anchors.top: prev.top
    margin-top: 5
    width: 110
    color: white
    font: verdana-11px-rounded
    text: Command

  Button
    id: onBtn
    anchors.right: offBtn.left
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 1
    width: 40
    height: 18
    font: verdana-11px-rounded
    text: ON
    color: #98FB98

  Button
    id: offBtn
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 40
    height: 18
    font: verdana-11px-rounded
    text: OFF
    color: #CD5C5C
]])

storage[MINI_WINDOW_NAME] = storage[MINI_WINDOW_NAME] or {}
local saved = storage[MINI_WINDOW_NAME]

if saved.x and saved.y then
  toolsScripts:setX(saved.x)
  toolsScripts:setY(saved.y)
end

toolsScripts.onGeometryChange = function(widget, oldRect, newRect)
  if oldRect.width == 0 and oldRect.height == 0 then return end
  storage[MINI_WINDOW_NAME].x = widget:getX()
  storage[MINI_WINDOW_NAME].y = widget:getY()
end

local scrollBar = toolsScripts:getChildById("miniwindowScrollBar")
if scrollBar then scrollBar:hide() end

toolsScripts.closeButton.onClick = function()
  toolsScripts:hide()
end

toolsScripts.minimizeButton:hide()
toolsScripts.lockButton:hide()

local scriptsLeaderControl = toolsScripts.panelScripts

local controls = {
  {text = "AttackBot", on = "set: AttackBot [ON]", off = "set: AttackBot [OFF]"},
  {text = "Follow",    on = "set: Follow [ON]",    off = "set: Follow [OFF]"},
  {text = "TargetBot", on = "set: TargetBot [ON]", off = "set: TargetBot [OFF]"},
  {text = "CaveBot",   on = "set: CaveBot [ON]",   off = "set: CaveBot [OFF]"},
  {text = "Hold MW",   on = "set: Hold MW [ON]",   off = "set: Hold MW [OFF]"},
  {text = "Hold WG",   on = "set: Hold WG [ON]",   off = "set: Hold WG [OFF]"},
  {text = "No Escape", on = "set: No Escape [ON]", off = "set: No Escape [OFF]"},
}

for i = 1, #controls do
  local cfg = controls[i]
  local row = g_ui.createWidget("LeaderRow", scriptsLeaderControl)

  row.label:setText(cfg.text)

  row.onBtn.onClick = function()
    sayChannel(1, cfg.on)
  end

  row.offBtn.onClick = function()
    sayChannel(1, cfg.off)
  end
end

local comboCountdownWidget = nil
local comboCountdownRunning = false

local function getComboCountdownWidget()
  if comboCountdownWidget and not comboCountdownWidget:isDestroyed() then
    return comboCountdownWidget
  end

  local root = g_ui.getRootWidget()
  if not root then return nil end

  comboCountdownWidget = g_ui.loadUIFromString([[
Panel
  id: comboCountdownWidget
  size: 90 21
  anchors.centerIn: parent
  margin-top: -180
  margin-left: -17

  Label
    id: text
    anchors.fill: parent
    text-align: center
    font: verdana-11px-rounded
    color: #EEC900
    text: COMBO
]], root)

  return comboCountdownWidget
end

local function showComboCountdownText(text, color)
  local widget = getComboCountdownWidget()
  if not widget then return end

  local label = widget:getChildById("text")
  if not label then return end

  label:setText(text)
  if color then
    label:setColor(color)
  end

  widget:show()
  widget:raise()
end

local function startComboCountdown(kind)
  if comboCountdownRunning then return end
  comboCountdownRunning = true

  local prefix = kind == "sd" and "EXEC SD: " or "EXEC UE: "
  local lastText = kind == "sd" and "SD!!!" or "BUUUM!!!"
  local color = kind == "sd" and "#AAAAAA" or "#EEC900"
  local finalColor = kind == "sd" and "white" or "red"

  showComboCountdownText(prefix .. "3", color)

  schedule(1000, function()
    showComboCountdownText(prefix .. "2", color)

    schedule(1000, function()
      showComboCountdownText(prefix .. "1", color)

      schedule(300, function()
        showComboCountdownText(lastText, finalColor)

        schedule(1200, function()
          if comboCountdownWidget and not comboCountdownWidget:isDestroyed() then
            comboCountdownWidget:hide()
          end
          comboCountdownRunning = false
        end)
      end)
    end)
  end)
end

local butSD = g_ui.createWidget("Button", scriptsLeaderControl)
butSD:setText("Combo SD")
butSD:setMarginTop(3)
butSD.onClick = function()
  sayChannel(1, "set: Combo SD [ON]")
  startComboCountdown("sd")
end
butSD:setHeight(22)
butSD:setFont("verdana-11px-rounded")
butSD:setColor("#696969")

local butUE = g_ui.createWidget("Button", scriptsLeaderControl)
butUE:setText("Combo UE")
butUE.onClick = function()
  sayChannel(1, "set: Combo UE [ON]")
  startComboCountdown("ue")
end
butUE:setHeight(22)
butUE:setMarginTop(1)
butUE:setFont("verdana-11px-rounded")
butUE:setColor("#EEC900")

local butCancelAtk = g_ui.createWidget("Button", scriptsLeaderControl)
butCancelAtk:setText("Stop Attack")
butCancelAtk.onClick = function()
  sayChannel(1, "set: Stop Attack")
end
butCancelAtk:setHeight(22)
butCancelAtk:setMarginTop(1)
butCancelAtk:setFont("verdana-11px-rounded")
butCancelAtk:setColor("white")

local function sanitizeLeaderComboStorage()
  storage.lnsLeaderCombo = storage.lnsLeaderCombo or {}

  local old = storage.lnsLeaderCombo

  storage.lnsLeaderCombo = {
    active = false,
    kind = tostring(old.kind or ""),
    targetId = 0,
    spell = tostring(old.spell or ""),
    token = tonumber(old.token) or 0,
    pauseUntil = 0
  }
end

sanitizeLeaderComboStorage()
