local Cell = {}
local DIRECTION = {TOP = 1, RIGHT = 2, BOTTOM = 3, LEFT = 4}

function Cell:new (x, y)
    if not x or not y then
        error("x and y parameters are required")
    end

    local o = {
        position = {x, y},
        visited = false,
        walls = {true, true, true, true} -- top, right, bottom, left
    }
    setmetatable(o, self)
    self.__index = self
    return o
end

function Cell:visit()
    self.visited = true
end

function Cell:removeWall (wall)
    self.walls[wall] = false
end

function Cell:removeWallBetween(neighbor)
    local relativePosition = self:getRelativePosition(neighbor)
    if relativePosition == DIRECTION.TOP then
        self:removeWall(DIRECTION.BOTTOM)
        neighbor:removeWall(DIRECTION.TOP)
    elseif relativePosition == DIRECTION.RIGHT then
        self:removeWall(DIRECTION.LEFT)
        neighbor:removeWall(DIRECTION.RIGHT)
    elseif relativePosition == DIRECTION.BOTTOM then
        self:removeWall(DIRECTION.TOP)
        neighbor:removeWall(DIRECTION.BOTTOM)
    elseif relativePosition == DIRECTION.LEFT then
        self:removeWall(DIRECTION.RIGHT)
        neighbor:removeWall(DIRECTION.LEFT)
    end
end


-- 좌표 기준은 canvas와 같다. (-x → +x, -y ↓ +y)
-- https://www.w3schools.com/graphics/canvas_coordinates.asp
function Cell:getRelativePosition(neighbor)
    local dx = self.position[1] - neighbor.position[1]
    local dy = self.position[2] - neighbor.position[2]

    if dy == -1 then
        return DIRECTION.TOP
    elseif dx == 1 then
        return DIRECTION.RIGHT
    elseif dy == 1 then
        return DIRECTION.BOTTOM
    elseif dx == -1 then
        return DIRECTION.LEFT
    end
end

return Cell