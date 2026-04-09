setDefaultTab("LNS")

local switchHealing = "healingButton"

if not storage[switchHealing] then
    storage[switchHealing] = { enabled = false }
end

healingButton = setupUI([[
Panel
  height: 18
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    text: HEALING
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
healingButton:setId(switchHealing)
healingButton.title:setOn(storage[switchHealing].enabled)

healingButton.title.onClick = function(widget)
    newState = not widget:isOn()
    widget:setOn(newState)
    storage[switchHealing].enabled = newState
end

local mainPanel = setupUI([[  
SpellRow < Panel
  height: 25
  margin-top: 3

  ComboBox
    id: spell
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 0
    width: 120
    font: verdana-11px-rounded
    text-align: center
    image-color: #828282

  BotTextEdit
    id: spellDigit
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 0
    width: 120
    font: verdana-11px-rounded
    text-align: center
    image-color: #828282

  Label
    id: lblHp
    anchors.left: spell.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 8
    text-auto-resize: true
    text: HP% <=
    font: verdana-11px-rounded
    width: 30

  SpinBox
    id: hp
    anchors.left: lblHp.right
    anchors.verticalCenter: parent.verticalCenter
    width: 60
    margin-left: 3
    minimum: 0
    maximum: 100
    step: 1
    text-align: center
    focusable: true
    editable: true
    image-color: #828282

  Label
    id: lblMana
    anchors.left: hp.right
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 10
    text: MP% <= 
    text-auto-resize: true  
    font: verdana-11px-rounded
    width: 35

  SpinBox
    id: mana
    anchors.left: lblMana.right
    anchors.verticalCenter: parent.verticalCenter
    width: 60
    margin-left: 5
    minimum: 0
    maximum: 1000
    step: 1
    text-align: center
    editable: true
    image-color: #828282

BotHealingPot < Panel
  height: 32
  margin-top: 3

  BotItem
    id: potionHp
    anchors.left: parent.left
    anchors.top: parent.top
    margin-top: 0
    border: 1 #8B0000
    opacity: 0.80

  Button
    id: resourceText
    anchors.top: potionHp.top
    anchors.left: potionHp.right
    anchors.right: parent.right
    margin-left: 5
    margin-right: 5
    text-align: center
    font: verdana-11px-rounded
    image-source: /images/ui/button_rounded
    image-color: 	#EE0000
    height: 18

  HorizontalScrollBar
    id: scrollMin
    anchors.left: resourceText.left
    anchors.top: resourceText.bottom
    anchors.right: resourceText.right
    margin-top: 3
    margin-right: 2
    minimum: 0
    maximum: 100
    step: 1

BotHealingPotMP < Panel
  height: 32
  margin-top: 3

  BotItem
    id: potionHp
    anchors.left: parent.left
    anchors.top: parent.top
    margin-top: 0
    border: 1 #00B2EE
    opacity: 0.80

  Button
    id: resourceText
    anchors.top: potionHp.top
    anchors.left: potionHp.right
    anchors.right: parent.right
    margin-left: 5
    margin-right: 5
    font: verdana-11px-rounded
    text-align: center
    image-source: /images/ui/button_rounded
    image-color: 	#00B2EE
    height: 18

  HorizontalScrollBar
    id: scrollMax
    anchors.left: resourceText.left
    anchors.right: resourceText.right
    anchors.top: resourceText.bottom
    margin-top: 3
    margin-left: 2
    minimum: 0
    maximum: 100
    step: 1

UIWindow
  id: mainPanel
  size: 400 390
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
    !text: tr('LNS Custom | Healing Engine')
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: black
    $hover:
      image-color: gray
  
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

  FlatPanel
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 18
    margin-right: 8
    margin-left: 8
    height: 120
    image-color: #363636
    layout: verticalBox

  Label
    id: labelHealing
    anchors.top: prev.top
    anchors.left: panelMain.left
    text: HEALING SPELLS:
    text-auto-resize: true
    font: verdana-9px-italic
    margin-top: -5
    margin-left: 10

  BotSwitch
    id: offHealing
    anchors.top: prev.top
    anchors.left: prev.right
    image-souce: /images/ui/button_rounded
    image-color: #363636
    margin-left: 5
    margin-top: -3
    width: 60
    $!on:
      opacity: 0.70
      image-color: #363636
      text: OFFLINE
      color: red
    $on:
      opacity: 1.00
      color: #7CFC00
      text: ONLINE
      image-color: #363636

  Button
    id: Pre-config
    anchors.right: panelMain.right
    anchors.top: prev.top
    text: PRE-CONFIG
    width: 60
    height: 18
    margin-right: 5
    font: verdana-9px-italic
    image-color: #363636
    image-souce: /images/ui/button_rounded

  Button
    id: Edit-config
    anchors.right: Pre-config.left
    anchors.top: prev.top
    text: EDITAVEL
    width: 60
    height: 18
    margin-right: 5
    font: verdana-9px-italic
    image-color: #363636
    image-souce: /images/ui/button_rounded

  SpellRow
    id: rowSpell1
    anchors.top: labelHealing.bottom
    anchors.left: panelMain.left
    anchors.right: panelMain.right
    margin-left: 10
    margin-top: 10

  SpellRow
    id: rowSpell2
    anchors.top: rowSpell1.bottom
    anchors.left: rowSpell1.left
    anchors.right: rowSpell1.right
    margin-top: 10

  SpellRow
    id: rowSpell3
    anchors.top: rowSpell2.bottom
    anchors.left: rowSpell2.left
    anchors.right: rowSpell2.right
    margin-top: 10

  FlatPanel
    id: panelPotion
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 25
    margin-right: 8
    margin-left: 8
    height: 145
    image-color: #363636
    layout: verticalBox

  Label
    id: labelPotion
    anchors.top: prev.top
    anchors.left: panelPotion.left
    text: POTIONS HEALTH/MANA:
    text-auto-resize: true
    font: verdana-9px-italic
    margin-top: -5
    margin-left: 10

  BotSwitch
    id: offPotions
    anchors.top: prev.top
    anchors.left: prev.right
    image-souce: /images/ui/button_rounded
    image-color: #363636
    margin-left: 5
    margin-top: -3
    width: 60
    $!on:
      opacity: 0.70
      image-color: #363636
      text: OFFLINE
      color: red
    $on:
      opacity: 1.00
      color: #7CFC00
      text: ONLINE
      image-color: #363636

  BotHealingPot
    id: rowPotionhp1
    anchors.top: labelPotion.bottom
    anchors.left: labelPotion.left
    width: 180
    margin-top: 10

  BotHealingPot
    id: rowPotionhp2
    anchors.top: rowPotionhp1.bottom
    anchors.left: rowPotionhp1.left
    width: 180
    margin-top: 10

  BotHealingPot
    id: rowPotionhp3
    anchors.top: rowPotionhp2.bottom
    anchors.left: rowPotionhp2.left
    width: 180
    margin-top: 10

  BotHealingPotMP
    id: rowPotionMp1
    anchors.top: labelPotion.bottom
    anchors.left: rowPotionhp1.right
    width: 180
    margin-top: 10
    margin-left: 10

  BotHealingPotMP
    id: rowPotionMp2
    anchors.top: rowPotionMp1.bottom
    anchors.left: rowPotionMp1.left
    width: 180
    margin-top: 10

  BotHealingPotMP
    id: rowPotionMp3
    anchors.top: rowPotionMp2.bottom
    anchors.left: rowPotionMp2.left
    width: 180
    margin-top: 10

  FlatPanel
    id: panelFood
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 25
    margin-right: 8
    margin-left: 8
    height: 55
    image-color: #363636
    layout: verticalBox

  Label
    id: labelFood
    anchors.top: prev.top
    anchors.left: panelFood.left
    text: AUTO FOOD:
    text-auto-resize: true
    font: verdana-9px-italic
    margin-top: -5
    margin-left: 10

  BotSwitch
    id: offFood
    anchors.top: prev.top
    anchors.left: prev.right
    image-souce: /images/ui/button_rounded
    image-color: #363636
    margin-left: 5
    margin-top: -3
    width: 60
    $!on:
      opacity: 0.70
      image-color: #363636
      text: OFFLINE
      color: red
    $on:
      opacity: 1.00
      color: #7CFC00
      text: ONLINE
      image-color: #363636

  Panel
    id: foodContainerPanel
    anchors.top: labelFood.bottom
    anchors.left: panelFood.left
    anchors.right: panelFood.right
    size: 270 35
    margin-top: 5
    margin-left: 5
    margin-right: 5

]], g_ui.getRootWidget())
mainPanel:hide()

mainPanel.closePanel.onClick = function()
  mainPanel:hide()
end

function buttonsHealingPcMobile()
  if modules._G.g_app.isMobile() then
    healingButton.settings:show()
    healingButton.title:setMarginRight(55)
  else
    healingButton.settings:hide()
    healingButton.title:setMarginRight(0)
  end
end
buttonsHealingPcMobile()


healingButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not mainPanel:isVisible() then
      mainPanel:show()
      mainPanel:raise();
      mainPanel:focus();
    else
      mainPanel:hide()
    end
  end
end

healingButton.settings.onClick = function()
    if not mainPanel:isVisible() then
        mainPanel:show()
        mainPanel:raise()
        mainPanel:focus()
    end
end

local destPanel = mainPanel.foodContainerPanel

if type(settings.food.items) ~= "table" or #settings.food.items == 0 then
  settings.food.items = { 3607, 3585, 3592, 3600, 3601 }
  saveSettings(settings)
end

storage.foodItems = settings.food.items

local foodContainer = UI.ContainerEx(function(widget, items)
  local cleanItems = normalizeContainerItems(items)

  storage.foodItems = cleanItems
  settings.food = settings.food or {}
  settings.food.items = cleanItems
  saveSettings(settings)
end, true)

foodContainer:setParent(destPanel)
foodContainer:fill('parent')
foodContainer:setOpacity(0.70)
foodContainer:setImageColor("#363636")
foodContainer:setItems(settings.food.items)

local function getFoodIds()
  local result = {}
  local added = {}

  if type(storage.foodItems) ~= "table" then
    return result
  end

  for _, entry in ipairs(storage.foodItems) do
    local id = 0

    if type(entry) == "number" then
      id = entry
    elseif type(entry) == "string" then
      id = tonumber(entry) or 0
    elseif type(entry) == "table" then
      if entry.id then
        id = tonumber(entry.id) or 0
      elseif entry.itemId then
        id = tonumber(entry.itemId) or 0
      elseif entry.getId and type(entry.getId) == "function" then
        id = tonumber(entry:getId()) or 0
      end
    end

    if id > 0 and not added[id] then
      added[id] = true
      table.insert(result, id)
    end
  end

  return result
end

local lastAutoFoodTry = 0

macro(1000, function()
  if not player then return end

  if not storage.lnsHealingPanel
     or not storage.lnsHealingPanel.toggles
     or storage.lnsHealingPanel.toggles.offFood ~= true then
    return
  end

  if not storage[switchHealing]
     or storage[switchHealing].enabled ~= true then
    return
  end

  if type(storage.foodItems) ~= "table" or not storage.foodItems[1] then
    print("[AUTO FOOD] sem foods configuradas")
    return
  end

  if lastAutoFoodTry + 30000 > now then
    return
  end
  lastAutoFoodTry = now

  local regen = player:getRegenerationTime() or 0

  if regen > 400 then
    return
  end

  for _, food in ipairs(storage.foodItems) do
    local foodId = type(food) == "table" and tonumber(food.id) or tonumber(food)
    if foodId and foodId > 0 then
      use(foodId)
      return
    end
  end
end)

local panelName = "lnsHealingPanel"

-- Spells padronizadas (como você pediu)
local SPELL_OPTIONS = {
  "", -- vazio = desativado
  "Exura",
  "Exura Gran",
  "Exura Vita",
  "Exura San",
  "Exura Gran San",
  "Exura Ico",
  "Exura Med Ico",
  "Exura Gran Ico"
}

-- "Amarração" da mana por spell (mana mínima necessária pra castar)
-- (valores padrão mais comuns; você pode ajustar se seu servidor for diferente)
local SPELL_MANA_COST = {
  ["Exura"] = 20,
  ["Exura Gran"] = 70,
  ["Exura Vita"] = 160,
  ["Exura San"] = 160,
  ["Exura Gran San"] = 210,
  ["Exura Ico"] = 40,
  ["Exura Med Ico"] = 90,
  ["Exura Gran Ico"] = 200
}

-- Defaults (se não existir no storage)
local DEFAULT_ROWS = {
  { spell = "Exura",          hp = 90, mana = 20  },
  { spell = "Exura Gran",     hp = 70, mana = 70  },
  { spell = "Exura Vita",     hp = 50, mana = 160 }
}

-- =========================
-- SPELLROW MODE + STORAGE (PRE-CONFIG / EDITAVEL)
-- =========================

local function ensureStorage()
  if not storage[panelName] or type(storage[panelName]) ~= "table" then
    storage[panelName] = {}
  end
  if type(storage[panelName].rows) ~= "table" then
    storage[panelName].rows = {}
  end

  -- modo padrão na 1ª vez: PRE-CONFIG
  if storage[panelName].spellMode ~= "pre" and storage[panelName].spellMode ~= "edit" then
    storage[panelName].spellMode = "pre"
  end

  for i = 1, 3 do
    if type(storage[panelName].rows[i]) ~= "table" then
      storage[panelName].rows[i] = {
        spell = DEFAULT_ROWS[i].spell,
        spellDigit = DEFAULT_ROWS[i].spell, -- inicia igual, mas depois fica independente
        hp = DEFAULT_ROWS[i].hp,
        mana = DEFAULT_ROWS[i].mana
      }
    end

    local r = storage[panelName].rows[i]

    if r.hp == nil then r.hp = DEFAULT_ROWS[i].hp end
    if r.mana == nil then r.mana = DEFAULT_ROWS[i].mana end
    if r.spell == nil then r.spell = DEFAULT_ROWS[i].spell end
    if r.spellDigit == nil then r.spellDigit = tostring(r.spell or "") end
  end
end

local function comboSelectByText(combo, text)
  if not combo then return end
  text = tostring(text or ""):lower()

  local idx = 1
  for i, s in ipairs(SPELL_OPTIONS) do
    if tostring(s):lower() == text then
      idx = i
      break
    end
  end

  -- tenta por índice
  if combo.setCurrentIndex then
    combo:setCurrentIndex(idx)
    return
  end

  -- fallback (algumas versões usam setCurrentOption)
  if combo.setCurrentOption then
    combo:setCurrentOption(SPELL_OPTIONS[idx])
    return
  end
end

local function fillComboOptions(combo)
  combo:clearOptions()
  for _, s in ipairs(SPELL_OPTIONS) do
    combo:addOption(s)
  end
end

local function setRowMode(rowWidget, mode)
  if not rowWidget then return end
  local combo = rowWidget.spell
  local edit  = rowWidget.spellDigit
  if not combo or not edit then return end

  if mode == "edit" then
    combo:hide()
    edit:show()
  else
    edit:hide()
    combo:show()
  end
end

local function getComboText(combo)
  if not combo then return "" end
  if combo.getCurrentOption then
    local opt = combo:getCurrentOption()
    if opt and opt.text then return opt.text end
  end
  return ""
end

local function bindSpellRow(rowWidget, rowIndex)
  if not rowWidget then return end

  local combo = rowWidget.spell
  local edit  = rowWidget.spellDigit
  local hpBox = rowWidget.hp
  local manaBox = rowWidget.mana

  -- popula combobox
  fillComboOptions(combo)

  -- aplica valores do storage na UI
  local rowStore = storage[panelName].rows[rowIndex]
  comboSelectByText(combo, rowStore.spell)

  if edit and edit.setText then
    edit:setText(tostring(rowStore.spellDigit or ""))
  end

  hpBox:setValue(tonumber(rowStore.hp) or 0)
  manaBox:setValue(tonumber(rowStore.mana) or 0)

  -- aplica visibilidade do modo atual
  setRowMode(rowWidget, storage[panelName].spellMode)

  -- salva quando mexer no COMBO (PRE-CONFIG)
  combo.onOptionChange = function(widget)
    local chosen = getComboText(widget)
    rowStore.spell = chosen

    local cost = SPELL_MANA_COST[chosen]
    if cost then
      local cur = tonumber(manaBox:getValue()) or 0
      if cur ~= cost then
        manaBox:setValue(cost)
        rowStore.mana = cost
      end
    end
  end

  -- salva quando mexer no TEXTEDIT (EDITAVEL)
  if edit then
    edit.onTextChange = function(widget, text)
      text = tostring(text or "")
      rowStore.spellDigit = text

      local cost = SPELL_MANA_COST[text]
      if cost then
        local cur = tonumber(manaBox:getValue()) or 0
        if cur ~= cost then
          manaBox:setValue(cost)
          rowStore.mana = cost
        end
      end
    end
  end

  hpBox.onValueChange = function(widget, value)
    rowStore.hp = tonumber(value) or 0
  end

  manaBox.onValueChange = function(widget, value)
    rowStore.mana = tonumber(value) or 0
  end
end

local function getSpellForMode(rowStore, mode)
  if mode == "edit" then
    return tostring(rowStore.spellDigit or "")
  end
  return tostring(rowStore.spell or "")
end

local function forceManaForRow(rowWidget, rowIndex, mode)
  if not rowWidget then return end
  local manaBox = rowWidget.mana
  if not manaBox then return end

  local rowStore = storage[panelName].rows[rowIndex]
  if not rowStore then return end

  local spell = getSpellForMode(rowStore, mode)
  local cost = SPELL_MANA_COST[spell]
  if not cost then return end

  -- força UI + storage
  manaBox:setValue(cost)
  rowStore.mana = cost
end

local function forceManaAll(mode)
  forceManaForRow(mainPanel.rowSpell1, 1, mode)
  forceManaForRow(mainPanel.rowSpell2, 2, mode)
  forceManaForRow(mainPanel.rowSpell3, 3, mode)
end

local function applyMode(mode)
  storage[panelName].spellMode = (mode == "edit") and "edit" or "pre"
  setRowMode(mainPanel.rowSpell1, storage[panelName].spellMode)
  setRowMode(mainPanel.rowSpell2, storage[panelName].spellMode)
  setRowMode(mainPanel.rowSpell3, storage[panelName].spellMode)

  -- AQUI: força a mana de acordo com o modo escolhido
  forceManaAll(storage[panelName].spellMode)
end
-- init
ensureStorage()

-- bind 3 rows
bindSpellRow(mainPanel.rowSpell1, 1)
bindSpellRow(mainPanel.rowSpell2, 2)
bindSpellRow(mainPanel.rowSpell3, 3)

local btnPre  = mainPanel:getChildById("Pre-config")
local btnEdit = mainPanel:getChildById("Edit-config")

if btnPre then
  btnPre.onClick = function()
    applyMode("pre") -- NÃO RESETA, só muda modo e força mana
  end
end

if btnEdit then
  btnEdit.onClick = function()
    applyMode("edit") -- NÃO RESETA, só muda modo e força mana
  end
end

-- =========================================
-- POTIONS STORAGE (HP/MP) - OTCv8 SAFE (BASEADO NA SUA BASE)
-- =========================================

local panelName = "lnsHealingPanel" -- usa o mesmo se já existir

-- cria storage default
if not storage[panelName] then storage[panelName] = {} end
if not storage[panelName].potions then storage[panelName].potions = {} end
if not storage[panelName].potions.hp then storage[panelName].potions.hp = {} end
if not storage[panelName].potions.mp then storage[panelName].potions.mp = {} end

for i = 1, 3 do
  if not storage[panelName].potions.hp[i] then storage[panelName].potions.hp[i] = { id = 0, min = 50 } end
  if not storage[panelName].potions.mp[i] then storage[panelName].potions.mp[i] = { id = 0, max = 70 } end

  storage[panelName].potions.hp[i].id  = tonumber(storage[panelName].potions.hp[i].id) or 0
  storage[panelName].potions.hp[i].min = tonumber(storage[panelName].potions.hp[i].min) or 50

  storage[panelName].potions.mp[i].id  = tonumber(storage[panelName].potions.mp[i].id) or 0
  storage[panelName].potions.mp[i].max = tonumber(storage[panelName].potions.mp[i].max) or 70
end

local function updatePotionTextSingle(widget, value, isMana)
  value = tonumber(value) or 0
  local labelType = isMana and "MP% <=" or "HP% <="
  if widget and widget.resourceText then
    widget.resourceText:setText(labelType .. " " .. value .. "%")
  end
end

local function setupPotionEntrySingle(widget, data, isMana)
  if not widget then return end
  if not data then data = { id = 0, min = 0, max = 0 } end

  local botItem = widget.potionHp
  local slider  = isMana and widget.scrollMax or widget.scrollMin

  -- aplica item e slider do storage
  if botItem and botItem.setItemId then
    botItem:setItemId(tonumber(data.id) or 0)
  end

  if slider and slider.setValue then
    local v = isMana and (tonumber(data.max) or 0) or (tonumber(data.min) or 0)
    slider:setValue(v)
    updatePotionTextSingle(widget, v, isMana)
  end

  -- callback: quando trocar o item
  if botItem and botItem.onItemChange then
    botItem.onItemChange = function(w)
      local item = w:getItem()
      if item then
        data.id = item:getId()
      else
        data.id = 0
      end
    end
  end

  -- callback: quando mexer no slider
  if slider then
  slider.onValueChange = function(s, v)
    v = tonumber(v) or 0
    if isMana then
      data.max = v
    else
      data.min = v
    end
    updatePotionTextSingle(widget, v, isMana)
    end
  end
end

-- binds HP (rowPotionhp1..3)
setupPotionEntrySingle(mainPanel.rowPotionhp1, storage[panelName].potions.hp[1], false)
setupPotionEntrySingle(mainPanel.rowPotionhp2, storage[panelName].potions.hp[2], false)
setupPotionEntrySingle(mainPanel.rowPotionhp3, storage[panelName].potions.hp[3], false)

-- binds MP (rowPotionMp1..3)
setupPotionEntrySingle(mainPanel.rowPotionMp1, storage[panelName].potions.mp[1], true)
setupPotionEntrySingle(mainPanel.rowPotionMp2, storage[panelName].potions.mp[2], true)
setupPotionEntrySingle(mainPanel.rowPotionMp3, storage[panelName].potions.mp[3], true)

if not storage[panelName] then storage[panelName] = {} end
if not storage[panelName].toggles then storage[panelName].toggles = {} end

local function bindToggleSwitch(switchWidget, key, defaultValue)
  if not switchWidget then return end

  if storage[panelName].toggles[key] == nil then
    storage[panelName].toggles[key] = (defaultValue == true)
  end

  -- aplica estado salvo
  switchWidget:setOn(storage[panelName].toggles[key] == true)

  -- salva ao clicar
  switchWidget.onClick = function(widget)
    local newState = not widget:isOn()
    widget:setOn(newState)
    storage[panelName].toggles[key] = newState
  end
end

bindToggleSwitch(mainPanel.offHealing, "offHealing", true)
bindToggleSwitch(mainPanel.offPotions, "offPotions", true)
bindToggleSwitch(mainPanel.offFood,    "offFood",    true)

-- =========================================
-- MACRO: Healing Spells (prioriza mais forte, fallback por mana)
-- Requisitos:
--  - storage.lnsHealingPanel.toggles.offHealing == true
--  - storage[switchHealing].enabled == true
-- =========================================
local healCooldownUntil = 0

local function isHealingSpellText(txt)
  local cfg = storage.lnsHealingPanel
  if not cfg or type(cfg.rows) ~= "table" then return false end

  txt = tostring(txt or ""):lower()
  if txt == "" then return false end

  for i = 1, 3 do
    local r = cfg.rows[i]
    if r and type(r) == "table" then
      local a = tostring(r.spell or ""):lower()
      local b = tostring(r.spellDigit or ""):lower()
      if (a ~= "" and txt == a) or (b ~= "" and txt == b) then
        return true
      end
    end
  end
  return false
end

onTalk(function(name, level, mode, text, channelId, pos)
  if not player or name ~= player:getName() then return end
  text = tostring(text or ""):lower()

  if isHealingSpellText(text) then
    healCooldownUntil = now + 900
  end
end)


macro(100, function()
  if not player then return end

  -- Condição 1: switch do painel (ONLINE/OFFLINE)
  if not storage.lnsHealingPanel
     or not storage.lnsHealingPanel.toggles
     or storage.lnsHealingPanel.toggles.offHealing ~= true then
    return
  end

  -- Condição 2: healingButton enabled
  if not storage[switchHealing]
     or storage[switchHealing].enabled ~= true then
    return
  end

  local cfg = storage.lnsHealingPanel
  if not cfg.rows or type(cfg.rows) ~= "table" then return end

  local hp = hppercent()
  local mp = mana()

  local mode = (cfg.spellMode == "edit") and "edit" or "pre"

  -- monta lista de spells "aplicáveis" (hp <= threshold e spell != "")
  local candidates = {}

  for i = 1, 3 do
    local r = cfg.rows[i]
    if r and type(r) == "table" then
      local spell = ""
      if mode == "edit" then
        spell = tostring(r.spellDigit or "")
      else
        spell = tostring(r.spell or "")
      end

      local hpTh = tonumber(r.hp) or 0
      local mpNeed = tonumber(r.mana) or 0

      if spell ~= "" and hp <= hpTh then
        -- custo real da spell (preferencial); fallback pro valor do row
        local realCost = SPELL_MANA_COST[spell] or mpNeed
        table.insert(candidates, {
          spell = spell,
          hpTh = hpTh,
          cost = tonumber(realCost) or 0
        })
      end
    end
  end

  if #candidates == 0 then return end

  -- ordena para priorizar a mais forte:
  -- quanto MENOR o hpTh, mais urgente/forte (ex: 50 é mais forte que 90)
  table.sort(candidates, function(a, b)
    return a.hpTh < b.hpTh
  end)

  -- tenta a melhor; se não tiver mana, faz fallback pras próximas
  for _, c in ipairs(candidates) do
    if mp >= (c.cost or 0) then
      if now < healCooldownUntil then return end
      say(c.spell)
      delay(200)
      return
    end
  end
end)

-- =========================================
-- MACRO: Potions HP/MP (SEM precisar backpack aberta)
-- Usa useWith(itemId, player) em vez de g_game.use(item)
-- Condições:
--  1) storage.lnsHealingPanel.toggles.offPotions == true
--  2) storage[switchHealing].enabled == true
-- =========================================

macro(200, function()
  -- Condição 1: switch do painel (ONLINE/OFFLINE) das potions
  if not storage.lnsHealingPanel
     or not storage.lnsHealingPanel.toggles
     or storage.lnsHealingPanel.toggles.offPotions ~= true then
    return
  end

  -- Condição 2: healingButton enabled
  if not storage[switchHealing]
     or storage[switchHealing].enabled ~= true then
    return
  end

  local cfg = storage.lnsHealingPanel
  if not cfg.potions then return end

  local hp = hppercent()
  local mp = manapercent()

  local me = g_game.getLocalPlayer()
  if not me then return end

  -- =========================
  -- HP potions (min): usa se HP <= min
  -- Prioriza menor min (mais urgente)
  -- =========================
  if cfg.potions.hp and type(cfg.potions.hp) == "table" then
    local candidatesHP = {}
    for i = 1, 3 do
      local p = cfg.potions.hp[i]
      if p and type(p) == "table" then
        local id = tonumber(p.id) or 0
        local min = tonumber(p.min) or 0
        if id > 0 and hp <= min then
          table.insert(candidatesHP, { id = id, th = min })
        end
      end
    end

    if #candidatesHP > 0 then
      table.sort(candidatesHP, function(a, b) return a.th < b.th end)
      for _, c in ipairs(candidatesHP) do
        -- useWith não precisa de backpack aberta
        useWith(c.id, me)
        return
      end
    end
  end

  -- =========================
  -- MP potions (max): usa se MP <= max
  -- Prioriza menor max (mais urgente)
  -- =========================
  if cfg.potions.mp and type(cfg.potions.mp) == "table" then
    local candidatesMP = {}
    for i = 1, 3 do
      local p = cfg.potions.mp[i]
      if p and type(p) == "table" then
        local id = tonumber(p.id) or 0
        local max = tonumber(p.max) or 0
        if id > 0 and mp <= max then
          table.insert(candidatesMP, { id = id, th = max })
        end
      end
    end

    if #candidatesMP > 0 then
      table.sort(candidatesMP, function(a, b) return a.th < b.th end)
      for _, c in ipairs(candidatesMP) do
        useWith(c.id, me)
        return
      end
    end
  end
end)
