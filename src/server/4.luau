local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CharacterConfigurations = require(ReplicatedStorage.SharedModules.Configurations.CharacterConfigurations)

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
    if Players.Values.IsAttacking.Value == false and not AttackDebounces[Player] then
        AttackDebounces[Player] = true
        Players.Values.IsAttacking.Value = true

        task.delay(AttackData.Attacks[tonumber(script.Name)].AttackDuration, function()
            Players.Values.IsAttacking.Value = false
        end)
        task.delay(AttackData.Attacks[tonumber(script.Name)].AttackDebounce, function()
            AttackDebounces[Player] = nil
        end)
        return true
    else
        return false
    end
end

return module