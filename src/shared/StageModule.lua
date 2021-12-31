local ReplicatedStorage = game:GetService("ReplicatedStorage").Common

local StageStore = require(ReplicatedStorage:WaitForChild("StageStore"))
local TeleportModule = require(ReplicatedStorage:WaitForChild("TeleportModule"))

local StageModule = {}
local PLACE_IDS = {
    8338771649,
    8354626769,
    8359709186,
}

local function neededTeleport(stage)
    return stage == 1 or stage == 2
end

function StageModule.stageClear(player, clearedStage)
    local stageClearEvent = Instance.new("RemoteEvent")
	stageClearEvent.Name = "StageClearEvent"
	stageClearEvent.Parent = ReplicatedStorage

    local stage = clearedStage + 1
    StageStore.setMaxStage(player, clearedStage + 1)

    if neededTeleport(clearedStage) and not player:GetAttribute("Teleporting") then
		player:SetAttribute("Teleporting", true)

		-- Teleport the player
        TeleportModule.teleportBetweenPlaces(PLACE_IDS[stage], { player })

		player:SetAttribute("Teleporting", nil)
	end
end

return StageModule