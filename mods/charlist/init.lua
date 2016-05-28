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

-- Quenta
-- {{
function charlist.find_name_owners(name)
    local usernames = {}
    for username, data in pairs(charlist.data[username]) do
        if string.match(data.name,          "^" .. name .. " %[.*%]") 
        or string.match(data.visible_name , "^" .. name .. " %[.*%]") then
            table.insert(tmp, username)
        end
        
    end
    return usernames
end

function charlist.set_visible_name(username, visible_name)
    assert(type(charlist.data[username]) == "table")
    charlist.data[username].visible_name = visible_name
end

function charlist.get_visible_name(username)
    assert(type(charlist.data[username]) == "table")
    return charlist.data[username].visible_name
end

function charlist.get_real_name(username)
    assert(type(charlist.data[username]) == "table")
    return charlist.data[username].name
end

function charlist.get_color(username)
    assert(type(charlist.data[username]) == "table")
    return charlist.data[username].color
end

function charlist.get_quenta(username)
    assert(type(charlist.data[username]) == "table")
    return charlist.data[username].color
end
-- }}

-- Skills
-- {{
function charlist.get_skill_table(username)
    if type(charlist.data[username].skills) == "table" then
        return charlist.data[username].skills    
    else
        return nil
    end
end

function charlist.get_skill_level(username, skill_name)
    assert(type(charlist.data[username].skills) == "table")
    
    local fudge_level = nil 
    
    if charlist.data[username].skills[skill_name] then
        fudge_level = charlist.data[username].skills[skill_name]
    end
    
    if not fudge_level then
        return nil
    end
    
    return fudge_level
end
-- }}

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

