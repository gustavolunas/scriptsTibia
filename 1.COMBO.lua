setDefaultTab("LNS")

local switchCombo = "comboButton"

if not storage[switchCombo] then
    storage[switchCombo] = { enabled = false }
end

comboButton = setupUI([[
Panel
  height: 18
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: ATTACKBOT
    font: verdana-9px
    image-source: /images/ui/button_rounded
    color: white
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
comboButton:setId(switchCombo)
comboButton.title:setOn(storage[switchCombo].enabled)

comboButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchCombo].enabled = newState
end

comboInterface = setupUI([=[
UIWindow
  id: mainPanel
  size: 350 410
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
    text: LNS Custom | Combat AI
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
    id: iconPanel
    anchors.top: parent.top
    anchors.left: parent.left
    size: 60 60
    margin-top: -19
    margin-left: -15

  Panel
    id: cardsRow
    anchors.top: topBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 8
    margin-left: 10
    margin-right: 10
    height: 150
    background-color: alpha

  Panel
    id: cardSpells
    anchors.top: cardsRow.top
    anchors.left: cardsRow.left
    anchors.right: cardsRow.right
    height: 150
    opacity: 0.95
    border: 1 alpha

  TextList
    id: spellList
    anchors.top: cardSpells.top
    anchors.left: cardSpells.left
    anchors.right: cardSpells.right
    margin-top: 0
    margin-left: 0
    margin-right: 12
    height: 120
    padding: 1
    vertical-scrollbar: spellListScrollBar
    image-color: #1b1b1b
    opacity: 0.95
    border: 1 #3b2a10

  VerticalScrollBar
    id: spellListScrollBar
    anchors.top: spellList.top
    anchors.bottom: spellList.bottom
    anchors.left: spellList.right
    step: 10
    pixels-scroll: true
    visible: true
    border: 1 #1f1f1f
    image-color: #363636
    opacity: 0.90
    margin-left: 0

  Panel
    id: spellsButtonsRow
    anchors.left: cardSpells.left
    anchors.right: cardSpells.right
    anchors.bottom: cardSpells.bottom
    height: 30
    margin-bottom: 3
    background-color: alpha

  Button
    id: adicionarSpell
    anchors.left: spellsButtonsRow.left
    anchors.verticalCenter: spellsButtonsRow.verticalCenter
    margin-left: 0
    image-source: /images/ui/button_rounded
    size: 110 22
    image-color: #2a2a2a
    text: ADICIONAR SPELL
    font: verdana-9px
    color: #b9b9b9

  Button
    id: adicionarRuna
    anchors.left: adicionarSpell.right
    anchors.verticalCenter: adicionarSpell.verticalCenter
    margin-left: 3
    image-source: /images/ui/button_rounded
    size: 110 22
    image-color: #2a2a2a
    text: ADICIONAR RUNA
    font: verdana-9px
    color: #b9b9b9

  Button
    id: moveDown
    anchors.right: spellsButtonsRow.right
    anchors.verticalCenter: spellsButtonsRow.verticalCenter
    margin-right: 0
    image-source: /images/ui/button_rounded
    size: 28 22
    image-color: #2a2a2a
    text: \/
    font: verdana-9px
    color: #b9b9b9

  Button
    id: moveUp
    anchors.right: moveDown.left
    anchors.verticalCenter: moveDown.verticalCenter
    margin-right: 1
    image-source: /images/ui/button_rounded
    size: 28 22
    image-color: #2a2a2a
    text: /\
    font: verdana-9px
    color: #b9b9b9

  Panel
    id: infolist2
    anchors.top: cardsRow.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 0
    margin-left: 10
    margin-right: 10
    text: ANTI-RED & TOOLS
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f
    color: #d7c08a
    text-auto-resize: true

  Panel
    id: actions
    anchors.top: infolist2.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-bottom: 10
    margin-left: 10
    margin-right: 10
    margin-top: 2
    background-color: #141414
    opacity: 0.92
    border: 1 #3b2a10

  Panel
    id: panelTools
    anchors.top: infolist2.bottom
    anchors.left: actions.left
    anchors.right: actions.right
    anchors.bottom: actions.bottom
    margin-top: 6
    margin-left: 0
    margin-right: 0
    margin-bottom: 0
    background-color: alpha

  Panel
    id: rowSqm
    anchors.top: panelTools.top
    anchors.left: panelTools.left
    anchors.right: panelTools.right
    height: 30
    background-color: alpha

  Label
    id: labelSqm
    anchors.left: rowSqm.left
    anchors.verticalCenter: rowSqm.verticalCenter
    margin-left: 10
    text: REALIZAR CHECAGEM DE SQMS
    font: verdana-9px
    color: #d7c08a
    text-auto-resize: true

  SpinBox
    id: sqmSafe
    anchors.right: rowSqm.right
    anchors.verticalCenter: rowSqm.verticalCenter
    margin-right: 10
    size: 62 22
    minimum: 1
    maximum: 10
    step: 1
    image-color: #2f2f2f
    color: white
    font: verdana-9px

  Panel
    id: rowVirar
    anchors.top: rowSqm.bottom
    anchors.left: panelTools.left
    anchors.right: panelTools.right
    margin-top: -5
    height: 30
    background-color: alpha

  BotSwitch
    id: virarTarget
    anchors.left: rowVirar.left
    anchors.verticalCenter: rowVirar.verticalCenter
    margin-left: 10
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
    id: labelVirarTgt
    anchors.left: virarTarget.right
    anchors.verticalCenter: virarTarget.verticalCenter
    margin-left: 10
    text: VIRAR DIRECAO TARGET
    font: verdana-9px
    color: #d7c08a
    text-auto-resize: true

  Panel
    id: rowDist
    anchors.top: rowVirar.bottom
    anchors.left: panelTools.left
    anchors.right: panelTools.right
    height: 30
    background-color: alpha

  BotSwitch
    id: manterDist
    anchors.left: rowDist.left
    anchors.verticalCenter: rowDist.verticalCenter
    margin-left: 10
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
    id: lblManterDist
    anchors.left: manterDist.right
    anchors.verticalCenter: manterDist.verticalCenter
    margin-left: 10
    text: MANTER DISTANCIA
    font: verdana-9px
    color: #d7c08a
    text-auto-resize: true

  Panel
    id: rowPlayers
    anchors.top: rowDist.bottom
    anchors.left: panelTools.left
    anchors.right: panelTools.right
    height: 30
    background-color: alpha

  BotSwitch
    id: IgnoreParty
    anchors.left: rowPlayers.left
    anchors.verticalCenter: rowPlayers.verticalCenter
    margin-left: 10
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
    id: lblIgnoreParty
    anchors.left: IgnoreParty.right
    anchors.verticalCenter: IgnoreParty.verticalCenter
    margin-left: 10
    text: CHECAR PLAYERS
    font: verdana-9px
    color: #d7c08a
    text-auto-resize: true

  Panel
    id: rowStairs
    anchors.top: rowPlayers.bottom
    anchors.left: panelTools.left
    anchors.right: panelTools.right
    height: 30
    background-color: alpha

  BotSwitch
    id: CheckStairs
    anchors.left: rowStairs.left
    anchors.verticalCenter: rowStairs.verticalCenter
    margin-left: 10
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
    id: lblCheckStairs
    anchors.left: CheckStairs.right
    anchors.verticalCenter: CheckStairs.verticalCenter
    margin-left: 10
    text: CHECAR STAIRS
    font: verdana-9px
    color: #d7c08a
    text-auto-resize: true

  Panel
    id: idsSafeAndares
    anchors.top: prev.bottom
    margin-top: 10
    anchors.left: panelTools.left
    anchors.right: panelTools.right
    anchors.bottom: panelTools.bottom
    margin-left: 10
    margin-right: 10
    margin-bottom: 10
    height: 74
    background-color: alpha

]=], g_ui.getRootWidget())
comboInterface:hide();

comboInterface.closePanel.onClick = function()
  comboInterface:hide()
end

function buttonsComboPcMobile()
  if modules._G.g_app.isMobile() then
    comboButton.settings:show()
    comboButton.title:setMarginRight(55)
  else
    comboButton.settings:hide()
    comboButton.title:setMarginRight(0)
  end
end
buttonsComboPcMobile()

comboButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not comboInterface:isVisible() then
      comboInterface:show()
      comboInterface:raise();
      comboInterface:focus();
    else
      comboInterface:hide()
    end
  end
end

comboButton.settings.onClick = function()
    if not comboInterface:isVisible() then
        comboInterface:show()
        comboInterface:raise()
        comboInterface:focus()
    end
end

spellAddPanel = setupUI([=[
UIWindow
  id: spellAddPanel
  size: 260 290
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

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
    !text: tr('LNS Custom | Combat AI - Spell Add')
    font: verdana-11px-rounded
    color: orange
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f
  
  Panel
    id: iconPanel
    anchors.top: parent.top
    anchors.left: parent.left
    size: 60 60
    margin-top: -19
    margin-left: -15

  Panel
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: -7
    margin-right: 8
    margin-left: 8
    height: 225
    background-color: #1b1b1b
    opacity: 0.95
    border: 1 #3b2a10

    Label
      id: magiaLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      text-align: left
      text: SPELL:
      margin-left: 10
      margin-right: 10
      margin-top: 5
      text-auto-resize: true
      font: verdana-9px

    TextEdit
      id: magia
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      image-color: gray
      font: verdana-9px
      placeholder: INSERT SPELL HERE!
      placeholder-font: verdana-9px

    Label
      id: distanceLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      text-align: left
      text: DISTANCE:
      text-auto-resize: true
      font: verdana-9px

    HorizontalScrollBar
      id: distance
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: manaLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      text-align: left
      text: MANA:
      text-auto-resize: true
      font: verdana-9px

    HorizontalScrollBar
      id: mana
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 0
      maximum: 1000
      step: 10

    Label
      id: mobsLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      text-align: left
      text: MOBS:
      text-auto-resize: true
      font: verdana-9px

    HorizontalScrollBar
      id: mobs
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 10
      step: 1

    Label
      id: cdLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      text-align: left
      text: COOLDOWN:
      text-auto-resize: true
      font: verdana-9px

    HorizontalScrollBar
      id: cooldown
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-right: 10
      margin-top: 3
      minimum: 0
      maximum: 60000
      step: 1

    Button
      id: calculeCooldown
      anchors.top: prev.top
      anchors.left: prev.right
      text: !
      width: 10
      height: 13
      margin-left: 2
      font: verdana-11px-rounded

    CheckBox
      id: safe
      anchors.top: prev.bottom
      anchors.left: mobs.left
      anchors.right: mobs.right
      margin-top: 12
      text-align: left
      text: SPELL SAFE ?
      image-source: /images/ui/checkbox_round
      text-auto-resize: true
      font: verdana-9px

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    image-source: /images/ui/button_rounded
    size: 122 25
    margin-top: 2
    image-color: #363636
    text: CANCELAR
    font: verdana-9px
    color: gray
    $hover:
      color: #FF4040

  Button
    id: adicionarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    image-source: /images/ui/button_rounded
    size: 122 25
    margin-top: 2
    image-color: #363636
    text: ADICIONAR
    font: verdana-9px
    color: gray
    $hover:
      color: #98FB98

]=], g_ui.getRootWidget())
spellAddPanel:show()

runeAddPanel = setupUI([=[
UIWindow
  id: runeAddPanel
  size: 220 208
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

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
    !text: tr('LNS Custom | Combat AI - Rune')
    color: orange
    font: verdana-11px-rounded
    color: orange
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f
  
  Panel
    id: iconPanel
    anchors.top: parent.top
    anchors.left: parent.left
    size: 60 60
    margin-top: -19
    margin-left: -15

  Panel
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: -7
    margin-right: 8
    margin-left: 8
    height: 145
    background-color: #1b1b1b
    opacity: 0.95
    border: 1 #3b2a10

    Label
      id: runaLabel
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      text-align: left
      text: ID RUNA:
      margin-left: 10
      margin-right: 10
      margin-top: 18
      text-auto-resize: true
      font: verdana-9px

    BotItem
      id: runa
      anchors.top: prev.top
      anchors.right: parent.right
      margin-right: 10
      margin-top: -5
      image-source: /images/ui/item-blessed

    Label
      id: distanceLabel
      anchors.top: prev.bottom
      anchors.left: runaLabel.left
      anchors.right: parent.right
      margin-top: 2
      margin-right: 10
      text-align: left
      text: DISTANCE:
      text-auto-resize: true
      font: verdana-9px

    HorizontalScrollBar
      id: distance
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 12
      step: 1

    Label
      id: mobsLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      text-align: left
      text: MOBS:
      text-auto-resize: true
      font: verdana-9px

    HorizontalScrollBar
      id: mobs
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 3
      minimum: 1
      maximum: 10
      step: 1

    Label
      id: cdLabel
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 10
      text-align: left
      text: COOLDOWN:
      text-auto-resize: true
      font: verdana-9px
      visible: false

    HorizontalScrollBar
      id: cooldown
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-right: 10
      margin-top: 3
      minimum: 0
      maximum: 5000
      step: 1
      visible: false

    Button
      id: calculeCooldown
      anchors.top: prev.top
      anchors.left: prev.right
      text: !
      width: 10
      height: 13
      margin-left: 2
      font: verdana-11px-rounded
      visible: false

    CheckBox
      id: safe
      anchors.top: mobs.bottom
      anchors.left: mobs.left
      anchors.right: mobs.right
      margin-top: 12
      text-align: left
      text: RUNA SAFE?
      image-source: /images/ui/checkbox_round
      text-auto-resize: true
      font: verdana-9px

  Button
    id: cancelarBt
    anchors.left: panelMain.left
    anchors.top: panelMain.bottom
    image-source: /images/ui/button_rounded
    size: 102 25
    margin-top: 2
    image-color: #363636
    text: CANCELAR
    font: verdana-9px
    color: gray
    $hover:
      color: #FF4040

  Button
    id: adicionarBt
    anchors.right: panelMain.right
    anchors.top: panelMain.bottom
    image-source: /images/ui/button_rounded
    size: 102 25
    margin-top: 2
    image-color: #363636
    text: ADICIONAR
    font: verdana-9px
    color: gray
    $hover:
      color: #98FB98

]=], g_ui.getRootWidget())
runeAddPanel:hide()

local STORAGE_KEY = "combo_actions_global_v1"
local MANAGER_SYNC_KEY = "combo_manager_sync_v1"
storage[MANAGER_SYNC_KEY] = storage[MANAGER_SYNC_KEY] or { rev = 0 }
local lastManagerSyncRev = storage[MANAGER_SYNC_KEY].rev or 0
-- =========================================================
-- UTIL
-- =========================================================
local function deepCopy(t)
  if type(t) ~= "table" then return t end
  local r = {}
  for k, v in pairs(t) do r[k] = deepCopy(v) end
  return r
end

local function clamp(n, a, b)
  n = tonumber(n) or a
  if n < a then return a end
  if n > b then return b end
  return n
end

local function trim(s)
  s = tostring(s or "")
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function isEmpty(s) return trim(s) == "" end

local function W(root, id)
  if not root then return nil end
  if root.recursiveGetChildById then return root:recursiveGetChildById(id) end
  if root.getChildById then return root:getChildById(id) end
  return nil
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

local function msToSecText(ms)
  ms = tonumber(ms) or 0
  return string.format("%.1f", ms / 1000)
end

local function nowMs()
  if type(now) == "number" then return now end
  if g_clock and g_clock.millis then return g_clock.millis() end
  return (os.time() * 1000) + math.floor((os.clock() * 1000) % 1000)
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

-- =========================================================
-- DEFAULT CFG
-- =========================================================
local function defaultCfg()
  return {
    main = {
      enabled = true,
      virarTarget = false,
      manterDist  = false,
      checkStairs = false,
      ignoreParty = false,
      checkAndares = false,
      sqmSafe = 5,
    },
    actions = {
    },
    draft = {
      spell = { cd = 0 },
      rune  = { cd = 0, id = 0 },
    }
  }
end

local function mergeDefaults(dst, def)
  if type(dst) ~= "table" then dst = {} end
  for k,v in pairs(def) do
    if dst[k] == nil then
      dst[k] = deepCopy(v)
    elseif type(v) == "table" and type(dst[k]) == "table" then
      dst[k] = mergeDefaults(dst[k], v)
    end
  end
  return dst
end

-- init storage global
storage[STORAGE_KEY] = mergeDefaults(storage[STORAGE_KEY], defaultCfg())
local cfg = storage[STORAGE_KEY]

cfg.main.safeIdsAndares = settings.combo.safeIdsAndares

if type(cfg.actions) ~= "table" then cfg.actions = {} end
cfg.draft = cfg.draft or { spell = { cd = 0 }, rune = { cd = 0 } }
cfg.draft.spell = cfg.draft.spell or { cd = 0 }
cfg.draft.rune = cfg.draft.rune or { cd = 0, id = 0 }
if cfg.draft.rune.id == nil then cfg.draft.rune.id = 0 end

-- migração simples (se você tinha cfg.spells antes)
if cfg.spells and type(cfg.spells) == "table" and #cfg.actions == 0 then
  for _, sp in ipairs(cfg.spells) do
    table.insert(cfg.actions, {
      type="spell",
      enabled = (sp.enabled ~= false),
      spell = tostring(sp.spell or ""),
      dist = tonumber(sp.dist or 1) or 1,
      mana = tonumber(sp.mana or 0) or 0,
      mobs = tonumber(sp.mobs or 0) or 0,
      cd   = tonumber(sp.cd or 0) or 0,
      safe = sp.safe and true or false
    })
  end
  cfg.spells = nil
end

-- =========================================================
-- UI refs (assume que comboInterface/spellAddPanel/runeAddPanel já existem)
-- =========================================================
local ui   = comboInterface
local spUI = spellAddPanel
local rnUI = runeAddPanel

local spellList   = ui.spellList
local addSpellBtn = ui.adicionarSpell
local addRuneBtn  = ui.adicionarRuna
local upBtn       = ui.moveUp
local downBtn     = ui.moveDown

local virarTarget = ui.virarTarget
local manterDist  = ui.manterDist
local checkStairs = ui.CheckStairs
local ignoreParty = ui.IgnoreParty
local checkAndares    = ui.checkAndares
local sqmSafe     = ui.sqmSafe
local idsSafePanel= ui.idsSafeAndares

local sp_spell    = W(spUI, "magia")
local sp_dist     = W(spUI, "distance")
local sp_mana     = W(spUI, "mana")
local sp_mobs     = W(spUI, "mobs")
local sp_cd       = W(spUI, "cooldown")
local sp_safe     = W(spUI, "safe")
local sp_cancel   = W(spUI, "cancelarBt")
local sp_add      = W(spUI, "adicionarBt")
local sp_dLbl     = W(spUI, "distanceLabel")
local sp_mLbl     = W(spUI, "manaLabel")
local sp_mbLbl    = W(spUI, "mobsLabel")
local sp_cdLbl    = W(spUI, "cdLabel")
local sp_calcBtn  = W(spUI, "calculeCooldown")

local function getBotItemId(w)
  if not w then return 0 end
  if w.getItemId then
    local id = tonumber(w:getItemId()) or 0
    return id
  end

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
  if w.setItem and Item and Item.create then
    if id > 0 then
      w:setItem(Item.create(id, 1))
    end
  end
end

local rn_id       = W(rnUI, "runa")
if rn_id and rn_id.onItemChange then
  rn_id.onItemChange = function(widget)
    cfg.draft.rune.id = getBotItemId(widget)
  end
end

local rn_dist     = W(rnUI, "distance")
local rn_mobs     = W(rnUI, "mobs")
local rn_cd       = W(rnUI, "cooldown")
local rn_safe     = W(rnUI, "safe")
local rn_cancel   = W(rnUI, "cancelarBt")
local rn_add      = W(rnUI, "adicionarBt")
local rn_dLbl     = W(rnUI, "distanceLabel")
local rn_mbLbl    = W(rnUI, "mobsLabel")
local rn_cdLbl    = W(rnUI, "cdLabel")
local rn_calcBtn  = W(rnUI, "calculeCooldown")

-- =========================================================
-- Safe IDs Andares (BotContainer) -> cfg.main.safeIdsAndares
-- =========================================================
local idsSafeContainer = UI.ContainerEx(function(widget, items)
  local cleanItems = normalizeContainerItems(items)

  cfg.main.safeIdsAndares = cleanItems

  settings = loadSettings()
  settings.combo = settings.combo or {}
  settings.combo.safeIdsAndares = cleanItems

  saveSettings(settings)
end, true, idsSafePanel)

idsSafeContainer:setParent(idsSafePanel)
idsSafeContainer:fill('parent')
idsSafeContainer:setOpacity(0.60)
idsSafeContainer:setItems(cfg.main.safeIdsAndares)

-- =========================================================
-- Row template
-- =========================================================
local rowTemplate = [[
UIWidget
  id: root
  height: 25
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
    border: 1 #5a3a12

  BotSwitch
    id: enabled
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 5
    margin-top: -0
    width: 42
    height: 20
    text-align: center
    font: verdana-9px-bold
    text: OFF
    color: white
    image-source: /images/ui/button_rounded
    image-color: #4a2a2a

    $on:
      text: ON
      color: white
      image-color: #2f6b3d

    $!on:
      text: OFF
      color: white
      image-color: #4a2a2a

  UIItem
    id: icon
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 0
    size: 28 28
    visible: false

  Label
    id: spellName
    anchors.left: enabled.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    margin-top: 0
    color: orange
    text: ""
    text-auto-resize: true

  Label
    id: distText
    anchors.left: spellName.right
    anchors.verticalCenter: spellName.verticalCenter
    margin-left: 5
    font: verdana-9px
    color: #c8c8c8
    text: "[1 Sqm"

  Label
    id: mobsText
    anchors.left: distText.right
    anchors.verticalCenter: distText.verticalCenter
    margin-left: 1
    font: verdana-9px
    color: #c8c8c8
    text: "+1 Creature]"

  Label
    id: safeText
    anchors.left: mobsText.right
    anchors.verticalCenter: mobsText.verticalCenter
    margin-left: 3
    font: verdana-9px
    color: #ff5a5a
    text: "[UNSAFE]"

  Button
    id: remove
    anchors.right: parent.right
    anchors.verticalCenter: parent.verticalCenter
    width: 20
    height: 20
    margin-right: 4
    text: X
    font: verdana-11px-rounded
    color: white
    image-source: /images/ui/button_rounded
    image-color: #4a1f1f
    opacity: 1.00

    $hover:
      image-color: #7a2a2a
      color: #ffd0d0
      opacity: 0.95
]]
-- =========================================================
-- Labels update
-- =========================================================
local function updateSpellPanelLabels()
  if sp_dLbl and sp_dist then sp_dLbl:setText("DISTANCE: " .. (sp_dist:getValue() or 0)) end
  if sp_mLbl and sp_mana then sp_mLbl:setText("MANA: " .. (sp_mana:getValue() or 0)) end
  if sp_mbLbl and sp_mobs then sp_mbLbl:setText("MOBS: " .. (sp_mobs:getValue() or 0)) end
  if sp_cdLbl then
    local v = (cfg.draft and cfg.draft.spell and cfg.draft.spell.cd) or (sp_cd and sp_cd:getValue()) or 0
    sp_cdLbl:setText("COOLDOWN: " .. (tonumber(v) or 0) .. " ms")
  end
end

local function updateRunePanelLabels()
  if rn_dLbl and rn_dist then rn_dLbl:setText("DISTANCE: " .. (rn_dist:getValue() or 0)) end
  if rn_mbLbl and rn_mobs then rn_mbLbl:setText("MOBS: " .. (rn_mobs:getValue() or 0)) end
  if rn_cdLbl then
    local v = (cfg.draft and cfg.draft.rune and cfg.draft.rune.cd) or (rn_cd and rn_cd:getValue()) or 1000
    rn_cdLbl:setText("COOLDOWN: " .. (tonumber(v) or 0) .. " ms")
  end
end

-- =========================================================
-- Reset forms
-- =========================================================
local function resetSpellForm()
  if sp_spell then sp_spell:setText("") end
  if sp_dist then sp_dist:setValue(1) end
  if sp_mana then sp_mana:setValue(0) end
  if sp_mobs then sp_mobs:setValue(0) end
  if sp_cd then sp_cd:setValue(0) end
  if sp_safe then sp_safe:setChecked(false) end
  cfg.draft.spell.cd = 0
  updateSpellPanelLabels()
end

local function resetRuneForm()
  cfg.draft.rune.id = 0

  -- limpa visualmente o BotItem
  if rn_id then setBotItemId(rn_id, 0) end

  if rn_dist then rn_dist:setValue(1) end
  if rn_mobs then rn_mobs:setValue(0) end
  if rn_cd then rn_cd:setValue(1000) end
  if rn_safe then rn_safe:setChecked(false) end

  cfg.draft.rune.cd = 0
  updateRunePanelLabels()
end

-- =========================================================
-- ScrollBar binds (SALVA SEMPRE no draft)
-- =========================================================
if sp_dist then sp_dist.onValueChange = function() updateSpellPanelLabels() end end
if sp_mana then sp_mana.onValueChange = function() updateSpellPanelLabels() end end
if sp_mobs then sp_mobs.onValueChange = function() updateSpellPanelLabels() end end

if sp_cd then
  sp_cd.onValueChange = function(widget, value)
    local v = tonumber(value)
    if not v and widget and widget.getValue then v = tonumber(widget:getValue()) end
    v = clamp(v or 0, 0, 60000)
    cfg.draft.spell.cd = v
    updateSpellPanelLabels()
  end
end

if rn_dist then rn_dist.onValueChange = function() updateRunePanelLabels() end end
if rn_mobs then rn_mobs.onValueChange = function() updateRunePanelLabels() end end

if rn_cd then
  rn_cd.onValueChange = function(widget, value)
    local v = tonumber(value)
    if not v and widget and widget.getValue then v = tonumber(widget:getValue()) end
    v = clamp(v or 0, 0, 60000)
    cfg.draft.rune.cd = v
    updateRunePanelLabels()
  end
end

-- =========================================================
-- Selection helpers
-- =========================================================
local function getSelectedIndex()
  local focused = spellList and spellList:getFocusedChild() or nil
  if not focused then return nil end
  return spellList:getChildIndex(focused)
end

local editingIndex = nil -- index dentro de cfg.actions

-- =========================================================
-- Refresh list
-- =========================================================
local function refreshList()
  if not spellList then return end
  clearChildren(spellList)

  for i, entry in ipairs(cfg.actions) do
    if entry.enabled == nil then entry.enabled = true end
    if entry.safe == nil then entry.safe = false end
    if entry.type ~= "spell" and entry.type ~= "rune" then entry.type = "spell" end

    local row = setupUI(rowTemplate, spellList)
    row.entryIndex = i

    row.enabled:setOn(entry.enabled)
    row.enabled.onClick = function(widget)
      local newState = not widget:isOn()
      widget:setOn(newState)
      entry.enabled = newState
    end

    row.remove.onClick = function()
      table.remove(cfg.actions, row.entryIndex)
      editingIndex = nil
      refreshList()
    end

    if entry.type == "rune" then
      row.spellName:setText("   ")
      row.spellName:setMarginLeft(12)
      row.spellName:setVisible(true)
      setItemIcon(row.icon, entry.runeId)
      row.icon:setVisible(true)
    else
      row.icon:setVisible(false)
      row.spellName:setVisible(true)
      row.spellName:setColor("orange")
      row.spellName:setText(tostring(entry.spell or ""))
    end

    local dist = tonumber(entry.dist or 0) or 0
    local mobs = tonumber(entry.mobs or 0) or 0
    row.distText:setText(string.format("[%d Sqm Range | ", dist))
    row.mobsText:setText(string.format("+%d Creature]", mobs))

    local safeChar  = entry.safe and "SAFE" or "UNSAFE"
    local safeColor = entry.safe and "#00FF00" or "#FF4040"
    if row.safeText.setColoredText then
      row.safeText:setColoredText({ "[", "white", safeChar, safeColor, "]", "white" })
    else
      row.safeText:setText("[SAFE: " .. safeChar .. "]")
      row.safeText:setColor(safeColor)
    end

    local tip = ""
    if entry.type == "spell" then
      tip = string.format(
        "Spell: %s\nDist: %d\nMobs: %d\nMP: %d\nCD: %ss\nSafe: %s",
        tostring(entry.spell or ""),
        dist,
        mobs,
        tonumber(entry.mana or 0) or 0,
        msToSecText(entry.cd),
        entry.safe and "SAFE" or "UNSAFE"
      )
    else
      tip = string.format(
        "Rune ID: %d\nDist: %d\nMobs: %d\nSafe: %s",
        tonumber(entry.runeId or 0) or 0,
        dist,
        mobs,
        entry.safe and "SAFE" or "UNSAFE"
      )
    end
    row:setTooltip(tip)

    row.onClick = function(widget)
      spellList:focusChild(widget)
    end

    row.onDoubleClick = function(widget)
      local idx = widget.entryIndex
      local e = cfg.actions[idx]
      if not e then return end
      editingIndex = idx

      if e.type == "rune" then
        if rn_id then setBotItemId(rn_id, tonumber(e.runeId) or 0) end
        if rn_dist then rn_dist:setValue(clamp(e.dist or 1, 0, 12)) end
        if rn_mobs then rn_mobs:setValue(clamp(e.mobs or 0, 0, 10)) end

        local cdv = clamp(tonumber(e.cd or 0) or 0, 0, 60000)
        cfg.draft.rune.cd = cdv
        if rn_cd then rn_cd:setValue(cdv) end
        if rn_cd and rn_cd.onValueChange then pcall(function() rn_cd.onValueChange(rn_cd, cdv) end) end

        if rn_safe then rn_safe:setChecked(e.safe and true or false) end
        updateRunePanelLabels()
        comboInterface:hide()
        rnUI:show(); rnUI:raise(); rnUI:focus()
      else
        if sp_spell then sp_spell:setText(tostring(e.spell or "")) end
        if sp_dist then sp_dist:setValue(clamp(e.dist or 1, 0, 12)) end
        if sp_mana then sp_mana:setValue(clamp(e.mana or 0, 0, 1000)) end
        if sp_mobs then sp_mobs:setValue(clamp(e.mobs or 0, 0, 10)) end

        local cdv = clamp(tonumber(e.cd or 0) or 0, 0, 60000)
        cfg.draft.spell.cd = cdv
        if sp_cd then sp_cd:setValue(cdv) end
        if sp_cd and sp_cd.onValueChange then pcall(function() sp_cd.onValueChange(sp_cd, cdv) end) end

        if sp_safe then sp_safe:setChecked(e.safe and true or false) end
        updateSpellPanelLabels()
        comboInterface:hide()
        spUI:show(); spUI:raise(); spUI:focus()
      end
    end
  end
end

macro(100, function()
  local rev = storage[MANAGER_SYNC_KEY] and storage[MANAGER_SYNC_KEY].rev or 0
  if rev ~= lastManagerSyncRev then
    lastManagerSyncRev = rev
    refreshList()
  end
end)

-- =========================================================
-- Move up/down
-- =========================================================
upBtn.onClick = function()
  local idx = getSelectedIndex()
  if not idx or idx < 2 then return end
  cfg.actions[idx], cfg.actions[idx-1] = cfg.actions[idx-1], cfg.actions[idx]
  refreshList()
  local newFocus = spellList:getChildByIndex(idx-1)
  if newFocus then spellList:focusChild(newFocus) end
end

downBtn.onClick = function()
  local idx = getSelectedIndex()
  if not idx or idx >= #cfg.actions then return end
  cfg.actions[idx], cfg.actions[idx+1] = cfg.actions[idx+1], cfg.actions[idx]
  refreshList()
  local newFocus = spellList:getChildByIndex(idx+1)
  if newFocus then spellList:focusChild(newFocus) end
end

-- =========================================================
-- Main toggles -> cfg
-- =========================================================
local function _bsGet(widget)
  if not widget then return false end
  if widget.isOn then return widget:isOn() end
  if widget.isChecked then return widget:isChecked() end
  return false
end

local function _bsSet(widget, state)
  state = state and true or false
  if not widget then return end
  if widget.setOn then widget:setOn(state); return end
  if widget.setChecked then widget:setChecked(state); return end
end

local function bindBotSwitch(widget, cfgKey, defaultValue)
  if not widget or not cfg or not cfg.main then return end

  if cfg.main[cfgKey] == nil then
    cfg.main[cfgKey] = defaultValue and true or false
  end

  _bsSet(widget, cfg.main[cfgKey])

  -- clique protegido igual teu comboButton.title
  widget.onClick = function(w)
    local newState = not _bsGet(w)
    _bsSet(w, newState)
    cfg.main[cfgKey] = newState
  end
end

bindBotSwitch(virarTarget, "virarTarget", false)
bindBotSwitch(manterDist,  "manterDist",  false)
bindBotSwitch(checkStairs, "checkStairs", false)
bindBotSwitch(ignoreParty, "ignoreParty", false)
bindBotSwitch(checkAndares,"checkAndares",false)

if sqmSafe then
  sqmSafe:setValue(clamp(cfg.main.sqmSafe, 1, 10))
  sqmSafe.onValueChange = function(w, v)
    cfg.main.sqmSafe = clamp(v, 1, 10)
    w:setValue(cfg.main.sqmSafe)
  end
end

-- =========================================================
-- Open add panels
-- =========================================================
addSpellBtn.onClick = function()
  editingIndex = nil
  resetSpellForm()
  spUI:show(); spUI:raise(); spUI:focus()
  comboInterface:hide()
end

addRuneBtn.onClick = function()
  editingIndex = nil
  resetRuneForm()
  rnUI:show(); rnUI:raise(); rnUI:focus()
  comboInterface:hide()
end

sp_cancel.onClick = function() spUI:hide() comboInterface:show() end
rn_cancel.onClick = function() rnUI:hide() comboInterface:show() end

-- =========================================================
-- Add spell
-- =========================================================
sp_add.onClick = function()
  local spell = trim(sp_spell and sp_spell:getText() or "")
  if isEmpty(spell) then return warn("[Combo] Preencha o campo SPELL.") end

  local entry = {
    type    = "spell",
    enabled = true,
    spell   = spell,
    dist    = clamp(sp_dist and sp_dist:getValue() or 1, 0, 12),
    mana    = clamp(sp_mana and sp_mana:getValue() or 0, 0, 1000),
    mobs    = clamp(sp_mobs and sp_mobs:getValue() or 0, 0, 10),
    cd      = clamp((cfg.draft and cfg.draft.spell and cfg.draft.spell.cd) or (sp_cd and sp_cd:getValue()) or 0, 0, 60000),
    safe    = (sp_safe and sp_safe:isChecked()) or false
  }

  if editingIndex and cfg.actions[editingIndex] then
    entry.enabled = cfg.actions[editingIndex].enabled ~= false
    cfg.actions[editingIndex] = entry
  else
    table.insert(cfg.actions, entry)
  end

  refreshList()
  editingIndex = nil
  resetSpellForm()
  spUI:hide()
  comboInterface:show()
end

-- =========================================================
-- Add rune
-- =========================================================
rn_add.onClick = function()
  local runeId = getBotItemId(rn_id)
  if not runeId or runeId <= 0 then return warn("[Combo] Selecione a runa no BotItem.") end

  local entry = {
    type    = "rune",
    enabled = true,
    runeId  = runeId,
    dist    = clamp(rn_dist and rn_dist:getValue() or 1, 0, 12),
    mana    = 0,
    mobs    = clamp(rn_mobs and rn_mobs:getValue() or 0, 0, 10),
    cd      = clamp((cfg.draft and cfg.draft.rune and cfg.draft.rune.cd) or (rn_cd and rn_cd:getValue()) or 0, 0, 60000),
    safe    = (rn_safe and rn_safe:isChecked()) or false
  }

  if editingIndex and cfg.actions[editingIndex] then
    entry.enabled = cfg.actions[editingIndex].enabled ~= false
    cfg.actions[editingIndex] = entry
  else
    table.insert(cfg.actions, entry)
  end

  refreshList()
  editingIndex = nil
  cfg.draft.rune.id = 0
  resetRuneForm()
  rnUI:hide()
  comboInterface:show()
end

-- =========================================================
-- INIT UI state
-- =========================================================
spUI:hide()
rnUI:hide()
resetSpellForm()
resetRuneForm()
updateSpellPanelLabels()
updateRunePanelLabels()
refreshList()

local function resetRuntimeCooldowns()
  if cfg and cfg.actions then
    for _, a in ipairs(cfg.actions) do
      a.nextCast = 0
    end
  end
  userRune = 0
end

resetRuntimeCooldowns()

if g_game and connect then
  connect(g_game, {
    onGameStart = function()
      resetRuntimeCooldowns()
    end
  })
end

-- -------------------------
-- SPELL CD (por onTalk)
-- -------------------------
local cdSpell = { active=false, spell="", lastTime=0 }

local function stopSpellCalc()
  cdSpell.active = false
  cdSpell.spell = ""
  cdSpell.lastTime = 0
end

macro(100, function()
  if not cdSpell.active then return end
  if cdSpell.spell == "" then stopSpellCalc(); return end
  say(cdSpell.spell)
end)

onTalk(function(name, level, mode, text)
  if not cdSpell.active then return end
  local player = g_game.getLocalPlayer()
  if not player then return end
  if name ~= player:getName() then return end

  local msg = trim(text):lower()
  local expected = trim(cdSpell.spell):lower()
  if expected == "" or msg ~= expected then return end

  local t = nowMs()
  if cdSpell.lastTime > 0 then
    local cd = math.floor(t - cdSpell.lastTime)
    local v = clamp(cd, 0, 60000)

    if sp_cd and sp_cd.setValue then
      sp_cd:setValue(v)
      cfg.draft.spell.cd = v
      if sp_cd.onValueChange then pcall(function() sp_cd.onValueChange(sp_cd, v) end) end
    else
      cfg.draft.spell.cd = v
      updateSpellPanelLabels()
    end

    warn(string.format("[CD-SPELL] %d ms (%.1fs)", v, v/1000))
    stopSpellCalc()
  else
    cdSpell.lastTime = t
  end
end)

if sp_calcBtn then
  sp_calcBtn.onClick = function()
    local spell = trim(sp_spell and sp_spell:getText() or "")
    if spell == "" then return end
    cdSpell.active = true
    cdSpell.spell = spell
    cdSpell.lastTime = 0
  end
end

-- =========================================================
-- RUNE COOLDOWN - MISSILE ONLY (SEM FALLBACK)
-- =========================================================
cfg.draft = cfg.draft or {}
cfg.draft.rune = cfg.draft.rune or { cd = 0 }

local runeCd = {
  active    = false,
  runeId    = 0,
  missileId = nil,
  lastTime  = 0
}

local function nowMs()
  if now then return now end
  return (os.time() * 1000) + math.floor((os.clock() * 1000) % 1000)
end

local function stopRuneCd()
  runeCd.active = false
  runeCd.runeId = 0
  runeCd.missileId = nil
  runeCd.lastTime = 0
end

local function applyRuneCd(ms)
  ms = math.floor(tonumber(ms) or 0)
  if ms < 0 then ms = 0 end
  if ms > 60000 then ms = 60000 end

  cfg.draft.rune.cd = ms

  -- aplica no painel
  local rn_cd = runeAddPanel and W(runeAddPanel, "cooldown")
  if rn_cd and rn_cd.setValue then
    rn_cd:setValue(ms)
  end

  if type(updateRunePanelLabels) == "function" then
    updateRunePanelLabels()
  end

  warn(string.format("[CD-RUNE] %d ms (%.1fs)", ms, ms / 1000))
  stopRuneCd()
end

-- =========================================================
-- TRY USE (APENAS useWith) + FORCADO
-- =========================================================
local function tryUseRune(runeId)
  local target = g_game.getAttackingCreature()
  if not target then target = g_game.getLocalPlayer() end
  if not target then return false end

  -- SOMENTE useWith
  if type(useWith) ~= "function" then
    warn("[CD-RUNE] useWith() nao existe no seu client.")
    return false
  end

  local ok = pcall(function()
    useWith(runeId, target)
  end)

  return ok
end

-- =========================================================
-- [INSERIDO] AUTO USAR RUNA 2x (FORCANDO TENTATIVAS)
-- =========================================================
local runeAuto = {
  active = false,
  runeId = 0,
  stage = 0,    
  nextAt = 0,
  startedAt = 0
}

local function startAutoRune2x(runeId)
  runeAuto.active = true
  runeAuto.runeId = tonumber(runeId) or 0
  runeAuto.stage = 1
  runeAuto.nextAt = 0
  runeAuto.startedAt = nowMs()
end

macro(60, function()
  if not runeAuto.active then return end
  if runeAuto.runeId <= 0 then runeAuto.active = false; return end

  -- se o calc acabou, para o auto junto
  if not runeCd.active then runeAuto.active = false; return end

  local t = nowMs()

  if t - runeAuto.startedAt > 20000 then
    warn("[CD-RUNE] Timeout: nao consegui medir (sem 2 missiles).")
    runeAuto.active = false
    return
  end

  if runeAuto.nextAt ~= 0 and t < runeAuto.nextAt then return end

  runeAuto.nextAt = t + 250

  if runeAuto.stage == 1 then
    tryUseRune(runeAuto.runeId)
    return
  end

  if runeAuto.stage == 2 then
    tryUseRune(runeAuto.runeId)
    return
  end
end)

-- =========================================================
-- MISSILE HANDLER
-- =========================================================
local function handleRuneMissile(missile)
  if not runeCd.active or not missile then return end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local src = missile:getSource()
  if not src then return end

  local tile = g_map.getTile(src)
  if not tile then return end

  local creatures = tile:getCreatures() or {}
  if #creatures == 0 then return end

  local caster = creatures[1]
  if caster:getName() ~= player:getName() then return end

  local mid = missile:getId()
  if not mid then return end

  local t = nowMs()

  if not runeCd.missileId then
    runeCd.missileId = mid
    runeCd.lastTime = t

    if runeAuto.active then
      runeAuto.stage = 2
      runeAuto.nextAt = 0
    end
    return
  end

  if mid ~= runeCd.missileId then return end

  if runeCd.lastTime > 0 then
    applyRuneCd(t - runeCd.lastTime)
  end
end

-- =========================================================
-- HOOKS DE MISSILE (compatibilidade total)
-- =========================================================
if type(onMissile) == "function" then
  pcall(function()
    onMissile(handleRuneMissile)
  end)
end

if type(onMissle) == "function" then
  pcall(function()
    onMissle(handleRuneMissile)
  end)
end

if g_map and connect then
  pcall(function()
    connect(g_map, {
      onMissile = function(_, missile)
        handleRuneMissile(missile)
      end
    })
  end)
end

-- =========================================================
-- BOTÃO "!" DO PAINEL
-- =========================================================
do
  local btn = runeAddPanel and W(runeAddPanel, "calculeCooldown")
  if btn then
    btn.onClick = function()
      local rn_id = runeAddPanel and W(runeAddPanel, "runa")
      local runeId = getBotItemId(rn_id)
      if not runeId or runeId <= 0 then
        return warn("[CD-RUNE] Selecione a runa no BotItem.")
      end

      if not runeId or runeId <= 0 then
        return warn("[CD-RUNE] ID da runa inválido.")
      end

      stopRuneCd()
      runeCd.active = true
      runeCd.runeId = runeId

      -- [INSERIDO] força 2 usos (via tentativas + missile)
      startAutoRune2x(runeId)

      warn("[CD-RUNE] Aguardando missile...")
    end
  end
end

-- =========================================================
-- LOAD DO COOLDOWN AO ABRIR O PAINEL
-- =========================================================
do
  local rn_cd = runeAddPanel and W(runeAddPanel, "cooldown")
  if rn_cd and rn_cd.setValue then
    rn_cd:setValue(tonumber(cfg.draft.rune.cd) or 1000)
    if type(updateRunePanelLabels) == "function" then
      updateRunePanelLabels()
    end
  end
end

-- =========================================================
-- CHECK STAIRS + TEXTO "UNSAFE" SIMPLES
-- =========================================================
ANDAR_NAO_SAFE = false

local function buildIdLookup(ids)
  local t = {}
  if type(ids) ~= "table" then return t end
  for _, v in pairs(ids) do
    local id = nil
    if type(v) == "table" then
      id = (v.getId and v:getId()) or v.id
    else
      id = v
    end
    id = tonumber(id)
    if id then t[id] = true end
  end
  return t
end

local function checkStairsNearby(dist, idLookup)
  local player = g_game.getLocalPlayer()
  if not player then return false end
  local p = player:getPosition()
  if not p then return false end

  for x = -dist, dist do
    for y = -dist, dist do
      local tile = g_map.getTile({ x = p.x + x, y = p.y + y, z = p.z })
      if tile then
        for _, item in ipairs(tile:getItems() or {}) do
          if idLookup[item:getId()] then
            return true
          end
        end
      end
    end
  end
  return false
end

macro(200, function()
  if not (cfg and cfg.main) then ANDAR_NAO_SAFE = false return end
  if not cfg.main.checkStairs then ANDAR_NAO_SAFE = false return end

  local dist = clamp((cfg and cfg.main and cfg.main.sqmSafe) or 8, 1, 10)
  local ids = (cfg and cfg.main and cfg.main.safeIdsAndares) or {}
  local lookup = buildIdLookup(ids)

  ANDAR_NAO_SAFE = checkStairsNearby(dist, lookup)
end)

macro(200, function()
  local player = g_game.getLocalPlayer()
  if not player then return end

  local unsafe = false

  -- stairs/buracos (seu sistema atual)
  if ANDAR_NAO_SAFE or PLAYERSINSCREEN then
    unsafe = true
  end

  if unsafe then
    player:setText("UNSAFE")
  else
    player:setText("")
  end
end)

-- =========================================================
-- KEEP DISTANCE (só com checkbox manterDist)
-- =========================================================
local lastMove = 0
local moveDelay = 25
local lastDir = nil
local stableUntil = 0

local function chebyshevDist(a, b)
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function stepPos(p, dir)
  local n = {x = p.x, y = p.y, z = p.z}
  if dir == 0 then n.y = n.y - 1
  elseif dir == 1 then n.x = n.x + 1
  elseif dir == 2 then n.y = n.y + 1
  elseif dir == 3 then n.x = n.x - 1
  elseif dir == 4 then n.x = n.x + 1; n.y = n.y - 1
  elseif dir == 5 then n.x = n.x + 1; n.y = n.y + 1
  elseif dir == 6 then n.x = n.x - 1; n.y = n.y + 1
  elseif dir == 7 then n.x = n.x - 1; n.y = n.y - 1
  end
  return n
end

local function isWalkableFree(pos)
  local tile = g_map.getTile(pos)
  if not tile or not tile:isWalkable() then return false end
  local cr = tile:getCreatures() or {}
  return #cr == 0
end

macro(200, function()
  if not (cfg and cfg.main) then return end
  if not (storage[switchCombo].enabled and cfg.main.manterDist) then return end

  local target = g_game.getAttackingCreature()
  if not target then return end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local pPos = player:getPosition()
  local tPos = target:getPosition()
  if not pPos or not tPos or pPos.z ~= tPos.z then return end

  local nowt = nowMs()
  if nowt - lastMove < moveDelay then return end

  local dist = chebyshevDist(pPos, tPos)
  local desiredDist = 4

  if dist <= 1 then
    local bestDir, bestScore = -1, -999999
    for dir = 0, 7 do
      local np = stepPos(pPos, dir)
      if isWalkableFree(np) then
        local newDist = chebyshevDist(np, tPos)
        local score = newDist * 10
        if dir <= 3 then score = score + 2 else score = score - 1 end
        if lastDir and ((dir + 2) % 4 == lastDir) then score = score - 8 end
        if lastDir and dir == lastDir then score = score + 3 end
        if newDist >= 2 then score = score + 5 end
        if score > bestScore then
          bestScore = score
          bestDir = dir
        end
      end
    end

    if bestDir ~= -1 then
      if player:isAutoWalking() then player:stopAutoWalk() end
      g_game.walk(bestDir)
      lastDir = bestDir
      lastMove = nowt
      stableUntil = nowt + 400
    end
    return
  end

  if dist > desiredDist then
    if nowt < stableUntil then return end
    if not player:isAutoWalking() then
      g_game.autoWalk(tPos, { precision = desiredDist - 1, ignoreNonPathable = true })
      lastMove = nowt
      stableUntil = nowt + 350
    end
    lastDir = nil
    return
  end

  if nowt > stableUntil then lastDir = nil end
end)

-- =========================================================
-- VIRAR PARA O TARGET (fast 4-dir) - checkbox virarTarget
-- =========================================================
local lastTurn = 0
local turnDelay = 20

local function getDir4(fromPos, toPos)
  local dx = toPos.x - fromPos.x
  local dy = toPos.y - fromPos.y
  if dx == 0 and dy == 0 then return nil end
  if math.abs(dx) > math.abs(dy) then
    return (dx > 0) and 1 or 3
  else
    return (dy > 0) and 2 or 0
  end
end

macro(30, function()
  if not (cfg and cfg.main) then return end
  if not (storage[switchCombo].enabled and cfg.main.virarTarget) then return end

  local player = g_game.getLocalPlayer()
  if not player then return end

  local target = g_game.getAttackingCreature()
  if not target then return end

  local pPos = player:getPosition()
  local tPos = target:getPosition()
  if not pPos or not tPos or pPos.z ~= tPos.z then return end

  local nowt = nowMs()
  if nowt - lastTurn < turnDelay then return end

  local dir = getDir4(pPos, tPos)
  if not dir then return end

  local curDir = player.getDirection and player:getDirection() or nil
  if curDir ~= nil and curDir == dir then return end

  if turn then
    turn(dir)
  elseif g_game.turn then
    g_game.turn(dir)
  end

  lastTurn = nowt
end)

-- =========================================================
-- 1. DETECTOR DE MAGIAS (PRECISÃO EXATA)
-- =========================================================
local combatGlobalUntil = 0

local COMBAT_GLOBAL_DELAY = 1000
local worldName = g_game.getWorldName() or ""

if worldName == "Telaria" or worldName == "Eternia" or worldName == "Aurera-Global" then
  COMBAT_GLOBAL_DELAY = 2000
end

onTalk(function(name, level, mode, text, channelId, pos)
    if name ~= g_game.getLocalPlayer():getName() then return end
    text = text:lower()
    
    if cfg and cfg.actions then
        for _, action in ipairs(cfg.actions) do
            if action.enabled and action.type == "spell" and action.spell:lower() == text then
                action.nextCast = now + (action.cd or 1000)
                combatGlobalUntil = now + COMBAT_GLOBAL_DELAY
            end
        end
    end
end)

-- =========================================================
-- 2. DETECTOR DE RUNAS (PRECISÃO EXATA)
-- =========================================================
local runeToMissile = {
    [3155] = 32,  -- SD
    [3175] = 30,
    [3191] = 4,
    [3161] = 29,
    [3202] = 36
}

local worldName = g_game.getWorldName() or ""

local RUNE_WORLD_COOLDOWN = 1000

if worldName == "Telaria" 
or worldName == "Eternia" 
or worldName == "Aurera-Global" then
  RUNE_WORLD_COOLDOWN = 2000
end

onMissle(function(missle)

  local player = g_game.getLocalPlayer()
  if not player then return end
  if not missle then return end

  local src = missle:getSource()
  if not src then return end

  local pPos = player:getPosition()
  if not pPos then return end

  if src.z ~= pPos.z or src.x ~= pPos.x or src.y ~= pPos.y then
    return
  end

  local missleId = tonumber(missle:getId())
  if not missleId then return end

  if not cfg or not cfg.actions then return end

  for _, action in ipairs(cfg.actions) do
    if action.enabled and action.type == "rune" then

      local rId = tonumber(action.runeId)
      local mappedMissile = rId and runeToMissile[rId]

      if mappedMissile and mappedMissile == missleId then

        userRune = now + RUNE_WORLD_COOLDOWN
        action.nextCast = now + RUNE_WORLD_COOLDOWN
        combatGlobalUntil = now + COMBAT_GLOBAL_DELAY
        return
      end
    end
  end

end)
-- =========================================================
-- CHECK PLAYERS
-- =========================================================
PLAYERSINSCREEN = false

local function clampValue(v, mn, mx)
  v = tonumber(v) or mn
  if v < mn then return mn end
  if v > mx then return mx end
  return v
end

local function isPartyMemberSafe(spec)
  if not spec or not spec.isPlayer or not spec:isPlayer() then return false end
  if spec.isLocalPlayer and spec:isLocalPlayer() then return false end

  if spec.isPartyMember and spec:isPartyMember() then
    return true
  end

  if spec.getShield then
    local sh = tonumber(spec:getShield()) or 0
    if sh == 3 then
      return true
    end
  end

  return false
end

local function isGuildMemberSafe(spec)
  if not spec or not spec.isPlayer or not spec:isPlayer() then return false end
  if spec.isLocalPlayer and spec:isLocalPlayer() then return false end

  if spec.getEmblem then
    local emblem = tonumber(spec:getEmblem()) or 0
    if emblem == 1 then
      return true
    end
  end

  return false
end

local function isEnemyPlayer(spec)
  if not spec or not spec.isPlayer or not spec:isPlayer() then return false end
  if spec.isLocalPlayer and spec:isLocalPlayer() then return false end
  if isPartyMemberSafe(spec) then return false end
  if isGuildMemberSafe(spec) then return false end
  return true
end

local function getSpecs(pos, multifloor)
  if g_map and g_map.getSpectators then
    local ok, res = pcall(function()
      return g_map.getSpectators(pos, multifloor)
    end)
    if ok and type(res) == "table" then return res end
  end

  if type(getSpectators) == "function" then
    local ok, res = pcall(function()
      return getSpectators(multifloor)
    end)
    if ok and type(res) == "table" then return res end
  end

  return {}
end

macro(200, function()
  if not (cfg and cfg.main) then
    PLAYERSINSCREEN = false
    return
  end

  if not cfg.main.ignoreParty then
    PLAYERSINSCREEN = false
    return
  end

  local me = g_game.getLocalPlayer()
  if not me then
    PLAYERSINSCREEN = false
    return
  end

  local myPos = me:getPosition()
  if not myPos then
    PLAYERSINSCREEN = false
    return
  end

  local range = clampValue(cfg.main.sqmSafe or 8, 1, 8)

  local specsSame = getSpecs(myPos, false)
  for _, spec in ipairs(specsSame) do
    if isEnemyPlayer(spec) then
      local sp = spec:getPosition()
      if sp and sp.z == myPos.z then
        local dist = getDistanceBetween(myPos, sp)
        if dist <= range then
          PLAYERSINSCREEN = true
          return
        end
      end
    end
  end

  local nearStairs = (cfg.main.checkStairs == true) and (ANDAR_NAO_SAFE == true)
  if not nearStairs then
    PLAYERSINSCREEN = false
    return
  end

  local specsMulti = getSpecs(myPos, true)
  for _, spec in ipairs(specsMulti) do
    if isEnemyPlayer(spec) then
      local sp = spec:getPosition()
      if sp then
        if (sp.z == myPos.z - 1) or (sp.z == myPos.z + 1) then
          local dist = getDistanceBetween(myPos, sp)
          if dist <= range then
            PLAYERSINSCREEN = true
            return
          end
        end
      end
    end
  end

  PLAYERSINSCREEN = false
end)
-- =========================================================
-- 3. MACRO DE COMBO REFEITO (MOTOR)
-- =========================================================
local SPAM_DELAY = 200 -- Tempo de espera "provisório" até o servidor responder

macro(100, function()
  if not storage[switchCombo].enabled then return end
  if not cfg.main.enabled then return end
  if now < combatGlobalUntil then return end

  local player = g_game.getLocalPlayer()
  local target = g_game.getAttackingCreature()
  if not player or not target then return end
  if player:isNpc() then return end

  local pPos = player:getPosition()
  local tPos = target:getPosition()
  if not pPos or not tPos or pPos.z ~= tPos.z then return end

  local dist = math.max(math.abs(pPos.x - tPos.x), math.abs(pPos.y - tPos.y))

  -- >>> FIX: detecta se o alvo é player
  local targetIsPlayer = (target.isPlayer and target:isPlayer()) or false

  for i, action in ipairs(cfg.actions) do
    if action.enabled then

      local isReady = now >= (tonumber(action.nextCast) or 0)

      local distOk = dist <= (tonumber(action.dist) or 8)

      local manaOk = true
      if action.type == "spell" then
        local needMana = tonumber(action.mana) or 0
        if mana() < needMana then manaOk = false end
      end

      -- >>> FIX: se target é player, não trava por mobs
      local mobsOk = true
      if (not targetIsPlayer) and (tonumber(action.mobs) or 0) > 0 then
        local count = 0
        local specs = g_map.getSpectators(pPos, false) or {}
        for _, s in ipairs(specs) do
          if s and s.isMonster and s:isMonster() then
            local sPos = s:getPosition()
            if sPos then
              local sd = math.max(math.abs(pPos.x - sPos.x), math.abs(pPos.y - sPos.y))
              if sd <= 7 then count = count + 1 end
            end
          end
        end
        if count < (tonumber(action.mobs) or 0) then mobsOk = false end
      end

      local safeOk = true
      if not action.safe then
        if (not targetIsPlayer) and cfg.main.checkStairs and ANDAR_NAO_SAFE then
          safeOk = false
        end

        if (not targetIsPlayer) and cfg.main.ignoreParty and PLAYERSINSCREEN then
          safeOk = false
        end
      end

      if isReady and distOk and manaOk and mobsOk and safeOk then

        if action.type == "spell" then
          if action.spell and action.spell ~= "" then
            say(action.spell)
            delay(1000)
            action.nextCast = now + SPAM_DELAY
            return
          end

        elseif action.type == "rune" then
          local rid = tonumber(action.runeId) or 0
          if rid > 0 then
            if (not userRune or userRune <= now) then
              useWith(rid, target)
              delay(1000)
              action.nextCast = now + SPAM_DELAY
            end
            return
          end
        end
      end
    end
  end
end)
