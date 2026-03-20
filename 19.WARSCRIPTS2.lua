-- =========================
-- STORAGE
-- =========================
UI.Separator()

local switchAntiPush = "AntiPushButton"
storage[switchAntiPush] = storage[switchAntiPush] or {
  enabled = false,
  items = {3031, 3035}
}

local antiCfg = storage[switchAntiPush]

-- garante que venha com os padrões se estiver vazio
if type(antiCfg.items) ~= "table" or #antiCfg.items == 0 then
  antiCfg.items = {3031, 3035}
end


AntiPushButton = setupUI([[
Panel
  height: 18

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 42
    height: 18
    text-align: center
    text: ANTI-PUSH
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
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    height: 18
    text: SHOW
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green
]])

AntiPushButton.title:setOn(antiCfg.enabled)

AntiPushButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  antiCfg.enabled = newState
end

-- =========================
-- PAINEL DE ITENS
-- =========================
antiPushInterface = setupUI([[
Panel
  height: 60
    
  Label
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 5
    text-align: center
    text: ITENS PARA DROPAR
    font: verdana-9px
    color: gray

  BotContainer
    id: antiPushItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 38
]])

antiPushInterface:hide()

-- =========================
-- APLICA ContainerEx
-- =========================
UI.ContainerEx(function(widget, items)
  antiCfg.items = items
end, true, nil, antiPushInterface.antiPushItems)

antiPushInterface.antiPushItems:setItems(antiCfg.items)

-- =========================
-- SHOW / HIDE
-- =========================
AntiPushButton.edit.onClick = function()
  if antiPushInterface:isVisible() then
    antiPushInterface:hide()
    AntiPushButton.edit:setText("SHOW")
  else
    antiPushInterface:show()
    AntiPushButton.edit:setText("HIDE")
  end
end

local function getDropIdsFromContainer(list)
  local t = {}
  for _, entry in pairs(list or {}) do
    local id = nil
    if type(entry) == "table" then
      id = tonumber(entry.id)
    else
      id = tonumber(entry)
    end
    if id and id > 0 then
      table.insert(t, id)
    end
  end
  return t
end

local function AntiPush()
  if antiCfg.enabled ~= true then return end

  local dropItems = getDropIdsFromContainer(antiCfg.items)
  if #dropItems == 0 then return end

  local tile = g_map.getTile(pos())
  if not tile then return end

  local thing = tile:getTopThing()
  if not thing or not thing.getId then return end
  local topId = thing:getId()

  for _, itemId in pairs(dropItems) do
    -- Mantém a lógica da tua base: só tenta dropar se o topo não for o mesmo item
    if itemId ~= topId then
      local dropItem = findItem(itemId)
      if dropItem then
        local c = (dropItem.getCount and dropItem:getCount()) or 1
        g_game.move(dropItem, pos(), (c == 1) and 1 or 2)
        return
      end
    end
  end
end

macro(500, function()
  if antiCfg.enabled ~= true then return end
  AntiPush()
end)


---========
---PICKUP
---========
local switchPickUp = "PickUpButton"

storage = storage or {}
storage[switchPickUp] = storage[switchPickUp] or {
  enabled = false,
  items = {3031, 3035},
  containerId = 2854,
  containerCount = 1
}

local pickCfg = storage[switchPickUp]

if type(pickCfg.items) ~= "table" or #pickCfg.items == 0 then
  pickCfg.items = {3031, 3035}
end

pickCfg.containerId = tonumber(pickCfg.containerId or 0) or 0
if pickCfg.containerId <= 0 then
  pickCfg.containerId = 2854
end

pickCfg.containerCount = tonumber(pickCfg.containerCount or 0) or 0
if pickCfg.containerCount <= 0 then
  pickCfg.containerCount = 1
end

-- compat: teu script usa "config"
local config = {
  enabled = pickCfg.enabled,
  pickUpItems = pickCfg.items,
  containerPickUpItems = {}
}

local function syncConfig()
  config.enabled = (pickCfg.enabled == true)
  config.pickUpItems = pickCfg.items or {}

  local cid = tonumber(pickCfg.containerId or 0) or 0
  if cid > 0 then
    config.containerPickUpItems = { { id = cid } }
  else
    config.containerPickUpItems = {}
  end
end

syncConfig()

-- =========================
-- UI: BUTTON
-- =========================
PickUpButton = setupUI([[
Panel
  height: 18

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    margin-right: 42
    text-align: center
    height: 18
    text: PICK UP
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
    id: edit
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    height: 18
    text: SHOW
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green
]])

PickUpButton.title:setOn(pickCfg.enabled)

PickUpButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  pickCfg.enabled = newState
  syncConfig()
end

-- =========================
-- UI: INTERFACE
-- =========================
pickUpInterface = setupUI([[
Panel
  height: 130

  Label
    id: labelcontainer
    anchors.top: parent.top
    anchors.left: parent.left
    margin-top: 10
    margin-left: 5
    text: ID CONTAINER:
    font: verdana-9px
    color: gray

  BotItem
    id: idContainerPick
    anchors.right: parent.right
    anchors.verticalCenter: prev.verticalCenter
    image-source: /images/ui/item-blessed
    margin-top: 5

  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: -2
    text: ITENS P/ COLETAR:
    font: verdana-9px
    color: gray

  BotContainer
    id: pickUpItems
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 78
]])

pickUpInterface:hide()

local function normalizeContainerItems(items)
  local r = {}
  if type(items) ~= "table" then return r end

  for _, v in pairs(items) do
    local id = nil

    if type(v) == "table" then
      id = tonumber(v.id)
      if not id and v.getId then
        local ok, got = pcall(function() return v:getId() end)
        if ok then id = tonumber(got) end
      end
    else
      id = tonumber(v)
    end

    if id and id > 0 then
      table.insert(r, id)
    end
  end

  return r
end

do
  local wid = pickUpInterface.idContainerPick
  local id = tonumber(pickCfg.containerId or 0) or 0

  if type(wid.setItemId) == "function" then
    wid:setItemId(id)
  elseif type(wid.setItem) == "function" then
    wid:setItem(id)
  end

  if type(wid.setItemCount) == "function" then
    wid:setItemCount(tonumber(pickCfg.containerCount or 1) or 1)
  end

  wid.onItemChange = function(widget)
    local item = widget:getItem()
    if item then
      pickCfg.containerId = item:getId()
      pickCfg.containerCount = item:getCount() or 1
    else
      pickCfg.containerId = 2854
      pickCfg.containerCount = 1
    end
    syncConfig()
  end
end

UI.ContainerEx(function(widget, items)
  pickCfg.items = normalizeContainerItems(items)
  if #pickCfg.items == 0 then
    pickCfg.items = {3031, 3035}
  end
  syncConfig()
end, true, nil, pickUpInterface.pickUpItems)

pickUpInterface.pickUpItems:setItems(pickCfg.items)

PickUpButton.edit.onClick = function()
  if pickUpInterface:isVisible() then
    pickUpInterface:hide()
    PickUpButton.edit:setText("SHOW")
  else
    pickUpInterface:show()
    PickUpButton.edit:setText("HIDE")
  end
end

local function properTable(t)
  local r = {}
  for _, entry in pairs(t or {}) do
    local id = tonumber(entry) or tonumber(entry and entry.id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end
  return r
end

local CheckPOS = 1

local pickUpMacro = macro(200, function()
  if not config.enabled then return end

  local pickUpIds = properTable(config.pickUpItems)
  local containerIds = properTable(config.containerPickUpItems)

  if #pickUpIds == 0 or #containerIds == 0 then return end

  for x = -CheckPOS, CheckPOS do
    for y = -CheckPOS, CheckPOS do
      local tile = g_map.getTile({x = posx() + x, y = posy() + y, z = posz()})
      if tile then
        for _, item in pairs(tile:getThings()) do
          if table.find(pickUpIds, item:getId()) then
            for _, container in pairs(getContainers()) do
              local cItem = container:getContainerItem()
              if cItem and table.find(containerIds, cItem:getId()) then
                g_game.move(item, container:getSlotPosition(container:getItemsCount()), item:getCount())
                return
              end
            end
          end
        end
      end
    end
  end
end)

--===============
--PUSH TUDO PARA BAIXO
--===============
local switchPushAll = "pushAllButton"
if not storage[switchPushAll] then storage[switchPushAll] = { enabled = false } end

pushAllButton = setupUI([[
Panel
  height: 18
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: PUXAR ITENS PROXIMOS
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
]])
pushAllButton:setId(switchPushAll)
pushAllButton.title:setOn(storage[switchPushAll].enabled)

pushAllButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchPushAll].enabled = newState
end

macro(100, function()
  if not storage[switchPushAll].enabled then return; end
  for _, tile in pairs(g_map.getTiles(posz())) do
    local tilePos = tile:getPosition()
    if distanceFromPlayer(tilePos) == 1 then
      local top = tile:getTopUseThing()
      if top and not top:isNotMoveable() then
        if distanceFromPlayer(tilePos) > 1 then return end
        g_game.move(top, pos(), top:getCount())
        return
      end
    end
  end
end)

--=================
--DROP FLOR
--=================

local switchDropFlor = "dropFlorButton"
if not storage[switchDropFlor] then storage[switchDropFlor] = { enabled = false } end

dropFlorButton = setupUI([[
Panel
  height: 18
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: DROP FLOWERS
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
dropFlorButton:setId(switchDropFlor)
dropFlorButton.title:setOn(storage[switchDropFlor].enabled)

dropFlorButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchDropFlor].enabled = newState
end

-- =========================================
-- UI WINDOW
-- =========================================
dropFlorInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 250 275
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
    text: LNS Custom | Drop Flowers
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
    id: cardFlower
    anchors.top: closePanel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    height: 110
    background-color: #1b1b1b
    opacity: 0.95
    margin-top: 12
    margin-left: 10
    margin-right: 10
    border: 1 #3b2a10

  Label
    id: labelcontainer
    anchors.top: prev.top
    anchors.left: prev.left
    margin-top: 16
    margin-left: 10
    text: ID FLOWER:
    font: verdana-9px
    color: #d7c08a

  BotItem
    id: idFlower
    anchors.right: cardFlower.right
    anchors.verticalCenter: prev.verticalCenter
    image-source: /images/ui/item-blessed
    margin-top: 2
    margin-right: 10

  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: 11
    text: ATALHO DROP BACK:
    width: 110
    font: verdana-9px
    color: #d7c08a

  TextEdit
    id: keyDropBACK
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: cardFlower.right
    margin-top: 0
    margin-right: 10
    placeholder: KEY HERE!
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #2f2f2f
    color: yellow
    
  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: 15
    text: ATALHO DROP ALL:
    width: 110
    font: verdana-9px
    color: #d7c08a

  TextEdit
    id: keyDropALL
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: cardFlower.right
    margin-top: 0
    margin-right: 10
    placeholder: KEY HERE!
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #2f2f2f
    color: yellow

  Panel
    id: cardCollect
    anchors.top: cardFlower.bottom
    anchors.left: cardFlower.left
    anchors.right: cardFlower.right
    height: 110
    background-color: #1b1b1b
    opacity: 0.95
    margin-top: 10
    border: 1 #3b2a10

  Label
    id: labelCollect
    anchors.top: prev.top
    anchors.left: prev.left
    margin-top: 16
    margin-left: 10
    text: ID CONTAINER COLLECT:
    font: verdana-9px
    color: #d7c08a

  BotItem
    id: idContainerCollect
    anchors.right: cardCollect.right
    anchors.verticalCenter: prev.verticalCenter
    image-source: /images/ui/item-blessed
    margin-top: 2
    margin-right: 10

  Label
    anchors.top: prev.bottom
    anchors.left: labelcontainer.left
    margin-top: 11
    text: ATALHO COLLECT:
    width: 110
    font: verdana-9px
    color: #d7c08a

  TextEdit
    id: keyCollectFlower
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: cardCollect.right
    margin-top: 0
    margin-right: 10
    placeholder: KEY HERE!
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #2f2f2f
    color: yellow

  BotSwitch
    id: showIconsFlor
    anchors.top: prev.bottom
    anchors.left: labelCollect.left
    size: 25 25
    image-source: /images/ui/button_rounded
    margin-top: 7
    image-color: #3a1010
    $on:
      color: #ffd37a
      image-color: green
      opacity: 1.00
    $!on:
      color: #b9b9b9
      image-color: #2a2a2a
      opacity: 0.95

  Label
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 10
    text: ICONS DROP/COLLECT FLOWER
    width: 110
    text-auto-resize: true
    font: verdana-9px
    color: #d7c08a
]], g_ui.getRootWidget())
dropFlorInterface:hide()

dropFlorButton.settings.onClick = function()
  dropFlorInterface:setVisible(not dropFlorInterface:isVisible())
end

function buttonsFlowerPcMobile()
  if modules._G.g_app.isMobile() then
    dropFlorButton.settings:show()
    dropFlorButton.title:setMarginRight(55)
  else
    dropFlorButton.settings:hide()
    dropFlorButton.title:setMarginRight(0)
  end
end
buttonsFlowerPcMobile()

dropFlorButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not dropFlorInterface:isVisible() then
      dropFlorInterface:show()
      dropFlorInterface:raise();
      dropFlorInterface:focus();
    else
      dropFlorInterface:hide()
    end
  end
end

dropFlorInterface.closePanel.onClick = function()
  dropFlorInterface:hide()
end

-- =========================================
-- STORAGE + BINDS (IGUAL SWAP)
-- =========================================
local panelStoreName = "panelDropFlorStorage"

if not storage[panelStoreName] then
  storage[panelStoreName] = {
    flowerId = 2981,            -- default pedido
    containerCollectId = 2854,  -- default bp
    keyDropBACK = "",
    keyDropALL = "F1",
    keyCollectFlower = "F2",
    showIconsFlor = false
  }
end

local cfg = storage[panelStoreName]

local function sched(ms, fn)
  if type(scheduleEvent) == "function" then
    return scheduleEvent(fn, ms)
  end
  if type(schedule) == "function" then
    return schedule(ms, fn)
  end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
    return g_dispatcher:scheduleEvent(fn, ms)
  end

  -- ✅ fallback seguro: NÃO chama fn() direto (evita stack overflow)
  -- tenta rodar no próximo frame (se existir)
  if g_dispatcher and type(g_dispatcher.addEvent) == "function" then
    return g_dispatcher:addEvent(fn)
  end

  -- último caso: não agenda, aborta silencioso
  return nil
end
local function safeSetItem(widget, id)
  if not widget then return end
  id = tonumber(id) or 0
  if id > 0 and widget.setItemId then widget:setItemId(id) end
  if id > 0 and (not widget.setItemId) and widget.setItem then widget:setItem(id) end
end

local function safeGetItem(widget)
  if not widget then return 0 end
  if widget.getItemId then return tonumber(widget:getItemId()) or 0 end
  if widget.getItem then
    local it = widget:getItem()
    if it and it.getId then return tonumber(it:getId()) or 0 end
  end
  return 0
end

local function bindBotItem(widget, store, key, defaultId)
  if not widget then return end
  local v = tonumber(store[key]) or 0
  if (v <= 0) and (tonumber(defaultId) or 0) > 0 then
    v = tonumber(defaultId)
    store[key] = v
  end
  safeSetItem(widget, v)
  widget.onItemChange = function(w)
    -- ✅ igual SWAP: só salva o ID do widget (sem setar de volta aqui)
    store[key] = safeGetItem(w)
  end
end

local function bindBotSwitch(widget, store, key, defaultBool)
  if not widget then return end
  local on = store[key]
  if on == nil then on = (defaultBool == true) end
  store[key] = (on == true)
  if widget.setOn then widget:setOn(store[key]) end
  widget.onClick = function(w)
    local newState = not w:isOn()
    w:setOn(newState)
    store[key] = (newState == true)
  end
end

local function bindTextEdit(widget, store, key, defaultText)
  if not widget then return end
  local v = store[key]
  if v == nil then v = tostring(defaultText or "") end
  store[key] = tostring(v or "")
  if widget.setText then widget:setText(store[key]) end
  widget.onTextChange = function(_, text)
    store[key] = tostring(text or "")
  end
end

bindBotItem(dropFlorInterface.idFlower, cfg, "flowerId", 2981)
bindBotItem(dropFlorInterface.idContainerCollect, cfg, "containerCollectId", 2854)

bindTextEdit(dropFlorInterface.keyDropBACK, cfg, "keyDropBACK", "")
bindTextEdit(dropFlorInterface.keyDropALL, cfg, "keyDropALL", "F1")
bindTextEdit(dropFlorInterface.keyCollectFlower, cfg, "keyCollectFlower", "F2")

bindBotSwitch(dropFlorInterface.showIconsFlor, cfg, "showIconsFlor", false)

-- =========================================
-- DROP / COLLECT (LÓGICA DA TUA MACRO BOA)
-- =========================================
local function tableContains(t, value)
  for i = 1, #t do
    if t[i] == value then return true end
  end
  return false
end

-- ✅ AJUSTE PEDIDO: agora SEMPRE segue o ID do BotItem (cfg.flowerId)
local function normalizeFlowerIds()
  local ids = {}
  local id = tonumber(cfg.flowerId or 0) or 0
  if id > 0 then table.insert(ids, id) end
  return ids
end

local function findItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end
  for _, c in pairs(g_game.getContainers() or {}) do
    for _, it in ipairs(c:getItems() or {}) do
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end
  return nil
end

local function findOpenContainerById(containerItemId)
  containerItemId = tonumber(containerItemId) or 0
  if containerItemId <= 0 then return nil end

  for _, c in pairs(g_game.getContainers() or {}) do
    local bpItem = c:getContainerItem()
    if bpItem and bpItem.getId and tonumber(bpItem:getId()) == containerItemId then
      return c
    end
  end
  return nil
end

function dropSequentially()
  local myPos = pos()
  if not myPos then return end

  local dirs = {
    {-1, 1}, {0, 1}, {1, 1},
    {-1, 0},         {1, 0},
    {-1, -1}, {0, -1}, {1, -1}
  }

  local tiles = {}
  for i = 1, #dirs do
    local t = g_map.getTile({x=myPos.x+dirs[i][1], y=myPos.y+dirs[i][2], z=myPos.z})
    if t then table.insert(tiles, t) end
  end

  local selfTile = g_map.getTile(myPos)
  if selfTile then table.insert(tiles, selfTile) end

  local flowerIds = normalizeFlowerIds()
  if #flowerIds == 0 then return end

  for _, tile in ipairs(tiles) do
    local tilePos = tile:getPosition()
    if tilePos then
      local isSelf = (tilePos.x == myPos.x and tilePos.y == myPos.y and tilePos.z == myPos.z)
      local topThing = tile:getTopThing()
      local canPlace = isSelf or (not topThing or (topThing:isItem() and not tableContains(flowerIds, topThing:getId())))

      if canPlace then
        for _, plant in ipairs(flowerIds) do
          local dropItem = findItemById(plant)
          if dropItem then
            g_game.move(dropItem, tilePos, 1)
          end
        end
      end
    end
  end
end

local function collectFlowers()
  if not pos() then return end

  -- flor = 1 id do BotItem
  local flowerId = tonumber(cfg.flowerId or 0) or 0
  if flowerId <= 0 then return end

  -- container alvo = BotItem
  local containerId = tonumber(cfg.containerCollectId or 0) or 0
  if containerId <= 0 then return end

  -- acha o container aberto que bate com o ID escolhido
  local dest = nil
  for _, c in pairs(g_game.getContainers() or {}) do
    local bpItem = c:getContainerItem()
    if bpItem and bpItem.getId and tonumber(bpItem:getId()) == containerId then
      dest = c
      break
    end
  end
  if not dest then return end

  -- destino fixo: slot 0 (igual teu exemplo que funciona)
  local slotPos = dest:getSlotPosition(0)
  if not slotPos then return end

  for dx = -1, 1 do
    for dy = -1, 1 do
      local tile = g_map.getTile({x = posx() + dx, y = posy() + dy, z = posz()})
      if tile then
        for _, it in ipairs(tile:getItems() or {}) do
          if it and it.isItem and it:isItem() and it.getId and tonumber(it:getId()) == flowerId then
            g_game.move(it, slotPos, it:getCount())
          end
        end
      end
    end
  end
end

-- =========================================
-- HOTKEYS
-- =========================================
local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end
local function normKey(s)
  return trim(s):lower()
end

macro(250, function()
  if not pos() then return; end
  if modules.corelib.g_keyboard.isKeyPressed(cfg.keyDropALL) then
    dropSequentially()
  end
end)

onKeyPress(function(keys)
  if not storage[switchDropFlor] or storage[switchDropFlor].enabled ~= true then return end

  local k = normKey(keys)
  if k == "" then return end
  local kCollect = normKey(cfg.keyCollectFlower)

  if kCollect ~= "" and k == kCollect then
    collectFlowers()
    return true
  end
end)

local __dropBackRunning = false
local __dropBackTickUntil = 0

local function nowMs()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function getMyDir()
  -- 0=N,1=E,2=S,3=W (padrão OTC)
  if g_game and g_game.getLocalPlayer then
    local p = g_game.getLocalPlayer()
    if p and p.getDirection then
      local d = p:getDirection()
      if d ~= nil then return tonumber(d) end
    end
  end
  if player and player.getDirection then
    local d = player:getDirection()
    if d ~= nil then return tonumber(d) end
  end
  return nil
end

local function getBackOffsets(dir)
  -- y+1 = sul, y-1 = norte (Tibia)
  -- atrás + diagonais atrás
  if dir == 0 then -- olhando NORTH -> atrás é SOUTH
    return { {0, 1}, {-1, 1}, {1, 1} }
  elseif dir == 2 then -- olhando SOUTH -> atrás é NORTH
    return { {0, -1}, {1, -1}, {-1, -1} }
  elseif dir == 1 then -- olhando EAST -> atrás é WEST
    return { {-1, 0}, {-1, -1}, {-1, 1} }
  elseif dir == 3 then -- olhando WEST -> atrás é EAST
    return { {1, 0}, {1, 1}, {1, -1} }
  end
  -- fallback: atrás south
  return { {0, 1}, {-1, 1}, {1, 1} }
end

local function canPlaceFlowerOnTile(tile, flowerIds, myPos)
  if not tile then return false end
  local tilePos = tile:getPosition()
  if not tilePos then return false end

  local isSelf = (tilePos.x == myPos.x and tilePos.y == myPos.y and tilePos.z == myPos.z)
  local topThing = tile:getTopThing()

  -- mesma regra do teu dropSequentially bom
  return isSelf or (not topThing or (topThing:isItem() and not tableContains(flowerIds, topThing:getId())))
end

local function startDropBack()
  if __dropBackRunning then return end
  local myPos = pos()
  if not myPos then return end

  local flowerIds = normalizeFlowerIds()
  if #flowerIds == 0 then return end

  local dir = getMyDir()
  if dir == nil then return end

  local order = getBackOffsets(dir)

  -- monta tiles na ordem correta: atrás -> diag1 -> diag2
  local tiles = {}
  for i = 1, #order do
    local off = order[i]
    local t = g_map.getTile({ x = myPos.x + off[1], y = myPos.y + off[2], z = myPos.z })
    if t then table.insert(tiles, t) end
  end
  if #tiles == 0 then return end

  __dropBackRunning = true
  local idx = 1

  local function step()
    if not storage[switchDropFlor] or storage[switchDropFlor].enabled ~= true then
      __dropBackRunning = false
      return
    end

    -- throttle pra não spammar move
    local t = nowMs()
    if __dropBackTickUntil > t then
      sched(30, step)
      return
    end
    __dropBackTickUntil = t + 90

    if idx > #tiles then
      __dropBackRunning = false
      return
    end

    local tile = tiles[idx]
    idx = idx + 1

    if tile and canPlaceFlowerOnTile(tile, flowerIds, myPos) then
      local flowerId = flowerIds[1]
      local it = findItemById(flowerId)
      if it then
        g_game.move(it, tile:getPosition(), 1)
      end
    end

    sched(120, step)
  end

  step()
end

macro(10, function()
  if not pos() then return end
  if not storage[switchDropFlor] or storage[switchDropFlor].enabled ~= true then return end
  if __dropBackRunning then return end

  if cfg.keyDropBACK ~= "" and modules.corelib.g_keyboard.isKeyPressed(cfg.keyDropBACK) then
    startDropBack()
  end
end)

UI.Separator()

storage = storage or {}

local exivaTargetSwitch = "exivaTargetSwitch"
local xExivaSwitch      = "xExivaSwitch"

storage[exivaTargetSwitch] = storage[exivaTargetSwitch] or { enabled = false }
storage[xExivaSwitch]      = storage[xExivaSwitch] or { enabled = false }

storage.Sense       = storage.Sense or false        -- manual (xNOME)
storage.SenseTarget = storage.SenseTarget or false  -- automático (Exiva Target)

exivaInterface = setupUI([[
Panel
  height: 35

  BotSwitch
    id: exivaTarget
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: EXIVA TARGET
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

  BotSwitch
    id: xExiva
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: xEXIVA
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
]])
exivaInterface:show()

exivaInterface.exivaTarget:setOn(storage[exivaTargetSwitch].enabled)
exivaInterface.exivaTarget.onClick = function(widget)
  storage[exivaTargetSwitch].enabled = not storage[exivaTargetSwitch].enabled
  widget:setOn(storage[exivaTargetSwitch].enabled)
end

exivaInterface.xExiva:setOn(storage[xExivaSwitch].enabled)
exivaInterface.xExiva.onClick = function(widget)
  storage[xExivaSwitch].enabled = not storage[xExivaSwitch].enabled
  widget:setOn(storage[xExivaSwitch].enabled)
end

-- =========================
-- EXIVA TARGET
-- =========================
macro(200, function()
  if not storage[exivaTargetSwitch].enabled then return end

  local target = g_game.getAttackingCreature()
  if target and target:isPlayer() then
    storage.SenseTarget = target:getName()
  end

  if not storage.SenseTarget or storage.SenseTarget == "" then return end

  local creature = getPlayerByName(storage.SenseTarget)
  if not (creature and creature:getPosition().z == player:getPosition().z and getDistanceBetween(pos(), creature:getPosition()) <= 6) then
    say('exiva "' .. storage.SenseTarget)
    delay(2300)
  end
end)

macro(200, function()
  if not storage[xExivaSwitch].enabled then return end
  if not storage.Sense or storage.Sense == "" then return end

  local creature = getPlayerByName(storage.Sense)
  if not (creature and creature:getPosition().z == player:getPosition().z and getDistanceBetween(pos(), creature:getPosition()) <= 6) then
    say('exiva "' .. storage.Sense)
    delay(2300)
  end
end)

-- =========================
-- xNOME
-- =========================
onTalk(function(name, level, mode, text, channelId, pos)
  if name ~= player:getName() then return end
  if type(text) ~= "string" or text:len() < 1 then return end

  if text:sub(1, 1):lower() == "x" then
    local checkMsg = text:sub(2):trim()

    if checkMsg == "0" then
      storage.Sense = false
    elseif checkMsg ~= "" then
      storage.Sense = checkMsg
    end
  end
end)

if g_keyboard and g_keyboard.bindKeyDown then
  g_keyboard.bindKeyDown("Escape", function()
    storage.SenseTarget = false
  end)
end