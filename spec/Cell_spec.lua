local Cell = require("Cell")

describe("[MazeGenerator > Cell] \n", function()
    describe("[Initialaize] \n", function()
        local cell

        setup(function()
            cell = Cell:new(1, 2)
        end)

        teardown(function()
            cell = nil
        end)

        it("생성 시 인자 전달 못받으면 오류가 난다.", function()
            assert.has_error(function()
                Cell:new()
            end)
        end)

        it("전달 받은 위치 정보가 저장된다.", function()
            assert.are.same(1, cell.position[1])
            assert.are.same(2, cell.position[2])
        end)

        it("방문여부가 false로 초기화 된다.", function()
            assert.is_false(cell.visited)
        end)

        it("cell의 벽은 총 4개다. (top, right, bottom, left)", function()
            assert.are.same(4, #cell.walls)
        end)

        it("cell의 각벽의 노출여부가 true로 초기화 된다.", function()
            assert.are.same(4, #cell.walls)
            assert.is_true(cell.walls[1])
            assert.is_true(cell.walls[2])
            assert.is_true(cell.walls[3])
            assert.is_true(cell.walls[4])
        end)
    end)

    describe("[Method] \n", function()
        it("visit: 방문 여부가 true 된다.", function()
            local cell = Cell:new(2, 2);
            assert.is_false(cell.visited)

            cell:visit()
            assert.is_true(cell.visited)
        end)

        it("removeWall: 선택한 벽의 노출여부가 false 된다.", function()
            local cell = Cell:new(2, 2);
            for i = 1, #cell.walls do
                assert.is_true(cell.walls[i])
                cell:removeWall(i)
                assert.is_false(cell.walls[i])
            end
        end)


        describe("removeWallBetween: 인자로 받은 cell이 인접하다면, 사이에 있는 벽 노출정보가 false 된다.", function()
            -- 좌표 기준은 canvas와 같다. (-x → +x, -y ↓ +y)
            -- https://www.w3schools.com/graphics/canvas_coordinates.asp
            local current

            teardown(function()
                current = nil
            end)

            before_each(function()
                current = Cell:new(2, 2);

                for i = 1, #current.walls do
                    assert.is_true(current.walls[i])
                end
            end)

            it("현재 cell이 위: 현재 셀의 아래벽과, 이웃셀 윗벽 노출여부가 false 된다.", function()
                local neighbor = Cell:new(2, 3);

                current:removeWallBetween(neighbor)
                assert.is_false(current.walls[3])
                assert.is_false(neighbor.walls[1])
            end)


            it("현재 cell이 우측: 현재 셀의 좌측벽과, 이웃셀 우측벽 노출여부가 false 된다.", function()
                local neighbor = Cell:new(1, 2);

                current:removeWallBetween(neighbor)
                assert.is_false(current.walls[4])
                assert.is_false(neighbor.walls[2])
            end)

            it("현재 cell이 아래: 현재 셀의 윗벽과, 이웃셀 아래벽 노출여부가 false 된다.", function()
                local neighbor = Cell:new(2, 1);

                current:removeWallBetween(neighbor)
                assert.is_false(current.walls[1])
                assert.is_false(neighbor.walls[3])
            end)

            it("현재 cell이 좌측: 현재 셀의 우측벽과, 이웃셀 좌측벽 노출여부가 false 된다.", function()
                local neighbor = Cell:new(3, 2);

                current:removeWallBetween(neighbor)
                assert.is_false(current.walls[2])
                assert.is_false(neighbor.walls[4])
            end)

            it("인접하지 않은 경우: 노출여부 변화 없다.", function()
                local neighbor = Cell:new(6, 6);
                current:removeWallBetween(neighbor)
                for i = 1, #current.walls do
                    assert.is_true(current.walls[i])
                    assert.is_true(neighbor.walls[i])
                end
            end)
        end)
    end)
end)