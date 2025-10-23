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

local function getCharacterData(name: string)
    for _, v in CharacterConfigurations do
        if v.CharacterName == name then
            return v
        end
    end
    return nil
end

local EquippedCharacterName: string? = nil

local function UseSpecialAttack(AttackNumber: number)
    if not EquippedCharacterName then return end

    local result = Events.SpecialAttack:InvokeServer(AttackNumber)
    if result ~= true then
        return
    end

    local charData = getCharacterData(EquippedCharacterName)
    if not charData then return end
    local info = charData.Attacks[AttackNumber]
    if not info then return end

    local slot = Attacks:FindFirstChild(tostring(AttackNumber))
    if not slot then return end
    slot.DebounceFrame.Size = UDim2.fromScale(1, 1)
    TweenService:Create(slot.DebounceFrame, TweenInfo.new(info.AttackDebounce), { Size = UDim2.fromScale(1, 0) }):Play()
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