local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Events = ReplicatedStorage:WaitForChild("Events")

local Character = script.Parent.Parent

local IsBlocking = false

UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
    if GameProcessedEvent then return end
    if Input.UserInputType == Enum.UserInputType.MouseButton1 and not IsBlocking then
        Events.ClickAttack:FireServer()
    end

    if Input.KeyCode == Enum.KeyCode.F then
        IsBlocking = true
        Events.Blocking:FireServer(true)
    end
end)
UserInputService.InputEnded:Connect(function(Input, GameProcessedEvent)
    if GameProcessedEvent then return end
    if Input.KeyCode == Enum.KeyCode.F then
        IsBlocking = false
        Events.Blocking:FireServer(false)
    end
end)