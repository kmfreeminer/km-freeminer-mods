local database = {}

function database_init()
    local env = require("luasql.sqlite3").sqlite3()
    database.connection = env:connect(minetest.get_modpath("charlist") .. "/database.sqlite")
end

if pcall(database_init) then    
    function database.execute(sql, ...)
        local tmp
        
        -- Escape arguments
        tmp = {}
        for _, binding in pairs({...}) do
            table.insert(tmp, database.connection:escape(binding))
        end
        
        sql = string.format(sql, unpack(tmp))
        local cursor = database.connection:execute(sql)
        
        -- Fetch data and close cursor
        tmp = {}
        if cursor then
            local data
            repeat
                data = cursor:fetch({}, "a")
                table.insert(tmp, data)
            until not data
        end
        
        -- Return iterator
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
charlist.data = {}

local function update_nametag(username)
    local player = minetest.get_player_by_name(username)
    local active_character = charlist.get_active_character(username)
    player:set_nametag_attributes({
        color = "#" .. charlist.get_color(username),
        text = active_character.visible_name or active_character.real_name or username
    })
end

-- Quenta
-- {{
function charlist.find_name_owners(name)
    local users = database.execute([[
        SELECT `user`.`username` FROM `users` as `user`
        INNER JOIN `characters` as `character` 
            ON (`user`.`id` = `character`.`user_id`)  
        WHERE 
            `character`.`real_name`    = '%s' OR 
            `character`.`visible_name` = '%s';
    ]], name, name)
    
    local owners = {}
    for character in users do
        table.insert(owners, character.username)
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

function charlist.get_active_character(username) 
    return database.execute([[
        SELECT 
            `character`.`real_name`    AS `real_name`,
            `character`.`visible_name` AS `visible_name`,
            `character`.`age`          AS `age`,
            `character`.`appearance`   AS `appearance`, 
            `character`.`quenta`       AS `quenta`, 
            `class`.`title`            AS `class`,
            `class`.`id`               AS `class_id`,
            `race`.`title`             AS `race`,
            `race`.`id`                AS `race_id`,
            `sex`.`title`              AS `sex`,
            `sex`.`id`                 AS `sex_id`

        FROM characters AS character
        INNER JOIN users      AS user
            ON (`character`.`user_id` = `user`.`id`)

        INNER JOIN `sexes`    AS `sex`
            ON (`character`.`sex` = `sex`.`id`)

        INNER JOIN `races`    AS `race`
            ON (`character`.`race` = `race`.`id`)

        INNER JOIN ch_classes AS class
            ON (`character`.`class` = `class`.`id`)
        WHERE
            `user`.`username` = '%s' AND
            (class.id = 20 OR class.id = -10)
        LIMIT 1;
    ]], username)() or {}
end
-- }}

-- Skills
-- {{
function charlist.get_skill_table(username)
    local skills = database.execute([[
        SELECT `skill`.`name`, `skill`.`level`
        FROM `skills` as `skill`
        INNER JOIN `characters` AS `character`
            ON (`skill`.`character_id` = `character`.`id`)  
        INNER JOIN `users` AS `user`
            ON (`character`.`user_id` = `user`.`id`)  
        WHERE `user`.`username` = '%s';
    ]], username)

    local skill_table = {}
    for skill in skills do
        skill_table[skill.name] = skill.level
    end

    return skill_table
end

function charlist.get_skill_level(username, skill_name)
    local skill = database.execute([[
        SELECT `skill`.`level`
        FROM `skills` as `skill`
            INNER JOIN `characters` AS `character`
                ON (`skill`.`character_id` = `character`.`id`)  
            INNER JOIN `users` AS `user`
                ON (`character`.`user_id` = `user`.`id`)  
        WHERE `user`.`username` = '%s'
        LIMIT 1;
    ]], username, skill_name)() or {}
    return skill.level
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
    if color ~= nil then
        update_nametag(username)
    end
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

minetest.register_privilege("whois", {
    description = "Даёт доступ к команде /whois", 
    give_to_singleplayer = true
})

minetest.register_chatcommand("whois", {
    params = "<name>",
    privs = { whois=true },
    description = "Позволяет узнать кто скрывается за указаным именем.",
    func = function(username, param)
        local result = ""
        for _, name in pairs(charlist.find_name_owners(param)) do
            local color = charlist.get_color(name)
            result = result .. name .. ": "
            result = result .. core.colorize(color or "FFFFFF", color or "OFFLINE") .. "\n"
        end
        minetest.chat_send_player(username, result)
    end
})

-- TESTING
if minetest.setting_get("development") and minetest.setting_getbool("development") == true then
    minetest.register_chatcommand("charlist_test", {
        func = function(username, param)
            print("\n=== charlist.find_name_owners test ===")
            print("(\"sad\") name_owners: " .. dump(charlist.find_name_owners("sad")))

            print("\n=== get_active_character test ===")
            print("active_character: " .. dump(charlist.get_active_character(username)))

            print("\n=== skills test ===")
            print("skill_table: " .. dump(charlist.get_skill_table(username)))
            print("skill_level: " .. dump(charlist.get_skill_level(username, "test")))
        end
    })
end
