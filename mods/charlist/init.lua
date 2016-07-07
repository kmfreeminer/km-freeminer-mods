database = dofile(minetest.get_modpath("charlist") .. "/database.lua")
assert(database.init({
    ["type"] = "sqlite",
    ["path"] = minetest.get_modpath("charlist") .. "/database.sqlite"
}))

charlist = {}

minetest.register_privilege("gm", {
    description = "Мастерская привелегия"
})

charlist.data = {}

local function update_nametag(username)
    local player = minetest.get_player_by_name(username)
    player:set_nametag_attributes({
        color = charlist.get_color(username),
        text = charlist.get_visible_name(username)
    })
end

local function get_active_character(username) 
    return database.find("characters", {["username"] = username, ["active"] = 1}, 1)();
end

-- Quenta
-- {{
function charlist.find_name_owners(name)
    local characters = database.find("characters", 
        { 
            ["OR"] = {
                ["name"] = name, 
                ["visible_name"] = name
            }, 
            ["active"] = 1
        });

    local owners = {}
    for character in characters do
        table.insert(owners, character.username)
    end
        
    if #owners <= 0 then
        return nil
    end
    
    return owners
end

function charlist.set_visible_name(username, visible_name)

end

function charlist.get_visible_name(username)
    local character = get_active_character(username) or {}
    return character.visible_name
end

function charlist.get_real_name(username)
    local character = get_active_character(username) or {}
    return character.name
end

function charlist.get_quenta(username)
    local character = get_active_character(username) or {}
    return character.quenta
end
-- }}

-- Skills
-- {{
function charlist.get_skill_table(username)
    local character = get_active_character(username)
    if not character then
        return {}
    end
    
    local skills = database.find("skills", {["character_id"] = character.id})

    local skill_table = {}
    for skill in skills do
        skill_table[skill.name] = skill.level
    end
    
    return skill_table
end

function charlist.get_skill_level(username, skill_name)
    local character = get_active_character(username)
    if not character then
        return nil
    end
    
    return database.find("skills", {["character_id"] = character.id, ["name"] = skill_name}, 1)()
end
-- }}

-- Color
-- {{
charlist.data.colors = {}

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
    local players = minetest.get_connected_players();
    for username, occupied_color in pairs(charlist.data.colors) do
        if occupied_color == color then
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

function charlist.get_free_random_color()
    local free_colors = get_free_colors()
    
    if #free_colors <= 0 then
        print("TODO")
        --TODO: add trully random color
    end
    
    return free_colors[math.random(1, #free_colors)]
end

function charlist.get_color(username)
    return charlist.data.colors[username]
end

-- identifier is username for players 
function charlist.set_color(identifier, color)
    charlist.data.colors[identifier] = color
end
-- }}

-- On join and on leave actions
-- {{
minetest.register_on_prejoinplayer(function(username, ip)
end)

minetest.register_on_joinplayer(function(player)  
    local username = player:get_player_name()
    charlist.set_color(username, charlist.get_free_random_color())
    
    update_nametag(username)
end)

-- Clear user on leave
minetest.register_on_leaveplayer(function(player)
    local username = player:get_player_name()

    charlist.set_color(username, nil)
end)
-- }}

minetest.register_on_shutdown(function()
    database.stop()
end)
