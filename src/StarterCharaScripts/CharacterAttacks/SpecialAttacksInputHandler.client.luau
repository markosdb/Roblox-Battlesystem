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

-- Prefer keeping templates outside the script so Rojo doesn't wipe them.
-- Place 'AttackTemplate' under the CharacterAttacks folder (script.Parent),
-- not as a child of this LocalScript. We'll still fallback to script child if present.
local AttackTemplate = script.Parent:FindFirstChild("AttackTemplate") or script:FindFirstChild("AttackTemplate")
if not AttackTemplate then
	warn("[SpecialAttacksInputHandler] AttackTemplate not found as sibling or child. Add it under CharacterAttacks (preferred) or under the script.")
end



