setDefaultTab("LNS")

switchSio = "sioButton"
if not storage[switchSio] then storage[switchSio] = { enabled = false } end

local STORAGE_KEY = "autoSioSystem_v1"
storage[STORAGE_KEY] = storage[STORAGE_KEY] or {}

local cfg = storage[STORAGE_KEY]
cfg.spell = cfg.spell or "Exura Sio"
cfg.usePrioList   = cfg.usePrioList == true
cfg.useFriendList = (cfg.useFriendList ~= false)
cfg.useGuild      = cfg.useGuild == true
cfg.useParty      = cfg.useParty == true

cfg.hpPercent = tonumber(cfg.hpPercent) or 60
if cfg.hpPercent < 1 then cfg.hpPercent = 1 end
if cfg.hpPercent > 100 then cfg.hpPercent = 100 end

cfg.prioOrder = cfg.prioOrder or { "KNIGHT", "PALADIN", "MONK", "MAGE (SORC/DRUID)" }

cfg.friends = cfg.friends or {}

local function trim(s)
  s = tostring(s or "")
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normName(s)
  s = trim(s):gsub("%s+", " ")
  return s
end

local function clearChildren(w)
  if not w then return end
  local ch = w:getChildren() or {}
  for i = #ch, 1, -1 do
    local c = ch[i]
    if c and not c:isDestroyed() then c:destroy() end
  end
end

local function swap(t, i, j)
  if type(t) ~= "table" then return end
  if i < 1 or j < 1 or i > #t or j > #t then return end
  t[i], t[j] = t[j], t[i]
end

local function hasValue(t, v)
  for i = 1, #t do
    if t[i] == v then return true end
  end
  return false
end

sioButton = setupUI([[
Panel
  height: 18

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: AUTO SIO
    font: verdana-9px
    color: white
    height: 18
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
sioButton:setId(switchSio)
sioButton.title:setOn(storage[switchSio].enabled)

sioButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchSio].enabled = newState
end

sioInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 300 400
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

  Panel
    id: background
    anchors.fill: parent
    background-color: #0b0b0b
    opacity: 0.88

  Panel
    id: topPanel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
    text-align: center
    !text: tr('LNS Custom | AutoSio System')
    font: verdana-11px-rounded
    color: orange
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f

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

  Label
    id: labelSpell
    anchors.left: parent.left
    anchors.top: topPanel.bottom
    text: SPELL:
    font: verdana-9px
    margin-top: 14
    margin-left: 10

  TextEdit
    id: spellEdit
    anchors.top: labelSpell.top
    anchors.left: labelSpell.right
    anchors.right: parent.right
    margin-right: 10
    margin-left: 5
    image-color: gray
    margin-top: -3
    placeholder: INSERT SPELL HERE!
    placeholder-font: verdana-9px
    font: verdana-9px

  Label
    id: labelHP
    anchors.left: parent.left
    anchors.top: prev.bottom
    text: HP PERCENT:
    font: verdana-9px
    margin-top: 5
    margin-left: 10

  HorizontalScrollBar
    id: porcentagemHP
    anchors.top: prev.top
    anchors.left: prev.right
    anchors.right: spellEdit.right
    width: 120

  Label
    id: porcentagemHPLabel
    anchors.centerIn: porcentagemHP
    text-align: center
    font: verdana-9px
    color: white
    text: "<= 60%"
    text-auto-resize: true

  Panel
    id: infoPriolist
    anchors.top: labelHP.bottom
    anchors.left: labelSpell.left
    anchors.right: spellEdit.right
    margin-top: 10
    height: 16
    background-color: black
    border: 1 #3b2a10

    Label
      id: infoText
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      margin-left: 4
      text-align: center
      text: #                        VOCATION                      MOVE
      font: verdana-9px
      color: #d7c08a

  TextList
    id: prioList
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: infoPriolist.bottom
    margin-top: 0
    margin-left: 10
    margin-right: 21
    border: 1 #3b2a10
    height: 78
    image-color: #363636
    vertical-scrollbar: prioListScrollBar

  VerticalScrollBar
    id: prioListScrollBar
    anchors.top: prioList.top
    anchors.bottom: prioList.bottom
    anchors.left: prioList.right
    step: 10
    pixels-scroll: true
    visible: true
    image-color: #363636
    opacity: 0.90

  BotSwitch
    id: ativadorPrioList
    anchors.top: prioList.bottom
    anchors.left: prioList.left
    anchors.right: prioListScrollBar.right
    margin-top: 3
    width: 220
    text: ATIVAR LISTA DE PRIORIDADES?
    font: verdana-9px
    image-source: /images/ui/button_rounded
    $on:
      color: green
      opacity: 1.00
    $!on:
      color: gray
      opacity: 0.85

  Panel
    id: infoListSio
    anchors.top: ativadorPrioList.bottom
    anchors.left: labelSpell.left
    anchors.right: infoPriolist.right
    margin-top: 5
    height: 16
    background-color: black
    border: 1 #3b2a10

    Label
      id: infoText2
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.verticalCenter: parent.verticalCenter
      margin-left: 4
      text: "SIO FRIEND LIST"
      text-align: center
      font: verdana-9px
      color: #d7c08a

  TextList
    id: sioList
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: infoListSio.bottom
    margin-left: 10
    margin-right: 22
    height: 90
    image-color: #363636
    border: 1 #3b2a10
    vertical-scrollbar: sioListScrollBar

  VerticalScrollBar
    id: sioListScrollBar
    anchors.top: sioList.top
    anchors.bottom: sioList.bottom
    anchors.left: sioList.right
    step: 10
    pixels-scroll: true
    visible: true
    image-color: #363636
    opacity: 0.90

  TextEdit
    id: nameSioList
    anchors.top: sioList.bottom
    anchors.left: sioList.left
    margin-top: 6
    width: 240
    image-color: gray
    placeholder: INSERT FRIEND NAME!
    placeholder-font: verdana-9px
    font: verdana-9px

  Button
    id: inserSioList
    anchors.top: nameSioList.top
    anchors.left: nameSioList.right
    anchors.right: sioListScrollBar.right
    margin-left: 2
    image-source: /images/ui/button_rounded
    image-color: #363636
    text: +
    font: sans-bold-16px

  BotSwitch
    id: ativadorSioList
    anchors.top: nameSioList.bottom
    anchors.left: parent.left
    anchors.right: sioListScrollBar.right
    margin-top: 5
    margin-left: 10
    width: 25
    text: CURAR LISTA AMIGOS
    font: verdana-9px
    image-source: /images/ui/button_rounded
    $on:
      color: green
      opacity: 1.00
    $!on:
      color: gray
      opacity: 0.85

  BotSwitch
    id: ativadorGuild
    anchors.top: ativadorSioList.bottom
    anchors.left: parent.left
    anchors.right: prev.right
    margin-top: 2
    margin-left: 10
    width: 25
    text: CURAR GUILD
    font: verdana-9px
    image-source: /images/ui/button_rounded
    $on:
      color: green
      opacity: 1.00
    $!on:
      color: gray
      opacity: 0.85

  BotSwitch
    id: ativadorParty
    anchors.top: ativadorGuild.bottom
    anchors.left: parent.left
    margin-top: 2
    margin-left: 10
    anchors.right: prev.right
    width: 25
    text: CURAR PARTY
    font: verdana-9px
    image-source: /images/ui/button_rounded
    $on:
      color: green
      opacity: 1.00
    $!on:
      color: gray
      opacity: 0.85
]], g_ui.getRootWidget())
sioInterface:hide()

sioInterface.closePanel.onClick = function() sioInterface:hide() end

function buttonsSioPcMobile()
  if modules._G.g_app.isMobile() then
    sioButton.settings:show()
    sioButton.title:setMarginRight(55)
  else
    sioButton.settings:hide()
    sioButton.title:setMarginRight(0)
  end
end
buttonsSioPcMobile()

sioButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not sioInterface:isVisible() then
      sioInterface:show()
      sioInterface:raise();
      sioInterface:focus();
    else
      sioInterface:hide()
    end
  end
end

sioButton.settings.onClick = function()
  if sioInterface:isVisible() then
    sioInterface:hide()
  else
    sioInterface:show()
    sioInterface:raise()
    sioInterface:focus()
  end
end

local prioRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: false
  background-color: alpha
  opacity: 1.00

  Label
    id: order
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 30
    font: verdana-9px
    color: white
    text: ""

  Label
    id: voc
    anchors.left: order.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 42
    text-align: center
    font: verdana-9px
    width: 120
    color: white
    text: ""

  Button
    id: down
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: v
    color: white
    image-color: #363636
    image-source: /images/ui/button_rounded

  Button
    id: up
    anchors.right: down.left
    anchors.verticalCenter: parent.verticalCenter
    width: 16
    height: 16
    margin-right: 2
    text: ^
    color: white
    image-color: #363636
    image-source: /images/ui/button_rounded
]]

local friendRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  Label
    id: name
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 4
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

local function rebuildPrioList()
  clearChildren(sioInterface.prioList)

  local fixed = { "KNIGHT", "PALADIN", "MONK", "MAGE (SORC/DRUID)" }
  if type(cfg.prioOrder) ~= "table" then cfg.prioOrder = {} end
  -- se tiver corrompida: reseta
  local ok = (#cfg.prioOrder == 4)
  if ok then
    for i = 1, 4 do
      if not hasValue(fixed, cfg.prioOrder[i]) then ok = false break end
    end
  end
  if not ok then
    cfg.prioOrder = { "KNIGHT", "PALADIN", "MONK", "MAGE (SORC/DRUID)" }
  end

  for i = 1, #cfg.prioOrder do
    local voc = cfg.prioOrder[i]
    local row = setupUI(prioRowTemplate, sioInterface.prioList)

    row.order:setText(tostring(i))
    row.voc:setText(voc)

    row.up.onClick = function()
      swap(cfg.prioOrder, i, i - 1)
      rebuildPrioList()
    end
    row.down.onClick = function()
      swap(cfg.prioOrder, i, i + 1)
      rebuildPrioList()
    end

    if i == 1 then row.up:setEnabled(false) end
    if i == #cfg.prioOrder then row.down:setEnabled(false) end
  end
end

local function rebuildFriendList()
  clearChildren(sioInterface.sioList)

  if type(cfg.friends) ~= "table" then cfg.friends = {} end

  for i = 1, #cfg.friends do
    local name = cfg.friends[i]
    local row = setupUI(friendRowTemplate, sioInterface.sioList)
    row.name:setText(name)
    row.entryIndex = i

    row.remove.onClick = function()
      table.remove(cfg.friends, row.entryIndex)
      rebuildFriendList()
    end
  end
end

sioInterface.spellEdit:setText(cfg.spell)

sioInterface.ativadorPrioList:setOn(cfg.usePrioList)
sioInterface.ativadorSioList:setOn(cfg.useFriendList)
sioInterface.ativadorGuild:setOn(cfg.useGuild)
sioInterface.ativadorParty:setOn(cfg.useParty)

rebuildPrioList()
rebuildFriendList()

sioInterface.spellEdit.onTextChange = function(_, text)
  cfg.spell = trim(text)
end

sioInterface.ativadorPrioList.onClick = function(w)
  local v = not w:isOn()
  w:setOn(v)
  cfg.usePrioList = v
end

sioInterface.ativadorSioList.onClick = function(w)
  local v = not w:isOn()
  w:setOn(v)
  cfg.useFriendList = v
end

sioInterface.ativadorGuild.onClick = function(w)
  local v = not w:isOn()
  w:setOn(v)
  cfg.useGuild = v
end

sioInterface.ativadorParty.onClick = function(w)
  local v = not w:isOn()
  w:setOn(v)
  cfg.useParty = v
end

sioInterface.inserSioList.onClick = function()
  local name = normName(sioInterface.nameSioList:getText())
  if name == "" then return end

  for i = 1, #cfg.friends do
    if cfg.friends[i] == name then
      sioInterface.nameSioList:setText("")
      return
    end
  end

  table.insert(cfg.friends, name)
  sioInterface.nameSioList:setText("")
  rebuildFriendList()
end

local function clampHp(v)
  v = tonumber(v) or 1
  if v < 1 then v = 1 end
  if v > 100 then v = 100 end
  return math.floor(v)
end

local function applyHpUI()
  local v = clampHp(cfg.hpPercent)
  cfg.hpPercent = v

  if sioInterface.porcentagemHP.setMinimum then sioInterface.porcentagemHP:setMinimum(1) end
  if sioInterface.porcentagemHP.setMaximum then sioInterface.porcentagemHP:setMaximum(100) end
  if sioInterface.porcentagemHP.setValue then
    sioInterface.porcentagemHP:setValue(v)
  elseif sioInterface.porcentagemHP.setPercent then

    sioInterface.porcentagemHP:setPercent(v)
  end

  if sioInterface.porcentagemHPLabel then
    sioInterface.porcentagemHPLabel:setText("<= " .. v .. "%")
  end
end

applyHpUI()

if sioInterface.porcentagemHP then
  sioInterface.porcentagemHP.onValueChange = function(_, value)
    cfg.hpPercent = clampHp(value)
    if sioInterface.porcentagemHPLabel then
      sioInterface.porcentagemHPLabel:setText("<= " .. cfg.hpPercent .. "%")
    end
  end

  sioInterface.porcentagemHP.onChange = function(_, value)
    cfg.hpPercent = clampHp(value)
    if sioInterface.porcentagemHPLabel then
      sioInterface.porcentagemHPLabel:setText("<= " .. cfg.hpPercent .. "%")
    end
  end
end

-- =========================================
-- PRIORIDADE
-- =========================================
local function getMs()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function clampHp(v)
  v = tonumber(v) or 1
  if v < 1 then v = 1 end
  if v > 100 then v = 100 end
  return math.floor(v)
end

local function trim(s)
  s = tostring(s or "")
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function buildVocationRank()
  local rank = {}
  for i = 1, #cfg.prioOrder do
    rank[cfg.prioOrder[i]] = i
  end
  return rank
end

local function getVocCodeFromCheckText(creature)
  if not creature or not creature.getText then return nil end
  local t = creature:getText() or ""
  if t == "" then return nil end

  local code = t:match("%d+%s*(%u%u)")
  if not code then code = t:match("(%u%u)") end
  return code
end

local function vocGroupFromCode(code)
  if code == "EK" then return "KNIGHT" end
  if code == "RP" then return "PALADIN" end
  if code == "EM" then return "MONK" end
  if code == "MS" or code == "ED" then return "MAGE (SORC/DRUID)" end
  return nil
end

local function getPrioRankForCreature(creature, rankMap)
  local code = getVocCodeFromCheckText(creature)
  local group = vocGroupFromCode(code)
  if not group then return 9999 end
  return rankMap[group] or 9999
end

local function buildFriendSet()
  local set = {}
  if type(cfg.friends) ~= "table" then cfg.friends = {} end
  for i = 1, #cfg.friends do
    local n = cfg.friends[i]
    if n and n ~= "" then set[n] = true end
  end
  return set
end

local function isPartyShield(creature)
  if not creature then return false end

  if creature.isPartyMember and creature:isPartyMember() then
    return true
  end

  if creature:isPartyMember() then
    return true
  end

  return false
end

local function isGuildCandidate(creature)
  if not creature then return false end
  if not (creature.isPlayer and creature:isPlayer()) then return false end
  if not creature.getEmblem then return false end
  return creature:getEmblem() == 1
end

local function castSioOnName(name)
  local spell = trim(cfg.spell)
  if spell == "" or not name or name == "" then return end
  say(spell .. ' "' .. name)
end

-- =========================================
-- SISTEMA CENTRAL AUTO SIO
-- =========================================

local SIO_CD_MS = 900
local lastSioCastMs = 0

-- monta uma lista de candidatos na tela, filtrando por HP
local function collectCandidates(baseFilterFn, minHp)
  local myId = player:getId()
  local specs = getSpectators(false)
  local out = {}

  for i = 1, #specs do
    local c = specs[i]
    if c and c.isPlayer and c:isPlayer() and c.getId and c.getName and c.getHealthPercent then
      if c:getId() ~= myId then
        local hp = c:getHealthPercent()
        if hp and hp > 0 and hp <= minHp then
          if (not baseFilterFn) or baseFilterFn(c) == true then
            out[#out + 1] = { creature = c, name = c:getName(), hp = hp }
          end
        end
      end
    end
  end

  return out
end

local function chooseByPriorityOrRule(candidates, mode)
  -- mode:
  -- "FRIEND" -> se prio ON: vocação; se OFF: aleatório
  -- "PARTY"/"GUILD" -> se prio ON: vocação; se OFF: menor hp
  if not candidates or #candidates == 0 then return nil end

  if cfg.usePrioList == true then
    local rankMap = buildVocationRank()
    table.sort(candidates, function(a, b)
      local ra = getPrioRankForCreature(a.creature, rankMap)
      local rb = getPrioRankForCreature(b.creature, rankMap)
      if ra ~= rb then return ra < rb end
      return (a.hp or 999) < (b.hp or 999)
    end)
    return candidates[1]
  end

  if mode == "FRIEND" then
    return candidates[math.random(1, #candidates)]
  end

  table.sort(candidates, function(a, b)
    return (a.hp or 999) < (b.hp or 999)
  end)
  return candidates[1]
end

local function pickFriendTarget(minHp)
  if not cfg.useFriendList then return nil end
  if not cfg.friends or #cfg.friends == 0 then return nil end

  local friendSet = buildFriendSet()

  local candidates = collectCandidates(function(c)
    local name = c:getName()
    return name and friendSet[name] == true
  end, minHp)

  return chooseByPriorityOrRule(candidates, "FRIEND")
end

local function pickPartyTarget(minHp)
  if not cfg.useParty then return nil end

  local candidates = collectCandidates(function(c)
    return isPartyShield(c)
  end, minHp)

  return chooseByPriorityOrRule(candidates, "PARTY")
end

local function pickGuildTarget(minHp)
  if not cfg.useGuild then return nil end

  local candidates = collectCandidates(function(c)
    return isGuildCandidate(c)
  end, minHp)

  return chooseByPriorityOrRule(candidates, "GUILD")
end

macro(200, function()
  if not storage[switchSio] or storage[switchSio].enabled ~= true then return end

  local now = getMs()
  if (now - lastSioCastMs) < SIO_CD_MS then return end

  local minHp = clampHp(cfg.hpPercent)

  -- ORDEM: FRIEND -> PARTY -> GUILD
  local chosen = pickFriendTarget(minHp)
  if not chosen then chosen = pickPartyTarget(minHp) end
  if not chosen then chosen = pickGuildTarget(minHp) end
  if not chosen or not chosen.name then return end

  lastSioCastMs = now
  castSioOnName(chosen.name)
end)
