
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterConfigurations = require(ReplicatedStorage.SharedModules.Configurations.CharacterConfigurations)

local AttackHitboxes = require(game.ServerScriptService.Modules.AttackHitboxes)

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

    local Fireball = nil

    FireBallAnimation:GetMarkerReachedSignal("CreateFireball"):Connect(function()
        Fireball = ReplicatedStorage.Assets.Fireball:Clone()
        Fireball.Anchored = true
        Fireball.Position = Character["Right Arm"].RightGripAttachment.WorldPosition
        Fireball.Orientation = Character.HumanoidRootPart.Orientation
        Fireball.Parent = workspace
        local FireballDebounce = false

        Fireball.Touched:Connect(function(Hit)
           local Humanoid = Hit.Parent:FindFirstChild("Humanoid") or Hit.Parent.Parent:FindFirstChild("Humanoid") 
           if Humanoid then
               if Hit.Parent.Name ~= Player.Name and Hit.Parent.Parent.Name ~= Player.Name then
                   print("Hit detected by fireball")
                   if not FireballDebounce then
                       FireballDebounce = true
                       AttackHitboxes.createHitbox(Character, Fireball.Size, 20, false, Humanoid.Parent.HumanoidRootPart.CFrame)
                       Events.TweenFireballSize:FireAllClients(Fireball,Vector3.new(0.1, 0.1, 0.1), true, 0.2)

                       local Particle = ReplicatedStorage.Assets.Fireball.FireballHitParticle:Clone() 
                       Particle.Parent = Humanoid.Parent.HumanoidRootPart
                       Particle:Emit(50)

                       task.delay(0.5, function()
                           Fireball:Destroy()
                       end)
                   end
               end
            end
        end)

        task.wait()
        Events.TweenFireballSize:FireAllClients(Fireball,Vector3.new(0.1, 0.1, 0.1), false)
        Events.TweenFireballSize:FireAllClients(Fireball,Fireball.Size, true, 0.2)
        
        task.delay(3, function()
            if Fireball and Fireball.Parent ~= nil then
                Fireball:Destroy()
            end
        end)

    end)

    FireBallAnimation:GetMarkerReachedSignal("ThrowFireball"):Connect(function()
        Fireball.VectorForce.Force = Vector3.new(0, Fireball.Mass * workspace.Gravity, 0)
        Fireball.Anchored = false
        
        Fireball.AssemblyLinearVelocity = Character.HumanoidRootPart.CFrame.LookVector * 80
    end)

    AttackDebounces[Player] = true
    task.delay(cfg.AttackDebounce, function()
        AttackDebounces[Player] = nil
    end)
    return true
end

return module