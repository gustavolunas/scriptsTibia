setDefaultTab("LNS")

local switchSwapEquips = "buttonSwapEquips"

if not storage[switchSwapEquips] then
    storage[switchSwapEquips] = { enabled = false }
end

buttonSwapEquips = setupUI([[
Panel
  height: 18

  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: SWAP EQ
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
buttonSwapEquips:setId(switchSwapEquips)
buttonSwapEquips.title:setOn(storage[switchSwapEquips].enabled)

buttonSwapEquips.title.onClick = function(widget)
    newState = not widget:isOn()
    widget:setOn(newState)
    storage[switchSwapEquips].enabled = newState
end

swapEquipsInterface = setupUI([[
EQPanel < Panel
  size: 160 230
  padding-left: 10
  padding-right: 10
  padding-bottom: 10

  BotItem
    id: head
    image-source: /images/game/slots/head
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    margin-top: 10
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: body
    image-source: /images/game/slots/body
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: legs
    image-source: /images/game/slots/legs
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: feet
    image-source: /images/game/slots/feet
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: neck
    image-source: /images/game/slots/neck
    anchors.top: head.top
    margin-top: 13
    anchors.right: head.left
    margin-right: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: left-hand
    image-source: /images/game/slots/left-hand
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: finger
    image-source: /images/game/slots/finger
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: right-hand
    image-source: /images/game/slots/right-hand
    anchors.left: body.right
    margin-left: 5
    anchors.top: left-hand.top
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: ammo
    image-source: /images/game/slots/ammo
    anchors.horizontalCenter: prev.horizontalCenter
    anchors.top: prev.bottom
    margin-top: 5
    $on:
      image-source: /images/ui/item-blessed

UIWindow
  id: mainPanel
  size: 605 270
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
    !text: tr('LNS Custom | Smart Swapper Equips')
    color: orange
    margin-left: 0
    margin-right: 0
    background-color: black
    $hover:
      image-color: gray
  
  Panel
    id: iconPanel
    anchors.top: parent.top
    anchors.left: parent.left
    size: 60 60
    margin-top: -19
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

  Button
    id: Combat
    anchors.top: topPanel.bottom
    anchors.left: topPanel.left
    size: 80 20
    text: COMBAT
    image-source: /images/ui/button_rounded
    image-color: #363636
    margin-left: 5
    margin-top: 5
    font: verdana-9px
    color: white

  Button
    id: DefAttack
    anchors.top: prev.top
    anchors.left: prev.right
    size: 80 20
    text: DEF/ATTACK
    image-source: /images/ui/button_rounded
    image-color: #363636
    font: verdana-9px
    color: white

  Button
    id: Equipper
    anchors.top: prev.top
    anchors.left: prev.right
    size: 80 20
    text: BOSS/PVP
    image-source: /images/ui/button_rounded
    image-color: #363636
    font: verdana-9px
    color: white

  FlatPanel
    id: panelCombat
    anchors.top: Combat.bottom
    anchors.right: parent.right
    anchors.left: Combat.left
    anchors.bottom: parent.bottom
    margin-right: 5
    margin-top: 1
    margin-bottom: 10
    image-color: #363636

    Label
      id: labelSwapArmaTitle
      anchors.top: parent.top
      anchors.left: parent.left
      anchors.right: parent.right
      text-align: center
      margin-top: 5
      text: SWAP SINGLE WEAPON x AREA WEAPON
      font: verdana-9px
      color: orange

    BotItem
      id: idArmaSingle
      anchors.top: prev.bottom
      anchors.left: prev.left
      margin-top: 5
      margin-left: 5
      image-source: /images/game/slots/left-hand
      $on:
        image-source: /images/ui/item-blessed

    BotItem
      id: idArmaArea
      anchors.top: prev.top
      anchors.left: prev.right
      margin-left: 5
      image-source: /images/game/slots/left-hand
      $on:
        image-source: /images/ui/item-blessed

    BotSwitch
      id: labelSwapArma
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 5
      margin-right: 3
      font: verdana-9px
      height: 18
      color: white
      image-source: /images/ui/button_rounded
      $on:
        font: verdana-9px
        color: green

    HorizontalScrollBar
      id: QntdMob
      anchors.left: prev.left
      anchors.top: prev.bottom
      anchors.right: parent.right
      margin-top: 3
      margin-right: 5
      width: 85
      minimum: 0
      maximum: 10
      step: 1

    Label
      id: labelSwapHelmet
      anchors.top: prev.bottom
      anchors.left: parent.left
      anchors.right: parent.right
      text-align: center
      margin-top: 15
      text: [SWAP MANA LEECH] - WEAPON & HELMET
      font: verdana-9px
      color: orange

    BotItem
      id: idArmaNormal
      anchors.top: labelSwapHelmet.bottom
      anchors.left: prev.left
      image-source: /images/game/slots/left-hand
      margin-top: 10
      margin-left: 5
      $on:
        image-source: /images/ui/item-blessed

    BotItem
      id: idArmaLeech
      anchors.top: prev.top
      anchors.left: prev.right
      margin-left: 5
      image-source: /images/game/slots/left-hand
      $on:
        image-source: /images/ui/item-blessed

    BotSwitch
      id: labelManaArmaLeech
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 5
      margin-right: 3
      font: verdana-9px
      height: 18
      color: white
      image-source: /images/ui/button_rounded
      $on:
        font: verdana-9px
        color: green

    HorizontalScrollBar
      id: manaArmaLeech
      anchors.left: prev.left
      anchors.top: prev.bottom
      anchors.right: parent.right
      margin-top: 3
      margin-right: 5
      width: 85
      minimum: 0
      maximum: 100
      step: 1
  
    BotItem
      id: idHelmetNormal
      anchors.top: prev.bottom
      anchors.left: idArmaNormal.left
      image-source: /images/game/slots/head
      margin-top: 5
      $on:
        image-source: /images/ui/item-blessed

    BotItem
      id: idHelmetLeech
      anchors.top: prev.top
      anchors.left: prev.right
      margin-left: 5
      image-source: /images/game/slots/head
      $on:
        image-source: /images/ui/item-blessed

    BotSwitch
      id: labelManaHelmetLeech
      anchors.top: prev.top
      anchors.left: prev.right
      anchors.right: parent.right
      margin-left: 5
      margin-right: 3
      font: verdana-9px
      height: 18
      color: white
      image-source: /images/ui/button_rounded
      $on:
        font: verdana-9px
        color: green

    HorizontalScrollBar
      id: manaHelmetLeech
      anchors.left: prev.left
      anchors.top: prev.bottom
      anchors.right: parent.right
      margin-top: 3
      margin-right: 5
      width: 85
      minimum: 0
      maximum: 100
      step: 1

  FlatPanel
    id: panelDefAttack
    anchors.top: panelCombat.top
    anchors.right: panelCombat.right
    anchors.left: panelCombat.left
    anchors.bottom: panelCombat.bottom
    image-color: #363636
    
    Label
      id: LabelAttack
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.right: setAttack.right
      text-align: center
      margin-top: 5
      text: "[SET ATTACK]"
      color: orange
      font: verdana-9px

    EQPanel
      id: setAttack
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      margin-top: 20

    Label
      id: LabelDefense
      anchors.left: setDefense.left
      anchors.right: setDefense.right
      anchors.top: parent.top
      text-align: center
      margin-top: 5
      text: "[SET DEFENSE]"
      color: orange
      font: verdana-9px

    EQPanel
      id: setDefense
      anchors.left: setAttack.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      margin-top: 20

    HorizontalScrollBar
      id: hppercentSet
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.bottom: parent.bottom
      margin-bottom: 18
      margin-left: 5
      margin-right: 5
      minimum: 0
      maximum: 100
      step: 1

    CheckBox
      id: checkDefAtk
      anchors.top: prev.bottom
      anchors.left: prev.left
      image-source: /images/ui/checkbox_round
      font: verdana-9px
      margin-top: 3
      text-auto-resize: true
      $checked:
        text: Ativado
      $!checked:
        text: Desativado
      
    Label
      id: labelHPpercentSet
      anchors.top: hppercentSet.top
      anchors.left: hppercentSet.left
      anchors.right: hppercentSet.right
      text-align: center
      text: HP <= 100%
      font: verdana-9px
      color: red

  FlatPanel
    id: panelBossPVP
    anchors.top: panelCombat.top
    anchors.right: panelCombat.right
    anchors.left: panelCombat.left
    anchors.bottom: panelCombat.bottom
    image-color: #363636

    Label
      id: LabelSet1
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.right: setNormal.right
      text-align: center
      margin-top: 5
      text: "[SET NORMAL]"
      color: orange
      font: verdana-9px

    EQPanel
      id: setNormal
      anchors.left: parent.left
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      margin-top: 15

    Label
      id: LabelSet2
      anchors.left: setBoss.left
      anchors.right: setBoss.right
      anchors.top: parent.top
      text-align: center
      margin-top: 5
      text: "[SET BOSS]"
      color: orange
      font: verdana-9px
    
    EQPanel
      id: setBoss
      anchors.left: setNormal.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      margin-top: 15

    Button
      id: bossList
      anchors.left: setBoss.left
      anchors.right: setBoss.right
      anchors.top: setBoss.bottom
      image-source: /images/ui/button_rounded
      image-color: #363636
      margin-top: -30
      font: verdana-9px
      text: Lista Bosses
      height: 16

    CheckBox
      id: setBossAuto
      anchors.left: bossList.left
      anchors.right: bossList.right
      anchors.top: bossList.bottom
      margin-top: 2
      margin-left: 2
      image-source: /images/ui/checkbox_round
      text: Auto Equip
      font: verdana-9px
      text-auto-resize: true

    Label
      id: LabelSet3
      anchors.left: setPVP.left
      anchors.right: setPVP.right
      anchors.top: parent.top
      text-align: center
      margin-top: 5
      text: "[SET PVP]"
      color: orange
      font: verdana-9px

    EQPanel
      id: setPVP
      anchors.left: setBoss.right
      anchors.top: parent.top
      anchors.bottom: parent.bottom
      margin-top: 15

    CheckBox
      id: setPVPAuto
      anchors.left: setPVP.left
      anchors.top: setPVP.bottom
      margin-top: -30
      margin-left: 10
      image-source: /images/ui/checkbox_round
      text: Auto Equip
      font: verdana-9px
      text-auto-resize: true

]], g_ui.getRootWidget())
swapEquipsInterface:hide()
swapEquipsInterface.panelCombat:hide()
swapEquipsInterface.panelDefAttack:hide()
swapEquipsInterface.panelBossPVP:hide()

swapEquipsInterface.closePanel.onClick = function()
  swapEquipsInterface:hide()
end

function buttonsSwapEquipPcMobile()
  if modules._G.g_app.isMobile() then
    buttonSwapEquips.settings:show()
    buttonSwapEquips.title:setMarginRight(55)
  else
    buttonSwapEquips.settings:hide()
    buttonSwapEquips.title:setMarginRight(0)
  end
end
buttonsSwapEquipPcMobile()

buttonSwapEquips.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not swapEquipsInterface:isVisible() then
      swapEquipsInterface:show()
      swapEquipsInterface:raise();
      swapEquipsInterface:focus();
    else
      swapEquipsInterface:hide()
    end
  end
end

buttonSwapEquips.settings.onClick = function()
    if not swapEquipsInterface:isVisible() then
        swapEquipsInterface:show()
        swapEquipsInterface:raise()
        swapEquipsInterface:focus()
    end
end

local function setMainSize(w, h)
  if swapEquipsInterface.mainPanel then
    if swapEquipsInterface.mainPanel.setSize then
      swapEquipsInterface.mainPanel:setSize({width = w, height = h})
    else
      swapEquipsInterface.mainPanel:setWidth(w)
      swapEquipsInterface.mainPanel:setHeight(h)
    end
  else
    if swapEquipsInterface.setSize then
      swapEquipsInterface:setSize({width = w, height = h})
    else
      swapEquipsInterface:setWidth(w)
      swapEquipsInterface:setHeight(h)
    end
  end
end
local function getWin()
  return swapEquipsInterface.mainPanel or swapEquipsInterface
end

local function sizeToWH(sz)
  if type(sz) == "table" then
    return sz.width or sz.w or 0, sz.height or sz.h or 0
  end
  -- alguns builds retornam objeto Size com .width/.height
  return (sz and sz.width) or 0, (sz and sz.height) or 0
end

local function centerWindow(offsetY)
  offsetY = tonumber(offsetY or -60) or -60
  local win = getWin()
  if not win or win:isDestroyed() then return end

  local parent = win:getParent() or g_ui.getRootWidget()
  if not parent or parent:isDestroyed() then return end

  local ps = parent:getSize()
  local ws = win:getSize()

  local pw, ph = sizeToWH(ps)
  local ww, wh = sizeToWH(ws)
  if pw <= 0 or ph <= 0 or ww <= 0 or wh <= 0 then return end

  local x = math.floor((pw - ww) / 2)
  local y = math.floor((ph - wh) / 2) + offsetY

  win:setPosition({ x = x, y = y })
end

-- quebra anchors UMA vez, pra centralização manual funcionar sempre
do
  local win = getWin()
  if win and not win:isDestroyed() and win.breakAnchors then
    win:breakAnchors()
  end
end

-- helper: resize + centraliza (centraliza depois do layout atualizar)
local function setMainSizeCentered(w, h)
  setMainSize(w, h)
  schedule(1, function()
    centerWindow(-60)
  end)
end

local function showCombatPage()
  setMainSizeCentered(330, 240)

  swapEquipsInterface.panelCombat:show()
  swapEquipsInterface.panelDefAttack:hide()
  swapEquipsInterface.panelBossPVP:hide()

  swapEquipsInterface.Combat:setColor("yellow")
  swapEquipsInterface.DefAttack:setColor("gray")
  swapEquipsInterface.Equipper:setColor("gray")
end

local function showDefAttackPage()
  setMainSizeCentered(330, 270)

  swapEquipsInterface.panelCombat:hide()
  swapEquipsInterface.panelDefAttack:show()
  swapEquipsInterface.panelBossPVP:hide()

  swapEquipsInterface.Combat:setColor("gray")
  swapEquipsInterface.DefAttack:setColor("yellow")
  swapEquipsInterface.Equipper:setColor("gray")
end

local function showBossPvpPage()
  setMainSizeCentered(485, 270)

  swapEquipsInterface.panelCombat:hide()
  swapEquipsInterface.panelDefAttack:hide()
  swapEquipsInterface.panelBossPVP:show()

  swapEquipsInterface.Combat:setColor("gray")
  swapEquipsInterface.DefAttack:setColor("gray")
  swapEquipsInterface.Equipper:setColor("yellow")
end

swapEquipsInterface.Combat.onClick = function() showCombatPage() end
swapEquipsInterface.DefAttack.onClick = function() showDefAttackPage() end
swapEquipsInterface.Equipper.onClick = function() showBossPvpPage() end

showCombatPage()

swapEquipsInterface.closePanel.onClick = function()
  swapEquipsInterface:hide()
end

buttonSwapEquips.settings.onClick = function()
  if not swapEquipsInterface:isVisible() then
    swapEquipsInterface:show()
  end
  swapEquipsInterface:raise()
  swapEquipsInterface:focus()

  schedule(1, function()
    centerWindow(-60)
  end)
end

local storePrefix = "swapEquips_v1_"

-- BotItems
local combatItemsToSave = {
  "idArmaSingle","idArmaArea",
  "idArmaNormal","idArmaLeech",
  "idHelmetNormal","idHelmetLeech"
}

for _, id in ipairs(combatItemsToSave) do
  local w = swapEquipsInterface.panelCombat[id]
  if w then
    local saved = storage[storePrefix .. id]
    if saved and saved > 0 then
      w:setItemId(saved)
    end
    w.onItemChange = function(widget)
      storage[storePrefix .. id] = widget:getItemId()
    end
  end
end

local combatSwitchesToSave = {
  "labelSwapArma",
  "labelManaArmaLeech",
  "labelManaHelmetLeech"
}

for _, id in ipairs(combatSwitchesToSave) do
  local w = swapEquipsInterface.panelCombat[id]
  if w then
    if storage[storePrefix .. id] ~= nil then
      w:setOn(storage[storePrefix .. id])
    else
      storage[storePrefix .. id] = w:isOn()
    end

    w.onClick = function(widget)
      widget:setOn(not widget:isOn())
      storage[storePrefix .. id] = widget:isOn()
    end
  end
end

local function bindScroll(id, defaultValue, updateFn)
  local w = swapEquipsInterface.panelCombat[id]
  if not w then return end

  local saved = storage[storePrefix .. id]
  if saved == nil then saved = defaultValue end
  w:setValue(saved)
  storage[storePrefix .. id] = saved
  if updateFn then updateFn(saved) end

  w.onValueChange = function(_, value)
    storage[storePrefix .. id] = value
    if updateFn then updateFn(value) end
  end
end

bindScroll("QntdMob", 3, function(v)
  if swapEquipsInterface.panelCombat.labelSwapArma then
    swapEquipsInterface.panelCombat.labelSwapArma:setText("Mobs >= " .. v)
  end
end)

bindScroll("manaArmaLeech", 80, function(v)
  if swapEquipsInterface.panelCombat.labelManaArmaLeech then
    swapEquipsInterface.panelCombat.labelManaArmaLeech:setText("Mana < " .. v .. "%")
  end
end)

bindScroll("manaHelmetLeech", 60, function(v)
  if swapEquipsInterface.panelCombat.labelManaHelmetLeech then
    swapEquipsInterface.panelCombat.labelManaHelmetLeech:setText("Mana < " .. v .. "%")
  end
end)

local whitelistMonsters = {"Emberwing", "Skullfrost", "Groovebeast", "Thundergiant"}

local function tableFind(t, v)
  if type(t) ~= "table" then return false end
  for _, x in ipairs(t) do
    if x == v then return true end
  end
  return false
end

macro(200, function()
  if not storage[switchSwapEquips] or storage[switchSwapEquips].enabled ~= true then return end

  local combat = swapEquipsInterface.panelCombat
  if not combat or combat:isDestroyed() then return end
  if not storage[storePrefix .. "labelSwapArma"] then return end

  local idSingle = storage[storePrefix .. "idArmaSingle"]
  local idArea   = storage[storePrefix .. "idArmaArea"]
  local limitMob = storage[storePrefix .. "QntdMob"] or 3

  if not idSingle or idSingle <= 100 then return end
  if not idArea or idArea <= 100 then return end
  if not g_game.isAttacking() then return end

  local me = pos()
  local specAmount = 0

  for _, mob in ipairs(getSpectators()) do
    if mob:isMonster() and not mob:isPlayer() then
      local mpos = mob:getPosition()
      if mpos and mpos.z == me.z and getDistanceBetween(me, mpos) <= 5 then
        if not tableFind(whitelistMonsters, mob:getName()) then
          specAmount = specAmount + 1
        end
      end
    end
  end

  local left = getSlot(SlotLeft)
  local currentWeapon = left and left:getId() or 0

  if specAmount >= limitMob then
    if currentWeapon ~= idArea then
      g_game.equipItemId(idArea)
    end
  else
    if currentWeapon ~= idSingle then
      g_game.equipItemId(idSingle)
    end
  end
end)

macro(200, function()
  if not storage[switchSwapEquips] or storage[switchSwapEquips].enabled ~= true then return end

  local combat = swapEquipsInterface.panelCombat
  if not combat or combat:isDestroyed() then return end

  local isAttacking = g_game.isAttacking()
  local manaPct = manapercent()

  if storage[storePrefix .. "labelManaArmaLeech"] then
    local idNormal = storage[storePrefix .. "idArmaNormal"]
    local idLeech  = storage[storePrefix .. "idArmaLeech"]
    local limit    = storage[storePrefix .. "manaArmaLeech"] or 80

    if idNormal and idNormal > 100 and idLeech and idLeech > 100 then
      local left = getSlot(SlotLeft)
      local cur = left and left:getId() or 0

      if not isAttacking then
        if cur ~= idNormal then g_game.equipItemId(idNormal) end
      else
        if manaPct < limit then
          if cur ~= idLeech then g_game.equipItemId(idLeech) end
        else
          if cur ~= idNormal then g_game.equipItemId(idNormal) end
        end
      end
    end
  end

  if storage[storePrefix .. "labelManaHelmetLeech"] then
    local idNormal = storage[storePrefix .. "idHelmetNormal"]
    local idLeech  = storage[storePrefix .. "idHelmetLeech"]
    local limit    = storage[storePrefix .. "manaHelmetLeech"] or 60

    if idNormal and idNormal > 100 and idLeech and idLeech > 100 then
      local head = getSlot(SlotHead)
      local cur = head and head:getId() or 0

      if not isAttacking then
        if cur ~= idNormal then g_game.equipItemId(idNormal) end
      else
        if manaPct < limit then
          if cur ~= idLeech then g_game.equipItemId(idLeech) end
        else
          if cur ~= idNormal then g_game.equipItemId(idNormal) end
        end
      end
    end
  end
end)

local function bindScrollText(root, scrollId, labelId, defaultValue, fmtFn)
  local s = root[scrollId]
  if not s then return end

  local key = storePrefix .. scrollId
  local v = storage[key]
  if v == nil then v = defaultValue or 0 end
  s:setValue(v)
  storage[key] = v

  if labelId and root[labelId] and fmtFn then
    root[labelId]:setText(fmtFn(v))
  end

  s.onValueChange = function(_, value)
    storage[key] = value
    if labelId and root[labelId] and fmtFn then
      root[labelId]:setText(fmtFn(value))
    end
  end
end

local function bindCheckBox(root, id, defaultValue)
  local w = root[id]
  if not w then return end

  local key = storePrefix .. id
  local saved = storage[key]
  if saved == nil then saved = (defaultValue == true) end
  w:setChecked(saved)
  storage[key] = saved

  w.onClick = function(widget)
    widget:setChecked(not widget:isChecked())
    storage[key] = widget:isChecked()
  end
end

local function bindEQPanel(eqPanel, keyPrefix)
  if not eqPanel then return end

  local slots = {
    "head","body","legs","feet","neck",
    "left-hand","finger","right-hand","ammo"
  }

  for _, sid in ipairs(slots) do
    local w = eqPanel[sid]
    if w then
      local key = storePrefix .. keyPrefix .. "_" .. sid
      local saved = storage[key]
      if saved and saved > 0 then
        w:setItemId(saved)
      end

      w.onItemChange = function(widget)
        storage[key] = widget:getItemId()
      end
    end
  end
end

do
  local p = swapEquipsInterface.panelDefAttack
  if p then
    -- EQPanels
    bindEQPanel(p.setDefense, "def_setDefense")
    bindEQPanel(p.setAttack,  "def_setAttack")

    bindCheckBox(p, "checkDefAtk",   false)

    -- Scroll HP% (texto no label)
    bindScrollText(p, "hppercentSet", "labelHPpercentSet", 100, function(v)
      return "HP <= " .. v .. "%"
    end)
  end
end

do
  local p = swapEquipsInterface.panelBossPVP
  if p then
    -- EQPanels
    bindEQPanel(p.setNormal, "boss_setNormal")
    bindEQPanel(p.setBoss,   "boss_setBoss")
    bindEQPanel(p.setPVP,    "boss_setPVP")

    bindCheckBox(p, "setBossAuto",   false)
    bindCheckBox(p, "setPVPAuto",    false)

  end
end

local function autoItemOnState(root)
  if not root or root:isDestroyed() then return end

  local function apply(w)
    if not w or w:isDestroyed() then return end
    if not w.getItemId then return end

    local id = w:getItemId() or 0

    if w.setOn and w.isOn then
      w:setOn(id > 0)
      return
    end

    if w.setImageSource then
      if w._emptyImageSource == nil and w.getImageSource then
        local cur = w:getImageSource()
        if cur and cur ~= "" and cur ~= "/images/ui/item-blessed" then
          w._emptyImageSource = cur
        end
      end

      if id > 0 then
        w:setImageSource("/images/ui/item-blessed")
      else
        if w._emptyImageSource then
          w:setImageSource(w._emptyImageSource)
        end
      end
    end
  end

  local function hook(w)
    if not w or w:isDestroyed() then return end

    if w.getItemId then
      schedule(1, function()
        if w and not w:isDestroyed() then apply(w) end
      end)

      local old = w.onItemChange
      w.onItemChange = function(widget, ...)
        schedule(1, function()
          if widget and not widget:isDestroyed() then apply(widget) end
        end)
        if old then old(widget, ...) end
      end
    end

    if w.getChildren then
      for _, ch in pairs(w:getChildren()) do
        hook(ch)
      end
    end
  end

  hook(root)
end

autoItemOnState(swapEquipsInterface)

local storePrefix = "swapEquips_v1_"
local DEF_DELAY_MS = 5000

local lastDefSwap = 0
local currentMode = "attack"

local function safeItemId(v)
  v = tonumber(v or 0) or 0
  if v <= 100 then return 0 end
  return v
end

local function equipSet(prefixKey)
  local function want(slotName)
    return safeItemId(storage[storePrefix .. prefixKey .. slotName])
  end

  -- ids desejados
  local head  = want("head")
  local body  = want("body")
  local legs  = want("legs")
  local feet  = want("feet")
  local neck  = want("neck")
  local left  = want("left-hand")
  local right = want("right-hand")
  local finger= want("finger")
  local ammo  = want("ammo")

  local function getId(slotConst)
    local it = getSlot(slotConst)
    return it and it:getId() or 0
  end

  if neck  > 0 and getId(SlotNeck)   ~= neck   then g_game.equipItemId(neck,   SlotNeck)   end
  if head  > 0 and getId(SlotHead)   ~= head   then g_game.equipItemId(head,   SlotHead)   end
  if body  > 0 and getId(SlotBody)   ~= body   then g_game.equipItemId(body,   SlotBody)   end
  if legs  > 0 and getId(SlotLeg)    ~= legs   then g_game.equipItemId(legs,   SlotLeg)    end
  if feet  > 0 and getId(SlotFeet)   ~= feet   then g_game.equipItemId(feet,   SlotFeet)   end
  if right > 0 and getId(SlotRight)  ~= right  then g_game.equipItemId(right,  SlotRight)  end
  if left  > 0 and getId(SlotLeft)   ~= left   then g_game.equipItemId(left,   SlotLeft)   end
  if finger> 0 and getId(SlotFinger) ~= finger then g_game.equipItemId(finger, SlotFinger) end
  if ammo  > 0 and getId(SlotAmmo)   ~= ammo   then g_game.equipItemId(ammo,   SlotAmmo)   end
end

macro(200, function()
  if not storage[switchSwapEquips] or storage[switchSwapEquips].enabled ~= true then return end
  if storage[storePrefix .. "checkDefAtk"] ~= true then return end

  local threshold = tonumber(storage[storePrefix .. "hppercentSet"] or 0) or 0
  local hp = hppercent()

  if hp <= threshold then
    if currentMode ~= "def" then
      equipSet("def_setDefense_")
      currentMode = "def"
      lastDefSwap = now
    else
      equipSet("def_setDefense_")
    end
    return
  end

  if currentMode == "def" then
    if (now - lastDefSwap) >= DEF_DELAY_MS then
      equipSet("def_setAttack_")
      currentMode = "attack"
    end
    return
  end

  equipSet("def_setAttack_")
end)


local panelName = "listaBoss"

storage[panelName] = storage[panelName] or {}
storage[panelName].bosses = storage[panelName].bosses or {}

listaBoss = setupUI([[
UIWindow
  id: mainPanel
  size: 250 315
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

  Panel
    id: background
    anchors.fill: parent
    background-color: black
    opacity: 0.70

  Panel
    id: topPanel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    height: 30
    text-align: center
    !text: tr('Insert Bosses Name')
    color: orange
    background-color: black
    $hover:
      image-color: gray

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
    id: panelCombat
    anchors.top: topPanel.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 12
    height: 240
    margin-left: 5
    margin-right: 5
    image-color: #363636

  TextList
    id: bossList
    anchors.top: panelCombat.top
    anchors.left: panelCombat.left
    anchors.right: panelCombat.right
    anchors.bottom: panelCombat.bottom
    margin-left: 6
    margin-right: 17
    margin-top: 6
    margin-bottom: 6
    padding: 1
    vertical-scrollbar: bossListScrollBar
    image-color: #363636

  VerticalScrollBar
    id: bossListScrollBar
    anchors.top: bossList.top
    anchors.bottom: bossList.bottom
    anchors.left: bossList.right
    step: 10
    pixels-scroll: true
    visible: true
    image-color: #363636
    opacity: 0.90

  TextEdit
    id: nameBoss
    anchors.left: parent.left
    anchors.top: panelCombat.bottom
    width: 200
    margin-left: 5
    image-color: #363636
    margin-top: 3
    font: verdana-9px
    placeholder: Name BOSS
    placeholder-font: verdana-9px

  Button
    id: addNameBoss
    anchors.left: prev.right
    anchors.top: panelCombat.bottom
    anchors.right: panelCombat.right
    margin-left: 3
    margin-top: 3
    image-source: /images/ui/button_rounded
    image-color: #363636
    text: +
    font: sans-bold-16px
]], g_ui.getRootWidget())
listaBoss:hide()

swapEquipsInterface.panelBossPVP.bossList.onClick = function()
  listaBoss:show()
  listaBoss:focus()
end

local rowTemplate = [[
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
    id: bossName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
    font: verdana-9px-bold
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

local function trim(s)
  s = tostring(s or "")
  return (s:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function norm(s)
  return trim(s):lower()
end

local function existsBoss(name)
  local n = norm(name)
  for _, v in ipairs(storage[panelName].bosses) do
    if norm(v) == n then return true end
  end
  return false
end

local function removeBoss(name)
  local n = norm(name)
  local newList = {}
  for _, v in ipairs(storage[panelName].bosses) do
    if norm(v) ~= n then table.insert(newList, v) end
  end
  storage[panelName].bosses = newList
end

local function refreshList()
  local list = listaBoss.bossList
  if not list then return end

  local children = list:getChildren() or {}
  for i = #children, 1, -1 do
    local c = children[i]
    if c and not c:isDestroyed() then c:destroy() end
  end

  for i, boss in ipairs(storage[panelName].bosses) do
    boss = trim(boss)
    if boss ~= "" then
      local row = setupUI(rowTemplate, list)
      row.entryName = boss
      row.bossName:setText(boss)

      row.remove.onClick = function()
        removeBoss(row.entryName)
        refreshList()
      end

      row.onClick = function(widget)
        list:focusChild(widget)
      end
    end
  end
end

local function addBossFromInput()
  local name = trim(listaBoss.nameBoss:getText())
  if name == "" then return end

  if existsBoss(name) then
    listaBoss.nameBoss:setText("")
    return
  end

  table.insert(storage[panelName].bosses, name)
  listaBoss.nameBoss:setText("")
  refreshList()
end

listaBoss.closePanel.onClick = function()
  listaBoss:hide()
end

listaBoss.addNameBoss.onClick = function()
  addBossFromInput()
end

listaBoss.nameBoss.onKeyPress = function(_, code)
  if code == KeyEnter or code == KeyReturn then
    addBossFromInput()
    return true
  end
  return false
end

-- INIT
refreshList()

local storePrefix = "swapEquips_v1_"
local BOSS_PANEL_STORAGE = "listaBoss"

local SWAP_DELAY_MS = 5000
local lastSwapBossPvp = 0
local currentBossPvpSet = ""

local function safeItemId(v)
  v = tonumber(v or 0) or 0
  if v <= 100 then return 0 end
  return v
end

local function getSlotId(slotConst)
  local it = getSlot(slotConst)
  return it and it:getId() or 0
end

local function equipBossPvpSet(prefixKey)
  local function want(slotName)
    return safeItemId(storage[storePrefix .. prefixKey .. slotName])
  end

  local neck   = want("neck")
  local head   = want("head")
  local body   = want("body")
  local legs   = want("legs")
  local feet   = want("feet")
  local left   = want("left-hand")
  local right  = want("right-hand")
  local finger = want("finger")
  local ammo   = want("ammo")

  -- ordem segura (igual teu padrão)
  if neck   > 0 and getSlotId(SlotNeck)   ~= neck   then g_game.equipItemId(neck,   SlotNeck)   end
  if head   > 0 and getSlotId(SlotHead)   ~= head   then g_game.equipItemId(head,   SlotHead)   end
  if body   > 0 and getSlotId(SlotBody)   ~= body   then g_game.equipItemId(body,   SlotBody)   end
  if legs   > 0 and getSlotId(SlotLeg)    ~= legs   then g_game.equipItemId(legs,   SlotLeg)    end
  if feet   > 0 and getSlotId(SlotFeet)   ~= feet   then g_game.equipItemId(feet,   SlotFeet)   end
  if right  > 0 and getSlotId(SlotRight)  ~= right  then g_game.equipItemId(right,  SlotRight)  end
  if left   > 0 and getSlotId(SlotLeft)   ~= left   then g_game.equipItemId(left,   SlotLeft)   end
  if finger > 0 and getSlotId(SlotFinger) ~= finger then g_game.equipItemId(finger, SlotFinger) end
  if ammo   > 0 and getSlotId(SlotAmmo)   ~= ammo   then g_game.equipItemId(ammo,   SlotAmmo)   end
end

local function isAttackingPlayer()
  local tgt = g_game.getAttackingCreature()
  return (tgt and tgt.isPlayer and tgt:isPlayer()) or false
end

local function hasBossOnScreen()
  local bosses = storage[BOSS_PANEL_STORAGE] and storage[BOSS_PANEL_STORAGE].bosses
  if type(bosses) ~= "table" or #bosses == 0 then return false end

  local bossLookup = {}
  for _, n in ipairs(bosses) do
    if type(n) == "string" and n ~= "" then
      bossLookup[n:lower()] = true
    end
  end

  local me = pos()
  for _, c in ipairs(getSpectators()) do
    if c and c:isMonster() then
      local cpos = c:getPosition()
      if cpos and me and cpos.z == me.z then
        local name = c:getName()
        if name and bossLookup[name:lower()] then
          return true
        end
      end
    end
  end
  return false
end

local function canSwapTo(setName)
  if setName == currentBossPvpSet then return false end
  if (now - lastSwapBossPvp) < SWAP_DELAY_MS then return false end
  return true
end

macro(200, function()
  if not storage[switchSwapEquips] or storage[switchSwapEquips].enabled ~= true then return end

  local p = swapEquipsInterface and swapEquipsInterface.panelBossPVP
  if not p or p:isDestroyed() then return end

  local autoBoss   = storage[storePrefix .. "setBossAuto"] == true
  local autoPvp    = storage[storePrefix .. "setPVPAuto"] == true

  local attackingPlayer = isAttackingPlayer()
  local bossOnScreen = false

  -- prioridade 1: PVP
  if attackingPlayer then
    if autoPvp then
      if canSwapTo("pvp") then
        equipBossPvpSet("boss_setPVP_")
        currentBossPvpSet = "pvp"
        lastSwapBossPvp = now
      end
    end
    return
  end

  bossOnScreen = hasBossOnScreen()

  if bossOnScreen and autoBoss then
    if canSwapTo("boss") then
      equipBossPvpSet("boss_setBoss_")
      currentBossPvpSet = "boss"
      lastSwapBossPvp = now
    end
    return
  end

  if autoBoss or autoPvp then
    if canSwapTo("normal") then
      equipBossPvpSet("boss_setNormal_")
      currentBossPvpSet = "normal"
      lastSwapBossPvp = now
    end
    return
  end
end)


