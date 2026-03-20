setDefaultTab("Tools")

local panelName = "autoParty"

autopartyui = setupUI([[
Panel
  height: 18

  BotSwitch
    id: status
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: AUTO PARTY
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
    id: editPlayerList
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
]], parent)

g_ui.loadUIFromString([[
AutoPartyName < Label
  font: verdana-9px
  height: 16
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #696969
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  Button
    id: remove
    anchors.right: parent.right
    width: 16
    height: 16
    margin-right: 15
    text: X
    color: #FF4040
    image-color: gray
    image-source: /images/ui/button_rounded

AutoPartyListWindow < UIWindow
  text: Auto Party
  size: 450 310
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
    !text: tr('LNS Custom | Auto Party')
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

  VerticalSeparator
    id: vertSep
    anchors.top: prev.bottom
    anchors.right: closePanel.left
    anchors.bottom: parent.bottom
    margin-right: 190
    margin-top: 8
    margin-bottom: 2

  Label
    id: labeltxtLeader
    anchors.top: prev.top
    anchors.left: parent.left
    anchors.right: prev.left
    text: Party [Invite List]
    color: orange
    margin-left: 10
    font: verdana-9px

  TextEdit
    id: txtLeader
    anchors.left: parent.left
    anchors.right: vertSep.left
    anchors.top: prev.top
    margin-top: 15
    margin-left: 10
    margin-right: 8
    placeholder: LEADER NAME
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #363636

  CheckBox
    id: soulider
    anchors.top: prev.bottom
    anchors.left: prev.left
    text: Sou Leader
    margin-top: 5
    font: verdana-9px
    text-auto-resize: true
    image-source: /images/ui/checkbox_round

  HorizontalSeparator
    id: hsep
    anchors.left: parent.left
    anchors.right: vertSep.left
    anchors.top: prev.bottom
    margin-top: 5
    margin-left: 8
    margin-right: 8
    image-color: #363636

  TextList
    id: lstAutoParty
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: vertSep.left
    margin-top: 5
    margin-bottom: 5
    margin-left: 8
    margin-right: 8
    padding: 1
    height: 150
    vertical-scrollbar: AutoPartyListListScrollBar
    image-color: #363636

  VerticalScrollBar
    id: AutoPartyListListScrollBar
    anchors.top: lstAutoParty.top
    anchors.bottom: lstAutoParty.bottom
    anchors.right: lstAutoParty.right
    step: 14
    pixels-scroll: true
    image-color: #363636

  TextEdit
    id: playerName
    anchors.left: parent.left
    anchors.top: lstAutoParty.bottom
    margin-top: 5
    margin-left: 8
    width: 180
    placeholder: PLAYER NAME
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #363636

  Button
    id: addPlayer
    text: +
    anchors.right: vertSep.left
    anchors.left: prev.right
    anchors.top: prev.top
    margin-left: 5
    margin-right: 8
    font: sans-bold-16px
    image-source: /images/ui/button_rounded
    image-color: #363636

  CheckBox
    id: creatureMove
    anchors.left: parent.left
    anchors.right: vertSep.left
    anchors.top: prev.bottom
    margin-top: 6
    margin-left: 8
    margin-right: 8
    text: Automatic Invite
    font: verdana-9px
    text-auto-resize: true
    image-source: /images/ui/checkbox_round

  CheckBox
    id: autoShare
    anchors.left: prev.left
    anchors.top: prev.bottom
    margin-top: 6
    text: Auto Sharear
    font: verdana-9px
    text-auto-resize: true
    image-source: /images/ui/checkbox_round

  Label
    id: labeltxtLeader
    anchors.top: vertSep.top
    anchors.left: vertSep.right
    text: Party [Say "PT"]
    color: orange
    margin-left: 10
    font: verdana-9px

  TextEdit
    id: palavraInvite
    anchors.left: prev.left
    anchors.top: prev.bottom
    margin-top: 2
    width: 195
    placeholder: PALAVRA-CHAVE
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #363636

  CheckBox
    id: soulider2
    anchors.top: prev.bottom
    anchors.left: prev.left
    text: Sou Leader
    margin-top: 5
    font: verdana-9px
    text-auto-resize: true
    image-source: /images/ui/checkbox_round

  Label
    id: minLevel
    anchors.top: prev.bottom
    anchors.left: prev.left
    text: Level Minimo:
    margin-top: 10
    color: orange
    font: verdana-9px

  TextEdit
    id: textMinLevel
    anchors.left: prev.left
    anchors.top: prev.bottom
    margin-top: 2
    width: 195
    placeholder: LEVEL MINIMO
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #363636

  Label
    id: maxLevel
    anchors.top: prev.bottom
    anchors.left: prev.left
    text: Level Maximo:
    margin-top: 5
    color: orange
    font: verdana-9px

  TextEdit
    id: textMaxLevel
    anchors.left: prev.left
    anchors.top: prev.bottom
    margin-top: 2
    width: 195
    placeholder: LEVEL MAXIMO
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #363636

  Button
    id: banList
    anchors.top: prev.bottom
    anchors.left: prev.left
    anchors.right: prev.right
    image-source: /images/ui/button_rounded
    image-color: #363636
    text: PLAYERS BANIDOS
    font: verdana-9px
    height: 20
    margin-top: 3

  HorizontalSeparator
    id: hsep
    anchors.left: prev.left
    anchors.right: prev.right
    anchors.top: prev.bottom
    margin-top: 5
    image-color: #363636

  TextEdit
    id: palavraPedirPT
    anchors.left: prev.left
    anchors.top: prev.bottom
    margin-top: 6
    width: 195
    placeholder: FRASE PEDIR PARTY
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #363636

  CheckBox
    id: pedirParty
    anchors.left: prev.left
    anchors.top: prev.bottom
    margin-top: 6
    text: Pedir Party
    font: verdana-9px
    text-auto-resize: true
    image-source: /images/ui/checkbox_round

  CheckBox
    id: aceitarParty
    anchors.left: prev.left
    anchors.top: prev.bottom
    margin-top: 6
    text: Aceitar Party
    font: verdana-9px
    text-auto-resize: true
    image-source: /images/ui/checkbox_round

]])

-- =========================
-- STORAGE (base)
-- =========================
if not storage[panelName] then
  storage[panelName] = {
    leaderName = "Leader",
    autoPartyList = {},
    enabled = false,
    onMove = false,
    soulider = false,
    autoShare = false,

    -- lado direito (abaixo do labeltxtLeader "Party [Say PT]")
    palavraInvite = "",
    soulider2 = false,
    minLevel = "",
    maxLevel = "",
    palavraPedirPT = "",
    pedirParty = false,
    aceitarParty = false,
    banListPlayers = {}
  }
end

-- garantir campos (compat)
if storage[panelName].onMove == nil then storage[panelName].onMove = false end
if storage[panelName].soulider == nil then storage[panelName].soulider = false end
if storage[panelName].autoShare == nil then storage[panelName].autoShare = false end
if storage[panelName].leaderName == nil then storage[panelName].leaderName = "" end
if not storage[panelName].autoPartyList then storage[panelName].autoPartyList = {} end
if storage[panelName].enabled == nil then storage[panelName].enabled = true end

-- novos (lado direito)
if storage[panelName].palavraInvite == nil then storage[panelName].palavraInvite = "" end
if storage[panelName].soulider2 == nil then storage[panelName].soulider2 = false end
if storage[panelName].minLevel == nil then storage[panelName].minLevel = "" end
if storage[panelName].maxLevel == nil then storage[panelName].maxLevel = "" end
if storage[panelName].palavraPedirPT == nil then storage[panelName].palavraPedirPT = "" end
if storage[panelName].pedirParty == nil then storage[panelName].pedirParty = false end
if storage[panelName].aceitarParty == nil then storage[panelName].aceitarParty = false end
if not storage[panelName].banListPlayers then storage[panelName].banListPlayers = {} end

function buttonsPartyPcMobile()
  if modules._G.g_app.isMobile() then
    autopartyui.editPlayerList:show()
    autopartyui.status:setMarginRight(55)
  else
    autopartyui.editPlayerList:hide()
    autopartyui.status:setMarginRight(0)
  end
end
buttonsPartyPcMobile()

local rootWidget = g_ui.getRootWidget()
if rootWidget then
  tcAutoParty = autopartyui.status

  autoPartyListWindow = UI.createWindow("AutoPartyListWindow", rootWidget)
  autoPartyListWindow:hide()

  autopartyui.status.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not autoPartyListWindow:isVisible() then
      autoPartyListWindow:show()
      autoPartyListWindow:raise();
      autoPartyListWindow:focus();
    else
      autoPartyListWindow:hide()
    end
  end
end

  autopartyui.editPlayerList.onClick = function()
    autoPartyListWindow:show()
    autoPartyListWindow:raise()
    autoPartyListWindow:focus()
  end

  autoPartyListWindow.closePanel.onClick = function()
    autoPartyListWindow:hide()
  end

  -- =========================
  -- LISTA (carregar/salvar)
  -- =========================
  if storage[panelName].autoPartyList and #storage[panelName].autoPartyList > 0 then
    for _, pName in ipairs(storage[panelName].autoPartyList) do
      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function()
        table.removevalue(storage[panelName].autoPartyList, label:getText())
        label:destroy()
      end
      label:setText(pName)
    end
  end

  autoPartyListWindow.addPlayer.onClick = function()
    local pName = autoPartyListWindow.playerName:getText()
    if pName:len() > 0 and not (table.contains(storage[panelName].autoPartyList, pName, true) or storage[panelName].leaderName == pName) then
      table.insert(storage[panelName].autoPartyList, pName)

      local label = g_ui.createWidget("AutoPartyName", autoPartyListWindow.lstAutoParty)
      label.remove.onClick = function()
        table.removevalue(storage[panelName].autoPartyList, label:getText())
        label:destroy()
      end
      label:setText(pName)
      autoPartyListWindow.playerName:setText("")
    end
  end

  autoPartyListWindow.playerName.onKeyPress = function(_, keyCode)
    if keyCode ~= 5 then return false end
    autoPartyListWindow.addPlayer.onClick()
    return true
  end

  autoPartyListWindow.playerName.onTextChange = function(_, text)
    if table.contains(storage[panelName].autoPartyList, text, true) then
      autoPartyListWindow.addPlayer:setColor("#FF0000")
    else
      autoPartyListWindow.addPlayer:setColor("#FFFFFF")
    end
  end

  -- =========================
  -- ENABLE
  -- =========================
  tcAutoParty:setOn(storage[panelName].enabled == true)
  tcAutoParty.onClick = function(widget)
    storage[panelName].enabled = not (storage[panelName].enabled == true)
    widget:setOn(storage[panelName].enabled)
  end

  -- =========================
  -- AUTOMATIC INVITE (onMove)
  -- =========================
  autoPartyListWindow.creatureMove:setChecked(storage[panelName].onMove == true)
  autoPartyListWindow.creatureMove.onClick = function(widget)
    storage[panelName].onMove = not (storage[panelName].onMove == true)
    widget:setChecked(storage[panelName].onMove)
  end

  -- =========================
  -- TXT LEADER
  -- =========================
  autoPartyListWindow.txtLeader.onTextChange = function(_, text)
    storage[panelName].leaderName = text
  end
  autoPartyListWindow.txtLeader:setText(storage[panelName].leaderName or "")

  -- =========================
  -- SOU LIDER: auto preenche / limpa
  -- =========================
  autoPartyListWindow.soulider:setChecked(storage[panelName].soulider == true)

  local function applySouLider()
    if storage[panelName].soulider then
      local myName = player:getName()
      storage[panelName].leaderName = myName
      autoPartyListWindow.txtLeader:setText(myName)
    else
      storage[panelName].leaderName = ""
      autoPartyListWindow.txtLeader:setText("")
    end
  end

  autoPartyListWindow.soulider.onClick = function(widget)
    storage[panelName].soulider = not (storage[panelName].soulider == true)
    widget:setChecked(storage[panelName].soulider)
    applySouLider()
  end

  applySouLider()

  -- =========================
  -- AUTO SHAREAR: faz PTSHARE ao ligar
  -- =========================
  autoPartyListWindow.autoShare:setChecked(storage[panelName].autoShare == true)
  autoPartyListWindow.autoShare.onClick = function(widget)
    storage[panelName].autoShare = not (storage[panelName].autoShare == true)
    widget:setChecked(storage[panelName].autoShare)
  end

macro(2000, function()
  if not tcAutoParty:isOn() then return end
  if storage[panelName].autoShare then
    if player:isPartyLeader() then
      if not player:isPartySharedExperienceActive() then
        g_game.partyShareExperience(true)
      end
    end
  end
end)

  -- ============================================================
  -- ✅ STORAGE DE TUDO ABAIXO DO LABEL (lado direito - "Say PT")
  -- ============================================================

  -- PALAVRA-CHAVE
  autoPartyListWindow.palavraInvite:setText(storage[panelName].palavraInvite or "")
  autoPartyListWindow.palavraInvite.onTextChange = function(_, text)
    storage[panelName].palavraInvite = text or ""
  end

  -- SOU LIDER 2 (opcional: replica comportamento do de cima, só que pra palavraInvite)
  autoPartyListWindow.soulider2:setChecked(storage[panelName].soulider2 == true)

  autoPartyListWindow.soulider2.onClick = function(widget)
    storage[panelName].soulider2 = not (storage[panelName].soulider2 == true)
    widget:setChecked(storage[panelName].soulider2)
  end

  -- LEVEL MIN / MAX
  autoPartyListWindow.textMinLevel:setText(tostring(storage[panelName].minLevel or ""))
  autoPartyListWindow.textMinLevel.onTextChange = function(_, text)
    storage[panelName].minLevel = text or ""
  end

  autoPartyListWindow.textMaxLevel:setText(tostring(storage[panelName].maxLevel or ""))
  autoPartyListWindow.textMaxLevel.onTextChange = function(_, text)
    storage[panelName].maxLevel = text or ""
  end

  -- FRASE PEDIR PARTY
  autoPartyListWindow.palavraPedirPT:setText(storage[panelName].palavraPedirPT or "")
  autoPartyListWindow.palavraPedirPT.onTextChange = function(_, text)
    storage[panelName].palavraPedirPT = text or ""
  end

  -- CHECK PEDIR PARTY
  autoPartyListWindow.pedirParty:setChecked(storage[panelName].pedirParty == true)
  autoPartyListWindow.pedirParty.onClick = function(widget)
    storage[panelName].pedirParty = not (storage[panelName].pedirParty == true)
    widget:setChecked(storage[panelName].pedirParty)
  end

  -- CHECK ACEITAR PARTY
  autoPartyListWindow.aceitarParty:setChecked(storage[panelName].aceitarParty == true)
  autoPartyListWindow.aceitarParty.onClick = function(widget)
    storage[panelName].aceitarParty = not (storage[panelName].aceitarParty == true)
    widget:setChecked(storage[panelName].aceitarParty)
  end

  -- =========================
  -- BAN LIST (window + storage)
  -- =========================
  g_ui.loadUIFromString([[
AutoPartyBanName < Label
  font: verdana-9px
  height: 16
  focusable: true
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #696969
    opacity: 0.75

  $focus:
    background-color: #404040
    opacity: 0.90

  Button
    id: remove
    anchors.right: parent.right
    width: 16
    height: 16
    margin-right: 15
    text: X
    color: #FF4040
    image-color: gray
    image-source: /images/ui/button_rounded

AutoPartyBanWindow < UIWindow
  size: 280 260
  border: 1 black
  anchors.centerIn: parent

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
    !text: tr('LNS Custom | Party Bans')
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

  TextList
    id: lstBan
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    margin-top: 15
    margin-left: 10
    margin-right: 10
    height: 180
    padding: 1
    image-color: #363636

  TextEdit
    id: txtBan
    anchors.left: parent.left
    anchors.top: lstBan.bottom
    margin-top: 8
    margin-left: 10
    width: 180
    placeholder: PLAYER NAME
    placeholder-font: verdana-9px
    font: verdana-9px
    image-color: #363636

  Button
    id: btnAdd
    text: +
    anchors.left: prev.right
    anchors.right: parent.right
    anchors.top: prev.top
    margin-left: 5
    margin-right: 10
    font: sans-bold-16px
    image-source: /images/ui/button_rounded
    image-color: #363636
]])

  local banWindow = UI.createWindow("AutoPartyBanWindow", rootWidget)
  banWindow:hide()

  local function reloadBanList()
    banWindow.lstBan:destroyChildren()
    for _, name in ipairs(storage[panelName].banListPlayers or {}) do
      local row = g_ui.createWidget("AutoPartyBanName", banWindow.lstBan)
      row:setText(name)
      row.remove.onClick = function()
        table.removevalue(storage[panelName].banListPlayers, row:getText())
        row:destroy()
      end
    end
  end

  reloadBanList()

  banWindow.btnAdd.onClick = function()
    local name = banWindow.txtBan:getText()
    if not name or name:len() == 0 then return end

    if not table.contains(storage[panelName].banListPlayers, name, true) then
      table.insert(storage[panelName].banListPlayers, name)
      reloadBanList()
    end

    banWindow.txtBan:setText("")
  end

  banWindow.txtBan.onKeyPress = function(_, keyCode)
    if keyCode ~= 5 then return false end
    banWindow.btnAdd.onClick()
    return true
  end

  banWindow.closePanel.onClick = function()
    banWindow:hide()
  end

  autoPartyListWindow.banList.onClick = function()
    reloadBanList()
    banWindow:show()
    banWindow:raise()
    banWindow:focus()
  end

  -- =========================
  -- MENSAGENS (join/invite)
  -- =========================
  onTextMessage(function(mode, text)
    if not tcAutoParty:isOn() then return end
    if mode ~= 20 then return end

    if text:find("has joined the party") then
      local data = regexMatch(text, "([a-z A-Z-]*) has joined the party")[1][2]
      if data and table.contains(storage[panelName].autoPartyList, data, true) then
        if storage[panelName].autoShare and not player:isPartySharedExperienceActive() then
          g_game.partyShareExperience(true)
        end
      end
      return
    end

    if text:find("has invited you") then
      if player:getName():lower() == (storage[panelName].leaderName or ""):lower() then
        return
      end

      local data = regexMatch(text, "([a-z A-Z-]*) has invited you")[1][2]
      if data and (storage[panelName].leaderName or ""):lower() == data:lower() then
        local leader = getCreatureByName(data, true)
        if leader then
          g_game.partyJoin(leader:getId())
          return
        end
      end
    end
  end)

  -- =========================
  -- INVITES
  -- =========================
  local function creatureInvites(creature)
    if not creature:isPlayer() or creature == player then return end

    -- Se eu não sou o leader, eu só aceito convite do leader
    if creature:getName():lower() == (storage[panelName].leaderName or ""):lower() then
      if creature:getShield() == 1 then
        g_game.partyJoin(creature:getId())
        return
      end
    end

    -- Só o leader convida
    if player:getName():lower() ~= (storage[panelName].leaderName or ""):lower() then return end
    if not table.contains(storage[panelName].autoPartyList, creature:getName(), true) then return end
    if creature:isPartyMember() or creature:getShield() == 2 then return end

    g_game.partyInvite(creature:getId())
  end

  onCreatureAppear(function(creature)
    if tcAutoParty:isOn() then
      creatureInvites(creature)
    end
  end)

  onCreaturePositionChange(function(creature)
    if tcAutoParty:isOn() and storage[panelName].onMove then
      creatureInvites(creature)
    end
  end)
end

-- =====================================================
-- == LÓGICA COMPLETA AUTO PARTY (INTEGRADA AO PAINEL) ==
-- =====================================================
-- Macro Principal: Gerencia o status da Party e pede Info
-- Variáveis de controle interno (estado da sessão)
local infoTime = 0
local talkTime = 0
local justForInfo = true
local canSeeInfo = true
local partyMembersCount = 0

local lastInfoAt = 0
local lastUnlockAt = 0

local lastCloseAt = 0

macro(1000, function()
  if not storage[panelName].enabled then return end

  -- usa segundos (os.time) porque sua macro inteira já trabalha assim
  local now = os.time()

  -- =========================
  -- FECHAR PAINEIS (APENAS QUANDO TIMER ATIVO)
  -- =========================
  if fecharPaineis and fecharPaineis > 0 and now <= fecharPaineis then
    if lastCloseAt == 0 or (now - lastCloseAt) >= 3 then
      local root = g_ui.getRootWidget()
      if root then
        for _, widget in ipairs(root:recursiveGetChildren()) do
          if widget:getStyleName() == 'MessageBoxLabel' then
            local parent = widget:getParent()
            if parent and parent.destroy then
              parent:destroy()
            end
            lastCloseAt = now
            break
          end
        end
      end
    end
  end

  -- =========================
  -- SUA LOGICA ORIGINAL (IGUAL)
  -- =========================
  if not storage[panelName].soulider2 then
    justForInfo = true
    partyMembersCount = 0
    infoTime = 0
    lastInfoAt = 0
    canSeeInfo = true
    return
  end

  if not player:isPartyLeader() then
    justForInfo = true
    partyMembersCount = 0
    infoTime = 0
    lastInfoAt = 0
    canSeeInfo = true
    return
  end

  if not canSeeInfo then
    if lastUnlockAt == 0 then lastUnlockAt = now end
    if (now - lastUnlockAt) >= 3 then
      canSeeInfo = true
      lastUnlockAt = 0
    end
  end

  if justForInfo and canSeeInfo then
    local partyId = getChannelId("party")
    if partyId then
      sayChannel(partyId, "!party info")
    else
      say("!party info")
    end

    -- ativa janela de 5s pra fechar paineis após pedir info
    fecharPaineis = now + 5

    lastInfoAt = now
    return
  end

  if canSeeInfo and (lastInfoAt == 0 or (now - lastInfoAt) >= 15) then
    local partyId = getChannelId("party")
    if partyId then
      sayChannel(partyId, "!party info")
    else
      say("!party info")
    end

    -- ativa janela de 5s pra fechar paineis após pedir info
    fecharPaineis = now + 5

    lastInfoAt = now
    return
  end

  if talkTime > 0 then
    talkTime = talkTime - 1
  end
end)


-- Evento: Recebe o retorno do "!party info" (Parsing de Níveis e Kick)
onLoginAdvice(function(text)
    if not storage[panelName].enabled or not storage[panelName].soulider2 then return end
    if not player:isPartyLeader() then return end

    -- O comando !party info costuma retornar uma string separada por "*" ou similar
    -- Vamos tentar extrair os dados conforme o script original
    local explode1 = string.explode(text, "*")
    local explode2 = string.explode(explode1[8], ":")[2]

    -- Atualiza Níveis no Painel automaticamente (Cálculo sugerido pelo seu script original)
    local rawMax = tonumber(string.explode(explode1[4], ":")[2]) or 0
    local rawMin = tonumber(string.explode(explode1[3], ":")[2]) or 0
    
    local calcMax = math.ceil(rawMax * 1.5)
    local calcMin = math.ceil(rawMin * 0.66)

    -- Atualiza os inputs do seu painel e o storage
    storage[panelName].maxLevel = tostring(calcMax)
    storage[panelName].minLevel = tostring(calcMin)
    autoPartyListWindow.textMaxLevel:setText(storage[panelName].maxLevel)
    autoPartyListWindow.textMinLevel:setText(storage[panelName].minLevel)

    -- Lógica de Auto-Kick (Inativos)
    partyMembersCount = tonumber(string.explode(explode1[2], ":")[2])
    if justForInfo then
      justForInfo = false
      return
    end
    if explode2:find(",") then
      local names = string.explode(explode2, ",")
      for i = 1, #names do
        canSeeInfo = false
        schedule(10 * i, function() -- tempo pra chutar quem ta cortando o share de exp
          if i == #names then
            canSeeInfo = true
          end
          sayChannel(getChannelId("party"), "!party kick," .. names[i])
        end)
      end
    elseif explode2 ~= "" then
      schedule(10, function() sayChannel(getChannelId("party"), "!party kick," .. explode2) end)
    end
end)

-- Evento: Escuta o chat para dar Invite por palavra-chave
onTalk(function(name, level, mode, text, channelId, pos)
    if not storage[panelName].enabled or not storage[panelName].soulider2 then return end
    if name == player:getName() then return end

    local keyword = storage[panelName].palavraInvite:lower()
    if keyword == "" then return end

    if text:lower():find(keyword) then
        -- 1. Verifica Ban List do seu painel
        if table.contains(storage[panelName].banListPlayers, name, true) then
            g_game.talkPrivate(5, name, "You are banned from my party.")
            return
        end

        -- 2. Verifica Níveis (usando o que está no storage/painel)
        local minL = tonumber(storage[panelName].minLevel) or 0
        local maxL = tonumber(storage[panelName].maxLevel) or 9999
        if level < minL or level > maxL then
            g_game.talkPrivate(5, name, "Min level: " .. minL .. " | Max level: " .. maxL)
            return
        end

        -- 3. Verifica Limite de 30 players
        if partyMembersCount >= 30 then
            g_game.talkPrivate(5, name, "Party is full (30 members).")
            return
        end

        -- 4. Tenta invitar
        local spec = getCreatureByName(name)
        if spec then
            if spec:isPartyMember() or spec:getShield() == 2 then return end
            g_game.partyInvite(spec:getId())
        end
    end
end)

local lastAppearTalk = 0
onCreatureAppear(function(creature)
    if not storage[panelName].enabled or not storage[panelName].soulider2 then return end
    if not creature:isPlayer() or creature:isLocalPlayer() then return end

    -- ignora quem já está na party ou já foi convidado
    if creature:isPartyMember() or creature:getShield() == 2 then return end

    local now = os.time()

    -- fala a cada 10s no máximo
    if partyMembersCount < 30 and (lastAppearTalk == 0 or (now - lastAppearTalk) >= 10) then
        local key = storage[panelName].palavraInvite
        if key and key ~= "" then
            say("Fale '" .. key .. "' para ser invitado na party!")
            lastAppearTalk = now
        end
    end
end)

-- Evento: Monitora mensagens do sistema para resetar info
onTextMessage(function(mode, text)
    if not storage[panelName].enabled or not storage[panelName].soulider2 then return end
    
    local t = text:lower()
    if t:find("you are now the leader") or t:find("has joined the party") or (t:find("has left the party") and canSeeInfo) then
        justForInfo = true
    end

    -- Parsing extra caso o server mande o range de level em texto limpo
    if t:find("level para compartilhamento") then
        local lMax, lMin = text:match("de (%d+) até (%d+)")
        if lMin and lMax then
            storage[panelName].minLevel = lMin
            storage[panelName].maxLevel = lMax
            autoPartyListWindow.textMinLevel:setText(lMin)
            autoPartyListWindow.textMaxLevel:setText(lMax)
        end
    end
end)

local lastsayparty = 0
macro(200, function()
  if not storage[panelName].enabled then return end
  if not storage[panelName].pedirParty then return end

  -- já está em party
  if player:getShield() > 2 then return end

  -- texto pra pedir party
  local frase = storage[panelName].palavraPedirPT
  if not frase or frase == "" then return end

  local now = os.time()

  if (lastsayparty == 0 or (now - lastsayparty) >= 10) then
    say(frase)
    lastsayparty = now
  end
end)


macro(200, function()
  if not storage[panelName].enabled then return end
  if not storage[panelName].aceitarParty then return end

  -- já está em party
  if player:getShield() > 2 then return end
  -- tenta aceitar convite de quem estiver na tela
  for _, spec in pairs(getSpectators(false)) do
    if spec:isPlayer() and spec:getShield() == 1 then
      g_game.partyJoin(spec:getId())
      return
    end
  end
end)

