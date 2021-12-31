local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage").Common
local StageStore = require(ReplicatedStorage:WaitForChild("StageStore"))

local function leaderboardSetup(player)
	local leaderstats = Instance.new("Folder")
	leaderstats.Name = "leaderstats"
	leaderstats.Parent = player

    local stage = Instance.new("IntValue")
    stage.Name = "Stage"
    stage.Value = StageStore.getMaxStage(player)
    stage.Parent = leaderstats
end

-- Connect the "leaderboardSetup()" function to the "PlayerAdded" event
Players.PlayerAdded:Connect(leaderboardSetup)