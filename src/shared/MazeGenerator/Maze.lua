local Cell = {}
if _TEST then Cell = require("Cell") else Cell = require(script.Parent.Cell) end

local Maze = {}

function Maze.createCells (size)
    local cells = {}
    for i = 1, size do
        cells[i] = {}
        for j = 1, size do
            cells[i][j] = Cell:new(i, j)
        end
    end
    return cells
end

function Maze:new (size)
    if not size then
        error("cellCount is required")
    end

    local o = {
        -- 좌표 기준은 canvas와 같다. (-x → +x, -y ↓ +y)
        -- https://www.w3schools.com/graphics/canvas_coordinates.asp
        cells = Maze.createCells(size)
    }
    setmetatable(o, self)
    self.__index = self

    return o
end

function Maze:generate ()
    -- algorithm: https://en.wikipedia.org/wiki/Maze_generation_algorithm#Iterative_implementation

    -- Choose the initial cell, mark it as visited and push it to the stack
    local first = self.cells[1][1]
    first:visit()
    local stack = {first}

    -- While the stack is not empty
    while #stack > 0 do
        -- Pop a cell from the stack and make it a current cell
        local current = table.remove(stack, #stack)
        local unvisitedNeighbors = self:getUnvisitedNeighbors(current)
        -- If the current cell has any neighbours which have not been visited
        if #unvisitedNeighbors > 0 then
            -- Push the current cell to the stack
            table.insert(stack, current)

            -- Choose one of the unvisited neighbours
            local picked = table.remove(unvisitedNeighbors, math.random(1, #unvisitedNeighbors))
            -- Remove the wall between the current cell and the chosen cell
            current:removeWallBetween(picked)
            -- Mark the chosen cell as visited and push it to the stack
            picked:visit()
            table.insert(stack, picked)
        end
    end

    return self.cells
end

function Maze:getUnvisitedNeighbors(cell)
    local unvisitedNeighbors = {}
    local steps = {{0, -1}, {1, 0}, {0, 1}, {-1, 0}}
    local boundary = {0, #self.cells} -- low, high
    for i = 1, #steps do
        local x = cell.position[1] + steps[i][1]
        local y = cell.position[2] + steps[i][2]

        if x > boundary[1] and x <= boundary[2] and y > boundary[1] and y <= boundary[2] then
            local neighbor = self.cells[x][y]
            if not neighbor.visited then
                table.insert(unvisitedNeighbors, neighbor)
            end
        end
    end
    return unvisitedNeighbors
end

return Maze