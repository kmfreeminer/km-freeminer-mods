local function get_range_index(range_delta)
    local range_index = kmchat.config.default_ranges.default + range_delta
    
    if range_index < 1 then
        range_index =  1
    elseif range_index > #kmchat.config.default_ranges["ranges"] then
        range_index = #kmchat.config.default_ranges["ranges"]
    end
    
    return range_index
end

-- Out of character
function ooc_process_function(event)
    local sender   = event.sender;
    local reciever = event.reciever;
    
    local range_index = get_range_index(event.range_delta)
    local range       = kmchat.config.default_ranges["ranges"][range_index][1]
    local range_label = kmchat.config.default_ranges["ranges"][range_index][2]

    local generated_string = string.format("%s%s (OOC): (( %s ))", kmchat.get_prefixed_username(sender), range_label, event.substrings[1])
    
    if (vector.distance(sender:getpos(), reciever:getpos())>range) then
        if minetest.check_player_privs(reciever:get_player_name(), {["gm"]=true,}) then
            return kmchat.colorize_string(generated_string, kmchat.config.gm_color)
        end
        return nil 
    end
    
    return kmchat.colorize_string(generated_string, "9966AA")
end

kmchat.register_chat_pattern({
        regexp = "^_(.+)",
        process_function = ooc_process_function
})

kmchat.register_chat_pattern({
        regexp = "^%(%((.+)%)%)",
        process_function = ooc_process_function
})

-- Global out of character
kmchat.register_chat_pattern({
        regexp = "^?%s?(.+)",
        process_function = function(event)
            local sender = event.sender;
            local generated_string = string.format("%s%s (OOC): (( %s ))", kmchat.get_prefixed_username(sender), " (на весь мир)", event.substrings[1])

            return kmchat.colorize_string(generated_string, "20EEDD")
        end,
})

-- Action
kmchat.register_chat_pattern({
        regexp = "^*%s?(.+)",
        process_function = function(event)
            local sender   = event.sender;
            local reciever = event.reciever;
            
            local range_index = get_range_index(event.range_delta)
            local range       = kmchat.config.default_ranges["ranges"][range_index][1]
            local range_label = kmchat.config.default_ranges["ranges"][range_index][2]
        
            local generated_string = string.format("* %s%s %s", kmchat.get_prefixed_username(sender), range_label, event.substrings[1])
            
            if (vector.distance(sender:getpos(), reciever:getpos())>range) then
                if minetest.check_player_privs(reciever:get_player_name(), {["gm"]=true,}) then
                    return kmchat.colorize_string(generated_string, kmchat.config.gm_color)
                end
                return nil 
            end
            
            return kmchat.colorize_string(generated_string, "FFFF00")
        end
})

-- Event
kmchat.register_chat_pattern({
        regexp = "^#%s?(.+)",
        process_function = function(event)
            local sender   = event.sender;
            local reciever = event.reciever;
            
            local range_index = get_range_index(event.range_delta)
            local range       = kmchat.config.default_ranges["ranges"][range_index][1]
            local range_label = kmchat.config.default_ranges["ranges"][range_index][2]
            
            if(not minetest.check_player_privs(sender:get_player_name(), {gm=true})) then return nil end
            
            local generated_string = string.format("*** %s ***", event.substrings[1])
            
            if (vector.distance(sender:getpos(), reciever:getpos())>range) then
                if minetest.check_player_privs(reciever:get_player_name(), {["gm"]=true,}) then
                    return kmchat.colorize_string(generated_string, kmchat.config.gm_color)
                end
                return nil 
            end
            
            return kmchat.colorize_string(generated_string, "FFFF00")
        end
})
