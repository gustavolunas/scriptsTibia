setDefaultTab("Tools")

local panelName = "imbuimentSystem"

-- ==========================================================
-- STORAGE
-- ==========================================================
storage[panelName] = storage[panelName] or {
  enabled = false,   -- BotSwitch
  list = {},
  lastUid = 0,
  timers = {}        -- [itemIdStr] = { detected={...}, updated=millis }
}
local st = storage[panelName]
st.timers = st.timers or {}

local function nextUid()
  st.lastUid = (tonumber(st.lastUid) or 0) + 1
  return st.lastUid
end

local function nowMillis() 
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end 
  if now then return now end 
  return 0 
end

local function itemKey(id) return tostring(id or 0) end

-- ==========================================================
-- BUTTON TOP (Config + IMBUIR MANUAL abaixo do switch)
-- ==========================================================
buttonImbuiment = setupUI([[
Panel
  height: 33

  BotSwitch
    id: status
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: AUTO IMBUIMENT
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
    text: Config
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green

  Button
    id: ImbuirManual
    anchors.top: status.bottom
    anchors.left: status.left
    anchors.right: parent.right
    width: 78
    height: 15
    margin-top: 1
    text: MANUAL IMBUIMENT
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #363636
    color: orange
    $hover:
      opacity: 0.95
]], parent)

storage[panelName] = storage[panelName] or {}
storage[panelName].enabled = storage[panelName].enabled == true
st = storage[panelName]
st.timers = st.timers or {}

-- aplica estado inicial
buttonImbuiment.status:setOn(st.enabled == true)

buttonImbuiment.status.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  st.enabled = newState
end
-- ==========================================================
-- UI WINDOW (mantido layout)
-- ==========================================================
imbuimentInterface = setupUI([[
imbuimentLabel < Label
  height: 18
  margin-top: 3

  ComboBox
    id: imbuiment
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 0
    width: 136
    height: 18
    font: verdana-9px
    text-align: center
    image-color: #828282

  ComboBox
    id: nivelimbuiment
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    width: 70
    height: 18
    font: verdana-9px
    text-align: left
    image-color: #828282
    @onSetup: |
      self:addOption("")
      self:addOption("Basic")
      self:addOption("Intricate")
      self:addOption("Powerful")

imbRow < Panel
  height: 34
  margin-top: 2
  layout:
    type: horizontalBox
    spacing: 6

  Item
    id: item
    size: 32 32
    image-source: /images/ui/item
    padding: 3
    border: 1 black
    image-color: #828282
    margin-left: 3

  Label
    id: text
    height: 18
    width: 220
    text: Imbuiments:
    font: verdana-9px
    color: white

  Button
    id: remove
    width: 30
    height: 18
    margin-right: 5
    text: X
    font: verdana-9px
    color: white
    image-source: /images/ui/button_rounded
    image-color: #8b2a2a
    $hover:
      opacity: 0.92
      color: black

UIWindow
  id: mainPanel
  size: 330 365
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
    !text: tr('LNS Custom | Imbuiments System')
    color: orange
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

  FlatPanel
    id: panelMain
    anchors.top: topPanel.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 8
    margin-right: 8
    margin-left: 8
    height: 135
    image-color: #363636

  BotItem
    id: botItem
    anchors.top: prev.top
    anchors.left: prev.left
    image-source: /images/ui/item
    border: 1 black
    image-color: #828282
    margin-top: 10
    margin-left: 8
    size: 80 100
    padding: 5

  Label
    id: labelType
    anchors.top: prev.top
    anchors.left: prev.right
    text: TYPE:
    font: verdana-9px
    margin-left: 10
    margin-top: 3

  ComboBox
    id: typeSelect
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    margin-top: -3
    width: 100
    height: 18
    image-color: #828282
    font: verdana-9px
    @onSetup: |
      self:addOption("")
      self:addOption("Helmet")
      self:addOption("Armor")
      self:addOption("Legs")
      self:addOption("Boots")
      self:addOption("Shield/Book")
      self:addOption("Weapon")
      self:addOption("Bag")
      self:addOption("Ring")
      self:addOption("Amulet")

  Label
    id: labelSlots
    anchors.top: prev.top
    anchors.left: prev.right
    text: SLOTS:
    font: verdana-9px
    margin-left: 10
    margin-top: 3

  SpinBox
    id: slotsSelect
    anchors.top: prev.top
    anchors.left: prev.right
    margin-left: 2
    margin-top: -3
    width: 25
    height: 18
    image-color: #828282
    minimum: 0
    maximum: 3
    font: verdana-9px

  imbuimentLabel
    id: imbuiment1
    anchors.top: typeSelect.bottom
    anchors.left: labelType.left
    anchors.right: panelMain.right
    margin-right: 10
    margin-top: 10
    image-color: #828282
    font: verdana-9px

  imbuimentLabel
    id: imbuiment2
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 10
    image-color: #828282
    font: verdana-9px

  imbuimentLabel
    id: imbuiment3
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    margin-top: 10
    image-color: #828282
    font: verdana-9px

  Button
    id: Adicionar
    anchors.left: panelMain.left
    anchors.top: imbuiment3.bottom
    anchors.right: panelMain.right
    height: 18
    margin-top: 5
    margin-left: 7
    margin-right: 6
    image-source: /images/ui/button_rounded
    image-color: #363636
    font: verdana-9px
    text: ADICIONAR
    color: orange

  FlatPanel
    id: listBox
    anchors.top: Adicionar.bottom
    anchors.left: panelMain.left
    anchors.right: panelMain.right
    margin-top: 6
    height: 190
    image-color: #363636

  ScrollablePanel
    id: listaImbuiments
    anchors.fill: parent
    anchors.top: listBox.top
    anchors.left: listBox.left
    anchors.right: listBox.right
    anchors.bottom: listBox.bottom
    padding: 2
    vertical-scrollbar: listImbuimentsScrollBar
    layout:
      type: verticalBox
      spacing: 2

  VerticalScrollBar
    id: listImbuimentsScrollBar
    anchors.top: listBox.top
    anchors.bottom: listBox.bottom
    anchors.right: listBox.right
    step: 14
    pixels-scroll: true
    image-color: #363636
]], g_ui.getRootWidget())

imbuimentInterface:hide()

function buttonsPreyPcMobile()
  if modules._G.g_app.isMobile() then
    buttonImbuiment.settings:show()
    buttonImbuiment.status:setMarginRight(55)
  else
    buttonImbuiment.settings:hide()
    buttonImbuiment.status:setMarginRight(0)
  end
end
buttonsPreyPcMobile()

buttonImbuiment.status.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not imbuimentInterface:isVisible() then
      imbuimentInterface:show()
      imbuimentInterface:raise();
      imbuimentInterface:focus();
    else
      imbuimentInterface:hide()
    end
  end
end

local timerUI = setupUI([[
timerRow < Panel
  height: 44
  margin-top: 2
  layout:
    type: horizontalBox
    spacing: 6

  Item
    id: item
    size: 32 32
    image-source: /images/ui/item
    padding: 3
    border: 1 black
    image-color: #828282
    margin-left: 3

  Label
    id: text
    height: 44
    width: 240
    font: verdana-9px
    color: white
    text-wrap: true

UIWindow
  id: timerWin
  size: 250 220
  anchors.right: parent.right
  anchors.bottom: parent.bottom
  margin-right: 12
  margin-bottom: 110

  Panel
    id: background
    anchors.fill: parent
    opacity: 0.70

  Panel
    id: top
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 20

  Label
    id: title
    anchors.centerIn: top
    text: Imbuiments Timers
    font: verdana-9px-bold
    color: yellow

  FlatPanel
    id: box
    anchors.top: top.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    image-source:
    margin: 6

  ScrollablePanel
    id: list
    anchors.fill: box
    padding: 2
    vertical-scrollbar: scroll
    layout:
      type: verticalBox
      spacing: 2

  VerticalScrollBar
    id: scroll
    anchors.top: box.top
    anchors.bottom: box.bottom
    anchors.right: box.right
    step: 16
    pixels-scroll: true
    visible: false
]], g_ui.getRootWidget())

timerUI:hide()

-- storage da posição
st.timerWinPos = st.timerWinPos or nil -- {x=..., y=...}

local function isMoveKeyPressed()
  -- PC: CTRL  |  Mobile: F2 (igual teu exemplo)
  if modules._G.g_app.isMobile() then
    return modules.corelib.g_keyboard.isKeyPressed("F2");
	else
		return modules.corelib.g_keyboard.isCtrlPressed();
  end
end

local function applyTimerPos()
  if not timerUI or not timerUI.setPosition then return end
  if st.timerWinPos and st.timerWinPos.x and st.timerWinPos.y then
    timerUI:breakAnchors()
    timerUI:setPosition({ x = st.timerWinPos.x, y = st.timerWinPos.y })
  end
end

local function saveTimerPos()
  if not timerUI or not timerUI.getPosition then return end
  local p = timerUI:getPosition()
  if not p then return end
  st.timerWinPos = { x = p.x, y = p.y }
end

local function disableDrag()
  if not timerUI then return end
  timerUI.onDragEnter = nil
  timerUI.onDragMove  = nil
  timerUI:setFocusable(false)
  timerUI:setPhantom(true)
  timerUI:setDraggable(false)
  timerUI:setOpacity(1.00)
end

local function enableDrag()
  if not timerUI then return end
  timerUI:setFocusable(true)
  timerUI:setPhantom(false)
  timerUI:setDraggable(true)
  timerUI:setOpacity(1.00)

  timerUI.onDragEnter = function(widget, mousePos)
    widget:breakAnchors()
    widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
    return true
  end

  timerUI.onDragMove = function(widget, mousePos, moved)
    local parent = widget:getParent()
    if not parent or not parent.getRect then return true end
    local r = parent:getRect()

    local x = mousePos.x - (widget.movingReference and widget.movingReference.x or 0)
    local y = mousePos.y - (widget.movingReference and widget.movingReference.y or 0)

    -- limita dentro da tela (root)
    x = math.min(math.max(r.x, x), r.x + r.width  - widget:getWidth())
    y = math.min(math.max(r.y, y), r.y + r.height - widget:getHeight())

    widget:move(x, y)
    st.timerWinPos = { x = x, y = y } -- salva em tempo real
    return true
  end
end

-- aplica posição salva assim que cria
applyTimerPos()
disableDrag()

-- controla drag PC/Mobile + salva fallback se mexer por outras formas
local lastPressed = nil
macro(100, function()
  local stHud = storage.hudInterfaceControl
  if not stHud or not stHud.switches or stHud.switches.timerImbuiment ~= true then return end
  if not timerUI or not timerUI.isVisible or not timerUI:isVisible() then return end

  local pressed = isMoveKeyPressed()
  if pressed ~= lastPressed then
    if pressed then enableDrag() else disableDrag() end
    lastPressed = pressed
  end

  -- fallback: garante que se mover por qualquer motivo, salva
  saveTimerPos()
end)

-- ==========================================================
-- POPULATE IMBUE LIST (painel)
-- ==========================================================
local IMBUE_NAMES = {
  "",
  "Life Leech",
  "Mana Leech",
  "Critical",
  "Magic Level",
  "Skill Boost",
  "Fire Protection",
  "Ice Protection",
  "Earth Protection",
  "Energy Protection",
  "Death Protection",
  "Holy Protection",
}

local function fillImbueCombo(combo)
  combo:clearOptions()
  for i = 1, #IMBUE_NAMES do combo:addOption(IMBUE_NAMES[i]) end
  if type(combo.setText) == "function" then combo:setText("") end
end

fillImbueCombo(imbuimentInterface.imbuiment1.imbuiment)
fillImbueCombo(imbuimentInterface.imbuiment2.imbuiment)
fillImbueCombo(imbuimentInterface.imbuiment3.imbuiment)

-- ==========================================================
-- SLOTS: trava/destrava
-- ==========================================================
local function setRowEnabled(row, enabled)
  row.imbuiment:setEnabled(enabled)
  row.nivelimbuiment:setEnabled(enabled)

  if enabled then
    row.imbuiment:setOpacity(1.00)
    row.nivelimbuiment:setOpacity(1.00)
  else
    row.imbuiment:setOpacity(0.55)
    row.nivelimbuiment:setOpacity(0.55)
    if type(row.imbuiment.setText) == "function" then row.imbuiment:setText("") end
    if type(row.nivelimbuiment.setText) == "function" then row.nivelimbuiment:setText("") end
  end
end

local function refreshSlots()
  local n = tonumber(imbuimentInterface.slotsSelect:getValue()) or 0
  setRowEnabled(imbuimentInterface.imbuiment1, n >= 1)
  setRowEnabled(imbuimentInterface.imbuiment2, n >= 2)
  setRowEnabled(imbuimentInterface.imbuiment3, n >= 3)
end

imbuimentInterface.slotsSelect.onValueChange  = function() refreshSlots() end
imbuimentInterface.slotsSelect.onValueChanged = function() refreshSlots() end
refreshSlots()

-- ==========================================================
-- LISTA (painel)
-- ==========================================================
local function comboText(combo)
  if not combo then return "" end
  if type(combo.getText) == "function" then return tostring(combo:getText() or "") end
  return ""
end

local function formatImbText(imbs)
  local parts = {}
  for i = 1, #imbs do
    local n = tostring(imbs[i] and imbs[i].name or "")
    local l = tostring(imbs[i] and imbs[i].level or "")
    if n ~= "" then
      if l ~= "" then parts[#parts + 1] = n .. " (" .. l .. ")"
      else parts[#parts + 1] = n end
    end
  end
  if #parts == 0 then return "(Nenhum)" end
  if #parts == 1 then return parts[1] end
  if #parts == 2 then return parts[1] .. " & " .. parts[2] end
  local out = parts[1]
  for i = 2, #parts do
    if i == #parts then out = out .. " & " .. parts[i] else out = out .. ", " .. parts[i] end
  end
  return out
end

local function rebuildList()
  local listPanel = imbuimentInterface.listaImbuiments
  listPanel:destroyChildren()

  for i = 1, #st.list do
    local e = st.list[i]
    local row = g_ui.createWidget("imbRow", listPanel)

    local fixedId = tonumber(e.itemId) or 0
    row.item:setItemId(fixedId)
    row.item.onItemChange = function() row.item:setItemId(fixedId) end
    row.item.onDrop = function() return false end

    row.text:setText('Imbuiments: "' .. formatImbText(e.imbues or {}) .. '"')

    row.remove.onClick = function()
      for idx = #st.list, 1, -1 do
        if st.list[idx].uid == e.uid then
          table.remove(st.list, idx)
          break
        end
      end
      rebuildList()
    end
  end
end

-- ==========================================================
-- ADD + RESET
-- ==========================================================
local function clearCombo(cb)
  if not cb then return end
  if type(cb.setText) == "function" then cb:setText("") end
  if type(cb.setCurrentOption) == "function" then cb:setCurrentOption("") end
end

local function resetForm()
  imbuimentInterface.botItem:setItemId(0)
  clearCombo(imbuimentInterface.typeSelect)

  if type(imbuimentInterface.slotsSelect.setValue) == "function" then
    imbuimentInterface.slotsSelect:setValue(0)
  end

  clearCombo(imbuimentInterface.imbuiment1.imbuiment)
  clearCombo(imbuimentInterface.imbuiment1.nivelimbuiment)
  clearCombo(imbuimentInterface.imbuiment2.imbuiment)
  clearCombo(imbuimentInterface.imbuiment2.nivelimbuiment)
  clearCombo(imbuimentInterface.imbuiment3.imbuiment)
  clearCombo(imbuimentInterface.imbuiment3.nivelimbuiment)

  refreshSlots()
end

imbuimentInterface.Adicionar.onClick = function()
  local itemId = tonumber(imbuimentInterface.botItem:getItemId()) or 0
  local typText = comboText(imbuimentInterface.typeSelect)
  local slots = tonumber(imbuimentInterface.slotsSelect:getValue()) or 0

  if itemId <= 0 then warn("[Imb] Selecione um item no BotItem.") return end
  if typText == "" then warn("[Imb] Selecione o TYPE.") return end

  local imbues = {}
  if slots >= 1 then imbues[#imbues + 1] = { name = comboText(imbuimentInterface.imbuiment1.imbuiment), level = comboText(imbuimentInterface.imbuiment1.nivelimbuiment) } end
  if slots >= 2 then imbues[#imbues + 1] = { name = comboText(imbuimentInterface.imbuiment2.imbuiment), level = comboText(imbuimentInterface.imbuiment2.nivelimbuiment) } end
  if slots >= 3 then imbues[#imbues + 1] = { name = comboText(imbuimentInterface.imbuiment3.imbuiment), level = comboText(imbuimentInterface.imbuiment3.nivelimbuiment) } end

  local filtered = {}
  for i = 1, #imbues do
    if tostring(imbues[i].name or "") ~= "" then filtered[#filtered + 1] = imbues[i] end
  end
  imbues = filtered

  local uid = nextUid()
  st.list[#st.list + 1] = { uid = uid, itemId = itemId, type = typText, slots = slots, imbues = imbues }

  rebuildList()
  resetForm()
end

local function destroyImbuingPanel()
  if not g_ui or not g_ui.getRootWidget then return false end
  local root = g_ui.getRootWidget()
  if not root then return false end

  -- tente por ids comuns (se você souber o id exato, coloca aqui primeiro)
  local knownIds = { "imbuingWindow", "imbueWindow", "ImbuingWindow", "imbueItemWindow" }
  for i = 1, #knownIds do
    local w = root:recursiveGetChildById(knownIds[i])
    if w and w:isVisible() then
      w:hide()
      return true
    end
  end

  -- fallback: varre janelas procurando título "Imbue Item"
  local children = root:getChildren()
  for i = 1, #children do
    local w = children[i]
    if w and w.getClassName and w:getClassName() == "UIWindow" then
      local title = w:recursiveGetChildById("title")
      if title and title.getText and title:getText() == "Imbue Item" then
        w:hide()
        return true
      end
    end
  end

  return false
end

-- ==========================================================
-- OPEN/CLOSE
-- ==========================================================
buttonImbuiment.settings.onClick = function()
  if imbuimentInterface:isVisible() then
    imbuimentInterface:hide()
  else
    imbuimentInterface:show()
    imbuimentInterface:raise()
    imbuimentInterface:focus()
    rebuildList()
  end
end

imbuimentInterface.closePanel.onClick = function() imbuimentInterface:hide() end

-- ==========================================================
-- TIMER ENGINE (LOOK nos itens e mostra tempos)
-- ==========================================================
local function safeFindItemInContainers(itemId)
  if not itemId or itemId <= 0 then return nil end
  if type(getContainers) ~= "function" then return nil end

  local conts = getContainers()
  if not conts then return nil end

  for c = 1, #conts do
    local cont = conts[c]
    if cont and cont.getItems then
      local items = cont:getItems()
      if items then
        for i = 1, #items do
          local it = items[i]
          if it and it.getId and it:getId() == itemId then
            return it
          end
        end
      end
    end
  end
  return nil
end

local function findItemObject(itemId, typText)
  itemId = tonumber(itemId) or 0
  typText = tostring(typText or "")

  -- MUITO IMPORTANTE:
  -- findItem normalmente retorna o "Thing" com posição válida (incluindo backpack),
  -- isso é o que faz o IMBUIR funcionar quando o item está na bag.
  if type(findItem) == "function" then
    local itAny = findItem(itemId)
    if itAny and itAny.getId and itAny:getId() == itemId then
      return itAny
    end
  end

  -- slots equipados
  if typText == "Helmet" and type(getHead) == "function" then
    local it = getHead()
    if it and it.getId and it:getId() == itemId then return it end
  end
  if typText == "Armor" and type(getBody) == "function" then
    local it = getBody()
    if it and it.getId and it:getId() == itemId then return it end
  end
  if typText == "Legs" and type(getLeg) == "function" then
    local it = getLeg()
    if it and it.getId and it:getId() == itemId then return it end
  end
  if typText == "Boots" and type(getFeet) == "function" then
    local it = getFeet()
    if it and it.getId and it:getId() == itemId then return it end
  end
  if typText == "Weapon" and type(getLeft) == "function" then
    local it = getLeft()
    if it and it.getId and it:getId() == itemId then return it end
  end
  if typText == "Shield/Book" and type(getRight) == "function" then
    local it = getRight()
    if it and it.getId and it:getId() == itemId then return it end
  end
  if typText == "Ring" and type(getFinger) == "function" then
    local it = getFinger()
    if it and it.getId and it:getId() == itemId then return it end
  end
  if typText == "Amulet" and type(getNeck) == "function" then
    local it = getNeck()
    if it and it.getId and it:getId() == itemId then return it end
  end

  -- containers abertos (fallback)
  return safeFindItemInContainers(itemId)
end

local function doLook(itemObj)
  if not itemObj then return false end
  if g_game and type(g_game.look) == "function" then
    g_game.look(itemObj)
    return true
  end
  if type(look) == "function" then
    look(itemObj)
    return true
  end
  return false
end

-- tier -> horas padrão (fallback quando o LOOK não mostra tempo)
local TIER_TO_HOURS = {
  Basic = 5,
  Intricate = 10,
  Powerful = 20
}

-- mapeia o "nome do imbue" do LOOK -> nome visual do seu painel
local LOOK_NAME_TO_VISUAL = {
  ["Void"] = "Mana Leech",
  ["Vampirism"] = "Life Leech",
  ["Strike"] = "Critical",
  ["Epiphany"] = "Magic Level",

  ["Precision"] = "Skill Boost",
  ["Chop"] = "Skill Boost",
  ["Slash"] = "Skill Boost",
  ["Bash"] = "Skill Boost",

  ["Dragon Hide"] = "Fire Protection",
  ["Quara Scale"] = "Ice Protection",
  ["Snake Skin"] = "Earth Protection",
  ["Cloud Fabric"] = "Energy Protection",
  ["Lich Shroud"] = "Death Protection",
  ["Demon Presence"] = "Holy Protection",

  ["Featherweight"] = "Capacity",
  ["Swiftness"] = "Speed"
}

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function parseTimeToSeconds(text)
  text = tostring(text or "")

  -- 02:19h / 2:19h / 5:54h
  local hh, mm = text:match("(%d+):(%d+)%s*[hH]")
  if hh and mm then
    return (tonumber(hh) or 0) * 3600 + (tonumber(mm) or 0) * 60
  end

  -- 02:19 (às vezes vem sem 'h')
  hh, mm = text:match("(%d+):(%d+)")
  if hh and mm then
    return (tonumber(hh) or 0) * 3600 + (tonumber(mm) or 0) * 60
  end

  -- 2h 19m
  local h2, m2 = text:match("(%d+)%s*[hH]%s*(%d+)%s*[mM]")
  if h2 then
    return (tonumber(h2) or 0) * 3600 + (tonumber(m2) or 0) * 60
  end

  -- 2h
  local h3 = text:match("(%d+)%s*[hH]")
  if h3 then
    return (tonumber(h3) or 0) * 3600
  end

  return nil
end

local function secondsToHHMM(seconds)
  seconds = tonumber(seconds) or 0
  if seconds < 0 then seconds = 0 end
  local hh = math.floor(seconds / 3600)
  local mm = math.floor((seconds % 3600) / 60)
  return string.format("%02d:%02dh", hh, mm)
end

-- extrai imbues do "Imbuements: (...)" com tempo INDIVIDUAL por imbue
-- retorna { {tier, raw, visual, seconds, timeStr}, ... }
local function parseImbuesFromLookText(text)
  text = tostring(text or "")

  local imbBlock = text:match("Imbuements:%s*%((.-)%)")
  if not imbBlock or imbBlock == "" then return {} end

  local out = {}

  for part in imbBlock:gmatch("([^,]+)") do
    part = trim(part)
    if part ~= "" then
      if part:find("Free Slot", 1, true) then
        -- ignora
      else
        local tier, rest = part:match("^(Basic)%s+(.+)$")
        if not tier then tier, rest = part:match("^(Intricate)%s+(.+)$") end
        if not tier then tier, rest = part:match("^(Powerful)%s+(.+)$") end

        tier = trim(tier or "")
        rest = trim(rest or part)

        -- rest: "Void 5:54h" | "Vampirism 18:56h"
        local timeToken = rest:match("(%d+:%d+%s*[hH])") or rest:match("(%d+%s*[hH]%s*%d+%s*[mM])")
        local rawName = rest
        if timeToken then
          rawName = trim(rest:gsub(timeToken, ""))
        end

        rawName = trim(rawName)
        local visual = LOOK_NAME_TO_VISUAL[rawName] or rawName

        local sec = nil
        if timeToken then
          sec = parseTimeToSeconds(timeToken)
        end

        -- fallback se não vier tempo no look
        if not sec then
          local h = TIER_TO_HOURS[tostring(tier)] or 0
          sec = h > 0 and (h * 3600) or 0
        end

        out[#out + 1] = {
          tier = tier,
          raw = rawName,
          visual = visual,
          seconds = sec,
          timeStr = secondsToHHMM(sec)
        }
      end
    end
  end

  return out
end

local function ensureTimerEntry(itemId)
  local k = itemKey(itemId)
  st.timers[k] = st.timers[k] or {}
  return st.timers[k]
end

local function updateTimerFromLook(itemId, lookText)
  local info = ensureTimerEntry(itemId)
  info.detected = parseImbuesFromLookText(lookText)
  info.updated = nowMillis()
end

local function getRemainingSeconds(itemId, imbueIndex)
  local info = st.timers[itemKey(itemId)]
  if not info or not info.detected or not info.detected[imbueIndex] then return nil end

  local total = tonumber(info.detected[imbueIndex].seconds)
  if not total then return nil end

  local elapsed = math.floor((nowMillis() - (tonumber(info.updated) or nowMillis())) / 1000)
  local remain = total - elapsed
  if remain < 0 then remain = 0 end
  return remain
end

local function rebuildTimersUI()
  local stHud = storage.hudInterfaceControl
  if not stHud or not stHud.switches or stHud.switches.timerImbuiment ~= true then return end
  if not timerUI or not timerUI.list then return end
  local list = timerUI.list
  list:destroyChildren()

  for i = 1, #st.list do
    local e = st.list[i]
    local itemId = tonumber(e.itemId) or 0
    if itemId > 0 then
      local row = g_ui.createWidget("timerRow", list)
      row.item:setItemId(itemId)
      row.item.onItemChange = function() row.item:setItemId(itemId) end
      row.item.onDrop = function() return false end

      local info = st.timers[itemKey(itemId)]
      local lines = {}

      -- prioridade: detectado pelo look (real)
      local detected = info and info.detected or nil
      if detected and #detected > 0 then
        for j = 1, #detected do
          local vis  = tostring(detected[j].visual or detected[j].raw or "")
          local tier = tostring(detected[j].tier or "")
          if vis ~= "" then
            local remain = getRemainingSeconds(itemId, j)
            local tStr = remain and secondsToHHMM(remain) or (detected[j].timeStr or "--:--h")
            if tier ~= "" then
              lines[#lines + 1] = vis .. " (" .. tier .. "): " .. tStr
            else
              lines[#lines + 1] = vis .. ": " .. tStr
            end
          end
        end
      else
        -- fallback: configurado no painel (sem look ainda)
        local conf = e.imbues or {}
        if #conf == 0 then
          lines[#lines + 1] = "Sem imbuiments configurados"
        else
          for j = 1, #conf do
            local nm = tostring(conf[j] and conf[j].name or "")
            local lv = tostring(conf[j] and conf[j].level or "")
            if nm ~= "" then
              if lv ~= "" then
                lines[#lines + 1] = nm .. " (" .. lv .. "): --:--h"
              else
                lines[#lines + 1] = nm .. ": --:--h"
              end
            end
          end
        end
      end

      row.text:setText(table.concat(lines, "\n"))
    end
  end
end

local lookState = {
  idx = 0,
  pending = nil -- { itemId=, started=millis }
}

-- captura texto do LOOK
-- =========================
-- LOOK CAPTURE (buffer)
-- Junta linhas do look e extrai "Imbuements:" mesmo quando vem quebrado
-- =========================
local lookBuffer = { acc = "", lastAt = 0, itemId = nil }

local function flushLookBuffer()
  if not lookBuffer.itemId then
    lookBuffer.acc = ""
    return
  end

  local full = tostring(lookBuffer.acc or "")
  if full:find("Imbuements:", 1, true) then
    updateTimerFromLook(lookBuffer.itemId, full)
    rebuildTimersUI()
  end

  lookBuffer.acc = ""
  lookBuffer.itemId = nil
end

onTextMessage(function(mode, text)
  if not lookState.pending then return end

  text = tostring(text or "")
  if text == "" then return end

  -- janela maior porque look vem em múltiplas linhas
  if nowMillis() - (lookState.pending.started or 0) > 4000 then
    lookState.pending = nil
    lookBuffer.acc = ""
    lookBuffer.itemId = nil
    return
  end

  -- acumula tudo que chegar logo após o look
  lookBuffer.itemId = lookState.pending.itemId
  lookBuffer.acc = (lookBuffer.acc == "" and text) or (lookBuffer.acc .. "\n" .. text)
  lookBuffer.lastAt = nowMillis()

  -- fecha o pending, mas espera um pouquinho pra juntar as próximas linhas
  lookState.pending = nil

  schedule(400, function()
    -- só flusha se ninguém adicionou mais texto no buffer nesses 400ms
    if lookBuffer.itemId and (nowMillis() - (lookBuffer.lastAt or 0) >= 350) then
      flushLookBuffer()
    end
  end)
end)

macro(300, function()
  if not storage[switchHud].enabled then 
    timerUI:hide() 
    return
  end
  local stHud = storage.hudInterfaceControl
  if not stHud or not stHud.switches or stHud.switches.timerImbuiment ~= true then
    timerUI:hide()
    return
  end

  if not timerUI:isVisible() then
    timerUI:show()
    timerUI:raise()
  end
end)

-- dá LOOK (10s)
macro(10000, function()
  local stHud = storage.hudInterfaceControl
  if not stHud or not stHud.switches or stHud.switches.timerImbuiment ~= true then return end
  if not timerUI:isVisible() then return end

  if #st.list == 0 then
    rebuildTimersUI()
    return
  end

  if lookState.pending then return end

  lookState.idx = lookState.idx + 1
  if lookState.idx > #st.list then lookState.idx = 1 end

  local e = st.list[lookState.idx]
  if not e then return end

  local itemId = tonumber(e.itemId) or 0
  if itemId <= 0 then return end

  local it = findItemObject(itemId, tostring(e.type or ""))
  if not it or not it.getId or it:getId() ~= itemId then return end

  if doLook(it) then
    lookState.pending = { itemId = itemId, started = nowMillis() }
  end
end)

-- refresh do texto do painel (não dá look, só redesenha)
macro(1000, function()
  local stHud = storage.hudInterfaceControl
  if not stHud or not stHud.switches or stHud.switches.timerImbuiment ~= true then return end
  if not timerUI:isVisible() then return end
  rebuildTimersUI()
end)

-- ==========================================================
-- AUTO IMBUE ENGINE (somente com BotSwitch ON)
-- ==========================================================
local SHRINES = {25060, 25061, 25182, 25183}

local function tierNameToNumber(tierName)
  if tierName == "Basic" then return 1 end
  if tierName == "Intricate" then return 2 end
  if tierName == "Powerful" then return 3 end
  return 3
end

local function getTierFromWindowName(name)
  name = tostring(name or "")
  if name:find("Basic") then return 1 end
  if name:find("Intricate") then return 2 end
  if name:find("Powerful") then return 3 end
  return 3
end

local function tableFind(t, v)
  for i = 1, #t do if t[i] == v then return true end end
  return false
end

local function findShrine()
  if not g_map or not g_map.getTiles then return nil, nil end
  local tiles = g_map.getTiles(posz())
  if not tiles then return nil, nil end

  for i = 1, #tiles do
    local tile = tiles[i]
    local items = tile and tile.getItems and tile:getItems()
    if items then
      for j = 1, #items do
        local it = items[j]
        if it and it.getId and tableFind(SHRINES, it:getId()) then
          return it, tile:getPosition()
        end
      end
    end
  end
  return nil, nil
end

-- VISUAL do painel -> GROUP interno
local IMBUE_VISUAL_TO_GROUP = {
  ["Life Leech"]        = "Vampirism",
  ["Mana Leech"]        = "Void",
  ["Critical"]          = "Strike",
  ["Magic Level"]       = "Epiphany",
  ["Skill Boost"]       = "Precision",

  ["Fire Protection"]   = "Dragon Hide",
  ["Ice Protection"]    = "Quara Scale",
  ["Earth Protection"]  = "Snake Skin",
  ["Energy Protection"] = "Cloud Fabric",
  ["Death Protection"]  = "Lich Shroud",
  ["Holy Protection"]   = "Demon Presence",
}

-- GROUP interno -> texto/categoria do shrine
local GROUP_TO_SHRINE_TEXT = {
  ["Void"]           = "Mana Leech",
  ["Vampirism"]      = "Hit Points Leech",
  ["Strike"]         = "Critical",

  ["Epiphany"]       = "Magic Level",
  ["Precision"]      = "Skillboost (Distance)",

  ["Lich Shroud"]    = "Elemental Protection (Death)",
  ["Snake Skin"]     = "Elemental Protection (Earth)",
  ["Demon Presence"] = "Elemental Protection (Holy)",
  ["Dragon Hide"]    = "Elemental Protection (Fire)",
  ["Quara Scale"]    = "Elemental Protection (Ice)",
  ["Cloud Fabric"]   = "Elemental Protection (Energy)",
}

local function findImbueFromWindow(windowImbuements, visualName, tierNum)
  if not windowImbuements then return nil end
  visualName = tostring(visualName or "")
  if visualName == "" then return nil end

  local groupInternal = IMBUE_VISUAL_TO_GROUP[visualName]
  if not groupInternal then
    print("[Imb] Visual sem mapping: " .. visualName)
    return nil
  end

  local shrineText = GROUP_TO_SHRINE_TEXT[groupInternal] or groupInternal
  tierNum = tonumber(tierNum) or 3

  for i = 1, #windowImbuements do
    local imb = windowImbuements[i]
    local g = tostring(imb.group or "")
    local n = tostring(imb.name or "")

    local okGroup =
      (g == shrineText) or
      (n:find(shrineText, 1, true) ~= nil) or
      (n:find(groupInternal, 1, true) ~= nil) or
      (n:find(visualName, 1, true) ~= nil)

    if okGroup then
      local t = getTierFromWindowName(n)
      if t == tierNum then return imb end
    end
  end
  return nil
end

local function activeName(activeSlots, slotIdx)
  if not activeSlots then return "" end
  local info = activeSlots[slotIdx]
  if not info or not info[1] then return "" end
  return tostring(info[1].name or "")
end

local imbState = {
  active = false,
  queue = {},
  idx = 1,
  waitingWindow = false,
  waitingApply = false,
  lastAction = 0,
  shrine = nil,
  shrinePos = nil,
  currentEntry = nil
}

local function resetImbState()
  imbState.active = false
  imbState.queue = {}
  imbState.idx = 1
  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.lastAction = 0
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.currentEntry = nil
end

local function buildQueueFromList()
  local q = {}
  for i = 1, #st.list do
    local e = st.list[i]
    local itemId = tonumber(e.itemId) or 0
    if itemId > 0 then
      q[#q + 1] = { entry = e, itemId = itemId, typ = tostring(e.type or "") }
    end
  end
  return q
end

local function onWindow(itemId, slots, activeSlots, imbuements, needItems)
  if not imbState.active then return end
  if not imbState.waitingWindow then return end

  imbState.waitingWindow = false
  imbState.waitingApply = true

  local entry = imbState.currentEntry
  if not entry then
    imbState.waitingApply = false
    schedule(250, function()
      if g_game and g_game.closeImbuingWindow then g_game.closeImbuingWindow() end
    end)
    return
  end

  local desired = entry.imbues or {}
  local desiredSlots = tonumber(entry.slots) or 0
  local realSlots = tonumber(slots) or 0
  local max = math.min(desiredSlots, realSlots, #desired)

  local toApply = {}

  for slotIdx = 0, max - 1 do
    local conf = desired[slotIdx + 1]
    local visualName = tostring(conf and conf.name or "")
    local tier = tierNameToNumber(tostring(conf and conf.level or "Powerful"))

    if visualName ~= "" then
      local hasActive = activeSlots and activeSlots[slotIdx] ~= nil
      if hasActive then
        local aName = activeName(activeSlots, slotIdx)
        if aName ~= "" then
          print('[Imb] NÃO vai aplicar no item '..tostring(itemId)..' (slot '..(slotIdx+1)..') porque ainda tem tempo ativo: "'..aName..'"')
        else
          print('[Imb] NÃO vai aplicar no item '..tostring(itemId)..' (slot '..(slotIdx+1)..') porque ainda tem tempo ativo (slot ocupado).')
        end
      else
        local imbData = findImbueFromWindow(imbuements, visualName, tier)
        if imbData then
          toApply[#toApply + 1] = { slotIdx = slotIdx, imb = imbData }
        else
          print("[Imb] Não encontrado: " .. visualName .. " (" .. tostring(conf.level) .. ")")
        end
      end
    end
  end

  local applyIndex = 1
  local function applyNext()
    if applyIndex > #toApply then
      imbState.waitingApply = false
      schedule(800, function()
        if g_game and g_game.closeImbuingWindow then g_game.closeImbuingWindow() end
      end)
      return
    end

    local data = toApply[applyIndex]
    applyIndex = applyIndex + 1

    if g_game and g_game.applyImbuement then
      print('[Imb] Aplicando: slot '..(data.slotIdx+1)..' -> "'..tostring(data.imb.name or "")..'"')
      g_game.applyImbuement(data.slotIdx, data.imb.id, true)
    end

    schedule(2200, applyNext)
  end

  if #toApply > 0 then
    schedule(350, applyNext)
  else
    imbState.waitingApply = false
    schedule(300, function()
      if g_game and g_game.closeImbuingWindow then g_game.closeImbuingWindow() end
    end)
  end
end

if type(onImbuementWindow) == "function" then
  onImbuementWindow(onWindow)
else
  print("[Imb] Aviso: onImbuementWindow não existe no seu client.")
end

macro(200, function()
  if st.enabled ~= true then return end
  if not imbState.active then return end

  local t = nowMillis()
  if t - (imbState.lastAction or 0) < 800 then return end
  if imbState.waitingWindow or imbState.waitingApply then return end

  if not imbState.shrine or not imbState.shrinePos then
    local shrine, sPos = findShrine()
    if not shrine then
      warn("[Imb] Shrine não encontrado no seu andar.")
      resetImbState()
      return
    end

    local pPos = player:getPosition()
    local dist = math.max(math.abs(pPos.x - sPos.x), math.abs(pPos.y - sPos.y))
    if dist > 1 then
      warn("[Imb] Longe do shrine (dist " .. dist .. "). Chegue perto (<=1).")
      resetImbState()
      return
    end

    imbState.shrine = shrine
    imbState.shrinePos = sPos
  end

  if imbState.idx > #imbState.queue then
    print("[Imb] Finalizado: todos itens da lista processados.")
    resetImbState()
    destroyImbuingPanel()
    return
  end

  local data = imbState.queue[imbState.idx]
  imbState.idx = imbState.idx + 1

  local entry = data.entry
  local itemObj = findItemObject(data.itemId, data.typ)

  if not itemObj or not itemObj.getId or itemObj:getId() ~= data.itemId then
    print("[Imb] Item não encontrado agora: " .. data.itemId .. " (" .. tostring(data.typ) .. ")")
    imbState.lastAction = t
    return
  end

  imbState.currentEntry = entry
  imbState.waitingWindow = true
  imbState.lastAction = t

  print("[Imb] Abrindo shrine no item: " .. tostring(data.itemId))
  useWith(imbState.shrine, itemObj)
end)

function startImbueAllFromList()
  if st.enabled ~= true then
    warn("[Imb] Ative o BotSwitch 'Imbuiments' para usar.")
    return
  end
  if imbState.active then
    warn("[Imb] Já está processando.")
    return
  end
  if #st.list == 0 then
    warn("[Imb] Sua lista está vazia.")
    return
  end

  imbState.queue = buildQueueFromList()
  imbState.idx = 1
  imbState.active = true
  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.currentEntry = nil
  imbState.lastAction = nowMillis()

  print("[Imb] Iniciando: " .. #imbState.queue .. " item(s) da lista.")
end

-- botão IMBUIR MANUAL (fora do painel, embaixo do switch)
buttonImbuiment.ImbuirManual.onClick = function()
  startImbueAllFromList()
end

-- CaveBot action (use perto do shrine)
function checkerImbuementsList()
  if st.enabled ~= true then return true end
  if imbState.active then return "retry" end
  startImbueAllFromList()
  return "retry"
end

-- inicial
rebuildList()
rebuildTimersUI()

UI.Separator()
