setDefaultTab("LNS")

UI.Separator()

local switchSwap = "swapButton"
if not storage[switchSwap] then storage[switchSwap] = { enabled = false } end

swapButton = setupUI([[
Panel
  height: 18
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: SWAP
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
swapButton:setId(switchSwap)
swapButton.title:setOn(storage[switchSwap].enabled)

swapButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchSwap].enabled = newState
end

panelSwap = setupUI([[  
RingConfig < Panel
  height: 65
  margin-top: 3

  BotItem
    id: ringPadrao
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    image-source: /images/game/slots/finger
    tooltip: Ring Padrao
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: ringEquipavel
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    image-source: /images/game/slots/finger
    margin-left: 5
    tooltip: Ring Especial
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: ringEquipavelID
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    image-source: /images/game/slots/finger
    margin-left: 5
    tooltip: [ID] Ring Especial
    $on:
      image-source: /images/ui/item-blessed

  HorizontalScrollBar
    id: hpEquip
    anchors.left: ringEquipavelID.right
    anchors.top: ringEquipavelID.top
    width: 120
    margin-top: 0
    margin-left: 5
    minimum: 0
    maximum: 100
    step: 1

  Label
    id: hpEquipLabel
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    text: Equip: 0%
    font: verdana-9px
    color: white
    text-align: center

  HorizontalScrollBar
    id: hpDesequip
    anchors.left: hpEquip.left
    anchors.top: prev.bottom
    width: 120
    margin-top: 8
    minimum: 0
    maximum: 100
    step: 1

  Label
    id: hpDesequipLabel
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    text: Unequip: 0%
    font: verdana-9px
    color: white
    text-align: center

  BotSwitch
    id: ativador
    anchors.left: ringPadrao.left
    anchors.right: ringEquipavelID.right
    anchors.top: ringPadrao.bottom
    margin-right: -10
    margin-left: -2
    margin-top: 3
    height: 22
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #3a1010
    $on:
      color: #ffd37a
      image-color: green
      opacity: 1.00
    $!on:
      color: #b9b9b9
      image-color: #2a2a2a
      opacity: 0.95

  BotSwitch
    id: ativadorFull
    anchors.left: hpEquipLabel.left
    margin-left: 10
    anchors.right: hpEquip.right
    anchors.top: ringPadrao.bottom
    margin-top: 3
    height: 22
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #3a1010
    $on:
      color: #ffd37a
      image-color: green
      opacity: 1.00
    $!on:
      color: #b9b9b9
      image-color: #2a2a2a
      opacity: 0.95

  VerticalSeparator
    id: vertSep
    anchors.top: ringPadrao.top
    anchors.bottom: ativador.bottom
    anchors.left: prev.right
    margin-left: 10

  BotItem
    id: backpack
    anchors.top: ringPadrao.top
    anchors.left: prev.right
    margin-left: 30
    image-source: /images/game/slots/back-blessed
    $on:
      image-source: /images/ui/item-blessed

  BotSwitch
    id: ativadorBP
    anchors.top: ativador.top
    anchors.left: vertSep.right
    anchors.bottom: ativador.bottom
    text: BP Inteligente
    height: 22
    margin-top: 0
    margin-left: 6
    text-auto-resize: true
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #3a1010
    $on:
      color: #ffd37a
      image-color: green
      opacity: 1.00
    $!on:
      color: #b9b9b9
      image-color: #2a2a2a
      opacity: 0.95

AmuletConfig < Panel
  height: 65
  margin-top: 3

  BotItem
    id: amuletPadrao
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    image-source: /images/game/slots/neck
    tooltip: Amulet Padrao
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: amuletEquipavel
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    image-source: /images/game/slots/neck
    margin-left: 5
    tooltip: Amulet Especial
    $on:
      image-source: /images/ui/item-blessed

  BotItem
    id: amuletEquipavelID
    anchors.left: prev.right
    anchors.verticalCenter: parent.verticalCenter
    image-source: /images/game/slots/neck
    margin-left: 5
    tooltip: [ID] Amulet Especial
    $on:
      image-source: /images/ui/item-blessed

  HorizontalScrollBar
    id: hpEquip
    anchors.left: amuletEquipavelID.right
    anchors.top: amuletEquipavelID.top
    width: 120
    margin-top: 0
    margin-left: 5
    minimum: 0
    maximum: 100
    step: 1

  Label
    id: hpEquipLabel
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    text: Equip: 0%
    font: verdana-9px
    color: white
    text-align: center

  HorizontalScrollBar
    id: hpDesequip
    anchors.left: hpEquip.left
    anchors.top: prev.bottom
    width: 120
    margin-top: 8
    minimum: 0
    maximum: 100
    step: 1

  Label
    id: hpDesequipLabel
    anchors.top: prev.top
    anchors.left: prev.left
    anchors.right: prev.right
    text: Unequip: 0%
    font: verdana-9px
    color: white
    text-align: center
    
  BotSwitch
    id: ativador
    anchors.left: amuletPadrao.left
    anchors.right: amuletEquipavelID.right
    anchors.top: amuletPadrao.bottom
    margin-right: -10
    margin-left: -2
    margin-top: 3
    height: 22
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #3a1010
    $on:
      color: #ffd37a
      image-color: green
      opacity: 1.00
    $!on:
      color: #b9b9b9
      image-color: #2a2a2a
      opacity: 0.95

  BotSwitch
    id: ativadorFull
    anchors.left: hpEquipLabel.left
    margin-left: 10
    anchors.right: hpEquip.right
    anchors.top: amuletPadrao.bottom
    margin-top: 3
    height: 22
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #3a1010
    $on:
      color: #ffd37a
      image-color: green
      opacity: 1.00
    $!on:
      color: #b9b9b9
      image-color: #2a2a2a
      opacity: 0.95

  VerticalSeparator
    id: vertSep
    anchors.top: amuletPadrao.top
    anchors.bottom: ativador.bottom
    anchors.left: prev.right
    margin-left: 10

  BotItem
    id: backpack
    anchors.top: amuletPadrao.top
    anchors.left: prev.right
    margin-left: 30
    image-source: /images/game/slots/back-blessed
    $on:
      image-source: /images/ui/item-blessed

  BotSwitch
    id: ativadorBP
    anchors.top: ativador.top
    anchors.left: vertSep.right
    anchors.bottom: ativador.bottom
    text: BP Inteligente
    margin-top: 0
    margin-left: 6
    text-auto-resize: true
    height: 22
    font: verdana-9px
    image-source: /images/ui/button_rounded
    image-color: #3a1010
    $on:
      color: #ffd37a
      image-color: green
      opacity: 1.00
    $!on:
      color: #b9b9b9
      image-color: #2a2a2a
      opacity: 0.95

UIWindow
  id: panelSwap
  size: 365 285
  border: 1 black
  anchors.centerIn: parent
  margin-top: -60

  Panel
    id: background
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.bottom: parent.bottom
    background-color: #0b0b0b
    opacity: 0.88

  Panel
    id: topPanel
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    size: 120 30
    text-align: center
    !text: tr('LNS Custom | Smart Swap')
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f
    color: orange
    font: verdana-11px-rounded
    margin-left: 0
    margin-right: 0

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

  Button
    id: Ring
    anchors.top: topPanel.bottom
    anchors.left: topPanel.left
    size: 80 22
    text: RING
    image-source: /images/ui/button_rounded
    image-color: #363636
    margin-left: 9
    margin-top: 5
    font: verdana-9px
    color: white

  Button
    id: Amulet
    anchors.top: prev.top
    anchors.left: prev.right
    size: 80 22
    text: AMULET
    image-source: /images/ui/button_rounded
    image-color: #363636
    font: verdana-9px
    color: white

  Panel
    id: abaRing
    anchors.top: prev.bottom
    anchors.bottom: parent.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 2
    margin-bottom: 10
    margin-left: 10
    margin-right: 10
    padding-left: 10
    padding-top: -10
    background-color: #1b1b1b
    border: 1 #3b2a10
    opacity: 0.95
    layout: verticalBox

    RingConfig
      id: ring1
      margin-left: -8
      size: 330 70

    RingConfig
      id: ring2
      margin-left: -8
      size: 330 70

    RingConfig
      id: ring3
      margin-left: -8
      size: 330 70

  Panel
    id: abaAmulet
    anchors.top: abaRing.top
    anchors.bottom: abaRing.bottom
    anchors.left: abaRing.left
    anchors.right: abaRing.right
    padding-left: 10
    padding-top: -10
    background-color: #1b1b1b
    border: 1 #3b2a10
    opacity: 0.95
    layout: verticalBox

    AmuletConfig
      id: amulet1
      margin-left: -8
      size: 330 70

    AmuletConfig
      id: amulet2
      margin-left: -8
      size: 330 70

    AmuletConfig
      id: amulet3
      margin-left: -8
      size: 330 70

]], g_ui.getRootWidget())

panelSwap:hide()
panelSwap.abaRing:show()
panelSwap.Ring:setColor("#ffd37a")
panelSwap.abaAmulet:hide()

swapButton.settings.onClick = function()
  panelSwap:setVisible(not panelSwap:isVisible())
end

panelSwap.closePanel.onClick = function()
  panelSwap:hide()
end

function buttonsSwapRingPcMobile()
  if modules._G.g_app.isMobile() then
    swapButton.settings:show()
    swapButton.title:setMarginRight(55)
  else
    swapButton.settings:hide()
    swapButton.title:setMarginRight(0)
  end
end
buttonsSwapRingPcMobile()

swapButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not panelSwap:isVisible() then
      panelSwap:show()
      panelSwap:raise();
      panelSwap:focus();
    else
      panelSwap:hide()
    end
  end
end

panelSwap.Ring.onClick = function()
  panelSwap.Ring:setColor("#ffd37a")
  panelSwap.Amulet:setColor("gray")
  panelSwap.abaRing:show()
  panelSwap.abaAmulet:hide()
end

panelSwap.Amulet.onClick = function()
  panelSwap.Ring:setColor("gray")
  panelSwap.Amulet:setColor("#ffd37a")
  panelSwap.abaRing:hide()
  panelSwap.abaAmulet:show()
end

-- =========================
-- STORAGE + BINDS + BLOQUEIO (Unequip >= Equip)
-- =========================
local panelStoreName = "panelSwapStorage"

if not storage[panelStoreName] then
  storage[panelStoreName] = {
    ring = { [1] = {}, [2] = {}, [3] = {} },
    amulet = { [1] = {}, [2] = {}, [3] = {} }
  }
end

local function sched(ms, fn)
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  return fn()
end

local function ensureEntry(root, idx)
  root[idx] = root[idx] or {}
  return root[idx]
end

local function safeSetItem(widget, id)
  if not widget then return end
  id = tonumber(id) or 0
  if widget.setItemId then
    widget:setItemId(id)
  end
end

local function safeGetItem(widget)
  if not widget then return 0 end
  if widget.getItemId then return tonumber(widget:getItemId()) or 0 end
  if widget.getItem then
    local it = widget:getItem()
    if it and it.getId then return tonumber(it:getId()) or 0 end
  end
  return 0
end

local function bindBotItem(widget, store, key, defaultId)
  if not widget then return end
  local v = tonumber(store[key]) or 0
  if (v <= 0) and (tonumber(defaultId) or 0) > 0 then
    v = tonumber(defaultId)
    store[key] = v
  end
  safeSetItem(widget, v)
  widget.onItemChange = function(w)
    store[key] = safeGetItem(w)
  end
end

local function setLabel(label, prefix, v)
  if label and label.setText then
    label:setText(prefix .. tostring(v) .. "%")
  end
end

local function bindEquipUnequipPair(sbEquip, sbUnequip, lbEquip, lbUnequip, store, keyEquip, keyUnequip)
  if not sbEquip or not sbUnequip then return end

  local e = tonumber(store[keyEquip])
  local u = tonumber(store[keyUnequip])

  if e == nil then e = (sbEquip.getValue and sbEquip:getValue()) or 0 end
  if u == nil then u = (sbUnequip.getValue and sbUnequip:getValue()) or 0 end

  if e < 0 then e = 0 end
  if e > 100 then e = 100 end
  if u < 0 then u = 0 end
  if u > 100 then u = 100 end
  if u < e then u = e end

  store[keyEquip] = e
  store[keyUnequip] = u

  if sbEquip.setValue then sbEquip:setValue(e) end
  if sbUnequip.setValue then sbUnequip:setValue(u) end
  setLabel(lbEquip, "equip: ", e)
  setLabel(lbUnequip, "unequip: ", u)

  sbEquip.onValueChange = function(_, value)
    value = tonumber(value) or 0
    if value < 0 then value = 0 end
    if value > 100 then value = 100 end

    store[keyEquip] = value
    setLabel(lbEquip, "equip: ", value)

    local curU = tonumber(store[keyUnequip]) or (sbUnequip.getValue and sbUnequip:getValue()) or 0
    if curU < value then
      curU = value
      store[keyUnequip] = curU
      if sbUnequip.setValue then sbUnequip:setValue(curU) end
      setLabel(lbUnequip, "unequip: ", curU)
    end
  end

  sbUnequip.onValueChange = function(_, value)
    value = tonumber(value) or 0
    if value < 0 then value = 0 end
    if value > 100 then value = 100 end

    local curE = tonumber(store[keyEquip]) or (sbEquip.getValue and sbEquip:getValue()) or 0
    if value < curE then value = curE end

    store[keyUnequip] = value
    if sbUnequip.setValue then sbUnequip:setValue(value) end
    setLabel(lbUnequip, "unequip: ", value)
  end
end

local function bindBotSwitch(widget, store, key, defaultBool, text)
  if not widget then return end
  local on = store[key]
  if on == nil then on = (defaultBool == true) end
  store[key] = (on == true)
  if widget.setOn then widget:setOn(store[key]) end
  if text and widget.setText then widget:setText(text) end
  widget.onClick = function(w)
    local newState = not w:isOn()
    w:setOn(newState)
    store[key] = (newState == true)
  end
end

local function bindExclusivePair(swSwap, swFull, store, keySwap, keyFull, textSwap, textFull)
  keySwap = keySwap or "ativador"
  keyFull = keyFull or "ativadorFull"

  if textSwap and swSwap and swSwap.setText then swSwap:setText(textSwap) end
  if textFull and swFull and swFull.setText then swFull:setText(textFull) end

  store[keySwap] = (store[keySwap] == true)
  store[keyFull] = (store[keyFull] == true)

  if store[keySwap] and store[keyFull] then
    store[keyFull] = false
  end

  if swSwap and swSwap.setOn then swSwap:setOn(store[keySwap]) end
  if swFull and swFull.setOn then swFull:setOn(store[keyFull]) end

  if swSwap then
    swSwap.onClick = function(w)
      local newState = not w:isOn()
      w:setOn(newState)
      store[keySwap] = (newState == true)

      if newState == true then
        store[keyFull] = false
        if swFull and swFull.setOn then swFull:setOn(false) end
      end
    end
  end

  if swFull then
    swFull.onClick = function(w)
      local newState = not w:isOn()
      w:setOn(newState)
      store[keyFull] = (newState == true)

      if newState == true then
        store[keySwap] = false
        if swSwap and swSwap.setOn then swSwap:setOn(false) end
      end
    end
  end
end

local DEFAULT_BP = 2854
local ringDefaults = {
  [1] = { ringEquipavel = 3051, ringEquipavelID = 3088, backpack = DEFAULT_BP },
  [2] = { ringEquipavel = 3048, ringEquipavelID = 3048, backpack = DEFAULT_BP },
  [3] = { backpack = DEFAULT_BP }
}
local amuletDefaults = {
  [1] = { amuletEquipavel = 3081, amuletEquipavelID = 3081, backpack = DEFAULT_BP },
  [2] = { backpack = DEFAULT_BP },
  [3] = { backpack = DEFAULT_BP }
}

local function bindRingRow(rowWidget, idx)
  if not rowWidget then return end
  local rowStore = ensureEntry(storage[panelStoreName].ring, idx)
  local d = ringDefaults[idx] or {}

  bindBotItem(rowWidget.ringPadrao,      rowStore, "ringPadrao")
  bindBotItem(rowWidget.ringEquipavel,   rowStore, "ringEquipavel",   d.ringEquipavel)
  bindBotItem(rowWidget.ringEquipavelID, rowStore, "ringEquipavelID", d.ringEquipavelID)
  bindExclusivePair(rowWidget.ativador, rowWidget.ativadorFull, rowStore, "ativador", "ativadorFull", "SWAP RING " .. idx, "EQUIP FULL")

  bindBotItem(rowWidget.backpack,        rowStore, "backpack", d.backpack)
  bindBotSwitch(rowWidget.ativadorBP,    rowStore, "ativadorBP", false, "BP CONTROL")
  
  bindEquipUnequipPair(
    rowWidget.hpEquip, rowWidget.hpDesequip,
    rowWidget.hpEquipLabel, rowWidget.hpDesequipLabel,
    rowStore, "hpEquip", "hpDesequip"
  )
end

local function bindAmuletRow(rowWidget, idx)
  if not rowWidget then return end
  local rowStore = ensureEntry(storage[panelStoreName].amulet, idx)
  local d = amuletDefaults[idx] or {}

  bindBotItem(rowWidget.amuletPadrao,      rowStore, "amuletPadrao")
  bindBotItem(rowWidget.amuletEquipavel,   rowStore, "amuletEquipavel",   d.amuletEquipavel)
  bindBotItem(rowWidget.amuletEquipavelID, rowStore, "amuletEquipavelID", d.amuletEquipavelID)
  bindExclusivePair(rowWidget.ativador, rowWidget.ativadorFull, rowStore, "ativador", "ativadorFull", "SWAP AMULET " .. idx, "EQUIP FULL")

  bindBotItem(rowWidget.backpack,          rowStore, "backpack", d.backpack)
  bindBotSwitch(rowWidget.ativadorBP,      rowStore, "ativadorBP", false, "BP CONTROL")

  bindEquipUnequipPair(
    rowWidget.hpEquip, rowWidget.hpDesequip,
    rowWidget.hpEquipLabel, rowWidget.hpDesequipLabel,
    rowStore, "hpEquip", "hpDesequip"
  )
end

bindRingRow(panelSwap.abaRing.ring1, 1)
bindRingRow(panelSwap.abaRing.ring2, 2)
bindRingRow(panelSwap.abaRing.ring3, 3)

bindAmuletRow(panelSwap.abaAmulet.amulet1, 1)
bindAmuletRow(panelSwap.abaAmulet.amulet2, 2)
bindAmuletRow(panelSwap.abaAmulet.amulet3, 3)

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
      sched(1, function()
        if w and not w:isDestroyed() then apply(w) end
      end)

      local old = w.onItemChange
      w.onItemChange = function(widget, ...)
        sched(1, function()
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

autoItemOnState(panelSwap)

-- ==========================================================
-- SWAP + EQUIP FULL (RING/AMULET)
-- ==========================================================

local __swapOld = g_game.getClientVersion() < 900
local __SWAP_CD_MS = 500

local __CD_MIGHT_RING = 3048
local __CD_SSA_AMULET = 3081

local __SLOT_FINGER = SlotFinger or 9
local __SLOT_NECK   = SlotNeck or 2

local function __nowMillis()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function __itemId(it)
  if not it then return 0 end
  if it.getId then return tonumber(it:getId()) or 0 end
  return 0
end

local function __getFinger()
  if type(getFinger) == "function" then return getFinger() end
  return getSlot(__SLOT_FINGER)
end

local function __getNeck()
  if type(getNeck) == "function" then return getNeck() end
  return getSlot(__SLOT_NECK)
end

local function __isIdIn(id, a, b)
  id = tonumber(id) or 0
  a  = tonumber(a) or 0
  b  = tonumber(b) or 0
  if id <= 0 then return false end
  return (a > 0 and id == a) or (b > 0 and id == b)
end

local function __shouldUseCooldown(kind, item2, item3)
  item2 = tonumber(item2) or 0
  item3 = tonumber(item3) or 0
  if kind == "ring" then
    return (item2 == __CD_MIGHT_RING) or (item3 == __CD_MIGHT_RING)
  end
  if kind == "amulet" then
    return (item2 == __CD_SSA_AMULET) or (item3 == __CD_SSA_AMULET)
  end
  return false
end

local function __getContainersSafe()
  if type(getContainers) == "function" then
    return getContainers() or {}
  end
  if g_game and type(g_game.getContainers) == "function" then
    return g_game.getContainers() or {}
  end
  return {}
end

local function __findBPContainer(bpId)
  bpId = tonumber(bpId) or 0
  if bpId <= 0 then return nil end
  for _, container in pairs(__getContainersSafe()) do
    local cItem = container.getContainerItem and container:getContainerItem()
    if cItem and cItem.getId and tonumber(cItem:getId()) == bpId then
      return container
    end
  end
  return nil
end

local function __findItemById(id)
  id = tonumber(id) or 0
  if id <= 0 then return nil end

  if type(findItem) == "function" then
    local it = findItem(id)
    if it then return it end
  end

  for _, c in ipairs(__getContainersSafe()) do
    local items = c:getItems() or {}
    for i = 1, #items do
      local it = items[i]
      if it and it.getId and tonumber(it:getId()) == id then
        return it
      end
    end
  end
  return nil
end

local function __forceOpenContainerById(id)
  id = tonumber(id) or 0
  if id <= 0 then return false end

  local slots = { getBack and getBack() or nil, getAmmo and getAmmo() or nil, __getFinger(), __getNeck(), getLeft and getLeft() or nil, getRight and getRight() or nil }
  for i = 1, #slots do
    local it = slots[i]
    if it and it.getId and tonumber(it:getId()) == id then
      g_game.open(it, nil)
      return true
    end
  end

  local it = __findItemById(id)
  if it and it.isContainer and it:isContainer() then
    g_game.open(it, nil)
    return true
  end

  for _, c in pairs(__getContainersSafe()) do
    for _, cit in ipairs(c:getItems() or {}) do
      if cit and cit.isContainer and cit:isContainer() and cit.getId and tonumber(cit:getId()) == id then
        g_game.open(cit, nil)
        return true
      end
    end
  end

  return false
end

local __bpOpenRetryUntil = 0

local function __ensureBpIsOpen(bpId)
  bpId = tonumber(bpId) or 0
  if bpId <= 0 then return false end
  if __findBPContainer(bpId) then return true end

  local t = __nowMillis()
  if __bpOpenRetryUntil > t then return false end
  __bpOpenRetryUntil = t + 400

  return __forceOpenContainerById(bpId)
end

local function __getContainerCount(container)
  if not container then return 0 end
  if container.getItemsCount then return tonumber(container:getItemsCount()) or 0 end
  return #(container:getItems() or {})
end

local function __getContainerCapacity(container)
  if not container then return 0 end
  if container.getCapacity then return tonumber(container:getCapacity()) or 0 end
  return 0
end

local function __getFreeContainer(preferBpId)
  preferBpId = tonumber(preferBpId) or 0

  if preferBpId > 0 then
    local preferred = __findBPContainer(preferBpId)
    if preferred then
      local cap = __getContainerCapacity(preferred)
      local count = __getContainerCount(preferred)
      if cap <= 0 or count < cap then
        return preferred
      end
    end
  end

  for _, container in ipairs(__getContainersSafe()) do
    local cname = (container.getName and container:getName() or ""):lower()
    local cap = __getContainerCapacity(container)
    local count = __getContainerCount(container)
    if (cap <= 0 or count < cap) and
       not cname:find("dead") and
       not cname:find("slain") and
       not cname:find("depot") and
       not cname:find("quiver") then
      return container
    end
  end

  return nil
end

local __lastUnequipWarn = 0
local __pendingUnequip = {
  ring = { [1]=0, [2]=0, [3]=0 },
  amulet = { [1]=0, [2]=0, [3]=0 }
}

local function __queueUnequip(kind, idx)
  if not kind or not idx then return end
  __pendingUnequip[kind][idx] = __nowMillis() + 250
end

local function __clearUnequip(kind, idx)
  if not kind or not idx then return end
  __pendingUnequip[kind][idx] = 0
end

local function __isUnequipPending(kind, idx)
  if not kind or not idx then return false end
  return (__pendingUnequip[kind][idx] or 0) > __nowMillis()
end

local function unequipItem(slot, preferBpId, kind, idx)
  local item = getSlot(slot)
  if not item then
    __clearUnequip(kind, idx)
    return false
  end

  if not __swapOld then
    g_game.equipItemId(item:getId())
    __clearUnequip(kind, idx)
    return true
  end

  local dest = __getFreeContainer(preferBpId)
  if dest then
    local count = __getContainerCount(dest)
    local pos = dest:getSlotPosition(count)
    g_game.move(item, pos, item:getCount())
    __clearUnequip(kind, idx)
    return true
  end

  if preferBpId > 0 then
    __ensureBpIsOpen(preferBpId)
  end

  __queueUnequip(kind, idx)

  local t = __nowMillis()
  if t - (__lastUnequipWarn or 0) > 1500 then
    __lastUnequipWarn = t
  end

  return false
end

local function __equipIdToSlot(id, slot)
  id = tonumber(id) or 0
  if id <= 0 then return false end

  if not __swapOld then
    g_game.equipItemId(id)
    return true
  end

  local it = __findItemById(id)
  if not it then return false end
  g_game.move(it, {x=65535, y=slot, z=0}, 1)
  return true
end

local function __equipSpecialToSlot(id1, id2, slot)
  id1 = tonumber(id1) or 0
  id2 = tonumber(id2) or 0

  if not __swapOld then
    local pick = (id1 > 0) and id1 or id2
    if pick <= 0 then return false end
    g_game.equipItemId(pick)
    return true
  end

  local it = __findItemById(id1) or __findItemById(id2)
  if not it then return false end
  g_game.move(it, {x=65535, y=slot, z=0}, 1)
  return true
end

local function __getActiveIndexByKey(kindTable, keyName)
  for i = 1, 3 do
    local row = kindTable and kindTable[i]
    if row and row[keyName] == true then
      return i, row
    end
  end
  return nil, nil
end

local __ringCdUntil   = { [1]=0, [2]=0, [3]=0 }
local __amuletCdUntil = { [1]=0, [2]=0, [3]=0 }

local function __processRingSwap(idx, row)
  local hp = hppercent()
  local t  = __nowMillis()

  local finger = __getFinger()
  local fid = __itemId(finger)

  local ring1  = tonumber(row.ringPadrao) or 0
  local item2  = tonumber(row.ringEquipavel) or 0
  local item3  = tonumber(row.ringEquipavelID) or 0
  local bpId   = tonumber(row.backpack) or 0

  local equipPct   = tonumber(row.hpEquip) or 0
  local unequipPct = tonumber(row.hpDesequip) or equipPct

  local hasNormal = ring1 > 0
  local useCd = __shouldUseCooldown("ring", item2, item3)
  local cdUntil = (useCd and (__ringCdUntil[idx] or 0)) or 0
  local cdActive = (useCd and (cdUntil > t)) or false

  if hp < equipPct then
    __clearUnequip("ring", idx)
    if __isIdIn(fid, item2, item3) then return false end

    if __equipSpecialToSlot(item2, item3, __SLOT_FINGER) then
      if useCd then
        __ringCdUntil[idx] = t + __SWAP_CD_MS
      end
      delay(120)
      return true
    end
    return false
  end

  if useCd and cdActive then
    if hp > unequipPct and fid ~= 0 then
      if unequipItem(__SLOT_FINGER, bpId, "ring", idx) then
        delay(120)
        return true
      end
    end
    return false
  end

  if hp > unequipPct then
    if hasNormal then
      __clearUnequip("ring", idx)
      if fid ~= ring1 then
        if __equipIdToSlot(ring1, __SLOT_FINGER) then
          delay(120)
          return true
        end
      end
      return false
    end

    if fid ~= 0 then
      if unequipItem(__SLOT_FINGER, bpId, "ring", idx) then
        delay(120)
        return true
      end
    else
      __clearUnequip("ring", idx)
    end
  else
    __clearUnequip("ring", idx)
  end

  return false
end

local function __processAmuletSwap(idx, row)
  local hp = hppercent()
  local t  = __nowMillis()

  local neck = __getNeck()
  local nid = __itemId(neck)

  local amu1  = tonumber(row.amuletPadrao) or 0
  local item2 = tonumber(row.amuletEquipavel) or 0
  local item3 = tonumber(row.amuletEquipavelID) or 0
  local bpId  = tonumber(row.backpack) or 0

  local equipPct   = tonumber(row.hpEquip) or 0
  local unequipPct = tonumber(row.hpDesequip) or equipPct

  local hasNormal = amu1 > 0
  local useCd = __shouldUseCooldown("amulet", item2, item3)
  local cdUntil = (useCd and (__amuletCdUntil[idx] or 0)) or 0
  local cdActive = (useCd and (cdUntil > t)) or false

  if hp < equipPct then
    __clearUnequip("amulet", idx)
    if __isIdIn(nid, item2, item3) then return false end

    if __equipSpecialToSlot(item2, item3, __SLOT_NECK) then
      if useCd then
        __amuletCdUntil[idx] = t + __SWAP_CD_MS
      end
      delay(120)
      return true
    end
    return false
  end

  if useCd and cdActive then
    if hp > unequipPct and nid ~= 0 then
      if unequipItem(__SLOT_NECK, bpId, "amulet", idx) then
        delay(120)
        return true
      end
    end
    return false
  end

  if hp > unequipPct then
    if hasNormal then
      __clearUnequip("amulet", idx)
      if nid ~= amu1 then
        if __equipIdToSlot(amu1, __SLOT_NECK) then
          delay(120)
          return true
        end
      end
      return false
    end

    if nid ~= 0 then
      if unequipItem(__SLOT_NECK, bpId, "amulet", idx) then
        delay(120)
        return true
      end
    else
      __clearUnequip("amulet", idx)
    end
  else
    __clearUnequip("amulet", idx)
  end

  return false
end

local __ringFullRetryUntil   = { [1]=0, [2]=0, [3]=0 }
local __amuletFullRetryUntil = { [1]=0, [2]=0, [3]=0 }
local __FULL_RETRY_MS = 600

local function __processRingFull(idx, row)
  local t = __nowMillis()
  if (__ringFullRetryUntil[idx] or 0) > t then return false end

  local finger = __getFinger()
  local fid = __itemId(finger)

  local item2 = tonumber(row.ringEquipavel) or 0
  local item3 = tonumber(row.ringEquipavelID) or 0
  if item2 <= 0 and item3 <= 0 then return false end

  local targetEquipped = (item3 > 0) and item3 or item2
  if fid == targetEquipped then return false end

  if __equipSpecialToSlot(item2, item3, __SLOT_FINGER) then
    delay(120)
    return true
  end

  __ringFullRetryUntil[idx] = t + __FULL_RETRY_MS
  return false
end

local function __processAmuletFull(idx, row)
  local t = __nowMillis()
  if (__amuletFullRetryUntil[idx] or 0) > t then return false end

  local neck = __getNeck()
  local nid = __itemId(neck)

  local item2 = tonumber(row.amuletEquipavel) or 0
  local item3 = tonumber(row.amuletEquipavelID) or 0
  if item2 <= 0 and item3 <= 0 then return false end

  local targetEquipped = (item3 > 0) and item3 or item2
  if nid == targetEquipped then return false end

  if __equipSpecialToSlot(item2, item3, __SLOT_NECK) then
    delay(120)
    return true
  end

  __amuletFullRetryUntil[idx] = t + __FULL_RETRY_MS
  return false
end

macro(50, function()
  if not storage["swapButton"] or storage["swapButton"].enabled ~= true then return end
  local st = storage["panelSwapStorage"]
  if not st or not st.ring then return end
  local fIdx = __getActiveIndexByKey(st.ring, "ativadorFull")
  if fIdx then return end
  local idx, row = __getActiveIndexByKey(st.ring, "ativador")
  if not idx or not row then return end
  __processRingSwap(idx, row)
end)

macro(50, function()
  if not storage["swapButton"] or storage["swapButton"].enabled ~= true then return end
  local st = storage["panelSwapStorage"]
  if not st or not st.amulet then return end
  local fIdx = __getActiveIndexByKey(st.amulet, "ativadorFull")
  if fIdx then return end
  local idx, row = __getActiveIndexByKey(st.amulet, "ativador")
  if not idx or not row then return end
  __processAmuletSwap(idx, row)
end)

macro(50, function()
  if not storage["swapButton"] or storage["swapButton"].enabled ~= true then return end
  local st = storage["panelSwapStorage"]
  if not st or not st.ring then return end
  local idx, row = __getActiveIndexByKey(st.ring, "ativadorFull")
  if not idx or not row then return end
  __processRingFull(idx, row)
end)

macro(50, function()
  if not storage["swapButton"] or storage["swapButton"].enabled ~= true then return end
  local st = storage["panelSwapStorage"]
  if not st or not st.amulet then return end
  local idx, row = __getActiveIndexByKey(st.amulet, "ativadorFull")
  if not idx or not row then return end
  __processAmuletFull(idx, row)
end)

-- ==========================================================
-- LNS | BP INTELIGENTE
-- ==========================================================

local function __sched(ms, fn)
  if type(scheduleEvent) == "function" then return scheduleEvent(fn, ms) end
  if g_dispatcher and type(g_dispatcher.scheduleEvent) == "function" then
    return g_dispatcher:scheduleEvent(fn, ms)
  end
  if type(schedule) == "function" then return schedule(ms, fn) end
  return fn()
end

local function __ms()
  if g_clock and type(g_clock.millis) == "function" then return g_clock.millis() end
  if now then return now end
  return 0
end

local function __playerPos()
  if pos then return pos() end
  if player and player.getPosition then return player:getPosition() end
  return nil
end

local function __keepSlotFree(container)
  if not container then return end

  local cap = __getContainerCapacity(container)
  local count = __getContainerCount(container)
  if cap > 0 and count < cap then return end

  local p = __playerPos()
  if not p then return end

  local items = container:getItems() or {}
  for i = #items, 1, -1 do
    local it = items[i]
    if it then
      local isCont = (it.isContainer and it:isContainer()) or false
      if not isCont then
        g_game.move(it, p, 1)
        return
      end
    end
  end

  if items[1] then
    g_game.move(items[1], p, 1)
  end
end

local function __containerHasId(container, idA, idB)
  if not container then return false end
  idA = tonumber(idA) or 0
  idB = tonumber(idB) or 0
  if idA <= 0 and idB <= 0 then return false end

  for _, it in ipairs(container:getItems() or {}) do
    if it and it.getId then
      local iid = tonumber(it:getId()) or 0
      if (idA > 0 and iid == idA) or (idB > 0 and iid == idB) then
        return true
      end
    end
  end
  return false
end

local function __openNextBPInside(container)
  if not container then return 0 end
  for _, it in ipairs(container:getItems() or {}) do
    if it and it.isContainer and it:isContainer() and it.getId then
      local nextId = tonumber(it:getId()) or 0
      if nextId > 0 then
        g_game.open(it, container)
        delay(200)
        return nextId
      end
    end
  end
  return 0
end

local function __getActiveRowByMode(tbl)
  for i = 1, 3 do
    local r = tbl and tbl[i]
    if r and r.ativadorFull == true then return i, r end
  end
  for i = 1, 3 do
    local r = tbl and tbl[i]
    if r and r.ativador == true then return i, r end
  end
  return nil, nil
end

local __bpActive = {
  ring   = { [1]=0, [2]=0, [3]=0 },
  amulet = { [1]=0, [2]=0, [3]=0 },
}

local __bpTickUntil = {
  ring   = { [1]=0, [2]=0, [3]=0 },
  amulet = { [1]=0, [2]=0, [3]=0 },
}

local function __bpInteligenteTick(kind, idx, row, item2, item3)
  if row.ativadorBP ~= true then return end

  local baseBpId = tonumber(row.backpack) or 0
  if baseBpId <= 0 then return end

  local t = __ms()
  if (__bpTickUntil[kind][idx] or 0) > t then return end
  __bpTickUntil[kind][idx] = t + 250

  if (__bpActive[kind][idx] or 0) <= 0 then
    __bpActive[kind][idx] = baseBpId
  end

  local activeId = __bpActive[kind][idx]

  __ensureBpIsOpen(activeId)

  local cont = __findBPContainer(activeId)

  if not cont and activeId ~= baseBpId then
    __bpActive[kind][idx] = baseBpId
    activeId = baseBpId
    __ensureBpIsOpen(activeId)
    cont = __findBPContainer(activeId)
  end

  if not cont then return end

  __keepSlotFree(cont)

  if not __containerHasId(cont, item2, item3) then
    local nextId = __openNextBPInside(cont)

    if nextId > 0 then
      __bpActive[kind][idx] = nextId
      __sched(250, function()
        __ensureBpIsOpen(nextId)
      end)
      return
    end

    g_game.close(cont)
    __bpTickUntil[kind][idx] = __ms() + 30000
    return
  end
end

macro(200, function()
  if not storage["swapButton"] or storage["swapButton"].enabled ~= true then return end
  local st = storage["panelSwapStorage"]
  if not st or not st.ring then return end

  local idx, row = __getActiveRowByMode(st.ring)
  if not idx or not row then return end

  local item2 = tonumber(row.ringEquipavel) or 0
  local item3 = tonumber(row.ringEquipavelID) or 0

  __bpInteligenteTick("ring", idx, row, item2, item3)
end)

macro(200, function()
  if not storage["swapButton"] or storage["swapButton"].enabled ~= true then return end
  local st = storage["panelSwapStorage"]
  if not st or not st.amulet then return end

  local idx, row = __getActiveRowByMode(st.amulet)
  if not idx or not row then return end

  local item2 = tonumber(row.amuletEquipavel) or 0
  local item3 = tonumber(row.amuletEquipavelID) or 0

  __bpInteligenteTick("amulet", idx, row, item2, item3)
end)