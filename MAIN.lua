local function updateTabsBorder()
  for _, test in pairs(modules.game_bot.botWindow:recursiveGetChildById("botTabs"):getChildren()) do
    for _, test3 in pairs(test:getChildren()) do
      if test3:isChecked(true) then
        test3:setText("LNS")
      end
    end
  end
end

updateTabsBorder()

MAIN_DIRECTORY = "/bot/" .. modules.game_bot.contentsPanel.config:getCurrentOption().text .. "/storage/"
STORAGE_DIRECTORY = "" .. MAIN_DIRECTORY .. "Settings.json";
-- cria o json se não existir
if not g_resources.fileExists(STORAGE_DIRECTORY) then
  g_resources.writeFileContents(STORAGE_DIRECTORY, json.encode({}, 2))
end

-- função para ler
function loadSettings()
  local status, result = pcall(function()
    return json.decode(g_resources.readFileContents(STORAGE_DIRECTORY))
  end)
  if status then
    return result
  end
  return {}
end

-- função para salvar
function saveSettings(data)
  local status, result = pcall(function()
    return json.encode(data, 2)
  end)
  if status then
    g_resources.writeFileContents(STORAGE_DIRECTORY, result)
  end
end

function normalizeContainerItems(items)
  local r = {}
  if type(items) ~= "table" then return r end

  for _, v in pairs(items) do
    local id = nil

    if type(v) == "table" then
      id = (v.getId and v:getId()) or v.id
    else
      id = v
    end

    id = tonumber(id)
    if id and id > 0 then
      table.insert(r, id)
    end
  end

  return r
end

settings = loadSettings()

settings.combo = settings.combo or {}
settings.combo.safeIdsAndares = normalizeContainerItems(settings.combo.safeIdsAndares or {435, 1948, 386, 1949})

settings.food = settings.food or {}
settings.food.items = normalizeContainerItems(settings.food.items or {})

settings.utility = settings.utility or {}
settings.utility.proximaBpID = normalizeContainerItems(settings.utility.proximaBpID or {2854})
settings.utility.transformarCoin = normalizeContainerItems(settings.utility.transformarCoin or {3031, 3035, 3043})
settings.utility.doorIds = normalizeContainerItems(settings.utility.doorIds or {5129, 5102, 5111, 5120, 11246})

settings.follow = settings.follow or {}
settings.follow.ropeID = tostring(settings.follow.ropeID or "3003")
settings.follow.ropeIDS = normalizeContainerItems(settings.follow.ropeIDS or {386})
settings.follow.useIDS = normalizeContainerItems(settings.follow.useIDS or {435})
settings.follow.stairIDS = normalizeContainerItems(settings.follow.stairIDS or {484, 17394, 1977, 414})
settings.follow.buracoIDS = normalizeContainerItems(settings.follow.buracoIDS or {1959})

settings.pvp = settings.pvp or {}
settings.pvp.destroyField = settings.pvp.destroyField or {}
settings.pvp.destroyField.fieldItems = normalizeContainerItems(settings.pvp.destroyField.fieldItems or {2118, 2122, 105, 2119})


saveSettings(settings)

sepp = UI.Separator():setMarginTop(-0)

local panelName = "codPanel"
local codPanel = setupUI([[
Panel
  id: codPanel
  height: 75
  margin-top: 0

  Label
    id: textLabel2
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    margin-top: 0
    height: 55
    text-align: center
    font: sono_bold_border_14
    text-auto-resize: true

  Button
    id: buttonDiscord
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    text: Discord
    color: orange
    font: ava
    image-source: /images/ui/button_rounded
    image-color: #363636
    margin-top: 4
    opacity: 1.00
    text-offset: 0 5
    color: white
    $hover:
      opacity: 0.95
      color: green

  Label
    id: iconDiscord
    anchors.left: prev.left
    anchors.top: prev.top
    margin-top: 1
    size: 20 20
    image-source: /images/ui/discord

  Button
    id: buttonYoutube
    anchors.left: buttonDiscord.left
    anchors.right: buttonDiscord.right
    anchors.top: prev.bottom
    text: YouTube
    font: ava
    text-offset: 0 5
    image-source: /images/ui/button_rounded
    image-color: #363636
    margin-top: 4
    text-offset: 0 5
    opacity: 1.00
    color: red
    $hover:
      opacity: 0.95
      color: white

  Panel
    id: iconYoutube
    anchors.left: prev.left
    anchors.verticalCenter: prev.verticalCenter
    margin-top: -1
    margin-left: 2
    size: 20 13

  HorizontalSeparator
    id: sep2
    anchors.left: buttonYoutube.left
    anchors.right: buttonYoutube.right
    anchors.top: buttonYoutube.bottom
    margin-top: 5
]])
function setRainbowColor(time)
    local r = math.floor(127 * math.sin(time) + 128)
    local g = math.floor(127 * math.sin(time + 2 * math.pi / 3) + 128)
    local b = math.floor(127 * math.sin(time + 4 * math.pi / 3) + 128)
    return string.format("#%02X%02X%02X", r, g, b)
end
macro(10, function()
    local text = 'LNS CUSTOM'
    local time = os.clock() * 4
    local coloredText = {}


    for i = 1, #text do
        local char = text:sub(i, i)
        local color = setRainbowColor(time + i * 0.1) 
        table.insert(coloredText, char) 
        table.insert(coloredText, color) 
    end


    if codPanel and codPanel.textLabel2 then
        codPanel.textLabel2:setColoredText(coloredText)
    end
end)

local link = "https://imgur.com/7DxD39S.png"
HTTP.downloadImage(link, function(texId)
  if texId then
    codPanel.iconYoutube:setImageSource(texId)
  else
    warn("Falha ao baixar imagem: " .. link)
  end
end)

codPanel.buttonDiscord.onClick = function()
  g_platform.openUrl("https://discord.gg/fkW6X72wsN")
end

local configName = modules.game_bot.contentsPanel.config:getCurrentOption().text

MyConfigName = modules.game_bot.contentsPanel.config:getCurrentOption().text

local function updateButtonsBot()
    modules.game_bot.contentsPanel.config:setImageColor("gray")
    modules.game_bot.contentsPanel.config:setOpacity(1.00)
    modules.game_bot.contentsPanel.config:setFont("verdana-9px")
    modules.game_bot.contentsPanel.editConfig:setImageColor("gray")
    modules.game_bot.contentsPanel.editConfig:setOpacity(1.00)
    modules.game_bot.contentsPanel.editConfig:setFont("verdana-9px")
    modules.game_bot.contentsPanel.enableButton:setImageColor("gray")
    modules.game_bot.contentsPanel.enableButton:setOpacity(1.00)
    modules.game_bot.contentsPanel.enableButton:setFont("verdana-9px")
    modules.game_bot.botWindow.closeButton:setImageColor("#363434")
    modules.game_bot.botWindow.minimizeButton:setImageColor("#363434")
    modules.game_bot.botWindow.lockButton:setImageColor("#363434")
    modules.game_bot.botWindow:setBorderWidth(1)
    modules.game_bot.botWindow:setImageColor("white")
    modules.game_bot.botWindow:setBorderColor("alpha")
end

updateButtonsBot()

UI.ContainerEx = function(callback, unique, parent, widget)
  if not widget then
    widget = UI.createWidget("BotContainer", parent)
  end
  local oldItems = {}
  local function updateItems()
    local items = widget:getItems()
    local somethingNew = (#items ~= #oldItems)
    for i, item in ipairs(items) do
      if type(oldItems[i]) ~= "table" then
        somethingNew = true
        break
      end
      if oldItems[i].id ~= item.id or oldItems[i].count ~= item.count then
        somethingNew = true
        break
      end
    end
    if somethingNew then
      oldItems = items
      callback(widget, items)
    end
    widget:setItems(items)
  end
  widget.setItems = function(self, items)
    if type(self) == "table" then
      items = self
    end
    local itemsToShow = math.max(10, #items + 2)
    if itemsToShow % 5 ~= 0 then
      itemsToShow = itemsToShow + 5 - itemsToShow % 5
    end
    widget.items:destroyChildren()
    for i = 0, itemsToShow do
      local itemWidget = g_ui.createWidget("BotItem", widget.items)
      if i == 0 then
        itemWidget:setBorderWidth(1)
        itemWidget:setBorderColor("#d7c08a")
      end
      if type(items[i]) == 'number' then
        items[i] = {id = items[i], count = 1}
      end
      if type(items[i]) == 'table' then
        itemWidget:setItem(Item.create(items[i].id, items[i].count))
      end
    end
    oldItems = items
    for _, child in ipairs(widget.items:getChildren()) do
      child.onItemChange = updateItems
    end
  end

  widget.getItems = function()
    local items = {}
    local duplicates = {}
    for _, child in ipairs(widget.items:getChildren()) do
      if child:getItemId() >= 100 then
        if not duplicates[child:getItemId()] or not unique then
          table.insert(items, {
            id = child:getItemId(),
            count = child:getItemCountOrSubType()
          })
          duplicates[child:getItemId()] = true
        end
      end
    end
    return items
  end
  widget:setItems({})
  return widget
end