setDefaultTab("Tools")

local scriptsPanelName = "Scriptss"

MAIN_DIRECTORY = "/bot/" .. modules.game_bot.contentsPanel.config:getCurrentOption().text .. "/storage/"
STORAGE_DIRECTORY = "" .. MAIN_DIRECTORY .. "Settings.json";

if not g_resources.directoryExists(MAIN_DIRECTORY) then
  g_resources.makeDir(MAIN_DIRECTORY)
end

if not g_resources.fileExists(STORAGE_DIRECTORY) then
  g_resources.writeFileContents(STORAGE_DIRECTORY, json.encode({}, 2))
end

function loadSettings()
  local status, result = pcall(function()
    return json.decode(g_resources.readFileContents(STORAGE_DIRECTORY))
  end)
  if status and type(result) == "table" then
    return result
  end
  return {}
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

function saveSettings(data)
  if type(data) ~= "table" then return end

  data.combo = data.combo or {}
  data.food = data.food or {}
  data.utility = data.utility or {}
  data.follow = data.follow or {}

  data.combo.safeIdsAndares = normalizeContainerItems(data.combo.safeIdsAndares or {})
  data.food.items = normalizeContainerItems(data.food.items or {})
  data.utility.proximaBpID = normalizeContainerItems(data.utility.proximaBpID or {})
  data.utility.transformarCoin = normalizeContainerItems(data.utility.transformarCoin or {})
  data.utility.doorIds = normalizeContainerItems(data.utility.doorIds or {})
  data.follow.ropeIDS = normalizeContainerItems(data.follow.ropeIDS or {})
  data.follow.useIDS = normalizeContainerItems(data.follow.useIDS or {})
  data.follow.stairIDS = normalizeContainerItems(data.follow.stairIDS or {})
  data.follow.buracoIDS = normalizeContainerItems(data.follow.buracoIDS or {})
  data.follow.ropeID = tostring(data.follow.ropeID or "3003")

  local status, result = pcall(function()
    return json.encode(data, 2)
  end)

  if status then
    g_resources.writeFileContents(STORAGE_DIRECTORY, result)
  end
end

settings = loadSettings()
settings.follow = settings.follow or {}
settings.follow.ropeID = tostring(settings.follow.ropeID or "3003")
settings.follow.ropeIDS = normalizeContainerItems(settings.follow.ropeIDS or {386})
settings.follow.useIDS = normalizeContainerItems(settings.follow.useIDS or {435})
settings.follow.stairIDS = normalizeContainerItems(settings.follow.stairIDS or {484, 17394, 1977, 414})
settings.follow.buracoIDS = normalizeContainerItems(settings.follow.buracoIDS or {1959})
saveSettings(settings)

if not storage[scriptsPanelName] then
    storage[scriptsPanelName] = {
        texts = {
            navAttack = "",
            navLeader = "",
            UELeader = "",
            UESpell = "",
            ropeID = tostring(settings.follow.ropeID or "3003")
        },
        switches = {
            attackCheck = false,
            followCheck = false,
            useUEcheck = false,
            souLider = false,
            abrirChatParty = false,
        }
    }
end

storage[scriptsPanelName].texts = storage[scriptsPanelName].texts or {}
storage[scriptsPanelName].switches = storage[scriptsPanelName].switches or {}

storage[scriptsPanelName].texts.ropeID = tostring(settings.follow.ropeID or "3003")
storage[scriptsPanelName].ropeIDS = settings.follow.ropeIDS or {386}
storage[scriptsPanelName].useIDS = settings.follow.useIDS or {435}
storage[scriptsPanelName].stairIDS = settings.follow.stairIDS or {484, 17394, 1977, 414}
storage[scriptsPanelName].buracoIDS = settings.follow.buracoIDS or {1959}
storage[scriptsPanelName].doorsIDS = storage[scriptsPanelName].doorsIDS or {}

if storage[scriptsPanelName].checkboxes then
  for k, v in pairs(storage[scriptsPanelName].checkboxes) do
    if storage[scriptsPanelName].switches[k] == nil then
      storage[scriptsPanelName].switches[k] = v and true or false
    end
  end
  storage[scriptsPanelName].checkboxes = nil
end

if storage[scriptsPanelName].switches.souLider == nil then storage[scriptsPanelName].switches.souLider = false end
if storage[scriptsPanelName].switches.abrirChatParty == nil then storage[scriptsPanelName].switches.abrirChatParty = false end

local switchFollow = "followButton"

if not storage[switchFollow] then
    storage[switchFollow] = { enabled = false }
end

followButton = setupUI([[
Panel
  height: 17
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    text-align: center
    width: 110
    text: Follow
    font: verdana-9px
    color: white
    image-source: /images/ui/button_rounded
    $on:
      color: green
      image-color: green
    $!on:
      image-color: gray
      color: white

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 0
    height: 17
    text: Config
    font: verdana-9px
    image-color: #363636
    image-source: /images/ui/button_rounded
    opacity: 1.00
    color: white
    $hover:
      opacity: 0.95
      color: green
]])
followButton:setId(switchFollow)
followButton.title:setOn(storage[switchFollow].enabled)

followButton.title.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    storage[switchFollow].enabled = newState
end

local navPanel = setupUI([[  
UIWindow
  id: navPanel
  size: 370 420
  !text: tr('')
  text-align: top-left
  font: verdana-11px-rounded
  border: 1 black
  anchors.centerIn: parent
  color: white

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
    !text: tr('LNS Custom | Follow Control')
    font: verdana-11px-rounded
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f
  
  Panel
    id: iconPanel
    anchors.top: topPanel.top
    anchors.left: parent.left
    size: 60 60
    margin-top: -28
    margin-left: -15

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
    id: infolist1
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    width: 180
    margin-top: 10
    margin-left: 10
    margin-right: 10
    text: FOLLOW CONFIG
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f
    color: gray

  Panel
    id: navConfig
    anchors.top: prev.bottom
    anchors.left: parent.left
    height: 125
    width: 170
    margin-top: 2
    margin-left: 10
    background-color: #1b1b1b
    opacity: 0.95
    border: 1 #3b2a10

  Label
    id: labelAttack
    anchors.top: infolist1.bottom
    anchors.left: infolist1.left
    margin-left: 5
    margin-top: 8
    text: LEADER ATTACK:
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  TextEdit
    id: navAttack
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: navConfig.right
    margin-right: 5
    margin-top: 4
    image-color: #2f2f2f
    placeholder: INSERT LEADER NAME!
    placeholder-font: verdana-9px
    font: verdana-9px
  
  BotSwitch
    id: attackCheck
    anchors.top: labelAttack.top
    anchors.left: labelAttack.right
    image-source: /images/ui/button_rounded
    font: verdana-9px
    size: 50 15
    margin-top: 0
    margin-left: 28
    $on:
      text: ON
      color: green
    $!on:
      text: OFF
      color: white

  Label
    id: labelFollow
    anchors.top: navAttack.bottom
    anchors.left: navAttack.left
    margin-top: 10
    text: PLAYER FOLLOW:
    text-auto-resize: true
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  TextEdit
    id: navLeader
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: navConfig.right
    margin-right: 5
    margin-top: 4
    image-color: #2f2f2f
    placeholder: INSERT FOLLOW NAME!
    placeholder-font: verdana-9px
    font: verdana-9px

  HorizontalSeparator
    id: sep1
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 5
    image-color: black

  BotSwitch
    id: followCheck
    anchors.top: labelFollow.top
    anchors.left: labelFollow.right
    image-source: /images/ui/button_rounded
    font: verdana-9px
    size: 50 15
    margin-top: 0
    margin-left: 28
    $on:
      text: ON
      color: green
    $!on:
      text: OFF
      color: white

  BotSwitch
    id: onSouLider
    anchors.top: sep1.bottom
    anchors.left: sep1.left
    margin-top: 4
    size: 15 15
    image-source: /images/ui/button_rounded
    font: verdana-9px

  Label
    id: labelSouLIder
    anchors.top: onSouLider.top
    anchors.left: onSouLider.right
    margin-top: 1
    margin-left: 5
    text: SOU LIDER
    text-auto-resize: true
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  Panel
    id: navUEConfig
    anchors.top: navConfig.top
    anchors.left: navConfig.right
    height: 125
    width: 170
    margin-left: 10
    margin-top: 0
    background-color: #1b1b1b
    opacity: 0.95
    border: 1 #3b2a10

  Label
    id: labelUELeader
    anchors.top: infolist1.bottom
    anchors.left: navUEConfig.left
    margin-top: 8
    margin-left: 5
    text: LEADER UE:
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  TextEdit
    id: UELeader
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: navUEConfig.right
    margin-right: 5
    margin-top: 4
    image-color: #2f2f2f
    placeholder: INSERT LEADER UE!
    placeholder-font: verdana-9px
    font: verdana-9px

  Label
    id: UESpellLabel
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 10
    text: UE SPELL:
    text-auto-resize: true
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  TextEdit
    id: UESpell
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: navUEConfig.right
    margin-right: 5
    margin-top: 4
    image-color: #2f2f2f
    placeholder: INSERT UE SPELL!
    placeholder-font: verdana-9px
    font: verdana-9px

  HorizontalSeparator
    id: sep2
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 5
    image-color: black

  BotSwitch
    id: useUEcheck
    anchors.top: UESpellLabel.top
    anchors.right: UESpell.right
    image-source: /images/ui/button_rounded
    font: verdana-9px
    size: 50 15
    margin-top: -2
    margin-left: 28
    $on:
      text: ON
      color: green
    $!on:
      text: OFF
      color: white

  BotSwitch
    id: onAbrirChat
    anchors.top: sep2.bottom
    anchors.left: sep2.left
    margin-top: 4
    size: 15 15
    image-source: /images/ui/button_rounded
    font: verdana-9px

  Label
    id: labelAbriParty
    anchors.top: onAbrirChat.top
    anchors.left: onAbrirChat.right
    margin-top: 1
    margin-left: 5
    text: ABRIR CHAT PARTY
    text-auto-resize: true
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  Panel
    id: ropePanel
    anchors.top: navConfig.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    width: 180
    height: 25
    margin-top: 5
    margin-left: 10
    margin-right: 10
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f

    Label
      id: toolsNavLabel
      anchors.left: parent.left
      anchors.top: parent.top
      margin-top: 6
      margin-left: 5
      text: INSIRA O ID DA CORDA:
      text-auto-resize: true
      font: verdana-9px
      color: gray

  BotTextEdit
    id: ropeID
    anchors.top: ropePanel.top
    anchors.right: ropePanel.right
    margin-right: 6
    margin-top: 3
    width: 180
    height: 19
    image-color: #2f2f2f
    placeholder: INSERT UE SPELL!
    placeholder-font: verdana-9px
    font: verdana-9px

  FlatPanel
    id: toolsNav
    anchors.top: ropePanel.bottom
    anchors.left: ropePanel.left
    anchors.right: ropePanel.right
    anchors.bottom: parent.bottom
    margin-bottom: 10
    margin-top: 2
    height: 289
    width: 180
    image-color: #363636
    layout: verticalBox
    
  Label
    id: RopeLabel
    anchors.top: ropePanel.bottom
    anchors.left: ropePanel.left
    margin-top: 5
    margin-left: 5
    text: IDS CORDA:
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  BotContainer
    id: ropeIds
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: toolsNav.right
    margin-left: -2
    margin-right: 5
    height: 34

  Label
    id: useLabel
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 5
    text: IDS USE:
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  BotContainer
    id: useIds
    anchors.top: prev.bottom
    anchors.left: useLabel.left
    anchors.right: toolsNav.right
    margin-right: 5
    height: 34

  Label
    id: stairLabel
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 5
    text: IDS ESCADA:
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  BotContainer
    id: stairIds
    anchors.top: prev.bottom
    anchors.left: stairLabel.left
    anchors.right: toolsNav.right
    margin-right: 5
    height: 34

  Label
    id: buracoLabel
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 5
    text: IDS BURACOS/TELEPORTS
    font: verdana-9px
    text-auto-resize: true
    color: #d7c08a

  BotContainer
    id: buracoIds
    anchors.top: prev.bottom
    anchors.left: buracoLabel.left
    anchors.right: toolsNav.right
    margin-right: 5
    height: 34


]], g_ui.getRootWidget())
navPanel:hide()
navPanel:setId(scriptsPanelName)

followButton.settings.onClick = function()
  navPanel:show()
end

navPanel.closePanel.onClick = function()
  navPanel:hide()
end

local textEditDefaults = {
  navAttack = "",
  navLeader = "",
  UELeader = "",
  UESpell = "",
  ropeID = tostring(settings.follow.ropeID or "3003")
}

local textEditIds = { "navAttack", "navLeader", "UELeader", "UESpell", "ropeID" }
for _, id in ipairs(textEditIds) do
  local textEdit = navPanel:getChildById(id)
  if textEdit then
    local savedText = storage[scriptsPanelName].texts[id]
    textEdit:setText(savedText or textEditDefaults[id])

    textEdit.onTextChange = function(widget, text)
      storage[scriptsPanelName].texts[id] = text

      if id == "ropeID" then
        settings = loadSettings()
        settings.follow = settings.follow or {}
        settings.follow.ropeID = tostring(text or "3003")
        saveSettings(settings)
      end
    end
  end
end

local function bindBotSwitch(panel, widgetId, storageKey)
  local w = panel:getChildById(widgetId)
  if not w then return end

  local st = storage[scriptsPanelName].switches
  if st[storageKey] == nil then st[storageKey] = false end

  w:setOn(st[storageKey] == true)

  w.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    st[storageKey] = newState
  end
end

bindBotSwitch(navPanel, "attackCheck", "attackCheck")
bindBotSwitch(navPanel, "followCheck", "followCheck")
bindBotSwitch(navPanel, "useUEcheck",  "useUEcheck")
bindBotSwitch(navPanel, "onSouLider",  "souLider")
bindBotSwitch(navPanel, "onAbrirChat", "abrirChatParty")

local useROPEContainer = navPanel:getChildById('ropeIds')
local useIDSContainer = navPanel:getChildById('useIds')
local stairIDSContainer = navPanel:getChildById('stairIds')
local buracoIDSContainer = navPanel:getChildById('buracoIds')

UI.ContainerEx(function()
  if useROPEContainer then
    local cleanItems = normalizeContainerItems(useROPEContainer:getItems())
    storage[scriptsPanelName].ropeIDS = cleanItems

    settings = loadSettings()
    settings.follow = settings.follow or {}
    settings.follow.ropeIDS = cleanItems
    saveSettings(settings)
  end
end, true, nil, useROPEContainer)
if useROPEContainer then
  useROPEContainer:setItems(storage[scriptsPanelName].ropeIDS or {})
end

UI.ContainerEx(function()
  if useIDSContainer then
    local cleanItems = normalizeContainerItems(useIDSContainer:getItems())
    storage[scriptsPanelName].useIDS = cleanItems

    settings = loadSettings()
    settings.follow = settings.follow or {}
    settings.follow.useIDS = cleanItems
    saveSettings(settings)
  end
end, true, nil, useIDSContainer)
if useIDSContainer then
  useIDSContainer:setItems(storage[scriptsPanelName].useIDS or {})
end

UI.ContainerEx(function()
  if stairIDSContainer then
    local cleanItems = normalizeContainerItems(stairIDSContainer:getItems())
    storage[scriptsPanelName].stairIDS = cleanItems

    settings = loadSettings()
    settings.follow = settings.follow or {}
    settings.follow.stairIDS = cleanItems
    saveSettings(settings)
  end
end, true, nil, stairIDSContainer)
if stairIDSContainer then
  stairIDSContainer:setItems(storage[scriptsPanelName].stairIDS or {})
end

UI.ContainerEx(function()
  if buracoIDSContainer then
    local cleanItems = normalizeContainerItems(buracoIDSContainer:getItems())
    storage[scriptsPanelName].buracoIDS = cleanItems

    settings = loadSettings()
    settings.follow = settings.follow or {}
    settings.follow.buracoIDS = cleanItems
    saveSettings(settings)
  end
end, true, nil, buracoIDSContainer)
if buracoIDSContainer then
  buracoIDSContainer:setItems(storage[scriptsPanelName].buracoIDS or {})
end

local function containsId(list, id)
    if not list then return false end
    id = tonumber(id)

    for _, entry in ipairs(list) do
        local entryId = tonumber(entry) or tonumber(entry.id)
        if entryId == id then
            return true
        end
    end

    return false
end

leaderPositions = {}
leaderDirections = {}
leaderUsePositions = {}
local leader
local lastLeaderFloor
local ropeId = 3003
local standTime = now

local function handleUse(pos)
    local tile = g_map.getTile(pos)
    if tile and tile:getTopUseThing() then g_game.use(tile:getTopUseThing()) end
end

local function handleRope(pos)
    local ropeIdd = storage[scriptsPanelName].texts["ropeID"]
    local tile = g_map.getTile(pos)
    if tile and tile:getTopUseThing() then useWith(tonumber(ropeIdd), tile:getTopUseThing()) end
end

local function handleStep(pos)
    autoWalk(pos, 40, {ignoreNonPathable=true, precision=1})
end

local function distance(pos1, pos2)
    pos2 = pos2 or player:getPosition()
    return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function executeClosest(possibilities)
    local closest, closestDistance = nil, 99
    for _, data in ipairs(possibilities) do
        local dist = distance(data.pos, leaderPositions[posz()] or player:getPosition())
        if dist < closestDistance then
            closest, closestDistance = data, dist
        end
    end
    if closest then closest.action(closest.pos); return true end
    return false
end

local function handleFloorChange()
    local p = player:getPosition()
    local s = storage[scriptsPanelName]
    local possibleChangers = {}

    local actionMap = {
        { ids = s.useIDS,    action = handleUse  },
        { ids = s.ropeIDS,   action = handleRope },
        { ids = s.stairIDS,  action = handleStep },
        { ids = s.buracoIDS, action = handleStep }
    }

    for _, mapEntry in ipairs(actionMap) do
        if mapEntry.ids and #mapEntry.ids > 0 then
            for x = -2, 2 do
                for y = -2, 2 do
                    local checkPos = {x = p.x + x, y = p.y + y, z = p.z}
                    local tile = g_map.getTile(checkPos)
                    
                    if tile and tile:getTopUseThing() and containsId(mapEntry.ids, tile:getTopUseThing():getId()) then
                        table.insert(possibleChangers, {action = mapEntry.action, pos = checkPos})
                    end
                end
            end
        end
    end

    if #possibleChangers > 0 then return executeClosest(possibleChangers) end
    return false
end

local function levitate(dir)
    turn(dir)
    schedule(200, function()
        say('exani hur "down')
        say('exani hur "up')
    end)
end

local function matchPos(p1, p2)
    return (p1.x == p2.x and p1.y == p2.y)
end

local function handleUsing()
    local usePos = leaderUsePositions[posz()]
    if usePos then
        local useTile = g_map.getOrCreateTile(usePos)
        if useTile and useTile:getTopUseThing() then use(useTile:getTopUseThing()) end
    end
end

local function getStandTime()
    return now - standTime
end

local function useRope(pos)
    pos = pos or player:getPosition()
    for x = -1, 1 do
        for y = -1, 1 do
            local tpos = {x = pos.x + x, y = pos.y + y, z = posz()}
            local tile = g_map.getTile(tpos)
            if tile and tile:getGround() then
                if containsId(storage[scriptsPanelName].ropeIDS, tile:getGround():getId()) then
                    handleRope(tpos)
                    delay(getDistanceBetween(player:getPosition(), tpos) * 60)
                    return true
                end
            end
        end
    end
    return false
end

local function handleDoors()
    if not leader then return false end
    local doorIds = storage[scriptsPanelName].useIDS or {}
    local lpos = leader:getPosition()
    for x = lpos.x - 1, lpos.x + 1 do
        for y = lpos.y - 1, lpos.y + 1 do
            local pos = {x = x, y = y, z = lpos.z}
            local tile = g_map.getTile(pos)
            if tile and tile:getTopUseThing() and containsId(doorIds, tile:getTopUseThing():getId()) then
                g_game.use(tile:getTopUseThing())
                delay(200)
                return true
            end
        end
    end
    return false
end

local function handleLeaderInteraction()
    if not leader then return false end
    local lpos = leader:getPosition()
    local useIds = storage[scriptsPanelName].useIDS or {}
    for x = -1, 1 do
        for y = -1, 1 do
            local tpos = {x = lpos.x + x, y = lpos.y + y, z = lpos.z}
            local tile = g_map.getTile(tpos)
            if tile and tile:getTopUseThing() and containsId(useIds, tile:getTopUseThing():getId()) then
                handleUse(tpos)
                delay(100)
                return true
            end
        end
    end
    return false
end

local lastKnownPosition

local function goLastKnown()
    if getDistanceBetween(pos(), {x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z}) > 1 then
        local newTile = g_map.getTile({x = lastKnownPosition.x, y = lastKnownPosition.y, z = lastKnownPosition.z})
        if newTile then
            g_game.use(newTile:getTopUseThing())
            delay(math.random(300, 700))
        end
    end
end

local function checkTargetPos()
    local c = getCreatureByName(target)
    if c and c:getPosition().z == posz() then
        lastKnownPosition = c:getPosition()
    end
end

local function targetMissing()
    for _, n in ipairs(getSpectators(false)) do
        if n:getName() == target then
            return n:getPosition().z ~= posz()
        end
    end
    return true
end

macro(200, function()
  if not storage[switchFollow] or storage[switchFollow].enabled ~= true then return end
  local target = storage[scriptsPanelName].texts["navLeader"]
  if storage[scriptsPanelName].switches.followCheck ~= true then return end

  if not g_game.isAttacking() then
    local c = getCreatureByName(target)

    if g_game.isFollowing() then
        if g_game.getFollowingCreature() ~= c then
            g_game.cancelFollow()
            g_game.follow(c)
        end
    end

    if c and not g_game.isFollowing() then
        g_game.follow(c)
    elseif c and g_game.isFollowing() and getDistanceBetween(pos(), c:getPosition()) > 2 then
        g_game.cancelFollow()
        g_game.follow(c)
    end
    
    if not c then
        local leaderPos = leaderPositions[posz()]
        if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
            autoWalk(leaderPos, 200, {ignoreNonPathable=true, precision=5})
            delay(500)
        end
        if handleDoors() then return end
        if handleLeaderInteraction() then return end
        if handleFloorChange() then return end

        local dir = leaderDirections[posz()]
        if dir then levitate(dir) end

        local levitatePos = listenedLeaderPosDir
        if levitatePos and matchPos(player:getPosition(), levitatePos) then
            levitate(listenedLeaderDir)
        end

        if useRope(leaderPos) then return end
        handleUsing()
    end

    if not c then
        local leaderPos = leaderPositions[posz()]
        if leaderPos and getDistanceBetween(pos(), leaderPos) > 1 then
            if handleDoors() or handleLeaderInteraction() or handleFloorChange() or useRope(leaderPos) then
            end
        end
        return
    end

    local dist = getDistanceBetween(pos(), c:getPosition())
    if dist > 3 and not c then
        g_game.cancelFollow()
        if handleDoors() or handleLeaderInteraction() or handleFloorChange() or useRope(c:getPosition()) then
        end
    end
  end
end)

macro(200, function()
  if not storage[switchFollow] or storage[switchFollow].enabled ~= true then return end
  if g_game.isAttacking() and storage[scriptsPanelName].switches.followCheck == true then
    if not leader then
        local leaderPos = leaderPositions[posz()]
        if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
            autoWalk(leaderPos, 200, {ignoreNonPathable=true, precision=1})
            return
        end

        if handleDoors() then return end
        if handleLeaderInteraction() then return end
        if handleFloorChange() then return end

        local dir = leaderDirections[posz()]
        if dir then levitate(dir) end

        local levitatePos = listenedLeaderPosDir
        if levitatePos and matchPos(player:getPosition(), levitatePos) then
            levitate(listenedLeaderDir)
            return
        end

        if useRope(leaderPos) then return end
        handleUsing()
    else
        listenedLeaderPosDir, listenedLeaderDir = nil, nil
        local lpos = leader:getPosition()
        local parameters = {ignoreNonPathable=true, precision=1, ignoreCreatures=true}
        local distance = getDistanceBetween(player:getPosition(), lpos)
        local path = findPath(player:getPosition(), lpos, 200, parameters)

        if distance > 1 and not path then
            handleUsing()
            handleDoors()
        elseif distance > 2 then
            if getStandTime() > 100 then
                autoWalk(lpos, 200, parameters)
            end
        end
    end
  end
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
    if storage[scriptsPanelName].switches.followCheck ~= true then return end
    if creature:getName() == player:getName() then standTime = now return end
    if creature:getName():lower() ~= (storage[scriptsPanelName].texts["navLeader"] or ""):lower() then return end

    if newPos then
        leaderPositions[newPos.z] = newPos
        lastLeaderFloor = newPos.z
        if newPos.z == posz() then leader = creature else leader = nil end
    else
        leader = nil
    end

    if oldPos and newPos and oldPos.z ~= newPos.z then
        leaderDirections[oldPos.z] = creature:getDirection()
    end
end)

onCreatureAppear(function(creature)
    if storage[scriptsPanelName].switches.followCheck ~= true then return end
    if creature:getName():lower() == (storage[scriptsPanelName].texts["navLeader"] or ""):lower() and creature:getPosition().z == posz() then
        leader = creature
    end
end)

onCreatureDisappear(function(creature)
    if storage[scriptsPanelName].switches.followCheck ~= true then return end
    if creature:getName():lower() == (storage[scriptsPanelName].texts["navLeader"] or ""):lower() then
        leader = nil
    end
end)

function followLeader()
  local leaderToFollow = storage[scriptsPanelName].texts["navLeader"]

  if leaderToFollow and leaderToFollow ~= '' then
    local creature = Creature.find(leaderToFollow)
    if creature then
      g_game.follow(creature)
    end
  end
end

onMissle(function(missle)
  local src = missle:getSource()
  if src.z ~= posz() then return end
  
  local from = g_map.getTile(src)
  local to = g_map.getTile(missle:getDestination())
  if not from or not to then return end
  
  local fromCreatures = from:getCreatures()
  local toCreatures = to:getCreatures()
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end
  
  local c1 = fromCreatures[1]
  local t1 = toCreatures[1]
  
  if t1:getName():lower() == storage[scriptsPanelName].texts["navAttack"]:lower() then return end
  
  if c1:getName():lower() == storage[scriptsPanelName].texts["navAttack"]:lower() then
    if player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2 then return end
    if storage[scriptsPanelName].switches.attackCheck == true then
      local target = g_game.getAttackingCreature()
      if not target or target ~= t1 then
        g_game.attack(t1)
      end
    end
  end
end)

local fecharChannel = 0

macro(1000, function()
  if storage[scriptsPanelName].switches.abrirChatParty ~= true then return end
  if not (player:isPartyMember() or player:getShield() > 2 or player:isPartyLeader()) then return end

  if not modules.game_console.getTab("Party") then
    g_game.requestChannels()
    g_game.joinChannel(1)
    fecharChannel = now + 2000
  end

  if fecharChannel > 0 and now >= fecharChannel then
    local w = nil

    if modules and modules.game_console then
      w = modules.game_console.channelsWindow
    end

    if not w then
      local root = g_ui.getRootWidget()
      if root and root.recursiveGetChildById then
        w = root:recursiveGetChildById('channelsWindow')
      end
    end

    if w then
      w:destroy()
      if modules and modules.game_console then
        modules.game_console.channelsWindow = nil
      end
    end

    fecharChannel = 0
  end
end)

local leaderWait = 0
local lastTarget = nil

local function encodeTargetId(id)
  local s = tostring(id)
  if #s >= 8 then
    local p1 = s:sub(1,1)
    local p2 = s:sub(2,3)
    local p3 = s:sub(4,4)
    local p4 = s:sub(5,6)
    local p5 = s:sub(7,8)
    local p6 = s:sub(9,10)
    return "." .. p1 .. "@" .. p2 .. "#" .. p3 .. "!" .. p4 .. "+" .. p5 .. "[" .. p6 .. "]"
  end
  return "." .. s
end

local function decodeTargetId(text)
  local digits = (text or ""):gsub("%D", "")
  if digits == "" then return nil end
  return tonumber(digits)
end

macro(500, function()
  if storage[scriptsPanelName].switches.souLider ~= true then return end
  if not (player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2) then return end

  local t = g_game.getAttackingCreature()
  if not t then return end

  if leaderWait >= now and lastTarget == t then return end
  lastTarget = t

  local msg = "ATACAR: " .. encodeTargetId(t:getId())
  sayChannel(1, msg)

  leaderWait = now + 8000
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if storage[scriptsPanelName].switches.attackCheck ~= true then return end
  if channelId ~= 1 then return end

  local leaderName = (storage[scriptsPanelName].texts["navAttack"] or ""):lower()
  if leaderName == "" then return end
  if name:lower() ~= leaderName then return end

  local id = decodeTargetId(text)
  if not id then return end

  local target = getCreatureById(id)
  if not target then return end
  if target:getPosition().z ~= posz() then return end

  if g_game.getAttackingCreature() == target then return end
  g_game.attack(target)
end)
