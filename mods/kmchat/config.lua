kmchat.config = {}

kmchat.config.default_range = 3
kmchat.config.default_color = "EEF3EE"

kmchat.config.dice_color = "FFFF00"

kmchat.config.gm_prefix = "[GM]"
kmchat.config.gm_color  = "666666"

kmchat.config.speak_ranges = {
    ["default"] = 3,
    ["ranges"] = {
        {3,  " (шепчет)"        }, 
        {8,  " (почти шепчет)"  }, 
        {14, ""                 }, 
        {24, " (громко говорит)"}, 
        {65, " (кричит)"        }
    }
}

kmchat.config.default_ranges = {
    ["default"] = 3,
    ["ranges"] = {
        {3,  " (скрытно)"    }, 
        {8,  " (тихо)"       }, 
        {14, ""              }, 
        {24, " (громко)"     }, 
        {65, " (громогласно)"}
    }
}
