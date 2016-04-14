function kmchat.register_chat_pattern(definition)
    if not definition["regexp"] then 
        return nil 
    end

    table.insert(kmchat.patterns, definition)
end

function kmchat.log(message)
    jabber.send(message)
    print(message)
end

function kmchat.overdrive_default_functions(definition)
    if(definition["init_process_function"]) then
        kmchat.default.init_process_function  = definition["init_process_function"]
    end
    
    if(definition["process_per_player_function"]) then
        kmchat.default.process_per_player_function = definition["process_per_player_function"]
    end
    
    if(definition["сolor"]) then
        kmchat.default.color = definition["сolor"]
    end
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
