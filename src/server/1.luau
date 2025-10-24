
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterConfigurations = require(ReplicatedStorage.SharedModules.Configurations.CharacterConfigurations)

local Events = ReplicatedStorage.Events
local AttackDebounces = {}
local module = {}

local AttackData = nil

for _, v in CharacterConfigurations do
    if v.CharacterName == script.Parent.Name then
        AttackData = v
        break
    end
end

module.AttackFunction = function(Player)
    local cfg = AttackData.Attacks[tonumber(script.Name)]
    if not cfg then return false end

    if AttackDebounces[Player] then
        return false
    end
    
    local Character = Player.Character

    local FireBallAnimation = Character.Humanoid.Animator:LoadAnimation(ReplicatedStorage.Animation.ThrowFireballAnimation)
    FireBallAnimation:Play()

    FireBallAnimation:GetMarkerReachedSignal("CreateFireball"):Connect(function()
        local Fireball = ReplicatedStorage.Assets.Fireball:Clone()
        Fireball.Anchored = true
        Fireball.CFrame = Character["Right Arm"].RightGripAttachment.WorldCFrame
        Fireball.Parent = workspace
        
        task.wait(0.01)
        Events.TweenFireballSize:FireAllClients(Fireball,Vector3.new(0.1, 0.1, 0.1), false)
        Events.TweenFireballSize:FireAllClients(Fireball,Fireball.Size, true, 0.2)
    end)
    AttackDebounces[Player] = true
    task.delay(cfg.AttackDebounce, function()
        AttackDebounces[Player] = nil
    end)
    return true
end

return module