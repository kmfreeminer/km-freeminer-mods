function kmchat.register_chat_pattern(definition)
    if not definition["regexp"] then return nil end
    
    if not definition["process_function"] then return nil end
    
    table.insert(kmchat.patterns, definition)
end

function kmchat.get_prefixed_username(player)
    player_name = player:get_player_name();
    
    if minetest.check_player_privs(player_name, {["gm"]=true,}) then
        return kmchat.config.gm_prefix .. player_name
    else
        return player_name
    end
end

function kmchat.colorize_string(given_string, color)
    return freeminer.colorize(color, given_string)
end
