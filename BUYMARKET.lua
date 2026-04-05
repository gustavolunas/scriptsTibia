setDefaultTab("LNS")
print("bmarket atualizado")

storage = storage or {}

local MARKET_STORAGE_KEY = "lns_buy_market_v2"
local DEPOT_IDS = { [3497]=true, [3498]=true, [3499]=true, [2594]=true }
local MARKET_ID = 12903
local MAIL_ID = 12902

-- =========================
-- BASE
-- =========================
local function deepCopy(t)
  if type(t) ~= "table" then return t end
  local r = {}
  for k, v in pairs(t) do r[k] = deepCopy(v) end
  return r
end

local function mergeDefaults(dst, def)
  if type(dst) ~= "table" then dst = {} end
  for k, v in pairs(def) do
    if dst[k] == nil then
      dst[k] = deepCopy(v)
    elseif type(v) == "table" and type(dst[k]) == "table" then
      dst[k] = mergeDefaults(dst[k], v)
    end
  end
  return dst
end

local function clamp(n, a, b)
  n = tonumber(n) or a
  if n < a then return a end
  if n > b then return b end
  return n
end

local function trim(s)
  return tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function normalize(s)
  return trim(tostring(s or ""):lower():gsub("%s+", " "))
end

local function ms()
  if g_clock and g_clock.millis then return g_clock.millis() end
  if g_clock and g_clock.seconds then return math.floor(g_clock.seconds() * 1000) end
  return os.time() * 1000
end

local function safeChildren(w)
  if not w or not w.getChildren then return {} end
  local ok, c = pcall(function() return w:getChildren() end)
  return ok and c or {}
end

local function clearChildren(w)
  local c = safeChildren(w)
  for i = #c, 1, -1 do
    local child = c[i]
    if child and not child:isDestroyed() then child:destroy() end
  end
end

local function safeText(w)
  if not w or not w.getText then return nil end
  local ok, t = pcall(function() return w:getText() end)
  return ok and t or nil
end

local function safeVisible(w)
  if not w then return false end
  if w.isVisible then
    local ok, v = pcall(function() return w:isVisible() end)
    if ok then return v end
  end
  if w.isHidden then
    local ok, h = pcall(function() return w:isHidden() end)
    if ok then return not h end
  end
  return true
end

local function safeEnabled(w)
  if not w then return false end
  if w.isEnabled then
    local ok, v = pcall(function() return w:isEnabled() end)
    if ok then return v end
  end
  return true
end

local function click(w)
  if not w then return false end
  if w.click and pcall(function() w:click() end) then return true end
  if w.onClick and pcall(function() w:onClick() end) then return true end
  pcall(function() w:onMousePress({x=5,y=5}, 1) end)
  if w.onMouseRelease and pcall(function() w:onMouseRelease({x=5,y=5}, 1) end) then return true end
  return false
end

local function focus(w)
  if w and w.focus then pcall(function() w:focus() end) end
end

local function setText(w, text)
  if not w or not w.setText then return false end
  return pcall(function() w:setText(text) end)
end

local function parseNumber(v)
  local n = tostring(v or ""):gsub("[^%d]", "")
  return n ~= "" and tonumber(n) or nil
end

local function rfind(w, id)
  if not w then return nil end
  if w.recursiveGetChildById then
    local ok, child = pcall(function() return w:recursiveGetChildById(id) end)
    if ok and child then return child end
  end
  for _, c in ipairs(safeChildren(w)) do
    local found = rfind(c, id)
    if found then return found end
  end
  return nil
end

local function getBotItemId(w)
  if not w then return 0 end
  if w.getItemId then return tonumber(w:getItemId()) or 0 end
  if w.getItem and w:getItem() and w:getItem().getId then
    return tonumber(w:getItem():getId()) or 0
  end
  return 0
end

local function setBotItemId(w, id)
  if not w then return end
  id = tonumber(id) or 0
  if w.setItemId then
    w:setItemId(id)
    return
  end
  if w.setItem and Item and Item.create and id > 0 then
    w:setItem(Item.create(id, 1))
  end
end

local function getWidgetItemId(widget)
  if not widget then return nil end

  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and item.getId then
      local ok2, id = pcall(function() return item:getId() end)
      if ok2 and id then return id end
    end
  end

  if widget.item and widget.item.getId then
    local ok, id = pcall(function() return widget.item:getId() end)
    if ok and id then return id end
  end

  if widget.getItemId then
    local ok, id = pcall(function() return widget:getItemId() end)
    if ok and id then return id end
  end

  return nil
end

local function findWidgetByItemId(widget, wantedId)
  if not widget then return nil end
  if getWidgetItemId(widget) == wantedId then return widget end
  for _, child in ipairs(safeChildren(widget)) do
    local found = findWidgetByItemId(child, wantedId)
    if found then return found end
  end
  return nil
end

local function posEq(a, b)
  return a and b and a.x == b.x and a.y == b.y and a.z == b.z
end

local function mapDist(a, b)
  return getDistanceBetween and getDistanceBetween(a, b) or math.abs(a.x - b.x) + math.abs(a.y - b.y)
end

local function topThing(tile)
  if not tile or not tile.getTopUseThing then return nil end
  local ok, thing = pcall(function() return tile:getTopUseThing() end)
  return ok and thing or nil
end

local function topId(tile)
  local thing = topThing(tile)
  if not thing or not thing.getId then return nil end
  local ok, id = pcall(function() return thing:getId() end)
  return ok and id or nil
end

local function hasOtherPlayer(tile)
  if not tile or not tile.getCreatures then return false end
  local ok, list = pcall(function() return tile:getCreatures() end)
  if not ok or not list then return false end
  local me = player:getName()
  for _, c in ipairs(list) do
    if c and c.isPlayer and c:isPlayer() and c:getName() ~= me then
      return true
    end
  end
  return false
end

local function canStand(pos)
  local tile = g_map.getTile(pos)
  -- Apagamos a checagem de outros players aqui:
  if not tile then return false end 
  if posEq(player:getPosition(), pos) then return true end
  if tile.isWalkable then
    local ok, v = pcall(function() return tile:isWalkable() end)
    return ok and v or false
  end
  return false
end

local function W(root, id)
  if not root then return nil end
  if root.recursiveGetChildById then return root:recursiveGetChildById(id) end
  if root.getChildById then return root:getChildById(id) end
  return nil
end

-- =========================
-- ITEM NAMES
-- =========================
local function safeRead(path)
  if not g_resources or not g_resources.readFileContents then
    return nil
  end
  local ok, content = pcall(function() return g_resources.readFileContents(path) end)
  if not ok or not content or content == "" then return nil end
  return content
end

local function loadLootItems()
  local cfgName = (type(MyConfigName) == "string" and MyConfigName ~= "" and MyConfigName) or "CUSTOM"
  local content =
    safeRead("/bot/" .. cfgName .. "/loot_items.lua") or
    safeRead("/bot/" .. cfgName .. "/loot_items") or
    safeRead("loot_items.lua")

  if not content then
    return {}
  end

  local list, seen = {}, {}
  for name, idStr in content:gmatch('%["(.-)"%]%s*=%s*(%d+)') do
    local id = tonumber(idStr)
    if id and not seen[id] then
      seen[id] = true
      list[#list + 1] = { name = tostring(name), id = id }
    end
  end

  table.sort(list, function(a, b) return (a.id or 0) < (b.id or 0) end)
  return list
end

local itemNameById = {}
for _, e in ipairs(loadLootItems()) do
  if e.id and e.name and e.name ~= "" then
    itemNameById[e.id] = e.name
  end
end

local function getItemDisplayName(itemId)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return "Unknown Item" end
  return itemNameById[itemId] or ("Item ID " .. itemId)
end

-- =========================
-- STORAGE
-- =========================
local function defaultMarketCfg()
  return {
    list = {},
    draft = {
      itemId = 0,
      name = "",
      amount = 1,
      maxPrice = 1
    }
  }
end

storage[MARKET_STORAGE_KEY] = mergeDefaults(storage[MARKET_STORAGE_KEY], defaultMarketCfg())
local marketCfg = storage[MARKET_STORAGE_KEY]
if type(marketCfg.list) ~= "table" then marketCfg.list = {} end
marketCfg.draft = marketCfg.draft or { itemId = 0, name = "", amount = 1, maxPrice = 1 }

marketInterface = setupUI([=[
UIWindow
  id: mainPanel
  size: 380 300
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
    border: 1 #1f1f1f

  Label
    id: titleLabel
    anchors.centerIn: topBar
    text: LNS Custom | Buy Market
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
    $hover:
      color: black
      opacity: 0.85

  UIButton
    id: clickHere
    anchors.top: topBar.bottom
    anchors.left: parent.left
    text: CLIQUE AQUI
    margin-top: 6
    margin-left: 63
    color: #FFD700
    font: verdana-9px
    $hover:
      opacity: 0.80

  Label
    id: labelClick
    anchors.verticalCenter: clickHere.verticalCenter
    anchors.left: clickHere.right
    margin-left: 0
    text: PARA GERENCIAR O BUY MARKET!
    font: verdana-9px

  TextList
    id: marketList
    anchors.top: clickHere.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin: 5
    margin-right: 15
    vertical-scrollbar: marketListScrollBar
    image-color: gray
    border: 1 black

  VerticalScrollBar
    id: marketListScrollBar
    anchors.top: marketList.top
    anchors.bottom: marketList.bottom
    anchors.left: marketList.right
    step: 10
    pixels-scroll: true
    border: 1 #1f1f1f
    image-color: #363636
]=], g_ui.getRootWidget())
marketInterface:hide()

marketAdd = setupUI([=[
UIWindow
  id: mainPanel
  size: 300 95
  anchors.centerIn: parent
  margin-top: -60
  opacity: 1.00

  Panel
    anchors.fill: parent
    background-color: #0b0b0b
    opacity: 0.88

  Panel
    id: topBar
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 19
    background-color: #111111
    border: 1 #1f1f1f

  Label
    anchors.centerIn: topBar
    text: "  ITEM        |           QUANTD           |          MAX PRICE"
    color: orange
    text-align: center
    font: verdana-9px

  BotItem
    id: itemMarket
    anchors.top: topBar.bottom
    anchors.left: parent.left
    margin-top: 7
    margin-left: 25
    image-source: /images/ui/item-blessed

  SpinBox
    id: amount
    anchors.verticalCenter: itemMarket.verticalCenter
    anchors.left: itemMarket.right
    width: 107
    margin-left: 25
    text-align: center
    font: verdana-9px
    image-color: gray
    minimum: 1
    maximum: 1000000000
    step: 1
    editable: true
    focusable: true

  SpinBox
    id: maxprice
    anchors.verticalCenter: itemMarket.verticalCenter
    anchors.left: amount.right
    width: 100
    margin-left: 4
    text-align: center
    font: verdana-9px
    image-color: gray
    minimum: 1
    maximum: 1000000000
    step: 1
    editable: true
    focusable: true

  Button
    id: cancelarBt
    anchors.left: parent.left
    anchors.top: itemMarket.bottom
    image-source: /images/ui/button_rounded
    size: 145 25
    margin-top: 10
    margin-left: 5
    image-color: #363636
    text: CANCELAR
    font: verdana-9px
    color: white
    $hover:
      color: #FF4040

  Button
    id: adicionarBt
    anchors.left: cancelarBt.right
    anchors.top: cancelarBt.top
    image-source: /images/ui/button_rounded
    size: 145 25
    image-color: #363636
    text: ADICIONAR
    font: verdana-9px
    color: white
    $hover:
      color: #98FB98
]=], g_ui.getRootWidget())
marketAdd:hide()

local marketList = W(marketInterface, "marketList")
local marketClose = W(marketInterface, "closePanel")
local marketClickHere = W(marketInterface, "clickHere")

local addItemBot = W(marketAdd, "itemMarket")
local addAmount = W(marketAdd, "amount")
local addMaxPrice = W(marketAdd, "maxprice")
local addCancel = W(marketAdd, "cancelarBt")
local addConfirm = W(marketAdd, "adicionarBt")

local editingIndex = nil

local rowTemplate = [[
UIWidget
  id: root
  height: 40
  focusable: true
  background-color: alpha

  $hover:
    background-color: #2F2F2F
    opacity: 0.80

  $focus:
    background-color: #404040
    opacity: 0.90

  CheckBox
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    width: 14
    height: 14
    margin-left: 4
    image-source: /images/ui/checkbox_round

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
    size: 38 38

  Label
    id: itemName
    anchors.left: icon.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    font: verdana-9px
    color: white

  Label
    id: amountText
    anchors.left: itemName.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-9px
    color: white
    text-auto-resize: true

  Label
    id: priceText
    anchors.left: amountText.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    font: verdana-9px
    color: white
    text-auto-resize: true

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

local function resetDraft()
  editingIndex = nil
  marketCfg.draft.itemId = 0
  marketCfg.draft.name = ""
  marketCfg.draft.amount = 1
  marketCfg.draft.maxPrice = 1
  if addItemBot then setBotItemId(addItemBot, 0) end
  if addAmount then addAmount:setValue(1) end
  if addMaxPrice then addMaxPrice:setValue(1) end
end

local function loadDraft()
  if addItemBot then setBotItemId(addItemBot, marketCfg.draft.itemId or 0) end
  if addAmount then addAmount:setValue(clamp(marketCfg.draft.amount or 1, 1, 1000000000)) end
  if addMaxPrice then addMaxPrice:setValue(clamp(marketCfg.draft.maxPrice or 1, 1, 1000000000)) end
end

local function refreshMarketList()
  if not marketList then return end
  clearChildren(marketList)

  for i, entry in ipairs(marketCfg.list) do
    entry.enabled = (entry.enabled ~= false)
    entry.itemId = tonumber(entry.itemId or 0) or 0
    entry.name = tostring(entry.name or getItemDisplayName(entry.itemId))
    entry.amount = clamp(entry.amount or 1, 1, 1000000000)
    entry.maxPrice = clamp(entry.maxPrice or 1, 1, 1000000000)

    local row = setupUI(rowTemplate, marketList)
    row.entryIndex = i
    row.enabled:setChecked(entry.enabled)

    row.enabled.onClick = function()
      entry.enabled = not entry.enabled
      row.enabled:setChecked(entry.enabled)
    end

    if row.icon and row.icon.setItemId then
      row.icon:setItemId(entry.itemId)
    elseif row.icon and row.icon.setItem and Item and Item.create and entry.itemId > 0 then
      row.icon:setItem(Item.create(entry.itemId, 1))
    end

    row.itemName:setText("[" .. string.upper(entry.name):sub(1, 12) .. "]")
    row.amountText:setText("[AMOUNT: " .. tostring(entry.amount) .. "]")
    row.priceText:setText("[MAX PRICE: " .. tostring(entry.maxPrice) .. "]")

    row.remove.onClick = function()
      table.remove(marketCfg.list, row.entryIndex)
      if editingIndex == row.entryIndex then editingIndex = nil end
      refreshMarketList()
    end

    row.onClick = function(widget)
      if marketList.focusChild then marketList:focusChild(widget) end
    end

    row.onDoubleClick = function(widget)
      local idx = widget.entryIndex
      local e = marketCfg.list[idx]
      if not e then return end

      editingIndex = idx
      marketCfg.draft.itemId = tonumber(e.itemId or 0) or 0
      marketCfg.draft.name = tostring(e.name or getItemDisplayName(e.itemId))
      marketCfg.draft.amount = clamp(e.amount or 1, 1, 1000000000)
      marketCfg.draft.maxPrice = clamp(e.maxPrice or 1, 1, 1000000000)

      loadDraft()
      marketInterface:hide()
      marketAdd:show()
      marketAdd:raise()
      marketAdd:focus()
    end
  end
end

if addItemBot and addItemBot.onItemChange then
  addItemBot.onItemChange = function(widget)
    local itemId = getBotItemId(widget)
    marketCfg.draft.itemId = itemId
    marketCfg.draft.name = getItemDisplayName(itemId)
  end
end

if addAmount then
  addAmount.onValueChange = function(widget, value)
    local v = tonumber(value)
    if not v and widget.getValue then v = tonumber(widget:getValue()) end
    marketCfg.draft.amount = clamp(v or 1, 1, 1000000000)
  end
end

if addMaxPrice then
  addMaxPrice.onValueChange = function(widget, value)
    local v = tonumber(value)
    if not v and widget.getValue then v = tonumber(widget:getValue()) end
    marketCfg.draft.maxPrice = clamp(v or 1, 1, 1000000000)
  end
end

if marketClickHere then
  marketClickHere.onClick = function()
    editingIndex = nil
    loadDraft()
    marketInterface:hide()
    marketAdd:show()
    marketAdd:raise()
    marketAdd:focus()
  end
end

if marketClose then
  marketClose.onClick = function()
    marketInterface:hide()
  end
end

if addCancel then
  addCancel.onClick = function()
    marketAdd:hide()
    marketInterface:show()
    marketInterface:raise()
    marketInterface:focus()
    resetDraft()
  end
end

if addConfirm then
  addConfirm.onClick = function()
    local itemId = getBotItemId(addItemBot)
    local amount = clamp(addAmount and addAmount:getValue() or 1, 1, 1000000000)
    local maxPrice = clamp(addMaxPrice and addMaxPrice:getValue() or 1, 1, 1000000000)

    if itemId <= 0 then
      return
    end

    local resolvedName = getItemDisplayName(itemId)
    if editingIndex and marketCfg.list[editingIndex] and resolvedName:find("^Item ID ") then
      resolvedName = tostring(marketCfg.list[editingIndex].name or resolvedName)
    end

    local entry = {
      enabled = true,
      itemId = itemId,
      name = resolvedName,
      amount = amount,
      maxPrice = maxPrice
    }

    if editingIndex and marketCfg.list[editingIndex] then
      entry.enabled = (marketCfg.list[editingIndex].enabled ~= false)
      marketCfg.list[editingIndex] = entry
    else
      table.insert(marketCfg.list, entry)
    end

    refreshMarketList()
    resetDraft()

    marketAdd:hide()
    marketInterface:show()
    marketInterface:raise()
    marketInterface:focus()
  end
end

marketAdd:hide()
loadDraft()
refreshMarketList()

-- =========================
-- MARKET UI
-- =========================
local function getMarketUI()
  if not rootWidget or not rootWidget.recursiveGetChildById then return nil end
  local m = rootWidget:recursiveGetChildById("marketWindow")
  if not m then return nil end
  return {
    market = m,
    searchEdit = m:recursiveGetChildById("searchEdit"),
    filterSearchAll = m:recursiveGetChildById("filterSearchAll"),
    itemsPanel = m:recursiveGetChildById("itemsPanel"),
    sellingTable = m:recursiveGetChildById("sellingTable"),
    sellingTableData = m:recursiveGetChildById("sellingTableData"),
    buyButton = m:recursiveGetChildById("buyButton"),
  }
end

local function closeMarketWindow()
  if modules and modules.game_market and modules.game_market.hide then
    local ok = pcall(function() modules.game_market.hide() end)
    if ok then return true end
  end

  local ui = getMarketUI()
  if not ui or not ui.market then return false end

  local closeBtn =
    ui.market:recursiveGetChildById("closeButton") or
    ui.market:recursiveGetChildById("closePanel") or
    ui.market:recursiveGetChildById("closeButtonTop")

  if closeBtn and click(closeBtn) then return true end
  if ui.market.hide then
    local ok = pcall(function() ui.market:hide() end)
    if ok then return true end
  end
  return false
end

local function marketReady()
  local ui = getMarketUI()
  if not ui or not ui.market then return nil end
  if ui.market.isHidden then
    local ok, hidden = pcall(function() return ui.market:isHidden() end)
    if ok and hidden then return nil end
  end
  return ui
end

local function setSearchAll(ui)
  local btn = ui and ui.filterSearchAll
  if not btn then return end
  if btn.isChecked then
    local ok, checked = pcall(function() return btn:isChecked() end)
    if ok and checked then return end
  end
  if btn.setChecked then pcall(function() btn:setChecked(true) end) end
  click(btn)
end

local function collectItemBoxes(w, out)
  out = out or {}
  if not w then return out end

  local ok, hasItem = pcall(function()
    return w.item and w.item.marketData and w.item.marketData.name
  end)

  if ok and hasItem and safeVisible(w) then
    out[#out + 1] = w
  end

  for _, c in ipairs(safeChildren(w)) do
    collectItemBoxes(c, out)
  end
  return out
end

local function findItemBox(itemsPanel, itemName)
  local wanted = normalize(itemName)
  for _, box in ipairs(collectItemBoxes(itemsPanel, {})) do
    local ok, name = pcall(function() return tostring(box.item.marketData.name) end)
    if ok and normalize(name) == wanted then return box end
  end
  return nil
end

local function selectItemBox(box)
  if not box then return false end
  if box.setChecked then pcall(function() box:setChecked(true) end) end
  if box.onCheckChange and pcall(function() box:onCheckChange(true) end) then return true end
  return click(box)
end

local function rowLooksLikeOffer(row)
  if not row or not safeVisible(row) or row.ref == nil then return false end
  local ch = safeChildren(row)
  if #ch < 4 then return false end
  for i = 1, #ch do
    local t = safeText(ch[i])
    if t and t ~= "" then return true end
  end
  return false
end

local function collectOfferRows(w, out)
  out = out or {}
  if not w then return out end
  for _, c in ipairs(safeChildren(w)) do
    if rowLooksLikeOffer(c) then
      out[#out + 1] = c
    else
      collectOfferRows(c, out)
    end
  end
  return out
end

local function firstSellRow(ui)
  local base = ui and (ui.sellingTableData or ui.sellingTable)
  local rows = collectOfferRows(base, {})
  return rows[1]
end

local function getPiecePrice(row)
  local ch = safeChildren(row)
  if #ch < 4 then return nil end
  local v3 = parseNumber(safeText(ch[3]))
  local v4 = parseNumber(safeText(ch[4]))
  if v3 and v4 then return math.min(v3, v4) end
  return v3 or v4
end

local function deepClick(row)
  if click(row) then return true end
  for _, c in ipairs(safeChildren(row)) do
    if click(c) then return true end
  end
  return false
end

local function selectOffer(ui, row)
  if not ui or not ui.sellingTable or not row or row.ref == nil then return false end

  focus(ui.sellingTable)
  focus(row)

  pcall(function() row:setChecked(true) end)
  pcall(function() row:setOn(true) end)
  pcall(function() row:setSelected(true) end)

  deepClick(row)

  if type(ui.sellingTable.onSelectionChange) == "function" then
    pcall(function() ui.sellingTable.onSelectionChange(ui.sellingTable, row, nil) end)
  end

  deepClick(row)

  if ui.buyButton and safeEnabled(ui.buyButton) then return true end

  if row.isChecked then
    local ok, v = pcall(function() return row:isChecked() end)
    if ok and v then return true end
  end
  if row.isOn then
    local ok, v = pcall(function() return row:isOn() end)
    if ok and v then return true end
  end
  if row.isSelected then
    local ok, v = pcall(function() return row:isSelected() end)
    if ok and v then return true end
  end

  return false
end

local function findAmountPopup()
  if not rootWidget then return nil end
  local sb = rootWidget:recursiveGetChildById("amountScrollBar")
  if not sb then return nil end
  if sb.getParent then
    local ok, p = pcall(function() return sb:getParent() end)
    if ok then return p end
  end
  return nil
end

local function setPopupAmount(popup, amount)
  local sb = rfind(popup, "amountScrollBar")
  if not sb or not sb.setValue then return false end
  return pcall(function() sb:setValue(amount) end)
end

local function getPopupAmount(popup)
  local sb = rfind(popup, "amountScrollBar")
  if not sb or not sb.getValue then return nil end
  local ok, v = pcall(function() return sb:getValue() end)
  return ok and tonumber(v) or nil
end

local function popupConfirm(popup)
  return click(rfind(popup, "buttonOk"))
end

local function popupCancel(popup)
  return click(rfind(popup, "buttonCancel"))
end

-- =========================
-- INVENTORY / MAIL
-- =========================
local function getAllContainers()
  if g_game and g_game.getContainers then
    local ok, containers = pcall(function() return g_game:getContainers() end)
    if ok and containers then return containers end
  end
  return {}
end

local function getContainerName(container)
  if not container or not container.getName then return "" end
  local ok, name = pcall(function() return tostring(container:getName() or "") end)
  return ok and name or ""
end

local function getContainerItems(container)
  if not container or not container.getItems then return {} end
  local ok, items = pcall(function() return container:getItems() end)
  return ok and items or {}
end

local function isBlockedContainerName(name)
  name = normalize(name)
  return name:find("your inbox", 1, true)
      or name:find("inbox", 1, true)
      or name:find("locker", 1, true)
      or name:find("depot", 1, true)
end

local function findMailContainer()
  for _, c in pairs(getAllContainers()) do
    if normalize(getContainerName(c)):find("inbox", 1, true) then
      return c
    end
  end
  return nil
end

local function getAnyOpenLootContainer()
  for _, c in pairs(getAllContainers()) do
    if not isBlockedContainerName(getContainerName(c)) then
      return c
    end
  end
  return nil
end

local function ensureLootContainerOpen()
  if getAnyOpenLootContainer() then return true end

  local playerObj = g_game.getLocalPlayer()
  if not playerObj or not playerObj.getInventoryItem or not InventorySlotFirst or not InventorySlotLast then
    return false
  end

  for slot = InventorySlotFirst, InventorySlotLast do
    local ok, item = pcall(function() return playerObj:getInventoryItem(slot) end)
    if ok and item then
      local idOk, itemId = pcall(function() return item:getId() end)
      if idOk and itemId and itemId > 0 then
        pcall(function() g_game.open(item) end)
      end
    end
  end

  schedule(150, function() end)
  return getAnyOpenLootContainer() ~= nil
end

local function getContainerDropPosition(container)
  if not container then return nil end

  if container.getItemsCount and container.getSlotPosition then
    local okCount, itemsCount = pcall(function() return container:getItemsCount() end)
    if okCount and tonumber(itemsCount) then
      local okPos, pos = pcall(function() return container:getSlotPosition(itemsCount) end)
      if okPos and pos then return pos end
    end
  end

  if container.getSlotPosition then
    local okPos, pos = pcall(function() return container:getSlotPosition(0) end)
    if okPos and pos then return pos end
  end

  return nil
end

local function moveItemToContainer(item, count, container)
  if not item or not container or not g_game or not g_game.move then return false end
  local pos = getContainerDropPosition(container)
  if not pos then return false end
  count = tonumber(count) or 1
  return pcall(function() g_game.move(item, pos, count) end)
end

local function getItemStackCount(item)
  if not item then return 0 end
  if item.getCount then
    local ok, c = pcall(function() return item:getCount() end)
    if ok and tonumber(c) then
      c = tonumber(c)
      if c > 1 then return c end
    end
  end
  return 1
end

local function countItemOpenContainersAndInventory(itemId)
  local total = 0
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return 0 end

  local playerObj = g_game.getLocalPlayer()
  if playerObj and playerObj.getInventoryItem and InventorySlotFirst and InventorySlotLast then
    for slot = InventorySlotFirst, InventorySlotLast do
      local ok, item = pcall(function() return playerObj:getInventoryItem(slot) end)
      if ok and item and item.getId then
        local ok2, id = pcall(function() return item:getId() end)
        if ok2 and tonumber(id) == itemId then
          total = total + getItemStackCount(item)
        end
      end
    end
  end

  for _, container in pairs(getAllContainers()) do
    for _, item in ipairs(getContainerItems(container)) do
      if item and item.getId then
        local ok3, id = pcall(function() return item:getId() end)
        if ok3 and tonumber(id) == itemId then
          total = total + getItemStackCount(item)
        end
      end
    end
  end

  return total
end

local function getOwnedAmount(itemId)
  itemId = tonumber(itemId) or 0
  if itemId <= 0 then return 0 end

  if type(itemAmount) == "function" then
    local ok, amount = pcall(function() return itemAmount(itemId) end)
    if ok and tonumber(amount) then
      return math.max(0, tonumber(amount))
    end
  end

  return countItemOpenContainersAndInventory(itemId)
end

local function buildAllowedMailItemOrder()
  local list, seen = {}, {}
  for _, entry in ipairs(marketCfg.list or {}) do
    if entry.enabled ~= false then
      local id = tonumber(entry.itemId or 0) or 0
      if id > 0 and not seen[id] then
        seen[id] = true
        list[#list + 1] = id
      end
    end
  end
  return list
end

local function findFirstAllowedItemInMailById(mail, wantedId)
  wantedId = tonumber(wantedId) or 0
  if wantedId <= 0 then return nil end

  for _, item in ipairs(getContainerItems(mail)) do
    if item and item.getId then
      local ok, id = pcall(function() return item:getId() end)
      id = ok and tonumber(id) or 0
      if id == wantedId then
        return item
      end
    end
  end

  return nil
end

local function collectAllowedMailItems(targetItemId)
  local mail = findMailContainer()
  if not mail then return "error", "mail container nao encontrado" end

  local dest = getAnyOpenLootContainer()
  if not dest then
    local opened = ensureLootContainerOpen()
    if opened then
      return "ensure_loot", nil
    end
    return "error", "nenhum container aberto"
  end

  local targetId = tonumber(targetItemId) or 0
  if targetId <= 0 then
    return "done_item", nil
  end

  local item = findFirstAllowedItemInMailById(mail, targetId)
  if not item then
    return "done_item", nil
  end

  local count = getItemStackCount(item)
  if moveItemToContainer(item, count, dest) then
    return "moved", nil, targetId, count
  end

  return "move_failed", "falha ao mover item id " .. tostring(targetId), targetId, count
end

-- =========================
-- DEPOT / LOCKER
-- =========================
local function bestDepot(range)
  local me = g_game.getLocalPlayer()
  if not me then return nil end
  local p = me:getPosition()
  if not p then return nil end

  local best
  local fallbackCurrent
  local offs = {{0,1},{0,-1},{1,0},{-1,0},{1,1},{-1,1},{1,-1},{-1,-1}}

  for x = -range, range do
    for y = -range, range do
      local dp = {x = p.x + x, y = p.y + y, z = p.z}
      local tile = g_map.getTile(dp)

      if tile and DEPOT_IDS[topId(tile)] then
        local foundStand = false

        for i = 1, #offs do
          local sp = {x = dp.x + offs[i][1], y = dp.y + offs[i][2], z = dp.z}
          if canStand(sp) then
            foundStand = true
            local d = mapDist(p, sp)
            if not best or d < best.d then
              best = { d = d, stand = sp, depot = dp }
            end
          end
        end

        -- fallback especial:
        -- se eu já estou colado no depot, aceita usar da posição atual
        if not foundStand and mapDist(p, dp) <= 1 then
          local d = mapDist(p, dp)
          if not fallbackCurrent or d < fallbackCurrent.d then
            fallbackCurrent = { d = d, stand = p, depot = dp }
          end
        end
      end
    end
  end

  return best or fallbackCurrent
end

local function useDepotAt(pos)
  local tile = g_map.getTile(pos)
  local thing = tile and topThing(tile)
  if not thing then return false end
  local id = topId(tile)
  if not id or not DEPOT_IDS[id] then return false end
  return pcall(function() g_game.use(thing) end)
end

local function useMarketFromLocker()
  if not rootWidget then return false end
  local widget = findWidgetByItemId(rootWidget, MARKET_ID)
  if not widget then return false end

  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and pcall(function() g_game.use(item) end) then return true end
  end

  if widget.item and pcall(function() g_game.use(widget.item) end) then return true end
  return click(widget)
end

local function useMailFromLocker()
  if not rootWidget then return false end
  local widget = findWidgetByItemId(rootWidget, MAIL_ID)
  if not widget then return false end

  if widget.getItem then
    local ok, item = pcall(function() return widget:getItem() end)
    if ok and item and pcall(function() g_game.use(item) end) then return true end
  end

  if widget.item and pcall(function() g_game.use(widget.item) end) then return true end
  return click(widget)
end

-- =========================
-- TASKS
-- =========================
local function buildMarketBuyListFromPanel()
  local list = {}
  for _, entry in ipairs(marketCfg.list or {}) do
    if entry.enabled ~= false then
      local itemId = tonumber(entry.itemId or 0) or 0
      local amount = tonumber(entry.amount or 0) or 0
      local maxPrice = tonumber(entry.maxPrice or 0) or 0
      local name = trim(entry.name or getItemDisplayName(itemId) or "")

      if itemId > 0 and amount > 0 and maxPrice > 0 and name ~= "" then
        list[#list + 1] = {
          itemId = itemId,
          name = name,
          amount = amount,
          maxPrice = maxPrice,
          baseOwned = nil
        }
      end
    end
  end
  return list
end

-- =========================
-- ENGINE
-- =========================
local autoBuyStep

local autoBuy = {
  running = false,
  step = "idle",
  nextAt = 0,

  tick = 50,

  waitSearch = 250,
  waitItem = 200,
  waitOffer = 180,
  waitBuy = 220,
  waitPopup = 180,

  maxSearch = 7,
  maxItem = 8,
  maxOffer = 5,
  maxSelect = 7,
  maxPopup = 7,

  retryItemMs = 200,
  closePopupOnFail = false,

  depotTarget = nil,
  depotPos = nil,
  depotTries = 0,
  openTries = 0,
  mailTries = 0,
  collectTries = 0,
  ensureLootTries = 0,

  mailItemOrder = {},
  mailItemIndex = 1,
  mailItemRetries = {},

  tasks = {},
  idx = 1,
  bought = {},
  tries = { search = 0, item = 0, offer = 0, select = 0, popup = 0 },
  row = nil
}

local lastLog = { msg = nil, at = 0 }
local function log(msg)
  msg = tostring(msg)
  local now = ms()
  if lastLog.msg == msg and now - lastLog.at < 1500 then return end
  lastLog.msg, lastLog.at = msg, now
  print("[AutoBuyMarket] " .. msg)
end

local function stopAutoBuy()
  autoBuy.running = false
  autoBuy.step = "idle"
  autoBuy.nextAt = 0
  autoBuy.depotTarget = nil
  autoBuy.depotPos = nil
  autoBuy.depotTries = 0
  autoBuy.openTries = 0
  autoBuy.mailTries = 0
  autoBuy.collectTries = 0
  autoBuy.ensureLootTries = 0
  autoBuy.mailItemOrder = {}
  autoBuy.mailItemIndex = 1
  autoBuy.mailItemRetries = {}
  autoBuy.tasks = {}
  autoBuy.idx = 1
  autoBuy.bought = {}
  autoBuy.tries = { search = 0, item = 0, offer = 0, select = 0, popup = 0 }
  autoBuy.row = nil

  if CaveBot and CaveBot.setOn then
    pcall(function() CaveBot.setOn() end)
  end
end

local function scheduleAutoBuy(delayMs)
  delayMs = math.max(1, tonumber(delayMs) or autoBuy.tick)
  autoBuy.nextAt = ms() + delayMs
  schedule(delayMs, function()
    if autoBuy.running then autoBuyStep() end
  end)
end

local function autoCurrentTask()
  return autoBuy.tasks[autoBuy.idx]
end

local function autoBoughtCount(itemId)
  return tonumber(autoBuy.bought[tonumber(itemId) or 0] or 0) or 0
end

local function autoAddBought(itemId, amount)
  itemId = tonumber(itemId) or 0
  autoBuy.bought[itemId] = autoBoughtCount(itemId) + (tonumber(amount) or 0)
end

local function autoRemaining(task)
  if not task then return 0 end

  if task.baseOwned == nil then
    task.baseOwned = getOwnedAmount(task.itemId)
    log(string.format("%s: possui %d, alvo %d, falta %d",
      tostring(task.name),
      tonumber(task.baseOwned) or 0,
      tonumber(task.amount) or 0,
      math.max(0, (tonumber(task.amount) or 0) - (tonumber(task.baseOwned) or 0))
    ))
  end

  return math.max(0, (tonumber(task.amount) or 0) - ((tonumber(task.baseOwned) or 0) + autoBoughtCount(task.itemId)))
end

local function autoResetTries()
  autoBuy.tries = { search = 0, item = 0, offer = 0, select = 0, popup = 0 }
  autoBuy.row = nil
end

local function autoNextTask()
  autoBuy.idx = autoBuy.idx + 1
  autoBuy.step = "buyer_idle"
  autoResetTries()
end

local function autoRetryItem(delayMs)
  autoBuy.step = "buyer_search"
  autoResetTries()
  scheduleAutoBuy(delayMs or autoBuy.retryItemMs)
end

local function autoCurrentMailItemId()
  return tonumber(autoBuy.mailItemOrder[autoBuy.mailItemIndex] or 0) or 0
end

local function autoNextMailItem()
  autoBuy.mailItemIndex = autoBuy.mailItemIndex + 1
  autoBuy.ensureLootTries = 0
end

autoBuyStep = function()
  if not autoBuy.running then return end

  local now = ms()
  if now < autoBuy.nextAt then
    scheduleAutoBuy(autoBuy.nextAt - now)
    return
  end

  -- DEPOT
  if autoBuy.step == "go_depot" then
    local found = bestDepot(7)
    if not found then
      stopAutoBuy()
      return
    end

    autoBuy.depotTarget = found.stand
    autoBuy.depotPos = found.depot
    autoBuy.depotTries = 0
    autoBuy.step = "walking_depot"
    scheduleAutoBuy(50)
    return
  end

  if autoBuy.step == "walking_depot" then
    local myPos = player:getPosition()
    if not myPos or not autoBuy.depotTarget or not autoBuy.depotPos then
      stopAutoBuy()
      return
    end

    if mapDist(myPos, autoBuy.depotPos) <= 1 then
      autoBuy.step = "use_depot"
      scheduleAutoBuy(50)
      return
    end

    autoBuy.depotTries = autoBuy.depotTries + 1
    if autoBuy.depotTries > 40 then
      stopAutoBuy()
      return
    end

    autoWalk(autoBuy.depotTarget, 500, {ignoreNonPathable = true, precision = 1})
    scheduleAutoBuy(1500)
    return
  end

  if autoBuy.step == "use_depot" then
    if useDepotAt(autoBuy.depotPos) then
      autoBuy.openTries = 0
      autoBuy.step = "open_market"
      scheduleAutoBuy(700)
      return
    end

    stopAutoBuy()
    return
  end

  if autoBuy.step == "open_market" then
    autoBuy.openTries = autoBuy.openTries + 1
    if autoBuy.openTries > 10 then
      stopAutoBuy()
      return
    end

    if useMarketFromLocker() then
      autoBuy.tasks = buildMarketBuyListFromPanel()

      if #autoBuy.tasks == 0 then
        closeMarketWindow()
        stopAutoBuy()
        return
      end

      autoBuy.idx = 1
      autoBuy.bought = {}
      autoBuy.step = "buyer_idle"
      autoResetTries()
      scheduleAutoBuy(900)
      return
    end

    scheduleAutoBuy(300)
    return
  end

  -- MAIL
  if autoBuy.step == "open_mail" then
    autoBuy.mailTries = autoBuy.mailTries + 1
    if autoBuy.mailTries > 10 then
      pcall(function() rootWidget:focus() end)
      stopAutoBuy()
      return
    end

    if useMailFromLocker() then
      autoBuy.collectTries = 0
      autoBuy.ensureLootTries = 0
      autoBuy.mailItemOrder = buildAllowedMailItemOrder()
      autoBuy.mailItemIndex = 1
      autoBuy.mailItemRetries = {}
      autoBuy.step = "collect_mail"
      scheduleAutoBuy(700)
      return
    end

    scheduleAutoBuy(300)
    return
  end

  if autoBuy.step == "collect_mail" then
    autoBuy.collectTries = autoBuy.collectTries + 1

    local targetId = autoCurrentMailItemId()
    if targetId <= 0 then
      pcall(function() rootWidget:focus() end)
      stopAutoBuy()
      return
    end

    local tries = tonumber(autoBuy.mailItemRetries[targetId] or 0) or 0
    local status, err, movedId, movedCount = collectAllowedMailItems(targetId)

    if status == "moved" then
      autoBuy.ensureLootTries = 0
      autoBuy.mailItemRetries[targetId] = 0
      scheduleAutoBuy(350)
      return
    end

    if status == "done_item" then
      autoBuy.mailItemRetries[targetId] = 0
      autoNextMailItem()
      scheduleAutoBuy(120)
      return
    end

    if status == "ensure_loot" then
      autoBuy.ensureLootTries = autoBuy.ensureLootTries + 1
      if autoBuy.ensureLootTries > 5 then
        autoNextMailItem()
        scheduleAutoBuy(300)
        return
      end
      scheduleAutoBuy(600)
      return
    end

    if status == "move_failed" then
      tries = tries + 1
      autoBuy.mailItemRetries[targetId] = tries
      if tries >= 3 then
        autoNextMailItem()
        scheduleAutoBuy(250)
        return
      end
      scheduleAutoBuy(350)
      return
    end

    if status == "error" then
      tries = tries + 1
      autoBuy.mailItemRetries[targetId] = tries
      if tries >= 3 then
        autoNextMailItem()
        scheduleAutoBuy(250)
        return
      end
      scheduleAutoBuy(400)
      return
    end

    if autoBuy.collectTries > 80 then
      pcall(function() rootWidget:focus() end)
      stopAutoBuy()
      return
    end

    scheduleAutoBuy(300)
    return
  end

  -- BUYER
  local task = autoCurrentTask()

  if autoBuy.step == "buyer_idle" then
    if not task then
      closeMarketWindow()
      autoBuy.mailTries = 0
      autoBuy.collectTries = 0
      autoBuy.step = "open_mail"
      scheduleAutoBuy(700)
      return
    end

    if autoRemaining(task) <= 0 then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.step = "buyer_search"
    scheduleAutoBuy(30)
    return
  end

  if not task then
    closeMarketWindow()
    autoBuy.mailTries = 0
    autoBuy.collectTries = 0
    autoBuy.step = "open_mail"
    scheduleAutoBuy(700)
    return
  end

  if autoRemaining(task) <= 0 then
    autoNextTask()
    scheduleAutoBuy(80)
    return
  end

  local ui = marketReady()
  if not ui then
    scheduleAutoBuy(1000)
    return
  end

  if autoBuy.step == "buyer_search" then
    if not ui.searchEdit then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    setSearchAll(ui)
    focus(ui.searchEdit)

    if not setText(ui.searchEdit, task.name) then
      autoBuy.tries.search = autoBuy.tries.search + 1
      if autoBuy.tries.search <= autoBuy.maxSearch then
        scheduleAutoBuy(autoBuy.waitSearch)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    pcall(function()
      if ui.searchEdit.onTextChange then
        ui.searchEdit.onTextChange(ui.searchEdit, task.name)
      end
    end)

    autoBuy.step = "buyer_item"
    scheduleAutoBuy(autoBuy.waitSearch)
    return
  end

  if autoBuy.step == "buyer_item" then
    local box = findItemBox(ui.itemsPanel, task.name)
    if not box then
      autoBuy.tries.item = autoBuy.tries.item + 1
      if autoBuy.tries.item <= autoBuy.maxItem then
        pcall(function()
          if ui.searchEdit and ui.searchEdit.onTextChange then
            ui.searchEdit.onTextChange(ui.searchEdit, task.name)
          end
        end)
        scheduleAutoBuy(autoBuy.waitSearch)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not selectItemBox(box) then
      autoBuy.tries.item = autoBuy.tries.item + 1
      if autoBuy.tries.item <= autoBuy.maxItem then
        scheduleAutoBuy(autoBuy.waitItem)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.step = "buyer_offer"
    autoBuy.row = nil
    autoBuy.tries.offer = 0
    scheduleAutoBuy(autoBuy.waitItem)
    return
  end

  if autoBuy.step == "buyer_offer" then
    local row = firstSellRow(ui)
    if not row then
      autoBuy.tries.offer = autoBuy.tries.offer + 1
      if autoBuy.tries.offer <= autoBuy.maxOffer then
        scheduleAutoBuy(autoBuy.waitItem)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    local piecePrice = getPiecePrice(row)
    if not piecePrice then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if piecePrice > (tonumber(task.maxPrice) or 0) then
      log(task.name .. ": primeira offer acima do maxPrice (" .. piecePrice .. " > " .. tostring(task.maxPrice) .. ")")
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.row = row
    autoBuy.step = "buyer_select"
    autoBuy.tries.select = 0
    scheduleAutoBuy(60)
    return
  end

  if autoBuy.step == "buyer_select" then
    local row = autoBuy.row or firstSellRow(ui)
    if not row then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if selectOffer(ui, row) then
      autoBuy.step = "buyer_buy"
      scheduleAutoBuy(autoBuy.waitOffer)
      return
    end

    autoBuy.tries.select = autoBuy.tries.select + 1
    if autoBuy.tries.select <= autoBuy.maxSelect then
      scheduleAutoBuy(autoBuy.waitOffer)
      return
    end
    autoNextTask()
    scheduleAutoBuy(80)
    return
  end

  if autoBuy.step == "buyer_buy" then
    if not ui.buyButton then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not safeEnabled(ui.buyButton) then
      autoBuy.tries.select = autoBuy.tries.select + 1
      if autoBuy.tries.select <= autoBuy.maxSelect + 4 then
        local row = autoBuy.row or firstSellRow(ui)
        if row then selectOffer(ui, row) end
        scheduleAutoBuy(autoBuy.waitOffer)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not click(ui.buyButton) then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoBuy.step = "buyer_popup"
    autoBuy.tries.popup = 0
    scheduleAutoBuy(autoBuy.waitBuy)
    return
  end

  if autoBuy.step == "buyer_popup" then
    local popup = findAmountPopup()
    if not popup then
      autoBuy.tries.popup = autoBuy.tries.popup + 1
      if autoBuy.tries.popup <= autoBuy.maxPopup then
        scheduleAutoBuy(autoBuy.waitPopup)
        return
      end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    local want = autoRemaining(task)
    if want <= 0 then
      if autoBuy.closePopupOnFail then popupCancel(popup) end
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    if not setPopupAmount(popup, want) then
      setPopupAmount(popup, 1)
      want = 1
    end

    local finalAmount = getPopupAmount(popup) or want or 1
    if finalAmount < 1 then finalAmount = 1 end

    if not popupConfirm(popup) then
      autoNextTask()
      scheduleAutoBuy(80)
      return
    end

    autoAddBought(task.itemId, finalAmount)

    if autoRemaining(task) <= 0 then
      autoNextTask()
      scheduleAutoBuy(80)
    else
      autoRetryItem(autoBuy.retryItemMs)
    end
    return
  end

  stopAutoBuy()
end

function startAutoBuyMarket()
  if autoBuy.running then return end

  if CaveBot and CaveBot.setOff then
    pcall(function() CaveBot.setOff() end)
  end

  autoBuy.running = true
  autoBuy.step = "go_depot"
  autoBuy.nextAt = 0
  autoBuy.tasks = {}
  autoBuy.idx = 1
  autoBuy.bought = {}
  autoBuy.depotTarget = nil
  autoBuy.depotPos = nil
  autoBuy.depotTries = 0
  autoBuy.openTries = 0
  autoBuy.mailTries = 0
  autoBuy.collectTries = 0
  autoBuy.ensureLootTries = 0
  autoBuy.mailItemOrder = {}
  autoBuy.mailItemIndex = 1
  autoBuy.mailItemRetries = {}
  autoResetTries()
  autoBuyStep()
end
