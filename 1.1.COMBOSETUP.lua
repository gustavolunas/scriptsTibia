local MANAGER_STORAGE_KEY = "combo_actions_global_v1"
local MANAGER_SYNC_KEY    = "combo_manager_sync_v1"

storage[MANAGER_STORAGE_KEY] = storage[MANAGER_STORAGE_KEY] or {
  main = {},
  actions = {},
  draft = { spell = { cd = 0 }, rune = { cd = 0, id = 0 } }
}

storage[MANAGER_SYNC_KEY] = storage[MANAGER_SYNC_KEY] or { rev = 0 }

local managerCfg = storage[MANAGER_STORAGE_KEY]
managerCfg.actions = managerCfg.actions or {}

local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return (os.time() * 1000) + math.floor((os.clock() * 1000) % 1000)
end

local function clearChildren(w)
  if not w then return end
  local children = w:getChildren() or {}
  for i = #children, 1, -1 do
    local child = children[i]
    if child and not child:isDestroyed() then
      child:destroy()
    end
  end
end

local function setItemIcon(widget, itemId)
  if not widget then return end
  itemId = tonumber(itemId)
  if not itemId or itemId <= 0 then
    widget:setVisible(false)
    return
  end

  widget:setVisible(true)

  if widget.setItemId then
    widget:setItemId(itemId)
    return
  end

  if widget.setItem and g_things and g_things.getThingType then
    widget:setItem({ id = itemId, count = 1 })
  end
end

local function bumpManagerSync()
  storage[MANAGER_SYNC_KEY].rev = (storage[MANAGER_SYNC_KEY].rev or 0) + 1
end

local function getCooldownLeft(entry)
  local nextCast = tonumber(entry and entry.nextCast or 0) or 0
  local left = nextCast - nowMs()
  if left < 0 then left = 0 end
  return left
end

local function getStructureSignature()
  local parts = {}
  for i, entry in ipairs(managerCfg.actions) do
    parts[#parts + 1] = table.concat({
      tostring(i),
      tostring(entry.type or ""),
      tostring(entry.enabled ~= false and 1 or 0),
      tostring(entry.spell or ""),
      tostring(entry.runeId or 0),
      tostring(entry.dist or 0),
      tostring(entry.mobs or 0),
      tostring(entry.mana or 0),
      tostring(entry.cd or 0),
      tostring(entry.safe and 1 or 0)
    }, "|")
  end
  return table.concat(parts, "||")
end

comboSetupInterface = setupUI([=[
UIWindow
  size: 270 160
  opacity: 0.95

  Panel
    anchors.fill: parent
    background-color: #0b0b0b
    border: 1 #3b2a10

  Panel
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 25
    background-color: #111111

  Label
    id: title
    anchors.centerIn: topBar
    text: [LNS] Manager Attackbot
    color: orange
    font: verdana-11px-rounded
    text-auto-resize: true

  Button
    id: minimize
    anchors.top: prev.top
    anchors.right: parent.right
    margin-right: 10
    size: 30 15
    text: -
    font: verdana-11px-rounded
    color: orange
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a

  TextList
    id: taskList
    anchors.top: topBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: 6
    margin-right: 18
    padding: 1
    image-color: #111111
    border: 1 #3b2a10
    vertical-scrollbar: taskScroll

  VerticalScrollBar
    id: taskScroll
    anchors.top: taskList.top
    anchors.bottom: taskList.bottom
    anchors.left: taskList.right
    step: 10
    pixels-scroll: true
    visible: true
    border: 1 #1f1f1f
    image-color: #363636
    opacity: 0.90
    margin-left: 0

  ResizeBorder
    id: bottomResizeBorder
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 5
    minimum: 170
    maximum: 245
    background: #ffffff88

]=], g_ui.getRootWidget())
comboSetupInterface:hide()

local managerMinimized = false
comboSetupInterface.minimize.onClick = function()
  managerMinimized = not managerMinimized
  if managerMinimized then
    comboSetupInterface:setHeight(31)
    comboSetupInterface.taskList:hide()
    comboSetupInterface.taskScroll:hide()
    comboSetupInterface.minimize:setText("+")
  else
    comboSetupInterface:setHeight(160)
    comboSetupInterface.taskList:show()
    comboSetupInterface.taskScroll:show()
    comboSetupInterface.minimize:setText("-")
  end
end

storage.widgetPos = storage.widgetPos or {}
storage.widgetPos["comboSetupInterface"] = storage.widgetPos["comboSetupInterface"] or {}
comboSetupInterface:setPosition({
  x = storage.widgetPos["comboSetupInterface"].x or comboSetupInterface:getX(),
  y = storage.widgetPos["comboSetupInterface"].y or comboSetupInterface:getY()
})

comboSetupInterface.onDragEnter = function(widget, mousePos)
  widget:breakAnchors()
  widget.movingReference = {
    x = mousePos.x - widget:getX(),
    y = mousePos.y - widget:getY()
  }
  return true
end

comboSetupInterface.onDragMove = function(widget, mousePos, moved)
  local parentRect = widget:getParent():getRect()

  local x = math.min(
    math.max(parentRect.x, mousePos.x - widget.movingReference.x),
    parentRect.x + parentRect.width - widget:getWidth()
  )

  local y = math.min(
    math.max(parentRect.y - widget:getParent():getMarginTop(), mousePos.y - widget.movingReference.y),
    parentRect.y + parentRect.height - widget:getHeight()
  )

  widget:move(x, y)
  storage.widgetPos["comboSetupInterface"] = { x = x, y = y }
  return true
end

local rowTemplate = [[
UIWidget
  id: root
  height: 21
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 20
    height: 17
    margin-left: 3
    margin-top: -0
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: red

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    size: 16 16
    visible: false

  Label
    id: spellName
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-9px
    color: white
    text: ""
    visible: false

  Label
    id: runeName
    anchors.left: icon.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    font: verdana-9px
    color: white
    text: ""
    visible: false

  Label
    id: status
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    margin-right: 3
    font: verdana-9px
    color: #FF4040
    text: "OFF"
    text-auto-resize: true
]]

local taskList = comboSetupInterface.taskList
local managerRows = {}
local lastStructureSignature = ""

local function updateManagerRow(row, entry)
  if not row or not entry then return end

  local enabled = entry.enabled ~= false
  local cooldownLeft = getCooldownLeft(entry)
  local cooling = cooldownLeft > 0

  row.enabled:setOn(enabled)

  if entry.type == "rune" then
    row.icon:setVisible(true)
    row.spellName:setVisible(false)
    row.runeName:setVisible(true)

    setItemIcon(row.icon, tonumber(entry.runeId or 0))
    row.runeName:setText(string.format("RUNA ID: [%d]", tonumber(entry.runeId or 0)))
  else
    row.icon:setVisible(false)
    row.runeName:setVisible(false)
    row.spellName:setVisible(true)

    row.spellName:setText(string.format("SPELL: [%s]", tostring(entry.spell or "")))
  end

  if cooling then
    row.status:setText(string.format("%.1fs", cooldownLeft / 1000))
    row.status:setColor("#67C1FF")
    row:setBackgroundColor("#12202c")

    if entry.type == "rune" then
      row.runeName:setColor("#bfe3ff")
    else
      row.spellName:setColor("#bfe3ff")
    end
  else
    row.status:setText(enabled and "ON" or "OFF")
    row.status:setColor(enabled and "green" or "#FF4040")
    row:setBackgroundColor("alpha")

    if entry.type == "rune" then
      row.runeName:setColor("white")
    else
      row.spellName:setColor("white")
    end
  end

  if entry.type == "rune" then
    row:setTooltip(string.format(
      "Runa ID: %d\nRange: %d\nMobs: %d\nSafe: %s\nStatus: %s",
      tonumber(entry.runeId or 0) or 0,
      tonumber(entry.dist or 0) or 0,
      tonumber(entry.mobs or 0) or 0,
      entry.safe and "SAFE" or "UNSAFE",
      cooling and "COOLDOWN" or (enabled and "ON" or "OFF")
    ))
  else
    row:setTooltip(string.format(
      "Spell: %s\nRange: %d\nMana: %d\nMobs: %d\nCooldown: %d ms\nSafe: %s\nStatus: %s",
      tostring(entry.spell or ""),
      tonumber(entry.dist or 0) or 0,
      tonumber(entry.mana or 0) or 0,
      tonumber(entry.mobs or 0) or 0,
      tonumber(entry.cd or 0) or 0,
      entry.safe and "SAFE" or "UNSAFE",
      cooling and "COOLDOWN" or (enabled and "ON" or "OFF")
    ))
  end
end

local function refreshAttackManager()
  clearChildren(taskList)
  managerRows = {}

  if not managerCfg.actions or #managerCfg.actions == 0 then
    local empty = setupUI([[
Label
  id: emptyText
  text: NENHUMA ACTION NO ATTACKBOT
  color: #7f7f7f
  font: verdana-9px
]], taskList)
    managerRows.empty = empty
    return
  end

  for i, entry in ipairs(managerCfg.actions) do
    local row = setupUI(rowTemplate, taskList)
    row.entryIndex = i

    row.enabled.onClick = function(widget)
      local idx = row.entryIndex
      local ref = managerCfg.actions[idx]
      if not ref then return end

      local newState = not widget:isOn()
      widget:setOn(newState)
      ref.enabled = newState

      bumpManagerSync()
      updateManagerRow(row, ref)
    end

    row.onClick = function(widget)
      taskList:focusChild(widget)

      local idx = row.entryIndex
      local ref = managerCfg.actions[idx]
      if not ref then return end

      ref.enabled = not (ref.enabled ~= false)
      row.enabled:setOn(ref.enabled)

      bumpManagerSync()
      updateManagerRow(row, ref)
    end

    managerRows[i] = row
    updateManagerRow(row, entry)
  end
end

macro(100, function()
  local sig = getStructureSignature()
  if sig ~= lastStructureSignature then
    lastStructureSignature = sig
    refreshAttackManager()
    return
  end

  for i, row in ipairs(managerRows) do
    local entry = managerCfg.actions[i]
    if row and entry then
      row.entryIndex = i
      updateManagerRow(row, entry)
    end
  end
end)

refreshAttackManager()