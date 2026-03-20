setDefaultTab("Tools")

UI.Separator()

switchPrey = "preyButton"

storage[switchPrey] = storage[switchPrey] or { enabled = false }
preyButton = setupUI([[
Panel
  height: 33
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: AUTO PREY
    font: verdana-9px
    color: white
    image-source: /images/ui/button_rounded
    tooltip: Verifica prey a cada 5 minutos
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

  Button
    id: manual
    anchors.top: title.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    margin-right: 0
    height: 15
    text: MANUAL PREY
    margin-top: 1
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #363636
    color: orange
    $hover:
      opacity: 0.95

  
]])
preyButton:setId(switchPrey)
preyButton.title:setOn(storage[switchPrey].enabled)

preyButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchPrey].enabled = newState
end

preyInterface = setupUI([=[
UIWindow
  id: mainPanel
  size: 542 340
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
    text: LNS Custom | Prey Reroll
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
    id: iconPanel
    anchors.top: parent.top
    anchors.left: parent.left
    size: 60 60
    margin-top: -19
    margin-left: -15

  Panel
    id: infoPreyList1
    anchors.top: prev.bottom
    anchors.left: parent.left
    width: 170
    height: 18
    margin-left: 5
    color: yellow
    text: "PREY LIST [1]"
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f
    color: orange

  TextList
    id: panelPreyList1
    anchors.top: prev.bottom
    anchors.right: prev.right
    anchors.left: prev.left
    margin-right: 10
    margin-top: 2
    height: 180
    image-color: gray
    opacity: 0.95
    border: 1 black
    vertical-scrollbar: prey1Scroll

  VerticalScrollBar
    id: prey1Scroll
    anchors.top: panelPreyList1.top
    anchors.bottom: panelPreyList1.bottom
    anchors.left: panelPreyList1.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    image-color: #2f2f2f
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirMobName1
    anchors.top: panelPreyList1.bottom
    anchors.left: panelPreyList1.left
    width: 140
    margin-top: 2
    color: yellow
    image-color: #2f2f2f
    font: verdana-9px
    placeholder: INSERT MOB NAME!
    placeholder-font: verdana-9px
  
  Button
    id: buttonAdd
    anchors.top: prev.top
    anchors.right: prey1Scroll.right
    anchors.left: prev.right
    margin-left: 2
    text: +
    font: sans-bold-16px
    image-source: /images/ui/button_rounded
    image-color: #363636

  VerticalSeparator
    id: vertsep
    anchors.top: infoPreyList1.top
    anchors.left: infoPreyList1.right
    margin-left: 5
    anchors.bottom: buttonAdd.bottom

  Panel
    id: panelprey2
    anchors.top: prev.top
    anchors.left: prev.right
    width: 170
    height: 18
    margin-left: 5
    color: yellow
    text: PREY LIST [2]
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f
    color: orange

  TextList
    id: panelPreyList2
    anchors.top: prev.bottom
    anchors.right: prev.right
    anchors.left: prev.left
    margin-top: 2
    margin-right: 10
    height: 180
    image-color: gray
    opacity: 0.95
    border: 1 black
    vertical-scrollbar: prey2Scroll

  VerticalScrollBar
    id: prey2Scroll
    anchors.top: panelPreyList2.top
    anchors.bottom: panelPreyList2.bottom
    anchors.left: panelPreyList2.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    image-color: #2f2f2f
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirMobName2
    anchors.top: panelPreyList2.bottom
    anchors.left: panelPreyList2.left
    width: 140
    margin-top: 2
    color: yellow
    image-color: #2f2f2f
    font: verdana-9px
    placeholder: INSERT MOB NAME!
    placeholder-font: verdana-9px
  
  Button
    id: buttonAdd2
    anchors.top: prev.top
    anchors.right: prey2Scroll.right
    anchors.left: prev.right
    margin-left: 2
    text: +
    font: sans-bold-16px
    image-source: /images/ui/button_rounded
    image-color: #363636

  VerticalSeparator
    id: vertsep2
    anchors.top: panelprey2.top
    anchors.left: panelprey2.right
    margin-left: 5
    anchors.bottom: buttonAdd.bottom

  Panel
    id: panelprey3
    anchors.top: prev.top
    anchors.left: prev.right
    width: 170
    height: 18
    margin-left: 5
    color: yellow
    text: PREY LIST [3]
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f
    color: orange

  TextList
    id: panelPreyList3
    anchors.top: prev.bottom
    anchors.right: prev.right
    anchors.left: prev.left
    margin-top: 2
    margin-right: 10
    height: 180
    image-color: gray
    opacity: 0.95
    border: 1 black
    vertical-scrollbar: prey3Scroll

  VerticalScrollBar
    id: prey3Scroll
    anchors.top: panelPreyList3.top
    anchors.bottom: panelPreyList3.bottom
    anchors.left: panelPreyList3.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    image-color: #2f2f2f
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirMobName3
    anchors.top: panelPreyList3.bottom
    anchors.left: panelPreyList3.left
    width: 140
    margin-top: 2
    color: yellow
    image-color: #2f2f2f
    font: verdana-9px
    placeholder: INSERT MOB NAME!
    placeholder-font: verdana-9px
  
  Button
    id: buttonAdd3
    anchors.top: prev.top
    anchors.right: prey3Scroll.right
    anchors.left: prev.right
    margin-left: 2
    text: +
    font: sans-bold-16px
    image-source: /images/ui/button_rounded
    image-color: #363636

  UIWidget
    id: ativarPrey1
    anchors.top: prev.bottom
    margin-top: 5
    anchors.left: infoPreyList1.left
    size: 35 30
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey1
    anchors.left: ativarPrey1.right
    anchors.verticalCenter: ativarPrey1.verticalCenter
    font: verdana-9px
    margin-left: 5
    text: "AUTO-REROLL (OFF)"
    color: #d7c08a
    text-auto-resize: true

  UIWidget
    id: ativarPrey2
    anchors.top: ativarPrey1.top
    anchors.left: panelprey2.left
    size: 35 30
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey2
    anchors.left: ativarPrey2.right
    anchors.verticalCenter: ativarPrey2.verticalCenter
    font: verdana-9px
    margin-left: 5
    text: "AUTO-REROLL (OFF)"
    color: #d7c08a
    text-auto-resize: true

  UIWidget
    id: ativarPrey3
    anchors.top: ativarPrey1.top
    anchors.left: panelprey3.left
    size: 35 30
    image-source: /images/game/prey/prey_select_blocked

  Label
    id: labelPrey3
    anchors.left: ativarPrey3.right
    anchors.verticalCenter: ativarPrey3.verticalCenter
    font: verdana-9px
    margin-left: 5
    text: "AUTO-REROLL (OFF)"
    color: #d7c08a
    text-auto-resize: true

  Panel
    id: fundoconfigsprey
    anchors.top: prev.bottom
    anchors.left: infoPreyList1.left
    anchors.right: prey3Scroll.right
    width: 180
    height: 25
    margin-top: 20
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f
      
  Label
    id: labelMaxRetries
    anchors.verticalCenter: fundoconfigsprey.verticalCenter
    anchors.left: prev.left
    margin-left: 5
    text: MAX RETRIES:
    font: verdana-9px
    color: gray
    text-auto-resize: true

  SpinBox
    id: maxRetriesPrey
    anchors.verticalCenter: fundoconfigsprey.verticalCenter
    anchors.left: prev.right
    margin-left: 5
    height: 19
    image-color: #2f2f2f
    font: verdana-9px
    text-align: center
    minimum: 0
    maximum: 100
    step: 1
    
  VerticalSeparator
    id: sepp
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    anchors.left: prev.right
    margin-left: 5

  Label
    id: labelDelayRetries
    anchors.verticalCenter: fundoconfigsprey.verticalCenter
    anchors.left: prev.right
    margin-left: 5
    text: DELAY ENTRE RETRIES:
    font: verdana-9px
    color: gray
    text-auto-resize: true

  HorizontalScrollBar
    id: delayRetries
    anchors.verticalCenter: fundoconfigsprey.verticalCenter
    anchors.right: fundoconfigsprey.right
    margin-right: 5
    height: 13
    image-color: gray
    anchors.left: prev.right
    margin-left: 5
    minimum: 0
    maximum: 5000
    step: 100

  Label
    id: delayMsValue
    anchors.verticalCenter: delayRetries.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text-align: center
    text: 0ms
    font: verdana-9px
    color: orange
    text-auto-resize: true
]=], g_ui.getRootWidget())
preyInterface:hide()

preyButton.settings.onClick = function()
  preyInterface:show()
end

function buttonsPreyPcMobile()
  if modules._G.g_app.isMobile() then
    preyButton.settings:show()
    preyButton.title:setMarginRight(55)
  else
    preyButton.settings:hide()
    preyButton.title:setMarginRight(0)
  end
end
buttonsPreyPcMobile()

preyButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not preyInterface:isVisible() then
      preyInterface:show()
      preyInterface:raise();
      preyInterface:focus();
    else
      preyInterface:hide()
    end
  end
end

storage = storage or {}
local STKEY = "lnsPreyRerollPanel"

storage[STKEY] = storage[STKEY] or {
  lists = { [1] = {}, [2] = {}, [3] = {} },
  enabled = { [1] = false, [2] = false, [3] = false },
  delayMs = 400,
  maxRetries = 15,
  slotSelected = { [1] = false, [2] = false, [3] = false } -- (sempre 1..3)
}
local st = storage[STKEY]
st.lists = st.lists or { [1] = {}, [2] = {}, [3] = {} }
st.enabled = st.enabled or { [1] = false, [2] = false, [3] = false }
st.delayMs = tonumber(st.delayMs) or 400
st.maxRetries = tonumber(st.maxRetries) or 15
st.slotSelected = st.slotSelected or { [1] = false, [2] = false, [3] = false }

local manualRun = false
local manualAutoHide = false

local function slotKey(slotIndex)
  return (tonumber(slotIndex) or 0) + 1 -- 0..2 -> 1..3
end

-- =========================
-- Utils (iguais padrão Travel)
-- =========================
local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("%s+", " ")
  return trim(s)
end

local function sameText(a, b)
  return normalizeText(a) == normalizeText(b)
end

local function capitalizeEachWord(str)
  return tostring(str or ""):gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper() .. rest:lower()
  end)
end

local function mobExists(list, mobName)
  for _, v in ipairs(list) do
    if sameText(v, mobName) then return true end
  end
  return false
end

local function addMob(listIndex, mobName)
  mobName = trim(mobName)
  if mobName == "" then return false end

  st.lists[listIndex] = st.lists[listIndex] or {}
  local list = st.lists[listIndex]

  local pretty = capitalizeEachWord(mobName)
  if mobExists(list, pretty) then return false end

  table.insert(list, pretty)
  return true
end

local function removeMob(listIndex, mobName)
  st.lists[listIndex] = st.lists[listIndex] or {}
  local list = st.lists[listIndex]
  for i = #list, 1, -1 do
    if sameText(list[i], mobName) then
      table.remove(list, i)
    end
  end
end

local function sortList(list)
  table.sort(list, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
end

-- =========================
-- Row Template (igual o Travel, com botão X)
-- =========================
local mobRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: false
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  Label
    id: mobName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-9px
    color: white
    text: ""

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: X
    color: #FF4040
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

-- =========================
-- UI References (seguras)
-- =========================
local function getListWidget(i)
  if i == 1 then return preyInterface.panelPreyList1 end
  if i == 2 then return preyInterface.panelPreyList2 end
  if i == 3 then return preyInterface.panelPreyList3 end
  return nil
end

local function getEditWidget(i)
  if i == 1 then return preyInterface.inserirMobName1 end
  if i == 2 then return preyInterface.inserirMobName2 end
  if i == 3 then return preyInterface.inserirMobName3 end
  return nil
end

local function getAddButton(i)
  if i == 1 then return preyInterface.buttonAdd end
  if i == 2 then return preyInterface.buttonAdd2 end
  if i == 3 then return preyInterface.buttonAdd3 end
  return nil
end

-- =========================
-- Refresh de cada lista
-- =========================
local function refreshMobList(listIndex)
  local listW = getListWidget(listIndex)
  if not listW then return end

  if listW.destroyChildren then listW:destroyChildren() end

  st.lists[listIndex] = st.lists[listIndex] or {}
  local arr = st.lists[listIndex]
  sortList(arr)

  for _, mobName in ipairs(arr) do
    local row = g_ui.loadUIFromString(mobRowTemplate, listW)
    row.mobName:setText(mobName)

    row.remove.onClick = function()
      removeMob(listIndex, mobName)
      refreshMobList(listIndex)
    end
  end
end

local function bindAddButton(listIndex)
  local btn = getAddButton(listIndex)
  local edit = getEditWidget(listIndex)
  if not btn or not edit then return end

  btn.onClick = function()
    local name = edit:getText() or ""
    name = trim(name)
    if name == "" then return end

    local ok = addMob(listIndex, name)
    edit:setText("")
    if ok then
      refreshMobList(listIndex)
    end
  end
end

-- =========================
-- Delay label "1000ms" + ScrollBar + SpinBox
-- =========================
local function applyDelayLabel()
  if preyInterface.delayMsValue and preyInterface.delayMsValue.setText then
    preyInterface.delayMsValue:setText(tostring(math.floor(st.delayMs)) .. "ms")
  end
end

local function clamp(n, a, b)
  n = tonumber(n) or a
  if n < a then return a end
  if n > b then return b end
  return n
end

if preyInterface.delayRetries then
  if preyInterface.delayRetries.setValue then
    preyInterface.delayRetries:setValue(clamp(st.delayMs, 0, 5000))
  end
  applyDelayLabel()

  preyInterface.delayRetries.onValueChange = function(_, value)
    st.delayMs = clamp(value, 0, 5000)
    applyDelayLabel()
  end
end

if preyInterface.maxRetriesPrey then
  if preyInterface.maxRetriesPrey.setValue then
    preyInterface.maxRetriesPrey:setValue(clamp(st.maxRetries, 0, 100))
  end

  preyInterface.maxRetriesPrey.onValueChange = function(_, value)
    st.maxRetries = clamp(value, 0, 100)
  end
end

-- =========================
-- UIWidget -> BotSwitch persistente
-- =========================
local function applySwitchUI(i)
  local w, lbl
  if i == 1 then w, lbl = preyInterface.ativarPrey1, preyInterface.labelPrey1 end
  if i == 2 then w, lbl = preyInterface.ativarPrey2, preyInterface.labelPrey2 end
  if i == 3 then w, lbl = preyInterface.ativarPrey3, preyInterface.labelPrey3 end
  if not w or not lbl then return end

  local on = st.enabled[i] == true
  if on then
    w:setImageSource("/images/game/prey/prey_select")
    lbl:setText("AUTO-REROLL (ON)")
  else
    w:setImageSource("/images/game/prey/prey_select_blocked")
    lbl:setText("AUTO-REROLL (OFF)")
  end
end

local function bindSwitch(i)
  local w
  if i == 1 then w = preyInterface.ativarPrey1 end
  if i == 2 then w = preyInterface.ativarPrey2 end
  if i == 3 then w = preyInterface.ativarPrey3 end
  if not w then return end

  w.onClick = function()
    st.enabled[i] = not (st.enabled[i] == true)
    applySwitchUI(i)
  end
end

if preyInterface.closePanel then
  preyInterface.closePanel.onClick = function()
    preyInterface:hide()
  end
end

for i = 1, 3 do
  refreshMobList(i)
  bindAddButton(i)
  bindSwitch(i)
  applySwitchUI(i)
end
applyDelayLabel()

-- =========================
-- Utils
-- =========================
local PREY_ACTION_LISTREROLL       = 0
local PREY_ACTION_MONSTERSELECTION = 2

local function later(ms, fn)
  if type(schedule) == "function" then return schedule(ms, fn) end
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  return fn()
end

local function trim2(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeText2(s)
  s = tostring(s or ""):lower()
  s = s:gsub("%s+", " ")
  return trim2(s)
end

local function sameText2(a, b)
  return normalizeText2(a) == normalizeText2(b)
end

local function capitalizeEachWord2(str)
  return tostring(str or ""):gsub("(%a)([%w_']*)", function(first, rest)
    return first:upper()..rest:lower()
  end)
end

-- =========================
-- GATES
-- =========================
local function mainEnabled()
  if manualRun == true then return true end
  return storage[switchPrey] and storage[switchPrey].enabled == true
end

local function slotEnabled(slotIndex)
  if not mainEnabled() then return false end
  if not st or not st.enabled then return false end
  local li = slotIndex + 1
  return st.enabled[li] == true
end

local function getDesiredMobsForSlot(slotIndex)
  if not st or not st.lists then return {} end
  local li = slotIndex + 1
  local list = st.lists[li]
  if type(list) ~= "table" then return {} end
  return list
end

local function listHasDesired(list, name)
  if type(list) ~= "table" then return false end
  for _, d in ipairs(list) do
    if sameText2(d, name) then return true end
  end
  return false
end

-- =========================
-- UI access (ROBUSTO + CACHE)
-- =========================
local preyWindow = nil

local function resolvePreyWindow()
  if preyWindow and not preyWindow:isDestroyed() then return preyWindow end
  local root = g_ui.getRootWidget()
  if not root then return nil end

  local w =
    (root.recursiveGetChildById and root:recursiveGetChildById("preyWindow")) or
    (root.recursiveGetChildById and root:recursiveGetChildById("prey")) or
    (root.recursiveGetChildById and root:recursiveGetChildById("Prey")) or
    nil

  preyWindow = w
  return preyWindow
end

local function safeGetPreyWidgets(slotIndex)
  local w = resolvePreyWindow()
  if not w or w:isDestroyed() then
    return nil
  end

  local prey = w["slot" .. (slotIndex + 1)]
  if not prey or prey:isDestroyed() then return nil end

  if not prey.inactive or prey.inactive:isDestroyed() then
    st.slotSelected[slotKey(slotIndex)] = true
    return "ACTIVE"
  end

  local list = prey.inactive.list
  if not list or list:isDestroyed() then
    st.slotSelected[slotKey(slotIndex)] = true
    return "ACTIVE"
  end

  local btn = prey.inactive.choose and prey.inactive.choose.choosePreyButton
  if not btn or btn:isDestroyed() then
    st.slotSelected[slotKey(slotIndex)] = true
    return "ACTIVE"
  end

  st.slotSelected[slotKey(slotIndex)] = false
  return prey, list, btn
end

local function slotAlreadySelected(slotIndex)
  local r = safeGetPreyWidgets(slotIndex)
  if r == "ACTIVE" then return true end
  if r == nil then
    return st.slotSelected[slotKey(slotIndex)] == true
  end
  return false
end

local function uiSelectAndConfirm(slotIndex, desiredName, desiredIdxFallback)
  local prey, list, btn = safeGetPreyWidgets(slotIndex)

  if prey == "ACTIVE" then
    return "SKIP"
  end

  if not prey then
    if desiredIdxFallback ~= nil then
      g_game.preyAction(slotIndex, PREY_ACTION_MONSTERSELECTION, desiredIdxFallback)
      st.slotSelected[slotKey(slotIndex)] = true
      return true
    end
    return false
  end

  local children = list:getChildren() or {}
  local foundPos = nil

  for i, child in ipairs(children) do
    if child.setChecked then child:setChecked(false) end
    local tip = child.getTooltip and child:getTooltip() or ""
    if tip ~= "" and sameText2(tip, desiredName) then
      foundPos = i
    end
  end

  if not foundPos then
    if desiredIdxFallback ~= nil and children[desiredIdxFallback + 1] then
      foundPos = desiredIdxFallback + 1
    end
  end

  if not foundPos then
    return false
  end

  local target = children[foundPos]
  if target and target.setChecked then target:setChecked(true) end

  if btn.onClick then
    btn.onClick()
    st.slotSelected[slotKey(slotIndex)] = true
    print(string.format("[Prey] Slot %d: Confirmado '%s'", slotIndex, capitalizeEachWord2(desiredName)))
    return true
  end

  g_game.preyAction(slotIndex, PREY_ACTION_MONSTERSELECTION, foundPos - 1)
  st.slotSelected[slotKey(slotIndex)] = true
  return true
end

local function trySelectFromCurrentUI(slotIndex)
  local desiredList = getDesiredMobsForSlot(slotIndex)
  if #desiredList == 0 then return false end

  local prey, list, btn = safeGetPreyWidgets(slotIndex)
  if prey == "ACTIVE" then
    return "SKIP"
  end
  if not prey then return false end

  local children = list:getChildren() or {}
  for i, child in ipairs(children) do
    local tip = child.getTooltip and child:getTooltip() or ""
    if tip ~= "" and listHasDesired(desiredList, tip) then
      local ok = uiSelectAndConfirm(slotIndex, tip, i - 1)
      return ok
    end
  end

  return false
end

local function findDesiredMob(names, desiredList)
  if type(names) ~= "table" then return nil end
  for i, name in ipairs(names) do
    if name and name ~= "" and listHasDesired(desiredList, name) then
      return i, name
    end
  end
  return nil
end

-- =========================
-- Engine (sequencial 0->1->2)
-- =========================
local scheduleDelay = 400
local maxRerolls = 15

local slot = nil
local rerollCount = 0
local isLocked = false

local running = false
local connected = false
local cycleDone = false
local doneKey = ""
local runToken = 0

local function refreshConfig()
  scheduleDelay = tonumber(st and st.delayMs) or 400
  maxRerolls = tonumber(st and st.maxRetries) or 15
  if scheduleDelay < 0 then scheduleDelay = 0 end
  if maxRerolls < 0 then maxRerolls = 0 end
end

local function buildCycleKey()
  local parts = {}

  parts[#parts+1] = mainEnabled() and "M1" or "M0"
  for s = 0, 2 do
    parts[#parts+1] = slotEnabled(s) and ("S" .. s .. "1") or ("S" .. s .. "0")
  end

  parts[#parts+1] = "D" .. tostring(tonumber(st and st.delayMs) or 0)
  parts[#parts+1] = "R" .. tostring(tonumber(st and st.maxRetries) or 0)

  for s = 0, 2 do
    local list = getDesiredMobsForSlot(s)
    parts[#parts+1] = "L" .. s .. ":" .. tostring(#list)
    for i = 1, #list do
      parts[#parts+1] = normalizeText2(list[i])
    end
  end

  return table.concat(parts, "|")
end

local function connectEvents()
  if connected then return end
  if not modules or not modules.game_bot then return end
  modules.game_bot.connect(g_game, { onPreySelection = onPreySelection })
  connected = true
end

local function stopAll()
  running = false
  isLocked = false
  slot = nil
  rerollCount = 0
  runToken = runToken + 1

  cycleDone = true
  doneKey = buildCycleKey()

  if manualRun == true and manualAutoHide == true then
    local tok = runToken
    later(80, function()
      if tok ~= runToken then return end
      if modules and modules.game_prey and modules.game_prey.hide then
        modules.game_prey.hide()
      end
    end)
  end

  manualRun = false
  manualAutoHide = false
end

local function nextEnabledSlot(fromSlot)
  for s = (fromSlot or -1) + 1, 2 do
    if slotEnabled(s) then return s end
  end
  return nil
end

local function finishAndGoNext()
  runToken = runToken + 1

  local next = nextEnabledSlot(slot)
  if not next then
    stopAll()
    return
  end

  slot = next
  rerollCount = 0
  isLocked = true
  refreshConfig()

  if modules and modules.game_prey and modules.game_prey.show then
    modules.game_prey.show()
  end

  local myToken = runToken

  later(150, function()
    if myToken ~= runToken then return end
    if not running or not mainEnabled() then return stopAll() end
    if not slotEnabled(slot) then isLocked = false return finishAndGoNext() end

    if slotAlreadySelected(slot) then
      print(string.format("[Prey] Slot %d já está selecionado. Pulando.", slot))
      isLocked = false
      return finishAndGoNext()
    end

    local ok = trySelectFromCurrentUI(slot)
    if ok == "SKIP" then
      isLocked = false
      return finishAndGoNext()
    end
    if ok == true then
      isLocked = false
      return finishAndGoNext()
    end

    st.slotSelected[slotKey(slot)] = false
    g_game.preyAction(slot, PREY_ACTION_LISTREROLL, 0)
  end)
end

local function performReroll(myToken)
  if myToken ~= runToken then return end
  if slot == nil then return end
  if not isLocked then return end

  if slotAlreadySelected(slot) then
    isLocked = false
    return finishAndGoNext()
  end

  if rerollCount >= maxRerolls then
    print(string.format("[Prey] Slot %d: Max retries %d atingido. Pulando.", slot, maxRerolls))
    isLocked = false
    return finishAndGoNext()
  end

  rerollCount = rerollCount + 1
  st.slotSelected[slotKey(slot)] = false
  g_game.preyAction(slot, PREY_ACTION_LISTREROLL, 0)
end

function onPreySelection(evSlot, bonusType, bonusValue, bonusGrade, names, outfits, timeUntilFreeReroll)
  if slot == nil then return end
  if evSlot ~= slot then return end
  if not isLocked then return end
  if not running then return end

  if not mainEnabled() then
    return stopAll()
  end

  if not slotEnabled(slot) then
    isLocked = false
    return finishAndGoNext()
  end

  if slotAlreadySelected(slot) then
    isLocked = false
    return finishAndGoNext()
  end

  local desiredList = getDesiredMobsForSlot(slot)
  if #desiredList == 0 then
    isLocked = false
    return finishAndGoNext()
  end

  local myToken = runToken

  local index, foundName = findDesiredMob(names, desiredList)
  if index then
    isLocked = false
    local idx0 = index - 1

    later(120, function()
      if myToken ~= runToken then return end
      if not running or not mainEnabled() then return stopAll() end
      if not slotEnabled(slot) then return finishAndGoNext() end
      if slotAlreadySelected(slot) then return finishAndGoNext() end

      local ok = uiSelectAndConfirm(slot, foundName, idx0)
      if ok == "SKIP" then
        return finishAndGoNext()
      end
      if ok == true then
        return finishAndGoNext()
      end

      isLocked = true
      later(scheduleDelay, function()
        performReroll(myToken)
      end)
    end)
    return
  end

  later(scheduleDelay, function()
    performReroll(myToken)
  end)
end

local function startSequence()
  if running then return end
  if not mainEnabled() then return end

  local key = buildCycleKey()
  if cycleDone and doneKey == key then
    return
  end

  cycleDone = false
  doneKey = ""

  connectEvents()
  refreshConfig()

  local first = nextEnabledSlot(-1)
  if not first then return end

  running = true
  slot = first
  rerollCount = 0
  isLocked = true
  runToken = runToken + 1

  if modules and modules.game_prey and modules.game_prey.show then
    modules.game_prey.show()
  end

  local myToken = runToken
  later(150, function()
    if myToken ~= runToken then return end
    if not running or not mainEnabled() then return stopAll() end
    if not slotEnabled(slot) then isLocked=false; return finishAndGoNext() end

    if slotAlreadySelected(slot) then
      isLocked = false
      return finishAndGoNext()
    end

    local ok = trySelectFromCurrentUI(slot)
    if ok == "SKIP" then
      isLocked = false
      return finishAndGoNext()
    end
    if ok == true then
      isLocked = false
      return finishAndGoNext()
    end

    st.slotSelected[slotKey(slot)] = false
    g_game.preyAction(slot, PREY_ACTION_LISTREROLL, 0)
  end)
end

local RECHECK_MS = 5 * 60 * 1000
local nextRecheckAt = 0

local function nowMillis()
  if g_clock and type(g_clock.millis) == "function" then
    return g_clock.millis()
  end
  if g_clock and type(g_clock.seconds) == "function" then
    return math.floor(g_clock.seconds() * 1000)
  end
  return os.time() * 1000
end

macro(250, function()
  local now = nowMillis()

  if not mainEnabled() then
    cycleDone = false
    doneKey = ""
    nextRecheckAt = 0
    stopAll()
    return
  end

  if not (slotEnabled(0) or slotEnabled(1) or slotEnabled(2)) then
    cycleDone = false
    doneKey = ""
    nextRecheckAt = 0
    stopAll()
    return
  end

  local key = buildCycleKey()
  if cycleDone and doneKey ~= key then
    cycleDone = false
    doneKey = ""
    nextRecheckAt = 0
  end

  if (not running) and cycleDone and doneKey == key then
    if modules and modules.game_prey then
      modules.game_prey:hide()
    end

    if nextRecheckAt == 0 then
      nextRecheckAt = now + RECHECK_MS
    end

    if now < nextRecheckAt then
      return
    end

    cycleDone = false
    doneKey = ""
    nextRecheckAt = 0
  end

  if running then
    refreshConfig()
    if slot ~= nil and (not slotEnabled(slot)) then
      isLocked = false
      finishAndGoNext()
    end
    return
  end

  startSequence()
end)

preyButton.manual.onClick = function()
  manualRun = true
  manualAutoHide = true

  if not (slotEnabled(0) or slotEnabled(1) or slotEnabled(2)) then
    cycleDone = false
    doneKey = ""
    stopAll()
    return
  end

  local key = buildCycleKey()
  if cycleDone and doneKey ~= key then
    cycleDone = false
    doneKey = ""
  end

  if running then
    refreshConfig()
    if slot ~= nil and (not slotEnabled(slot)) then
      isLocked = false
      finishAndGoNext()
    end
    return
  end

  if not running and cycleDone and doneKey == key then
    if modules and modules.game_prey and modules.game_prey.hide then
      modules.game_prey.hide()
    end
    manualRun = false
    manualAutoHide = false
    return
  end
  startSequence()
end

UI.Separator()