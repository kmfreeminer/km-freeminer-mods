roleplay.skills = {}
roleplay.skills.data = {}

--function roleplay.skills.set_level(username, skill, level)
    --assert(type(roleplay.skills.data[username]) == "table")
    
    --local stored_skill = roleplay.skills.parse(username, skill)
    --assert(not stored_skill or (exist_skill == skill), string.format("Пересечение названий \"%s\" и \"%s\", невозможно указать этот навык", tmp, skill))

    --roleplay.skills.data[username][skill] = fudge.parse_level(level)
    --roleplay.skills.save()
--end

function roleplay.skills.parse_name(username, text_unparsed)
    assert(type(roleplay.skills.data[username]) == "table")

    for skill, level in pairs(roleplay.skills.data[username]) do
        if string.match(text_unparsed, "^"..skill) then
            return skill
        end
    end
    
    return nil
end

function roleplay.skills.get_level(username, skill)
    assert(type(roleplay.skills.data[username]) == "table")
    
    local fudge_level_key = nil 
    
    if roleplay.skills.data[username][skill] then
        fudge_level_key = roleplay.skills.data[username][skill]
    end
    
    if not fudge_level_key or type(fudge_level_key) ~= "number" then
        return nil
    end
    
    return fudge_level_key
end

function roleplay.skills.get_all(username)
    if type(roleplay.skills.data[username]) == "table" then
        return roleplay.skills.data[username]    
    else
        return nil
    end
end

function roleplay.skills.parse(username, text_unparsed)
    assert(type(roleplay.skills.data[username]) == "table")
    
    local skill_name          = roleplay.skills.parse_name(username, text_unparsed)
    local fudge_level_key     = roleplay.skills.get_level(username, skill_name)
    
    if not fudge_level_key then
        return nil
    end
    
    local fudge_level_key     = fudge.validate(fudge_level_key)
    local fudge_level_orignal = fudge.to_string(fudge_level_key)
    
    return fudge_level_key
end

-- Load skill data from server on join
minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    
    roleplay.skills.fetch_data(player_name, function(skills)
        roleplay.skills.data[player_name] = skills
    end)
end)

-- Clear user on leave
minetest.register_on_leaveplayer(function(player)
    local player_name = player:get_player_name()
    roleplay.skills.data[player_name] = nil
end)
