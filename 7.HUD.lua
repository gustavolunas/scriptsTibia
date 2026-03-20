switchHud = "hudButton"

UI.Separator()
if not storage[switchHud] then storage[switchHud] = { enabled = false } end

hudButton = setupUI([[
Panel
  height: 18
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: HUD
    height: 18
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
hudButton:setId(switchHud)
hudButton.title:setOn(storage[switchHud].enabled)

hudButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchHud].enabled = newState
end

HUD_PANEL_STORAGE = "hudInterfaceControl"
storage[HUD_PANEL_STORAGE] = storage[HUD_PANEL_STORAGE] or { switches = { barLifeMana  = false, timerImbuiment = false, pushMax = false, targetInfo = false }}
storage[HUD_PANEL_STORAGE].targetInfoPos = storage[HUD_PANEL_STORAGE].targetInfoPos or { x = 0, y = 0 }


local function getHudSwitchState(id)
  local st = storage[HUD_PANEL_STORAGE]
  st.switches = st.switches or {}
  if st.switches[id] == nil then st.switches[id] = false end
  return st.switches[id] == true
end

local function setHudSwitchState(id, value)
  local st = storage[HUD_PANEL_STORAGE]
  st.switches = st.switches or {}
  st.switches[id] = value == true
end

local function bindHudBotSwitch(root, id)
  if not root or type(root.recursiveGetChildById) ~= "function" then return end

  local w = root:recursiveGetChildById(id)
  if not w then return end

  w:setOn(getHudSwitchState(id))

  w.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    setHudSwitchState(id, newState)
  end
end

function applyHudSwitches(root)
  bindHudBotSwitch(root, "barLifeMana")
  bindHudBotSwitch(root, "timerImbuiment")
  bindHudBotSwitch(root, "timerMW")
  bindHudBotSwitch(root, "pushMax")
  bindHudBotSwitch(root, "targetInfo")
  bindHudBotSwitch(root, "targetHP")
  bindHudBotSwitch(root, "taskTracker")
  bindHudBotSwitch(root, "comboManager")
end

hudInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 260 280
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
    !text: tr('LNS Custom [HUD Control]')
    color: orange
    font: terminus-14px-bold
    margin-left: 0
    margin-right: 0
    background-color: black
    $hover:
      image-color: gray

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

  TextList
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 12
    margin-right: 20
    margin-left: 8
    height: 235
    image-color: #363636
    vertical-scrollbar: spellListScrollBar
    layout: verticalBox

    BotSwitch
      id: barLifeMana
      margin-top: 10
      margin-right: 5
      width: 25
      font: terminus-10px
      text: LIFE/MANA BAR EDITED
      image-source:
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: gray
        opacity: 0.80

    BotSwitch
      id: timerImbuiment
      margin-top: 10
      margin-right: 5
      width: 25
      font: terminus-10px
      text: TIMER IMBUIMENTS
      image-source:
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: gray
        opacity: 0.80

    BotSwitch
      id: pushMax
      margin-top: 10
      margin-right: 5
      width: 25
      font: terminus-10px
      text: PUSHMAX BUTTONS
      image-source:
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: gray
        opacity: 0.80

    BotSwitch
      id: targetInfo
      margin-top: 10
      margin-right: 5
      width: 25
      font: terminus-10px
      text: TARGET INFO
      image-source:
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: gray
        opacity: 0.80

    BotSwitch
      id: targetHP
      margin-top: 10
      margin-right: 5
      width: 25
      font: terminus-10px
      text: TARGET HP%
      image-source:
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: gray
        opacity: 0.80

    BotSwitch
      id: taskTracker
      margin-top: 10
      margin-right: 5
      width: 25
      font: terminus-10px
      text: TASK TRACKER
      image-source:
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: gray
        opacity: 0.80

    BotSwitch
      id: comboManager
      margin-top: 10
      margin-right: 5
      width: 25
      font: terminus-10px
      text: MANAGER ATTACKBOT
      image-source:
      $on:
        color: green
        opacity: 1.00
      $!on:
        color: gray
        opacity: 0.80
      
  VerticalScrollBar
    id: spellListScrollBar
    anchors.top: panelMain.top
    anchors.bottom: panelMain.bottom
    anchors.left: panelMain.right
    pixels-scroll: true
    image-color: #363636
    margin-top: 0
    margin-bottom: 0
    step: 10
]], g_ui.getRootWidget())

hudInterface:hide()
applyHudSwitches(hudInterface)

hudInterface.closePanel.onClick = function() hudInterface:hide() end

function buttonsHudPcMobile()
  if modules._G.g_app.isMobile() then
    hudButton.settings:show()
    hudButton.title:setMarginRight(55)
  else
    hudButton.settings:hide()
    hudButton.title:setMarginRight(0)
  end
end
buttonsHudPcMobile()

hudButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not hudInterface:isVisible() then
      hudInterface:show()
      hudInterface:raise();
      hudInterface:focus();
    else
      hudInterface:hide()
    end
  end
end

hudButton.settings.onClick = function()
  if not hudInterface:isVisible() then
    applyHudSwitches(hudInterface)
    hudInterface:show()
    hudInterface:raise()
    hudInterface:focus()
  end
end

-- =====================================
-- ============= LIFE BAR ==============
-- =====================================

local function isLifeManaEnabled()
  local st = storage[HUD_PANEL_STORAGE]
  if type(st) ~= "table" then return false end
  if type(st.switches) ~= "table" then return false end
  return st.switches.barLifeMana == true
end

local function hpColor(p)
  if p <= 35 then return "red" end
  return "red"
end

local function mpColor(p)
  if p <= 35 then return "#000099" end
  if p <= 75 then return "#3333CC" end
  return "#4D4DFF"
end


local HP_UI = [[
ProgressBar
  id: barHp
  anchors.centerIn: parent
  margin-top: -255
  margin-left: -20
  height: 11
  width: 320
  border: 1 black
  opacity: 0.60
  text-align: center
  background-color: red
]]

local MP_UI = [[
ProgressBar
  id: barMp
  anchors.centerIn: parent
  margin-top: -243
  margin-left: -20
  height: 11
  width: 240
  border: 1 black
  opacity: 0.60
  text-align: center
  background-color: blue
]]

local bars = { hp = nil, mp = nil }

local function ensureBars()
  if bars.hp and not bars.hp:isDestroyed() and bars.mp and not bars.mp:isDestroyed() then
    return
  end
  bars.hp = setupUI(HP_UI, g_ui.getRootWidget())
  bars.mp = setupUI(MP_UI, g_ui.getRootWidget())
  bars.hp:hide()
  bars.mp:hide()
end

local function setBarsVisible(v)
  ensureBars()
  if v then
    bars.hp:show()
    bars.mp:show()
  else
    bars.hp:hide()
    bars.mp:hide()
  end
end

local function updateBars()
  if not (bars.hp and bars.mp) then return end

  local hp = hppercent()
  local mp = manapercent()

  bars.hp:setPercent(hp)
  bars.hp:setText(string.format("HP: %d%%", hp))
  bars.hp:setBackgroundColor(hpColor(hp))

  bars.mp:setPercent(mp)
  bars.mp:setText(string.format("MP: %d%%", mp))
  bars.mp:setBackgroundColor(mpColor(mp))
end

macro(100, function()
  if not storage[switchHud].enabled then
    setBarsVisible(false)
    return
  end

  local enabled = isLifeManaEnabled()
  setBarsVisible(enabled)
  if not enabled then return end

  updateBars()
end)

-- =====================================
-- =========== TARGET INFO =============
-- =====================================
local function hudMasterOn()
  return storage.hudButton and storage.hudButton.enabled == true
end

local function targetInfoOn()
  local st = storage[HUD_PANEL_STORAGE]
  return st and st.switches and st.switches.targetInfo == true
end

local function targetHPOn()
  local st = storage[HUD_PANEL_STORAGE]
  return st and st.switches and st.switches.targetHP == true
end

-- =========================
-- UI (IMAGEM + TEXTOS)
-- =========================
local targetUI = setupUI([[
UIWindow
  id: targetInfoHUD
  anchors.centerIn: parent
  height: 52
  width: 210
  opacity: 1.00
  padding: 4

  UICreature
    id: targetSprite
    width: 70
    height: 80
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: -10
    margin-top: -10

  Label
    id: line1
    anchors.left: targetSprite.right
    anchors.right: parent.right
    anchors.top: parent.top
    margin-left: 6
    margin-top: 4
    font: verdana-11px-rounded
    color: white
    text: "TARGET: -"

  Label
    id: line2
    anchors.left: line1.left
    anchors.right: line1.right
    anchors.top: line1.bottom
    margin-top: 1
    font: verdana-11px-rounded
    color: white
    text: "HP: -"

  Label
    id: line3
    anchors.left: line1.left
    anchors.right: line1.right
    anchors.top: line2.bottom
    margin-top: 1
    font: verdana-11px-rounded
    color: white
    text: "DIST: -"
]], g_ui.getRootWidget())
targetUI:hide()

-- =========================
-- MOVE KEY (CTRL PC / F2 Mobile)
-- =========================
local function isMoveKeyPressed()
  if g_app and type(g_app.isMobile) == "function" and g_app:isMobile() then
    return g_keyboard and g_keyboard.isKeyPressed and g_keyboard.isKeyPressed("F2")
  end
  return g_keyboard and g_keyboard.isCtrlPressed and g_keyboard.isCtrlPressed()
end

-- =========================
-- POS SAVE/LOAD + DRAG
-- =========================
local function applyTargetPos()
  local st = storage[HUD_PANEL_STORAGE]
  local p = st and st.targetInfoPos

  targetUI:breakAnchors()

  -- se não tem posição salva (ou está zerada), centraliza igual as barras
  if not p or not p.x or not p.y or (p.x == 0 and p.y == 0) then
    targetUI:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
    targetUI:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
    return
  end

  targetUI:setPosition({ x = p.x, y = p.y })
end

local function saveTargetPos()
  local p = targetUI:getPosition()
  if not p then return end
  storage[HUD_PANEL_STORAGE].targetInfoPos = { x = p.x, y = p.y }
end

local function disableDrag()
  targetUI.onDragEnter = nil
  targetUI.onDragMove  = nil
  targetUI:setFocusable(false)
  targetUI:setPhantom(true)
  targetUI:setDraggable(false)
  targetUI:setOpacity(1.00)
end

local function enableDrag()
  targetUI:setFocusable(true)
  targetUI:setPhantom(false)
  targetUI:setDraggable(true)
  targetUI:setOpacity(1.00)

  targetUI.onDragEnter = function(widget, mousePos)
    widget:breakAnchors()
    widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
    return true
  end

  targetUI.onDragMove = function(widget, mousePos, moved)
    local parent = widget:getParent()
    if not parent or not parent.getRect then return true end
    local r = parent:getRect()

    local ref = widget.movingReference or { x = 0, y = 0 }
    local x = mousePos.x - ref.x
    local y = mousePos.y - ref.y

    x = math.min(math.max(r.x, x), r.x + r.width  - widget:getWidth())
    y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

    widget:move(x, y)
    storage[HUD_PANEL_STORAGE].targetInfoPos = { x = x, y = y }
    return true
  end
end

applyTargetPos()
disableDrag()

-- =========================
-- DIST (SQM)
-- =========================
local function sqmDistance(a, b)
  if not a or not b then return 0 end
  local dx = math.abs((a.x or 0) - (b.x or 0))
  local dy = math.abs((a.y or 0) - (b.y or 0))
  return math.max(dx, dy)
end

-- =========================
-- LOOP (SHOW/HIDE + UPDATE)
-- =========================
local lastPressed = nil

macro(100, function()
  if not g_game.isAttacking() then targetUI:hide() return end
  if not hudMasterOn() or not targetInfoOn() then
    if targetUI:isVisible() then targetUI:hide() end
    return
  end

  if not targetUI:isVisible() then targetUI:show() end

  -- drag control
  local pressed = isMoveKeyPressed()
  if pressed ~= lastPressed then
    if pressed then enableDrag() else disableDrag() end
    lastPressed = pressed
  end
  saveTargetPos()

  local t = g_game and g_game.getAttackingCreature and g_game.getAttackingCreature() or nil
  if not t then
    targetUI.targetSprite:setOutfit({}) -- limpa sprite
    targetUI.line1:setText("TARGET: -")
    targetUI.line2:setText("HP: -")
    targetUI.line3:setText("DIST: -")
    return
  end

  -- imagem do target
  if t.getOutfit then
    targetUI.targetSprite:setOutfit(t:getOutfit())
  end

  local name = (t.getName and t:getName()) or "-"
  local hp = (t.getHealthPercent and t:getHealthPercent()) or 0

  local myPos = pos and pos() or nil
  local tPos  = (t.getPosition and t:getPosition()) or nil
  local dist = sqmDistance(myPos, tPos)

  targetUI.line1:setText("TARGET: " .. name)
  targetUI.line2:setText(string.format("HP: %d%%", hp))
  targetUI.line3:setText(string.format("DIST: %d SQM", dist))
end)

-- =====================================
-- =========== TARGET HP% SAFE =========
-- (não apaga texto do vBot Check Players)
-- =====================================

local lastTargetId = 0

macro(200, function()
  if not hudMasterOn() or not targetHPOn() then
    -- se tinha um target antigo com texto nosso, limpa só ele
    if lastTargetId ~= 0 then
      local specs = getSpectators(false)
      for i = 1, #specs do
        local c = specs[i]
        if c and c.getId and c:getId() == lastTargetId then
          c:clearText()
          break
        end
      end
      lastTargetId = 0
    end
    return
  end

  local target = g_game.getAttackingCreature()
  if not target then
    -- sem target: limpa só o último target
    if lastTargetId ~= 0 then
      local specs = getSpectators(false)
      for i = 1, #specs do
        local c = specs[i]
        if c and c.getId and c:getId() == lastTargetId then
          c:clearText()
          break
        end
      end
      lastTargetId = 0
    end
    return
  end

  local tid = target:getId()

  -- trocou de target: limpa o texto do target antigo (somente ele)
  if lastTargetId ~= 0 and lastTargetId ~= tid then
    local specs = getSpectators(false)
    for i = 1, #specs do
      local c = specs[i]
      if c and c.getId and c:getId() == lastTargetId then
        c:clearText()
        break
      end
    end
  end

  lastTargetId = tid

  local hp = target:getHealthPercent()
  if not hp then return end

  local color
  if hp > 66 then
    color = "green"
  elseif hp > 33 then
    color = "yellow"
  else
    color = "red"
  end

  -- seta texto SÓ no target
  target:setText(hp .. "%", color)
end)

-- =====================================
-- =========== TASK TRACKE =============
-- =====================================
macro(250, function()
  if not hudMasterOn() or not (storage[HUD_PANEL_STORAGE] and storage[HUD_PANEL_STORAGE].switches and storage[HUD_PANEL_STORAGE].switches.taskTracker) then
    taskInterface:hide()
    return
  end
  if hudMasterOn() and (storage[HUD_PANEL_STORAGE] and storage[HUD_PANEL_STORAGE].switches and storage[HUD_PANEL_STORAGE].switches.taskTracker) then
    taskInterface:show()
    return
  end
end)

macro(250, function()
  if not hudMasterOn() or not (storage[HUD_PANEL_STORAGE] and storage[HUD_PANEL_STORAGE].switches and storage[HUD_PANEL_STORAGE].switches.comboManager) then
    comboSetupInterface:hide()
    return
  end
  if hudMasterOn() and (storage[HUD_PANEL_STORAGE] and storage[HUD_PANEL_STORAGE].switches and storage[HUD_PANEL_STORAGE].switches.comboManager) then
    comboSetupInterface:show()
    return
  end
end)