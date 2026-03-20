setDefaultTab("LNS")

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
  if g_clock and type(g_clock.seconds) == "function" then
    return math.floor(g_clock.seconds() * 1000)
  end
  if type(now) == "number" then
    return now
  end
  if os and os.clock then
    return math.floor(os.clock() * 1000)
  end
  if os and os.time then
    return os.time() * 1000
  end
  return 0
end

local function clamp(v, a, b)
  if v < a then return a end
  if v > b then return b end
  return v
end

local function v01ToPct(v)
  return math.floor((clamp(v or 0, 0, 1) * 100) + 0.5)
end

local function pctTo01(p)
  return clamp((p or 0) / 100, 0, 1)
end

local function normPct(text)
  local n = tonumber((text or ""):match("%-?%d+"))
  if not n then return nil end
  if n < 0 then n = 0 end
  if n > 100 then n = 100 end
  return math.floor(n)
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  return s
end

local function iconTextFromInput(s)
  s = tostring(s or "")
  s = s:gsub("^%s+", ""):gsub("%s+$", "")
  -- permite quebrar linha no texto do ícone usando "|" ou "\n"
  s = s:gsub("\\n", "\n")
  s = s:gsub("|", "\n")
  return s
end

local function iconTextToInput(s)
  s = tostring(s or "")
  -- mostra quebra de linha como "|"
  s = s:gsub("\n", "|")
  return s
end


local MyConfigName = "default"
if modules and modules.game_bot and modules.game_bot.contentsPanel
  and modules.game_bot.contentsPanel.config
  and modules.game_bot.contentsPanel.config.getCurrentOption then
  local opt = modules.game_bot.contentsPanel.config:getCurrentOption()
  if opt and opt.text then
    MyConfigName = opt.text
  end
end

storage.lnsIconsDB = storage.lnsIconsDB or {}
storage.lnsIconsDB[MyConfigName] = storage.lnsIconsDB[MyConfigName] or {
  enabled = false,
  iconConfig = {},   
  icons = {},         
  status = {},       
  items = {},      
  modes = {},         
  outfits = {},        
  texts = {}          
}
local db = storage.lnsIconsDB[MyConfigName]
db.iconConfig = db.iconConfig or {}
db.icons      = db.icons      or {}
db.status     = db.status     or {}
db.items      = db.items      or {}
db.modes      = db.modes      or {}
db.outfits    = db.outfits    or {}
db.texts      = db.texts      or {}

local function applyRelativePos(widget, cfg)
  if not widget or not cfg then return end
  local parent = widget:getParent()
  if not parent then return end

  local r = parent:getRect()
  local w = r.width - widget:getWidth()
  local h = r.height - widget:getHeight()

  widget:setMarginTop(math.max(h * (-0.5) - parent:getMarginTop(), h * (-0.5 + (cfg.y or 0))))
  widget:setMarginLeft(w * (-0.5 + (cfg.x or 0)))
end

local function extractItemId(a, b, c)
  local function fromAny(x)
    if type(x) == "number" then return x end
    if type(x) == "string" then
      local n = tonumber(x:match("%d+"))
      return n or 0
    end
    if type(x) == "table" then
      if x.getId then
        local ok, id = pcall(function() return x:getId() end)
        if ok and tonumber(id) then return tonumber(id) end
      end
      if x.id and tonumber(x.id) then return tonumber(x.id) end
    end
    return 0
  end

  local id = fromAny(b)
  if id == 0 then id = fromAny(a) end
  if id == 0 then id = fromAny(c) end
  return tonumber(id) or 0
end

local function applyIconItem(iconWidget, itemId)
  if not iconWidget or not iconWidget.item then return end
  itemId = tonumber(itemId) or 0

  if iconWidget.creature and iconWidget.creature.setVisible then
    iconWidget.creature:setVisible(false)
  end
  if iconWidget.item and iconWidget.item.setVisible then
    iconWidget.item:setVisible(true)
  end

  if iconWidget.item.setItemId then
    iconWidget.item:setItemId(itemId)
    return
  end

  if iconWidget.item.setItem then
    if itemId > 0 and Item and Item.create then
      iconWidget.item:setItem(Item.create(itemId))
    else
      iconWidget.item:setItem(nil)
    end
    return
  end

  if iconWidget.item.setImageSource then
    iconWidget.item:setImageSource("")
  end
end

local function makeOutfitById(id)
  id = tonumber(id) or 0
  return {
    mount = 0,
    feet = 0,
    legs = 0,
    body = id,
    type = id,
    auxType = 0,
    addons = 3,
    head = 0
  }
end

local function applyIconOutfit(iconWidget, outfitId)
  outfitId = tonumber(outfitId) or 0
  if not iconWidget then return end

  if iconWidget.item and iconWidget.item.setVisible then
    iconWidget.item:setVisible(false)
  end
  if iconWidget.creature and iconWidget.creature.setVisible then
    iconWidget.creature:setVisible(true)
  end

  if iconWidget.creature and iconWidget.creature.setOutfit then
    pcall(function()
      iconWidget.creature:setOutfit(makeOutfitById(outfitId))
    end)
    return
  end

  applyIconItem(iconWidget, 0)
end

local function clearRowCreaturePick(creaturePick)
  if not creaturePick then return end
  if creaturePick.setVisible then creaturePick:setVisible(true) end
end

local function setRowCreaturePick(creaturePick, outfitId)
  if not creaturePick then return end
  if creaturePick.setVisible then creaturePick:setVisible(true) end

  local o = nil
  if player and player.getOutfit then
    local ok, base = pcall(function() return player:getOutfit() end)
    if ok and type(base) == "table" then
      base.type = tonumber(outfitId) or 0
      base.addons = 3
      o = base
    end
  end
  o = o or makeOutfitById(outfitId)

  if creaturePick.setOutfit then
    pcall(function() creaturePick:setOutfit(o) end)
  end
end

local function setRowItemPick(itemPick, itemId)
  if not itemPick then return end
  itemId = tonumber(itemId) or 0

  if itemPick.setItemId then
    itemPick:setItemId(itemId)
    return
  end

  if itemPick.setItem and Item and Item.create then
    if itemId > 0 then
      itemPick:setItem(Item.create(itemId))
    else
      itemPick:setItem(nil)
    end
  end
end

local function setRowItemPickBlocked(itemPick, itemId)
  if not itemPick then return end
  itemPick._lnsBlockPick = true
  setRowItemPick(itemPick, itemId)
  itemPick._lnsBlockPick = false
end

local iconsWithoutPosition = 0

local function addIcone(id, options, onPosChanged)
  local panel = modules.game_interface.gameMapPanel
  options = options or {}

  db.icons[id] = db.icons[id] or {}
  local cfg = db.icons[id]

  if type(cfg.x) ~= "number" or type(cfg.y) ~= "number" then
    -- posição inicial padronizada: X=1 / Y=1 (0.01 em relativo)
    cfg.x = 0.01
    cfg.y = 0.01
  end

  local w = g_ui.createWidget("BotIcon", panel)
  w.botWidget = true
  w.botIcon = true

  w.onMousePress = function(widget, mousePos, button)
    return true
  end
  w.onMouseRelease = function(widget, mousePos, button)
    return true
  end
  w.onMouseMove = function(widget, mousePos)
    return true
  end
  
  local savedMode = db.modes[id]
  if savedMode ~= "item" and savedMode ~= "outfit" then
    savedMode = (options.defaultMode == "outfit") and "outfit" or "item"
    db.modes[id] = savedMode
  end

  if savedMode == "outfit" then
    local oId = tonumber(db.outfits[id]) or 0
    if oId <= 0 then
      oId = tonumber(options.defaultOutfitId) or 0
      db.outfits[id] = oId
    end
    db.items[id] = 0
    applyIconOutfit(w, oId)
  else
    local savedItem = tonumber(db.items[id])
    if savedItem == nil then
      savedItem = tonumber(options.defaultItemId) or 0
      db.items[id] = savedItem
    end
    applyIconItem(w, savedItem)
  end

  w.status:show()
  local savedStatus = db.status[id]
  if savedStatus == nil then
    savedStatus = (options.defaultOn == true)
  end
  w.status:setOn(savedStatus == true)

  if options.text then
    local t = db.texts[id]
    if type(t) ~= "string" then t = "" end
    local showText = (t ~= "" and iconTextFromInput(t)) or options.text

    w.text:setText(showText)
    w.text:setFont("verdana-9px")
    w.text:setColor("white")

    -- Remove quebras de linha para contar caracteres reais
    local plain = showText:gsub("\n", "")
    local len = string.len(plain)

    w.text:setMarginLeft(-10)
    w.text:setMarginRight(-10)
  else
    w.text:setText("")
  end

  w:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
  w:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)

  w.onGeometryChange = function(widget)
    if widget:isDragging() then return end
    applyRelativePos(widget, cfg)
  end

  w.onClick = function()
    local newState = not w.status:isOn()
    w.status:setOn(newState)
    db.status[id] = newState
  end

  -- CTRL+drag
  if options.movable ~= false then
    w.onDragEnter = function(widget, mousePos)
      if not modules.corelib.g_keyboard.isCtrlPressed() then return false end
      widget:breakAnchors()
      widget.movingReference = { x = mousePos.x - widget:getX(), y = mousePos.y - widget:getY() }
      return true
    end

    w.onDragMove = function(widget, mousePos)
      local pr = widget:getParent():getRect()
      local x = clamp(mousePos.x - widget.movingReference.x, pr.x, pr.x + pr.width - widget:getWidth())
      local y = clamp(mousePos.y - widget.movingReference.y, pr.y - widget:getParent():getMarginTop(), pr.y + pr.height - widget:getHeight())
      widget:move(x, y)
      return true
    end

    w.onDragLeave = function(widget)
      local parent = widget:getParent()
      local pr = parent:getRect()

      local x = widget:getX() - pr.x
      local y = widget:getY() - pr.y
      local width  = pr.width  - widget:getWidth()
      local height = pr.height - widget:getHeight()

      cfg.x = clamp(x / math.max(1, width), 0, 1)
      cfg.y = clamp(y / math.max(1, height), 0, 1)

      widget:addAnchor(AnchorHorizontalCenter, "parent", AnchorHorizontalCenter)
      widget:addAnchor(AnchorVerticalCenter, "parent", AnchorVerticalCenter)
      applyRelativePos(widget, cfg)

      if type(onPosChanged) == "function" then
        onPosChanged(cfg)
      end
      return true
    end
  end

  applyRelativePos(w, cfg)
  return w, cfg
end

local rowTemplate = [[
UIWidget
  id: root
  height: 38
  focusable: true
  background-color: #141414
  border: 1 #232323
  opacity: 1.00
  margin-top: 2

  $hover:
    background-color: #1c1c1c
    border: 1 #3a2a12

  $focus:
    background-color: #202020
    border: 1 alpha

  BotSwitch
    id: check
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    margin-top: -1
    width: 40
    height: 29
    text-align: center
    font: verdana-9px-bold
    text: HIDE
    color: white
    image-source: /images/ui/button_rounded
    image-color: #4a2a2a

    $on:
      text: HIDE
      color: white
      image-color: #2f6b3d

    $!on:
      text: SHOW
      color: white
      image-color: #5a2d2d

  BotItem
    id: itemPick
    anchors.left: check.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 8
    size: 28 28
    image-source: /images/ui/item-blessed
    border: 1 #4a3a16
    background-color: #101010

  UICreature
    id: creaturePick
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    size: 28 28
    background-color: #101010
    border: 1 #2b2b2b
    image-source: /images/ui/item-blessed
    visible: true

  Button
    id: listaIds
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    size: 20 20
    text: L
    text-offset: 0 -1
    tooltip: Lista de Outfits/Items
    font: verdana-9px-bold
    color: #d8d8d8
    image-color: #3b3b3b
    image-source: /images/ui/button_rounded

    $hover:
      color: #ffb347
      image-color: #4a3415

  BotTextEdit
    id: nameEdit
    anchors.left: listaIds.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    width: 110
    height: 22
    font: verdana-9px-bold
    color: white
    text-align: left
    text: ""
    image-color: #2f2f2f
    tooltip: (use | para quebrar linha)

  Label
    id: lblX
    anchors.left: nameEdit.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 10
    width: 14
    font: verdana-9px-bold
    color: #ffb347
    text: "X:"

  BotTextEdit
    id: editX
    anchors.left: lblX.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    width: 38
    height: 22
    font: verdana-9px
    text-align: center
    image-color: #2f2f2f
    color: white
    text: "0"

  Label
    id: lblY
    anchors.left: editX.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 8
    width: 14
    font: verdana-9px-bold
    color: #ffb347
    text: "Y:"

  BotTextEdit
    id: editY
    anchors.left: lblY.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 2
    width: 38
    height: 22
    font: verdana-9px
    text-align: center
    image-color: #2f2f2f
    color: white
    text: "0"
]]

local idPicker = {
  win = nil,
  itemList = nil,
  pageLabel = nil,
  btnBack = nil,
  btnNext = nil,
  btnClose = nil,
  btnOut = nil,
  btnIt = nil,

  target = nil, -- { iconId=..., iconWidget=..., row={itemPick=..., creaturePick=...} }

  view = "items",
  lootList = {},
  itemIndex = 1,

  outfitFirst = 1,
  outfitLast = 1904,
  outfitPage = 1,

  pageSize = 95
}

local function idPicker_safeRead(path)
  if not g_resources or type(g_resources.readFileContents) ~= "function" then
    return nil, "g_resources.readFileContents não existe"
  end
  local ok, content = pcall(function() return g_resources.readFileContents(path) end)
  if not ok then return nil, content end
  if not content or content == "" then return nil, "vazio" end
  return content, nil
end

local function idPicker_loadLootItems()
  local cfgName = (type(MyConfigName) == "string" and MyConfigName ~= "" and MyConfigName) or "CUSTOM"
  local path1 = "/bot/" .. cfgName .. "/loot_items.lua"
  local path2 = "/bot/" .. cfgName .. "/loot_items"
  local path3 = "loot_items.lua"

  local content, err = idPicker_safeRead(path1)
  if not content then content, err = idPicker_safeRead(path2) end
  if not content then content, err = idPicker_safeRead(path3) end

  if not content then
    warn("ID Picker: não achei loot_items.lua em: " .. path1)
    warn("ID Picker: erro/leitura: " .. tostring(err))
    return {}
  end

  local list, seen, n = {}, {}, 0
  for name, idStr in content:gmatch('%["(.-)"%]%s*=%s*(%d+)') do
    local id = tonumber(idStr)
    if id and not seen[id] then
      seen[id] = true
      n = n + 1
      list[n] = { name = tostring(name), id = id }
    end
  end

  table.sort(list, function(a,b) return (a.id or 0) < (b.id or 0) end)
  return list
end

local function idPicker_W(win, id)
  if win and win.recursiveGetChildById then return win:recursiveGetChildById(id) end
  if win and win.getChildById then return win:getChildById(id) end
  return nil
end

local function idPicker_buildUI()
  if idPicker.win then return end

  g_ui.loadUIFromString([[
IdPickerWindow < UIWindow
  size: 690 520
  @onEscape: self:hide()
  anchors.centerIn: parent
  margin-top: -60

  Panel
    id: background
    anchors.fill: parent
    background-color: black
    opacity: 0.70

  Panel
    id: topPanel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    size: 120 30
    text-align: center
    !text: tr('LNS Custom | Lista de IDs')
    color: orange
    background-color: black

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
    id: topBar
    height: 26
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top

    Button
      id: btnOutfits
      !text: tr('OUTFITS')
      font: verdana-9px
      anchors.left: parent.left
      anchors.top: parent.top
      margin-left: 6
      margin-top: 5
      width: 90
      height: 20
      image-source: /images/ui/button_rounded
      image-color: #363636

    Button
      id: btnItems
      !text: tr('ITEMS')
      font: verdana-9px
      anchors.left: btnOutfits.right
      anchors.top: parent.top
      margin-left: 6
      margin-top: 5
      width: 90
      height: 20
      image-source: /images/ui/button_rounded
      image-color: #363636

  Panel
    id: itemList
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: topBar.bottom
    anchors.bottom: separator.top
    margin-top: 5
    margin-left: 9
    layout:
      type: grid
      cell-size: 56 56
      flow: true

  HorizontalSeparator
    id: separator
    anchors.right: parent.right
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    margin-bottom: 25

  Button
    id: backButton
    !text: tr('VOLTAR')
    font: verdana-9px
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    image-source: /images/ui/button_rounded
    image-color: #363636
    margin-left: 10
    width: 200

  Label
    id: page
    text: 0/0
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.left: prev.right
    anchors.top: prev.top
    width: 220
    margin-top: 2
    font: terminus-14px-bold
    text-align: center

  Button
    id: nextButton
    !text: tr('PROXIMA')
    font: verdana-9px
    margin-right: 10
    anchors.left: page.right
    anchors.bottom: parent.bottom
    image-source: /images/ui/button_rounded
    image-color: #363636
    width: 200

IdPickerEntry < UIWidget
  size: 60 60
  margin-left: 2
  margin-top: 10

  UICreature
    id: creature
    size: 40 40
    phantom: true
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    background-color: #00000055
    image-source: /images/ui/item-blessed
    border: 1 alpha
    $hover:
      border: 2 white

  Item
    id: item
    size: 40 40
    phantom: false
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: parent.verticalCenter
    image-source: /images/ui/item-blessed
    padding: 5
    border: 1 alpha
    $hover:
      border: 1 white
  ]])

  idPicker.win = UI.createWindow("IdPickerWindow", g_ui.getRootWidget())
  idPicker.win:hide()

  idPicker.itemList  = idPicker_W(idPicker.win, "itemList")
  idPicker.pageLabel = idPicker_W(idPicker.win, "page")
  idPicker.btnBack   = idPicker_W(idPicker.win, "backButton")
  idPicker.btnNext   = idPicker_W(idPicker.win, "nextButton")
  idPicker.btnClose  = idPicker_W(idPicker.win, "closePanel")
  idPicker.btnOut    = idPicker_W(idPicker.win, "btnOutfits")
  idPicker.btnIt     = idPicker_W(idPicker.win, "btnItems")

  if idPicker.btnClose then
    idPicker.btnClose.onClick = function()
      if idPicker.win then idPicker.win:hide() end
    end
  end
end

local function idPicker_applyItem(itemId)
  local t = idPicker.target
  if not t or not t.iconId or not t.row or not t.iconWidget then return end

  itemId = tonumber(itemId) or 0

  db.modes[t.iconId] = "item"
  db.items[t.iconId] = itemId
  db.outfits[t.iconId] = nil

  setRowItemPickBlocked(t.row.itemPick, itemId)
  clearRowCreaturePick(t.row.creaturePick)
  applyIconItem(t.iconWidget, itemId)

  if idPicker.win then idPicker.win:hide() end
end

local function idPicker_applyOutfit(outfitId)
  local t = idPicker.target
  if not t or not t.iconId or not t.row or not t.iconWidget then return end

  outfitId = tonumber(outfitId) or 0

  db.modes[t.iconId] = "outfit"
  db.outfits[t.iconId] = outfitId
  db.items[t.iconId] = 0

  setRowCreaturePick(t.row.creaturePick, outfitId)
  setRowItemPickBlocked(t.row.itemPick, 0)
  applyIconOutfit(t.iconWidget, outfitId)

  if idPicker.win then idPicker.win:hide() end
end

local function idPicker_addOutfitCell(id)
  local w = UI.createWidget("IdPickerEntry", idPicker.itemList)

  w.item:setVisible(false)
  w.creature:setVisible(true)
  w.creature:setSize({ width = 50, height = 70 })

  local base = nil
  if player and player.getOutfit then
    local ok, o = pcall(function() return player:getOutfit() end)
    if ok and type(o) == "table" then base = o end
  end
  base = base or makeOutfitById(id)
  base.type = id
  base.addons = 3

  pcall(function() w.creature:setOutfit(base) end)

  w.onDoubleClick = function()
    idPicker_applyOutfit(id)
  end
end

local function idPicker_addItemCell(entry)
  local id = entry.id
  local name = entry.name or ""

  local w = UI.createWidget("IdPickerEntry", idPicker.itemList)

  w.creature:setVisible(false)
  w.item:setVisible(true)

  w.item:setSize({ width = 50, height = 70 })
  w.item:setItemId(id)
  w.item:setTooltip(name .. " (" .. id .. ")")

  w.onDoubleClick = function()
    idPicker_applyItem(id)
  end
end

local function idPicker_render()
  if not idPicker.itemList then return end
  idPicker.itemList:destroyChildren()

  if idPicker.view == "outfits" then
    local fromId = idPicker.outfitPage
    if fromId < idPicker.outfitFirst then fromId = idPicker.outfitFirst end
    if fromId > idPicker.outfitLast then fromId = idPicker.outfitLast end

    local toId = fromId + idPicker.pageSize
    if toId > idPicker.outfitLast then toId = idPicker.outfitLast end

    for i = fromId, toId do
      idPicker_addOutfitCell(i)
    end

    if idPicker.pageLabel then
      idPicker.pageLabel:setText(fromId .. " - " .. toId .. " / " .. idPicker.outfitLast)
    end
    return
  end

  local total = #idPicker.lootList
  if total == 0 then
    if idPicker.pageLabel then idPicker.pageLabel:setText("0/0") end
    return
  end

  if idPicker.itemIndex < 1 then idPicker.itemIndex = 1 end
  if idPicker.itemIndex > total then idPicker.itemIndex = total end

  local toIndex = idPicker.itemIndex + idPicker.pageSize
  if toIndex > total then toIndex = total end

  for i = idPicker.itemIndex, toIndex do
    local entry = idPicker.lootList[i]
    if entry then idPicker_addItemCell(entry) end
  end

  if idPicker.pageLabel then
    idPicker.pageLabel:setText(idPicker.itemIndex .. " - " .. toIndex .. " / " .. total)
  end
end

local function idPicker_bindButtons()
  if not idPicker.win then return end

  if idPicker.btnOut then
    idPicker.btnOut.onClick = function()
      idPicker.view = "outfits"
      idPicker_render()
    end
  end

  if idPicker.btnIt then
    idPicker.btnIt.onClick = function()
      idPicker.view = "items"
      idPicker.lootList = idPicker_loadLootItems()
      idPicker_render()
    end
  end

  if idPicker.btnBack then
    idPicker.btnBack.onClick = function()
      if idPicker.view == "outfits" then
        idPicker.outfitPage = idPicker.outfitPage - idPicker.pageSize
        if idPicker.outfitPage < idPicker.outfitFirst then idPicker.outfitPage = idPicker.outfitFirst end
        idPicker_render()
        return
      end

      idPicker.itemIndex = idPicker.itemIndex - idPicker.pageSize
      if idPicker.itemIndex < 1 then idPicker.itemIndex = 1 end
      idPicker_render()
    end
  end

  if idPicker.btnNext then
    idPicker.btnNext.onClick = function()
      if idPicker.view == "outfits" then
        idPicker.outfitPage = idPicker.outfitPage + idPicker.pageSize
        if idPicker.outfitPage > idPicker.outfitLast then idPicker.outfitPage = idPicker.outfitLast end
        idPicker_render()
        return
      end

      local total = #idPicker.lootList
      idPicker.itemIndex = idPicker.itemIndex + idPicker.pageSize
      if idPicker.itemIndex > total then idPicker.itemIndex = total end
      idPicker_render()
    end
  end
end

local function openIdPicker(target)
  idPicker_buildUI()
  idPicker_bindButtons()

  idPicker.target = target

  if idPicker.view == "items" then
    idPicker.lootList = idPicker_loadLootItems()
  end

  if idPicker.win then
    idPicker.win:show()
    idPicker.win:raise()
    idPicker.win:focus()
  end
  idPicker_render()
end

local applyIconsVisibility = function() end

local iconButton = setupUI([[
Panel
  height: 18
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: ICONES
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
iconButton.title:setOn(db.enabled == true)

iconButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  db.enabled = newState
  applyIconsVisibility()
end

local iconsInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 420 385
  border: 1 #000000
  anchors.centerIn: parent
  margin-top: -60

  Panel
    id: background
    anchors.fill: parent
    background-color: #0e0e0e
    border: 1 #2a2a2a
    opacity: 0.96

  Panel
    id: topPanel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 28
    background-color: #111111
    border-bottom: 1 #3a2a12

    Label
      id: title
      anchors.centerIn: parent
      text: LNS Custom | Icones Control
      text-auto-resize: true
      font: verdana-11px-rounded
      color: #ff9d00

  UIButton
    id: closePanel
    anchors.top: parent.top
    anchors.right: parent.right
    size: 20 20
    margin-top: 4
    margin-right: 6
    background-color: #ff8a00
    border: 1 #2b1800
    text: X
    color: white

    $hover:
      background-color: #ffad33
      color: black

  Panel
    id: searchWrap
    anchors.top: topPanel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 32
    margin-top: 6
    margin-left: 8
    margin-right: 8
    background-color: #141414
    border: 1 #2a2a2a

    TextEdit
      id: textpesquisarIcon
      anchors.fill: parent
      margin-left: 6
      margin-right: 6
      margin-top: 4
      margin-bottom: 4
      font: verdana-9px
      image-color: #2d2d2d
      color: #e6e6e6
      placeholder: TEXTO DE PESQUISA ICON
      placeholder-font: verdana-9px

  Panel
    id: listWrap
    anchors.top: searchWrap.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-left: 8
    margin-right: 8
    margin-top: 6
    margin-bottom: 8
    background-color: #101010
    border: 1 #3a2a12

    TextList
      id: panelMain
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.bottom: parent.bottom
      anchors.right: spellListScrollBar.left
      margin-left: 4
      margin-top: 4
      margin-bottom: 4
      margin-right: 4
      vertical-scrollbar: spellListScrollBar
      image-color: #1f1f1f
      opacity: 1.00
      layout: verticalBox

    VerticalScrollBar
      id: spellListScrollBar
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      anchors.right: parent.right
      width: 13
      pixels-scroll: true
      image-color: #1c1c1c
      margin-top: 4
      margin-bottom: 4
      margin-right: 4
      step: 10
]], g_ui.getRootWidget())
iconsInterface:hide()

function buttonsIconsPcMobile()
  if modules._G.g_app.isMobile() then
    iconButton.settings:show()
    iconButton.title:setMarginRight(55)
  else
    iconButton.settings:hide()
    iconButton.title:setMarginRight(0)
  end
end
buttonsIconsPcMobile()

iconButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not iconsInterface:isVisible() then
      iconsInterface:show()
      iconsInterface:raise();
      iconsInterface:focus();
    else
      iconsInterface:hide()
    end
  end
end

iconButton.settings.onClick = function()
  if not iconsInterface:isVisible() then
    iconsInterface:show()
    iconsInterface:raise()
    iconsInterface:focus()
  end
end

iconsInterface.closePanel.onClick = function() iconsInterface:hide() end
iconButton.settings.onClick = function()
  if not iconsInterface:isVisible() then
    iconsInterface:show()
    iconsInterface:raise()
    iconsInterface:focus()
  end
end

local ICON_LIST = {
  { id="lnsAttackBot",        label="ATTACK BOT",        iconText="ATTACK" },
  { id="lnsHealing",          label="HEALING",           iconText="HEALING" },
  { id="lnsConditions",       label="CONDITIONS",        iconText="CONDIT." },
  { id="lnsSwapRingAMulet",   label="SWAP RING/AMULET",  iconText="RING/AMULET" },
  { id="lnsFollow",           label="FOLLOW",            iconText="FOLLOW" },
  { id="lnsAutoSio",          label="AUTO SIO",          iconText="AUTOSIO" },
  { id="lnsSwapEquips",       label="SWAP EQUIPS",       iconText="SWAP EQUIPS" },
  { id="lnsPushmax",          label="PUSHMAX",           iconText="PUSHMAX" },
  { id="lnsMwSystem",         label="MWSYSTEM",          iconText="MW SYSTEM" },

  { id="lnsCaveBot",          label="CAVEBOT",           iconText="CAVEBOT" },
  { id="lnsTargetBot",        label="TARGETBOT",         iconText="TARGET" },

  { id="lnsParty",            label="AUTO PARTY",        iconText="AUTO PARTY" },
  { id="lnsImbuiment",        label="IMBUIMENT",         iconText="IMBUIMENT" },

  { id="lnsHaste",            label="AUTO HASTE",        iconText="HASTE" },
  { id="lnsBuff",             label="AUTO BUFF",         iconText="BUFF" },
  { id="lnsAntiLyze",         label="AUTO ANTI-LYZE",    iconText="ANTI-LYZE" },
  { id="lnsUturaGran",        label="AUTO UTURA GRAN",   iconText="UTURA GRAN" },
  { id="lnsAutoUtamoVita",    label="AUTO UTAMO VITA",   iconText="UTAMO" },
  { id="lnsAutoUtanaVid",     label="AUTO UTANA VID",    iconText="UTANA VID" },
  { id="lnsExetaRes",         label="AUTO EXETA RES",    iconText="EXETA RES" },
  { id="lnsAmpRes",           label="AUTO AMP RES",      iconText="AMP RES" },
  { id="lnsExetaLoot",        label="AUTO EXETA LOOT",   iconText="EXETA LOOT" },
  { id="lnsCureStatus",       label="AUTO CURE STATUS",  iconText="CURE STATUS" },

  { id="lnsAutoAol",          label="AUTO AOL",          iconText="AOL" },
  { id="lnsAutoBless",        label="AUTO BLESS",        iconText="BLESS" },
}

local function injectUtilitariosIntoIconList(list)
  if not storage.lnsUtilIcons or not storage.lnsUtilIcons[MyConfigName] then return end

  for _, def in pairs(storage.lnsUtilIcons[MyConfigName]) do
    if def and def.id then
      local exists = false
      for i = 1, #list do
        if list[i] and list[i].id == def.id then
          exists = true
          break
        end
      end
      if not exists then
        table.insert(list, {
          id = def.id,
          label = tostring(def.label or def.id):upper(),
          iconText = tostring(def.iconText or def.label or def.id):upper(),
          _utilStoreKey = def.storeKey
        })
      end
    end
  end
end
injectUtilitariosIntoIconList(ICON_LIST)

for _, it in ipairs(ICON_LIST) do
  it.label = tostring(it.label or it.id):upper()
  it.iconText = tostring(it.iconText or it.label or it.id):upper()
end

for _, it in ipairs(ICON_LIST) do
  it.key = "show_" .. it.id

  -- normaliza para boolean (evita 'true'/'false' string ou 0/1 virarem truthy e mostrarem tudo)
  local v = db.iconConfig[it.key]
  if v == true or v == 1 or v == "1" or v == "true" then
    db.iconConfig[it.key] = true
  else
    db.iconConfig[it.key] = false
  end
end

local icons = {}
local rows  = {}

local function safeShow(w) if w and not w:isVisible() then w:show() end end
local function safeHide(w) if w and w:isVisible() then w:hide() end end

applyIconsVisibility = function()
  if db.enabled ~= true then
    for _, it in ipairs(ICON_LIST) do safeHide(icons[it.id]) end
    return
  end

  for _, it in ipairs(ICON_LIST) do
    if db.iconConfig[it.key] == true then
      safeShow(icons[it.id])
    else
      safeHide(icons[it.id])
    end
  end
end

for _, child in ipairs(iconsInterface.listWrap.panelMain:getChildren()) do
  child:destroy()
end

for _, it in ipairs(ICON_LIST) do
  local iconWidget, cfg = addIcone(it.id, {
    movable = true,
    text = it.iconText,
    defaultOn = false,
    defaultItemId = 0,
    defaultMode = "item",
    defaultOutfitId = 0
  }, function(newCfg)
    local rowPack = rows[it.id]
    if not rowPack then return end
    rowPack.editX._lnsBlock = true
    rowPack.editY._lnsBlock = true
    rowPack.editX:setText(tostring(v01ToPct(newCfg.x)))
    rowPack.editY:setText(tostring(v01ToPct(newCfg.y)))
    rowPack.editX._lnsBlock = false
    rowPack.editY._lnsBlock = false
  end)

  icons[it.id] = iconWidget

  local row = g_ui.loadUIFromString(rowTemplate, iconsInterface.listWrap.panelMain)
  row:setId("row_" .. it.id)

  -- nome editável do texto do ícone (default vindo da macro)
  row.nameEdit:setText(iconTextToInput((db.texts[it.id] and db.texts[it.id] ~= "" and db.texts[it.id]) or it.iconText))
  row.nameEdit:setTooltip("Altere para o nome desejado no ICONE")
  row.check:setOn(db.iconConfig[it.key] == true)

  row.editX:setText(tostring(v01ToPct(cfg.x)))
  row.editY:setText(tostring(v01ToPct(cfg.y)))

  row.creaturePick:setVisible(false)

  local mode0 = db.modes[it.id]
  if mode0 ~= "item" and mode0 ~= "outfit" then
    mode0 = "item"
    db.modes[it.id] = "item"
  end

  if mode0 == "outfit" then
    local oId = tonumber(db.outfits[it.id]) or 0
    db.items[it.id] = 0
    setRowItemPickBlocked(row.itemPick, 0)
    setRowCreaturePick(row.creaturePick, oId)
  else
    local saved = tonumber(db.items[it.id]) or 0
    setRowItemPickBlocked(row.itemPick, saved)
    clearRowCreaturePick(row.creaturePick)
  end

  if row.itemPick then
    local function onPickChanged(w, a, b, c)
      if w and w._lnsBlockPick then return end

      local id = extractItemId(a, b, c)

      if id == 0 and w and w.getItem then
        local it2 = w:getItem()
        if it2 then
          local ok, rid = pcall(function() return it2:getId() end)
          if ok and tonumber(rid) then id = tonumber(rid) end
        end
      end

      id = tonumber(id) or 0
      db.modes[it.id] = "item"
      db.items[it.id] = id
      db.outfits[it.id] = nil

      clearRowCreaturePick(row.creaturePick)
      applyIconItem(iconWidget, id)
    end

    row.itemPick.onItemChange = onPickChanged
    row.itemPick.onItemIdChange = onPickChanged
  end

  if row.listaIds then
    row.listaIds.onClick = function()
      openIdPicker({
        iconId = it.id,
        iconWidget = iconWidget,
        row = {
          itemPick = row.itemPick,
          creaturePick = row.creaturePick
        }
      })
    end
  end

  row.check.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    db.iconConfig[it.key] = newState
    applyIconsVisibility()
  end

  row.nameEdit.onTextChange = function(w)
    if w._lnsBlock then return end
    local raw = tostring(w:getText() or "")
    db.texts[it.id] = raw
    local showText = (raw ~= "" and iconTextFromInput(raw)) or it.iconText
    if iconWidget and iconWidget.text and iconWidget.text.setText then
      iconWidget.text:setText(showText)
    end
  end


  row.editX.onTextChange = function(w)
    if w._lnsBlock then return end
    local v = normPct(w:getText())
    if not v then return end
    cfg.x = pctTo01(v)
    applyRelativePos(iconWidget, cfg)
    w._lnsBlock = true
    w:setText(tostring(v))
    w._lnsBlock = false
  end

  row.editY.onTextChange = function(w)
    if w._lnsBlock then return end
    local v = normPct(w:getText())
    if not v then return end
    cfg.y = pctTo01(v)
    applyRelativePos(iconWidget, cfg)
    w._lnsBlock = true
    w:setText(tostring(v))
    w._lnsBlock = false
  end

  rows[it.id] = {
    root = row,
    check = row.check,
    nameEdit = row.nameEdit,
    editX = row.editX,
    editY = row.editY,
    itemPick = row.itemPick,
    creaturePick = row.creaturePick,
    listaIds = row.listaIds
  }
end

-- garante estado limpo (evita aparecer tudo no relog antes de aplicar filtros)
for _, it in ipairs(ICON_LIST) do
  safeHide(icons[it.id])
end

applyIconsVisibility()

-- reaplica visibilidade após login/reconexão (blindagem)
macro(500, function()
  applyIconsVisibility()
end)

local function matchesIcon(it, q)
  if q == "" then return true end
  local a = normalizeText(it.label)
  local b = normalizeText(it.iconText)
  local c = normalizeText(it.id)
  return (a:find(q, 1, true) ~= nil) or (b:find(q, 1, true) ~= nil) or (c:find(q, 1, true) ~= nil)
end

local function filterIconRows(query)
  local q = normalizeText(query)
  for _, it in ipairs(ICON_LIST) do
    local rowPack = rows[it.id]
    if rowPack and rowPack.root then
      if matchesIcon(it, q) then rowPack.root:show() else rowPack.root:hide() end
    end
  end
end

iconsInterface.searchWrap.textpesquisarIcon.onTextChange = function(_, text)
  filterIconRows(text)
end

local function safeCall(obj, fnName, ...)
  if not obj or not fnName then return false, nil end
  local fn = obj[fnName]
  if type(fn) ~= "function" then return false, nil end

  local ok, res = pcall(fn, obj, ...)
  if ok then return true, res end

  ok, res = pcall(fn, ...)
  if ok then return true, res end

  return false, nil
end

local function bindIconToToggle(iconId, toggleWidget, storageKey)
  if not icons or not icons[iconId] then return end
  local icon = icons[iconId]

  storage[storageKey] = storage[storageKey] or { enabled = false }
  storage[storageKey].enabled = storage[storageKey].enabled == true

  local lock = false

  local function apply(state)
    state = (state == true)
    storage[storageKey].enabled = state
    db.status[iconId] = state

    if icon.status then
      icon.status:show()
      icon.status:setOn(state)
    end

    if toggleWidget then
      if toggleWidget.setOn then
        toggleWidget:setOn(state)
      elseif toggleWidget.setChecked then
        toggleWidget:setChecked(state)
      end
    end
  end

  apply(storage[storageKey].enabled)

  icon.onClick = function()
    if lock then return end
    lock = true
    apply(not (storage[storageKey].enabled == true))
    lock = false
  end

  if toggleWidget then
    local old = toggleWidget.onClick
    if toggleWidget.setOn then
      toggleWidget.onClick = function(w, ...)
        if lock then return end
        lock = true
        if type(old) == "function" then pcall(old, w, ...) else w:setOn(not w:isOn()) end
        apply(w:isOn())
        lock = false
      end
    end

    local oldChk = toggleWidget.onCheckChange
    if toggleWidget.setChecked then
      toggleWidget.onCheckChange = function(w, checked, ...)
        if lock then return end
        lock = true
        if type(oldChk) == "function" then pcall(oldChk, w, checked, ...) end
        apply(checked)
        lock = false
      end
    end
  end
end

local function bindIconToConditionsCheck(iconId, panelName, checkId)
  if not icons or not icons[iconId] then return end
  local icon = icons[iconId]

  storage[panelName] = storage[panelName] or {}

  if storage[panelName].switches == nil and type(storage[panelName].checks) == "table" then
    storage[panelName].switches = storage[panelName].checks
    storage[panelName].checks = nil
  end

  storage[panelName].switches = storage[panelName].switches or {}

  local lock = false

  local function getState()
    return storage[panelName].switches[checkId] == true
  end

  local function setState(state)
    state = (state == true)
    storage[panelName].switches[checkId] = state

    local w = (conditionsInterface and conditionsInterface[checkId]) or nil
    if w then
      if w.setOn and w.isOn then
        if w:isOn() ~= state then w:setOn(state) end
      elseif w.setChecked and w.isChecked then
        if w:isChecked() ~= state then w:setChecked(state) end
      end
    end

    if icon.status then
      icon.status:show()
      icon.status:setOn(state)
    end
    db.status[iconId] = state
  end

  setState(getState())

  icon.onClick = function()
    if lock then return end
    lock = true
    setState(not getState())
    lock = false
  end
end

local function bindIconToBotModule(iconId, moduleObj, isOnFn, setOnFn, setOffFn)
  if not icons or not icons[iconId] then return end
  local icon = icons[iconId]

  local function callNoSelf(fnName, a)
    if not moduleObj then return false, nil end
    local fn = moduleObj[fnName]
    if type(fn) ~= "function" then return false, nil end
    local ok, res
    if a == nil then ok, res = pcall(fn) else ok, res = pcall(fn, a) end
    return ok, res
  end

  local function callWithSelf(fnName, a)
    if not moduleObj then return false, nil end
    local fn = moduleObj[fnName]
    if type(fn) ~= "function" then return false, nil end
    local ok, res
    if a == nil then ok, res = pcall(fn, moduleObj) else ok, res = pcall(fn, moduleObj, a) end
    return ok, res
  end

  local function safeBoolFrom(fnName)
    local ok, res = callNoSelf(fnName)
    if ok then return res == true end
    ok, res = callWithSelf(fnName)
    if ok then return res == true end
    return nil
  end

  local function safeIsOn()
    if not moduleObj then return false end

    if type(isOnFn) == "table" then
      for i = 1, #isOnFn do
        if isOnFn[i] == "isOn" then
          local b = safeBoolFrom("isOn")
          if b ~= nil then return b end
        end
      end
      for i = 1, #isOnFn do
        if isOnFn[i] == "isOff" then
          local b = safeBoolFrom("isOff")
          if b ~= nil then return not b end
        end
      end
      return false
    end

    if type(isOnFn) == "string" and isOnFn ~= "" then
      local b = safeBoolFrom(isOnFn)
      if b ~= nil then return b end
    end

    local b1 = safeBoolFrom("isOn")
    if b1 ~= nil then return b1 end
    local b2 = safeBoolFrom("isOff")
    if b2 ~= nil then return not b2 end

    return false
  end

  local function safeSetOn()
    local name = (type(setOnFn) == "string" and setOnFn ~= "" and setOnFn) or "setOn"

    local ok1 = callNoSelf(name)
    if ok1 then return end
    local ok2 = callWithSelf(name)
    if ok2 then return end

    ok1 = callNoSelf(name, true)
    if ok1 then return end
    ok2 = callWithSelf(name, true)
    if ok2 then return end
  end

  local function safeSetOff()
    local offName = (type(setOffFn) == "string" and setOffFn ~= "" and setOffFn) or "setOff"
    local onName  = (type(setOnFn) == "string" and setOnFn ~= "" and setOnFn) or "setOn"

    local ok1 = callNoSelf(offName)
    if ok1 then return end
    local ok2 = callWithSelf(offName)
    if ok2 then return end

    ok1 = callNoSelf(offName, true)
    if ok1 then return end
    ok2 = callWithSelf(offName, true)
    if ok2 then return end

    ok1 = callNoSelf(offName, false)
    if ok1 then return end
    ok2 = callWithSelf(offName, false)
    if ok2 then return end

    ok1 = callNoSelf(onName, false)
    if ok1 then return end
    ok2 = callWithSelf(onName, false)
    if ok2 then return end
  end

  local function applyState(state)
    state = (state == true)
    db.status[iconId] = state
    if icon.status then
      icon.status:show()
      icon.status:setOn(state)
    end
  end

  applyState(safeIsOn())

  icon.onClick = function()
    if safeIsOn() then
      safeSetOff()
      applyState(false)
    else
      safeSetOn()
      applyState(true)
    end
  end

  macro(300, function()
    if not icons or not icons[iconId] then return end
    local s = safeIsOn()
    if icon.status and icon.status:isOn() ~= s then
      applyState(s)
    end
  end)
end

local function bindIconToBotModuleLate(iconId, getModuleFn)
  local tries = 0
  local maxTries = 200
  local stepMs = 100

  local function tryBind()
    tries = tries + 1

    if not icons or not icons[iconId] then
      if tries < maxTries then later(stepMs, tryBind) end
      return
    end

    local mod = nil
    if type(getModuleFn) == "function" then
      local ok, res = pcall(getModuleFn)
      if ok then mod = res end
    end

    if not mod or type(mod) ~= "table" then
      if tries < maxTries then later(stepMs, tryBind) end
      return
    end

    local hasSetOn  = type(mod.setOn)  == "function"
    local hasSetOff = type(mod.setOff) == "function"
    if not hasSetOn and not hasSetOff then
      if tries < maxTries then later(stepMs, tryBind) end
      return
    end

    bindIconToBotModule(iconId, mod, {"isOn","isOff"}, "setOn", "setOff")
  end

  tryBind()
end

-- 4) Icon action (one-shot)
local function bindIconToAction(iconId, actionFn)
  if not icons or not icons[iconId] then return end
  local icon = icons[iconId]

  icon.onClick = function()
    if type(actionFn) == "function" then
      pcall(actionFn)
    end
    if icon.status then
      icon.status:show()
      icon.status:setOn(true)
      later(300, function()
        if icons and icons[iconId] and icons[iconId].status then
          icons[iconId].status:setOn(false)
        end
      end)
    end
    db.status[iconId] = false
  end
end

local function bindIconToPanelEnabledLate(iconId, panelName, getSwitchFn)
  local tries = 0
  local maxTries = 80
  local stepMs = 100

  local function tryBind()
    tries = tries + 1

    if not icons or not icons[iconId] then
      if tries < maxTries then later(stepMs, tryBind) end
      return
    end

    local sw = nil
    if type(getSwitchFn) == "function" then
      local ok, res = pcall(getSwitchFn)
      if ok then sw = res end
    end

    if not sw or not sw.setOn or not sw.isOn then
      if tries < maxTries then later(stepMs, tryBind) end
      return
    end

    storage[panelName] = storage[panelName] or {}
    storage[panelName].enabled = storage[panelName].enabled == true

    local icon = icons[iconId]
    local lock = false

    local function apply(state)
      state = (state == true)
      storage[panelName].enabled = state

      if sw:isOn() ~= state then
        sw:setOn(state)
      end

      db.status[iconId] = state
      if icon.status then
        icon.status:show()
        icon.status:setOn(state)
      end
    end

    apply(storage[panelName].enabled)

    local oldSwitchClick = sw.onClick
    sw.onClick = function(widget, ...)
      if lock then return end
      lock = true

      if type(oldSwitchClick) == "function" then
        pcall(oldSwitchClick, widget, ...)
      else
        widget:setOn(not widget:isOn())
      end

      apply(widget:isOn())
      lock = false
    end

    icon.onClick = function()
      if lock then return end
      lock = true
      apply(not (storage[panelName].enabled == true))
      lock = false
    end
  end

  tryBind()
end

local function bindIconToPushMaxLate(iconId)
  local tries = 0
  local maxTries = 120
  local stepMs = 100

  local function tryBind()
    tries = tries + 1

    if not icons or not icons[iconId] then
      if tries < maxTries then later(stepMs, tryBind) end
      return
    end

    local sw = (mainUI and mainUI.switch) or nil
    if not sw or not sw.setOn or not sw.isOn then
      if tries < maxTries then later(stepMs, tryBind) end
      return
    end

    storage.pvpSystem = storage.pvpSystem or {}
    storage.pvpSystem.pushSystem = storage.pvpSystem.pushSystem or { enabled = false }
    local cfg = storage.pvpSystem.pushSystem

    local icon = icons[iconId]
    local lock = false

    local function apply(state)
      state = (state == true)
      cfg.enabled = state

      if sw:isOn() ~= state then
        sw:setOn(state)
      end

      db.status[iconId] = state
      if icon.status then
        icon.status:show()
        icon.status:setOn(state)
      end
    end

    apply(cfg.enabled == true)

    local oldSwitchClick = sw.onClick
    sw.onClick = function(widget, ...)
      if lock then return end
      lock = true

      if type(oldSwitchClick) == "function" then
        pcall(oldSwitchClick, widget, ...)
      else
        widget:setOn(not widget:isOn())
        cfg.enabled = widget:isOn()
      end

      apply(cfg.enabled == true)
      lock = false
    end

    icon.onClick = function()
      if lock then return end
      lock = true
      apply(not (cfg.enabled == true))
      lock = false
    end

    macro(300, function()
      if not icons or not icons[iconId] then return end
      local s = (cfg.enabled == true)
      if icon.status and icon.status:isOn() ~= s then
        apply(s)
      end
    end)
  end

  tryBind()
end

LnsUtilIcons = LnsUtilIcons or {}

function LnsUtilIcons.onToggleChanged(toggleKey, state)
  if not storage.lnsUtilIcons or not storage.lnsUtilIcons[MyConfigName] then return end

  local iconId = nil
  for _, def in pairs(storage.lnsUtilIcons[MyConfigName]) do
    if def and def.storeKey == toggleKey then
      iconId = def.id
      break
    end
  end
  if not iconId then return end
  if not icons or not icons[iconId] then return end

  state = (state == true)
  db.status[iconId] = state

  local icon = icons[iconId]
  if icon.status then
    icon.status:show()
    icon.status:setOn(state)
  end

  if state then
    db.enabled = true
    if iconButton and iconButton.title and iconButton.title.setOn then
      iconButton.title:setOn(true)
    end

    local showKey = "show_" .. iconId
    db.iconConfig[showKey] = true

    if rows and rows[iconId] and rows[iconId].check and rows[iconId].check.setOn then
      rows[iconId].check:setOn(true)
    end
    applyIconsVisibility()
  end
end

bindIconToConditionsCheck("lnsHaste", "conditionsInterface", "spellHaste")
bindIconToConditionsCheck("lnsBuff", "conditionsInterface", "spellBuff")
bindIconToConditionsCheck("lnsAntiLyze", "conditionsInterface", "spellAntilyze")
bindIconToConditionsCheck("lnsAutoUtamoVita", "conditionsInterface", "spellUtamo")
bindIconToConditionsCheck("lnsAutoUtanaVid", "conditionsInterface", "spellUtana")
bindIconToConditionsCheck("lnsExetaRes", "conditionsInterface", "exetaRes")
bindIconToConditionsCheck("lnsAmpRes", "conditionsInterface", "exetaAmpRes")
bindIconToConditionsCheck("lnsUturaGran", "conditionsInterface", "spellUtura")
bindIconToConditionsCheck("lnsExetaLoot", "conditionsInterface", "exetaLoot")
bindIconToConditionsCheck("lnsCureStatus", "conditionsInterface", "cureStatus")

if healingButton and healingButton.title then bindIconToToggle("lnsHealing", healingButton.title, "healingButton") end
if comboButton and comboButton.title then bindIconToToggle("lnsAttackBot", comboButton.title, "comboButton") end
if sioButton and sioButton.title then bindIconToToggle("lnsAutoSio", sioButton.title, "sioButton") end
if mwSystemButton and mwSystemButton.title then bindIconToToggle("lnsMwSystem", mwSystemButton.title, "mwSystemButton") end
if conditionsButton and conditionsButton.title then bindIconToToggle("lnsConditions", conditionsButton.title, "conditionsButton") end
if followButton and followButton.title then bindIconToToggle("lnsFollow", followButton.title, "followButton") end
if buttonSwapEquips and buttonSwapEquips.title then bindIconToToggle("lnsSwapEquips", buttonSwapEquips.title, "buttonSwapEquips") end
if swapButton and swapButton.title then bindIconToToggle("lnsSwapRingAMulet", swapButton.title, "swapButton") end

bindIconToBotModuleLate("lnsCaveBot", function() return CaveBot end)
bindIconToBotModuleLate("lnsTargetBot", function() return TargetBot end)

bindIconToPushMaxLate("lnsPushmax")

local function bindUtilitariosIcons()
  if not storage.lnsUtilIcons or not storage.lnsUtilIcons[MyConfigName] then return end
  for _, def in pairs(storage.lnsUtilIcons[MyConfigName]) do
    if def and def.id and def.storeKey and icons[def.id] then
      local iconId = def.id 
      local key = def.storeKey
      local icon = icons[iconId]

      icon.onClick = function()
        local newState = true

        if storage.utilityToggles then
          newState = not (storage.utilityToggles[key] == true)
        end

        if type(setUtilityToggle) == "function" then
          setUtilityToggle(key, newState)
        else
          storage.utilityToggles = storage.utilityToggles or {}
          storage.utilityToggles[key] = newState
          if LnsUtilIcons and type(LnsUtilIcons.onToggleChanged) == "function" then
            LnsUtilIcons.onToggleChanged(key, newState)
          end
        end

        if newState then
          db.enabled = true
          if iconButton and iconButton.title and iconButton.title.setOn then
            iconButton.title:setOn(true)
          end
          db.iconConfig["show_" .. iconId] = true
          if rows[iconId] and rows[iconId].check and rows[iconId].check.setOn then
            rows[iconId].check:setOn(true)
          end
          applyIconsVisibility()
        end

        db.status[iconId] = newState
        if icon.status then
          icon.status:show()
          icon.status:setOn(newState)
        end
      end

      local s = (storage.utilityToggles and storage.utilityToggles[key] == true)
      db.status[iconId] = s
      if icon.status then
        icon.status:show()
        icon.status:setOn(s)
      end
    end
  end
end
bindUtilitariosIcons()

if icons["lnsParty"] then
  local icon = icons["lnsParty"]
  icon.onClick = function()
    if LnsPartyBridge and type(LnsPartyBridge.getEnabled) == "function" and type(LnsPartyBridge.setEnabled) == "function" then
      local newState = not LnsPartyBridge.getEnabled()
      LnsPartyBridge.setEnabled(newState)
      db.status["lnsParty"] = newState
      if icon.status then icon.status:show(); icon.status:setOn(newState) end
      if newState then
        db.enabled = true
        iconButton.title:setOn(true)
        db.iconConfig["show_lnsParty"] = true
        if rows["lnsParty"] and rows["lnsParty"].check then rows["lnsParty"].check:setOn(true) end
        applyIconsVisibility()
      end
      return
    end

    storage.autoParty = storage.autoParty or {}
    storage.autoParty.enabled = not (storage.autoParty.enabled == true)
    local s = storage.autoParty.enabled == true
    db.status["lnsParty"] = s
    if icon.status then icon.status:show(); icon.status:setOn(s) end
  end

  local initState = false
  if LnsPartyBridge and type(LnsPartyBridge.getEnabled) == "function" then
    initState = LnsPartyBridge.getEnabled()
  else
    initState = storage.autoParty and storage.autoParty.enabled == true
  end
  db.status["lnsParty"] = initState
  if icon.status then icon.status:show(); icon.status:setOn(initState) end

  bindIconToPanelEnabledLate("lnsParty", "autoParty", function()
    return (autopartyui and autopartyui.status) or (tcAutoParty)
  end)
end

bindIconToPanelEnabledLate("lnsImbuiment", "imbuimentSystem", function()
  return buttonImbuiment and buttonImbuiment.status
end)

macro(200, function()
  local iconId = "lnsAutoAol"
  if db.status[iconId] ~= true then return end

  local aolId = tonumber(db.items[iconId]) or 3057
  if aolId <= 0 then return end

  if not getNeck or not findItem or not moveToSlot then return end

  local neck = getNeck()
  local hasAol = neck and neck.getId and (neck:getId() == aolId)
  if hasAol then return end

  local aol = findItem(aolId)
  if aol then
    local neckSlot = SlotNeck or 2
    moveToSlot(aol, neckSlot, 1)
  else
    say("!aol")
    delay(1000)
  end
end)

local blessState = { hasBought = false }

local function getBlessCommand()
  if not g_game or not g_game.getWorldName then
    return "!bless"
  end
  local world = g_game.getWorldName()
  if world == "Telaria" or world == "Eternia" then
    return "!bless yes"
  end
  return "!bless"
end

macro(1000, function()
  local iconId = "lnsAutoBless"
  if db.status[iconId] ~= true then return end
  if not say or not player then return end

  local blessCommand = getBlessCommand()

  if blessState.hasBought ~= true then
    say(blessCommand)
    blessState.hasBought = true
    return
  end

  if player.getBlessings and g_game.getClientVersion then
    if g_game.getClientVersion() > 1000 and player:getBlessings() == 0 then
      say(blessCommand)
    end
  end
end)

blessState.hasBought = false
