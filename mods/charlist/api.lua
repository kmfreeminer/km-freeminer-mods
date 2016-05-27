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
    
    local fudge_level_key = nil 
    
    if charlist.data[username].skills[skill_name] then
        fudge_level_key = charlist.data[username].skills[skill_name]
    end
    
    if not fudge_level_key or type(fudge_level_key) ~= "number" then
        return nil
    end
    
    return fudge_level_key
end
-- }}
