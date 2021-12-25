local ReplicatedStorage = game:GetService("ReplicatedStorage")

local TeleportModule = {}

-- source: https://developer.roblox.com/en-us/articles/How-to-teleport-within-a-Place
function TeleportModule.teleportWithinPlace(humanoid, params)
	local Players = game:GetService("Players")

	-- Create remote event instance
	local teleportEvent = Instance.new("RemoteEvent")
	teleportEvent.Name = "TeleportWithinPlaceEvent"
	teleportEvent.Parent = ReplicatedStorage

	local character = humanoid.Parent

	-- Freeze character during teleport if requested
	if params.freeze then
		humanoid:SetAttribute("DefaultWalkSpeed", humanoid.WalkSpeed)
		humanoid:SetAttribute("DefaultJumpPower", humanoid.JumpPower)
		humanoid.WalkSpeed = 0
		humanoid.JumpPower = 0
	end

	-- Calculate height of root part from character base
	local rootPartY
	if humanoid.RigType == Enum.HumanoidRigType.R15 then
		rootPartY = (humanoid.RootPart.Size.Y * 0.5) + humanoid.HipHeight
	else
		rootPartY = (humanoid.RootPart.Size.Y * 0.5) + humanoid.Parent.LeftLeg.Size.Y + humanoid.HipHeight
	end

	-- Teleport player and request content around location if applicable
	local position = CFrame.new(params.destination + Vector3.new(0, rootPartY, 0))
	local orientation = CFrame.Angles(0, math.rad(params.faceAngle), 0)
	if workspace.StreamingEnabled then
		local player = Players:GetPlayerFromCharacter(character)
		player:RequestStreamAroundAsync(params.destination)
	end
	character:SetPrimaryPartCFrame(position * orientation)

	-- Unfreeze character
	if params.freeze then
		humanoid.WalkSpeed = humanoid:GetAttribute("DefaultWalkSpeed")
		humanoid.JumpPower = humanoid:GetAttribute("DefaultJumpPower")
	end
end

-- source: https://developer.roblox.com/en-us/articles/Teleporting-Between-Places
function TeleportModule.teleportBetweenPlaces(targetPlaceID, playersTable, teleportOptions)
	local TeleportService = game:GetService("TeleportService")
	local RETRY_DELAY = 2
	local MAX_WAIT = 10
	-- Create remote event instance
	local teleportEvent = Instance.new("RemoteEvent")
	teleportEvent.Name = "TeleportBetweenPlacesEvent"
	teleportEvent.Parent = ReplicatedStorage

	local currentWait = 0


	-- Show custom teleport screen to valid players if client event is connected
	teleportEvent:FireAllClients(playersTable, true)

	local function doTeleport(players, options)
		if currentWait < MAX_WAIT then
			local success, errorMessage = pcall(function()
				return TeleportService:TeleportAsync(targetPlaceID, players, options)
			end)
			if not success then
				warn(errorMessage)
				-- Retry teleport after defined delay
				wait(RETRY_DELAY)
				currentWait = currentWait + RETRY_DELAY
				doTeleport(players, teleportOptions)
			end
		else
			-- On failure, hide custom teleport screen for remaining valid players
			teleportEvent:FireAllClients(players, false)
			return true
		end
	end

	TeleportService.TeleportInitFailed:Connect(function(player, teleportResult, errorMessage)
		if teleportResult ~= Enum.TeleportResult.Success then
			warn(errorMessage)
			-- Retry teleport after defined delay
			wait(RETRY_DELAY)
			currentWait = currentWait + RETRY_DELAY
			doTeleport({player}, teleportOptions)
		end
	end)

	-- Fire initial teleport
	doTeleport(playersTable, teleportOptions)
end

return TeleportModule