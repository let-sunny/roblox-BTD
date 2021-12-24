-- source: https://developer.roblox.com/en-us/articles/How-to-teleport-within-a-Place
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local TeleportWithinPlace = {}

-- Create remote event instance
local teleportEvent = Instance.new("RemoteEvent")
teleportEvent.Name = "TeleportEvent"
teleportEvent.Parent = ReplicatedStorage

function TeleportWithinPlace.Teleport(humanoid, params)
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

return TeleportWithinPlace