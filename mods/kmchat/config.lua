kmchat.config = {}

kmchat.config.default_range = 3
kmchat.config.default_color = "EEF3EE"

kmchat.config.dice_color = "FFFF00"

kmchat.config.gm_prefix = "[GM]"
kmchat.config.gm_color  = "666666"

kmchat.config.ranges = {
    ["default"] = 3,
    
    ["ranges"] = {
        3,
        8,
        14,
        24,
        65
    },
    
    ["labels"] = {
        ["default"] = {
            " (скрытно)",
            " (тихо)",
            "",
            " (громко)",
            " (громогласно)"
        },
        ["speak"] = {
            " (шепчет)",
            " (почти шепчет)",
            "",
            " (громко говорит)",
            " (кричит)"
        }
    }
}

local function get_range_index(range_delta)
    local range_index = kmchat.config.ranges.default + range_delta
    
    if range_index < 1 then
        range_index =  1
    elseif range_index > #kmchat.config.ranges["ranges"] then
        range_index = #kmchat.config.ranges["ranges"]
    end
    
    return range_index
end

function kmchat.config.ranges.getLabel(range_delta)
    return kmchat.config.ranges.getLabel(range_delta, "default")
end

function kmchat.config.ranges.getLabel(range_delta, message_type)
    local range_index = get_range_index(range_delta)
    
    if kmchat.config.ranges.labels[message_type] and kmchat.config.ranges.labels[message_type][range_index] then
        return kmchat.config.ranges.labels[message_type][range_index]
    end
    
    return ""
end

function kmchat.config.ranges.getRange(range_delta)
    local range_index = get_range_index(range_delta)
    return kmchat.config.ranges.ranges[range_index]
end
