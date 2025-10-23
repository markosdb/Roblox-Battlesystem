print("ServerAttackhandler loaded properly")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = ReplicatedStorage.Events

local AttackHitboxes = require(script.Parent.Modules.AttackHitboxes)
local CharacterConfigurations = require(ReplicatedStorage.SharedModules.Configurations.CharacterConfigurations)

local ClickAttackDebounces = {}

local function EquipCharacter(Player, CharacterName)
    local Values = Player:WaitForChild("Values")
    Values.Character.Value = CharacterName

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
    local PlayerCharacter = Player.Values.Character.Value
    local Result = require(script.Characters[PlayerCharacter][tostring(AttackNumber)]).AttackFunction(Player)
    return Result
end

Players.PlayerAdded:Connect(PlayerAdded)

for _, v in Players:GetPlayers() do
    task.spawn(function()
        PlayerAdded(v)
    end)

end