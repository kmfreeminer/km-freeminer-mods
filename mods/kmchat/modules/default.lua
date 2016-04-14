local default_definition = {}

default_definition.check_say_function = 
    function(event)
        return true
    end

default_definition.init_process_function = 
    function(event)
        local sender = event.sender;

        local range_label = kmchat.config.ranges.getLabel(event.range_delta, "speak")       
        
        return string.format("%s%s: %s", kmchat.get_prefixed_username(sender), range_label, event.message)
    end

default_definition.process_per_player_function = 
    function(event)
        local sender   = event.sender;
        local reciever = event.reciever;
        
        local range = kmchat.config.ranges.getRange(event.range_delta, "speak")
                        
        if (vector.distance(sender:getpos(), reciever:getpos()) <= range) then
            return kmchat.colorize_string(event.message_result, event.color)
        end
        
        if (minetest.check_player_privs(reciever:get_player_name(), {["gm"]=true,})) then
            return kmchat.colorize_string(event.message_result, kmchat.config.gm_color)
        end
                
        return nil
    end
    
default_definition.color = kmchat.config.default_color

kmchat.overdrive_default_functions(default_definition)
