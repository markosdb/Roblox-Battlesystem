local Players = game:GetService("Players")
local ServerScriptService = game:GetService("ServerScriptService")

local ProfileManager = require(ServerScriptService.Services.ProfileManager)

local module = {}

function module.createHitbox(Character, HitboxSize, Damage, Blockable)
    local Player = Players:GetPlayerFromCharacter(Character)
    local Profile = ProfileManager.Profiles[Player]
    local Hitbox = Instance.new("Part")
    Hitbox.Transparency = 0.9
    Hitbox.BrickColor = BrickColor.new("Bright red")
    Hitbox.CanCollide = false
    Hitbox.Anchored = true
    Hitbox.Size = HitboxSize
    Hitbox.CFrame = Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, -3)
    Hitbox.Parent = workspace

    local PartsInHitbox = workspace:GetPartsInPart(Hitbox)
    local Debounces = {}

    for _, v in PartsInHitbox do
        local Humanoid = v.Parent:FindFirstChild("Humanoid") or v.Parent.Parent:FindFirstChild("Humanoid")
        if Humanoid and Humanoid.Parent ~= Character and not Debounces[Humanoid] and Humanoid.Health > 0 then
            Debounces[Humanoid] = true
            if Blockable then
                if not Humanoid.Parent:FindFirstChild("Blocking") then
                    Humanoid.Health = math.max(0, Humanoid.Health - Damage)
                    if Humanoid.Health == 0 then
                        Profile.Data.leaderstats.Kills += 1
                    end
                end
            else
                Humanoid.Health = math.max(0, Humanoid.Health - Damage)
            end
        end
    end
   
    task.delay(0.3, function()
        Hitbox:Destroy()
    end)
end

return module 