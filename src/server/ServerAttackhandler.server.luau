print("ServerAttackhandler loaded properly")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = ReplicatedStorage.Events

local AttackHitboxes = require(script.Parent.Modules.AttackHitboxes)
local CharacterConfigurations = require(ReplicatedStorage.SharedModules.Configurations.CharacterConfigurations)

local ClickAttackDebounces = {}

local function EquipCharacter(Player, CharacterName)
    -- Ensure Values folder and a StringValue named "Character" exist
    local Values = Player:FindFirstChild("Values")
    if not Values then
        Values = Instance.new("Folder")
        Values.Name = "Values"
        Values.Parent = Player
    end

    local CharacterValue = Values:FindFirstChild("Character")
    if not CharacterValue or CharacterValue.ClassName ~= "StringValue" then
        if CharacterValue then CharacterValue:Destroy() end
        CharacterValue = Instance.new("StringValue")
        CharacterValue.Name = "Character"
        CharacterValue.Parent = Values
    end

    CharacterValue.Value = CharacterName

    local CharacterData = nil

    for _,v in CharacterConfigurations do
        if v.CharacterName == CharacterName then
            CharacterData = v
            break
        end
    end

    Events.EquipCharacterClient:FireClient(Player, CharacterData)
end

local function PlayerAdded(Player)
    Player.CharacterAdded:Connect(function(Character)
         print("looaaded!")
         task.wait(1)
         EquipCharacter(Player, "Hunter")
    end)
end

Events.ClickAttack.OnServerEvent:Connect(function(Player)
    local Character = Player.Character
    if Character == nil then
        return
    end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid == nil then
        return
    end
    if Humanoid.Health <= 0 then
        return
    end
    if ClickAttackDebounces[Player] then
        return
    end
    
    ClickAttackDebounces[Player] = true
    local PunchCombo = Player.Values.PunchCombo
    local Animation = script.PunchAnimationCycle[tostring(PunchCombo.Value)]
    local LoadedPunchAnimation = Humanoid.Animator:LoadAnimation(Animation)
    LoadedPunchAnimation:Play()

    if tonumber(PunchCombo.Value) >= #script.PunchAnimationCycle:GetChildren() then
        PunchCombo.Value = 1
    else
        PunchCombo.Value += 1
    end
    
    LoadedPunchAnimation:GetMarkerReachedSignal("Hit"):Connect(function()
        AttackHitboxes.createHitbox(Character, Vector3.new(9, 9, 5), 10, true)
    end)
    

    task.wait(LoadedPunchAnimation.Length + 0.1)
    if ClickAttackDebounces[Player] then
        ClickAttackDebounces[Player] = nil
    end

end)

Events.Block.OnServerEvent:Connect(function(Player, Value)
    local Character = Player.Character
    if Character == nil then
        return
    end
    local Humanoid = Character:FindFirstChild("Humanoid")
    if Humanoid == nil then
        return
    end
    if Humanoid.Health <= 0 then
        return
    end
    if ClickAttackDebounces[Player] then
        return
    end

    if not Value then
        local LoadedAnimations = Humanoid.Animator:GetPlayingAnimationTracks()
        for _, v in LoadedAnimations do
            if v.Name == "Block" then
                v:Stop()
            end
        end
        if Character:FindFirstChild("Blocking") then
            Character.Blocking:Destroy()
        end
    else
        local BlockAnimation = Humanoid.Animator:LoadAnimation(script.Animations.Block)
        BlockAnimation:Play()
        local Blocking = Instance.new("StringValue")
        Blocking.Name = "Blocking"
        Blocking.Parent = Character
    end
end)

Events.SpecialAttack.OnServerInvoke = function(Player, AttackNumber)
    -- Validate inputs
    if typeof(AttackNumber) ~= "number" then
        warn("SpecialAttack: AttackNumber must be a number")
        return false
    end

    local Values = Player:FindFirstChild("Values")
    local CharacterValue = Values and Values:FindFirstChild("Character")
    local PlayerCharacter = CharacterValue and CharacterValue.Value or nil

    if type(PlayerCharacter) ~= "string" or PlayerCharacter == "" then
        warn("SpecialAttack: Player character not set; blocking invoke")
        return false
    end

    local CharactersFolder = script:FindFirstChild("Characters")
    if not CharactersFolder then
        warn("SpecialAttack: Characters folder missing under ServerAttackhandler")
        return false
    end

    local CharacterFolder = CharactersFolder:FindFirstChild(PlayerCharacter)
    if not CharacterFolder then
        warn(string.format("SpecialAttack: No character folder '%s'", PlayerCharacter))
        return false
    end

    local AttackModule = CharacterFolder:FindFirstChild(tostring(AttackNumber))
    if not AttackModule then
        warn(string.format("SpecialAttack: No attack '%s' for '%s'", tostring(AttackNumber), PlayerCharacter))
        return false
    end

    local ok, result = pcall(function()
        return require(AttackModule).AttackFunction(Player)
    end)
    if not ok then
        warn("SpecialAttack: error in attack module:", result)
        return false
    end
    return result == nil and true or result
end

Players.PlayerAdded:Connect(PlayerAdded)

for _, v in Players:GetPlayers() do
    task.spawn(function()
        PlayerAdded(v)
    end)

end