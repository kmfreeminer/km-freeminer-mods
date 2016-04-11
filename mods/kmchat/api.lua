function kmchat.register_chat_pattern(definition)
    if not definition["regexp"] then return nil end
    local regexp = definition["regexp"]
    
    if not definition["process_function"] then return nil end
    local process_function = definition["process_function"]
    
    local ability_to_say_function = nil
    if definition["ability_to_say_function"] then
        ability_to_say_function = definition["ability_to_say_function"]
    end
    
    local ability_to_see_function = nil
    if definition["ability_to_see_function"] then
        ability_to_see_function = definition["ability_to_see_function"]
    end
    
    table.insert(kmchat.patterns, {regexp, process_function, privilege_to_say, privilege_to_see})
end

function kmchat.get_prefixed_username(player)
    player_name = player:get_player_name();
    
    if minetest.check_player_privs(player_name, {["gm"]=true,}) then
        return GM_PREFIX .. player_name
    else
        return player_name
    end
end

function kmchat.colorize_string(given_string, color)
    if minetest.check_player_privs(player_name, {["gm"]=true,}) then
        return freeminer.colorize(GM_COLOR, given_string)
    else
        return freeminer.colorize(color, given_string)
    end
end

--DEBUG FUNCTION
function dumpt(tab)
    for i,j in pairs(tab) do
        print(i, j)
    end
end
