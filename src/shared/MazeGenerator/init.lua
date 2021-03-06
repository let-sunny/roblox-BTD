local Maze = require(script.Maze)
local Draw = require(script.Draw)


return function(count, size, exitCount)
    local maze = Maze:new(count)
    local cells = maze:generate()
    local draw = Draw:new(size)
    draw:draw(cells, exitCount)
end
