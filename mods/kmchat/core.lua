function kmchat.process_default(player, message, range)
    local generated_string = string.format("%s%s: %s", kmchat.get_prefixed_username(player), DEFAULT_RANGES[range][2], message)
    return kmchat.colorize_string(generated_string, DEFAULT_COLOR)
end

function kmchat.process_message(name, message)
    local fmt       = DEFAULT_FORMAT 
    local range     = DEFAULT_RANGE
    local color     = DEFAULT_COLOR
    local privilege = nil
    
    local player_name = name
        
    local player  = minetest.get_player_by_name(player_name)
    local players = minetest.get_connected_players()
     
    local loud_control = string.match(message, '^[!=]*')
    range = range + #(string.match(string.gsub(message,"=",""), '!*'))
    range = range - #(string.match(string.gsub(message,"!",""), '=*'))
    
    if range < 1 then
        range = 1
    elseif range > #RANGES then
        range = #RANGES
    end
    
    message = string.gsub(message, "^[!=]*", "")
    
    local result_message = nil;
    local privilege_to_see_function = nil;
    for _, pattern in pairs(kmchat.patterns) do
        local regexp = pattern[1]
        local process_function = pattern[2]
        local privilege_to_say_function = pattern[3]
        privilege_to_see_function = pattern[4]
                
        local substrings = { string.match(message, regexp) }
        dumpt(substrings)
        if substrings[1] then
            if (not privilege_to_say) or privilege_to_say_function(player) then
                result_message = process_function(player, substrings, range)
                privilege = privilege_to_see;
            end
        end
    end

    if not result_message then
        result_message = kmchat.process_default(player, message, range)
    end

    local players = minetest.get_connected_players()
    local sender_position = player:getpos()
    for i = 1, #players do 
        local reciever_name = players[i]:get_player_name()
        local reciever_position = players[i]:getpos()
        
        if minetest.check_player_privs(players[i]:get_player_name(), {gm=true}) then
			minetest.chat_send_player(reciever_name , result_message)
        elseif math.sqrt((sender_position.x-sender_position.x)^2 + (sender_position.y-reciever_position.y)^2 + (sender_position.z-sender_position.z)^2) < RANGES[range][1] then
            if (not privilege_to_say_function) or privilege_to_say_function(players[i]) then
                minetest.chat_send_player(reciever_name, result_message)
            end
        end
    end
    
    return true
end

minetest.register_on_chat_message(kmchat.process_message)
