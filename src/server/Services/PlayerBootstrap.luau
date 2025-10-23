local Players = game:GetService("Players")

local function ensureDefaults(player)
	-- Ensure 'Values' folder
	local values = player:FindFirstChild("Values")
	if not values then
		values = Instance.new("Folder")
		values.Name = "Values"
		values.Parent = player
	end

	-- Ensure 'PunchCombo' IntValue (default 1)
	local punchCombo = values:FindFirstChild("PunchCombo")
	if punchCombo and not punchCombo:IsA("IntValue") then
		punchCombo:Destroy()
		punchCombo = nil
	end
	if not punchCombo then
		punchCombo = Instance.new("IntValue")
		punchCombo.Name = "PunchCombo"
		punchCombo.Value = 1
		punchCombo.Parent = values
	end

	-- Ensure 'Character' StringValue (default empty)
	local characterValue = values:FindFirstChild("Character")
	if characterValue and not characterValue:IsA("StringValue") then
		characterValue:Destroy()
		characterValue = nil
	end
	if not characterValue then
		characterValue = Instance.new("StringValue")
		characterValue.Name = "Character"
		characterValue.Value = ""
		characterValue.Parent = values
	end
end

-- Bootstrap existing players (e.g., when requiring after some joins)
for _, p in Players:GetPlayers() do
	task.spawn(ensureDefaults, p)
end

-- Hook for future joins
Players.PlayerAdded:Connect(ensureDefaults)

return {}