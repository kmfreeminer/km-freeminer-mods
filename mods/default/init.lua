MAP_GENERATION_LIMIT=31000

-- Definitions made by this mod that other mods can use too
default = {}
default.LIGHT_MAX = 14
default.weather = core.setting_getbool("weather")
if default.weather == 0 then default.weather = nil end

-- Nametag
default.nametag_alpha = 100

-- Load files
dofile(minetest.get_modpath("default").."/functions.lua")
dofile(minetest.get_modpath("default").."/nodes.lua")
dofile(minetest.get_modpath("default").."/tools.lua")
dofile(minetest.get_modpath("default").."/craftitems.lua")
dofile(minetest.get_modpath("default").."/crafting.lua")
dofile(minetest.get_modpath("default").."/mapgen.lua")
dofile(minetest.get_modpath("default").."/player.lua")
dofile(minetest.get_modpath("default").."/trees.lua")
dofile(minetest.get_modpath("default").."/aliases.lua")

-- Test Item for C-Ann
minetest.register_craftitem("default:test", {
    description = "Hello, C-Ann!",
})
