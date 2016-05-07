kmchat.gm_prefix = "[GM]"
kmchat.gm_color = "666666"

kmchat.fudge_levels = {"-","ужасно--","ужасно-","ужасно", "плохо", "посредственно", "нормально", "хорошо", "отлично", "супер", "легендарно", "легендарно+", "легендарно++","как Аллах"}

kmchat.default = {color = "FFFFFF",
                  format_string = "{{nick}}{{range_label}}: {{text}}"}

kmchat.local_ooc = {color = "9966AA",
                 format_string = "{{nick}} (OOC){{range_label}}: (( {{text}} ))"}

kmchat.global_ooc = {color = "20EEDD",
                     format_string = "{{nick}} (OOC): (( {{text}} ))"}

kmchat.action = {color = "FFFF00",
                 format_string     = "* {{nick}}{{range_label}} {{text}} *"}

kmchat.event = {color = "FFFF00",
                format_string = "*** {{text}} ***"}

kmchat.dice = {color = "FFFF00",
               format_string = "*** {{nick}}{{range_label}} кидает d{{dice}} и выкидывает {{dice_result}} ***"}
kmchat.fudge_dice = {color = "FFFF00",
                     format_string = "*** {{nick}}{{range_label}} кидает 4df ({{signs}}) от {{fudge_dice_string}} и выкидывает {{fudge_level_result}} ***"}

kmchat.ranges = {
    ["default"] = {
        ["default"] = 3,
        ["range"] = {
            { 3,  " (скрытно)"     },
            { 8,  " (тихо)"        },
            { 14, ""               },
            { 24, " (громко)"      },
            { 65, " (громогласно)" }
        }
    },
    ["speak"] = {
        ["default"] = 3,
        ["range"] = {
            { 3,  " (шепчет)"        },
            { 8,  " (почти шепчет)"  },
            { 14, ""                 },
            { 24, " (громко говорит)"},
            { 65, " (кричит)"        }
        }
    }
}
