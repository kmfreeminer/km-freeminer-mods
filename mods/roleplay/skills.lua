roleplay.skills = {}

roleplay.skills.data = {
    ["xunto"] = {
        ["вязание узлов"]   = "посредственно",
        ["владение шпагой"] = "ужасно"
    }
}

function roleplay.skills.parse(username, unparsed_text)
    assert(roleplay.skills.data[username])

    for skill, level in pairs(roleplay.skills.data[username]) do
        if string.match(unparsed_text, "^"..skill) then
            print(skill)
            return skill
        end
    end
    
    return nil
end

function roleplay.skills.get_level(username, skill)
    assert(roleplay.skills.data[username])
    if roleplay.skills.data[username][skill] then
        return roleplay.skills.data[username][skill]
    else
        return fudge.default
    end
end

function roleplay.skills.parse_and_get_level(username, unparsed_text)
    assert(roleplay.skills.data[username])
    local skill = roleplay.skills.parse(username, unparsed_text)
    print(skill)
    return roleplay.skills.get_level(username, skill) .. "(" .. unparsed_text .. ")"
end

function roleplay.skills.set(username, skill, level)
    assert(roleplay.skills.data[username])
    
    local stored_skill = roleplay.skills.parse(username, skill)
    assert(not stored_skill or (exist_skill == skill), string.format("Пересечение названий \"%s\" и \"%s\", невозможно указать этот навык", tmp, skill))

    roleplay.skills.data[username][skill] = level
    roleplay.skills.save()
end

-- load and save functions
function roleplay.skills.save()
    roleplay.save("skills", roleplay.skills.data)
end

function roleplay.skills.load()
    local data = roleplay.load("skills")
    if data then
        roleplay.skills.data = data
    end
end

-- Save data on shutdown
minetest.register_on_shutdown(function()
    roleplay.skills.save()
end)

-- Load data on server start
roleplay.skills.load()

minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    
    if not roleplay.skills.data[player_name] then
        roleplay.skills.data[player_name] = {}
    end
end)

