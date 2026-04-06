setDefaultTab("Tools")

local panelImbuiment = setupUI([[
MainWindow
  size: 450 337
  text: Panel Imbuement

  UIButton
    id: clickHere
    anchors.top: parent.top
    anchors.left: parent.left
    text: Click Here
    margin-top: -2
    margin-left: 100
    color: #FFD700
    text-auto-resize: true
    font: verdana-11px-rounded
    opacity: 1.00
    $hover:
      opacity: 0.80

  Label
    id: labelClick
    anchors.verticalCenter: clickHere.verticalCenter
    anchors.left: clickHere.right
    margin-left: 4
    margin-top: 0
    font: verdana-11px-rounded
    text: to manage auto imbuement

  FlatPanel
    id: flatP
    anchors.fill: parent
    margin: -8
    margin-top: 15
    margin-bottom: 20
    
    Label
      text: Clean Imbuements with:
      anchors.top: parent.top
      anchors.left: parent.left
      color: gray
      margin-top: 3
      margin-left: 5

    HorizontalScrollBar
      id: limparImbuements
      anchors.verticalCenter: prev.verticalCenter
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 5
      margin-right: 5
      minimum: 1
      maximum: 1200

      Label
        id: limparText
        anchors.centerIn: parent
        font: verdana-11px-rounded
        color: #d7c08a
        text-auto-resize: true
        text: "1 min"
        phantom: true

    Label
      text: Imbuement Mode:
      anchors.top: prev.bottom
      anchors.left: parent.left
      color: gray
      margin-top: 7
      margin-left: 5

    BotSwitch
      id: imbuingShrine
      anchors.left: limparImbuements.left
      anchors.verticalCenter: prev.verticalCenter
      text: Imbuing Shrine
      width: 135
      font: verdana-11px-rounded
      $on:
        image-color: green
        color: green
      $!on:
        image-color: gray
        color: white

    BotSwitch
      id: portableShrine
      anchors.left: prev.right
      anchors.verticalCenter: prev.verticalCenter
      text: Portable Shrine
      width: 135
      margin-top: 0
      margin-left: 1
      font: verdana-11px-rounded
      $on:
        image-color: green
        color: green
      $!on:
        image-color: gray
        color: white

    TextList
      id: imbueList
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin: 5
      margin-right: 15
      vertical-scrollbar: imbueListScrollBar

    VerticalScrollBar
      id: imbueListScrollBar
      anchors.top: imbueList.top
      anchors.bottom: imbueList.bottom
      anchors.left: imbueList.right
      step: 10
      pixels-scroll: true
      border: 1 #1f1f1f

  Button
    id: closePanel
    anchors.left: flatP.left
    anchors.right: flatP.right
    anchors.top: flatP.bottom
    margin-left: -1
    margin-top: 5
    text: Fechar
    font: verdana-11px-rounded
]], g_ui.getRootWidget())
panelImbuiment:hide()

local panelImbuementManager = setupUI([[
MainWindow
  id: imbuementManager
  size: 420 410
  text: Auto Imbuement Manager

  FlatPanel
    id: bg
    anchors.fill: parent
    margin: -8
    margin-top: 0
    margin-bottom: 20

    FlatPanel
      id: leftBox
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      height: 60
      margin-top: 8
      margin-left: 6
      margin-right: 6

      Label
        text: Item
        anchors.top: parent.top
        anchors.left: parent.left
        margin-left: 13
        margin-top: -5
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      BotItem
        id: itemToImbue
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        margin-top: 0
        margin-left: 12
        border: 1 #d7c08a

      VerticalSeparator
        id: vsep
        anchors.top: parent.top
        anchors.left: prev.right
        anchors.bottom: parent.bottom
        margin-left: 13

      Label
        text: Slot Equipament
        anchors.top: parent.top
        anchors.left: prev.right
        margin-left: 60
        margin-top: -5
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      UIItem
        id: head
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: vsep.right
        margin-left: 10
        image-source: /images/game/slots/head
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: body
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/body
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: legs
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/legs
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: feet
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/feet
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: left-hand
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/left-hand
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: right-hand
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/right-hand
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      UIItem
        id: back
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: prev.right
        margin-left: 2
        image-source: /images/game/slots/back
        size: 29 29
        margin-top: 3
        border: 1 #444444
        focusable: true

      VerticalSeparator
        id: vsep2
        anchors.top: parent.top
        anchors.left: prev.right
        anchors.bottom: parent.bottom
        margin-left: 13

      Label
        text: Qtd. Imbue
        anchors.top: parent.top
        anchors.left: prev.right
        margin-left: 13
        margin-top: -5
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      SpinBox
        id: qtdimbue
        anchors.verticalCenter: back.verticalCenter
        anchors.left: vsep2.right
        anchors.right: parent.right
        margin-left: 10
        margin-right: 10
        text-align: center
        font: verdana-11px-rounded
        color: gray
        minimum: 1
        maximum: 3
  
    FlatPanel
      id: bottomBox
      anchors.top: leftBox.bottom
      anchors.left: leftBox.left
      anchors.right: leftBox.right
      anchors.bottom: parent.bottom
      margin-top: 5
      margin-bottom: 5

      Label
        text: Slot Imbue 1:
        anchors.top: parent.top
        anchors.left: parent.left
        margin-left: 6
        margin-top: 2
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      TextList
        id: imbueList1
        anchors.top: prev.bottom
        anchors.left: parent.left
        height: 70
        width: 260
        margin-left: 6
        margin-right: 19
        margin-top: 2
        vertical-scrollbar: imbueScroll1
        font: verdana-11px-rounded

      VerticalScrollBar
        id: imbueScroll1
        anchors.top: imbueList1.top
        anchors.bottom: imbueList1.bottom
        anchors.left: prev.right
        margin-right: 6
        step: 10
        pixels-scroll: true
        visible: true

      TextList
        id: imbueNivel1
        anchors.top: prev.top
        anchors.left: imbueList1.right
        anchors.right: parent.right
        height: 42
        margin-left: 20
        margin-right: 10
        font: verdana-11px-rounded

      Label
        text: Slot Imbue 2:
        anchors.top: imbueList1.bottom
        anchors.left: parent.left
        margin-left: 6
        margin-top: 4
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      TextList
        id: imbueList2
        anchors.top: prev.bottom
        anchors.left: parent.left
        height: 70
        width: 260
        margin-left: 6
        margin-right: 19
        margin-top: 2
        vertical-scrollbar: imbueScroll2
        font: verdana-11px-rounded

      VerticalScrollBar
        id: imbueScroll2
        anchors.top: imbueList2.top
        anchors.bottom: imbueList2.bottom
        anchors.left: imbueList2.right
        margin-right: 6
        step: 10
        pixels-scroll: true
        visible: true

      TextList
        id: imbueNivel2
        anchors.top: prev.top
        anchors.left: imbueList2.right
        anchors.right: parent.right
        height: 42
        margin-left: 20
        margin-right: 10
        font: verdana-11px-rounded

      Label
        text: Slot Imbue 3:
        anchors.top: imbueList2.bottom
        anchors.left: parent.left
        margin-left: 6
        margin-top: 4
        text-auto-resize: true
        font: verdana-11px-rounded
        color: #d7c08a

      TextList
        id: imbueList3
        anchors.top: prev.bottom
        anchors.left: parent.left
        width: 260
        height: 70
        margin-left: 6
        margin-right: 19
        margin-top: 2
        vertical-scrollbar: imbueScroll3
        font: verdana-11px-rounded

      VerticalScrollBar
        id: imbueScroll3
        anchors.top: imbueList3.top
        anchors.bottom: imbueList3.bottom
        anchors.left: prev.right
        margin-right: 6
        step: 10
        pixels-scroll: true
        visible: true

      TextList
        id: imbueNivel3
        anchors.top: prev.top
        anchors.left: imbueList3.right
        anchors.right: parent.right
        height: 42
        margin-left: 20
        margin-right: 10
        font: verdana-11px-rounded

  Button
    id: cancelar
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 5
    width: 200
    text: Cancelar
    font: verdana-11px-rounded

  Button
    id: confirmar
    anchors.top: prev.top
    anchors.left: prev.right
    width: 200
    margin-left: 5
    text: Confirmar
    font: verdana-11px-rounded
]], g_ui.getRootWidget())
panelImbuementManager:hide()

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

setDefaultTab("Tools")

storage.autoImbuement = storage.autoImbuement or {
  enabled = false,
  limparMinutes = 60,
  shrineMode = "imbuing", -- "imbuing" / "portable"
  entries = {},
  nextUid = 0,
  timers = {},
  recentActions = {}
}

local db = storage.autoImbuement
db.entries = db.entries or {}
db.timers = db.timers or {}
db.recentActions = db.recentActions or {}

local panel = panelImbuiment
local manager = panelImbuementManager

-- =========================================================
-- CONST / MAPS
-- =========================================================
local IMBUE_OPTIONS = {
  "Life Leech", "Mana Leech", "Critical", "Magic Level", "Skill Boost",
  "Fire Protection", "Ice Protection", "Earth Protection", "Energy Protection",
  "Death Protection", "Holy Protection",
}

local IMBUE_LEVELS = { "Basic", "Intricate", "Powerful" }

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

local SHRINES = {25060, 25061, 25182, 25183}
local PORTABLE_SHRINE = 14513
local RECENT_ACTION_MS = 10000

local SLOT_TO_INV = {
  head = InventorySlotHead or 1,
  back = InventorySlotBack or 3,
  body = InventorySlotBody or 4,
  ["right-hand"] = InventorySlotRight or 5,
  ["left-hand"] = InventorySlotLeft or 6,
  legs = InventorySlotLeg or 7,
  feet = InventorySlotFeet or 8,
}

local SLOT_WIDGET_IDS = {"head", "body", "legs", "feet", "left-hand", "right-hand", "back"}

-- =========================================================
-- REFS
-- =========================================================
local function W(root, id)
  if not root then return nil end
  if root.recursiveGetChildById then
    return root:recursiveGetChildById(id)
  end
  if root.getChildById then
    return root:getChildById(id)
  end
  return nil
end

local refs = {
  item = W(manager, "itemToImbue"),
  qtd = W(manager, "qtdimbue"),
  confirm = W(manager, "confirmar"),
  cancel = W(manager, "cancelar"),

  open = W(panel, "clickHere"),
  close = W(panel, "closePanel"),
  list = W(panel, "imbueList"),
  limpar = W(panel, "limparImbuements"),
  limparText = W(panel, "limparText"),
  shrine = W(panel, "imbuingShrine"),
  portable = W(panel, "portableShrine"),

  leftBox = W(manager, "leftBox"),
  bottomBox = W(manager, "bottomBox"),
}

local imbueLists = { W(manager, "imbueList1"), W(manager, "imbueList2"), W(manager, "imbueList3") }
local levelLists = { W(manager, "imbueNivel1"), W(manager, "imbueNivel2"), W(manager, "imbueNivel3") }

local slotWidgets = {
  head = W(manager, "head"),
  body = W(manager, "body"),
  legs = W(manager, "legs"),
  feet = W(manager, "feet"),
  ["left-hand"] = W(manager, "left-hand"),
  ["right-hand"] = W(manager, "right-hand"),
  back = W(manager, "back"),
}

-- =========================================================
-- TEMPLATES
-- =========================================================
local selectRowTemplate = [[
selectRow < UIWidget
  id: root
  height: 13
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.85

  $focus:
    background-color: #2f6f3e
    opacity: 0.95

  Label
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    color: white
    text: ""
]]

local savedRowTemplate = [[
savedRow < UIWidget
  id: root
  height: 45
  focusable: true
  background-color: alpha
  margin-top: 2
  opacity: 1.00
  border: 1 alpha

  $hover:
    background-color: #2F2F2F
    opacity: 0.80
    border: 1 gray

  $focus:
    background-color: #404040
    border: 1 gray
    opacity: 0.90

  UIItem
    id: icon
    anchors.left: parent.left
    anchors.top: parent.top
    margin-left: 4
    margin-top: 2
    size: 40 40

  Label
    id: text
    anchors.left: icon.right
    anchors.right: remove.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    margin-left: 6
    margin-right: 4
    text-align: center
    font: verdana-11px-rounded
    color: white
    text-wrap: true
    text-vertical-auto-resize: true

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 3
    text: X
    color: #FF4040
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

g_ui.loadUIFromString(selectRowTemplate)
g_ui.loadUIFromString(savedRowTemplate)

-- =========================================================
-- HELPERS
-- =========================================================
local function clamp(v, a, b)
  v = tonumber(v) or a
  if v < a then return a end
  if v > b then return b end
  return v
end

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function lowerTrim(s)
  return trim(s):lower()
end

local function cloneTable(orig)
  if type(orig) ~= "table" then return orig end
  local copy = {}
  for k, v in pairs(orig) do
    if type(v) == "table" then
      copy[k] = cloneTable(v)
    else
      copy[k] = v
    end
  end
  return copy
end

local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function later(ms, fn)
  if type(schedule) == "function" then
    return schedule(ms, fn)
  end
  if type(scheduleEvent) == "function" then
    return scheduleEvent(fn, ms)
  end
  if g_dispatcher and g_dispatcher.scheduleEvent then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  return fn()
end

local function clearChildren(widget)
  if not widget or not widget.getChildren then return end
  local children = widget:getChildren()
  for i = #children, 1, -1 do
    local child = children[i]
    if child and (not child.isDestroyed or not child:isDestroyed()) then
      child:destroy()
    end
  end
end

local function getRowLabel(row)
  if not row then return nil end
  return row.text or (row.getChildById and row:getChildById("text")) or nil
end

local function getRowRemove(row)
  if not row then return nil end
  return row.remove or (row.getChildById and row:getChildById("remove")) or nil
end

local function getRowIcon(row)
  if not row then return nil end
  return row.icon or (row.getChildById and row:getChildById("icon")) or nil
end

local function clearRowFocus(listWidget)
  if not listWidget or not listWidget.getChildren then return end
  for _, child in ipairs(listWidget:getChildren()) do
    if child.setFocused then child:setFocused(false) end
    child._selected = false
  end
  listWidget._selectedRow = nil
  listWidget._selectedValue = nil
end

local function setRowFocus(listWidget, row, value)
  if not listWidget or not row then return end
  clearRowFocus(listWidget)
  if row.setFocused then row:setFocused(true) end
  row._selected = true
  listWidget._selectedRow = row
  listWidget._selectedValue = value
end

local function getSelectedRowValue(listWidget)
  if not listWidget then return "" end
  return tostring(listWidget._selectedValue or "")
end

local function createSelectRow(listWidget, text, onSelect)
  local row = g_ui.createWidget("selectRow", listWidget)
  local label = getRowLabel(row)
  row._value = tostring(text or "")

  if label then
    label:setText(row._value)
  end

  row.onClick = function(widget)
    if listWidget._locked then return end
    setRowFocus(listWidget, widget, widget._value)
    if onSelect then onSelect(widget._value, widget) end
  end

  return row
end

local function fillSelectList(listWidget, entries, onSelect)
  if not listWidget then return end
  clearChildren(listWidget)
  clearRowFocus(listWidget)
  for i = 1, #entries do
    createSelectRow(listWidget, entries[i], onSelect)
  end
end

local function selectListValue(listWidget, value)
  if not listWidget or not listWidget.getChildren then return false end
  value = tostring(value or "")
  for _, child in ipairs(listWidget:getChildren()) do
    if tostring(child._value or "") == value then
      setRowFocus(listWidget, child, child._value)
      return true
    end
  end
  clearRowFocus(listWidget)
  return false
end

local function nextUid()
  db.nextUid = (tonumber(db.nextUid) or 0) + 1
  return db.nextUid
end

local function itemTimerKey(itemId)
  return tostring(tonumber(itemId) or 0)
end

local function canonImbueName(name)
  name = trim(tostring(name or ""))
  if name == "" then return "" end

  if name == "Hit Points Leech" then return "Life Leech" end
  if name == "Mana Leech" then return "Mana Leech" end
  if name == "Critical" then return "Critical" end
  if name == "Magic Level" then return "Magic Level" end

  if name == "Skillboost (Distance)" or name == "Skillboost (Sword)" or name == "Skillboost (Club)" or name == "Skillboost (Axe)" then
    return "Skill Boost"
  end

  if name == "Elemental Protection (Fire)" then return "Fire Protection" end
  if name == "Elemental Protection (Ice)" then return "Ice Protection" end
  if name == "Elemental Protection (Earth)" then return "Earth Protection" end
  if name == "Elemental Protection (Energy)" then return "Energy Protection" end
  if name == "Elemental Protection (Death)" then return "Death Protection" end
  if name == "Elemental Protection (Holy)" then return "Holy Protection" end

  return LOOK_NAME_TO_VISUAL[name] or name
end

local function tierNameToNumber(name)
  name = lowerTrim(name)
  if name == "basic" then return 1 end
  if name == "intricate" then return 2 end
  return 3
end

local function getTierFromWindowName(name)
  name = lowerTrim(name)
  if name:find("basic", 1, true) then return 1 end
  if name:find("intricate", 1, true) then return 2 end
  if name:find("powerful", 1, true) then return 3 end
  return 3
end

local function uiItemSlotNameToType(slotId)
  if slotId == "head" then return "Helmet" end
  if slotId == "body" then return "Armor" end
  if slotId == "legs" then return "Legs" end
  if slotId == "feet" then return "Boots" end
  if slotId == "left-hand" then return "Weapon" end
  if slotId == "right-hand" then return "Shield/Book" end
  if slotId == "back" then return "Bag" end
  return ""
end

local function typeToSlotKey(typ)
  if typ == "Helmet" then return "head" end
  if typ == "Armor" then return "body" end
  if typ == "Legs" then return "legs" end
  if typ == "Boots" then return "feet" end
  if typ == "Weapon" then return "left-hand" end
  if typ == "Shield/Book" then return "right-hand" end
  if typ == "Bag" then return "back" end
  return nil
end

local function getDistance(a, b)
  return math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function getChebyshevDistance(a, b)
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function isWalkablePos(pos)
  local tile = g_map.getTile(pos)
  if not tile then return false end
  if tile.isWalkable then
    return tile:isWalkable()
  end
  return true
end

local function getBestAdjacentShrinePos(shrinePos, playerPos)
  local candidates = {
    {x = shrinePos.x + 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x + 1, y = shrinePos.y - 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y + 1, z = shrinePos.z},
    {x = shrinePos.x - 1, y = shrinePos.y - 1, z = shrinePos.z},
  }

  local bestPos, bestDist = nil, 99999
  for _, pos in ipairs(candidates) do
    if isWalkablePos(pos) then
      local dist = getDistance(playerPos, pos)
      if dist < bestDist then
        bestDist = dist
        bestPos = pos
      end
    end
  end

  return bestPos
end

local function normalizeEntry(entry)
  entry = entry or {}
  entry.uid = tonumber(entry.uid or 0) or 0
  entry.itemId = tonumber(entry.itemId or 0) or 0
  entry.type = entry.type or ""
  entry.slotKey = entry.slotKey or typeToSlotKey(entry.type)
  entry.slots = clamp(entry.slots or 1, 1, 3)
  entry.imbues = entry.imbues or {}

  for i = 1, entry.slots do
    entry.imbues[i] = entry.imbues[i] or {name = "", level = "Basic"}
    entry.imbues[i].name = trim(entry.imbues[i].name or "")
    entry.imbues[i].level = trim(entry.imbues[i].level or "Basic")
  end

  return entry
end

local function formatImbText(imbs, qtd)
  local parts = {}
  qtd = tonumber(qtd or #imbs) or #imbs

  for i = 1, qtd do
    local n = tostring(imbs[i] and imbs[i].name or "")
    local l = tostring(imbs[i] and imbs[i].level or "")
    if n ~= "" and n ~= "nil" then
      if l ~= "" and l ~= "nil" then
        parts[#parts + 1] = n .. " (" .. l .. ")"
      else
        parts[#parts + 1] = n
      end
    end
  end

  if #parts == 0 then return "(Nenhum)" end
  return table.concat(parts, "\n")
end

-- =========================================================
-- STATE UI
-- =========================================================
local state = {
  slot = nil,
  imbues = { nil, nil, nil },
  levels = { "Basic", "Basic", "Basic" },
  editingUid = nil
}

local imbState = {
  active = false,
  queue = {},
  idx = 1,
  waitingWindow = false,
  waitingApply = false,
  currentEntry = nil,
  currentItem = nil,
  currentItemSource = nil,
  shrine = nil,
  shrinePos = nil,
  lastAction = 0,
  reopenAfterClear = false
}

-- =========================================================
-- UI HELPERS
-- =========================================================
local function refreshSlotBorders()
  for name, widget in pairs(slotWidgets) do
    if widget and widget.setBorderWidth then widget:setBorderWidth(1) end
    if widget and widget.setBorderColor then
      widget:setBorderColor(name == state.slot and "#00ff66" or "#3a3a3a")
    end
    if widget and widget.setOpacity then
      widget:setOpacity(name == state.slot and 1.0 or 0.85)
    end
  end
end

local function setSectionEnabled(i, enabled)
  local a, b = imbueLists[i], levelLists[i]

  if a then
    a._locked = not enabled
    if a.setEnabled then a:setEnabled(enabled) end
    if a.setFocusable then a:setFocusable(enabled) end
    if a.setOpacity then a:setOpacity(enabled and 1.0 or 0.40) end
  end

  if b then
    b._locked = not enabled
    if b.setEnabled then b:setEnabled(enabled) end
    if b.setFocusable then b:setFocusable(enabled) end
    if b.setOpacity then b:setOpacity(enabled and 1.0 or 0.40) end
  end
end

local function getQtd()
  if refs.qtd and refs.qtd.getValue then
    return clamp(refs.qtd:getValue(), 1, 3)
  end
  return 1
end

local function updateLimparText(v)
  v = clamp(v or 1, 1, 1200)
  db.limparMinutes = v
  if refs.limparText then refs.limparText:setText(v .. " min") end
end

local function setShrine(mode)
  db.shrineMode = (mode == "portable" and "portable" or "imbuing")
  if refs.shrine and refs.shrine.setOn then refs.shrine:setOn(db.shrineMode == "imbuing") end
  if refs.portable and refs.portable.setOn then refs.portable:setOn(db.shrineMode == "portable") end
end

local function buildSelectList(listWidget, options, selected, enabled, setter)
  if not listWidget then return end
  clearChildren(listWidget)

  for _, value in ipairs(options) do
    local row = g_ui.createWidget("selectRow", listWidget)
    local label = getRowLabel(row)
    row._value = value

    if label then label:setText(value) end

    if enabled and selected == value then
      setRowFocus(listWidget, row, value)
    end

    row.onClick = function(widget)
      if listWidget._locked then return end
      setRowFocus(listWidget, widget, widget._value)
      if setter then setter(value) end
    end

    if not enabled then
      if row.setEnabled then row:setEnabled(false) end
      if row.setOpacity then row:setOpacity(0.40) end
    end
  end
end

local function refreshManagerLists()
  local qtd = getQtd()

  for i = 1, 3 do
    local enabled = i <= qtd
    if not enabled then
      state.imbues[i] = nil
      state.levels[i] = "Basic"
    end

    setSectionEnabled(i, enabled)

    buildSelectList(imbueLists[i], IMBUE_OPTIONS, state.imbues[i], enabled, function(v)
      state.imbues[i] = v
    end)

    buildSelectList(levelLists[i], IMBUE_LEVELS, state.levels[i], enabled, function(v)
      state.levels[i] = v
    end)
  end
end

local function resetManager()
  state.slot = nil
  state.editingUid = nil
  state.imbues = { nil, nil, nil }
  state.levels = { "Basic", "Basic", "Basic" }

  if refs.item and refs.item.setItemId then refs.item:setItemId(0) end
  if refs.qtd and refs.qtd.setValue then refs.qtd:setValue(1) end

  refreshSlotBorders()
  refreshManagerLists()
end

local function loadEntryToManager(entry)
  entry = normalizeEntry(cloneTable(entry))
  state.editingUid = tonumber(entry.uid) or nil
  state.slot = entry.slotKey or typeToSlotKey(entry.type)
  state.imbues = { nil, nil, nil }
  state.levels = { "Basic", "Basic", "Basic" }

  if refs.item and refs.item.setItemId then refs.item:setItemId(entry.itemId or 0) end
  if refs.qtd and refs.qtd.setValue then refs.qtd:setValue(entry.slots or 1) end

  for i = 1, entry.slots do
    state.imbues[i] = entry.imbues[i] and entry.imbues[i].name or nil
    state.levels[i] = entry.imbues[i] and entry.imbues[i].level or "Basic"
  end

  refreshSlotBorders()
  refreshManagerLists()
end

local function removeEntryByUid(uid)
  uid = tonumber(uid)
  if not uid then return end

  for i = #db.entries, 1, -1 do
    if tonumber(db.entries[i].uid) == uid then
      table.remove(db.entries, i)
      break
    end
  end

  rebuildMainList()
end

local function createSavedRow(listWidget, entry, onRemove)
  local row = g_ui.createWidget("savedRow", listWidget)
  local icon = getRowIcon(row)
  local label = getRowLabel(row)
  local remove = getRowRemove(row)

  row._uid = tonumber(entry.uid)

  if icon and icon.setItemId then
    icon:setItemId(tonumber(entry.itemId) or 0)
    icon.onItemChange = function() icon:setItemId(tonumber(entry.itemId) or 0) end
    icon.onDrop = function() return false end
  end

  if label then
    label:setText(formatImbText(entry.imbues or {}, entry.slots))
  end

  row.onClick = function(widget)
    setRowFocus(listWidget, widget, widget._uid)
    for i = 1, #db.entries do
      if tonumber(db.entries[i].uid) == tonumber(widget._uid) then
        loadEntryToManager(db.entries[i])
        panel:hide()
        manager:show()
        manager:raise()
        manager:focus()
        break
      end
    end
  end

  if remove then
    remove.onClick = function()
      if onRemove then onRemove(entry, row) end
    end
  end

  return row
end

function rebuildMainList()
  if not refs.list then return end
  clearChildren(refs.list)
  clearRowFocus(refs.list)

  for i = 1, #db.entries do
    local entry = normalizeEntry(db.entries[i])
    db.entries[i] = entry
    createSavedRow(refs.list, entry, function(data)
      removeEntryByUid(data.uid)
    end)
  end
end

local function saveEntry()
  local itemId = refs.item and refs.item.getItemId and tonumber(refs.item:getItemId()) or 0
  local slotKey = state.slot
  local slots = getQtd()

  if itemId <= 0 then
    warn("[Imb] Selecione um item.")
    return false
  end

  if not slotKey or slotKey == "" then
    warn("[Imb] Selecione o slot do equipamento.")
    return false
  end

  local entry = {
    uid = state.editingUid or nextUid(),
    itemId = itemId,
    slotKey = slotKey,
    type = uiItemSlotNameToType(slotKey),
    slots = slots,
    imbues = {}
  }

  for i = 1, slots do
    local name = trim(state.imbues[i] or "")
    local level = trim(state.levels[i] or "Basic")

    if name == "" then
      warn("[Imb] Selecione o imbue do slot " .. i .. ".")
      return false
    end

    if level == "" then
      warn("[Imb] Selecione o nível do slot " .. i .. ".")
      return false
    end

    entry.imbues[i] = { name = name, level = level }
  end

  local replaced = false
  for i = 1, #db.entries do
    if tonumber(db.entries[i].uid) == tonumber(entry.uid) then
      db.entries[i] = normalizeEntry(entry)
      replaced = true
      break
    end
  end

  if not replaced then
    db.entries[#db.entries + 1] = normalizeEntry(entry)
  end

  return true
end

-- =========================================================
-- UI BIND
-- =========================================================
buttonImbuiment = setupUI([[
Panel
  height: 18

  Button
    id: settings
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-left: 0
    height: 18
    text: Imbuement Manager
    opacity: 1.00

]], parent)

db.enabled = true

buttonImbuiment.settings.onClick = function()
  if panel:isVisible() then
    panel:hide()
    manager:hide()
  else
    rebuildMainList()
    panel:show()
    panel:raise()
    panel:focus()
  end
end

function checkerImbuementsList()
  if db.enabled ~= true then return true end
  if imbState.active then return "retry" end
  startImbueAllFromList()
  CaveBot.setOff()
  return "retry"
end

local imbIcon = addIcon("imbI", {
  item = 14513,
  text = "M.Imbue",
  switchable = false,
  moveable = true,
}, function()
  startImbueAllFromList(true)
end)

imbIcon:setSize({height = 57, width = 54})
imbIcon.text:setFont('verdana-11px-rounded')
imbIcon.item:setSize('35 35')

if refs.limpar then
  if refs.limpar.setMinimum then refs.limpar:setMinimum(1) end
  if refs.limpar.setMaximum then refs.limpar:setMaximum(1200) end
  if refs.limpar.setValue then refs.limpar:setValue(clamp(db.limparMinutes or 60, 1, 1200)) end
  refs.limpar.onValueChange = function()
    updateLimparText(refs.limpar:getValue())
  end
end
updateLimparText(db.limparMinutes or 60)

if refs.shrine then
  refs.shrine.onClick = function() setShrine("imbuing") end
end
if refs.portable then
  refs.portable.onClick = function() setShrine("portable") end
end
setShrine(db.shrineMode or "imbuing")

if refs.open then
  refs.open.onClick = function()
    resetManager()
    panel:hide()
    manager:show()
    manager:raise()
    manager:focus()
  end
end

if refs.close then
  refs.close.onClick = function()
    panel:hide()
    manager:hide()
  end
end

if refs.cancel then
  refs.cancel.onClick = function()
    manager:hide()
    panel:show()
    panel:raise()
    panel:focus()
    resetManager()
  end
end

if refs.confirm then
  refs.confirm.onClick = function()
    if not saveEntry() then return end
    rebuildMainList()
    manager:hide()
    panel:show()
    panel:raise()
    panel:focus()
    resetManager()
  end
end

if refs.qtd then
  refs.qtd.onValueChange = function()
    refreshManagerLists()
  end
  refs.qtd.onValueChanged = function()
    refreshManagerLists()
  end
end

for _, id in ipairs(SLOT_WIDGET_IDS) do
  local w = slotWidgets[id]
  if w then
    w.onClick = function()
      state.slot = id
      refreshSlotBorders()
    end
    w.onMouseRelease = function(widget, mousePos, button)
      if button ~= MouseLeftButton then return false end
      state.slot = id
      refreshSlotBorders()
      return true
    end
  end
end

refreshManagerLists()
refreshSlotBorders()
rebuildMainList()

-- =========================================================
-- ITEM FIND / LOOK
-- =========================================================
local function findItemInContainers(itemId)
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

local function getInventoryItemBySlot(slotKey)
  local invSlot = SLOT_TO_INV[slotKey]
  if not invSlot then return nil end

  if getInventoryItem then
    return getInventoryItem(invSlot)
  end

  if g_game and g_game.getLocalPlayer and g_game.getLocalPlayer() and g_game.getLocalPlayer().getInventoryItem then
    return g_game.getLocalPlayer():getInventoryItem(invSlot)
  end

  return nil
end

local function findItemObject(itemId, typText, slotKey)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return nil end

  local equipped = slotKey and getInventoryItemBySlot(slotKey) or nil
  if equipped and equipped.getId and equipped:getId() == itemId then
    return equipped, "equip"
  end

  if type(findItem) == "function" then
    local any = findItem(itemId)
    if any and any.getId and any:getId() == itemId then
      return any, "findItem"
    end
  end

  local cont = findItemInContainers(itemId)
  if cont then return cont, "container" end

  return nil, nil
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

-- =========================================================
-- LOOK PARSE / TIMERS
-- =========================================================
local function parseTimeToSeconds(text)
  text = tostring(text or "")

  local hh, mm = text:match("(%d+):(%d+)%s*[hH]")
  if hh and mm then
    return (tonumber(hh) or 0) * 3600 + (tonumber(mm) or 0) * 60
  end

  hh, mm = text:match("(%d+):(%d+)")
  if hh and mm then
    return (tonumber(hh) or 0) * 3600 + (tonumber(mm) or 0) * 60
  end

  local h2, m2 = text:match("(%d+)%s*[hH]%s*(%d+)%s*[mM]")
  if h2 then
    return (tonumber(h2) or 0) * 3600 + (tonumber(m2) or 0) * 60
  end

  local h3 = text:match("(%d+)%s*[hH]")
  if h3 then
    return (tonumber(h3) or 0) * 3600
  end

  return nil
end

local function parseImbuesFromLookText(text)
  text = tostring(text or "")
  local imbBlock = text:match("Imbuements:%s*%((.-)%)")
  if not imbBlock or imbBlock == "" then return {} end

  local out = {}

  for part in imbBlock:gmatch("([^,]+)") do
    part = trim(part)
    if part ~= "" and not part:find("Free Slot", 1, true) then
      local tier, rest = part:match("^(Basic)%s+(.+)$")
      if not tier then tier, rest = part:match("^(Intricate)%s+(.+)$") end
      if not tier then tier, rest = part:match("^(Powerful)%s+(.+)$") end

      tier = trim(tier or "")
      rest = trim(rest or part)

      local timeToken = rest:match("(%d+:%d+%s*[hH])") or rest:match("(%d+%s*[hH]%s*%d+%s*[mM])")
      local rawName = rest
      if timeToken then
        rawName = trim(rest:gsub(timeToken, ""))
      end

      local visual = LOOK_NAME_TO_VISUAL[rawName] or rawName
      local sec = timeToken and parseTimeToSeconds(timeToken) or nil
      local timeStr = "--:--"

      if timeToken then
        local hh, mm = timeToken:match("(%d+):(%d+)")
        if hh and mm then
          timeStr = string.format("%02d:%02d", tonumber(hh) or 0, tonumber(mm) or 0)
        else
          local h2, m2 = timeToken:match("(%d+)%s*[hH]%s*(%d+)%s*[mM]")
          if h2 then
            timeStr = string.format("%02d:%02d", tonumber(h2) or 0, tonumber(m2) or 0)
          end
        end
      end

      out[#out + 1] = {
        tier = tier,
        raw = rawName,
        visual = visual,
        seconds = sec,
        timeStr = timeStr
      }
    end
  end

  return out
end

local function updateTimerFromLook(itemId, lookText)
  local key = tostring(tonumber(itemId) or 0)
  local detected = parseImbuesFromLookText(lookText)
  local updatedNow = nowMs()

  storage.autoImbuement = storage.autoImbuement or {}
  storage.autoImbuement.timers = storage.autoImbuement.timers or {}

  storage.autoImbuement.timers[key] = storage.autoImbuement.timers[key] or {}
  storage.autoImbuement.timers[key].detected = detected
  storage.autoImbuement.timers[key].updated = updatedNow

  -- espelha também no storage antigo só por compatibilidade/debug
  storage.imbuimentSystem = storage.imbuimentSystem or {}
  storage.imbuimentSystem.timers = storage.imbuimentSystem.timers or {}
  storage.imbuimentSystem.timers[key] = storage.imbuimentSystem.timers[key] or {}
  storage.imbuimentSystem.timers[key].detected = detected
  storage.imbuimentSystem.timers[key].updated = updatedNow

  db.timers = storage.autoImbuement.timers
end

local function getDetectedImbueTimeByVisual(itemId, visualName)
  local info = db.timers[itemTimerKey(itemId)]
  if not info or type(info.detected) ~= "table" then return nil end

  visualName = tostring(visualName or "")
  for i = 1, #info.detected do
    local d = info.detected[i]
    if tostring(d.visual or "") == visualName then
      return tonumber(d.seconds or 0) or 0
    end
  end

  return nil
end

local function isRecentAction(itemId)
  local key = itemTimerKey(itemId)
  local t = tonumber(db.recentActions[key] or 0) or 0
  if t <= 0 then return false end

  local diff = nowMs() - t

  if diff < 0 then
    db.recentActions[key] = nil
    return false
  end

  if diff >= RECENT_ACTION_MS then
    db.recentActions[key] = nil
    return false
  end

  return true
end

local function markRecentAction(itemId)
  db.recentActions[itemTimerKey(itemId)] = nowMs()
end

-- =========================================================
-- SHRINE / PORTABLE
-- =========================================================
local function findNearestShrine()
  if not player or not player.getPosition then return nil, nil end
  local playerPos = player:getPosition()
  local bestShrine, bestDist, bestPos = nil, 99999, nil

  for x = -7, 7 do
    for y = -5, 5 do
      local scanPos = {x = playerPos.x + x, y = playerPos.y + y, z = playerPos.z}
      local tile = g_map.getTile(scanPos)
      if tile then
        local items = tile:getItems()
        if items then
          for _, item in ipairs(items) do
            local itemId = item:getId()
            for _, shrineId in ipairs(SHRINES) do
              if itemId == shrineId then
                local dist = getDistance(playerPos, scanPos)
                if dist < bestDist then
                  bestDist = dist
                  bestShrine = item
                  bestPos = scanPos
                end
                break
              end
            end
          end
        end
      end
    end
  end

  return bestShrine, bestPos
end

local function isNearShrine(shrine)
  if not shrine or not shrine.getPosition or not player or not player.getPosition then return false end
  local playerPos = player:getPosition()
  local shrinePos = shrine:getPosition()
  return getChebyshevDistance(playerPos, shrinePos) <= 1
end

local function ensureNearShrine(shrine)
  if not shrine or not shrine.getPosition then return false end
  if isNearShrine(shrine) then return true end

  local playerPos = player:getPosition()
  local shrinePos = shrine:getPosition()
  local walkPos = getBestAdjacentShrinePos(shrinePos, playerPos)

  if not walkPos then
    return false
  end

  if getDistance(playerPos, walkPos) > 0 then
    autoWalk(walkPos, 20, {ignoreNonPathable = true, precision = 1})
  end

  return false
end

local function useThingWithSafe(a, b)
  if type(useThingWith) == "function" then
    return useThingWith(a, b)
  end
  if type(useWith) == "function" then
    return useWith(a, b)
  end
  return false
end

local function openShrineOnItem(itemObj)
  if not itemObj then return false end

  if db.shrineMode == "portable" then
    local portable = findItem and findItem(PORTABLE_SHRINE) or nil
    if not portable then
      return false
    end
    return useThingWithSafe(portable, itemObj)
  end

  local shrine, shrinePos = findNearestShrine()
  if not shrine then
    return false
  end

  imbState.shrine = shrine
  imbState.shrinePos = shrinePos

  if not isNearShrine(shrine) then
    ensureNearShrine(shrine)

    later(1800, function()
      if not imbState.active then return end
      if not imbState.currentItem then return end
      if not imbState.shrine then return end
      if not isNearShrine(imbState.shrine) then return end

      imbState.waitingWindow = true
      imbState.lastAction = nowMs()
      useThingWithSafe(imbState.shrine, imbState.currentItem)
    end)

    return true
  end

  return useThingWithSafe(shrine, itemObj)
end

-- =========================================================
-- IMB WINDOW MATCH
-- =========================================================
local function getTierFromEntryLevel(levelName)
  return tierNameToNumber(levelName)
end

local function findImbueFromWindow(windowImbuements, visualName, tierNum)
  if type(windowImbuements) ~= "table" then return nil end

  visualName = tostring(visualName or "")
  if visualName == "" then return nil end

  local groupInternal = IMBUE_VISUAL_TO_GROUP[visualName]
  if not groupInternal then
    return nil
  end

  local shrineText = GROUP_TO_SHRINE_TEXT[groupInternal] or groupInternal
  tierNum = tonumber(tierNum) or 3

  for i = 1, #windowImbuements do
    local imb = windowImbuements[i]
    local groupName = tostring(imb.group or "")
    local windowName = tostring(imb.name or "")

    local okGroup =
      (groupName == shrineText) or
      (windowName:find(shrineText, 1, true) ~= nil) or
      (windowName:find(groupInternal, 1, true) ~= nil) or
      (windowName:find(visualName, 1, true) ~= nil)

    if okGroup then
      local tier = getTierFromWindowName(windowName)
      if tier == tierNum then
        return imb
      end
    end
  end

  return nil
end

local function tryClearImbuement(slotIdx)
  slotIdx = tonumber(slotIdx) or 0

  if g_game and type(g_game.clearImbuement) == "function" then
    g_game.clearImbuement(slotIdx, true)
    return true
  end

  if g_game and type(g_game.removeImbuement) == "function" then
    g_game.removeImbuement(slotIdx, true)
    return true
  end

  if g_game and type(g_game.clearImbuementSlot) == "function" then
    g_game.clearImbuementSlot(slotIdx, true)
    return true
  end

  if type(clearImbuement) == "function" then
    clearImbuement(slotIdx, true)
    return true
  end

  if type(removeImbuement) == "function" then
    removeImbuement(slotIdx, true)
    return true
  end

  return false
end

local function tryApplyImbuement(slotIdx, imbData)
  if not imbData then return false end

  if g_game and type(g_game.applyImbuement) == "function" then
    g_game.applyImbuement(slotIdx, imbData.id, true)
    return true
  end

  return false
end

local function buildActionsForEntry(entry, activeSlots, windowImbuements)
  local actions = {}
  local thresholdSec = (tonumber(db.limparMinutes or 0) or 0) * 60

  for slotIdx = 0, entry.slots - 1 do
    local cfg = entry.imbues[slotIdx + 1]
    if cfg and trim(cfg.name) ~= "" then
      local desiredVisual = canonImbueName(cfg.name)
      local desiredTier = getTierFromEntryLevel(cfg.level)

      local active = activeSlots and activeSlots[slotIdx] or nil
      local shouldApply = false

      if active then
        local activeInfo = active[1]
        local activeTime = tonumber(active[2] or 0) or 0
        local activeName = canonImbueName(activeInfo and (activeInfo.group or activeInfo.name) or "")

        if activeName == desiredVisual then
          if activeTime <= thresholdSec then
            actions[#actions + 1] = {
              kind = "clear",
              slotIdx = slotIdx,
              visualName = desiredVisual
            }
            shouldApply = true
          end
        else
          actions[#actions + 1] = {
            kind = "clear",
            slotIdx = slotIdx,
            visualName = desiredVisual
          }
          shouldApply = true
        end
      else
        shouldApply = true
      end

      if shouldApply then
        local imbData = findImbueFromWindow(windowImbuements, desiredVisual, desiredTier)
        if imbData then
          actions[#actions + 1] = {
            kind = "apply",
            slotIdx = slotIdx,
            visualName = desiredVisual,
            imbData = imbData
          }
        else
        end
      end
    end
  end

  return actions
end

local function runActions(actions, onDone)
  local idx = 1

  local function nextAction()
    if idx > #actions then
      if onDone then onDone() end
      return
    end

    local action = actions[idx]
    idx = idx + 1

    if action.kind == "clear" then
      if not tryClearImbuement(action.slotIdx) then
        later(500, nextAction)
        return
      end
      later(1800, nextAction)
      return
    end

    if action.kind == "apply" then
      if not tryApplyImbuement(action.slotIdx, action.imbData) then
        later(500, nextAction)
        return
      end
      later(2200, nextAction)
      return
    end

    later(200, nextAction)
  end

  nextAction()
end

-- =========================================================
-- RUNTIME QUEUE
-- =========================================================
local function resetImbState()
  imbState.active = false
  imbState.queue = {}
  imbState.idx = 1
  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.currentEntry = nil
  imbState.currentItem = nil
  imbState.currentItemSource = nil
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.lastAction = 0
  imbState.reopenAfterClear = false
end

local function buildAutoImbueQueue()
  local q = {}

  for i, entry in ipairs(db.entries or {}) do
    entry = normalizeEntry(entry)
    local itemObj, source = findItemObject(entry.itemId, entry.type, entry.slotKey)
    if itemObj and itemObj.getId and itemObj:getId() == entry.itemId then
      q[#q + 1] = {
        entry = entry,
        itemId = entry.itemId,
        typ = entry.type,
        slotKey = entry.slotKey,
        itemObj = itemObj,
        source = source
      }
    end
  end

  return q
end


function startImbueAllFromList()
  CaveBot.setOff()
  if db.enabled ~= true then
    warn("[Imb] Ative o BotSwitch 'Imbuiments' para usar.")
    return
  end
  if imbState.active then
    warn("[Imb] Já está processando.")
    return
  end
  if #db.entries == 0 then
    warn("[Imb] Sua lista está vazia.")
    return
  end

  local q = buildAutoImbueQueue()
  if #q == 0 then
    warn("[Imb] Nenhum item configurado foi encontrado.")
    return
  end

  imbState.active = true
  imbState.queue = q
  imbState.idx = 1
  imbState.waitingWindow = false
  imbState.waitingApply = false
  imbState.currentEntry = nil
  imbState.currentItem = nil
  imbState.currentItemSource = nil
  imbState.shrine = nil
  imbState.shrinePos = nil
  imbState.lastAction = nowMs()
  imbState.reopenAfterClear = false

end

-- =========================================================
-- WINDOW CALLBACK
-- =========================================================
local function onWindow(itemId, slots, activeSlots, windowImbuements, needItems)
  if not imbState.active then return end
  if not imbState.currentEntry then return end

  local entry = imbState.currentEntry
  if tonumber(entry.itemId) ~= tonumber(itemId) then
    return
  end

  imbState.waitingWindow = false
  imbState.waitingApply = true
  imbState.lastAction = nowMs()

  local actions = buildActionsForEntry(entry, activeSlots or {}, windowImbuements or {})
  
  -- Se não há mais nenhuma ação na fila, o item está perfeitamente imbuido!
  if #actions == 0 then
    print("[AutoImb] Item " .. tostring(itemId) .. " 100% pronto!")
    markRecentAction(itemId)
    imbState.waitingApply = false
    later(300, function()
      if g_game and g_game.closeImbuingWindow then g_game.closeImbuingWindow() end
    end)
    return
  end

  -- O SEGREDO ESTÁ AQUI: Pega APENAS a primeira ação e manda para o servidor.
  -- Depois disso, aguarda o servidor responder com a janela atualizada!
  local action = actions[1]

  if action.kind == "clear" then
    tryClearImbuement(action.slotIdx)
  elseif action.kind == "apply" then
    tryApplyImbuement(action.slotIdx, action.imbData)
  end

  -- Timeout de segurança: Se o bot tentar aplicar e falhar (ex: falta de materiais na backpack),
  -- o servidor do Tibia não vai atualizar a janela. Esse delay libera o bot para ir para o próximo item.
  later(3500, function()
    if imbState.active and imbState.waitingApply and imbState.currentEntry and imbState.currentEntry.itemId == itemId then
        markRecentAction(itemId)
        imbState.waitingApply = false
        if g_game and g_game.closeImbuingWindow then g_game.closeImbuingWindow() end
    end
  end)
end

if type(onImbuementWindow) == "function" then
  onImbuementWindow(onWindow)
else
end

-- =========================================================
-- MAIN ENGINE
-- =========================================================
macro(200, function()
  if db.enabled ~= true then return end
  if not imbState.active then return end

  local t = nowMs()
  if t - (imbState.lastAction or 0) < 800 then return end
  if imbState.waitingWindow or imbState.waitingApply then return end

  if imbState.idx > #imbState.queue then
    resetImbState()
    destroyImbuingPanel()
    CaveBot.setOn()
    return
  end

  local data = imbState.queue[imbState.idx]
  imbState.idx = imbState.idx + 1

  local entry = data.entry
  local itemObj, source = findItemObject(data.itemId, data.typ, data.slotKey)

  if not itemObj or not itemObj.getId or itemObj:getId() ~= data.itemId then
    imbState.lastAction = t
    return
  end

  if isRecentAction(data.itemId) then
    db.recentActions[itemTimerKey(data.itemId)] = nil
    imbState.idx = imbState.idx + 1
    imbState.lastAction = t
    return
  end

  imbState.currentEntry = entry
  imbState.currentItem = itemObj
  imbState.currentItemSource = source
  imbState.waitingWindow = true
  imbState.lastAction = t
    
  openShrineOnItem(itemObj)
end)

-- =========================================================
-- LOOK UPDATE TIMER
-- =========================================================
local lookState = {
  waitingItemId = nil,
  waitingTextUntil = 0,
  queue = {},
  idx = 1,
  running = false
}

local function buildLookQueue()
  local q = {}
  local seen = {}

  for i = 1, #db.entries do
    local entry = normalizeEntry(db.entries[i])
    if entry.itemId > 0 and not seen[entry.itemId] then
      seen[entry.itemId] = true
      q[#q + 1] = cloneTable(entry)
    end
  end

  return q
end

local function processLookQueue()
  if lookState.running ~= true then return end
  if lookState.waitingItemId then return end

  if lookState.idx > #lookState.queue then
    lookState.running = false
    return
  end

  local entry = lookState.queue[lookState.idx]
  lookState.idx = lookState.idx + 1

  local itemObj = nil
  itemObj = getInventoryItemBySlot(entry.slotKey)
  if not itemObj or not itemObj.getId or itemObj:getId() ~= entry.itemId then
    itemObj = findItemInContainers(entry.itemId)
  end

  if not itemObj then
    later(150, processLookQueue)
    return
  end

  lookState.waitingItemId = tonumber(entry.itemId)
  lookState.waitingTextUntil = nowMs() + 3000

  if not doLook(itemObj) then
    lookState.waitingItemId = nil
    later(120, processLookQueue)
  end
end

macro(25000, function()
  if #db.entries == 0 then return end
  if imbState.active then return end
  if lookState.running then return end

  lookState.queue = buildLookQueue()
  lookState.idx = 1
  lookState.running = true
  lookState.waitingItemId = nil
  processLookQueue()
end)

macro(200, function()
  if not lookState.waitingItemId then return end
  if nowMs() > (lookState.waitingTextUntil or 0) then
    lookState.waitingItemId = nil
    later(50, processLookQueue)
  end
end)

-- =========================================================
-- STATUS MESSAGE HOOK
-- =========================================================
botserver = botserver or { __callbacks = {} }

if not onStatusMessage then
  botserver.__callbacks.onStatusMessage = {}

  onStatusMessage = function(callback)
    table.insert(botserver.__callbacks.onStatusMessage, function(...)
      callback(...)
    end)

    local cb = botserver.__callbacks.onStatusMessage[#botserver.__callbacks.onStatusMessage]
    return {
      remove = function()
        for i, cb2 in ipairs(botserver.__callbacks.onStatusMessage) do
          if cb == cb2 then
            table.remove(botserver.__callbacks.onStatusMessage, i)
            break
          end
        end
      end
    }
  end
end

if modules and modules.game_textmessage and not botserver.__imbHookInstalled then
  botserver.__imbHookInstalled = true
  local oldStatus = modules.game_textmessage.displayStatusMessage

  modules.game_textmessage.displayStatusMessage = function(text, color)
    if oldStatus then
      oldStatus(text, color)
    end

    local callbacks = botserver.__callbacks.onStatusMessage or {}
    for i = 1, #callbacks do
      callbacks[i](text)
    end
  end
end

onTextMessage(function(mode, text)
  if not lookState.waitingItemId then return end
  if type(text) ~= "string" then return end
  if not text:find("Imbuements:", 1, true) then return end

  updateTimerFromLook(lookState.waitingItemId, text)
  lookState.waitingItemId = nil

  later(80, processLookQueue)
end)

function cavebotCheckImbueByLook()
  local db = storage.autoImbuement or {}

  if db.enabled ~= true then
    return "Hunt"
  end

  if type(db.entries) ~= "table" or #db.entries == 0 then
    return "Hunt"
  end

  if type(db.timers) ~= "table" then
    return "retry"
  end

  local thresholdSec = (tonumber(db.limparMinutes or 0) or 0) * 60

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

  local function canonImbueName(name)
    name = trim(name)
    if name == "" then return "" end

    if name == "Hit Points Leech" then return "Life Leech" end
    if name == "Mana Leech" then return "Mana Leech" end
    if name == "Critical" then return "Critical" end
    if name == "Magic Level" then return "Magic Level" end

    if name == "Skillboost (Distance)" or name == "Skillboost (Sword)" or name == "Skillboost (Club)" or name == "Skillboost (Axe)" then
      return "Skill Boost"
    end

    if name == "Elemental Protection (Fire)" then return "Fire Protection" end
    if name == "Elemental Protection (Ice)" then return "Ice Protection" end
    if name == "Elemental Protection (Earth)" then return "Earth Protection" end
    if name == "Elemental Protection (Energy)" then return "Energy Protection" end
    if name == "Elemental Protection (Death)" then return "Death Protection" end
    if name == "Elemental Protection (Holy)" then return "Holy Protection" end

    return LOOK_NAME_TO_VISUAL[name] or name
  end

  for i = 1, #db.entries do
    local entry = db.entries[i]
    local itemId = tonumber(entry.itemId or 0) or 0
    local slots = tonumber(entry.slots or 1) or 1
    local imbues = entry.imbues or {}

    if itemId > 0 then
      local info = db.timers[tostring(itemId)]

      -- ainda não recebeu look desse item
      if not info or type(info.detected) ~= "table" then
        return "retry"
      end

      for slot = 1, slots do
        local cfg = imbues[slot]
        if cfg and trim(cfg.name) ~= "" then
          local wanted = canonImbueName(cfg.name)
          local found = nil

          for j = 1, #info.detected do
            local d = info.detected[j]
            if tostring(d.visual or "") == wanted then
              found = d
              break
            end
          end

          if not found then
            return "REFRESH"
          end

          local sec = tonumber(found.seconds or 0) or 0
          if sec <= thresholdSec then
            print("[Imb/Cavebot] tempo baixo: item " .. itemId .. " / " .. wanted .. " / " .. sec .. "s <= " .. thresholdSec .. "s")
            return "REFRESH"
          end
        end
      end
    end
  end

  return "Hunt"
end
-- =========================================================
-- AUTO START / INIT
-- =========================================================
panel:hide()
manager:hide()
