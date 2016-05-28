charlist = {}

-- CONFIG-ZONE
-- {{
charlist.user_get_url = "127.0.0.1/users/{{username}}"
charlist.data_folder = minetest.get_modpath("charlist").."/data/"
--}}

charlist.data = {}
local dataload = {}

local function update_nametag(username)
    local player = minetest.get_player_by_name(username)
end

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
    update_nametag()
end

function charlist.get_visible_name(username)
    assert(type(charlist.data[username]) == "table")
    return charlist.data[username].visible_name
end

function charlist.get_real_name(username)
    assert(type(charlist.data[username]) == "table")
    return charlist.data[username].name
end

function charlist.get_quenta(username)
    assert(type(charlist.data[username]) == "table")
    return charlist.data[username].color
end
-- }}

-- Color
-- {{
local colors ={}

colors.primary = {
    "E0143C", "E9967A", "FF4500", "FFD700", "B8860B", "7FFF00", "32CD32",
    "90EE90", "00FF7F", "66CDAA", "00FFFF", "E0FFFF", "48D1CC", "5F9EA0", 
    "6495ED", "00BFFF", "1E90FF", "87CEFA", "4169E1", "6A5ACD", "9370DB", 
    "9400D3", "BA55D3", "FF00FF", "C71585", "DB7093", "FF69B4", "D2691E", 
    "CD853F", "F4A460", "DEB887", "BC8F8F", "FFDEAD", "778899", "B0C4DE", 
    "A9A9A9"
}

colors.secondary = {
    "483D8B", "696969", "3030FF", "AA1010", "FF6347", "808000", "F5DEB3", 
    "D8BFD8", "F5F5DC", "EEE8AA", "B0E0E6", "00FA9A", "7FFFD4", "006400", 
    "CD5C5C", "BDB76B", "9ACD32", "228B22", "20B2AA", "2E8B57", "8FBC8F", 
    "008B8B", "4682B4", "8B008B", "DDA0DD", "EE82EE", "FFB6C1", "A0522D"
}

local function find_color_owner(color)
    for username, data in pairs(charlist.data) do
        if data.color == color then
            return username
        end
    end
    return nil
end

local function get_free_colors()
    local color_table = {}
    
    for _, color in pairs(colors.primary) do
        if find_color_owner(color) == nil then
            table.insert(color_table, color)
        end
    end
    
    if #color_table > 0 then
        return color_table
    end
    
    for _, color in pairs(colors.secondary) do
        if find_color_owner(color) == nil then
            table.insert(color_table, color)
        end
    end
    
    return color_table
end

local function get_random_color()
    local free_colors = get_free_colors()
    
    if #free_colors < 0 then
        --TODO: add trully random color
    end
    
    return free_colors[math.random(1, #free_colors)]
end

function charlist.get_color(username)
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

-- Player data save and load functions
-- {{
local httpenv = core.request_http_api()
if not httpenv then
    minetest.log("error", "Unable to get HTTPApiTable, maybe you should add secure.trusted_mods = roleplay or secure.http_mods = roleplay to your .conf file.")
end

if require("lfs") then
    lfs.mkdir(charlist.data_folder)
else
    minetest.log("error", "Unable to get lfs, install lfs for lua5.1 or create " .. charlist.data_folder .. " folder yourtself.")
end

-- Data save functions
function dataload.save_to_file(username, data)
    local storage = io.open(charlist.data_folder .. username, "w")
    storage:write(minetest.serialize(data))
    storage:close()
end

-- Data load functions
function dataload.load_from_file(username)
    local storage = io.open(charlist.data_folder ..username, "r")
    
    if not storage then
        return nil
    end
    
    local result = minetest.deserialize(storage:read("*all"))
    if type(result) ~= "table" then
        return nil
    end
    
    storage:close()
    
    return result
end

-- Server load function
function dataload.load_from_server(httpenv, username)
    if httpenv then
        local url = string.gsub(charlist.user_get_url, "{{username}}", username)
        local handle = httpenv.fetch_async({ url = url, timeout = 2 })
        
        local result = nil
        repeat
            result = httpenv.fetch_async_get(handle)
        until result.completed

        local fetched_data = minetest.parse_json(result.data)
        if result.succeeded and type(fetched_data) == "table" then
            return fetched_data
        end
    end
    return nil
end

-- Load data from server on join
minetest.register_on_prejoinplayer(function(username, ip)    
    charlist.data[username] = {}
    local data = {}
    data.skills = {}
    data.wounds = {}
    
    local fetched_data = dataload.load_from_file(username)
    if fetched_data then
        data = fetched_data
    end
    
    fetched_data = dataload.load_from_server(httpenv, username)
    if fetched_data then
        for key, value in pairs(fetched_data) do
            data[key] = value
        end
    end
    
    charlist.data[username] = data
    charlist.data[username].color = get_random_color()
end)

minetest.register_on_joinplayer(function(player)  
    local username = player:get_player_name()
    update_nametag(username)
end)

-- Clear user on leave
minetest.register_on_leaveplayer(function(player)
    local username = player:get_player_name()
    charlist.data[username].color = nil

    dataload.save_to_file(username, charlist.data[username])
    charlist.data[username] = nil
end)
-- }}
