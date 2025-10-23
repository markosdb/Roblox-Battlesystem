local ServerScriptService = game:GetService("ServerScriptService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local ProfileService = require(ServerScriptService.Modules.ProfileService)
local ProfileTemplate = require(script.ProfileFolder.ProfileTemplate)

local ProfileStore = ProfileService.GetProfileStore(
    "Test key",
    ProfileTemplate
)

local module = {}
module.Profiles = {}

local function LoadPlayerInstances(Player, Profile)
    for _, v in script.PlayerValues:GetChildren() do
        v:Clone().Parent = Player
    end
    task.spawn(function()
        while true do
            for _, v in Player.leaderstats:GetChildren() do
                local ActualValue = Profile.Data.leaderstats[v.Name]
                v.Value = ActualValue
            end
            task.wait(0.1)
        end
    end)
end

local function  PlayerAdded(Player)
    local Profile = ProfileStore:LoadProfileAsync("Player_" .. Player.UserId)
    if Profile then
        Profile:AddUserId(Player.UserId)
        Profile:Reconcile()
        Profile:ListenToRelease(function()
            module.Profiles[Player] = nil
            Player:Kick("Your data has been released.")
        end)

        if Player:IsDescendantOf(Players) == true then
            module.Profiles[Player] = Profile
            LoadPlayerInstances(Player, Profile)
        else
            Profile:Release()
        end
    else
        Player:Kick("Failed to load your data.")
    end
end

for _, Player in Players:GetPlayers() do
    task.spawn(PlayerAdded, Player)
end

Players.PlayerAdded:Connect(PlayerAdded)

Players.PlayersRemoved:Connect(function(Player)
    local Profile = module.Profiles[Player]
    if Profile then
        Profile:Release()
    end
    
end)
return module