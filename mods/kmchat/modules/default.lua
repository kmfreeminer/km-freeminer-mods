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

default_definition.process_per_player_function = kmchat.create_range_pp(kmchat.config.default_color, "speak")

kmchat.overdrive_default_functions(default_definition)
