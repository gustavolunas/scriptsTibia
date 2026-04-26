setDefaultTab("Tools")
print("btf att")

PANEL_NAME = "lnsFollow"
SWITCH_FOLLOW = "followButton"

local function trim(str)
  str = tostring(str or "")
  return str:match("^%s*(.-)%s*$")
end

storage[PANEL_NAME] = storage[PANEL_NAME] or {
  texts = {
    navAttack = "",
    navLeader = "",
    UESpell = "",
    ropeID = tostring((settings.follow and settings.follow.ropeID) or "3003")
  },
  switches = {
    attackCheck = false,
    followCheck = false,
    useUEcheck = false,
    abrirChatParty = false,
    debug = false,
  },
  ropeIDS = (settings.follow and settings.follow.ropeIDS) or {386},
  useIDS = (settings.follow and settings.follow.useIDS) or {435},
  stairIDS = (settings.follow and settings.follow.stairIDS) or {484, 17394, 1977, 414},
  buracoIDS = (settings.follow and settings.follow.buracoIDS) or {1959},
  doorsIDS = (settings.follow and settings.follow.doorsIDS) or {},
}

storage[SWITCH_FOLLOW] = storage[SWITCH_FOLLOW] or {
  enabled = false,
  leader = false
}

local S = storage[PANEL_NAME]
S.texts = S.texts or {}
S.switches = S.switches or {}

if S.checkboxes then
  for k, v in pairs(S.checkboxes) do
    if S.switches[k] == nil then
      S.switches[k] = v and true or false
    end
  end
  S.checkboxes = nil
end

if S.switches.abrirChatParty == nil then S.switches.abrirChatParty = false end
if S.switches.debug == nil then S.switches.debug = false end

local State = {
  leader = nil,
  leaderPositions = {},
  leaderDirections = {},
  leaderUsePositions = {},
  lastLeaderFloor = nil,
  standTime = now,
  fecharChannel = 0,
  leaderWait = 0,
  lastTarget = nil,
  lastDoorUse = 0,
  lastRopeUse = 0,
  lastUseTry = 0,
  lastWalkTry = 0,
  lastFollowTry = 0,
  lastFloorTry = 0,
  lastLeaderSeenAt = 0,
}

local function dbg(msg)
  if S.switches.debug then
    print("[LNS FOLLOW] " .. msg)
  end
end

local function getLeaderName()
  return trim(tostring(S.texts.navLeader or ""))
end

local function getAttackLeaderName()
  return trim(tostring(S.texts.navAttack or ""))
end

local function saveFollowSetting(key, value)
  settings = loadSettings()
  settings.follow = settings.follow or {}
  settings.follow[key] = value
  saveSettings(settings)
end

local function safeText(id, default)
  if S.texts[id] == nil then
    S.texts[id] = default
  end
  return S.texts[id]
end

local function containsId(list, id)
  if not list then return false end
  local wanted = tonumber(id)
  if not wanted then return false end

  for _, entry in ipairs(list) do
    local entryId = nil
    if type(entry) == "table" then
      entryId = tonumber(entry.id)
    else
      entryId = tonumber(entry)
    end
    if entryId == wanted then
      return true
    end
  end
  return false
end

local function isPartyReady()
  return player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2
end

local function canRetry(lastTime, delayMs)
  return now >= (lastTime + delayMs)
end

local function resetLeaderCache()
  State.leader = nil
  State.leaderPositions = {}
  State.leaderDirections = {}
  State.leaderUsePositions = {}
  State.lastLeaderFloor = nil
  State.lastLeaderSeenAt = 0
end

local function setFollowEnabled(value)
  storage[SWITCH_FOLLOW].enabled = value
  if not value then
    g_game.cancelFollow()
    resetLeaderCache()
    dbg("Follow desligado e cache resetado.")
  end
end

local function updateToolsScripts()
  if storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].leader then
    if toolsScripts then toolsScripts:show() end
  else
    if toolsScripts then toolsScripts:hide() end
  end
end

local function distanceManhattan(pos1, pos2)
  pos2 = pos2 or player:getPosition()
  return math.abs(pos1.x - pos2.x) + math.abs(pos1.y - pos2.y)
end

local function matchPos(p1, p2)
  return p1 and p2 and p1.x == p2.x and p1.y == p2.y and p1.z == p2.z
end

local function getVisibleLeader()
  local name = getLeaderName()
  if name == "" then return nil end

  local c = getCreatureByName(name)
  if c and c:getPosition().z == posz() then
    return c
  end
  return nil
end

local function handleUse(pos)
  if not canRetry(State.lastUseTry, 200) then return false end
  State.lastUseTry = now

  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() then
    g_game.use(tile:getTopUseThing())
    dbg("Usando tile em " .. pos.x .. "," .. pos.y .. "," .. pos.z)
    return true
  end
  return false
end

local function handleRope(pos)
  if not canRetry(State.lastRopeUse, 300) then return false end
  State.lastRopeUse = now

  local ropeIdd = tonumber(S.texts.ropeID or "3003")
  local tile = g_map.getTile(pos)
  if tile and tile:getTopUseThing() and ropeIdd then
    useWith(ropeIdd, tile:getTopUseThing())
    dbg("Usando rope em " .. pos.x .. "," .. pos.y .. "," .. pos.z)
    return true
  end
  return false
end

local function handleStep(pos)
  if not canRetry(State.lastWalkTry, 200) then return false end
  State.lastWalkTry = now
  autoWalk(pos, 40, {ignoreNonPathable=true, precision=1})
  return true
end

local function executeClosest(possibilities)
  local referencePos = State.leaderPositions[posz()] or player:getPosition()
  local closest, closestDistance = nil, 99999

  for _, data in ipairs(possibilities) do
    local dist = distanceManhattan(data.pos, referencePos)
    if dist < closestDistance then
      closest = data
      closestDistance = dist
    end
  end

  if closest then
    return closest.action(closest.pos)
  end
  return false
end

local function handleFloorChange()
  if not canRetry(State.lastFloorTry, 250) then return false end
  State.lastFloorTry = now

  local p = player:getPosition()
  local possibleChangers = {}

  local actionMap = {
    { ids = S.useIDS,    action = handleUse  },
    { ids = S.ropeIDS,   action = handleRope },
    { ids = S.stairIDS,  action = handleStep },
    { ids = S.buracoIDS, action = handleStep }
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

  if #possibleChangers > 0 then
    dbg("Floor changer encontrado.")
    return executeClosest(possibleChangers)
  end

  return false
end

local function useRopeNear(pos)
  if not pos then return false end

  for x = -1, 1 do
    for y = -1, 1 do
      local tpos = {x = pos.x + x, y = pos.y + y, z = posz()}
      local tile = g_map.getTile(tpos)
      if tile and tile:getGround() and containsId(S.ropeIDS, tile:getGround():getId()) then
        if handleRope(tpos) then
          delay(getDistanceBetween(player:getPosition(), tpos) * 60)
          return true
        end
      end
    end
  end
  return false
end

local function handleUsing()
  local usePos = State.leaderUsePositions[posz()]
  if not usePos then return false end

  local useTile = g_map.getOrCreateTile(usePos)
  if useTile and useTile:getTopUseThing() then
    g_game.use(useTile:getTopUseThing())
    dbg("Usando posição do leader.")
    return true
  end
  return false
end

local function getStandTime()
  return now - State.standTime
end

local function levitate(dir)
  if not dir then return false end
  turn(dir)
  schedule(200, function()
    say('exani hur "down')
    say('exani hur "up')
  end)
  dbg("Tentando levitate.")
  return true
end

local function handleDoors()
  if not canRetry(State.lastDoorUse, 400) then return false end

  local doorIds = S.doorsIDS or {}
  local ppos = player:getPosition()
  local lpos = State.leader and State.leader:getPosition() or State.leaderPositions[posz()]
  local bestDoor = nil
  local bestLeaderDist = 99999
  local bestPlayerDist = 99999

  for x = ppos.x - 4, ppos.x + 4 do
    for y = ppos.y - 4, ppos.y + 4 do
      local pos = {x = x, y = y, z = ppos.z}
      local tile = g_map.getTile(pos)

      if tile and tile:getTopUseThing() and containsId(doorIds, tile:getTopUseThing():getId()) then
        local playerDist = getDistanceBetween(ppos, pos)
        if playerDist <= 4 then
          local leaderDist = lpos and getDistanceBetween(lpos, pos) or 99999

          if not bestDoor
            or leaderDist < bestLeaderDist
            or (leaderDist == bestLeaderDist and playerDist < bestPlayerDist) then
            bestDoor = {thing = tile:getTopUseThing(), pos = pos}
            bestLeaderDist = leaderDist
            bestPlayerDist = playerDist
          end
        end
      end
    end
  end

  if not bestDoor then return false end

  State.lastDoorUse = now
  g_game.use(bestDoor.thing)
  dbg("Abrindo porta em " .. bestDoor.pos.x .. "," .. bestDoor.pos.y .. "," .. bestDoor.pos.z)

  if lpos then
    local around = {
      {x = lpos.x + 1, y = lpos.y, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y, z = lpos.z},
      {x = lpos.x, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x, y = lpos.y - 1, z = lpos.z},
      {x = lpos.x + 1, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x + 1, y = lpos.y - 1, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y + 1, z = lpos.z},
      {x = lpos.x - 1, y = lpos.y - 1, z = lpos.z},
    }

    for i = 1, #around do
      local testPos = around[i]
      local path = findPath(player:getPosition(), testPos, 20, {ignoreNonPathable=true, precision=1, ignoreCreatures=true})
      if path then
        autoWalk(testPos, 200, {ignoreNonPathable=true, precision=1})
        break
      end
    end
  end

  delay(200)
  return true
end

local function handleLeaderInteraction()
  local l = State.leader
  if not l then return false end

  local lpos = l:getPosition()
  local useIds = S.useIDS or {}

  for x = -1, 1 do
    for y = -1, 1 do
      local tpos = {x = lpos.x + x, y = lpos.y + y, z = lpos.z}
      local tile = g_map.getTile(tpos)
      if tile and tile:getTopUseThing() and containsId(useIds, tile:getTopUseThing():getId()) then
        if handleUse(tpos) then
          delay(100)
          return true
        end
      end
    end
  end

  return false
end

local function tryRecoverLeaderPath()
  local leaderPos = State.leaderPositions[posz()]
  if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
    autoWalk(leaderPos, 200, {ignoreNonPathable=true, precision=5})
    delay(300)
    dbg("Andando para última posição do leader.")
    return true
  end

  if handleLeaderInteraction() then return true end
  if handleFloorChange() then return true end

  local dir = State.leaderDirections[posz()]
  if dir then
    return levitate(dir)
  end

  if useRopeNear(leaderPos) then return true end
  if handleUsing() then return true end

  return false
end

local function ensureFollow(creature)
  if not creature then return false end
  if not canRetry(State.lastFollowTry, 250) then return false end
  State.lastFollowTry = now

  if g_game.isFollowing() then
    if g_game.getFollowingCreature() ~= creature then
      g_game.cancelFollow()
      g_game.follow(creature)
      dbg("Reiniciando follow no leader.")
      return true
    end
  else
    g_game.follow(creature)
    dbg("Iniciando follow no leader.")
    return true
  end
  return false
end

local function followVisibleLeader(creature)
  if not creature then return false end

  local lpos = creature:getPosition()
  local dist = getDistanceBetween(player:getPosition(), lpos)
  local parameters = {ignoreNonPathable=true, precision=1, ignoreCreatures=true}
  local path = findPath(player:getPosition(), lpos, 200, parameters)

  ensureFollow(creature)

  if dist > 3 then
    if handleDoors() then return true end
  end

  if g_game.isFollowing() and dist > 1 and getStandTime() > 100 then
    autoWalk(lpos, 200, parameters)
    g_game.cancelFollow()
    g_game.follow(creature)
  end

  if dist > 2 and not path then
    if handleUsing() then return true end
    if handleDoors() then return true end
    if handleFloorChange() then return true end
  elseif dist > 7 then
    if getStandTime() > 100 then
      autoWalk(lpos, 200, parameters)
      dbg("Ajustando autowalk no leader.")
      return true
    end
  end

  return false
end

local function followVisibleLeaderWhileAttacking(creature)
  if not creature then return false end

  local lpos = creature:getPosition()
  local dist = getDistanceBetween(player:getPosition(), lpos)
  local parameters = {ignoreNonPathable=true, precision=1, ignoreCreatures=true}
  local path = findPath(player:getPosition(), lpos, 200, parameters)

  -- IMPORTANTE:
  -- enquanto estiver atacando, não usar g_game.follow()
  -- para não quebrar target / attack

  if dist > 3 then
    if handleDoors() then return true end
  end

  if dist > 1 and not path then
    if handleUsing() then return true end
    if handleDoors() then return true end
    if handleFloorChange() then return true end
  elseif dist > 2 then
    if getStandTime() > 100 then
      autoWalk(lpos, 200, parameters)
      dbg("Ajustando autowalk no leader enquanto ataca.")
      return true
    end
  end

  return false
end

local function runFollowLogicIdle()
  if not storage[SWITCH_FOLLOW] or storage[SWITCH_FOLLOW].enabled ~= true then return end
  if S.switches.followCheck ~= true then return end
  if g_game.isAttacking() then return end

  local leaderName = getLeaderName()
  if leaderName == "" then return end

  local c = getVisibleLeader()
  State.leader = c

  -- aqui pode usar follow normal
  if c then
    return followVisibleLeader(c)
  else
    return tryRecoverLeaderPath()
  end
end

local function runFollowLogicAttacking()
  if not storage[SWITCH_FOLLOW] or storage[SWITCH_FOLLOW].enabled ~= true then return end
  if S.switches.followCheck ~= true then return end
  if not g_game.isAttacking() then return end

  local leaderName = getLeaderName()
  if leaderName == "" then return end

  local c = getVisibleLeader()
  State.leader = c

  -- sem leader visível: tenta recuperar caminho / floor / door
  if not c then
    local leaderPos = State.leaderPositions[posz()]
    if leaderPos and getDistanceBetween(player:getPosition(), leaderPos) > 0 then
      autoWalk(leaderPos, 200, {ignoreNonPathable=true, precision=1})
      dbg("Andando para última posição do leader enquanto ataca.")
      return true
    end

    if handleDoors() then return true end
    if handleLeaderInteraction() then return true end
    if handleFloorChange() then return true end

    local dir = State.leaderDirections[posz()]
    if dir then
      return levitate(dir)
    end

    if useRopeNear(leaderPos) then return true end
    if handleUsing() then return true end

    return false
  end

  -- com leader visível, só reposiciona sem follow bruto
  return followVisibleLeaderWhileAttacking(c)
end

followButton = setupUI([[
Panel
  height: 35

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-right: 45
    text: Follow
    color: white
    height: 18

  Button
    id: settings
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 2
    height: 18
    text: Config
    opacity: 1.00
    color: white

  CheckBox
    id: lider
    anchors.left: title.left
    anchors.top: title.bottom
    margin-top: 2
    image-source: /images/ui/checkbox_round
    text: Leader Control
    text-auto-resize: true
]])

followButton:setId(SWITCH_FOLLOW)
followButton.title:setOn(storage[SWITCH_FOLLOW].enabled)
followButton.lider:setChecked(storage[SWITCH_FOLLOW].leader)

followButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  setFollowEnabled(newState)
end

followButton.lider.onClick = function(widget)
  local newState = not widget:isChecked()
  widget:setChecked(newState)
  storage[SWITCH_FOLLOW].leader = newState
  updateToolsScripts()
end

updateToolsScripts()

local navPanel = setupUI([[  
MainWindow
  id: navPanel
  size: 370 350
  !text: tr('Follow Panel')
  margin-top: -50
  border: 1 black

  Panel
    id: infolist1
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    size: 190 123
    image-source: /images/ui/miniwindow
    image-border: 12
    margin-left: -4
    margin-right: -4

    Label
      id: title
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      text: Configurations Follower
      margin-top: 2

  BotSwitch
    id: attackCheck
    anchors.top: infolist1.top
    anchors.left: parent.left
    margin-left: 2
    margin-top: 20
    image-source: /images/ui/button_rounded
    size: 35 20
    font: verdana-11px-rounded
    $on:
      text: On
    $!on:
      text: Off
      image-color: gray

  Label
    id: labelAttack
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 4
    text: Leader Attack:
    font: verdana-11px-rounded
    text-auto-resize: true

  TextEdit
    id: navAttack
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: parent.right
    margin-left: 10
    margin-right: 3
    placeholder: Insert Leader Name
    placeholder-font: verdana-9px

  BotSwitch
    id: followCheck
    anchors.top: attackCheck.bottom
    anchors.left: attackCheck.left
    image-source: /images/ui/button_rounded
    margin-top: 5
    size: 35 20
    font: verdana-11px-rounded
    $on:
      text: On
    $!on:
      text: Off
      image-color: gray

  Label
    id: labelFollow
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 4
    text: Player Follow:
    text-auto-resize: true
    font: verdana-11px-rounded

  TextEdit
    id: navLeader
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: navAttack.left
    anchors.right: parent.right
    margin-right: 3
    placeholder: Insert Follower Name
    placeholder-font: verdana-9px

  BotSwitch
    id: useUEcheck
    anchors.top: followCheck.bottom
    anchors.left: followCheck.left
    image-source: /images/ui/button_rounded
    margin-top: 5
    size: 35 20
    font: verdana-11px-rounded
    $on:
      text: On
    $!on:
      text: Off
      image-color: gray

  Label
    id: UESpellLabel
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 4
    text: UE Spell:
    font: verdana-11px-rounded
    text-auto-resize: true

  TextEdit
    id: UESpell
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: navLeader.left
    anchors.right: parent.right
    margin-right: 3
    placeholder: Insert UE Spell
    placeholder-font: verdana-9px

  BotSwitch
    id: onAbrirChat
    anchors.top: useUEcheck.bottom
    anchors.left: useUEcheck.left
    margin-top: 12
    image-source: /images/ui/button_rounded
    size: 35 20
    font: verdana-11px-rounded
    $on:
      text: On
    $!on:
      text: Off
      image-color: gray

  Label
    id: labelAbriParty
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    margin-left: 4
    text: Abrir Chat Party
    font: verdana-11px-rounded
    text-auto-resize: true

  VerticalSeparator
    anchors.left: prev.right
    anchors.top: prev.top
    anchors.bottom: prev.bottom
    margin-left: 10
    margin-top: -7
    margin-bottom: -5

  Panel
    id: ropePanel
    anchors.verticalCenter: prev.verticalCenter
    anchors.left: prev.right
    anchors.right: parent.right
    width: 180
    height: 25
    margin-left: 5
    margin-right: 4

    Label
      id: toolsNavLabel
      anchors.left: parent.left
      anchors.top: parent.top
      margin-top: 6
      margin-left: 5
      text: ID Rope:
      text-auto-resize: true
      font: verdana-11px-rounded

  BotTextEdit
    id: ropeID
    anchors.top: ropePanel.top
    anchors.right: ropePanel.right
    margin-right: 0
    margin-top: 3
    width: 90
    height: 19
    font: verdana-11px-rounded

  FlatPanel
    id: toolsNav
    anchors.top: ropePanel.bottom
    anchors.left: infolist1.left
    anchors.right: infolist1.right
    anchors.bottom: parent.bottom
    margin-bottom: 20
    margin-top: 10
    width: 170

  Label
    id: RopeLabel
    anchors.top: ropePanel.bottom
    anchors.left: toolsNav.left
    margin-top: 15
    margin-left: 8
    text: IDS String:
    font: verdana-11px-rounded
    text-auto-resize: true

  BotContainer
    id: ropeIds
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: toolsNav.right
    margin-left: 0
    margin-right: 5
    height: 34

  Label
    id: useLabel
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 5
    text: IDS to Use:
    font: verdana-11px-rounded
    text-auto-resize: true

  BotContainer
    id: useIds
    anchors.top: prev.bottom
    anchors.left: useLabel.left
    anchors.right: toolsNav.right
    margin-right: 5
    height: 34

  Label
    id: doorsLabel
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 5
    text: IDS Doors:
    font: verdana-11px-rounded
    text-auto-resize: true

  BotContainer
    id: doorsIds
    anchors.top: prev.bottom
    anchors.left: doorsLabel.left
    anchors.right: toolsNav.right
    margin-right: 5
    height: 34

  Button
    id: closePanel
    anchors.left: toolsNav.left
    anchors.right: toolsNav.right
    anchors.top: toolsNav.bottom
    margin-top: 5
    text: Close
]], g_ui.getRootWidget())

navPanel:hide()
navPanel:setId(PANEL_NAME)

followButton.settings.onClick = function()
  navPanel:show()
end

navPanel.closePanel.onClick = function()
  navPanel:hide()
end

local textEditDefaults = {
  navAttack = "",
  navLeader = "",
  UESpell = "",
  ropeID = tostring((settings.follow and settings.follow.ropeID) or "3003")
}

local function bindTextEdit(panel, id, onSave)
  local textEdit = panel:getChildById(id)
  if not textEdit then return end

  textEdit:setText(safeText(id, textEditDefaults[id] or ""))

  textEdit.onTextChange = function(widget, text)
    S.texts[id] = text
    if onSave then onSave(text) end
  end
end

bindTextEdit(navPanel, "navAttack")
bindTextEdit(navPanel, "navLeader")
bindTextEdit(navPanel, "UESpell")
bindTextEdit(navPanel, "ropeID", function(text)
  saveFollowSetting("ropeID", tostring(text or "3003"))
end)

local function bindBotSwitch(panel, widgetId, storageKey, cb)
  local w = panel:getChildById(widgetId)
  if not w then return end

  if S.switches[storageKey] == nil then
    S.switches[storageKey] = false
  end

  w:setOn(S.switches[storageKey] == true)

  w.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    S.switches[storageKey] = newState
    if cb then cb(newState, widget) end
  end
end

bindBotSwitch(navPanel, "attackCheck", "attackCheck")
bindBotSwitch(navPanel, "followCheck", "followCheck")
bindBotSwitch(navPanel, "useUEcheck", "useUEcheck")
bindBotSwitch(navPanel, "onAbrirChat", "abrirChatParty")

local useROPEContainer = navPanel:getChildById("ropeIds")
local useIDSContainer = navPanel:getChildById("useIds")
local doorsIDSContainer = navPanel:getChildById("doorsIds")

UI.ContainerEx(function()
  if useROPEContainer then
    local cleanItems = normalizeContainerItems(useROPEContainer:getItems())
    S.ropeIDS = cleanItems
    saveFollowSetting("ropeIDS", cleanItems)
  end
end, true, nil, useROPEContainer)
if useROPEContainer then
  useROPEContainer:setItems(S.ropeIDS or {})
end

UI.ContainerEx(function()
  if useIDSContainer then
    local cleanItems = normalizeContainerItems(useIDSContainer:getItems())
    S.useIDS = cleanItems
    saveFollowSetting("useIDS", cleanItems)
  end
end, true, nil, useIDSContainer)
if useIDSContainer then
  useIDSContainer:setItems(S.useIDS or {})
end

UI.ContainerEx(function()
  if doorsIDSContainer then
    local cleanItems = normalizeContainerItems(doorsIDSContainer:getItems())
    S.doorsIDS = cleanItems
    saveFollowSetting("doorsIDS", cleanItems)
  end
end, true, nil, doorsIDSContainer)
if doorsIDSContainer then
  doorsIDSContainer:setItems(S.doorsIDS or {})
end

macro(200, function()
  runFollowLogicIdle()
end)

macro(200, function()
  runFollowLogicAttacking()
end)

onCreaturePositionChange(function(creature, newPos, oldPos)
  if S.switches.followCheck ~= true then return end

  if creature:getName() == player:getName() then
    State.standTime = now
    return
  end

  if creature:getName():lower() ~= getLeaderName():lower() then return end

  if newPos then
    State.leaderPositions[newPos.z] = newPos
    State.lastLeaderFloor = newPos.z
    State.lastLeaderSeenAt = now
    if newPos.z == posz() then
      State.leader = creature
    else
      State.leader = nil
    end
  else
    State.leader = nil
  end

  if oldPos and newPos and oldPos.z ~= newPos.z then
    State.leaderDirections[oldPos.z] = creature:getDirection()
  end
end)

onCreatureAppear(function(creature)
  if S.switches.followCheck ~= true then return end
  if creature:getName():lower() == getLeaderName():lower() and creature:getPosition().z == posz() then
    State.leader = creature
    State.lastLeaderSeenAt = now
  end
end)

onCreatureDisappear(function(creature)
  if S.switches.followCheck ~= true then return end
  if creature:getName():lower() == getLeaderName():lower() then
    State.leader = nil
  end
end)

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

  local navAttack = getAttackLeaderName():lower()
  if navAttack == "" then return end
  if t1:getName():lower() == navAttack then return end

  if c1:getName():lower() == navAttack then
    if S.switches.attackCheck == true then
      local currentTarget = g_game.getAttackingCreature()
      if not currentTarget or currentTarget ~= t1 then
        g_game.attack(t1)
      end
    end
  end
end)

macro(1000, function()
  if S.switches.abrirChatParty ~= true then return end
  if not isPartyReady() then return end

  if not modules.game_console.getTab("Party") then
    g_game.requestChannels()
    g_game.joinChannel(1)
    State.fecharChannel = now + 2000
  end

  if State.fecharChannel > 0 and now >= State.fecharChannel then
    local w = nil

    if modules and modules.game_console then
      w = modules.game_console.channelsWindow
    end

    if not w then
      local root = g_ui.getRootWidget()
      if root and root.recursiveGetChildById then
        w = root:recursiveGetChildById("channelsWindow")
      end
    end

    if w then
      w:destroy()
      if modules and modules.game_console then
        modules.game_console.channelsWindow = nil
      end
    end

    State.fecharChannel = 0
  end
end)

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

local function isKnight()
  local voc = player:getVocation()
  return voc == 1 or voc == 6
end

macro(500, function()
  if not (storage[SWITCH_FOLLOW] and storage[SWITCH_FOLLOW].leader) then return end
  if not isKnight() then return end
  if not isPartyReady() then return end

  local t = g_game.getAttackingCreature()
  if not t then return end
  if t:getPosition().z ~= posz() then return end

  if State.leaderWait >= now and State.lastTarget == t then return end
  State.lastTarget = t

  local msg = "ATACAR: " .. encodeTargetId(t:getId())
  sayChannel(1, msg)
  State.leaderWait = now + 8000
end)

onTalk(function(name, level, mode, text, channelId, pos)
  if S.switches.attackCheck ~= true then return end
  if channelId ~= 1 then return end

  local leaderName = getAttackLeaderName():lower()
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
