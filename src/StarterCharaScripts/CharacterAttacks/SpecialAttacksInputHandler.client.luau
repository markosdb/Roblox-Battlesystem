local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Events = ReplicatedStorage:WaitForChild("Events")

local Character = script.Parent.Parent

local Player = Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")
local MainGui = PlayerGui:WaitForChild("MainGui")
local Attacks = MainGui.Attacks
local AttackTemplate = Attacks.AttackTemplate

local SharedModules = ReplicatedStorage:WaitForChild("SharedModules")
local Configurations = SharedModules.Configurations

local CharacterConfigurations = require(Configurations.CharacterConfigurations)

local EquippedCharacterName = nil -- This should be set based on the player's equipped character

local function UseSpecialAttack(AttackNumber)
    if EquippedCharacterName == nil then return end
    
    local Result = Events.UseSpecialAttack:InvokeServer(AttackNumber)

    if Result == true then
        local AttackData = nil
        for _, v in CharacterConfigurations do
            if v.CharacterName == EquippedCharacterName then
                AttackData = v.Attacks[AttackNumber]
                break
            end
            local AttackTemplate = Attacks[tostring(AttackNumber)]
            AttackTemplate.DebounceFrame.Size = UDim2.fromScale(1, 1)
            TweenService:Create(AttackTemplate.DebounceFrame, TweenInfo.new(AttackData.AttackDebounce), {Size = UDim2.fromScale(1, 0)}):Play()
        end
    end
end

UserInputService.InputBegan:Connect(function(Input, GameProcessedEvent)
    if GameProcessedEvent or EquippedCharacterName == nil then return end
    if Input.KeyCode == Enum.KeyCode.One then
        UseSpecialAttack(1)
    end
    if Input.KeyCode == Enum.KeyCode.Two then
        UseSpecialAttack(2)
    end
    if Input.KeyCode == Enum.KeyCode.Three then
        UseSpecialAttack(3)
    end
    if Input.KeyCode == Enum.KeyCode.Four then
        UseSpecialAttack(4)
    end
end)

Events.EquipCharacterClient.OnClientEvent:Connect(function(CharacterData)
    EquippedCharacterName = CharacterData.CharacterName
    for i, v in CharacterData.Attacks do
        local NewTemplate = AttackTemplate:Clone()
        NewTemplate.Name = tostring(i)
        NewTemplate.Number.Text = tostring(i)
        NewTemplate.AttackName.Text = v.AttackName
        NewTemplate.Visible = true
        NewTemplate.DebounceFrame.Size = UDim2.fromScale(1, 0)
        NewTemplate.Parent = Attacks
    end
end)