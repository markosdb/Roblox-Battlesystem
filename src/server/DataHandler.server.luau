local Players = game:GetService("Players")

Players.PlayerAdded:Connect(function(Player)
    print("Player joined: " .. Player.Name)
    for _,v in script.PlayerValues:GetChildren() do
        v:Clone().Parent = Player
    end
end)