setDefaultTab("Tools")



switchTravel = "travelButton"

storage[switchTravel] = storage[switchTravel] or { enabled = false }
travelButton = setupUI([[
Panel
  height: 18
  
  BotSwitch
    id: title
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    height: 18
    text: FAST TRAVEL
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
travelButton:setId(switchTravel)
travelButton.title:setOn(storage[switchTravel].enabled)

travelButton.title.onClick = function(widget)
  local newState = not widget:isOn()
  widget:setOn(newState)
  storage[switchTravel].enabled = newState
end

local STKEY = "lnsFastTravel"
storage[STKEY] = storage[STKEY] or {
  activationMode = "", -- "", "APROXIMAÇÃO (3SQM)", "POR ATAQUE"
  selectedNpc = "",
  npcs = {
    -- ["Npc Name"] = { cities = { "Carlin", "Thais" } }
  }
}
local st = storage[STKEY]

local defaultNpcs = {
  ["Captain Bluebear"] = { cities = { "Carlin", "Ab'dendriel", "Edron", "Venore", "Port Hope", "Liberty Bay", "Yalahar", "Roshamuul", "Krailos", "Oramond", "Rangiroa", "Svargrond", "Arcadia" } },
  ["Captain Fearless"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Port Hope", "Edron", "Darashia", "Liberty Bay", "Svargrond", "Yalahar", "Gray Island", "Ankrahmun", "Issavi", "Arcadia", "Rangiroa" } },
  ["Captain Greyhound"] = { cities = { "Thais", "Ab'dendriel", "Venore", "Svargrond", "Yalahar", "Rangiroa", "Arcadia", "Edron" } },
  ["Captain Seahorse"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Venore", "Port Hope", "Ankrahmun", "Liberty Bay", "Gray Island", "Cormaya" } },
  ["Karith"] = { cities = { "Thais", "Carlin", "Ab'dendriel", "Ankrahmun", "Darashia", "Venore", "Port Hope", "Liberty Bay", "Arcadia" } },
  ["Captain Sinbeard"] = { cities = { "Darashia", "Venore", "Liberty Bay", "Port Hope", "Yalahar", "Edron" } },
  ["Petros"] = { cities = { "Venore", "Port Hope", "Liberty Bay", "Ankrahmun", "Yalahar", "Issavi", "Gray Island" } },
  ["Charles"] = { cities = { "Thais", "Darashia", "Venore", "Liberty Bay", "Ankrahmun", "Yalahar", "Edron" } },
  ["Jack Fate"] = { cities = { "Edron", "Thais", "Venore", "Darashia", "Ankrahmun", "Yalahar", "Port Hope", "Goroma", "Liberty Bay" } },
  ["Captain Seagull"] = { cities = { "Thais", "Carlin", "Venore", "Yalahar", "Edron", "Gray Island" } },
  ["Scrutinon"] = { cities = { "Ab'dendriel", "Darashia", "Edron", "Venore" } },
  ["Captain Harava"] = { cities = { "Darashia", "Krailos", "Oramond", "Venore" } },
  ["Captain Gulliver"] = { cities = { "Thais", "Edron", "Venore", "Port Hope", "Issavi", "Krailos" } },
  ["Captain Pelagia"] = { cities = { "Venore", "Edron", "Oramond", "Issavi", "Darashia" } },
  ["Captain Chelop"] = { cities = { "Thais" } },
  ["Captain Breezelda"] = { cities = { "Carlin", "Thais", "Venore", "Arcadia" } },
  ["Captain Frank"] = { cities = { "Venore" } },
  ["Captain Grenald"] = { cities = { "Carlin", "Thais", "Venore", "Yalahar", "Svargrond" } },
  ["Pemaret"] = { cities = { "Edron" } },
  ["Maris"] = { cities = { "Fenrock", "Mistrock", "Yalahar" } },
  ["Captain Cookie"] = { cities = { "Liberty Bay" } },
  ["Chemar"] = { cities = { "Farmine" } },
  ["Melian"] = { cities = { "Darashia", "Femor Hills", "Svargrond", "Issavi", "Marapur", "Edron" } },
  ["Imbul"] = { cities = { "East" } },
  ["Lorek"] = { cities = { "Banuta", "West" } },
  ["Buddel"] = { cities = { "Helheim", "Svargrond" } },
  ["Gurbasch"] = { cities = { "Gnomprona" } },
  ["Urks The Mute"] = { cities = { "Cormaya" } },
  ["Thorgrin"] = { cities = { "Cormaya" } },
  ["Eustacio"] = { cities = { "Shortcut" } },
  ["Captain Jack Rat"] = { cities = { "Sail", "Safe" } },
  ["Harlow"] = { cities = { "Yalahar", "Vengoth" } },
}

local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeText(s)
  s = tostring(s or "")
  s = s:lower()
  s = s:gsub("%s+", " ")
  s = trim(s)
  return s
end

local function sameText(a, b)
  return normalizeText(a) == normalizeText(b)
end

local function containsText(hay, needle)
  hay = normalizeText(hay)
  needle = normalizeText(needle)
  if needle == "" then return true end
  return hay:find(needle, 1, true) ~= nil
end

local function ensureNpc(name)
  name = trim(name)
  if name == "" then return nil end
  st.npcs[name] = st.npcs[name] or { cities = {} }
  st.npcs[name].cities = st.npcs[name].cities or {}
  return name
end

local function cityExists(cities, cityName)
  for _, c in ipairs(cities) do
    if sameText(c, cityName) then return true end
  end
  return false
end

local function addCityToNpc(npcName, cityName)
  npcName = trim(npcName)
  cityName = trim(cityName)
  if npcName == "" or cityName == "" then return false end
  if not st.npcs[npcName] then return false end
  local cities = st.npcs[npcName].cities
  if cityExists(cities, cityName) then return false end
  table.insert(cities, cityName)
  return true
end

st.npcs = st.npcs or {}

for npcName, data in pairs(defaultNpcs) do
  if not st.npcs[npcName] then
    st.npcs[npcName] = { cities = {} }
  end

  st.npcs[npcName].cities = st.npcs[npcName].cities or {}

  for _, cityName in ipairs(data.cities or {}) do
    local exists = false
    for _, savedCity in ipairs(st.npcs[npcName].cities) do
      if normalizeText(savedCity) == normalizeText(cityName) then
        exists = true
        break
      end
    end

    if not exists then
      table.insert(st.npcs[npcName].cities, cityName)
    end
  end
end

travelInterface = setupUI([=[
UIWindow
  id: mainPanel
  size: 370 310
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
    text: LNS Custom | Fast Travel
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

  TextEdit
    id: pesquisarNPC
    anchors.top: prev.bottom
    anchors.left: parent.left
    width: 170
    margin-left: 10
    color: yellow
    image-color: #2f2f2f
    font: verdana-9px
    placeholder: PESQUISAR POR NPC
    placeholder-font: verdana-9px

  TextList
    id: panelMain
    anchors.top: prev.bottom
    anchors.right: prev.right
    anchors.left: prev.left
    margin-right: 10
    margin-top: 2
    height: 180
    image-color: gray
    opacity: 0.95
    border: 1 black
    vertical-scrollbar: panelMainScroll

  VerticalScrollBar
    id: panelMainScroll
    anchors.top: panelMain.top
    anchors.bottom: panelMain.bottom
    anchors.left: panelMain.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    image-color: #2f2f2f
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirNpcName
    anchors.top: panelMain.bottom
    anchors.left: panelMain.left
    width: 140
    margin-top: 2
    color: yellow
    image-color: #2f2f2f
    font: verdana-9px
    placeholder: INSERT NAME NPC!
    placeholder-font: verdana-9px
  
  Button
    id: buttonAdd
    anchors.top: prev.top
    anchors.right: panelMainScroll.right
    anchors.left: prev.right
    margin-left: 2
    text: +
    font: sans-bold-16px
    image-source: /images/ui/button_rounded
    image-color: #363636

  VerticalSeparator
    id: vertsep
    anchors.top: pesquisarNPC.top
    anchors.left: pesquisarNPC.right
    margin-left: 5
    anchors.bottom: buttonAdd.bottom

  Panel
    id: panelCity
    anchors.top: prev.top
    anchors.left: prev.right
    width: 170
    height: 22
    margin-left: 5
    color: yellow
    text: CONFIG CITYS TRAVEL
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f
    color: gray

  TextList
    id: configLista
    anchors.top: prev.bottom
    anchors.right: prev.right
    anchors.left: prev.left
    margin-top: 2
    margin-right: 10
    height: 180
    image-color: gray
    opacity: 0.95
    border: 1 black
    vertical-scrollbar: ConfigListaScroll

  VerticalScrollBar
    id: ConfigListaScroll
    anchors.top: configLista.top
    anchors.bottom: configLista.bottom
    anchors.left: configLista.right
    width: 13
    margin-top: 1
    margin-bottom: 1
    image-color: #2f2f2f
    step: 18
    pixels-scroll: true

  TextEdit
    id: inserirCityName
    anchors.top: configLista.bottom
    anchors.left: configLista.left
    width: 140
    margin-top: 2
    color: yellow
    image-color: #2f2f2f
    font: verdana-9px
    placeholder: INSERT CITY NAME
    placeholder-font: verdana-9px
  
  Button
    id: buttonCity
    anchors.top: prev.top
    anchors.right: ConfigListaScroll.right
    anchors.left: prev.right
    margin-left: 2
    text: +
    font: sans-bold-16px
    image-source: /images/ui/button_rounded
    image-color: #363636

  Panel
    id: panelTravelON
    anchors.top: panelMain.bottom
    anchors.left: panelMain.left
    anchors.right: buttonCity.right
    width: 180
    height: 25
    margin-top: 30
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f

    Label
      id: labelTravelON
      anchors.left: parent.left
      anchors.top: parent.top
      margin-top: 6
      margin-left: 5
      text: COMO ATIVAR O FAST-TRAVEL:
      text-auto-resize: true
      font: verdana-9px
      color: gray

  ComboBox
    id: comoAtivarTravel
    anchors.top: panelTravelON.top
    anchors.right: panelTravelON.right
    margin-right: 6
    margin-top: 3
    width: 170
    height: 19
    image-color: #2f2f2f
    font: verdana-9px

]=], g_ui.getRootWidget())
travelInterface:hide();

function buttonsTravelPcMobile()
  if modules._G.g_app.isMobile() then
    travelButton.settings:show()
    travelButton.title:setMarginRight(55)
  else
    travelButton.settings:hide()
    travelButton.title:setMarginRight(0)
  end
end
buttonsTravelPcMobile()

travelButton.title.onMouseRelease = function(widget, mousePos, mouseButton)
  if mouseButton == 2 then
    if not travelInterface:isVisible() then
      travelInterface:show()
      travelInterface:raise();
      travelInterface:focus();
    else
      travelInterface:hide()
    end
  end
end

travelButton.settings.onClick = function()
  travelInterface:show()
end

local npcRowTemplate = [[
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
    id: npcName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
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

local cityRowTemplate = [[
UIWidget
  id: root
  height: 18
  focusable: false
  background-color: alpha
  opacity: 1.00

  $hover:
    background-color: #2F2F2F
    opacity: 0.75

  Label
    id: cityName
    anchors.left: parent.left
    anchors.verticalCenter: parent.verticalCenter
    margin-left: 6
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

-- =========================
-- UI STATE
-- =========================
local npcRows = {}
local cityRows = {}

local function sortNpcNames()
  local names = {}
  for npcName, _ in pairs(st.npcs) do
    table.insert(names, npcName)
  end
  table.sort(names, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
  return names
end

local function refreshCitiesForSelectedNpc()
  local list = travelInterface.configLista
  if not list then return end

  if list.destroyChildren then list:destroyChildren() end
  cityRows = {}

  local npcName = trim(st.selectedNpc or "")
  if npcName == "" or not st.npcs[npcName] then return end

  local cities = st.npcs[npcName].cities or {}

  table.sort(cities, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)

  for index, cityName in ipairs(cities) do
    local row = g_ui.loadUIFromString(cityRowTemplate, list)
    row.cityName:setText(cityName)

    row.remove.onClick = function()
      local npc = st.npcs[npcName]
      if not npc or not npc.cities then return end

      for i = #npc.cities, 1, -1 do
        if sameText(npc.cities[i], cityName) then
          table.remove(npc.cities, i)
        end
      end

      refreshCitiesForSelectedNpc()
    end

    table.insert(cityRows, {
      root = row,
      nameLabel = row.cityName,
      removeBtn = row.remove
    })
  end
end

local function selectNpc(npcName)
  npcName = trim(npcName)
  if npcName == "" then
    st.selectedNpc = ""
    refreshCitiesForSelectedNpc()
    return
  end
  if not st.npcs[npcName] then return end

  st.selectedNpc = npcName

  refreshCitiesForSelectedNpc()

  for name, pack in pairs(npcRows) do
    if pack and pack.root then
      if name == npcName then
        pack.root:focus()
      end
    end
  end
end

local function removeNpc(npcName)
  npcName = trim(npcName)
  if npcName == "" then return end

  if st.npcs[npcName] then
    st.npcs[npcName] = nil
  end

  if sameText(st.selectedNpc, npcName) then
    st.selectedNpc = ""
  end

  local currentFilter = ""
  if travelInterface.pesquisarNPC and travelInterface.pesquisarNPC.getText then
    currentFilter = travelInterface.pesquisarNPC:getText() or ""
  end

  local function refreshNpcList() end -- forward
end

-- =========================
-- CLICK BIND (robusto)
-- =========================
local function bindNpcRowClick(row, npcName)
  row.onMouseRelease = function(widget, mousePos, button)
    if button ~= MouseLeftButton then return end
    selectNpc(npcName)
  end

  if row.npcName then
    row.npcName.onMouseRelease = function(widget, mousePos, button)
      if button ~= MouseLeftButton then return end
      selectNpc(npcName)
    end
  end

  row.onClick = function()
    selectNpc(npcName)
  end
end

-- =========================
-- FILTER NPC LIST
-- =========================
local function matchesNpc(npcName, q)
  if q == "" then return true end
  return containsText(npcName, q)
end

local function filterNpcRows(query)
  local q = normalizeText(query)
  for npcName, pack in pairs(npcRows) do
    if pack and pack.root then
      if matchesNpc(npcName, q) then pack.root:show() else pack.root:hide() end
    end
  end
end

-- =========================
-- REFRESH NPC LIST (full rebuild)
-- =========================
local function refreshNpcList()
  local list = travelInterface.panelMain
  if not list then return end

  if list.destroyChildren then list:destroyChildren() end
  npcRows = {}

  local names = sortNpcNames()
  for _, npcName in ipairs(names) do
    local row = g_ui.loadUIFromString(npcRowTemplate, list)
    row.npcName:setText(npcName)

    npcRows[npcName] = {
      root = row,
      nameLabel = row.npcName,
      removeBtn = row.remove
    }

    bindNpcRowClick(row, npcName)

    row.remove.onClick = function()
      if st.npcs[npcName] then st.npcs[npcName] = nil end
      if sameText(st.selectedNpc, npcName) then st.selectedNpc = "" end

      local currentFilter = travelInterface.pesquisarNPC and travelInterface.pesquisarNPC:getText() or ""
      refreshNpcList()
      filterNpcRows(currentFilter or "")
      refreshCitiesForSelectedNpc()
    end
  end

  if st.selectedNpc ~= "" and npcRows[st.selectedNpc] and npcRows[st.selectedNpc].root then
    npcRows[st.selectedNpc].root:focus()
  end
end

-- =========================
-- BUTTONS / EVENTS
-- =========================
travelInterface.closePanel.onClick = function()
  travelInterface:hide()
end

local TRAVEL_MODES = { "", "APROXIMACAO (3SQM)", "POR ATAQUE" }

travelInterface.comoAtivarTravel:clearOptions()
for _, opt in ipairs(TRAVEL_MODES) do
  travelInterface.comoAtivarTravel:addOption(opt)
end

local function applyComboFromStorage()
  local mode = tostring(st.activationMode or "")
  local idx = 1
  for i, opt in ipairs(TRAVEL_MODES) do
    if opt == mode then
      idx = i
      break
    end
  end
  if travelInterface.comoAtivarTravel.setCurrentOption then
    travelInterface.comoAtivarTravel:setCurrentOption(idx)
  end
  if travelInterface.comoAtivarTravel.setText then
    travelInterface.comoAtivarTravel:setText(TRAVEL_MODES[idx])
  end
end

local function saveComboToStorage(text)
  st.activationMode = tostring(text or "")
end

travelInterface.comoAtivarTravel.onOptionChange = function(_, text)
  saveComboToStorage(text)
end
travelInterface.comoAtivarTravel.onSelectionChange = function(_, text)
  saveComboToStorage(text)
end
travelInterface.comoAtivarTravel.onTextChange = function(_, text)
  if text ~= nil then saveComboToStorage(text) end
end

applyComboFromStorage()

travelInterface.pesquisarNPC.onTextChange = function(_, text)
  filterNpcRows(text or "")
end

travelInterface.buttonAdd.onClick = function()
  local name = travelInterface.inserirNpcName:getText() or ""
  name = trim(name)
  if name == "" then return end

  ensureNpc(name)
  travelInterface.inserirNpcName:setText("")
  refreshNpcList()

  local q = travelInterface.pesquisarNPC:getText() or ""
  filterNpcRows(q)

  selectNpc(name)
end

-- Add City for selected NPC
travelInterface.buttonCity.onClick = function()
  local npcName = trim(st.selectedNpc or "")
  if npcName == "" then return end

  local cityName = travelInterface.inserirCityName:getText() or ""
  cityName = trim(cityName)
  if cityName == "" then return end

  local ok = addCityToNpc(npcName, cityName)
  if ok then
    travelInterface.inserirCityName:setText("")
    refreshCitiesForSelectedNpc()
  end
end

-- =========================
-- INIT
-- =========================
refreshNpcList()
refreshCitiesForSelectedNpc()

do
  local q = travelInterface.pesquisarNPC and travelInterface.pesquisarNPC:getText() or ""
  filterNpcRows(q or "")
end

-- =========================
-- UTILS
-- =========================
local function trim(s)
  return (tostring(s or ""):gsub("^%s+", ""):gsub("%s+$", ""))
end

local function normalizeText(s)
  s = tostring(s or ""):lower()
  s = s:gsub("%s+", " ")
  return trim(s)
end

local function nowMs()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function isApproxMode()
  local m = normalizeText(st.activationMode or "")
  return (m == normalizeText("APROXIMAÇÃO (3SQM)")) or (m == normalizeText("APROXIMACAO (3SQM)"))
end

local function distSqm(a, b)
  if not a or not b then return 999 end
  if a.z ~= b.z then return 999 end
  return math.max(math.abs(a.x - b.x), math.abs(a.y - b.y))
end

local function sortCities(cities)
  table.sort(cities, function(a, b)
    return normalizeText(a) < normalizeText(b)
  end)
end

local function findNpcOnScreenByName(name)
  name = trim(name)
  if name == "" then return nil end
  local specs = getSpectators() or {}
  for _, cr in ipairs(specs) do
    if cr and cr.getName and cr:isNpc() and cr.getPosition then
      if cr:getName() == name then
        return cr
      end
    end
  end
  return nil
end

local function isNpcNear(name, maxDist)
  local me = g_game.getLocalPlayer()
  if not me then return false end
  local myPos = me:getPosition()
  if not myPos then return false end

  local npc = findNpcOnScreenByName(name)
  if not npc then return false end

  local npcPos = npc:getPosition()
  return distSqm(myPos, npcPos) <= (maxDist or 3)
end

-- =========================
-- UI
-- =========================
local travelUII = setupUI([[
UIWindow
  id: travelUII
  size: 300 70
  opacity: 0.85
  anchors.left: parent.left
  anchors.top: parent.top
  margin-left: 800
  margin-top: 150

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
    height: 25
    background-color: #111111
    opacity: 1.00
    border: 1 #1f1f1f

  Label
    id: titleLabel
    anchors.centerIn: topBar
    text: [LNS] Select City Travel
    text-auto-resize: true
    color: orange
    font: verdana-11px-rounded

  Panel
    id: panelTravelUII
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    width: 180
    height: 35
    margin-top: 10
    margin-left: 10
    margin-right: 10
    font: verdana-9px
    background-color: black
    border: 1 #1f1f1f

    Label
      id: labelTraveUII
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.top: parent.top
      margin-top: 12
      margin-left: 10
      margin-right: 10
      text: SELECIONE A CITY:
      text-auto-resize: true
      font: verdana-9px
      color: gray

  ComboBox
    id: TravelOptions
    anchors.top: panelTravelUII.top
    anchors.right: panelTravelUII.right
    margin-right: 6
    margin-top: 3
    width: 160
    height: 29
    image-color: #2f2f2f
    color: gray
    font: verdana-11px-rounded
]], g_ui.getRootWidget())

travelUII:hide()

-- =========================
-- STATE
-- =========================
local uiNpcName = ""          -- NPC atual do painel
local lastCitiesKey = ""      -- evita repopular toda hora
local travelCooldownMs = 1200 -- anti-spam geral
local lastTravelAt = 0
local lockTravel = false

local function buildCitiesKey(cities)
  if not cities then return "" end
  local tmp = {}
  for i = 1, #cities do tmp[#tmp + 1] = normalizeText(cities[i]) end
  table.sort(tmp)
  return table.concat(tmp, "|")
end

local function fillCitiesCombo(cities)
  travelUII.TravelOptions:clearOptions()

  travelUII.TravelOptions:addOption("")

  if cities and #cities > 0 then
    for i = 1, #cities do
      travelUII.TravelOptions:addOption(cities[i])
    end
  end

  if travelUII.TravelOptions.setCurrentOption then
    travelUII.TravelOptions:setCurrentOption(1)
  end
  if travelUII.TravelOptions.setText then
    travelUII.TravelOptions:setText("")
  end
end

local function showTravelUIForNpc(npcName)
  npcName = trim(npcName)
  if npcName == "" or not st.npcs[npcName] then return end

  local cities = st.npcs[npcName].cities or {}
  sortCities(cities)

  local key = buildCitiesKey(cities)
  if uiNpcName ~= npcName or lastCitiesKey ~= key then
    fillCitiesCombo(cities)
    uiNpcName = npcName
    lastCitiesKey = key
  end

  if not travelUII:isVisible() then
    travelUII:show()
  end
end

local function hideTravelUI()
  if travelUII:isVisible() then travelUII:hide() end
  uiNpcName = ""
  lastCitiesKey = ""
end

-- =========================
-- TRAVEL SEQUENCE
-- =========================
local function doNpcTravel(npcName, city)
  npcName = trim(npcName)
  city = trim(city)

  if npcName == "" or city == "" then return end
  if lockTravel then return end

  local t = nowMs()
  if (t - lastTravelAt) < travelCooldownMs then return end

  if not isNpcNear(npcName, 3) then return end

  lockTravel = true
  lastTravelAt = t

  local nameCopy = npcName
  local cityCopy = city

  NPC.say("hi")

  schedule(250, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say(cityCopy)
    if (player:isPartyMember() or player:isPartyLeader() or player:getShield() > 2) then 
      sayChannel(1, "Travel to: " .. cityCopy)
    end
  end)

  schedule(500, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say("yes")
  end)

  schedule(500, function()
    if not isNpcNear(nameCopy, 3) then lockTravel = false return end
    NPC.say("yes")
    lockTravel = false
  end)
end

local function onCitySelected(_, text)
  local city = trim(text or "")
  if city == "" then return end
  if uiNpcName == "" then return end
  doNpcTravel(uiNpcName, city)
end

travelUII.TravelOptions.onOptionChange = onCitySelected
travelUII.TravelOptions.onSelectionChange = onCitySelected
travelUII.TravelOptions.onTextChange = onCitySelected

macro(200, function()
  if not storage[switchTravel].enabled then hideTravelUI() return; end
  if not isApproxMode() then
    return
  end

  local me = g_game.getLocalPlayer()
  if not me then hideTravelUI() return end
  local myPos = me:getPosition()
  if not myPos then hideTravelUI() return end

  local bestName = ""
  local bestDist = 999

  local specs = getSpectators() or {}
  for _, cr in ipairs(specs) do
    if cr and cr.getName and cr.getPosition and cr:isNpc() then
      local name = cr:getName()
      if name and st.npcs[name] then
        local d = distSqm(myPos, cr:getPosition())
        if d <= 3 and d < bestDist then
          bestDist = d
          bestName = name
        end
      end
    end
  end

  if bestName ~= "" then
    showTravelUIForNpc(bestName)
  else
    hideTravelUI()
  end
end)

--================
--ATTACKMODE
--================
local function isAttackMode()
  return tostring(st.activationMode or "") == "POR ATAQUE"
end

-- estado do "último NPC clicado pra viajar"
local attackTravelNpc = ""
local attackTravelSeenAt = 0
local ATTACK_CLICK_WINDOW_MS = 1200 -- janela pra considerar "um clique"
local UI_KEEP_ALIVE_MS = 60000      -- segurança (fecha depois de 60s se quiser)

local function nowMs()
  if g_clock and g_clock.millis then return g_clock.millis() end
  return os.time() * 1000
end

local function findNpcByNameOnScreen(name)
  local specs = getSpectators() or {}
  for _, cr in ipairs(specs) do
    if cr and cr:isNpc() and cr.getName and cr.getPosition then
      if (cr:getName() or "") == name then
        return cr
      end
    end
  end
  return nil
end

onAttackingCreatureChange(function(creature, oldCreature)
  if not storage[switchTravel].enabled then hideTravelUI() return; end
  if not isAttackMode() then return end

  if not creature or not creature:isNpc() then return end

  local npcName = creature:getName() or ""
  if npcName == "" then return end
  if not st.npcs or not st.npcs[npcName] then return end

  local pos = creature:getPosition()
  if not pos or distanceFromPlayer(pos) > 3 then return end

  attackTravelNpc = npcName
  attackTravelSeenAt = nowMs()
  showTravelUIForNpc(npcName)
end)

macro(200, function()
  if not storage[switchTravel].enabled then hideTravelUI() return; end
  if not isAttackMode() then return end

  if attackTravelNpc == "" then return end

  if (nowMs() - attackTravelSeenAt) > UI_KEEP_ALIVE_MS then
    attackTravelNpc = ""
    hideTravelUI()
    return
  end

  local npc = findNpcByNameOnScreen(attackTravelNpc)
  if not npc then
    attackTravelNpc = ""
    hideTravelUI()
    return
  end

  local pos = npc:getPosition()
  if not pos or distanceFromPlayer(pos) > 3 then
    attackTravelNpc = ""
    hideTravelUI()
    return
  end
end)
