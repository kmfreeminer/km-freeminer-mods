local database = {}

function database_init()
    local env = require("luasql.sqlite3").sqlite3()
    database.connection = env:connect(minetest.get_modpath("charlist") .. "/database.sqlite")
    
    database.connection:execute([[
        CREATE TABLE characters ( 
            id                   integer NOT NULL  ,
            username             char(100) NOT NULL  ,
            name                 varchar(100) NOT NULL  ,
            visible_name         varchar(100)   ,
            quenta               text   , active integer   NOT NULL DEFAULT 0,
            CONSTRAINT Pk_characters PRIMARY KEY ( id )
        );
    ]])
    
    database.connection:execute([[
        CREATE TABLE skills ( 
            id                   integer NOT NULL  ,
            character_id         integer NOT NULL  ,
            name                 varchar(100) NOT NULL  ,
            level                varchar(100) NOT NULL  ,
            CONSTRAINT Pk_skills PRIMARY KEY ( id ),
            FOREIGN KEY ( character_id ) REFERENCES characters( id )  
        );
    ]])
    
    database.connection:execute([[
        CREATE INDEX idx_skills ON skills ( character_id );
    ]])

end

if pcall(database_init) then    
    function database.execute(sql, ...)
        local tmp
        
        tmp = {}
        for _, binding in pairs({...}) do
            table.insert(tmp, database.connection:escape(binding))
        end
        
        sql = string.format(sql, unpack(tmp))
        
        local cursor = database.connection:execute(sql)
        
        tmp = {}
        local data
        repeat
            data = cursor:fetch({}, "a")
            table.insert(tmp, data)
        until not data
        
        local i = 0
        return function()
            i = i + 1
            return tmp[i]
        end
    end
    
    function database.stop()
        database.connection:close()
    end
else
    function database.prepare() end
    
    function database.execute()
        return function()
            return {}
        end
    end
    
    function database.stop() end
end

charlist = {}

minetest.register_privilege("gm", {
    description = "Мастерская привелегия"
})

charlist.data = {}

local function update_nametag(username)
    local player = minetest.get_player_by_name(username)
    local name = username or charlist.get_real_name(username) or charlist.get_visible_name(username)
    player:set_nametag_attributes({
        color = charlist.get_color(username),
        text = name
    })
end

-- Quenta
-- {{
function charlist.find_name_owners(name)
    local characters = database.execute([[
        SELECT * FROM `characters` AS `character` 
        WHERE (`character`.`name`='%s' OR `character`.`name`='%s') 
        AND `character`.`active` = 1;
    ]], name, name)

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
    database.execute([[
        UPDATE `characters` AS `character` 
        WHERE `character`.`username`='%s' 
        SET `character`.`visible_name`='%s'
        LIMIT 1;
    ]], username, visible_name)
    update_nametag(username)
end

local function get_active_character(username) 
    return database.execute([[
        SELECT * FROM `characters` AS `character` 
        WHERE `character`.`username`='%s' LIMIT 1;
    ]], username)()
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
    local skills = database.execute([[
        SELECT `character`.`username`, `skill`.`name`, `skill`.`level` 
        FROM `skills` AS `skill`
        INNER JOIN `characters` AS `character`
            ON (`skill`.`character_id` = `character`.`id`) 
            WHERE `character`.`username` = '%s';
    ]], username)

    local skill_table = {}
    for skill in skills do
        skill_table[skill.name] = skill.level
    end

    return skill_table
end

function charlist.get_skill_level(username, skill_name)
    local tmp = database.execute([[
        SELECT `character`.`username`, `skill`.`name`, `skill`.`level` 
        FROM `skills` AS `skill`
        INNER JOIN `characters` AS `character`
            ON (`skill`.`character_id` = `character`.`id`) 
            WHERE 
                `character`.`username` = '%s' AND
                `skill`.`name` = '%s'
        LIMIT 1;
    ]], username, skill_name)()
    return tmp.level
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

function charlist.set_color(username, color)
    charlist.data.colors[username] = color
    update_nametag(username)
end
-- }}

-- On join and on leave actions
-- {{
minetest.register_on_prejoinplayer(function(username, ip)
end)

minetest.register_on_joinplayer(function(player)  
    local username = player:get_player_name()
    charlist.set_color(username, charlist.get_free_random_color())
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
