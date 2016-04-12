kmchat.default = {}

function kmchat.default.process_function(player, message, range)
    local generated_string = string.format("%s%s: %s", kmchat.get_prefixed_username(player), kmchat.config.speak_ranges["ranges"][range][2], message)
    return kmchat.colorize_string(generated_string, kmchat.config.default_color)
end

function kmchat.default.privilege_to_see_function(sender, receiver, range)
    local sender_position = sender:getpos()
    local reciever_position = receiver:getpos()
    
    return math.sqrt((sender_position.x-reciever_position.x)^2 + (sender_position.y-reciever_position.y)^2 + (sender_position.z-reciever_position.z)^2) < kmchat.config.speak_ranges["ranges"][range][1]
end

function kmchat.default.validate_range_function(range_delta)
    local range = kmchat.config.speak_ranges.default + range_delta
    
    if range < 1 then
        range =  1
    elseif range > #kmchat.config.speak_ranges["ranges"] then
        range = #kmchat.config.speak_ranges["ranges"]
    end
    
    return range
end

function kmchat.process_message(name, message)
    local player  = minetest.get_player_by_name(name)
    local players = minetest.get_connected_players()
    
    local range_delta = 0
    range_delta = range_delta + #(string.match(string.gsub(message,"=",""), '!*'))
    range_delta = range_delta - #(string.match(string.gsub(message,"!",""), '=*'))
    message = string.gsub(message, "^[!=]*", "")

    local message_definition = {}
    local substrings = {}
    for _, definition in pairs(kmchat.patterns) do
        substrings = { string.match(message, definition["regexp"]) }
        if substrings[1] then
            message_definition = definition
            break
        else 
            substrings = {}
        end
    end
    
    local message_range = 0;
    if message_definition["validate_range_function"] then
        message_range = message_definition["validate_range_function"](range_delta)
    else
        message_range = kmchat.default.validate_range_function(range_delta)
    end
    
    local message_result = nil
    if not message_definition["privilege_to_say_function"] or message_definition["privilege_to_say_function"](player) then
        if message_definition["process_function"] then
            message_result = message_definition["process_function"](player, substrings, message_range)
        end
    end
    
    if not message_result then
        message_result = kmchat.default.process_function(player, message, message_range)
    end
    
    for i = 1, #players do 
        local reciever_name = players[i]:get_player_name()
        
        if minetest.check_player_privs(players[i]:get_player_name(), {gm=true}) then
			minetest.chat_send_player(reciever_name, kmchat.colorize_string(message_result, "000000"))
        else
            if message_definition["privilege_to_see_function"] then
                if(message_definition["privilege_to_see_function"](player, players[i], message_range)) then
                    minetest.chat_send_player(reciever_name, message_result)
                end
            else
                if (kmchat.default.privilege_to_see_function(player, players[i], message_range)) then
                    minetest.chat_send_player(reciever_name, message_result)
                end
            end
        end
    end
    
    return true
end

minetest.register_on_chat_message(kmchat.process_message)
