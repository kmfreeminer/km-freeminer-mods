kmchat.default = {}

kmchat.default.process_function = 
    function(event)
        return nil
    end

function kmchat.process_messages(name, message)
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

    local event = {}
    event.sender = player
    
    event.range_delta = range_delta
    
    event.message = message
    event.substrings = substrings

    for i = 1, #players do 
        event.reciever = players[i]
        
        local message_result = nil
        if message_definition.process_function then
            message_result = message_definition.process_function(event)
        end
        
        if not message_result then
            message_result = kmchat.default.process_function(event)
        end
        
        if message_result then
            minetest.chat_send_player(players[i]:get_player_name(), message_result)
        end
        event.reciever = nil
    end
    
    return true
end

minetest.register_on_chat_message(kmchat.process_messages)
