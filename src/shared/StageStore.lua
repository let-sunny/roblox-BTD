local DataStoreService = game:GetService("DataStoreService")
local Store = DataStoreService:GetDataStore("PlayerStage")
local StageStore = {}

local function getStageStatus(player)
    local success, stageStatus = pcall(function()
        return Store:GetAsync(player.UserId)
    end)

    if success then
        return stageStatus
    else
        print("Loading stage status failed: " .. player.UserId)
        return {
            maxStage = 1
        }
    end
end

local function setStageStore(player, stageStatus)
    local success, errorMessage = pcall(function()
        Store:SetAsync(player.UserId, stageStatus)
    end)

    if not success then
        print("Saving stage status failed: " .. player.UserId)
        print(errorMessage)
    end
end

function StageStore.getMaxStage(player)
    return getStageStatus(player).maxStage
end

function StageStore.setMaxStage(player, stage)
    local stageStatus = getStageStatus(player)

    if (not stageStatus.maxStage or stage > stageStatus.maxStage) then
        stageStatus.maxStage = stage
        setStageStore(player, stageStatus)
    end
end

return StageStore