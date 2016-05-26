roleplay.skills = {}

roleplay.skills.data = {
    ["xunto"] = {
        ["вязание узлов"]   = fudge.parse_level("посредственно"),
        ["владение шпагой"] = fudge.parse_level("ужасно")
    }
}

-- Helpers
-- {{
local function parse(username, unparsed_text)
    assert(roleplay.skills.data[username])

    for skill, level in pairs(roleplay.skills.data[username]) do
        if string.match(unparsed_text, "^"..skill) then
            return skill
        end
    end
    
    return nil
end

local function get_level(username, skill)
    assert(roleplay.skills.data[username])
    
    local fudge_level_key = nil 
    
    if roleplay.skills.data[username][skill] then
        fudge_level_key = roleplay.skills.data[username][skill]
    end
    
    if not fudge_level_key or type(fudge_level_key) ~= "number" then
        fudge_level_key = fudge.default
    end
    
    return fudge.get_level(fudge_level_key)
end
--}}


function roleplay.skills.parse(username, skill_unparsed)
    return parse(username, skill_unparsed)
end

function roleplay.skills.set_level(username, skill, level)
    assert(roleplay.skills.data[username])
    
    local stored_skill = roleplay.skills.parse(username, skill)
    assert(not stored_skill or (exist_skill == skill), string.format("Пересечение названий \"%s\" и \"%s\", невозможно указать этот навык", tmp, skill))

    roleplay.skills.data[username][skill] = fudge.parse_level(level)
    roleplay.skills.save()
end

function roleplay.skills.get_level(username, skill_unparsed)
    assert(roleplay.skills.data[username])
    
    local skill = roleplay.skills.parse(username, skill_unparsed)
    local fudge_level_key, fudge_level_orignal = get_level(username, skill)
    
    return fudge_level_key, fudge_level_orignal, fudge_level_orignal .. "(" .. skill_unparsed .. ")"
end

-- load skill data from server
minetest.register_on_joinplayer(function(player)
    
end)

-- clear user on leave
minetest.register_on_leaveplayer(function(player)
    
end)
