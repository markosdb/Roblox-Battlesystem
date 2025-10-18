
local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(Player)
    print(Player.Name .. " has joined the game.")
    for _, v in script.PlayerValues:GetChildren() do
        v:Clone().Parent = Player
    end
end)
