local Draw = {}
local WALL_UNIT_POSITION = {Vector3.new(0, 0, 1), Vector3.new(-1, 0, 0), Vector3.new(0, 0, -1), Vector3.new(1, 0, 0)}

function Draw.getWallTemplate()
	local template = Instance.new("Part", game.Workspace)
	template.Name = "WallTemplate"
	template.Position = Vector3.new(0, -100, 0)
	template.BrickColor = BrickColor.new("Pastel blue-green")
	template.Material = Enum.Material.Glass
	template.Anchored = true

	return template
end

function Draw.getCellTemplate()
	local template = Instance.new("Model", game.Workspace)
	template.Name = "CellTemplate"
	return template
end

function Draw.getMazeModel()
	local template = Instance.new("Model", game.Workspace)
	template.Name = "MazeModel"
	return template
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
		wallSize = Vector3.new(cellSize, 20, 2),
		wallTemplate = Draw.getWallTemplate(),
		cellTemplate = Draw.getCellTemplate(),
		mazeModel = Draw.getMazeModel(),
	}
	setmetatable(o, self)
	self.__index = self

	game.Workspace:WaitForChild("MazeModel")
	game.Workspace:WaitForChild("WallTemplate")
	game.Workspace:WaitForChild("CellTemplate")

	return o
end


function Draw:draw(cells, exitCount)
    self:createMaze(cells)
    self:cresteExit(exitCount)
end

function Draw:createMaze(cells)
	local cellCount = #cells
	for i = 1, cellCount do
		for j = 1, cellCount do
			local walls = cells[i][j].walls
			local cell = self.cellTemplate:Clone()
			cell.Name = "Cell"
			cell.Parent = self.mazeModel
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
			local wall = self.wallTemplate:Clone()
			wall.Name = "Wall"
			wall.Parent = parent
			wall.Position = self:getTransformationCoordinate(WALL_UNIT_POSITION[i], mazeSize, parentPosition)
			wall.Size = self.wallSize

			if i % 2 == 0 then -- { top, right, bottom, left }
				wall.CFrame = CFrame.new(wall.Position) * CFrame.Angles(0, math.rad(90), 0)
			end
		end
	end
end

function Draw:createExit(exitCount)
    -- 출구 정해진 숫자만큼 생성
    -- 일정 시간뒤 랜덤하게 위치 이동
end


return Draw