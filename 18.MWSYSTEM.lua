setDefaultTab("War")
local switchMwSystem = "mwSystemButton"

if not storage[switchMwSystem] then
  storage[switchMwSystem] = { enabled = false }
end

storage[switchMwSystem].panel = storage[switchMwSystem].panel or {
  items = { mw = 3180, wg = 3156 },
  keys = {
    mwCursor = "",
    wgCursor = "",
    mwFrente = "",
    mwCosta  = "",
    holdMW   = "",
    holdWG   = "",
  },
  switches = {
    mwCursor = false,
    wgCursor = false,
    mwFrente = false,
    mwCosta  = false,
    hold     = false,
    icons = false,
    iconsJogarMW = false,
    iconsHoldMw = false,
    iconsCursor = false,
  }
}

local function nowMillis()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return math.floor(os.clock() * 1000)
end

local function posKey3(pos)
  return pos.x .. "," .. pos.y .. "," .. pos.z
end

local function samePos(a, b)
  return a and b and a.x == b.x and a.y == b.y and a.z == b.z
end

local function mwSystemEnabled()
  return storage[switchMwSystem].enabled == true
end

local function keyCodeToString(code)
  if type(code) == "string" then return code end
  if g_keyboard and g_keyboard.getKeyName then
    local name = g_keyboard.getKeyName(code)
    if name and name ~= "" then return name end
  end
  return tostring(code)
end

-- drag modifier (CTRL on PC / F2 on mobile, as you had)
local function isMoveKeyPressed()
  if g_app and type(g_app.isMobile) == "function" and g_app:isMobile() then
    return g_keyboard and g_keyboard.isKeyPressed and g_keyboard.isKeyPressed("F2")
  end
  return g_keyboard and g_keyboard.isCtrlPressed and g_keyboard.isCtrlPressed()
end

-- =========================================================
-- TOP BUTTON (MW System + Config)
-- =========================================================
mwSystemButton = setupUI([[
Panel
  height: 18

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: MW/WG SYSTEM
    font: verdana-9px
    color: white
    image-source: /images/ui/button_rounded
    $on:
      color: #32CD32
      image-color: #3CB371
    $!on:
      image-color: gray
      color: white

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: CONFIG
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green
]])

mwSystemButton:setId(switchMwSystem)
mwSystemButton.title:setOn(storage[switchMwSystem].enabled)

mwSystemButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchMwSystem].enabled = newState

  if not newState then
    mwSystemOnDisableCleanup()
  end
end

-- =========================================================
-- MAIN CONFIG WINDOW
-- =========================================================
mwSystemInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 380 400
  anchors.centerIn: parent
  margin-top: -60
  opacity: 1.00

  Panel
    id: background
    anchors.fill: parent
    background-color: #0b0b0b
    opacity: 0.88

  Panel
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f

  Label
    id: titleLabel
    anchors.centerIn: topBar
    text: LNS Custom | MW/WG System
    text-auto-resize: true
    color: orange
    font: verdana-11px-rounded

  UIButton
    id: closePanel
    anchors.right: topBar.right
    anchors.verticalCenter: topBar.verticalCenter
    size: 20 20
    margin-right: 8
    text: X
    background-color: orange
    color: white
    opacity: 1.00
    $hover:
      color: black
      opacity: 0.85

  Panel
    id: cardsRow
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 12
    margin-left: 10
    margin-right: 10
    height: 132
    background-color: alpha

  Panel
    id: cardMW
    anchors.top: closePanel.bottom
    anchors.left: parent.left
    width: 170
    height: 132
    background-color: #1b1b1b
    opacity: 0.95
    margin-top: 10
    margin-left: 10
    border: 1 #3b2a10

  Label
    id: CursosMW
    anchors.top: cardMW.top
    anchors.left: cardMW.left
    anchors.right: cardMW.right
    margin-top: 8
    margin-left: 10
    text: ID RUNA MAGIC WALL
    font: verdana-9px
    color: #d7c08a

  BotItem
    id: idMW
    anchors.left: CursosMW.left
    anchors.top: CursosMW.bottom
    margin-top: 10
    size: 40 40
    image-source: /images/ui/item-blessed

  Label
    id: mwIdValue
    anchors.left: idMW.right
    anchors.verticalCenter: idMW.verticalCenter
    margin-left: 10
    text: 3180
    text-auto-resize: true
    font: verdana-11px-rounded
    color: #e6d2a6

  Label
    id: mwHotLabel
    anchors.left: CursosMW.left
    anchors.top: idMW.bottom
    margin-top: 10
    text: HOTKEY MW:
    font: verdana-9px
    color: #b9b9b9

  TextEdit
    id: keyMwCursor
    anchors.right: cardMW.right
    anchors.verticalCenter: mwHotLabel.verticalCenter
    margin-right: 10
    width: 58
    height: 20
    font: verdana-9px
    text-align: center
    placeholder: F1
    image-color: #2f2f2f
    color: white

  BotSwitch
    id: AtivadorMWCursor
    anchors.left: CursosMW.left
    anchors.right: cardMW.right
    anchors.bottom: cardMW.bottom
    margin-left: 0
    margin-right: 10
    margin-bottom: 10
    height: 22
    text: UTILIZAR CURSOR MW
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #3a1010
    $on:
      color: #ffd37a
      image-color: green
      opacity: 1.00
    $!on:
      color: #b9b9b9
      image-color: #2a2a2a
      opacity: 0.95

  Panel
    id: cardWG
    anchors.top: closePanel.bottom
    anchors.right: parent.right
    width: 170
    height: 132
    margin-top: 10
    margin-right: 10
    background-color: #1b1b1b
    opacity: 0.95
    border: 1 #2a3b62

  Label
    id: CursosWG
    anchors.top: cardWG.top
    anchors.left: cardWG.left
    anchors.right: cardWG.right
    margin-top: 8
    margin-left: 10
    text: ID WILD GROWTH
    font: verdana-9px
    color: #d7c08a

  BotItem
    id: idWG
    anchors.left: CursosWG.left
    anchors.top: CursosWG.bottom
    margin-top: 10
    size: 40 40
    image-source: /images/ui/item-blessed

  Label
    id: wgIdValue
    anchors.left: idWG.right
    anchors.verticalCenter: idWG.verticalCenter
    margin-left: 10
    text-auto-resize: true
    text: 3156
    font: verdana-11px-rounded
    color: #e6d2a6

  Label
    id: wgHotLabel
    anchors.left: CursosWG.left
    anchors.top: idWG.bottom
    margin-top: 10
    text: HOTKEY WG:
    font: verdana-9px
    color: #b9b9b9

  TextEdit
    id: keyWGCursor
    anchors.right: cardWG.right
    anchors.verticalCenter: wgHotLabel.verticalCenter
    margin-right: 10
    width: 58
    height: 20
    font: verdana-9px
    text-align: center
    placeholder: F2
    image-color: #2f2f2f
    color: white

  BotSwitch
    id: AtivadorWGCursor
    anchors.left: CursosWG.left
    anchors.right: cardWG.right
    anchors.bottom: cardWG.bottom
    margin-left: 0
    margin-right: 10
    margin-bottom: 10
    height: 22
    text: UTILIZAR CURSOR WG
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #3a1010
    $on:
      color: #ffd37a
      image-color: green
      opacity: 1.00
    $!on:
      color: #b9b9b9
      image-color: #2a2a2a
      opacity: 0.95

  Panel
    id: actions
    anchors.top: cardsRow.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 10
    margin-left: 10
    margin-right: 10
    margin-top: 30
    background-color: #141414
    opacity: 0.92
    border: 1 #3b2a10

  Panel
    id: rowFront
    anchors.top: actions.top
    anchors.left: actions.left
    anchors.right: actions.right
    height: 30
    margin: 0
    background-color: alpha

  BotSwitch
    id: AtivadorMWFrente
    anchors.left: rowFront.left
    anchors.verticalCenter: rowFront.verticalCenter
    margin-left: 5
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblFrontText
    anchors.left: AtivadorMWFrente.right
    anchors.verticalCenter: AtivadorMWFrente.verticalCenter
    margin-left: 10
    text: JOGAR MW NA FRENTE DO ALVO
    font: verdana-9px
    color: #d7c08a

  TextEdit
    id: keyMwFrente
    anchors.right: rowFront.right
    anchors.verticalCenter: rowFront.verticalCenter
    width: 62
    height: 22
    margin-right: 6
    font: verdana-9px
    text-align: center
    placeholder: F3
    image-color: #3a1010
    color: white

  Panel
    id: rowBack
    anchors.top: rowFront.bottom
    anchors.left: actions.left
    anchors.right: actions.right
    height: 30
    margin-left:5
    margin-top: 0
    background-color: alpha

  BotSwitch
    id: AtivadorMWCosta
    anchors.left: rowBack.left
    anchors.verticalCenter: rowBack.verticalCenter
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblBackText
    anchors.left: AtivadorMWCosta.right
    anchors.verticalCenter: AtivadorMWCosta.verticalCenter
    margin-left: 10
    text: JOGAR MW NA COSTA DO ALVO
    font: verdana-9px
    color: #d7c08a

  TextEdit
    id: keyMwCosta
    anchors.right: rowBack.right
    anchors.verticalCenter: rowBack.verticalCenter
    width: 62
    height: 22
    margin-right: 6
    font: verdana-9px
    text-align: center
    placeholder: F4
    image-color: #3a1010
    color: white

  Panel
    id: rowHold
    anchors.top: rowBack.bottom
    anchors.left: actions.left
    anchors.right: actions.right
    height: 30
    margin-left: 5
    margin-top: 0
    background-color: alpha

  BotSwitch
    id: AtivadorHold
    anchors.left: rowHold.left
    anchors.verticalCenter: rowHold.verticalCenter
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblHoldText
    anchors.left: AtivadorHold.right
    anchors.verticalCenter: AtivadorHold.verticalCenter
    margin-left: 10
    text: HOLD MW & WG
    font: verdana-9px
    color: #d7c08a

  TextEdit
    id: keyHoldMW
    anchors.right: keyHoldWG.left
    anchors.verticalCenter: rowHold.verticalCenter
    width: 62
    height: 22
    margin-right: 6
    font: verdana-9px
    text-align: center
    placeholder: MW
    image-color: #3a1010
    color: white

  TextEdit
    id: keyHoldWG
    anchors.right: rowHold.right
    anchors.verticalCenter: rowHold.verticalCenter
    width: 62
    height: 22
    margin-right: 6
    font: verdana-9px
    text-align: center
    placeholder: WG
    image-color: #3a1010
    color: white

  BotSwitch
    id: AtivadorIcons
    anchors.left: AtivadorHold.left
    anchors.top: AtivadorHold.bottom
    width: 22
    height: 22
    margin-top: 10
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblIcons
    anchors.left: AtivadorIcons.right
    anchors.verticalCenter: AtivadorIcons.verticalCenter
    margin-left: 10
    text: ATIVAR ICONS MAGIC WALL
    font: verdana-9px
    color: #d7c08a

  BotSwitch
    id: AtivadorJogarMW
    anchors.left: AtivadorIcons.left
    anchors.top: AtivadorIcons.bottom
    width: 22
    height: 22
    margin-top: 10
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblJogarMW
    anchors.left: AtivadorJogarMW.right
    anchors.verticalCenter: AtivadorJogarMW.verticalCenter
    margin-left: 10
    text: ATIVAR ICONS MW COSTA/FRENTE ALVO
    font: verdana-9px
    color: #d7c08a

  BotSwitch
    id: AtivadorHoldMwIcon
    anchors.left: AtivadorJogarMW.left
    anchors.top: AtivadorJogarMW.bottom
    width: 22
    height: 22
    margin-top: 10
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblHoldIcon
    anchors.left: AtivadorHoldMwIcon.right
    anchors.verticalCenter: AtivadorHoldMwIcon.verticalCenter
    margin-left: 10
    text: ATIVAR ICONS HOLD MW/WG
    font: verdana-9px
    color: #d7c08a

  BotSwitch
    id: AtivadorCursorMwIcon
    anchors.left: AtivadorHoldMwIcon.left
    anchors.top: AtivadorHoldMwIcon.bottom
    width: 22
    height: 22
    margin-top: 10
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblCursorIcon
    anchors.left: AtivadorCursorMwIcon.right
    anchors.verticalCenter: AtivadorCursorMwIcon.verticalCenter
    margin-left: 10
    text: ATIVAR ICONS CURSOR MW/WG
    font: verdana-9px
    color: #d7c08a

]], g_ui.getRootWidget())
mwSystemInterface:hide()

function buttonsMwPcMobile()
  if modules._G.g_app.isMobile() then
    mwSystemButton.settings:show()
    mwSystemButton.title:setMarginRight(55)
  else
    mwSystemButton.settings:hide()
    mwSystemButton.title:setMarginRight(0)
  end
end
buttonsMwPcMobile()

mwSystemButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not mwSystemInterface:isVisible() then
      mwSystemInterface:show()
      mwSystemInterface:raise();
      mwSystemInterface:focus();
    else
      mwSystemInterface:hide()
    end
  end
end

mwSystemButton.settings.onClick = function()
  mwSystemInterface:show()
end

mwSystemInterface.idMW:setItemId(storage[switchMwSystem].panel.items.mw or 2129) mwSystemInterface.idWG:setItemId(storage[switchMwSystem].panel.items.wg or 2129)

mwSystemInterface.keyMwCursor:setText(storage[switchMwSystem].panel.keys.mwCursor or "")
mwSystemInterface.keyWGCursor:setText(storage[switchMwSystem].panel.keys.wgCursor or "")
mwSystemInterface.keyMwFrente:setText(storage[switchMwSystem].panel.keys.mwFrente or "")
mwSystemInterface.keyMwCosta:setText(storage[switchMwSystem].panel.keys.mwCosta or "")
mwSystemInterface.keyHoldMW:setText(storage[switchMwSystem].panel.keys.holdMW or "")
mwSystemInterface.keyHoldWG:setText(storage[switchMwSystem].panel.keys.holdWG or "")

mwSystemInterface.AtivadorMWCursor:setOn(storage[switchMwSystem].panel.switches.mwCursor == true)
mwSystemInterface.AtivadorWGCursor:setOn(storage[switchMwSystem].panel.switches.wgCursor == true)
mwSystemInterface.AtivadorMWFrente:setOn(storage[switchMwSystem].panel.switches.mwFrente == true)
mwSystemInterface.AtivadorMWCosta:setOn(storage[switchMwSystem].panel.switches.mwCosta == true)
mwSystemInterface.AtivadorHold:setOn(storage[switchMwSystem].panel.switches.hold == true)
mwSystemInterface.AtivadorIcons:setOn(storage[switchMwSystem].panel.switches.icons == true)
mwSystemInterface.AtivadorJogarMW:setOn(storage[switchMwSystem].panel.switches.iconsJogarMW == true)
mwSystemInterface.AtivadorHoldMwIcon:setOn(storage[switchMwSystem].panel.switches.iconsHoldMw == true)
mwSystemInterface.AtivadorCursorMwIcon:setOn(storage[switchMwSystem].panel.switches.iconsCursor == true)

mwSystemInterface.idMW.onItemChange = function(widget)
  storage[switchMwSystem].panel.items.mw = widget:getItemId()
  mwSystemInterface.mwIdValue:setText(tonumber(widget:getItemId()))
end

mwSystemInterface.idWG.onItemChange = function(widget)
  storage[switchMwSystem].panel.items.wg = widget:getItemId()
  mwSystemInterface.wgIdValue:setText(tonumber(widget:getItemId()))
end

local activeKeyEdit = nil

local function bindKeyTextEdit(textEditWidget, storageKey)
  textEditWidget.onTextChange = function(_, text)
    storage[switchMwSystem].panel.keys[storageKey] = text or ""
  end

  textEditWidget.onFocusChange = function(widget, focused)
    if focused then
      activeKeyEdit = widget
    elseif activeKeyEdit == widget then
      activeKeyEdit = nil
    end
  end
end

bindKeyTextEdit(mwSystemInterface.keyMwCursor, "mwCursor")
bindKeyTextEdit(mwSystemInterface.keyWGCursor, "wgCursor")
bindKeyTextEdit(mwSystemInterface.keyMwFrente, "mwFrente")
bindKeyTextEdit(mwSystemInterface.keyMwCosta, "mwCosta")
bindKeyTextEdit(mwSystemInterface.keyHoldMW, "holdMW")
bindKeyTextEdit(mwSystemInterface.keyHoldWG, "holdWG")

local function bindSwitch(botSwitchWidget, storageKey)
  botSwitchWidget.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    storage[switchMwSystem].panel.switches[storageKey] = newState
  end
end

bindSwitch(mwSystemInterface.AtivadorMWCursor, "mwCursor")
bindSwitch(mwSystemInterface.AtivadorWGCursor, "wgCursor")
bindSwitch(mwSystemInterface.AtivadorMWFrente, "mwFrente")
bindSwitch(mwSystemInterface.AtivadorMWCosta, "mwCosta")
bindSwitch(mwSystemInterface.AtivadorHold, "hold")
bindSwitch(mwSystemInterface.AtivadorIcons, "icons")
bindSwitch(mwSystemInterface.AtivadorJogarMW, "iconsJogarMW")
bindSwitch(mwSystemInterface.AtivadorHoldMwIcon, "iconsHoldMw")
bindSwitch(mwSystemInterface.AtivadorCursorMwIcon, "iconsCursor")

onKeyDown(function(keys)
  if not activeKeyEdit then return end
  if mwSystemInterface:isHidden() then return end
  if not activeKeyEdit:isFocused() then return end

  if keys == "Escape" or keys == "Esc" then
    activeKeyEdit:setText("")
    return
  end

  activeKeyEdit:setText(keys)
  activeKeyEdit:setCursorPos(#keys)
end)

mwSystemInterface.closePanel.onClick = function()
  mwSystemInterface:hide()
end

-- =========================================================
-- HOLD MW & WG (tile text "HOLD MW"/"HOLD WG")
-- =========================================================
local holdPressAt = 0
local candidates = {}

local lastCastAt = 0
local lastCastByTile = {}
local CAST_COOLDOWN_MS   = 200
local TILE_COOLDOWN_MS   = 200
local REMOVE_DEBOUNCE_MS = 170

local function holdEnabled()
  if not storage[switchMwSystem].enabled then return false end
  return storage[switchMwSystem].panel.switches.hold == true
end

local function getHoldKeys()
  local mwHot = storage[switchMwSystem].panel.keys.holdMW or ""
  local wgHot = storage[switchMwSystem].panel.keys.holdWG or ""
  return mwHot, wgHot
end

local function findCandidateIndex(pos)
  for i = 1, #candidates do
    if samePos(candidates[i], pos) then return i end
  end
  return nil
end

local function addCandidate(pos)
  if not pos then return end
  if not findCandidateIndex(pos) then
    table.insert(candidates, pos)
  end
end

local function removeCandidate(pos)
  local idx = findCandidateIndex(pos)
  if idx then table.remove(candidates, idx) end
end

local function clearAllHoldTexts()
  candidates = {}
  for _, tile in ipairs(g_map.getTiles(posz())) do
    local txt = tile:getText()
    if txt and txt:find("HOLD") then
      tile:setText("")
    end
  end
end

local function tryUseHoldOnTile(tile)
  if not tile then return end

  local txt = tile:getText()
  if not txt or txt:len() == 0 then return end
  if not txt:find("HOLD") then return end

  local rune = (txt == "HOLD MW" and 3180) or (txt == "HOLD WG" and 3156) or nil
  if not rune then return end

  if not tile:canShoot() then return end
  if isInPz() then return end
  if not tile:isWalkable() then return end

  local top = tile:getTopUseThing()
  if not top then return end
  if top:getId() == 2130 then return end

  local ppos = player:getPosition()
  local tpos = tile:getPosition()
  if not ppos or not tpos then return end

  if math.abs(ppos.x - tpos.x) >= 8 or math.abs(ppos.y - tpos.y) >= 6 then
    return
  end

  if (now - lastCastAt) < CAST_COOLDOWN_MS then return end

  local k = posKey3(tpos)
  local lastTile = lastCastByTile[k] or 0
  if (now - lastTile) < TILE_COOLDOWN_MS then return end

  lastCastAt = now
  lastCastByTile[k] = now
  return useWith(rune, top)
end

local holdMacro = macro(20, function()
  if not holdEnabled() then return end
  if #candidates == 0 then return end

  for i = #candidates, 1, -1 do
    local pos = candidates[i]
    local tile = g_map.getTile(pos)
    if not tile then
      table.remove(candidates, i)
    else
      local txt = tile:getText()
      if not txt or txt:len() == 0 then
        table.remove(candidates, i)
      else
        local ok = tryUseHoldOnTile(tile)
        if ok then return end
      end
    end
  end
end)

onRemoveThing(function(tile, thing)
  if not holdEnabled() then return end
  if not thing or thing:getId() ~= 2129 then return end

  local txt = tile:getText()
  if not txt or not txt:find("HOLD") then return end

  local tpos = tile:getPosition()
  addCandidate(tpos)

  local k = posKey3(tpos)
  local current = lastCastByTile[k] or 0
  lastCastByTile[k] = math.max(current, now + REMOVE_DEBOUNCE_MS)
end)

onAddThing(function(tile, thing)
  if not holdEnabled() then return end
  if holdMacro.isOff() then return end
  if not thing or thing:getId() ~= 2129 then return end

  local txt = tile:getText()
  if txt and txt:len() > 0 then
    removeCandidate(tile:getPosition())
  end
end)

onKeyDown(function(keys)
  local wsadWalking = modules.game_walking and modules.game_walking.wsadWalking
  if not wsadWalking then return end

  if not holdEnabled() then return end
  if holdMacro.isOff() then return end

  local mwHot, wgHot = getHoldKeys()
  if keys ~= mwHot and keys ~= wgHot then return end

  holdPressAt = now

  local tile = getTileUnderCursor()
  if not tile then return end

  local txt = tile:getText() or ""
  if txt:len() > 0 then
    tile:setText("")
    removeCandidate(tile:getPosition())
  else
    if keys == mwHot then
      tile:setText("HOLD MW")
    else
      tile:setText("HOLD WG")
    end
    addCandidate(tile:getPosition())
  end
end)

onKeyPress(function(keys)
  local wsadWalking = modules.game_walking and modules.game_walking.wsadWalking
  if not wsadWalking then return end
  if not holdEnabled() then return end
  if holdMacro.isOff() then return end

  if keys == "Escape" or keys == "Esc" then
    clearAllHoldTexts()
    return
  end

  local mwHot, wgHot = getHoldKeys()
  if keys ~= mwHot and keys ~= wgHot then return end

  if (holdPressAt - now) < -1000 then
    clearAllHoldTexts()
  end
end)

-- =========================================================
-- MW FRENTE & COSTA (by target direction)
-- =========================================================
local MW_CAST_COOLDOWN_MS = 200
local MW_TILE_COOLDOWN_MS = 200
local MW_KEY_REPEAT_MS    = 200
local MW_FAIL_COOLDOWN_MS = 1200
local MW_PERP_SPREAD      = 1

local mwLastCastAt = 0
local mwLastCastByTile = {}
local mwLastKeyAt = { front = 0, back = 0 }

local function getMWRuneId()
  return storage[switchMwSystem].panel.items.mw or 3180
end

local function inCastRange(ppos, tpos)
  return ppos.z == tpos.z and math.abs(ppos.x - tpos.x) < 8 and math.abs(ppos.y - tpos.y) < 6
end

local function tileHasMWorWG(tile)
  local top = tile and tile:getTopUseThing()
  if not top then return false end
  local id = top:getId()
  return id == 2129 or id == 2130
end

local function canUseAt(pos)
  local tile = g_map.getTile(pos)
  if not tile then return false end
  if isInPz() then return false end
  if not tile:canShoot() then return false end
  if tile.isWalkable and not tile:isWalkable() then return false end
  if tileHasMWorWG(tile) then return false end

  local top = tile:getTopUseThing()
  if not top then return false end
  return true, tile, top
end

local function tryCastAt(pos)
  local ok, tile, top = canUseAt(pos)
  if not ok then return false end

  local ppos = player:getPosition()
  local tpos = tile:getPosition()
  if not ppos or not tpos then return false end
  if not inCastRange(ppos, tpos) then return false end

  if (now - mwLastCastAt) < MW_CAST_COOLDOWN_MS then return false end

  local k = posKey3(tpos)
  local lastTile = mwLastCastByTile[k] or 0
  if lastTile > now then return false end
  if (now - lastTile) < MW_TILE_COOLDOWN_MS then return false end

  local used = useWith(getMWRuneId(), top)
  mwLastCastAt = now

  if used then
    mwLastCastByTile[k] = now
    return true
  else
    mwLastCastByTile[k] = now + MW_FAIL_COOLDOWN_MS
    return false
  end
end

local function computeBasePosByTargetDir(targetPos, targetDir, isFront, distance)
  distance = distance or 1

  local dx, dy = 0, 0
  if targetDir == 0 then dy = -distance
  elseif targetDir == 1 then dx =  distance
  elseif targetDir == 2 then dy =  distance
  elseif targetDir == 3 then dx = -distance
  end

  if not isFront then dx, dy = -dx, -dy end

  local base = { x = targetPos.x + dx, y = targetPos.y + dy, z = targetPos.z }
  local axis = (dx ~= 0) and "H" or "V"
  return base, axis
end

local function buildTryList(basePos, axis)
  local list = { basePos }

  if axis == "H" then
    for i = 1, MW_PERP_SPREAD do
      table.insert(list, {x=basePos.x, y=basePos.y - i, z=basePos.z})
      table.insert(list, {x=basePos.x, y=basePos.y + i, z=basePos.z})
    end
  else
    for i = 1, MW_PERP_SPREAD do
      table.insert(list, {x=basePos.x - i, y=basePos.y, z=basePos.z})
      table.insert(list, {x=basePos.x + i, y=basePos.y, z=basePos.z})
    end
  end

  return list
end

onKeyPress(function(keys)
  if not mwSystemEnabled() then return end

  local normalized = string.lower(keys or "")
  if normalized == "" then return end

  local frontEnabled = storage[switchMwSystem].panel.switches.mwFrente == true
  local backEnabled  = storage[switchMwSystem].panel.switches.mwCosta  == true

  local keyFront = string.lower(storage[switchMwSystem].panel.keys.mwFrente or "")
  local keyBack  = string.lower(storage[switchMwSystem].panel.keys.mwCosta  or "")

  local doFront = frontEnabled and keyFront ~= "" and normalized == keyFront
  local doBack  = backEnabled  and keyBack  ~= "" and normalized == keyBack
  if not doFront and not doBack then return end

  local mode = doFront and "front" or "back"
  if (now - (mwLastKeyAt[mode] or 0)) < MW_KEY_REPEAT_MS then return end
  mwLastKeyAt[mode] = now

  local target = g_game.getAttackingCreature()
  if not target then return end

  local targetPos = target:getPosition()
  if not targetPos or targetPos.z ~= posz() then return end

  local targetDir = target:getDirection()
  if targetDir == nil then return end

  local basePos, axis = computeBasePosByTargetDir(targetPos, targetDir, doFront, 1)
  local tries = buildTryList(basePos, axis)

  for i = 1, #tries do
    if tryCastAt(tries[i]) then return end
  end
end)

-- =========================================================
-- CURSOR HOTKEY (useWith rune on player)
-- =========================================================
local function startCrosshair(itemId)
    local item = findItem(itemId)
    if item and modules and modules.game_interface and modules.game_interface.startUseWith then
      modules.game_interface.startUseWith(item)
    end
  end

do
  local CURSOR_KEY_REPEAT_MS = 180
  local cursorLastAt = { mw = 0, wg = 0 }

  local function mwSystemEnabled()
    return storage[switchMwSystem] and storage[switchMwSystem].enabled == true
  end

  onKeyDown(function(keys)
    if not mwSystemEnabled() then return end

    local normalized = string.lower(keys or "")
    if normalized == "" then return end

    local st = storage[switchMwSystem]
    local p = st and st.panel
    if not p then return end

    local mwOn = p.switches and p.switches.mwCursor == true
    local wgOn = p.switches and p.switches.wgCursor == true

    local mwKey = string.lower((p.keys and p.keys.mwCursor) or "")
    local wgKey = string.lower((p.keys and p.keys.wgCursor) or "")

    local doMw = mwOn and mwKey ~= "" and normalized == mwKey
    local doWg = wgOn and wgKey ~= "" and normalized == wgKey
    if not doMw and not doWg then return end

    if doMw then
      if (now - (cursorLastAt.mw or 0)) < CURSOR_KEY_REPEAT_MS then return end
      cursorLastAt.mw = now
      local runeId = (p.items and p.items.mw) or 3180
      startCrosshair(runeId)
      return
    end

    if doWg then
      if (now - (cursorLastAt.wg or 0)) < CURSOR_KEY_REPEAT_MS then return end
      cursorLastAt.wg = now
      local runeId = (p.items and p.items.wg) or 3156
      startCrosshair(runeId)
      return
    end
  end)
end

-- =========================================================
-- MW ICONS (directional) + drag/pos
-- =========================================================
mwIcons = setupUI([[
UIWindow
  id: mainPanel
  size: 110 140
  anchors.centerIn: parent
  margin-top: 0
  opacity: 1.00
  text: MW Icons
  font: verdana-9px

  Item
    id: NW
    anchors.top: parent.top
    anchors.left: parent.left
    text: NW
    image-source:
    margin-top: 15
    font: verdana-9px
    text-align: bottom

  Item
    id: N
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 5
    text: N
    image-source:
    font: verdana-9px
    text-align: bottom

  Item
    id: NE
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 5
    text: NE
    image-source:
    font: verdana-9px
    text-align: bottom

  Item
    id: W
    anchors.top: NW.bottom
    anchors.left: NW.left
    text: W
    image-source:
    margin-top: 10
    font: verdana-9px
    text-align: bottom

  Item
    id: C
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 5
    text: C
    image-source:
    font: verdana-9px
    text-align: bottom

  Item
    id: E
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 5
    text: E
    image-source:
    font: verdana-9px
    text-align: bottom

  Item
    id: SW
    anchors.top: W.bottom
    anchors.left: NW.left
    text: SW
    image-source:
    margin-top: 10
    font: verdana-9px
    text-align: bottom

  Item
    id: S
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 5
    text: S
    image-source:
    font: verdana-9px
    text-align: bottom

  Item
    id: SE
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 5
    text: SE
    image-source:
    font: verdana-9px
    text-align: bottom
]], g_ui.getRootWidget())
mwIcons:hide()
mwIcons:setFocusable(false)

storage.mwSystem = storage.mwSystem or {}
storage.mwSystem.ui = storage.mwSystem.ui or {}
storage.mwSystem.ui.mwIconsPos = storage.mwSystem.ui.mwIconsPos or { x = 0, y = 0 }

local function applyMwIconsPos()
  local p = storage.mwSystem.ui.mwIconsPos
  mwIcons:breakAnchors()
  if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
    mwIcons:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    mwIcons:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    return
  end
  mwIcons:setPosition({ x = p.x, y = p.y })
end

local function disableMwIconsDrag()
  mwIcons.onDragEnter = nil
  mwIcons.onDragMove  = nil
  mwIcons:setFocusable(false)
  mwIcons:setPhantom(true)
  mwIcons:setDraggable(false)
  mwIcons:setOpacity(1.00)
end

local function enableMwIconsDrag()
  mwIcons:setFocusable(true)
  mwIcons:setPhantom(false)
  mwIcons:setDraggable(true)
  mwIcons:setOpacity(1.00)

  mwIcons.onDragEnter = function(widget, mousePos)
    widget:breakAnchors()
    widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
    return true
  end

  mwIcons.onDragMove = function(widget, mousePos)
    local parent = widget:getParent()
    if not parent or not parent.getRect then return true end
    local r = parent:getRect()

    local ref = widget.movingReference or { x = 0, y = 0 }
    local x = mousePos.x - ref.x
    local y = mousePos.y - ref.y

    x = math.min(math.max(r.x, x), r.x + r.width  - widget:getWidth())
    y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

    widget:move(x, y)
    storage.mwSystem.ui.mwIconsPos = { x = x, y = y }
    return true
  end
end

applyMwIconsPos()
disableMwIconsDrag()

local lastPressedIcons = false
macro(200, function()
  if not mwSystemEnabled() or not storage[switchMwSystem].panel.switches.icons then
    mwIcons:hide()
    return
  end

  mwIcons:show()

  local pressed = isMoveKeyPressed()
  if pressed ~= lastPressedIcons then
    if pressed then enableMwIconsDrag() else disableMwIconsDrag() end
    lastPressedIcons = pressed
  end

  applyMwIconsPos()
end)

mwIcons.NW:setItemId(2129) mwIcons.N:setItemId(2129) mwIcons.NE:setItemId(2129)
mwIcons.W:setItemId(2129)  mwIcons.C:setItemId(2129) mwIcons.E:setItemId(2129)
mwIcons.SW:setItemId(2129) mwIcons.S:setItemId(2129) mwIcons.SE:setItemId(2129)

-- =========================
-- MW DIRECIONAIS (click -> enable green; after cast confirms MW -> disable)
-- =========================
do
  local mwallId = 3180
  local mwEffectIds = { [2128] = true, [2129] = true }
  local REPLACE_DELAY_MS = 200

  local dirs = {
    NW = {dx=-1, dy=-1},
    N  = {dx= 0, dy=-1},
    NE = {dx= 1, dy=-1},
    W  = {dx=-1, dy= 0},
    C  = {dx= 0, dy= 0},
    E  = {dx= 1, dy= 0},
    SW = {dx=-1, dy= 1},
    S  = {dx= 0, dy= 1},
    SE = {dx= 1, dy= 1},
  }

  local function getDirState(dir)
    storage.mwSystem.dirs = storage.mwSystem.dirs or {}
    local st = storage.mwSystem.dirs[dir]
    if type(st) ~= "table" then
      st = {}
      storage.mwSystem.dirs[dir] = st
    end
    if st.enabled == nil then st.enabled = false end
    if st.pending == nil then st.pending = false end
    if st.pendingSince == nil then st.pendingSince = 0 end
    if st.lastTry == nil then st.lastTry = 0 end
    if st.lastHasMW == nil then st.lastHasMW = false end
    if st.mwMissingSince == nil then st.mwMissingSince = 0 end
    return st
  end

  storage.mwSystem.mwFeet = storage.mwSystem.mwFeet or {}
  if storage.mwSystem.mwFeet.armed == nil then storage.mwSystem.mwFeet.armed = false end
  if storage.mwSystem.mwFeet.pending == nil then storage.mwSystem.mwFeet.pending = false end
  if storage.mwSystem.mwFeet.pendingSince == nil then storage.mwSystem.mwFeet.pendingSince = 0 end
  if storage.mwSystem.mwFeet.lastTry == nil then storage.mwSystem.mwFeet.lastTry = 0 end
  if storage.mwSystem.mwFeet.lastOldPos == nil then storage.mwSystem.mwFeet.lastOldPos = nil end

  local function setDirColor(dir, enabled)
    local w = mwIcons and mwIcons[dir]
    if not w then return end
    if w.setColoredText then
      w:setColoredText({dir, enabled and "green" or "white"})
    end
  end

  local function disableDir(dir)
    local st = getDirState(dir)
    st.enabled = false
    st.pending = false
    st.pendingSince = 0
    st.lastHasMW = false
    st.mwMissingSince = 0
    setDirColor(dir, false)
  end

  local function disableAllExcept(dirKeep)
    for dir, _ in pairs(dirs) do
      local st = getDirState(dir)
      local keep = (dir == dirKeep)
      st.enabled = keep
      st.pending = false
      st.pendingSince = 0
      st.lastHasMW = false
      st.mwMissingSince = 0
      setDirColor(dir, keep)
    end
  end

  local function hasMWOnTile(tile)
    local items = tile:getItems()
    if not items then return false end
    for _, item in ipairs(items) do
      if item and item.getId then
        local id = item:getId()
        if mwEffectIds[id] then return true end
      end
    end
    return false
  end

  local function getTileAtOffset(dx, dy)
    local lp = g_game.getLocalPlayer()
    if not lp then return nil end
    local pos = lp:getPosition()
    if not pos then return nil end
    return g_map.getTile({x = pos.x + dx, y = pos.y + dy, z = pos.z})
  end

  local function tryUseMwOnTile(tile)
    if not tile then return false end
    if not tile:isWalkable() then return false end
    if hasMWOnTile(tile) then return false end

    local ground = tile:getGround()
    if not ground or type(ground) ~= "userdata" or not ground.getId then return false end
    local okId, gid = pcall(function() return ground:getId() end)
    if not okId or not gid or gid <= 0 then return false end

    local mwallItem = findItem(mwallId)
    if not mwallItem or type(mwallItem) ~= "userdata" then return false end

    pcall(function()
      g_game.useWith(mwallItem, ground)
    end)

    return true
  end

  local function toggleDir(dir)
    if dir == "C" then return end
    local st = getDirState(dir)
    if st.enabled then
      disableDir(dir)
    else
      disableAllExcept(dir)
      storage.mwSystem.mwFeet.armed = false
      storage.mwSystem.mwFeet.pending = false
      storage.mwSystem.mwFeet.pendingSince = 0
      setDirColor("C", false)
    end
  end

  local function setCArmed(v)
    storage.mwSystem.mwFeet.armed = v and true or false
    storage.mwSystem.mwFeet.pending = false
    storage.mwSystem.mwFeet.pendingSince = 0
    setDirColor("C", storage.mwSystem.mwFeet.armed)
  end

  for dir, _ in pairs(dirs) do
    local w = mwIcons and mwIcons[dir]
    if w then
      if dir == "C" then
        w.onClick = function()
          if storage.mwSystem.mwFeet.armed then
            setCArmed(false)
          else
            disableAllExcept("C")
            setCArmed(true)
          end
        end
        setDirColor("C", storage.mwSystem.mwFeet.armed)
      else
        w.onClick = function() toggleDir(dir) end
        setDirColor(dir, getDirState(dir).enabled)
      end
    end
  end

  macro(200, function()
    if not mwSystemEnabled() then return end
    if not mwIcons or mwIcons:isHidden() then return end
    local tnow = nowMillis()

    for dir, d in pairs(dirs) do
      if dir ~= "C" then
        local st = getDirState(dir)
        if st.enabled then
          local tile = getTileAtOffset(d.dx, d.dy)
          if not tile then return end

          local has = hasMWOnTile(tile)

          if has then
            st.lastHasMW = true
            st.mwMissingSince = 0
          else
            if st.lastHasMW then
              st.lastHasMW = false
              st.mwMissingSince = tnow
            end
          end

          if has then
            if st.pending then disableDir(dir) end
            return
          end

          if st.mwMissingSince > 0 then
            if (tnow - st.mwMissingSince) < REPLACE_DELAY_MS then
              return
            end
          end

          if st.pending then
            if (tnow - (st.pendingSince or 0)) > 900 then
              st.pending = false
              st.pendingSince = 0
            end
            return
          end

          if (tnow - (st.lastTry or 0)) < 900 then return end
          st.lastTry = tnow

          local called = tryUseMwOnTile(tile)
          if called then
            st.pending = true
            st.pendingSince = tnow
          end
          return
        end
      end
    end
  end)

  onPlayerPositionChange(function(newPos, oldPos)
    if not mwIcons or mwIcons:isHidden() then return end
    if not storage.mwSystem.mwFeet.armed then return end
    if not newPos or not oldPos then return end
    if oldPos.x == newPos.x and oldPos.y == newPos.y and oldPos.z == newPos.z then return end

    local tnow = nowMillis()
    local oldPosition = {x = oldPos.x, y = oldPos.y, z = oldPos.z}
    storage.mwSystem.mwFeet.lastOldPos = oldPosition

    if (tnow - (storage.mwSystem.mwFeet.lastTry or 0)) < 900 then return end
    storage.mwSystem.mwFeet.lastTry = tnow

    local tile = g_map.getTile(oldPosition)
    if not tile then return end

    if hasMWOnTile(tile) then
      setCArmed(false)
      return
    end

    local called = tryUseMwOnTile(tile)
    if called then
      storage.mwSystem.mwFeet.pending = true
      storage.mwSystem.mwFeet.pendingSince = tnow

      schedule(150, function()
        if not storage.mwSystem.mwFeet.armed then return end
        local p = storage.mwSystem.mwFeet.lastOldPos
        if not p then return end
        local t = g_map.getTile(p)
        if t and hasMWOnTile(t) then
          setCArmed(false)
        end
      end)
    end
  end)

  macro(200, function()
    if not mwSystemEnabled() then return end
    if not mwIcons or mwIcons:isHidden() then return end
    if not storage.mwSystem.mwFeet.armed then return end
    if not storage.mwSystem.mwFeet.pending then return end

    local tnow = nowMillis()
    if (tnow - (storage.mwSystem.mwFeet.pendingSince or 0)) > 900 then
      storage.mwSystem.mwFeet.pending = false
      storage.mwSystem.mwFeet.pendingSince = 0
    end
  end)
end

-- =========================================================
-- C/F ICONS (Costa/Frente) + drag/pos + click casts
-- =========================================================
mwCostaFrente = setupUI([[
UIWindow
  id: mainPanel
  size: 90 50
  anchors.centerIn: parent
  margin-top: 0
  opacity: 1.00
  text: C/F Icons
  font: verdana-9px

  Item
    id: Costa
    anchors.top: parent.top
    anchors.left: parent.left
    text: Costa
    image-source:
    margin-top: 15
    size: 38 38
    font: verdana-9px
    text-align: bottom

  Item
    id: Frente
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 10
    text: Frente
    size: 38 38
    image-source:
    font: verdana-9px
    text-align: bottom
]], g_ui.getRootWidget())

mwCostaFrente:show()
mwCostaFrente:setFocusable(false)
mwCostaFrente.Costa:setItemId(11611)
mwCostaFrente.Frente:setItemId(11611)

do
  local CLICK_REPEAT_MS = 200
  local mwLastClickAt = { front = 0, back = 0 }

  local function getMWRuneIdLocal()
    local id = storage[switchMwSystem] and storage[switchMwSystem].panel and storage[switchMwSystem].panel.items and storage[switchMwSystem].panel.items.mw
    id = tonumber(id)
    return (id and id > 0) and id or 3180
  end

  local function tryCastAtLocal(pos, nowms)
    local ok, tile, top = canUseAt(pos)
    if not ok then return false end

    local pl = g_game.getLocalPlayer()
    if not pl then return false end
    local ppos = pl:getPosition()
    local tpos = tile:getPosition()
    if not ppos or not tpos then return false end
    if not inCastRange(ppos, tpos) then return false end

    if (nowms - mwLastCastAt) < MW_CAST_COOLDOWN_MS then return false end

    local k = posKey3(tpos)
    local lastTile = mwLastCastByTile[k] or 0
    if lastTile > nowms then return false end
    if (nowms - lastTile) < MW_TILE_COOLDOWN_MS then return false end

    local used = useWith(getMWRuneIdLocal(), top)
    mwLastCastAt = nowms

    if used then
      mwLastCastByTile[k] = nowms
      return true
    else
      mwLastCastByTile[k] = nowms + MW_FAIL_COOLDOWN_MS
      return false
    end
  end

  local function castFrontOrBack(isFront)
    local nowms = nowMillis()
    local mode = isFront and "front" or "back"
    if (nowms - (mwLastClickAt[mode] or 0)) < CLICK_REPEAT_MS then return end
    mwLastClickAt[mode] = nowms

    local target = g_game.getAttackingCreature()
    if not target then return end

    local targetPos = target:getPosition()
    if not targetPos then return end

    local pl = g_game.getLocalPlayer()
    if not pl then return end
    local ppos = pl:getPosition()
    if not ppos then return end
    if targetPos.z ~= ppos.z then return end

    local targetDir = target:getDirection()
    if targetDir == nil then return end

    local basePos, axis = computeBasePosByTargetDir(targetPos, targetDir, isFront, 1)
    local tries = buildTryList(basePos, axis)

    for i = 1, #tries do
      if tryCastAtLocal(tries[i], nowms) then return end
    end
  end

  if mwCostaFrente and mwCostaFrente.Frente then
    mwCostaFrente.Frente.onClick = function() castFrontOrBack(true) end
  end
  if mwCostaFrente and mwCostaFrente.Costa then
    mwCostaFrente.Costa.onClick = function() castFrontOrBack(false) end
  end
end

storage.mwSystem.ui.mwCostaFrentePos = storage.mwSystem.ui.mwCostaFrentePos or { x = 0, y = 0 }
local lastPressedCF = false

local function applyMwCostaFrentePos()
  local p = storage.mwSystem.ui.mwCostaFrentePos
  mwCostaFrente:breakAnchors()
  if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
    mwCostaFrente:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    mwCostaFrente:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    return
  end
  mwCostaFrente:setPosition({ x = p.x, y = p.y })
end

local function disableMwCostaFrenteDrag()
  mwCostaFrente.onDragEnter = nil
  mwCostaFrente.onDragMove  = nil
  mwCostaFrente:setFocusable(false)
  mwCostaFrente:setPhantom(true)
  mwCostaFrente:setDraggable(false)
  mwCostaFrente:setOpacity(1.00)
end

local function enableMwCostaFrenteDrag()
  mwCostaFrente:setFocusable(true)
  mwCostaFrente:setPhantom(false)
  mwCostaFrente:setDraggable(true)
  mwCostaFrente:setOpacity(1.00)

  mwCostaFrente.onDragEnter = function(widget, mousePos)
    widget:breakAnchors()
    widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
    return true
  end

  mwCostaFrente.onDragMove = function(widget, mousePos)
    local parent = widget:getParent()
    if not parent or not parent.getRect then return true end
    local r = parent:getRect()

    local ref = widget.movingReference or { x = 0, y = 0 }
    local x = mousePos.x - ref.x
    local y = mousePos.y - ref.y

    x = math.min(math.max(r.x, x), r.x + r.width  - widget:getWidth())
    y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

    widget:move(x, y)
    storage.mwSystem.ui.mwCostaFrentePos = { x = x, y = y }
    return true
  end
end

applyMwCostaFrentePos()
disableMwCostaFrenteDrag()

macro(200, function()
  if not mwSystemEnabled() or not storage[switchMwSystem].panel.switches.iconsJogarMW then
    mwCostaFrente:hide()
    return
  end

  mwCostaFrente:show()

  local pressed = isMoveKeyPressed()
  if pressed ~= lastPressedCF then
    if pressed then enableMwCostaFrenteDrag() else disableMwCostaFrenteDrag() end
    lastPressedCF = pressed
  end

  applyMwCostaFrentePos()
end)

-- =========================================================
-- HOLD ICONS (MW/WG) - separate system (tile text "Hold MW"/"Hold WG")
-- =========================================================
mwHold = setupUI([[
UIWindow
  id: mainPanel
  size: 90 50
  anchors.centerIn: parent
  margin-top: 0
  opacity: 1.00
  text: Hold Icons
  font: verdana-9px

  Item
    id: MW
    anchors.top: parent.top
    anchors.left: parent.left
    text: MW
    image-source:
    margin-top: 15
    size: 38 38
    font: verdana-9px
    text-align: bottom

  Item
    id: WG
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 10
    text: WG
    size: 38 38
    image-source:
    font: verdana-9px
    text-align: bottom
]], g_ui.getRootWidget())

mwHold:hide()
mwHold:setFocusable(true)
mwHold.MW:setItemId(11612)
mwHold.WG:setItemId(11642)

do
  local CAST_COOLDOWN_MS     = 200
  local TILE_COOLDOWN_MS     = 200
  local FAIL_COOLDOWN_MS     = 200
  local REPLACE_DELAY_MS     = 200

  storage.mwSystem.ui.mwHoldPos = storage.mwSystem.ui.mwHoldPos or { x = 0, y = 0 }
  storage.mwSystem.hold = storage.mwSystem.hold or {}
  storage.mwSystem.hold.mw = storage.mwSystem.hold.mw or { enabled = false }
  storage.mwSystem.hold.wg = storage.mwSystem.hold.wg or { enabled = false }

  local candidatesH = {}
  local lastCastAtH = 0
  local lastCastByTileH = {}
  local lastPressedHold = false

  local function getMWRuneIdH()
    local id = storage[switchMwSystem] and storage[switchMwSystem].panel and storage[switchMwSystem].panel.items and storage[switchMwSystem].panel.items.mw
    id = tonumber(id)
    return (id and id > 0) and id or 3180
  end

  local function getWGRuneIdH()
    local id = storage[switchMwSystem] and storage[switchMwSystem].panel and storage[switchMwSystem].panel.items and storage[switchMwSystem].panel.items.wg
    id = tonumber(id)
    return (id and id > 0) and id or 3156
  end

  local function setColor(which, enabled)
    local w = mwHold and mwHold[which]
    if not w or not w.setColoredText then return end
    w:setColoredText({which, enabled and "green" or "white"})
  end

  local function refreshColors()
    setColor("MW", storage.mwSystem.hold.mw.enabled)
    setColor("WG", storage.mwSystem.hold.wg.enabled)
  end

  local function applyMwHoldPos()
    local p = storage.mwSystem.ui.mwHoldPos
    mwHold:breakAnchors()
    if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
      mwHold:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
      mwHold:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
      return
    end
    mwHold:setPosition({ x = p.x, y = p.y })
  end

  local function disableDrag()
    mwHold.onDragEnter = nil
    mwHold.onDragMove  = nil
    mwHold:setFocusable(false)
    mwHold:setPhantom(true)
    mwHold:setDraggable(false)
    mwHold:setOpacity(1.00)
  end

  local function enableDrag()
    mwHold:setFocusable(true)
    mwHold:setPhantom(false)
    mwHold:setDraggable(true)
    mwHold:setOpacity(1.00)

    mwHold.onDragEnter = function(widget, mousePos)
      widget:breakAnchors()
      widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
      return true
    end

    mwHold.onDragMove = function(widget, mousePos)
      local parent = widget:getParent()
      if not parent or not parent.getRect then return true end
      local r = parent:getRect()

      local ref = widget.movingReference or { x = 0, y = 0 }
      local x = mousePos.x - ref.x
      local y = mousePos.y - ref.y

      x = math.min(math.max(r.x, x), r.x + r.width  - widget:getWidth())
      y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

      widget:move(x, y)
      storage.mwSystem.ui.mwHoldPos = { x = x, y = y }
      return true
    end
  end

  applyMwHoldPos()
  disableDrag()

  local function findCandidateIndexH(pos)
    for i = 1, #candidatesH do
      if samePos(candidatesH[i], pos) then return i end
    end
    return nil
  end

  local function addCandidateH(pos)
    if not pos then return end
    if not findCandidateIndexH(pos) then
      table.insert(candidatesH, pos)
    end
  end

  local function removeCandidateH(pos)
    local idx = findCandidateIndexH(pos)
    if idx then table.remove(candidatesH, idx) end
  end

  local function clearHoldType(kind)
    local want = (kind == "MW") and "Hold MW" or "Hold WG"

    for _, tile in ipairs(g_map.getTiles(posz())) do
      local txt = tile:getText()
      if txt and txt == want then
        tile:setText("")
      end
    end

    for i = #candidatesH, 1, -1 do
      local t = g_map.getTile(candidatesH[i])
      if not t then
        table.remove(candidatesH, i)
      else
        local txt = t:getText() or ""
        if txt:len() == 0 or txt == want then
          table.remove(candidatesH, i)
        end
      end
    end
  end

  if mwHold and mwHold.MW then
    mwHold.MW.onClick = function()
      storage.mwSystem.hold.mw.enabled = not storage.mwSystem.hold.mw.enabled
      if not storage.mwSystem.hold.mw.enabled then clearHoldType("MW") end
      refreshColors()
    end
  end

  if mwHold and mwHold.WG then
    mwHold.WG.onClick = function()
      storage.mwSystem.hold.wg.enabled = not storage.mwSystem.hold.wg.enabled
      if not storage.mwSystem.hold.wg.enabled then clearHoldType("WG") end
      refreshColors()
    end
  end

  refreshColors()

  local function tryUseHoldOnTile(tile, nowms)
    if not tile then return false end

    local txt = tile:getText()
    if not txt or txt:len() == 0 then return false end

    local isMW = (txt == "Hold MW")
    local isWG = (txt == "Hold WG")
    if not isMW and not isWG then return false end

    if isMW and not storage.mwSystem.hold.mw.enabled then return false end
    if isWG and not storage.mwSystem.hold.wg.enabled then return false end

    if not tile:canShoot() then return false end
    if isInPz and isInPz() then return false end
    if tile.isWalkable and not tile:isWalkable() then return false end

    local top = tile:getTopUseThing()
    if not top then return false end

    local topId = top:getId()
    if (isMW and topId == 2129) or (isWG and topId == 2130) then
      return false
    end

    local pl = g_game.getLocalPlayer()
    if not pl then return false end
    local ppos = pl:getPosition()
    local tpos = tile:getPosition()
    if not ppos or not tpos then return false end

    if math.abs(ppos.x - tpos.x) >= 8 or math.abs(ppos.y - tpos.y) >= 6 then
      return false
    end

    if (nowms - lastCastAtH) < CAST_COOLDOWN_MS then return false end

    local k = posKey3(tpos)
    local lastTile = lastCastByTileH[k] or 0
    if lastTile > nowms then return false end
    if (nowms - lastTile) < TILE_COOLDOWN_MS then return false end

    local runeId = isMW and getMWRuneIdH() or getWGRuneIdH()
    lastCastAtH = nowms

    local used = useWith(runeId, top)
    if used then
      lastCastByTileH[k] = nowms
      return true
    else
      lastCastByTileH[k] = nowms + FAIL_COOLDOWN_MS
      return false
    end
  end

  local holdMacroH = macro(20, function()
    if #candidatesH == 0 then return end
    local nowms = nowMillis()

    for i = #candidatesH, 1, -1 do
      local pos = candidatesH[i]
      local tile = g_map.getTile(pos)
      if not tile then
        table.remove(candidatesH, i)
      else
        local txt = tile:getText()
        if not txt or txt:len() == 0 then
          table.remove(candidatesH, i)
        else
          if tryUseHoldOnTile(tile, nowms) then return end
        end
      end
    end
  end)

  onRemoveThing(function(tile, thing)
    if not tile or not thing or not thing.getId then return end
    local id = thing:getId()
    if id ~= 2129 and id ~= 2130 then return end

    local txt = tile:getText()
    if txt ~= "Hold MW" and txt ~= "Hold WG" then return end

    addCandidateH(tile:getPosition())

    local nowms = nowMillis()
    local k = posKey3(tile:getPosition())
    local cur = lastCastByTileH[k] or 0
    lastCastByTileH[k] = math.max(cur, nowms + REPLACE_DELAY_MS)
  end)

  onAddThing(function(tile, thing)
    if holdMacroH.isOff() then return end
    if not tile or not thing or not thing.getId then return end
    local id = thing:getId()
    if id ~= 2129 and id ~= 2130 then return end

    local txt = tile:getText()
    if txt == "Hold MW" or txt == "Hold WG" then
      removeCandidateH(tile:getPosition())
    end
  end)

  onUseWith(function(pos, itemId, target)
    if not target or not target.getPosition then return end

    local mwId = getMWRuneIdH()
    local wgId = getWGRuneIdH()
    if itemId ~= mwId and itemId ~= wgId then return end

    if itemId == mwId and not storage.mwSystem.hold.mw.enabled then return end
    if itemId == wgId and not storage.mwSystem.hold.wg.enabled then return end

    local tpos = target:getPosition()
    local tile = g_map.getTile(tpos)
    if not tile then return end

    if itemId == mwId then
      tile:setText("Hold MW")
    else
      tile:setText("Hold WG")
    end

    addCandidateH(tile:getPosition())
  end)

  macro(200, function()
    if not mwSystemEnabled() or not storage[switchMwSystem].panel.switches.iconsHoldMw then
      mwHold:hide()
      return
    end

    mwHold:show()

    local pressed = isMoveKeyPressed()
    if pressed ~= lastPressedHold then
      if pressed then enableDrag() else disableDrag() end
      lastPressedHold = pressed
    end
    applyMwHoldPos()
  end)
end

-- =========================================================
-- CURSOR ICONS (MW/WG) + show/hide + save pos + green active + reUse crosshair
-- =========================================================
do
  storage[switchMwSystem] = storage[switchMwSystem] or { enabled = false }
  storage[switchMwSystem].panel = storage[switchMwSystem].panel or { switches = {}, keys = {}, items = {} }
  storage[switchMwSystem].panel.items = storage[switchMwSystem].panel.items or { mw = 3180, wg = 3156 }
  storage[switchMwSystem].panel.switches = storage[switchMwSystem].panel.switches or {}
  storage[switchMwSystem].panel.switches.iconsCursor = storage[switchMwSystem].panel.switches.iconsCursor == true

  -- estado separado do cursor por ícone
  storage[switchMwSystem].cursorIcons = storage[switchMwSystem].cursorIcons or {
    mw = false,
    wg = false,
    pos = { x = 1, y = 1 } -- padrão solicitado (x:1 y:1)
  }

  local function mwSystemEnabled()
    return storage[switchMwSystem] and storage[switchMwSystem].enabled == true
  end

  local function stopCrosshair()
    if modules and modules.game_interface and modules.game_interface.stopUseWith then
      modules.game_interface.stopUseWith()
    elseif g_game and g_game.cancelUse then
      g_game.cancelUse()
    end
  end

  local function startCrosshair(itemId)
    local item = findItem(itemId)
    if item and modules and modules.game_interface and modules.game_interface.startUseWith then
      modules.game_interface.startUseWith(item)
    end
  end

  local function setItemVisual(widget, isActive, label)
    if not widget then return end
    label = label or ""
    if widget.setColoredText then
      widget:setColoredText({ label, isActive and "green" or "white" })
      return
    end
    if widget.setTextColor then
      widget:setTextColor(isActive and "#00ff00" or "#ffffff")
    end
    if widget.setOpacity then
      widget:setOpacity(isActive and 1.00 or 0.95)
    end
  end

  local function isMoveKeyPressed()
    if g_app and type(g_app.isMobile) == "function" and g_app:isMobile() then
      return g_keyboard and g_keyboard.isKeyPressed and g_keyboard.isKeyPressed("F2")
    end
    return g_keyboard and g_keyboard.isCtrlPressed and g_keyboard.isCtrlPressed()
  end

mwCursorr = setupUI([[
UIWindow
  id: mainPanel
  size: 90 50
  anchors.centerIn: parent
  margin-top: 0
  opacity: 1.00
  text: Cursor Icons
  font: verdana-9px

  Item
    id: MW
    anchors.top: parent.top
    anchors.left: parent.left
    text: MW
    image-source:
    margin-top: 15
    size: 38 38
    font: verdana-9px
    text-align: bottom

  Item
    id: WG
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 10
    text: WG
    size: 38 38
    image-source:
    font: verdana-9px
    text-align: bottom
]], g_ui.getRootWidget())

  mwCursorr:setFocusable(false)
  mwCursorr:setPhantom(true)
  mwCursorr:setDraggable(false)

  mwCursorr.MW:setItemId(storage[switchMwSystem].panel.items.mw or 3180)
  mwCursorr.WG:setItemId(storage[switchMwSystem].panel.items.wg or 3156)

  local function applyCursorPos()
    local p = storage[switchMwSystem].cursorIcons.pos
    mwCursorr:breakAnchors()
    if not p or type(p.x) ~= "number" or type(p.y) ~= "number" then
      storage[switchMwSystem].cursorIcons.pos = { x = 1, y = 1 }
      p = storage[switchMwSystem].cursorIcons.pos
    end
    -- posição inicial padronizada x:1 y:1
    if p.x == 1 and p.y == 1 then
      mwCursorr:setPosition({ x = 1, y = 1 })
      return
    end
    mwCursorr:setPosition({ x = p.x, y = p.y })
  end

  local function disableCursorDrag()
    mwCursorr.onDragEnter = nil
    mwCursorr.onDragMove  = nil
    mwCursorr:setFocusable(false)
    mwCursorr:setPhantom(true)
    mwCursorr:setDraggable(false)
  end

  local function enableCursorDrag()
    mwCursorr:setFocusable(true)
    mwCursorr:setPhantom(false)
    mwCursorr:setDraggable(true)

    mwCursorr.onDragEnter = function(widget, mousePos)
      widget:breakAnchors()
      widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
      return true
    end

    mwCursorr.onDragMove = function(widget, mousePos)
      local parent = widget:getParent()
      if not parent or not parent.getRect then return true end
      local r = parent:getRect()

      local ref = widget.movingReference or { x = 0, y = 0 }
      local x = mousePos.x - ref.x
      local y = mousePos.y - ref.y

      x = math.min(math.max(r.x, x), r.x + r.width  - widget:getWidth())
      y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

      widget:move(x, y)
      storage[switchMwSystem].cursorIcons.pos = { x = x, y = y }
      return true
    end
  end

  local function refreshCursorUI()
    local show = mwSystemEnabled() and storage[switchMwSystem].panel.switches.iconsCursor == true
    if show then
      mwCursorr:show()
    else
      mwCursorr:hide()
      -- se esconder a UI, só limpa o estado do ÍCONE (não mexe no painel)
      storage[switchMwSystem].cursorIcons.mw = false
      storage[switchMwSystem].cursorIcons.wg = false
      stopCrosshair()
      return
    end

    setItemVisual(mwCursorr.MW, storage[switchMwSystem].cursorIcons.mw == true, "MW")
    setItemVisual(mwCursorr.WG, storage[switchMwSystem].cursorIcons.wg == true, "WG")
  end

  mwCursorr.MW.onClick = function()
    if not mwSystemEnabled() then return end
    if storage[switchMwSystem].panel.switches.iconsCursor ~= true then return end

    local was = storage[switchMwSystem].cursorIcons.mw == true
    if was then
      storage[switchMwSystem].cursorIcons.mw = false
      stopCrosshair()
    else
      storage[switchMwSystem].cursorIcons.mw = true
      storage[switchMwSystem].cursorIcons.wg = false
      startCrosshair(storage[switchMwSystem].panel.items.mw or 3180)
    end
    refreshCursorUI()
  end

  mwCursorr.WG.onClick = function()
    if not mwSystemEnabled() then return end
    if storage[switchMwSystem].panel.switches.iconsCursor ~= true then return end

    local was = storage[switchMwSystem].cursorIcons.wg == true
    if was then
      storage[switchMwSystem].cursorIcons.wg = false
      stopCrosshair()
    else
      storage[switchMwSystem].cursorIcons.wg = true
      storage[switchMwSystem].cursorIcons.mw = false
      startCrosshair(storage[switchMwSystem].panel.items.wg or 3156)
    end
    refreshCursorUI()
  end

  applyCursorPos()
  disableCursorDrag()
  mwCursorr:hide() -- evita flash

  local lastPressed = false
  macro(200, function()
    if not mwSystemEnabled() or storage[switchMwSystem].panel.switches.iconsCursor ~= true then
      if mwCursorr:isVisible() then
        mwCursorr:hide()
        storage[switchMwSystem].cursorIcons.mw = false
        storage[switchMwSystem].cursorIcons.wg = false
        stopCrosshair()
      end
      return
    end

    if not mwCursorr:isVisible() then mwCursorr:show() end

    local pressed = isMoveKeyPressed()
    if pressed ~= lastPressed then
      if pressed then enableCursorDrag() else disableCursorDrag() end
      lastPressed = pressed
    end
    applyCursorPos()
    -- mantém cores atualizadas
    setItemVisual(mwCursorr.MW, storage[switchMwSystem].cursorIcons.mw == true, "MW")
    setItemVisual(mwCursorr.WG, storage[switchMwSystem].cursorIcons.wg == true, "WG")
  end)

  -- ========= reUse automático (SÓ enquanto ícone estiver verde) =========
  settings = settings or {}
  if settings.reUse == nil then settings.reUse = true end

  local excluded = excluded or {}
  local function tableFind(t, v)
    if type(t) ~= "table" then return false end
    for i = 1, #t do
      if t[i] == v then return true end
    end
    return false
  end

  local function isAnyIconCursorActive()
    return storage[switchMwSystem].cursorIcons.mw == true or storage[switchMwSystem].cursorIcons.wg == true
  end

  local function getActiveIconItemId()
    if storage[switchMwSystem].cursorIcons.mw == true then
      return storage[switchMwSystem].panel.items.mw or 3180
    end
    if storage[switchMwSystem].cursorIcons.wg == true then
      return storage[switchMwSystem].panel.items.wg or 3156
    end
    return nil
  end

  onUseWith(function(pos, itemId, target, subType)
    if not mwSystemEnabled() then return end
    if not isAnyIconCursorActive() then return end

    local activeId = getActiveIconItemId()
    if not activeId or itemId ~= activeId then return end

    if settings.reUse and not tableFind(excluded, itemId) then
      schedule(50, function()
        if not mwSystemEnabled() then return end
        if not isAnyIconCursorActive() then return end
        local item = findItem(itemId)
        if item and modules and modules.game_interface and modules.game_interface.startUseWith then
          modules.game_interface.startUseWith(item)
        end
      end)
    end
  end)

  refreshCursorUI()
end

