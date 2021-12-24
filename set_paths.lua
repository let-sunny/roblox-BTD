-- set_paths.lua
local version = _VERSION:match("%d+%.%d+")
package.path = 'lua_modules/share/lua/' .. version .. '/?.lua;lua_modules/share/lua/' .. version .. '/?/init.lua;'
                    .. 'src/shared/?/init.lua;' .. 'src/shared/MazeGenerator/?.lua;' .. 'src/shared/?.lua;' .. 'src/shared/?;' .. package.path
package.cpath = 'lua_modules/lib/lua/' .. version .. '/?.so;' .. package.cpath