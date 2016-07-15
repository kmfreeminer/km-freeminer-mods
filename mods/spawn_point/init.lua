local spawn_position = nil

minetest.register_on_respawnplayer(function(player)
    if spawn_position then
        player:setpos(spawn_position)
        return true
    end
end)

minetest.register_privilege("setspawn", {
    description = "Даёт доступ к команде /setspawn", 
    give_to_singleplayer = true
})

minetest.register_chatcommand("setspawn", {
    privs = { setspawn=true },
    description = "Устанавливает точку респавна",
    func = function(username, _)
        local player = minetest.get_player_by_name(username)
        spawn_position = player:getpos()
    end
})

-- Spawnpoint file
local FILENAME = minetest.get_modpath("spawn_point") .. "/spawnpoint"

-- Load spawnpoint
local file = io.open(FILENAME, "r")
if file then
    spawn_position = minetest.deserialize(file:read("*all"))
    file:close()
end

-- Save spawnpoint
minetest.register_on_shutdown(function()
    if spawn_position then
        local file = io.open(FILENAME, "w")
        file:write(minetest.serialize(spawn_position))
        file:close()
    end
end)
