setDefaultTab("Cave")

g_ui.loadUIFromString([[
LNSCaveBotFUNC < Panel
  margin-top: 5
  layout:
    type: verticalBox
    fit-children: true

  HorizontalSeparator
  
  Label
    text-align: center
    text: LNS CAVEBOT FUNCTIONS
    font: verdana-9px
    margin-top: 3
    
  HorizontalSeparator
    
  Panel
    id: buttons
    margin-top: 2
    
    layout:
      type: verticalBox
      cell-spacing: 1
      flow: true
      fit-children: true

  HorizontalSeparator
    margin-top: 3
]])

local panel = UI.createWidget("LNSCaveBotFUNC")

storage.caveBot = storage.caveBot or {
  forceRefill = false,
  backStop = false,
  backTrainers = false,
  backOffline = false,
  nextCharMode = "Stamina Menor que:",
  nextCharValue = 0
}

-- =========================================
-- FUNCTIONS INTERFACE
-- =========================================
local functionsInterface = setupUI([[
UIWindow
  id: cavefuncUI
  size: 340 200
  opacity: 0.98
  anchors.centerIn: parent
  margin-top: -60
  focusable: false
  phantom: false

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
    height: 24
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f

  Label
    id: titleLabel
    anchors.left: topBar.left
    anchors.verticalCenter: topBar.verticalCenter
    margin-left: 10
    text: CAVEBOT FUNCTIONS MANAGER
    text-auto-resize: true
    color: orange
    font: verdana-9px

  UIButton
    id: closePanel
    anchors.right: topBar.right
    anchors.verticalCenter: topBar.verticalCenter
    margin-right: 5
    size: 16 16
    text: X
    background-color: orange
    color: white
    opacity: 1.00
    $hover:
      color: black
      opacity: 0.85

  Panel
    id: innerFrame
    anchors.top: topBar.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: footer.top
    margin-left: 8
    margin-right: 8
    margin-top: 8
    margin-bottom: 6
    background-color: #0d0d0d
    border: 1 #1f1f1f
    opacity: 0.96

  Panel
    id: headerLine
    anchors.top: innerFrame.top
    anchors.left: innerFrame.left
    anchors.right: innerFrame.right
    height: 18
    background-color: #141414
    border-bottom: 1 #232323

  Label
    id: sectionTitle
    anchors.centerIn: headerLine
    text: AUTOMATION MODULES
    color: #8d8d8d
    font: verdana-9px

  Button
    id: abrirBuyMarket
    anchors.top: headerLine.bottom
    anchors.left: innerFrame.left
    anchors.right: innerFrame.right
    margin-left: 8
    margin-right: 8
    margin-top: 8
    height: 24
    text: Auto Buy-Market
    font: verdana-11px-rounded
    color: #ffd36b
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $hover:
      image-color: #2a2116
      color: #fff1b3

  Button
    id: abrirImbuiment
    anchors.top: prev.bottom
    anchors.left: innerFrame.left
    anchors.right: innerFrame.right
    margin-left: 8
    margin-right: 8
    margin-top: 5
    height: 24
    text: Auto Imbuiment
    font: verdana-11px-rounded
    color: #ffb46a
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $hover:
      image-color: #2a1f16
      color: #ffd7ac

  Button
    id: abrirSupply
    anchors.top: prev.bottom
    anchors.left: innerFrame.left
    anchors.right: innerFrame.right
    margin-left: 8
    margin-right: 8
    margin-top: 5
    height: 24
    text: Buy+Checker Supply
    font: verdana-11px-rounded
    color: #ff7ee7
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $hover:
      image-color: #261924
      color: #ffc7f5

  Button
    id: nextChar
    anchors.top: prev.bottom
    anchors.left: innerFrame.left
    anchors.right: innerFrame.right
    margin-left: 8
    margin-right: 8
    margin-top: 5
    height: 24
    text: Configurar Proximo Char
    font: verdana-11px-rounded
    color: #dfdfdf
    image-source: /images/ui/button_rounded
    image-color: #2a2a2a
    $hover:
      image-color: #252525
      color: white

  Panel
    id: footer
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    height: 18
    background-color: #0d0d0d
    border-top: 1 #1d1d1d

  Label
    id: footerText
    anchors.verticalCenter: footer.verticalCenter
    anchors.left: prev.left
    anchors.right: prev.right
    text: LNS Scripts - Advanced Functions Cavebot
    text-align: center
    color: #4f4f4f
    font: verdana-9px

]], g_ui.getRootWidget())
functionsInterface:hide()

functionsInterface.closePanel.onClick = function()
  functionsInterface:hide()
end

functionsInterface.abrirBuyMarket.onClick = function()
  marketInterface:show()
  marketInterface:focus()
  functionsInterface:hide()
end

functionsInterface.abrirImbuiment.onClick = function()
  imbuimentInterface:show()
  imbuimentInterface:focus()
  functionsInterface:hide()
end

functionsInterface.abrirSupply.onClick = function()
  warn("Em Desenvolvimento...")
end

-- =========================================
-- CAVE FUNCTIONS UI
-- =========================================
local caveFunctions = setupUI([[
UIWindow
  id: cavefuncUI
  size: 280 79
  opacity: 0.85
  anchors.centerIn: parent
  margin-top: -60
  focusable: true

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
    height: 18
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f

  Label
    id: titleLabel
    anchors.centerIn: topBar
    text: [LNS] Select Cavebot Function
    text-auto-resize: true
    color: orange
    font: verdana-11px-rounded

  ComboBox
    id: TravelOptions
    anchors.top: prev.bottom
    anchors.right: parent.right
    anchors.left: parent.left
    margin-right: 5
    margin-left: 5
    margin-top: 8
    width: 160
    height: 24
    image-color: gray
    text-align: center
    color: gray
    font: verdana-11px-rounded
    @onSetup: |
      self:addOption(" ... ")
      self:addOption("Buying Market")
      self:addOption("Auto Imbuiment")
      self:addOption("Check Supply")
      self:addOption("Login Next Char")

  ComboBox
    id: nextCharOptions
    anchors.top: prev.bottom
    anchors.left: prev.left
    margin-top: 4
    width: 160
    height: 19
    image-color: gray
    text-align: center
    color: gray
    font: verdana-9px
    @onSetup: |
      self:addOption("Stamina Menor que:")
      self:addOption("Level")

  SpinBox
    id: nextCharValue
    anchors.verticalCenter: nextCharOptions.verticalCenter
    anchors.left: prev.right
    width: 107
    height: 19
    margin-left: 2
    text-align: center
    font: verdana-9px
    image-color: gray
    editable: true
    focusable: true
    minimum: 1
    maximum: 9999
    step: 1

  Button
    id: cancelarBt
    anchors.left: parent.left
    anchors.bottom: parent.bottom
    image-source: /images/ui/button_rounded
    size: 137 20
    margin-bottom: 5
    margin-left: 3
    image-color: #363636
    text: CANCEL
    font: verdana-9px
    color: white
    $hover:
      color: #FF4040

  Button
    id: adicionarBt
    anchors.left: cancelarBt.right
    anchors.top: prev.top
    image-source: /images/ui/button_rounded
    size: 137 20
    image-color: #363636
    text: ADD FUNCTION
    font: verdana-9px
    color: white
    $hover:
      color: #98FB98

]], g_ui.getRootWidget())
caveFunctions:hide()

local function getSelectedComboText(combo)
  local current = combo and combo.getCurrentOption and combo:getCurrentOption()
  if type(current) == "table" then
    return current.text or current[1] or " ... "
  end
  return tostring(current or " ... ")
end

local function updateNextCharUI()
  local selected = getSelectedComboText(caveFunctions.TravelOptions)

  if selected == "Login Next Char" then
    caveFunctions:setWidth(280)
    caveFunctions:setHeight(110)
    caveFunctions.nextCharOptions:show()
    caveFunctions.nextCharValue:show()
  else
    caveFunctions:setWidth(280)
    caveFunctions:setHeight(79)
    caveFunctions.nextCharOptions:hide()
    caveFunctions.nextCharValue:hide()
  end
end

loginNextChar = function()
  modules.client_entergame.EnterGame.openWindow()

  local rwPanel = g_ui.getRootWidget():getChildById('charactersWindow')
  if not rwPanel then return false end

  local buttonsPanel = rwPanel:getChildById('characters')
  if not buttonsPanel then return false end

  local childs = buttonsPanel:getChildren()
  if not childs or #childs == 0 then return false end

  local focused = buttonsPanel:getFocusedChild()
  if not focused then
    buttonsPanel:focusChild(buttonsPanel:getFirstChild())
  else
    local fIndex = buttonsPanel:getChildIndex(focused)
    if fIndex == #childs then
      buttonsPanel:focusChild(buttonsPanel:getFirstChild())
    else
      buttonsPanel:focusNextChild()
    end
  end

  rwPanel:onEnter()
  return true
end

caveFunctions.nextCharOptions:setOption(storage.caveBot.nextCharMode or "Stamina Menor que:")
caveFunctions.nextCharValue:setValue(tonumber(storage.caveBot.nextCharValue) or 0)
caveFunctions.nextCharOptions:hide()
caveFunctions.nextCharValue:hide()
updateNextCharUI()

caveFunctions.TravelOptions.onOptionChange = function(widget, optionText, optionData)
  updateNextCharUI()
end

caveFunctions.nextCharOptions.onOptionChange = function(widget, optionText, optionData)
  storage.caveBot.nextCharMode = getSelectedComboText(caveFunctions.nextCharOptions)
  caveFunctions.nextCharValue:setValue(0)
end

caveFunctions.nextCharValue.onValueChange = function(widget, value)
  storage.caveBot.nextCharValue = tonumber(value) or tonumber(widget:getValue()) or 0
end

caveFunctions.cancelarBt.onClick = function()
  caveFunctions:hide()
end

functionsInterface.nextChar.onClick = function()
  caveFunctions:show()
  caveFunctions:focus()
  caveFunctions.TravelOptions:setOption("Login Next Char")
  updateNextCharUI()
  functionsInterface:hide()
end

caveFunctions.adicionarBt.onClick = function()
  if not CaveBot or not CaveBot.addAction then
    caveFunctions:hide()
    return
  end

  local selected = getSelectedComboText(caveFunctions.TravelOptions)
  local actionText = nil

  if selected == "Buying Market" then
    actionText = "startAutoBuyMarket()\nreturn true"

  elseif selected == "Auto Imbuiment" then
    actionText = "checkerImbuementsList()\nreturn true"

  elseif selected == "Check Supply" then
    actionText = "checkLnsSupply()\nreturn true"

  elseif selected == "Login Next Char" then
    local mode = getSelectedComboText(caveFunctions.nextCharOptions)
    local value = tonumber(caveFunctions.nextCharValue:getValue()) or 0

    storage.caveBot.nextCharMode = mode
    storage.caveBot.nextCharValue = value

    if mode == "Stamina Menor que:" then
      actionText = string.format([[
-- CHECK STAMINA
if stamina() <= %d * 60 then
  loginNextChar()
end
return true
]], value)

    elseif mode == "Level" then
      actionText = string.format([[
-- CHECK LEVEL
if player:getLevel() >= %d then
  loginNextChar()
end
return true
]], value)
    end
  end

  if actionText then
    CaveBot.addAction("function", actionText, true)
    if CaveBot.save then
      CaveBot.save()
    end
  end

  caveFunctions.TravelOptions:setOption(" ... ")
  updateNextCharUI()
  caveFunctions:hide()
end

butt1 = addButton("", "FUNCTIONS MANAGER", function()
  functionsInterface:show()
  functionsInterface:focus()
end, panel.buttons)
butt1:setFont("verdana-9px")
butt1:setImageSource("/images/ui/button_rounded")
butt1:setImageColor("#828282")
butt1:setHeight(18)

butt = addButton("", "FUNCTIONS ADD", function()
  caveFunctions:show()
  caveFunctions:focus()
  updateNextCharUI()
end, panel.buttons)
butt:setFont("verdana-9px")
butt:setImageSource("/images/ui/button_rounded")
butt:setImageColor("#363636")
butt:setMarginTop(-0)
butt:setHeight(18)
