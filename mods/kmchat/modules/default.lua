-- Out of character
kmchat.register_chat_pattern({
        regexp = "^_(.+)",
        process_function = function(player, substrings, range)
            local generated_string = string.format("%s%s (OOC): (( %s ))", kmchat.get_prefixed_username(player), RANGES[range][2], substrings[1])
            return kmchat.colorize_string(generated_string, "9966AA")
        end
})

kmchat.register_chat_pattern({
        regexp = "^%(%((.+)%)%)",
        process_function = function(player, substrings, range)
            local generated_string = string.format("%s%s (OOC): (( %s ))", kmchat.get_prefixed_username(player), RANGES[range][2], substrings[1])
            return kmchat.colorize_string(generated_string, "9966AA")
        end,
        
})

-- Global out of character
kmchat.register_chat_pattern({
        regexp = "^?%s?(.+)",
        process_function = function(player, substrings, range)
            local generated_string = string.format("*** %s%s: %s ***", kmchat.get_prefixed_username(player), RANGES[range][2], substrings[1])
            return kmchat.colorize_string(generated_string, "20EEDD")
        end
})

-- Action
kmchat.register_chat_pattern({
        regexp = "^*%s?(.+)",
        process_function = function(player, substrings, range)
            local generated_string = string.format("* %s%s %s", kmchat.get_prefixed_username(player), RANGES[range][2], substrings[1])
            return kmchat.colorize_string(generated_string, "FFFF00")
        end
})

-- Event
kmchat.register_chat_pattern({
        regexp = "^#%s?(.+)",
        process_function = function(player, substrings, range)
            local generated_string = string.format("*** %s%s: %s ***", kmchat.get_prefixed_username(player), RANGES[range][2], substrings[1])
            return kmchat.colorize_string(generated_string, "FFFF00")
        end,
})
