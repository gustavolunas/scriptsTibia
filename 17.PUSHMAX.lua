setDefaultTab("War")

-- ============================================================
--  STORAGE
-- ============================================================
if not storage.pvpSystem then
    storage.pvpSystem = {}
end

if not storage.pvpSystem.pushSystem then
    storage.pvpSystem.pushSystem = {
        enabled = false,
        mode = "marcacao",  -- "marcacao" ou "numpad"
        
        -- Delays
        pushDelay = 1060,
        cancelDelayOnRetreat = false,
        
        -- Runa para items bloqueadores
        runeId = 3188,
        useRune = false,
        blockingItems = {3147, 2595, 2118, 2119, 2120, 2129},  -- IDs padrao de items que bloqueiam
        
        -- Destroy Field (limpar fields no caminho)
        destroyField = {
            enabled = false,
            runeId = 3148,  -- Destroy Field rune por padrao
            fieldItems = {2118, 2122, 105, 2119}  -- IDs padrao de fields (fire, poison, etc)
        },
        
        
        -- Modo Marcacao
        marcacao = {
            hotkey = "PageUp",  -- Serve para marcar E executar push
            autoPush = false,   -- Push automatico ate o fim
            showMarkers = true
        },
        
        -- Modo Numpad
        numpad = {
            maxDistance = 7,
            autoRetreat = true,
            keys = {
                ["1"] = "Numpad1",
                ["2"] = "Numpad2",
                ["3"] = "Numpad3",
                ["4"] = "Numpad4",
                ["6"] = "Numpad6",
                ["7"] = "Numpad7",
                ["8"] = "Numpad8",
                ["9"] = "Numpad9"
            }
        }
    }
end

local config = storage.pvpSystem.pushSystem

-- Garantir que destroyField existe (compatibilidade com storages antigos)
if not config.destroyField then
    config.destroyField = {
        enabled = false,
        runeId = 3148,
        fieldItems = {2118, 2122, 105, 2119}
    }
end

-- Garantir que fieldItems existe
config.destroyField.fieldItems = settings.pvp.destroyField.fieldItems or {2118, 2122, 105, 2119}

-- Garantir que numpad.keys existe (compatibilidade)
if not config.numpad.keys then
    config.numpad.keys = {
        ["1"] = "Numpad1",
        ["2"] = "Numpad2",
        ["3"] = "Numpad3",
        ["4"] = "Numpad4",
        ["6"] = "Numpad6",
        ["7"] = "Numpad7",
        ["8"] = "Numpad8",
        ["9"] = "Numpad9"
    }
end

-- ============================================================
--  HELPERS
-- ============================================================

local Helpers = {}

function Helpers.showMessage(msg)
    modules.game_textmessage.displayGameMessage(msg)
end

function Helpers.getDistance(pos1, pos2)
    if not pos1 or not pos2 then return 999 end
    return math.max(math.abs(pos1.x - pos2.x), math.abs(pos1.y - pos2.y))
end

function Helpers.isValidTile(tile)
    if not tile then return false end
    local pos = tile:getPosition()
    if not pos or pos.z ~= posz() then return false end
    if not tile:isWalkable() then return false end
    if tile:hasCreature() then return false end
    return true
end

-- ============================================================
--  UI DEFINITIONS
-- ============================================================

g_ui.loadUIFromString([[
ScrollDetector < UIWidget
  focusable: false
  phantom: true

PVPPushScrollBar < Panel
  height: 35
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  HorizontalScrollBar
    id: scroll
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 3
    minimum: 10
    maximum: 3000
    step: 10

PVPPushItem < Panel
  height: 40
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.verticalCenter: next.verticalCenter

  BotItem
    id: item
    anchors.top: parent.top
    anchors.right: parent.right

PVPPushTextEdit < Panel
  height: 50
  margin-top: 7

  UIWidget
    id: text
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    text-align: center
    
  TextEdit
    id: textEdit
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: prev.bottom
    margin-top: 5
    text-align: center

PVPPushCheckBox < BotSwitch
  height: 20
  margin-top: 7

PVPModeButton < Button
  height: 35
  margin-top: 7
  font: verdana-11px-rounded

PVPTabPanel < Panel
  margin: 3

  VerticalScrollBar
    id: panelScroll
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    step: 28
    pixels-scroll: true
    image-color: #87CEEB

  ScrollablePanel
    id: panelContent
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-left: 6
    margin-right: 10
    padding: 5
    padding-left: 8
    padding-top: 8
    padding-bottom: 8
    vertical-scrollbar: panelScroll
    layout:
      type: verticalBox
      spacing: 5

PVPKeysWindow < UIWindow
  size: 165 215
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
    !text: tr('PushMax Config')
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: black
    $hover:
      image-color: gray

  UIButton
    id: closeButton
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
    id: content
    anchors.top: closeButton.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    margin-top: 18
    margin-left: 5
    margin-right: 5
    margin-bottom: 5
    image-color: #363636

    Label
      anchors.top: parent.top
      anchors.left: parent.left
      id: configureKeys
      margin-top: 5
      margin-left: 8
      font: verdana-9px
      text: Configure Keys Push:

    TextEdit
      id: NW
      anchors.top: prev.bottom
      anchors.left: prev.left
      font: verdana-9px
      margin-top: 10
      placeholder: NW
      width: 40
      placeholder-font: verdana-9px

    TextEdit
      id: N
      anchors.top: prev.top
      anchors.left: prev.right
      margin-top: 0
      margin-left: 10
      font: verdana-9px
      placeholder: N
      width: 40
      placeholder-font: verdana-9px
      
    TextEdit
      id: NE
      anchors.top: prev.top
      anchors.left: prev.right
      margin-top: 0
      margin-left: 10
      font: verdana-9px
      placeholder: NE
      width: 40
      placeholder-font: verdana-9px

    TextEdit
      id: W
      anchors.top: NW.bottom
      anchors.left: NW.left
      margin-top: 10
      font: verdana-9px
      placeholder: W
      width: 40
      placeholder-font: verdana-9px

    TextEdit
      id: E
      anchors.top: NE.bottom
      anchors.left: NE.left
      margin-top: 10
      font: verdana-9px
      placeholder: E
      width: 40
      placeholder-font: verdana-9px

    TextEdit
      id: SW
      anchors.top: W.bottom
      anchors.left: NW.left
      font: verdana-9px
      margin-top: 10
      placeholder: SW
      width: 40
      placeholder-font: verdana-9px

    TextEdit
      id: S
      anchors.top: W.bottom
      anchors.left: N.left
      margin-top: 10
      font: verdana-9px
      placeholder: S
      width: 40
      placeholder-font: verdana-9px
      
    TextEdit
      id: SE
      anchors.top: W.bottom
      anchors.left: NE.left
      margin-top: 10
      font: verdana-9px
      placeholder: SE
      width: 40
      placeholder-font: verdana-9px

    Button
      id: saveBtn
      anchors.top: prev.bottom
      anchors.left: SW.left
      anchors.right: SE.right
      size: 100 20
      margin-top: 10
      text: Save
      font: verdana-9px
      image-source: /images/ui/button_rounded
      image-color: #363636

    Button
      id: resetBtn
      anchors.top: prev.bottom
      anchors.left: prev.left
      anchors.right: prev.right
      margin-top: 2
      size: 100 20
      text: Reset
      font: verdana-9px
      image-source: /images/ui/button_rounded
      image-color: #363636

PVPMainWindow < UIWindow
  size: 315 355
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
    !text: tr('LNS Custom | PushMax')
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: black
    $hover:
      image-color: gray

  UIButton
    id: closeButton
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
    id: content
    anchors.top: topPanel.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-top: 8
    margin-right: 8
    margin-left: 8
    height: 150
    image-color: #363636
    layout: verticalBox

  Label
    id: tipoPush
    anchors.top: prev.top
    anchors.left: content.left
    margin-top: 5
    margin-left: 5
    font: verdana-9px
    text: Tipo de Push:

  Button
    id: buttonNumpad
    anchors.left: content.left
    anchors.top: tipoPush.bottom
    margin-top: 5
    margin-left: 5
    size: 105 21
    image-source: /images/ui/button_rounded
    text: NUMPAD/WASD
    font: verdana-9px

  Button
    id: setupTeclas
    anchors.left: prev.right
    anchors.top: prev.top
    margin-top:
    margin-left: 0
    text: Setup
    font: verdana-9px
    size: 30 21
    image-source: /images/ui/button_rounded
    image-color: #363636

  Button
    id: buttonMarcacao
    anchors.left: setupTeclas.right
    anchors.top: buttonNumpad.top
    size: 105 21
    margin-left: 3
    margin-top:
    image-source: /images/ui/button_rounded
    text: TECLA
    font: verdana-9px

  BotTextEdit
    id: pushKeyEdit
    anchors.left: buttonMarcacao.right
    anchors.top: buttonMarcacao.top
    font: verdana-9px
    anchors.right: content.right
    margin-right: 5
    margin-left: 3
    height: 18
    margin-top: 1
    placeholder: KEY
    text-align: left
    placeholder-font: verdana-9px
    image-color: #828282

  Label
    id: labelDistance
    anchors.top: prev.bottom
    anchors.left: tipoPush.left
    margin-top: 10
    font: verdana-9px
    text: Max Distance Push:

  HorizontalScrollBar
    id: distancePush
    anchors.top: labelDistance.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-right: 5
    margin-left: 5
    margin-top: 3
    minimum: 1
    maximum: 9
    step: 1

  Label
    id: distanceText
    anchors.centerIn: distancePush
    font: verdana-9px
    text: ""

  Label
    id: labelDelay
    anchors.top: distancePush.bottom
    anchors.left: content.left
    margin-top: 8
    margin-left: 5
    font: verdana-9px
    text: Delay Push:

  HorizontalScrollBar
    id: delayPush
    anchors.top: labelDelay.bottom
    anchors.left: content.left
    anchors.right: content.right
    margin-right: 5
    margin-top: 3
    margin-left: 5
    minimum: 10
    maximum: 2000
    step: 10

  Label
    id: delayText
    anchors.centerIn: delayPush
    font: verdana-9px
    text: ""

  CheckBox
    id: autoAfastar
    anchors.top: prev.bottom
    anchors.left: labelDelay.left
    margin-top: 10
    margin-left: 2
    text: Auto Afastar
    text-auto-resize: true
    font: verdana-9px
    image-source: /images/ui/checkbox_round

  FlatPanel
    id: panelRunas
    anchors.top: content.bottom
    anchors.right: content.right
    anchors.left: content.left
    margin-top: 10
    height: 145
    image-color: #363636
    layout: verticalBox

  CheckBox
    id: firefield
    anchors.top: panelRunas.top
    anchors.left: autoAfastar.left
    margin-top: 14
    font: verdana-9px
    text: Fire Field Rune:
    text-auto-resize: true
    image-source: /images/ui/checkbox_round

  BotTextEdit
    id: firefieldKey
    anchors.left: firefield.right
    anchors.top: firefield.top
    font: verdana-9px
    margin-right: 5
    margin-left: 10
    height: 18
    width: 50
    text-align: left
    margin-top: -3
    image-color: #828282
    placeholder: KEY
    placeholder-font: verdana-9px

  BotItem
    id: fireFieldId
    anchors.top: firefieldKey.top
    anchors.left: firefieldKey.right
    margin-top: -7
    margin-left: 110
    image-source: /images/ui/item

  CheckBox
    id: destroyField
    anchors.top: firefield.bottom
    anchors.left: autoAfastar.left
    margin-top: 25
    font: verdana-9px
    text: Destroy Field Rune:
    text-auto-resize: true
    image-source: /images/ui/checkbox_round

  BotItem
    id: destroyFieldId
    anchors.top: destroyField.top
    anchors.left: fireFieldId.left
    margin-top: -3
    image-source: /images/ui/item

  Panel
    id: destroyFieldList
    anchors.top: destroyFieldId.bottom
    anchors.left: destroyField.left
    anchors.right: panelRunas.right
    anchors.bottom: panelRunas.bottom
    margin-right: 5
    margin-top: 3
    margin-bottom: 3
]])

-- ============================================================
--  PAINEL PRINCIPAL
-- ============================================================

-- Definir estilo customizado do BotSwitch para tema dark
g_ui.loadUIFromString([[
PVPSwitch < BotSwitch
  $on:
    color: #32CD32
    image-color: #3CB371
  $!on:
    image-color: gray
    color: white
]])

mainUI = setupUI([[
Panel
  height: 18

  PVPSwitch
    id: switch
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: PUSHMAX
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
    id: setup
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

-- Janela de config
pvpWindow = UI.createWindow('PVPMainWindow', rootWidget)
pvpWindow:hide()
pvpWindow.closeButton.onClick = function(widget)
    pvpWindow:hide()
end

-- Criar paineis com scroll usando o template
pushPanel = UI.createWidget('PVPTabPanel', pvpWindow.content)
pushPanel:setId('pushPanel')

local mainPanel = pvpWindow.content
btnNumpad = pvpWindow.buttonNumpad
btnMarcacao = pvpWindow.buttonMarcacao
hkMarcacao = pvpWindow.buttonMarcacao
pvpWindow.pushKeyEdit.onTextChange = function(w, text)
    config.marcacao.hotkey = text
end
pvpWindow.pushKeyEdit:setText(config.marcacao.hotkey)


-- ============================================================
--  ABA PUSH - Configuração
-- ============================================================

-- Switch principal
mainUI.switch:setOn(config.enabled)
mainUI.switch.onClick = function(widget)
    config.enabled = not config.enabled
    widget:setOn(config.enabled)
end

function buttonsPushPcMobile()
  if modules._G.g_app.isMobile() then
    mainUI.setup:show()
    mainUI.switch:setMarginRight(55)
  else
    mainUI.setup:hide()
    mainUI.switch:setMarginRight(0)
  end
end
buttonsPushPcMobile()

mainUI.switch.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not pvpWindow:isVisible() then
      pvpWindow:show()
      pvpWindow:raise();
      pvpWindow:focus();
    else
      pvpWindow:hide()
    end
  end
end

mainUI.setup.onClick = function()
    pvpWindow:show()
    pvpWindow:raise()
    pvpWindow:focus()
end

-- ============================================================
--  CONFIGURACAO UI
-- ============================================================

local function updateModeButtons()
    if config.mode == "marcacao" then
        btnMarcacao:setColor("#00FF00")
        btnMarcacao:setText("TECLA")
        btnMarcacao:setImageColor("green")
        btnNumpad:setColor("#FFFFFF")
        btnNumpad:setText("NUMPAD")
        btnNumpad:setImageColor("red")
    else
        btnMarcacao:setColor("#FFFFFF")
        btnMarcacao:setText("TECLA")
        btnMarcacao:setImageColor("red")
        btnNumpad:setColor("#00FF00")
        btnNumpad:setText("NUMPAD")
        btnNumpad:setImageColor("green")
    end
end

btnMarcacao.onClick = function()
    -- Se já estiver no modo marcação, ele funciona como um interruptor (toggle)
    if config.mode == "marcacao" then
        config.marcacao.autoPush = not config.marcacao.autoPush
        btnMarcacao:setOn(config.marcacao.autoPush)
    else
        -- Se não estiver, ele apenas muda o modo
        config.mode = "marcacao"
    end
    
    updateModeButtons()
end

btnNumpad.onClick = function()
    config.mode = "numpad"
    updateModeButtons()
end

updateModeButtons()

-- Função helper para converter keyCode em nome legível
local function getKeyName(keyCode, keyboardModifiers)
    -- Mapeamento de keyCodes comuns
    local keyNames = {
        [48] = "0", [49] = "1", [50] = "2", [51] = "3", [52] = "4",
        [53] = "5", [54] = "6", [55] = "7", [56] = "8", [57] = "9",
        [65] = "A", [66] = "B", [67] = "C", [68] = "D", [69] = "E",
        [70] = "F", [71] = "G", [72] = "H", [73] = "I", [74] = "J",
        [75] = "K", [76] = "L", [77] = "M", [78] = "N", [79] = "O",
        [80] = "P", [81] = "Q", [82] = "R", [83] = "S", [84] = "T",
        [85] = "U", [86] = "V", [87] = "W", [88] = "X", [89] = "Y",
        [90] = "Z",
        [32] = "Space",
        [16777219] = "Backspace",
        [16777220] = "Enter",
        [16777217] = "Tab",
        [16777216] = "Escape",
        -- Numpad (keyCodes corretos para OTClient)
        [96] = "Numpad0", [97] = "Numpad1", [98] = "Numpad2",
        [99] = "Numpad3", [100] = "Numpad4", [101] = "Numpad5",
        [102] = "Numpad6", [103] = "Numpad7", [104] = "Numpad8",
        [105] = "Numpad9",
        -- Setas
        [16777234] = "Left", [16777235] = "Up", [16777236] = "Right", [16777237] = "Down",
        -- Function keys
        [16777264] = "F1", [16777265] = "F2", [16777266] = "F3", [16777267] = "F4",
        [16777268] = "F5", [16777269] = "F6", [16777270] = "F7", [16777271] = "F8",
        [16777272] = "F9", [16777273] = "F10", [16777274] = "F11", [16777275] = "F12",
        -- Page/Home/End/Insert/Delete
        [16777238] = "Insert", [16777239] = "Delete", [16777232] = "Home", 
        [16777233] = "End", [16777238] = "PageUp", [16777239] = "PageDown"
    }
    
    local keyName = keyNames[keyCode] or "Key" .. keyCode
    
    -- Adicionar modificadores
    if keyboardModifiers == KeyboardCtrlModifier then
        keyName = "Ctrl+" .. keyName
    elseif keyboardModifiers == KeyboardShiftModifier then
        keyName = "Shift+" .. keyName
    elseif keyboardModifiers == KeyboardAltModifier then
        keyName = "Alt+" .. keyName
    end
    
    return keyName
end

-- Função para abrir janela de setup de teclas
-- Função para abrir janela de setup de teclas (usando seu OTUI pronto)
local function openKeysSetupWindow()
  local keysWindow = UI.createWindow('PVPKeysWindow', rootWidget)
  keysWindow:show()
  keysWindow:raise()
  keysWindow:focus()

  -- Garantir config e config.numpad.keys
  config = config or {}
  config.numpad = config.numpad or {}
  if not config.numpad.keys then
    config.numpad.keys = {
      ["1"] = "Numpad1",
      ["2"] = "Numpad2",
      ["3"] = "Numpad3",
      ["4"] = "Numpad4",
      ["6"] = "Numpad6",
      ["7"] = "Numpad7",
      ["8"] = "Numpad8",
      ["9"] = "Numpad9"
    }
  end

  local function safeKeyName(keyCode, keyboardModifiers)
    if type(getKeyName) == "function" then
      return getKeyName(keyCode, keyboardModifiers)
    end
    -- fallback simples (caso getKeyName não exista nesse client)
    return tostring(keyCode or "")
  end

  local function setFieldText(field, text)
    if not field then return end
    field:setText(text or "")
  end

  local content = keysWindow:getChildById('content')
  if not content then
    keysWindow:destroy()
    return
  end

  local keyFields = {
    ["7"] = content:getChildById("NW"),
    ["8"] = content:getChildById("N"),
    ["9"] = content:getChildById("NE"),
    ["4"] = content:getChildById("W"),
    ["6"] = content:getChildById("E"),
    ["1"] = content:getChildById("SW"),
    ["2"] = content:getChildById("S"),
    ["3"] = content:getChildById("SE"),
  }
  local labels = {
    ["7"] = "^< Noroeste (7):",
    ["8"] = "^ Norte (8):",
    ["9"] = "^> Nordeste (9):",
    ["4"] = "< Oeste (4):",
    ["6"] = "> Leste (6):",
    ["1"] = "v< Sudoeste (1):",
    ["2"] = "v Sul (2):",
    ["3"] = "v> Sudeste (3):"
  }

  for pos, field in pairs(keyFields) do
    local fallback = "Numpad" .. pos
    setFieldText(field, config.numpad.keys[pos] or fallback)
  end

  for pos, field in pairs(keyFields) do
    if field then
      field.onKeyPress = function(widget, keyCode, keyboardModifiers)
        local keyName = safeKeyName(keyCode, keyboardModifiers)
        widget:setText(keyName)
        config.numpad.keys[pos] = keyName

        if Helpers and type(Helpers.showMessage) == "function" then
        end
        return true
      end
    end
  end

  local saveBtn = content:getChildById("saveBtn")
  local resetBtn = content:getChildById("resetBtn")

  if saveBtn then
    saveBtn.onClick = function()
      if Helpers and type(Helpers.showMessage) == "function" then
      end
      keysWindow:hide()
      keysWindow:destroy()
    end
  end

  if resetBtn then
    resetBtn.onClick = function()
      config.numpad.keys = {
        ["1"] = "1",
        ["2"] = "2",
        ["3"] = "3",
        ["4"] = "4",
        ["6"] = "6",
        ["7"] = "7",
        ["8"] = "8",
        ["9"] = "9"
      }

      for pos, field in pairs(keyFields) do
        if field then
          field:setText(config.numpad.keys[pos])
        end
      end

      if Helpers and type(Helpers.showMessage) == "function" then
      end
    end
  end

  if keysWindow.closeButton then
    keysWindow.closeButton.onClick = function()
      keysWindow:hide()
      keysWindow:destroy()
    end
  end
end

pvpWindow.setupTeclas.onClick = function()
    openKeysSetupWindow()
end

config = config or {}
config.numpad = config.numpad or {}
if not config.numpad.maxDistance then config.numpad.maxDistance = 1 end
if not config.pushDelay then config.pushDelay = 200 end

-- Pega scrollbars/labels do painel
local distanceScroll = pvpWindow:recursiveGetChildById('distancePush')
local distanceText   = pvpWindow:recursiveGetChildById('distanceText')

local delayScroll = pvpWindow:recursiveGetChildById('delayPush')
local delayText   = pvpWindow:recursiveGetChildById('delayText')

if distanceScroll and distanceText then
  distanceScroll:setRange(1, 9)     -- seu OTUI já tem, mas não custa garantir
  distanceScroll:setStep(1)

  -- clamp simples pra não estourar
  local v = tonumber(config.numpad.maxDistance) or 1
  if v < 1 then v = 1 end
  if v > 9 then v = 9 end
  config.numpad.maxDistance = v

  distanceScroll:setValue(v)
  distanceText:setText("Max Distance Push: " .. v)

  distanceScroll.onValueChange = function(scroll, value)
    config.numpad.maxDistance = value
    distanceText:setText("Max Distance Push: " .. value)
  end
end

if delayScroll and delayText then
  delayScroll:setRange(10, 2000)  -- seu OTUI: 10..2000 step 10
  delayScroll:setStep(10)

  local d = tonumber(config.pushDelay) or 200
  if d < 10 then d = 10 end
  if d > 2000 then d = 2000 end
  -- força múltiplo de 10 (já que step é 10)
  d = math.floor(d / 10) * 10
  config.pushDelay = d

  delayScroll:setValue(d)
  delayText:setText("Delay Push: " .. d .. "ms")

  delayScroll.onValueChange = function(scroll, value)
    config.pushDelay = value
    delayText:setText("Delay Push: " .. value .. "ms")
  end
end


config = config or {}
config.numpad = config.numpad or {}
pvpWindow.autoAfastar:setChecked(config.numpad.autoRetreat == true)
pvpWindow.autoAfastar.onCheckChange = function(_, checked)
  config.numpad.autoRetreat = checked == true
end

-- Separador visual
local runaSeparator = UI.createWidget('HorizontalSeparator', mainPanel)
runaSeparator:setMarginTop(300)

-- ============================================================
--  FIRE FIELD
-- ============================================================
-- ====== FIRE FIELD CONFIG (painel) ======
config.fireField = config.fireField or { enabled = false, key = "", runeId = 0 }

local uiFireCheck = pvpWindow:recursiveGetChildById('firefield')
local uiFireKey   = pvpWindow:recursiveGetChildById('firefieldKey')
local uiFireItem  = pvpWindow:recursiveGetChildById('fireFieldId')

if uiFireCheck then
  uiFireCheck:setChecked(config.fireField.enabled == true)
  uiFireCheck.onCheckChange = function(_, checked)
    config.fireField.enabled = checked == true
  end
end

if uiFireKey then
  if uiFireKey.setText then
    uiFireKey:setText(tostring(config.fireField.key or ""))
  end
  uiFireKey.onTextChange = function(_, text)
    config.fireField.key = tostring(text or "")
  end
end

if uiFireItem then
  if uiFireItem.setItemId then
    uiFireItem:setItemId(tonumber(config.fireField.runeId) or 0)
  end
  uiFireItem.onItemChange = function(widget)
    if widget and widget.getItemId then
      config.fireField.runeId = widget:getItemId()
    end
  end
end

-- ====== FIRE FIELD HOTKEY ======
local function trim(s)
  s = tostring(s or "")
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local lastFireAt = 0
local function nowMs()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return math.floor(os.clock() * 1000)
end

onKeyDown(function(keys)
  -- precisa estar com o PushMax ligado
  if not mainUI or not mainUI.switch or not mainUI.switch.isOn or mainUI.switch:isOn() ~= true then return end

  -- precisa estar habilitado no checkbox
  if config.fireField.enabled ~= true then return end

  -- tecla e runa configuradas
  local hk = config.fireField.key
  local runeId = tonumber(config.fireField.runeId) or 0
  if trim(hk) == "" or runeId <= 0 then return end

  -- só dispara se a tecla configurada estiver pressionada
  if not modules.corelib.g_keyboard.isKeyPressed(hk) then return end

  -- anti spam
  local t = nowMs()
  if (t - lastFireAt) < 350 then return end
  lastFireAt = t

  local target = g_game.getAttackingCreature() or g_game.getFollowingCreature()
  if not target then return end

  local playerPos = pos()
  local targetPos = target:getPosition()
  if not playerPos or not targetPos then return end

  local distX = math.abs(playerPos.x - targetPos.x)
  local distY = math.abs(playerPos.y - targetPos.y)
  local distance = math.max(distX, distY)

  local parameters = { ignoreNonPathable = true, precision = 1, ignoreCreatures = true }

  local function tryUse()
    if getDistanceBetween(pos(), target:getPosition()) == 1 then
      useWith(runeId, player)
    end
  end

  if distance > 1 then
    autoWalk(targetPos, 40, parameters)
    schedule(300, tryUse)
  else
    tryUse()
  end
end)


-- ============================================================
--  DESTROY FIELD (Limpar Fields no Caminho)
-- ============================================================
config = config or {}
config.destroyField = config.destroyField or { enabled = false, runeId = 0, fieldItems = {} }

local useDestroyFieldCheck = pvpWindow:recursiveGetChildById('destroyField')
local destroyFieldItem = pvpWindow:recursiveGetChildById('destroyFieldId')

-- CHECKBOX (usa setChecked + onCheckChange, igual o que funciona no seu client)
if useDestroyFieldCheck then
  useDestroyFieldCheck:setChecked(config.destroyField.enabled == true)

  useDestroyFieldCheck.onCheckChange = function(_, checked)
    config.destroyField.enabled = checked == true
  end
end

-- BOTITEM (runa destroy field)
if destroyFieldItem then
  if destroyFieldItem.setItemId then
    destroyFieldItem:setItemId(tonumber(config.destroyField.runeId) or 0)
  end

  destroyFieldItem.onItemChange = function(widget)
    if widget and widget.getItemId then
      config.destroyField.runeId = widget:getItemId()
    end
  end
end

-- Label para fields a destruir
local fieldItemsLabel = UI.createWidget('UIWidget', mainPanel)
fieldItemsLabel:setHeight(20)
fieldItemsLabel:setMarginTop(10)
fieldItemsLabel:setText("Fields/Walls para Destruir:")
fieldItemsLabel:setTextAlign(AlignCenter)
fieldItemsLabel:setColor("#FFAA00")

config = config or {}
config.destroyField = config.destroyField or { enabled = false, runeId = 0, fieldItems = {} }

local hostPanel = pvpWindow:recursiveGetChildById('destroyFieldList')
if not hostPanel then
  print("[DESTROY CONFIG] ERRO: nao achei Panel destroyFieldList no OTUI")
  return
end

-- evita duplicar caso reabra a janela
if hostPanel._dfContainer and hostPanel._dfContainer.destroy then
  pcall(function() hostPanel._dfContainer:destroy() end)
  hostPanel._dfContainer = nil
end

-- cria o container editor DENTRO do panel
local fieldItemsContainer = UI.ContainerEx(function(_, items)
  local itemIds = normalizeContainerItems(items)

  config.destroyField.fieldItems = itemIds

  settings = loadSettings()
  settings.pvp = settings.pvp or {}
  settings.pvp.destroyField = settings.pvp.destroyField or {}
  settings.pvp.destroyField.fieldItems = itemIds
  saveSettings(settings)

end, true, hostPanel)  -- << PARENTA no hostPanel (não no mainPanel)

-- parent + preencher o panel
fieldItemsContainer:setParent(hostPanel)
fieldItemsContainer:fill('parent')

-- carregar itens salvos
fieldItemsContainer:setItems(settings.pvp.destroyField.fieldItems or {})

-- tooltip (se existir no seu build)
if fieldItemsContainer.setTooltip then
  fieldItemsContainer:setTooltip("Clique para adicionar IDs de fields/walls que devem ser destruidos (fire, poison, energy, magic wall). O destroy field sera usado automaticamente quando detectar.")
end

-- guarda referência pra não duplicar
hostPanel._dfContainer = fieldItemsContainer

-- Info sobre itens bloqueadores
local blockingInfo = UI.createWidget('UIWidget', mainPanel)
blockingInfo:setHeight(50)
blockingInfo:setMarginTop(5)
blockingInfo:setTextWrap(true)
blockingInfo:setTextAlign(AlignCenter)
blockingInfo:setColor("#AAAAAA")
blockingInfo:setText("Clique no box acima para adicionar IDs.\nExemplos: 3147 (parcel), 2595 (box),\n2118 (fire field), 2119 (energy field)")

-- Info
local infoLabel = UI.createWidget('UIWidget', mainPanel)
infoLabel:setHeight(100)
infoLabel:setMarginTop(15)
infoLabel:setTextWrap(true)
infoLabel:setTextAlign(AlignCenter)
infoLabel:setColor("#FFFF00")

local function updateInfo()
  if config.mode == "marcacao" then
    infoLabel:setText(string.format([[
MODO AUTOMATICO:
1. %s = Marcar alvo
2. %s = Marcar destino
3. Empurra ate o fim!
4. Ao chegar = Marque novo destino
ESC = Recomecar do zero
]], config.marcacao.hotkey, config.marcacao.hotkey))
  else
    infoLabel:setText([[
MODO TECLAS:
1. Ataque criatura OU de Look nela
2. Use as teclas configuradas para empurrar
   (padrao: numpad 1-9)
   7 8 9
   4   6
   1 2 3
]])
  end
end

btnMarcacao.onClick = function()
    config.mode = "marcacao"
    updateModeButtons()
    updateInfo()
end

btnNumpad.onClick = function()
    config.mode = "numpad"
    updateModeButtons()
    updateInfo()
end

-- ============================================================
--  VARIAVEIS DE ESTADO DO PUSH (ANTES DE TUDO!)
-- ============================================================

do
-- Encapsular sistema de Push para reduzir variáveis locais

PushState = {
    -- Marcacao
    retreatLockUntil = 0,
    markedTarget = nil,
    markedTargetPos = nil,  -- Pode ser tile vazio!
    markedDest = nil,
    markStep = 0,  -- 0=nada, 1=alvo marcado, 2=destino marcado
    isProgressive = false,
    manualPush = false,  -- Push manual via scroll
    
    -- Numpad
    currentTarget = nil,
    lastLookName = nil,
    
    -- Geral
    lastPush = 0,
    
    -- Controle de retreat (evitar loop)
    justRetreated = false,
    retreatTime = 0,
    lastPlayerMove = 0,
    
    -- Posicao antiga do jogador (antes do retreat) - bloquear essa posicao!
    blockedPlayerPos = nil,
    blockedUntil = 0,
    
    -- Debug
    lastDebugMsg = 0
}

updateInfo()

-- Limpar marcacoes (so usado no resetPush com ESC)
local function clearMarkers()
    for _, tile in pairs(g_map.getTiles(posz())) do
        local text = tile:getText()
        if text == "Target" or text == "Dest" then
            tile:setText('')
        end
    end
    if PushState.markedTarget then
        PushState.markedTarget:setMarked(nil)
    end
end

-- Manter marcacoes visiveis durante o push (otimizado para evitar flickering)
local lastTargetPos = nil
local lastDestCheck = 0

local function updateMarkers()
    local currentTime = now
    
    -- Atualizar TARGET (so quando alvo se move)
    if PushState.markedTarget then
        local targetPos = PushState.markedTarget:getPosition()
        if targetPos and targetPos.z == posz() then
            -- Verificar se alvo mudou de posicao
            local posChanged = not lastTargetPos or 
                             lastTargetPos.x ~= targetPos.x or 
                             lastTargetPos.y ~= targetPos.y
            
            if posChanged then
                -- Limpar texto da posicao antiga
                if lastTargetPos then
                    local oldTile = g_map.getTile(lastTargetPos)
                    if oldTile and oldTile:getText() == "Target" then
                        oldTile:setText('')
                    end
                end
                
                -- Marcar nova posicao
                local targetTile = g_map.getTile(targetPos)
                if targetTile then
                    targetTile:setText('Target')
                end
                
                lastTargetPos = {x = targetPos.x, y = targetPos.y, z = targetPos.z}
            end
            
            -- Manter criatura marcada em verde (so a cada 1 segundo)
            if currentTime - lastDestCheck > 1000 then
                PushState.markedTarget:setMarked('red')
            end
        end
    end
    
    -- Atualizar DEST (so a cada 1 segundo para evitar flickering)
    if PushState.markedDest and PushState.markedDest.z == posz() then
        if currentTime - lastDestCheck > 1000 then
            local destTile = g_map.getTile(PushState.markedDest)
            if destTile then
                local currentText = destTile:getText()
                if currentText ~= "Dest" then
                    destTile:setText('Dest')
                end
            end
            lastDestCheck = currentTime
        end
    end
end

local function clearDestMarker()
    for _, tile in pairs(g_map.getTiles(posz())) do
        if tile and tile:getText() == "Dest" then
            pcall(function() tile:setText('') end)
        end
    end
end

-- ============================================================
-- RESET PUSH (ESC) - LIMPEZA COMPLETA
-- ============================================================

local function resetPush()
    clearMarkers()  -- Limpa TARGET e DEST
    PushState.markedTarget = nil
    PushState.markedTargetPos = nil
    PushState.markedDest = nil
    PushState.markStep = 0  -- Volta para zero (pode marcar tudo do zero)
    PushState.isProgressive = false
    PushState.manualPush = false
    PushState.justRetreated = false
    lastTargetPos = nil  -- Resetar cache de posicao
    
    -- Limpar TUDO: Holds, TRAPs e MW ALVO!
    for _, tile in pairs(g_map.getTiles(posz())) do
        local text = tile:getText()
        if text and text ~= "" then
            -- Limpar qualquer texto (Holds, Traps, MW ALVO, etc)
            tile:setText("")
        end
    end
end

-- Verificar se posicao tem obstaculo (incluindo jogador e onde ele VAI ESTAR)
local function hasObstacle(checkPos)
    if not checkPos then return true end
    
    local tile = g_map.getTile(checkPos)
    if not tile then return true end
    if not tile:isWalkable() then return true end
    
    -- IMPORTANTE: Verificar se o JOGADOR esta ou VAI ESTAR nessa posicao!
    local playerPos = pos()
    
    -- 1. Verificar posicao ATUAL do jogador
    if playerPos.x == checkPos.x and playerPos.y == checkPos.y and playerPos.z == checkPos.z then
        return true  -- Jogador esta aqui!
    end
    
    -- 2. Verificar posicao BLOQUEADA (onde jogador estava antes de recuar)
    if PushState.blockedPlayerPos and now < PushState.blockedUntil then
        if PushState.blockedPlayerPos.x == checkPos.x and 
           PushState.blockedPlayerPos.y == checkPos.y and 
           PushState.blockedPlayerPos.z == checkPos.z then
            return true  -- Posicao bloqueada (jogador estava aqui antes de recuar)!
        end
    end
    
    -- 3. Verificar se tem criatura
    local creatures = tile:getCreatures()
    if #creatures > 0 then
        -- Ignorar a criatura que estamos empurrando (o target)
        if #creatures == 1 and PushState.markedTarget then
            if creatures[1]:getId() == PushState.markedTarget:getId() then
                -- E o proprio target, nao conta como obstaculo
                return false
            end
        end
        -- Qualquer outra criatura = obstaculo
        return true
    end
    
    return false
end

-- Funcao simples: retorna APENAS o proximo passo ideal
-- Nao calcula caminho completo, apenas o PROXIMO tile para empurrar
local function getNextStep(currentPos, targetPos)
    if not currentPos or not targetPos then return nil end
    
    -- Calcular todas as 8 direcoes adjacentes
    local allDirections = {
        {x = currentPos.x + 1, y = currentPos.y,     z = currentPos.z, name = "L"},  -- Leste
        {x = currentPos.x - 1, y = currentPos.y,     z = currentPos.z, name = "O"},  -- Oeste
        {x = currentPos.x,     y = currentPos.y + 1, z = currentPos.z, name = "S"},  -- Sul
        {x = currentPos.x,     y = currentPos.y - 1, z = currentPos.z, name = "N"},  -- Norte
        {x = currentPos.x + 1, y = currentPos.y + 1, z = currentPos.z, name = "SE"}, -- Sudeste
        {x = currentPos.x - 1, y = currentPos.y + 1, z = currentPos.z, name = "SO"}, -- Sudoeste
        {x = currentPos.x + 1, y = currentPos.y - 1, z = currentPos.z, name = "NE"}, -- Nordeste
        {x = currentPos.x - 1, y = currentPos.y - 1, z = currentPos.z, name = "NO"}  -- Noroeste
    }
    
    -- Filtrar apenas tiles LIVRES
    local freeDirections = {}
    for _, dir in ipairs(allDirections) do
        local isBlocked = hasObstacle(dir)
        
        if not isBlocked then
            -- Calcular distancia ate o destino
            dir.distToTarget = Helpers.getDistance(dir, targetPos)
            table.insert(freeDirections, dir)
        end
    end
    
    -- Se nenhuma direcao livre, retorna nil
    if #freeDirections == 0 then
        return nil
    end
    
    -- Escolher a direcao que MAIS APROXIMA do destino
    local bestDir = freeDirections[1]
    for _, dir in ipairs(freeDirections) do
        if dir.distToTarget < bestDir.distToTarget then
            bestDir = dir
        end
    end
    
    return bestDir
end

-- Detectar fields (configurados pelo jogador) no tile
local function hasFieldInTile(pos)
    if not config.destroyField.fieldItems or #config.destroyField.fieldItems == 0 then
        return false
    end
    
    if not pos then return false end
    
    local tile = g_map.getTile(pos)
    if not tile then return false end
    
    -- Verificar items no tile
    local items = tile:getItems()
    if not items then return false end
    
    -- Contar items
    local itemCount = 0
    for _ in pairs(items) do
        itemCount = itemCount + 1
    end
    
    if itemCount == 0 then
        return false
    end
    
    -- Verificar se algum field da lista esta no tile
    for _, item in pairs(items) do
        if item and type(item) == "userdata" and item.getId then
            local itemId = item:getId()
            
            -- Comparar com lista (tratando TABELAS e NUMEROS)
            for _, fieldId in ipairs(config.destroyField.fieldItems) do
                local compareId = fieldId
                
                -- Se for tabela, extrair o ID
                if type(fieldId) == "table" then
                    compareId = fieldId.id or fieldId.itemId
                end
                
                -- MATCH encontrado!
                if compareId and itemId == compareId then
                    print("[DESTROY] Field ID " .. itemId .. " detectado no tile!")
                    return true
                end
            end
        end
    end
    
    return false
end

-- Executar push simples
local function executePush(creature, destPos)
    if not config.enabled then return false end
    if not creature or not destPos then return false end
    
    local currentTime = now
    if currentTime - PushState.lastPush < config.pushDelay then
        return false  -- Aguardando delay
    end
    
    local creaturePos = creature:getPosition()
    if not creaturePos then return false end
    
    -- Verificar distancia criatura->destino (adjacente = 1)
    local dist = Helpers.getDistance(creaturePos, destPos)
    if dist ~= 1 then
        return false
    end
    
    -- Validar tile de destino
    local destTile = g_map.getTile(destPos)
    if not destTile or not destTile:isWalkable() or destTile:hasCreature() then
        return false
    end
    
    -- ============================================================
    -- 2. DESTROY FIELD FALLBACK (ADJACENTE - 1 sqm)
    -- ============================================================
    if config.destroyField.enabled and config.destroyField.runeId > 0 then
        local hasField = hasFieldInTile(destPos)
        
        if hasField then
            local destroyRune = findItem(config.destroyField.runeId)
            if destroyRune and type(destroyRune) == "userdata" then
                local pathTile = g_map.getTile(destPos)
                if pathTile then
                    local ground = pathTile:getGround()
                    if ground and type(ground) == "userdata" and ground.getId then
                        -- VALIDAÇÃO EXTRA: Testar se getId() funciona ANTES de usar
                        local testSuccess, testId = pcall(function() return ground:getId() end)
                        if testSuccess and testId and testId > 0 then
                            local success = pcall(function()
                                g_game.useInventoryItemWith(config.destroyField.runeId, ground)
                            end)
                            if success then
                                -- NAO usar delay() aqui! Retornar e agendar push
                                PushState.lastPush = currentTime + 600  -- Aguardar 600ms
                                return false  -- Nao executar push agora, aguardar delay
                            end
                        end
                    end
                end
            else
                return false
            end
        end
    end
    
    -- 3. Executar push
    g_game.move(creature, destPos)
    
    PushState.lastPush = currentTime
    return true
end

local function autoRetreat(targetPos, pushDirection)
    if not config.numpad.autoRetreat then return false end
    if not targetPos or not pushDirection then return false end
    
    local currentTime = now
    
    -- ANTI-LOOP: Multiplas verificacoes para evitar loop
    -- 1. Se acabou de recuar (menos de 800ms), nao recuar novamente
    if PushState.justRetreated and (currentTime - PushState.retreatTime) < 800 then
        return false
    end
    
    -- 2. Se jogador se moveu recentemente (menos de 600ms), nao recuar automaticamente
    --    (significa que ele esta se posicionando manualmente)
    if (currentTime - PushState.lastPlayerMove) < 600 then
        return false
    end
    
    local playerPos = pos()
    local distance = Helpers.getDistance(playerPos, targetPos)
    
    -- Se esta colado (distancia 0 ou 1), precisa recuar
    if distance <= 1 then
        -- Calcular onde o jogador esta em relacao ao alvo
        local relativeX = playerPos.x - targetPos.x
        local relativeY = playerPos.y - targetPos.y
        
        -- Andar na direcao OPOSTA ao alvo para se afastar
        local retreatPos = {
            x = playerPos.x,
            y = playerPos.y,
            z = playerPos.z
        }
        
        -- Se esta no mesmo X (NORTE ou SUL), andar no eixo Y
        if relativeX == 0 then
            if relativeY < 0 then
                retreatPos.y = playerPos.y - 1  -- Esta ao norte, anda mais norte
            else
                retreatPos.y = playerPos.y + 1  -- Esta ao sul, anda mais sul
            end
        -- Se esta no mesmo Y (OESTE ou LESTE), andar no eixo X
        elseif relativeY == 0 then
            if relativeX < 0 then
                retreatPos.x = playerPos.x - 1  -- Esta a oeste, anda mais oeste
            else
                retreatPos.x = playerPos.x + 1  -- Esta a leste, anda mais leste
            end
        -- Se esta na DIAGONAL, andar APENAS no eixo X (esquerda ou direita)
        else
            if relativeX < 0 then
                retreatPos.x = playerPos.x - 1  -- Esta a oeste, anda mais oeste
            else
                retreatPos.x = playerPos.x + 1  -- Esta a leste, anda mais leste
            end
            -- NAO anda no Y quando diagonal (simplificado)
        end
        
        -- Validar posicao de retreat
        local retreatTile = g_map.getTile(retreatPos)
        if retreatTile and retreatTile:isWalkable() and not retreatTile:hasCreature() then
            -- SALVAR posicao ATUAL do jogador ANTES de recuar
            local playerCurrentPos = pos()
            PushState.blockedPlayerPos = {
                x = playerCurrentPos.x,
                y = playerCurrentPos.y,
                z = playerCurrentPos.z
            }
            PushState.blockedUntil = now + 1500  -- Bloquear por 1.5 segundos
            
            -- Recuar (andar = cancela delay!)
            autoWalk(retreatPos, true, true)
            
            -- Marcar que acabou de recuar
            PushState.justRetreated = true
            PushState.retreatTime = now
            
            return true
        else
            -- Se nao conseguiu recuar na direcao ideal, tentar outras
            local alternativeRetreat = {
                {x = playerPos.x - 1, y = playerPos.y},
                {x = playerPos.x + 1, y = playerPos.y},
                {x = playerPos.x, y = playerPos.y - 1},
                {x = playerPos.x, y = playerPos.y + 1}
            }
            
            for _, altPos in ipairs(alternativeRetreat) do
                altPos.z = playerPos.z
                local altTile = g_map.getTile(altPos)
                if altTile and altTile:isWalkable() and not altTile:hasCreature() then
                    -- Verificar se fica MAIS LONGE do alvo
                    local newDist = Helpers.getDistance(altPos, targetPos)
                    if newDist > distance then
                        -- SALVAR posicao ATUAL antes de recuar
                        local playerCurrentPos = pos()
                        PushState.blockedPlayerPos = {
                            x = playerCurrentPos.x,
                            y = playerCurrentPos.y,
                            z = playerCurrentPos.z
                        }
                        PushState.blockedUntil = now + 1500
                        
                        autoWalk(altPos, true, true)
                        
                        -- Marcar que acabou de recuar
                        PushState.justRetreated = true
                        PushState.retreatTime = now
                        
                        return true
                    end
                end
            end
        end
    end
    
    return false
end

-- ============================================================
--  MODO MARCACAO - HOTKEY E MOUSE
-- ============================================================

-- Funcao compartilhada de marcacao E execucao de push
-- Funcao compartilhada de marcacao (push sempre automatico no modo marcacao)
local function doMark()
  -- Se já tem alvo e destino marcados (step 2):
  -- agora NÃO existe modo manual, então não executa "1 push por vez" aqui.
  -- Só tenta detectar alvo se você marcou tile vazio e ele apareceu depois.
  if PushState.markStep == 2 and PushState.markedDest then
    if not PushState.markedTarget and PushState.markedTargetPos then
      local targetTile = g_map.getTile(PushState.markedTargetPos)
      if targetTile then
        local creatures = targetTile:getCreatures()
        if #creatures > 0 then
          PushState.markedTarget = creatures[1]
          PushState.markedTarget:setMarked('red')
        end
      end
    end
    return
  end

  local tile = getTileUnderCursor()
  if not tile then return end

  if PushState.markStep == 0 then
    -- Marcar alvo (PODE SER TILE VAZIO!)
    local creatures = tile:getCreatures()

    if #creatures > 0 then
      PushState.markedTarget = creatures[1]
      PushState.markedTarget:setMarked('red')
      PushState.markedTargetPos = nil
    else
      PushState.markedTarget = nil
      PushState.markedTargetPos = tile:getPosition()
    end

    tile:setText('Target')
    PushState.markStep = 1

  elseif PushState.markStep == 1 then
    -- Marcar destino (APENAS UMA VEZ!)
    if Helpers.isValidTile(tile) then
      local destPos = tile:getPosition()

      pcall(function() tile:setText('Dest') end)
      PushState.markedDest = destPos
      PushState.markStep = 2

      -- SEMPRE automático agora
      PushState.isProgressive = true

    else
      resetPush()
    end
  end
end


-- Deteccao de hotkey
onKeyDown(function(keys)
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    
    -- Normalizar teclas para comparação (case-insensitive)
    local normalizedKeys = string.lower(keys or "")
    local hotkey = string.lower(config.marcacao.hotkey or "")
    
    -- Hotkey para marcar alvo/destino
    if normalizedKeys == hotkey then
        doMark()
    end
    
end)

-- Detectar criatura entrando no tile de alvo marcado (ARMADILHA)
macro(200, function()
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    if PushState.markStep < 1 then return end
    
    -- Se marcou tile vazio como alvo, verificar se alguma criatura entrou
    if not PushState.markedTarget and PushState.markedTargetPos then
        local targetTile = g_map.getTile(PushState.markedTargetPos)
        if targetTile then
            local creatures = targetTile:getCreatures()
            if #creatures > 0 then
                -- Detectou criatura! Marcar UMA VEZ
                if not PushState.markedTarget then
                    PushState.markedTarget = creatures[1]
                    PushState.markedTarget:setMarked('red')
                    
                    -- ARMADILHA: Se ja tem destino, empurrar automatico!
                    if PushState.markedDest then
                        PushState.isProgressive = true
                    else
                    end
                end
            end
        end
    end
end)

-- Macro para manter marcacoes visiveis (otimizado)
macro(200, function()
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    if PushState.markStep > 0 then
        updateMarkers()  -- Atualizar apenas quando necessario
    end
end)

-- Macro para push progressivo (so executa quando scroll ativa)
macro(50, function()
    if not config.enabled then return end
    if config.mode ~= "marcacao" then return end
    if not PushState.isProgressive then return end
    if not PushState.markedTarget or not PushState.markedDest then return end
    
    -- Verificar se target ainda existe
    local targetPos = PushState.markedTarget:getPosition()
    if not targetPos or targetPos.z ~= posz() then
        -- Target perdido, mas manter destino marcado se tiver
        if PushState.markedDest then
            PushState.markedTarget = nil
            PushState.markStep = 1  -- Volta para "alvo marcado"
            PushState.isProgressive = false
        else
            resetPush()
        end
        return
    end
    
    -- Verificar se chegou no destino EXATO
    if targetPos.x == PushState.markedDest.x and 
       targetPos.y == PushState.markedDest.y and 
       targetPos.z == PushState.markedDest.z then
        -- Chegou! Limpar destino e permitir marcar novo destino
        if PushState.isProgressive then  -- So executar uma vez
            
            -- Limpar APENAS destino (manter alvo marcado)
            clearDestMarker()
            PushState.markedDest = nil
            PushState.isProgressive = false
            PushState.markStep = 1  -- Volta para "alvo marcado" (pode marcar novo destino)
            
            -- Se era tile vazio, manter posicao para proxima deteccao
            if not PushState.markedTarget and PushState.markedTargetPos then
                -- Manter markedTargetPos para proxima deteccao
            end
            -- Se era criatura, manter ela marcada (markedTarget ja esta marcado)
        end
        
        -- Limpar APENAS o DEST (mantem TARGET)
        clearDestMarker()
        PushState.markedDest = nil
        PushState.markStep = 1  -- Volta para "alvo marcado" (pode marcar novo destino)
        
        return  -- Para o macro
    end
    
    -- Removido: Nao desativar isProgressive no modo manual
    -- O macro vai executar 1 push e parar naturalmente ate proxima hotkey ativar
    
    -- Verificar delay (respeitando cancelamento)
    local currentTime = now
    if currentTime - PushState.lastPush < config.pushDelay then
        return  -- Aguardando delay
    end
    
    -- CALCULAR PROXIMO PASSO (valida em tempo real!)
    -- Testa TODAS as 8 direcoes e escolhe a melhor livre
    local nextStep = getNextStep(targetPos, PushState.markedDest)
    
    if not nextStep then
        -- NENHUMA direcao livre! Todos os 8 tiles adjacentes estao bloqueados
        -- Mostrar mensagem para jogador saber (mas nao spammar)
        if (now - (PushState.lastDebugMsg or 0)) > 2000 then
            PushState.lastDebugMsg = now
        end
        return
    end
    
    -- Verificar se o proximo passo REALMENTE esta adjacente (deve sempre ser)
    local distToNext = Helpers.getDistance(targetPos, nextStep)
    if distToNext ~= 1 then
        return
    end
    
    -- ============================================================
    -- DESTROY FIELD DE LONGE (ate 5 sqm)
    -- ============================================================
    if config.destroyField.enabled and config.destroyField.runeId > 0 then
        local playerPos = pos()
        local playerToDestDist = Helpers.getDistance(playerPos, nextStep)
        
        if playerToDestDist <= 5 then
            local hasField = hasFieldInTile(nextStep)
            
            if hasField then
                local destroyRune = findItem(config.destroyField.runeId)
                if destroyRune and type(destroyRune) == "userdata" then
                    local pathTile = g_map.getTile(nextStep)
                    if pathTile then
                        local ground = pathTile:getGround()
                        if ground and type(ground) == "userdata" and ground.getId then
                            -- VALIDAÇÃO EXTRA: Testar se getId() funciona ANTES de usar
                            local testSuccess, testId = pcall(function() return ground:getId() end)
                            if testSuccess and testId and testId > 0 then
                                local success = pcall(function()
                                    g_game.useInventoryItemWith(config.destroyField.runeId, ground)
                                end)
                                if success then
                                    -- NAO usar delay() aqui! Agendar proximo push
                                    PushState.lastPush = now + 700  -- Aguardar 700ms
                                    return  -- Parar aqui, proximo ciclo do macro vai tentar push
                                end
                            end
                        end
                    end
                else
                    return
                end
            end
        end
    end
    
    -- Tile encontrado e livre, preparar para empurrar
    local destTile = g_map.getTile(nextStep)
    if Helpers.isValidTile(destTile) then
        -- AUTO-RETREAT no modo marcacao!
        local playerPos = pos()
        local playerToTargetDist = Helpers.getDistance(playerPos, targetPos)
        
        -- Se jogador esta muito perto (0 ou 1), recuar primeiro
        if playerToTargetDist <= 1 and config.numpad.autoRetreat then
            -- Calcular direcao do push
            local pushDir = {
                x = nextStep.x - targetPos.x,
                y = nextStep.y - targetPos.y
            }
            
            -- Tentar recuar
            if autoRetreat(targetPos, pushDir) then
                -- Recuou! Delay sera cancelado pelo movimento
                -- NAO executar push aqui - deixar o macro fazer no proximo ciclo
                -- O delay ja foi cancelado pelo movimento
                return
            end
        end
        
        -- Se nao precisou recuar OU recuo falhou, empurrar diretamente
        local pushResult = executePush(PushState.markedTarget, nextStep)
        if pushResult then
            -- Push executado com sucesso!
            PushState.justRetreated = false
            -- Limpar bloqueio da posicao antiga do jogador
            PushState.blockedPlayerPos = nil
            PushState.blockedUntil = 0
            PushState.retreatLockUntil = 0
        end
    end
end)

-- Reset ao mover no modo marcacao (APENAS se nao tiver marcacoes)
-- REMOVIDO: onPlayerPositionChange que chamava resetPush()
-- Isso estava limpando os Holds indevidamente ao andar
-- Agora resetPush() é chamado APENAS com ESC!

-- Reset ao pressionar ESC (limpa TUDO do zero)
onKeyDown(function(keys)
    if not config.enabled then return end
    if keys == "Escape" then
        -- Sempre limpar TUDO com ESC, mesmo sem marcações
        resetPush()
        PushState.currentTarget = nil
    end
end)

-- ============================================================
--  MODO TECLAS - LOOK + DIRECIONAL
-- ============================================================

-- Sistema de Look
onTextMessage(function(mode, text)
    if not config.enabled then return end
    if config.mode ~= "numpad" then return end
    
    local name = text:match("You see ([^%(]+)")
    if name then
        name = name:gsub("^%s*(.-)%s*$", "%1")  -- trim
        PushState.lastLookName = name
        
        -- Buscar criatura
        for _, creature in ipairs(getSpectators()) do
            if creature:getName() == name and creature:getPosition().z == posz() then
                PushState.currentTarget = creature
                return
            end
        end
    end
end)

-- Sistema de Look automatico (captura quando jogador da look em qualquer criatura)
-- Nao precisa de hotkey especifica, usa o look normal do jogo

-- Target automatico (atacando/seguindo)
macro(100, function()
    if not config.enabled then return end
    if config.mode ~= "numpad" then return end
    
    local attacking = g_game.getAttackingCreature()
    local following = g_game.getFollowingCreature()
    
    if attacking then
        PushState.currentTarget = attacking
    elseif following then
        PushState.currentTarget = following
    end
end)

-- Push direcional (teclas configuráveis)
onKeyDown(function(keys)
    if not config.enabled then return end
    if config.mode ~= "numpad" then return end
    
    -- Mapeamento de direções
    local directionVectors = {
        ["1"] = {x = -1, y =  1},  -- Sudoeste
        ["2"] = {x =  0, y =  1},  -- Sul
        ["3"] = {x =  1, y =  1},  -- Sudeste
        ["4"] = {x = -1, y =  0},  -- Oeste
        ["6"] = {x =  1, y =  0},  -- Leste
        ["7"] = {x = -1, y = -1},  -- Noroeste
        ["8"] = {x =  0, y = -1},  -- Norte
        ["9"] = {x =  1, y = -1}   -- Nordeste
    }
    
    -- Encontrar qual direção corresponde à tecla pressionada
    local dir = nil
    local dirPos = nil
    
    -- Normalizar teclas para comparação (case-insensitive)
    local normalizedKeys = string.lower(keys or "")
    
    if config.numpad.keys then
        for pos, keyName in pairs(config.numpad.keys) do
            local normalizedKeyName = string.lower(keyName or "")
            if normalizedKeys == normalizedKeyName then
                dir = directionVectors[pos]
                dirPos = pos
                break
            end
        end
    end
    
    if not dir then return end
    
    if not PushState.currentTarget then
        Helpers.showMessage("Selecione o Player que deseja empurrar")
        return
    end
    
    local targetPos = PushState.currentTarget:getPosition()
    if not targetPos or targetPos.z ~= posz() then
        PushState.currentTarget = nil
        return
    end
    
    -- Verificar distancia
    local distance = Helpers.getDistance(pos(), targetPos)
    
    if distance > config.numpad.maxDistance then
        return
    end
    
    -- Calcular destino
    local destPos = {
        x = targetPos.x + dir.x,
        y = targetPos.y + dir.y,
        z = targetPos.z
    }
    
    -- Validar tile destino
    local destTile = g_map.getTile(destPos)
    if not Helpers.isValidTile(destTile) then
        Helpers.showMessage("Impossivel arastar para este SQM")
        return
    end
    
    -- ============================================================
    -- DESTROY FIELD DE LONGE (ate 5 sqm) - MODO TECLAS
    -- ============================================================
    if config.destroyField.enabled and config.destroyField.runeId > 0 then
        local playerPos = pos()
        local playerToDestDist = Helpers.getDistance(playerPos, destPos)
        
        -- Se destino esta a ate 5 sqm E tem field, usar destroy de longe
        if playerToDestDist <= 5 then
            local hasField = hasFieldInTile(destPos)
            
            if hasField then
                local destroyRune = findItem(config.destroyField.runeId)
                if destroyRune and type(destroyRune) == "userdata" then
                    local pathTile = g_map.getTile(destPos)
                    if pathTile then
                        local ground = pathTile:getGround()
                        if ground and type(ground) == "userdata" and ground.getId then
                            -- VALIDAÇÃO EXTRA: Testar se getId() funciona ANTES de usar
                            local testSuccess, testId = pcall(function() return ground:getId() end)
                            if testSuccess and testId and testId > 0 then
                                local success = pcall(function()
                                    g_game.useInventoryItemWith(config.destroyField.runeId, ground)
                                end)
                                if success then
                                    -- Agendar push apos destroy field fazer efeito
                                schedule(700, function()
                                    if PushState.currentTarget then
                                        executePush(PushState.currentTarget, destPos)
                                    end
                                end)
                                return  -- Parar aqui, push sera executado apos delay
                            end
                            end
                        end
                    end
                else
                    return
                end
            end
        end
    end
    
    -- Tentar auto-retreat
    if autoRetreat(targetPos, dir) then
        schedule(400, function()
            if PushState.currentTarget then
                executePush(PushState.currentTarget, destPos)
            end
        end)
    else
        -- Executar push direto
        executePush(PushState.currentTarget, destPos)
    end
end)

-- ============================================================
--  CANCELAR AO RECUAR
-- ============================================================

onPlayerPositionChange(function(newPos, oldPos)
    if not config.enabled then return end
    
    -- Detectar movimento do jogador
    if oldPos and newPos then
        local moved = (oldPos.x ~= newPos.x or oldPos.y ~= newPos.y)
        
        if moved then
            -- Atualizar tempo do ultimo movimento
            PushState.lastPlayerMove = now
            
            -- Se cancelar delay ao recuar esta ativo
            if config.cancelDelayOnRetreat then
                -- Resetar delay para permitir push imediato
                PushState.lastPush = 0
                
                -- Feedback visual em ambos os modos
                if config.mode == "numpad" and PushState.currentTarget then
                elseif config.mode == "marcacao" and PushState.isProgressive then
                end
            end
            
            -- Sistema ja recalcula automaticamente a cada 50ms no macro
            -- Nao precisa fazer nada aqui
        end
    end
end)

-- Scroll do mouse removido (causava erros)
-- Sistema funciona perfeitamente apenas com hotkey

end -- Fim do bloco do sistema de Push










