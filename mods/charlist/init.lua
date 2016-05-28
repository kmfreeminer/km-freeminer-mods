charlist = {}

-- CONFIG-ZONE
-- {{
charlist.user_get_url = "127.0.0.1/users/{{username}}"
charlist.data_folder = minetest.get_modpath("charlist").."/data/"
--}}

charlist.data = {}

local httpenv = core.request_http_api()
if not httpenv then
    minetest.log("error", "Unable to get HTTPApiTable, maybe you should add secure.trusted_mods = roleplay or secure.http_mods = roleplay to your .conf file.")
end

if require("lfs") then
    lfs.mkdir(charlist.data_folder)
else
    minetest.log("error", "Unable to get lfs, install lfs for lua5.1 or create " .. charlist.data_folder .. " folder yourtself.")
end

-- Player data save and load functions
-- {{
-- Data save functions
local function file_save(username, data)
    local storage = io.open(charlist.data_folder .. username, "w")
    storage:write(minetest.serialize(data))
    storage:close()
end

-- Data load functions
local function file_load(username)
    local storage = io.open(charlist.data_folder ..username, "r")
    
    if not storage then
        return nil
    end
    
    local result = minetest.deserialize(storage:read("*all"))
    if type(result) ~= "table" then
        return nil
    end
    
    storage:close()
    
    charlist.data[username] = result
end

-- Server load function
local function server_load(httpenv, username)
    if httpenv then
        local url = string.gsub(charlist.user_get_url, "{{username}}", username)
        httpenv.fetch({ url = url, timeout = 2 }, 
            function(result)
                if result.succeeded then
                    local fetched_data = minetest.parse_json(result.data)
                    if type(fetched_data) == "table" then
                        charlist.data[username]["name"]   = fetched_data["name"]
                        charlist.data[username]["quenta"] = fetched_data["quenta"]
                        charlist.data[username]["skills"] = fetched_data["skills"]
                    end
                end
            end)
    end
end
-- }}

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
    
    charlist.data[username] = {}
    charlist.data[username].skills = {}
    charlist.data[username].wounds = {}

    file_load(username)
    charlist.data[username].color = "AAAAAA"
    server_load(httpenv, username)
end)

-- Clear user on leave
minetest.register_on_leaveplayer(function(player)
    local username = player:get_player_name()
    
    file_save(username, data)
    charlist.data[username] = nil
end)
