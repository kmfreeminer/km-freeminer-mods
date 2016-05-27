charlist = {}

-- CONFIG-ZONE
-- {{
charlist.user_get_url = "127.0.0.1/users/{{username}}"
charlist.data_folder = minetest.get_modpath("charlist").."/data/"
--}}

charlist.data = {}

local httpenv = core.request_http_api()

dofile(minetest.get_modpath("charlist").."/data.lua")
dofile(minetest.get_modpath("charlist").."/api.lua")

--dofile(minetest.get_modpath("charlist").."quenta.lua")
--dofile(minetest.get_modpath("charlist").."skills.lua")
--dofile(minetest.get_modpath("charlist").."wounds.lua")

-- Load data from server on join
minetest.register_on_joinplayer(function(player)
    local username = player:get_player_name()    
    charlist.load_data(httpenv, username)
end)

-- Clear user on leave
minetest.register_on_leaveplayer(function(player)
    local username = player:get_player_name()
    charlist.save_data(username, charlist.data[username])
end)

