-- Out of character
local function ooc_init_process_function(event)
    local sender   = event.sender;
    
    local range_label = kmchat.config.ranges.getLabel(event.range_delta)
    
    return string.format("%s%s (OOC): (( %s ))", kmchat.get_prefixed_username(sender), range_label, event.substrings[1])
end


kmchat.register_chat_pattern({
        regexp = "^_(.+)",
        init_process_function = ooc_init_process_function,
        color = "9966AA"
})

kmchat.register_chat_pattern({
        regexp = "^%(%((.+)%)%)",
        init_process_function = ooc_init_process_function,
        color = "9966AA"
})


-- Global out of character
kmchat.register_chat_pattern({
        regexp = "^?%s?(.+)",
        
        init_process_function = function(event)
            local sender = event.sender;            
            return string.format("%s%s (OOC): (( %s ))", kmchat.get_prefixed_username(sender), " (на весь мир)", event.substrings[1])
        end,
        
        process_per_player_function = function(event)
            return kmchat.colorize_string(event.message_result, "20EEDD")
        end,
})

-- Action
kmchat.register_chat_pattern({
        regexp = "^*%s?(.+)",
        
        init_process_function = function(event)
            local sender = event.sender;              
              
            local range_label = kmchat.config.ranges.getLabel(event.range_delta)
            
            return string.format("* %s%s %s", kmchat.get_prefixed_username(sender), range_label, event.substrings[1])
        end,
        
        color = "FFFF00"
})

-- Event
kmchat.register_chat_pattern({
        regexp = "^#%s?(.+)",
        
        init_process_function = function(event)
            local sender = event.sender;              
              
            local range_label = kmchat.config.ranges.getLabel(event.range_delta)          
            
            if(not minetest.check_player_privs(sender:get_player_name(), {gm=true})) then return nil end
            
            return string.format("*** %s ***", event.substrings[1])
        end,
        
        color = "FFFF00"
})
