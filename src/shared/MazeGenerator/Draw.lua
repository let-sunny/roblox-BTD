local Draw = {}
local WALL_UNIT_POSITION = {Vector3.new(0, 0, 1), Vector3.new(-1, 0, 0), Vector3.new(0, 0, -1), Vector3.new(1, 0, 0)}

-- source: https://developer.roblox.com/en-us/onboarding/deadly-lava/2
local function killerPlayer(otherPart)
    local partParent = otherPart.Parent
    local humanoid = partParent:FindFirstChild("Humanoid")
    if humanoid then
        humanoid.Health = 0
    end
end

function Draw:getTransformationCoordinate(unit, cellCount, parentPosition)
	local std = self.wallSize.X - self.wallSize.Z
	local mazeWidth = (cellCount - 1) * std

	return (unit
            -- 사이즈 변환, 전달 받은 벽 사이즈에 따라 크기 변환
		    * Vector3.new(std / 2, 1, std / 2))
            -- 좌표계 변환, (-x → +x, -y ↓ +y) ==> (+x ← -x, -z ↑ +z)
		    + Vector3.new((cellCount - parentPosition.X) * std, 0, (cellCount - parentPosition.Y) * std)
            -- 중앙 이동
            - Vector3.new(mazeWidth / 2, 0, mazeWidth / 2)
end

function Draw:new(cellSize)
	local o = {
		cellSize = cellSize,
		wallSize = Vector3.new(cellSize, 35, 2),
        templates = game:GetService("ReplicatedStorage").Template.MazeGenerator,
        exits = {},
	}
	setmetatable(o, self)
	self.__index = self

	return o
end

function Draw:draw(cells, exitCount)
    self:initTemplateBlock()
    self:createMaze(cells)
    self:cresteExit(exitCount)
end

function Draw:initTemplateBlock()
    self.templates.Baseplate:Clone().Parent = game.Workspace
    self.templates.SpawnLocation:Clone().Parent = game.Workspace
    self.mazeFrame = self.templates.MazeFrame:Clone()
    self.mazeFrame.Parent = game.Workspace
    self.mazeFrame.Parent:WaitForChild("MazeFrame")
end

function Draw:createMaze(cells)
	local cellCount = #cells
	for i = 1, cellCount do
		for j = 1, cellCount do
			local walls = cells[i][j].walls
			local cell = self.templates.Cell:Clone()
			cell.Name = "Cell"
			cell.Parent = self.mazeFrame
			cell:SetAttribute("index", Vector2.new(i, j))

			cell.Parent:WaitForChild("Cell")
			self:createWalls(cell, walls, cellCount)
		end
	end
end

function Draw:createWalls(parent, walls, mazeSize)
	for i = 1, #walls do
		if walls[i] then
			local parentPosition = parent:GetAttribute("index")
			local wall = self.templates.Wall:Clone()
			wall.Name = "Wall"
			wall.Parent = parent
			wall.Position = self:getTransformationCoordinate(WALL_UNIT_POSITION[i], mazeSize, parentPosition)
			wall.Size = self.wallSize

			if i % 2 == 0 then -- { top, right, bottom, left }
				wall.CFrame = CFrame.new(wall.Position) * CFrame.Angles(0, math.rad(90), 0)
			end

            if math.random(0, 10) == 1 then
                wall.Touched:Connect(killerPlayer)
                wall.BrickColor = BrickColor.new("Bright red")
            end
		end
	end
end

function Draw:cresteExit(exitCount)
    -- 출구 정해진 숫자만큼 생성
    local exits = self.exits
    local cells = self.mazeFrame:getChildren()
    for _ = 1, exitCount do
        local exit = self.templates.Exit:Clone()
        local parent = cells[math.random(1, #cells)]
        exit.Name = "Exit"
        exit.PrimaryPart = exit:FindFirstChild("PrimaryPart")

        -- TODO: stage two 정해지면 경로변경
        Draw.setTeleportPart(exit.PrimaryPart, game:GetService("ReplicatedStorage").Template.StageTwo.SpawnLocation.Position)

        Draw.setModelPosition(exit, parent)
        table.insert(exits, exit)
    end

    -- 일정 시간뒤 랜덤하게 위치 이동
    while Wait(60 * 5) do
        for i = 1, #exits do
            local exit = exits[i]
            local parent = cells[math.random(1, #cells)]
            Draw.setModelPosition(exit, parent)
        end
    end
end

function Draw.setModelPosition(model, parent) 
    local orientation = parent:GetBoundingBox()
    model.Parent = parent
    model:SetPrimaryPartCFrame(orientation + Vector3.new(0, 3, 0))
end

-- TODO: killerPlayer, teleportPart 구조 및 위치 수정
function Draw.setTeleportPart(teleportPart, destination)
    local TELEPORT_FACE_ANGLE = 0
    local FREEZE_CHARACTER = true

    local ReplicatedStorage = game:GetService("ReplicatedStorage").Common
    -- Require teleport module
    local TeleportWithinPlace = require(ReplicatedStorage:WaitForChild("TeleportWithinPlace"))

    local function teleportPlayer(otherPart)
        local character = otherPart.Parent
        local humanoid = character:FindFirstChild("Humanoid")

        if humanoid and not humanoid:GetAttribute("Teleporting") then
            humanoid:SetAttribute("Teleporting", true)

            local params = {
                destination = destination,
                faceAngle = TELEPORT_FACE_ANGLE,
                freeze = FREEZE_CHARACTER
            }
            TeleportWithinPlace.Teleport(humanoid, params)

            wait(1)
            humanoid:SetAttribute("Teleporting", nil)
        end
    end

    teleportPart.Touched:Connect(teleportPlayer)
end



return Draw