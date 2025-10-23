local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Events = ReplicatedStorage.Events

local function HandleInput(input, gameProcessed)
    if gameProcessed then return end
    
    -- Add your special attack input handling here
    -- Example:
    -- if input.KeyCode == Enum.KeyCode.Q then
    --     Events.SpecialAttack:FireServer("SpecialMove1")
    -- end
end

UserInputService.InputBegan:Connect(HandleInput)