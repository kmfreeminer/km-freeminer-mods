local function get_range_index(range_delta)
    local range_index = kmchat.config.speak_ranges.default + range_delta
    
    if range_index < 1 then
        range_index =  1
    elseif range_index > #kmchat.config.speak_ranges["ranges"] then
        range_index = #kmchat.config.speak_ranges["ranges"]
    end
    
    return range_index
end

kmchat.overdrive_default_process_function(
    function(event)
        local sender   = event.sender;
        local reciever = event.reciever;
        
        local range_index = get_range_index(event.range_delta)
        
        local range = kmchat.config.speak_ranges["ranges"][range_index][1]
        local range_label = kmchat.config.speak_ranges["ranges"][range_index][2]

        local generated_string = string.format("%s%s: %s", kmchat.get_prefixed_username(sender), range_label, event.message)
        
        if (vector.distance(sender:getpos(), reciever:getpos())>range) then
            if minetest.check_player_privs(reciever:get_player_name(), {["gm"]=true,}) then
                return kmchat.colorize_string(generated_string, kmchat.config.gm_color)
            end
            return nil 
        end
        
        return kmchat.colorize_string(generated_string, kmchat.config.default_color)
    end
)
