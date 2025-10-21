print("ServerAttackhandler loaded properly")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local Events = ReplicatedStorage.Events

local AttackHitboxes = require(script.Parent.AttackHitboxes)

local ClickAttackDebounces = {}

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

    task.wait(LoadedPunchAnimation.Length + 0.1)
    if ClickAttackDebounces[Player] then
        ClickAttackDebounces[Player] = nil
    end

end)