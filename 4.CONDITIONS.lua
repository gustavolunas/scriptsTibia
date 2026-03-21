setDefaultTab("LNS")

switchConditions = "conditionsButton"
local panelName = "conditionsInterface"

if not storage[panelName] then
  storage[panelName] = {
    switches = {},
    combos   = {},
    texts    = {}
  }
end

if not storage[switchConditions] then
    storage[switchConditions] = { enabled = false }
end

conditionsButton = setupUI([[
Panel
  height: 18
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: CONDITIONS
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
conditionsButton:setId(switchConditions)
conditionsButton.title:setOn(storage[switchConditions].enabled)

conditionsButton.title.onClick = function(widget)
    newState = not widget:isOn()
    widget:setOn(newState)
    storage[switchConditions].enabled = newState
end

conditionsInterface = setupUI([[
UIWindow
  id: mainPanel
  size: 320 385
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
    text: LNS Custom | Perfect Conditions
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
    id: infolist1
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 10
    margin-left: 10
    margin-right: 10
    text: SPEEDS & BUFFS
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f
    color: gray

  Panel
    id: cardsRow
    anchors.top: infolist1.bottom
    anchors.left: infolist1.left
    anchors.right: infolist1.right
    margin-top: 2
    height: 125
    background-color: alpha

  Panel
    id: cardSpeed
    anchors.top: cardsRow.top
    anchors.left: cardsRow.left
    anchors.right: cardsRow.right
    height: 125
    background-color: #1b1b1b
    opacity: 0.95
    border: 1 #3b2a10
    
  Panel
    id: rowHaste
    anchors.top: cardSpeed.top
    anchors.left: cardSpeed.left
    anchors.right: cardSpeed.right
    height: 28
    margin-top: 8
    background-color: alpha

  BotSwitch
    id: spellHaste
    anchors.left: rowHaste.left
    anchors.verticalCenter: rowHaste.verticalCenter
    margin-left: 8
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblHaste
    anchors.left: spellHaste.right
    anchors.verticalCenter: spellHaste.verticalCenter
    margin-left: 8
    text: HASTE
    font: verdana-9px
    color: #d7c08a

  ComboBox
    id: comboHaste
    anchors.right: rowHaste.right
    anchors.verticalCenter: rowHaste.verticalCenter
    margin-right: 8
    width: 150
    image-color: #2f2f2f
    font: verdana-9px
    @onSetup: |
      self:addOption("")
      self:addOption("Utani Hur")
      self:addOption("Utani Gran Hur")
      self:addOption("Utani Tempo Hur")

  Panel
    id: rowBuff
    anchors.top: rowHaste.bottom
    anchors.left: cardSpeed.left
    anchors.right: cardSpeed.right
    height: 28
    margin-top: 0
    background-color: alpha

  BotSwitch
    id: spellBuff
    anchors.left: rowBuff.left
    anchors.verticalCenter: rowBuff.verticalCenter
    margin-left: 8
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblBuff
    anchors.left: spellBuff.right
    anchors.verticalCenter: spellBuff.verticalCenter
    margin-left: 8
    text: BUFF
    font: verdana-9px
    color: #d7c08a

  ComboBox
    id: comboBuff
    anchors.right: rowBuff.right
    anchors.verticalCenter: rowBuff.verticalCenter
    margin-right: 8
    width: 150
    font: verdana-9px
    image-color: #2f2f2f
    @onSetup: |
      self:addOption("")
      self:addOption("Utito Tempo")
      self:addOption("Utamo Tempo")
      self:addOption("Utito Tempo San")

  Panel
    id: rowAntiLyze
    anchors.top: rowBuff.bottom
    anchors.left: cardSpeed.left
    anchors.right: cardSpeed.right
    height: 28
    margin-top: 0
    background-color: alpha

  BotSwitch
    id: spellAntilyze
    anchors.left: rowAntiLyze.left
    anchors.verticalCenter: rowAntiLyze.verticalCenter
    margin-left: 8
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblAntiLyze
    anchors.left: spellAntilyze.right
    anchors.verticalCenter: spellAntilyze.verticalCenter
    margin-left: 8
    text: ANTILYZE
    font: verdana-9px
    color: #d7c08a

  TextEdit
    id: comboAntilyze
    anchors.right: rowAntiLyze.right
    anchors.verticalCenter: rowAntiLyze.verticalCenter
    margin-right: 8
    width: 150
    height: 20
    image-color: #2f2f2f
    font: verdana-9px
    color: white
    placeholder: INSERT ANTI-LYZE SPELL
    placeholder-font: verdana-9px

  Panel
    id: rowUtura
    anchors.top: rowAntiLyze.bottom
    anchors.left: cardSpeed.left
    anchors.right: cardSpeed.right
    height: 28
    margin-top: 0
    background-color: alpha

  BotSwitch
    id: spellUtura
    anchors.left: rowUtura.left
    anchors.verticalCenter: rowUtura.verticalCenter
    margin-left: 8
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblUtura
    anchors.left: spellUtura.right
    anchors.verticalCenter: spellUtura.verticalCenter
    margin-left: 8
    text: UTURA GRAN
    font: verdana-9px
    color: #d7c08a

  TextEdit
    id: textUturaGran
    anchors.right: rowUtura.right
    anchors.verticalCenter: rowUtura.verticalCenter
    margin-right: 8
    width: 150
    height: 20
    image-color: #2f2f2f
    font: verdana-9px
    color: white
    placeholder: INSERT UTURA SPELL
    placeholder-font: verdana-9px

  Panel
    id: infolist2
    anchors.top: cardsRow.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 10
    margin-left: 10
    margin-right: 10
    text: TOOLS CONFIGURATIONS
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f
    color: gray

  Panel
    id: actions
    anchors.top: infolist2.bottom
    anchors.left: infolist2.left
    anchors.right: infolist2.right
    anchors.bottom: parent.bottom
    margin-bottom: 10
    margin-top: 2
    background-color: #141414
    opacity: 0.92
    border: 1 #3b2a10

  Panel
    id: rowUtamo
    anchors.top: actions.top
    anchors.left: actions.left
    anchors.right: actions.right
    height: 28
    margin-top: 5
    background-color: alpha

  BotSwitch
    id: spellUtamo
    anchors.left: rowUtamo.left
    anchors.verticalCenter: rowUtamo.verticalCenter
    margin-left: 8
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    $on: 
      image-color: green
    $!on:
      image-color: #2a2a2a

  Label
    id: lblUtamo
    anchors.left: spellUtamo.right
    anchors.verticalCenter: spellUtamo.verticalCenter
    margin-left: 10
    text: AUTO MAGIC SHIELD
    font: verdana-9px
    color: #d7c08a

  Panel
    id: rowUtana
    anchors.top: rowUtamo.bottom
    anchors.left: actions.left
    anchors.right: actions.right
    height: 28
    margin-top: 0
    background-color: alpha

  BotSwitch
    id: spellUtana
    anchors.left: rowUtana.left
    anchors.verticalCenter: rowUtana.verticalCenter
    margin-left: 8
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $on:
      image-color: green
      opacity: 1.00
    $!on:
      image-color: #2a2a2a
      opacity: 0.95

  Label
    id: lblUtana
    anchors.left: spellUtana.right
    anchors.verticalCenter: spellUtana.verticalCenter
    margin-left: 10
    text: AUTO INVISIBLE
    font: verdana-9px
    color: #d7c08a

  Panel
    id: rowExetaRes
    anchors.top: rowUtana.bottom
    anchors.left: actions.left
    anchors.right: actions.right
    height: 28
    margin-top: 0
    background-color: alpha

  BotSwitch
    id: exetaRes
    anchors.left: rowExetaRes.left
    anchors.verticalCenter: rowExetaRes.verticalCenter
    margin-left: 8
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    $on:
      image-color: green
      opacity: 1.00
    $!on:
      image-color: #2a2a2a
      opacity: 0.95

  Label
    id: lblExetaRes
    anchors.left: exetaRes.right
    anchors.verticalCenter: exetaRes.verticalCenter
    margin-left: 10
    text: EXETA RES
    font: verdana-9px
    color: #d7c08a

  Panel
    id: rowAmpRes
    anchors.top: rowExetaRes.bottom
    anchors.left: actions.left
    anchors.right: actions.right
    height: 28
    margin-top: 0
    background-color: alpha

  BotSwitch
    id: exetaAmpRes
    anchors.left: rowAmpRes.left
    anchors.verticalCenter: rowAmpRes.verticalCenter
    margin-left: 8
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    $on:
      image-color: green
      opacity: 1.00
    $!on:
      image-color: #2a2a2a
      opacity: 0.95
  Label
    id: lblAmpRes
    anchors.left: exetaAmpRes.right
    anchors.verticalCenter: exetaAmpRes.verticalCenter
    margin-left: 10
    text: AMP RES
    font: verdana-9px
    color: #d7c08a

  TextEdit
    id: textAmpRes
    anchors.right: rowAmpRes.right
    anchors.verticalCenter: rowAmpRes.verticalCenter
    margin-right: 8
    width: 150
    height: 20
    image-color: #2f2f2f
    font: verdana-9px
    color: white
    placeholder: INSERT AMP RES SPELL
    placeholder-font: verdana-9px

  Panel
    id: rowExetaLoot
    anchors.top: rowAmpRes.bottom
    anchors.left: actions.left
    anchors.right: actions.right
    height: 28
    margin-top: 0
    background-color: alpha

  BotSwitch
    id: exetaLoot
    anchors.left: rowExetaLoot.left
    anchors.verticalCenter: rowExetaLoot.verticalCenter
    margin-left: 8
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    $on:
      image-color: green
      opacity: 1.00
    $!on:
      image-color: #2a2a2a
      opacity: 0.95

  Label
    id: lblExetaLoot
    anchors.left: exetaLoot.right
    anchors.verticalCenter: exetaLoot.verticalCenter
    margin-left: 10
    text: EXETA LOOT
    font: verdana-9px
    color: #d7c08a

  BotSwitch
    id: cureStatus
    anchors.left: exetaLoot.left
    anchors.top: exetaLoot.bottom
    margin-top: 7
    width: 22
    height: 22
    text: ""
    image-source: /images/ui/button_rounded
    $on:
      image-color: green
      opacity: 1.00
    $!on:
      image-color: #2a2a2a
      opacity: 0.95

  Label
    id: lblCureStatus
    anchors.left: cureStatus.right
    anchors.verticalCenter: cureStatus.verticalCenter
    margin-left: 10
    text: CURE STATUS
    font: verdana-9px
    color: #d7c08a

]], g_ui.getRootWidget())

conditionsInterface:hide()
conditionsInterface.closePanel.onClick = function()
  conditionsInterface:hide()
end

function buttonsConditionsPcMobile()
  if modules._G.g_app.isMobile() then
    conditionsButton.settings:show()
    conditionsButton.title:setMarginRight(55)
  else
    conditionsButton.settings:hide()
    conditionsButton.title:setMarginRight(0)
  end
end
buttonsConditionsPcMobile()

conditionsButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not conditionsInterface:isVisible() then
      conditionsInterface:show()
      conditionsInterface:raise();
      conditionsInterface:focus();
    else
      conditionsInterface:hide()
    end
  end
end

conditionsButton.settings.onClick = function()
    if not conditionsInterface:isVisible() then
        conditionsInterface:show()
        conditionsInterface:raise()
        conditionsInterface:focus()
    end
end

storage = storage or {}
storage[panelName] = storage[panelName] or {}
if storage[panelName].switches == nil and type(storage[panelName].checks) == "table" then
  storage[panelName].switches = storage[panelName].checks
  storage[panelName].checks = nil
end

storage[panelName].switches = storage[panelName].switches or {}
storage[panelName].combos   = storage[panelName].combos   or {}
storage[panelName].texts    = storage[panelName].texts    or {}

local function bindSwitch(id)
  local w = conditionsInterface[id]
  if not w then return end

  storage[panelName].switches = storage[panelName].switches or {}

  -- carregar estado salvo
  if storage[panelName].switches[id] ~= nil then
    w:setOn(storage[panelName].switches[id] and true or false)
  else
    storage[panelName].switches[id] = w:isOn() and true or false
  end

  -- toggle manual (garante ficar verde)
  w.onClick = function(widget)
    widget:setOn(not widget:isOn())
    storage[panelName].switches[id] = widget:isOn() and true or false
  end
end

local function bindCombo(id)
  local combo = conditionsInterface[id]
  if not combo then return end

  if storage[panelName].combos[id] ~= nil then
    combo:setCurrentOption(storage[panelName].combos[id])
  else
    storage[panelName].combos[id] = combo:getCurrentOption()
  end

  combo.onOptionChange = function(widget, option)
    storage[panelName].combos[id] = option
  end
end

local function bindText(id)
  local w = conditionsInterface[id]
  if not w then return end

  if storage[panelName].texts[id] ~= nil then
    w:setText(tostring(storage[panelName].texts[id]))
  else
    storage[panelName].texts[id] = w:getText() or ""
  end

  w.onTextChange = function(widget, text)
    storage[panelName].texts[id] = tostring(text or "")
  end
end

-- SPEED & BUFFS
bindSwitch("spellHaste")
bindCombo("comboHaste")

bindSwitch("spellBuff")
bindCombo("comboBuff")

bindSwitch("spellAntilyze")
bindText("comboAntilyze")

bindSwitch("spellUtura")
bindText("textUturaGran")

bindSwitch("spellUtamo")
bindSwitch("spellUtana")
bindSwitch("exetaRes")
bindSwitch("exetaAmpRes")
bindText("textAmpRes")
bindSwitch("exetaLoot")
bindSwitch("cureStatus")

-- =========================
-- CONDITIONS (BotSwitch)
-- =========================
local switchConditions = "conditionsButton"
local panelName = "conditionsInterface"

storage = storage or {}
storage[switchConditions] = storage[switchConditions] or { enabled = false }
storage[panelName] = storage[panelName] or {}

-- MIGRAÇÃO: checks -> switches (se tiver storage antigo)
if storage[panelName].switches == nil and type(storage[panelName].checks) == "table" then
  storage[panelName].switches = storage[panelName].checks
  storage[panelName].checks = nil
end

storage[panelName].switches = storage[panelName].switches or {}
storage[panelName].combos   = storage[panelName].combos   or {}
storage[panelName].texts    = storage[panelName].texts    or {}

-- =========================
-- Timers via onTalk
-- =========================
local userUturaTimer = 0
local userBuffTimer  = 0

onTalk(function(name, level, mode, text, channelId, pos)
  text = text:lower()
  if name ~= player:getName() then return end

  -- BUFF (combo é valor único, não tabela)
  local buffSpell = storage[panelName].combos["comboBuff"]
  if buffSpell and text == tostring(buffSpell):lower() then
    userBuffTimer = now + 10000
  end

  -- UTURA (text é string, não tabela)
  local uturaSpell = storage[panelName].texts["textUturaGran"]
  if uturaSpell and text == tostring(uturaSpell):lower() then
    userUturaTimer = now + 60500
  end
end)

local function _trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

-- =========================
-- Moving detector (pra haste)
-- =========================
local _lastMovePos = nil
local _lastMoveMs  = 0

local function isMovingRecently(ms)
  ms = ms or 250
  local p = pos()
  if not p then return false end

  if not _lastMovePos then
    _lastMovePos = {x=p.x, y=p.y, z=p.z}
    return false
  end

  if p.x ~= _lastMovePos.x or p.y ~= _lastMovePos.y or p.z ~= _lastMovePos.z then
    _lastMovePos = {x=p.x, y=p.y, z=p.z}
    _lastMoveMs = now
    return true
  end

  return (_lastMoveMs > 0 and (now - _lastMoveMs) <= ms)
end

-- =========================
-- SPEED & BUFFS macro
-- =========================
macro(200, function()
  if not storage[switchConditions] or not storage[switchConditions].enabled then return end

  local player = g_game.getLocalPlayer()
  if not player or player:isNpc() then return end

  local cfg = storage[panelName]
  if not cfg or not cfg.switches then return end

  local sw = cfg.switches
  local combos = cfg.combos or {}
  local texts  = cfg.texts  or {}

  -- AntiLyze
  if sw["spellAntilyze"] then
    if isParalyzed() then
      local spell = _trim(texts["comboAntilyze"])
      if spell ~= "" then
        say(spell)
        return
      end
    end
  end

  if sw["spellHaste"] then
    if not hasHaste() and not isParalyzed() then
      if isInPz() then return end
      if not isMovingRecently(250) then return end

      local spell = _trim(combos["comboHaste"])
      if spell ~= "" then
        say(spell)
      end
    end
  end

  -- Buff (agora respeita o timer do onTalk)
  if sw["spellBuff"] then
    if userBuffTimer and userBuffTimer >= now then return end
    if g_game.isAttacking() then
      local spell = _trim(combos["comboBuff"])
      if spell ~= "" then
        say(spell)
      end
    end
  end

  if sw["spellUtura"] then
    if userUturaTimer and userUturaTimer >= now then return end
    if player:getMana() >= 200 then
      local spell = _trim(texts["textUturaGran"])
      if spell == "" then spell = "utura gran" end
      say(spell)
    end
  end
end)

-- =========================
-- CURE STATUS (um BotSwitch único: cureStatus)
-- =========================
macro(200, function()
  if not storage[switchConditions] or not storage[switchConditions].enabled then return end

  local cfg = storage[panelName]
  if not cfg or not cfg.switches then return end
  if not cfg.switches["cureStatus"] then return end

  if g_game.isAttacking() then return; end

  -- Mantive as mesmas spells (tudo junto num único switch)
  if isPoisioned() then
    say('exana pox')
    return
  end

  if isBurning() then
    say('exana flam')
    return
  end

  if isEnergized() then
    say('exana vis')
    return
  end

  if isCursed() then
    say('exana mort')
    return
  end

  if isBleeding() then
    say('exana kor')
    return
  end
end)

-- =========================
-- UTAMO (switch spellUtamo)
-- =========================
macro(200, function()
  if not storage[switchConditions] or not storage[switchConditions].enabled then return end

  local cfg = storage[panelName]
  if not cfg or not cfg.switches then return end
  if not cfg.switches["spellUtamo"] then return end

  if not hasManaShield() then
    say("utamo vita")
  end
end)

-- =========================
-- UTANA (switch spellUtana)
-- =========================
local utanaCast = 0
macro(200, function()
  if not storage[switchConditions] or not storage[switchConditions].enabled then return end

  local cfg = storage[panelName]
  if not cfg or not cfg.switches then return end
  if not cfg.switches["spellUtana"] then return end

  if mana() < 441 then return end
  if utanaCast > 0 and (now - utanaCast < 120000) then return end

  say("utana vid")
  utanaCast = now
end)

-- =========================
-- EXETA RES (switch exetaRes) - 1 SQM
-- =========================
onTalk(function(name, level, mode, text, channelId, pos)
  text = text:lower();
  if name ~= player:getName() then return; end
  if text == 'Exeta Res' or text == 'exeta res' then
    exetaSlow = now + 1900
  end
end)

macro(200, function()
  if not storage[switchConditions] or not storage[switchConditions].enabled then return end

  local cfg = storage[panelName]
  if not cfg or not cfg.switches or not cfg.switches["exetaRes"] then return end

  if isInPz() or not g_game.isAttacking() then return end
  if exetaSlow and exetaSlow >= now then return; end

  local me = g_game.getLocalPlayer()
  local target = g_game.getAttackingCreature()
  if not me or not target then return end

  local p = me:getPosition()
  local t = target:getPosition()
  if not p or not t or p.z ~= t.z then return end

  if math.max(math.abs(p.x - t.x), math.abs(p.y - t.y)) ~= 1 then return end

  say("exeta res")
  delay(1000)
end)

-- =========================
-- EXETA AMP RES (switch exetaAmpRes) - TextEdit textAmpRes
-- =========================
local lastExetaAmpRes = 0
local exetaAmpResCooldown = 6000

macro(200, function()
  if not storage[switchConditions] or not storage[switchConditions].enabled then return end

  local cfg = storage[panelName]
  if not cfg or not cfg.switches or not cfg.switches["exetaAmpRes"] then return end

  if isInPz() then return end
  if not g_game.isAttacking() then return end
  if now - lastExetaAmpRes < exetaAmpResCooldown then return end

  local spell = cfg.texts and cfg.texts["textAmpRes"]
  spell = _trim(spell)
  if spell == "" then spell = "exeta amp res" end

  say(spell)
  lastExetaAmpRes = now
  delay(1000)
end)

-- =========================
-- EXETA LOOT (switch exetaLoot)
-- =========================
local exetaLootDelay = 1000

local nextExeta = 0
onCreatureDisappear(function(creature)
  if not storage[switchConditions] or not storage[switchConditions].enabled then return end
  if nextExeta > now  then return end
  if isInPz() then return end
  if not creature:isMonster() then return end

  local pos = player:getPosition()
  local mpos = creature:getPosition()
  local name = creature:getName()

  if pos.z ~= mpos.z or getDistanceBetween(pos, mpos) > 1 then return end

  schedule(100, function()
    local tile = g_map.getTile(mpos)
    if not tile then return end

    local container = tile:getTopUseThing()
    if not container or not container:isContainer() then return end

    nextExeta = now + exetaLootDelay
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
    say("exeta loot")
  end)
end)
