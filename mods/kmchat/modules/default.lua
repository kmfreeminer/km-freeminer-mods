-- Out of character
function ooc_process_function(player, substrings, range)
    return string.format("%s%s (OOC): (( %s ))", kmchat.get_prefixed_username(player), kmchat.config.default_ranges["ranges"][range][2], substrings[1])
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
        process_function = function(sender, substrings, range)
            return string.format("%s%s (OOC): (( %s ))", kmchat.get_prefixed_username(player), " (на весь мир)", substrings[1])
        end,
        
        privilege_to_see_function = function(event)
            return true
        end,
        
        colorize_function = function(event)
        
        end
})

-- Action
kmchat.register_chat_pattern({
        regexp = "^*%s?(.+)",
        process_function = function(player, substrings, range)
            return string.format("* %s%s %s", kmchat.get_prefixed_username(player), kmchat.config.default_ranges["ranges"][range][2], substrings[1])
        end
})

-- Event
kmchat.register_chat_pattern({
        regexp = "^#%s?(.+)",
        process_function = function(player, substrings, range)
            return string.format("*** %s%s: %s ***", kmchat.get_prefixed_username(player), kmchat.config.default_ranges["ranges"][range][2], substrings[1])
        end,
})
