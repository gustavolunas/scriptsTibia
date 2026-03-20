setDefaultTab("War")

UI.Separator():setMarginTop(-0)

LABEL2 = UI.Label("PVP SCRIPTS")
LABEL2:setMarginTop(-1)
LABEL2:setFont("sono_bold_border_14")
macro(10, function()
    local text = 'WAR SCRIPTS'
    local time = os.clock() * 4
    local coloredText = {}


    for i = 1, #text do
        local char = text:sub(i, i)
        local color = setRainbowColor(time + i * 0.1) 
        table.insert(coloredText, char) 
        table.insert(coloredText, color) 
    end


    if LABEL2 and LABEL2 then
        LABEL2:setColoredText(coloredText)
    end
end)

UI.Separator():setMarginTop(-2)


warning = function() end

-----------==========
--MULTILEADERS
-----------==========

storage.MultiLeaderAttack = storage.MultiLeaderAttack or {
  enabled = false,
  leader1 = "",
  leader2 = "",
  leader3 = ""
}

local multiSettings = storage.MultiLeaderAttack

multiSettings.enabled = multiSettings.enabled == true
multiSettings.leader1 = tostring(multiSettings.leader1 or "")
multiSettings.leader2 = tostring(multiSettings.leader2 or "")
multiSettings.leader3 = tostring(multiSettings.leader3 or "")

local function trimText(text)
  text = tostring(text or "")
  text = text:gsub("^%s+", "")
  text = text:gsub("%s+$", "")
  return text
end

liderPrioridade = setupUI([[
Panel
  height: 80
    
  BotTextEdit
    id: leader1
    anchors.top: parent.top
    anchors.left: parent.left
    anchors.right: parent.right
    image-color: gray
    margin-top: 0
    color: yellow
    font: verdana-9px
    placeholder: "   INSERT LEADER[1] NAME!"
    placeholder-font: verdana-9px
    text-align: left
  
  BotTextEdit
    id: leader2
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    image-color: gray
    margin-top: 3
    color: yellow
    font: verdana-9px
    placeholder: "   INSERT LEADER[2] NAME!"
    placeholder-font: verdana-9px
    text-align: left

  BotTextEdit
    id: leader3
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    image-color: gray
    margin-top: 3
    color: yellow
    font: verdana-9px
    placeholder: "   INSERT LEADER[3] NAME!"
    placeholder-font: verdana-9px
    text-align: left

  BotSwitch
    id: ativador
    anchors.top: prev.bottom
    anchors.left: parent.left
    anchors.right: parent.right
    text-align: center
    margin-left: -1
    margin-right: -1
    text: MULTI LEADER ATTACK
    font: verdana-9px
    height: 18
    color: white
    image-source: /images/ui/button_rounded
    $on:
      color: #32CD32
      image-color: #3CB371
    $!on:
      image-color: gray
      color: white
]])

liderPrioridade:show()

liderPrioridade.leader1:setText(multiSettings.leader1)
liderPrioridade.leader2:setText(multiSettings.leader2)
liderPrioridade.leader3:setText(multiSettings.leader3)
liderPrioridade.ativador:setOn(multiSettings.enabled)

liderPrioridade.leader1.onTextChange = function(widget, text)
  multiSettings.leader1 = trimText(text)
end

liderPrioridade.leader2.onTextChange = function(widget, text)
  multiSettings.leader2 = trimText(text)
end

liderPrioridade.leader3.onTextChange = function(widget, text)
  multiSettings.leader3 = trimText(text)
end

liderPrioridade.ativador.onClick = function(widget)
  multiSettings.enabled = not multiSettings.enabled
  widget:setOn(multiSettings.enabled)
end

local mlTarget = nil
local mlCurrentPriority = nil
local mlLastTargetTime = 0

local function isFriend(name)
  if not name then return false end
  if not storage.playerList or not storage.playerList.friendList then
    return false
  end
  return table.find(storage.playerList.friendList, name, true)
end

local function getLeaderPriorityByName(name)
  if not name or name == "" then return nil end
  local attackerName = name:lower()

  local l1 = trimText(multiSettings.leader1):lower()
  local l2 = trimText(multiSettings.leader2):lower()
  local l3 = trimText(multiSettings.leader3):lower()

  if l1 ~= "" and attackerName == l1 then
    return 1
  end

  if l2 ~= "" and attackerName == l2 then
    return 2
  end

  if l3 ~= "" and attackerName == l3 then
    return 3
  end

  return nil
end

local function canReplaceTarget(newPriority)
  if not mlTarget or not mlCurrentPriority then
    return true
  end

  if newPriority < mlCurrentPriority then
    return true
  end

  if newPriority == mlCurrentPriority then
    return true
  end

  if now - mlLastTargetTime > 1500 then
    return true
  end

  return false
end

onMissle(function(missle)
  if not multiSettings.enabled then return end
  if not missle then return end

  local src = missle:getSource()
  local dst = missle:getDestination()
  if not src or not dst then return end
  if src.z ~= posz() or dst.z ~= posz() then return end

  local fromTile = g_map.getTile(src)
  local toTile = g_map.getTile(dst)
  if not fromTile or not toTile then return end

  local fromCreatures = fromTile:getCreatures()
  local toCreatures = toTile:getCreatures()
  if not fromCreatures or not toCreatures then return end
  if #fromCreatures ~= 1 or #toCreatures ~= 1 then return end

  local attacker = fromCreatures[1]
  local target = toCreatures[1]
  if not attacker or not target then return end

  local attackerName = attacker:getName()
  local targetName = target:getName()

  if not attackerName or attackerName == "" then return end
  if not targetName or targetName == "" then return end
  if isFriend(targetName) then return end

  local priority = getLeaderPriorityByName(attackerName)
  if not priority then return end

  if canReplaceTarget(priority) then
    mlTarget = target
    mlCurrentPriority = priority
    mlLastTargetTime = now
  end
end)

macro(100, function()
  if not multiSettings.enabled then
    mlTarget = nil
    mlCurrentPriority = nil
    mlLastTargetTime = 0
    return
  end

  if not mlTarget then return end

  if g_game.isAttacking() and g_game.getAttackingCreature() == mlTarget then
    return
  end

  g_game.attack(mlTarget)

  mlTarget = nil
  mlCurrentPriority = nil
  mlLastTargetTime = 0
end)

UI.Separator()
