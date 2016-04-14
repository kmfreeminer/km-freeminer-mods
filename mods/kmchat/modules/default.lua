local function get_range_index(range_delta)
    local range_index = kmchat.config.speak_ranges.default + range_delta
    
    if range_index < 1 then
        range_index =  1
    elseif range_index > #kmchat.config.speak_ranges["ranges"] then
        range_index = #kmchat.config.speak_ranges["ranges"]
    end
    
    return range_index
end

local default_definition = {}

default_definition.check_say_function = 
    function(event)
        return true
    end

default_definition.init_process_function = 
    function(event)
        local sender = event.sender;

        local range_index = get_range_index(event.range_delta)
        local range_label = kmchat.config.speak_ranges["ranges"][range_index][2]
        
        return string.format("%s%s: %s", kmchat.get_prefixed_username(sender), range_label, event.message)
    end

default_definition.process_per_player_function = 
    function(event)
        local sender   = event.sender;
        local reciever = event.reciever;
        
        local range_index = get_range_index(event.range_delta)
        local range = kmchat.config.speak_ranges["ranges"][range_index][1]
                        
        if (vector.distance(sender:getpos(), reciever:getpos()) > range) then
            return kmchat.colorize_string(event.message_result, event.color)
        end
        
        if (minetest.check_player_privs(reciever:get_player_name(), {["gm"]=true,})) then
            return kmchat.colorize_string(event.message_result, event.color)
        end
                
        return nil
    end
    
default_definition.color = kmchat.config.default_color

kmchat.overdrive_default_functions(default_definition)
