local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")

local Player = game.Players.LocalPlayer
local Character = script.Parent.Parent.Parent


local Events = ReplicatedStorage:WaitForChild("Events")

Events:WaitForChild("TweenFireballSize").OnClientEvent:Connect(function(Fireball, NewSize, Tween, TweenDuration)
    if not Tween then
        Fireball.Size = NewSize
    else
        TweenService:Create(Fireball, TweenInfo.new(TweenDuration, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Size = NewSize}):Play()
    end
end)
