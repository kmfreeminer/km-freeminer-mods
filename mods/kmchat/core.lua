kmchat.default = {}

kmchat.default.check_say_function = 
    function(event)
        return true
    end
    
kmchat.default.init_process_function = 
    function(event)
        return nil
    end
    
kmchat.default.process_per_player_function = 
    function(event)
        return kmchat.colorize_string(event.result_message, event.color)
    end

kmchat.default.color = "FFFFFF"

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
        
    -- If player is not allowed to say that, it will act as default
    if message_definition.check_say_function then
        if not message_definition.check_say_function() then
            message_definition = {}
        else
            message_definition = kmchat.default
        end
    end
    
    event.message_result = nil
    -- Process message text
    if message_definition.init_process_function then
        event.message_result = message_definition.init_process_function(event)
    end
    
    if not event.message_result then
        event.message_result = kmchat.default.init_process_function(event)
        message_definition = kmchat.default
    end
    
    for i = 1, #players do 
        event.reciever = players[i]
        
        local message_result = nil
        
        if message_definition.process_per_player_function then
            message_result = message_definition.process_per_player_function(event)
        else
            message_result = kmchat.default.process_per_player_function(event)
        end
        
        if message_result then
            minetest.chat_send_player(players[i]:get_player_name(), message_result)
        end
        
        event.reciever = nil
    end
    
    kmchat.log(event.message_result)
    
    return true
end

minetest.register_on_chat_message(kmchat.process_messages)
