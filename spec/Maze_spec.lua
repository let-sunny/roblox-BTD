local Maze = {}
describe("[MazeGenerator > Maze]  \n", function()
    setup(function()
        _G._TEST = true
        Maze = require("Maze")
    end)

    teardown(function()
        _G._TEST = nil
    end)

    describe("[Initialaize]  \n", function()
        it("생성 시 인자 전달 못받으면 오류가 난다.", function()
            assert.has_error(function()
                Maze:new()
            end)
        end)

        it("전달 받은 크기만큼 셀을 생성한다.", function()
            local size = 3;
            local maze = Maze:new(size)

            assert.are.same(size, #maze.cells)
            for i = 1, #maze.cells do
                assert.are.same(size, #maze.cells[i])
            end
        end)
    end)

    describe("[Method]  \n", function()
        local function shallowCopy(target)
            local copy
            if type(target) == "table" then
                copy = {}
                for key, value in pairs(target) do
                copy[key] = value
                end
            else -- number, string, boolean, etc
                copy = target
            end
            return copy
        end

        describe("getUnvisitedNeighbors: 방문하지 않은 인접 셀을 반환한다.", function()
            local maze = Maze:new(3)
            assert.are.same(4, #maze:getUnvisitedNeighbors(maze.cells[2][2]))
            assert.are.same(2, #maze:getUnvisitedNeighbors(maze.cells[1][1]))

            it("getUnvisitedNeighbors: 방문한 인접 셀 제외된다.", function()
                maze.cells[2][3]:visit()
                assert.are.same(3, #maze:getUnvisitedNeighbors(maze.cells[2][2]))
            end)
        end)

        it("generate: 모든 셀을 방문한다", function()
            local maze = Maze:new(3)
            local cells = maze:generate()

            for i = 1, #cells do
                for j = 1, #cells[i] do
                    assert.is_true(cells[i][j].visited)
                end
            end
        end)
    end)
end)