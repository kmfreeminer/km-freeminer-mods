local function isMessageTypeExist(message_type)
    if kmchat.ranges[message_type]         and
       kmchat.ranges[message_type].default and
       kmchat.ranges[message_type].range
    then
        return true
    end
    
    return false
end

-- Default range index
local function getDefaultRangeIndex(message_type)
    return kmchat.ranges[message_type].default
end

-- Validate range index
local function getRangeIndex(range_delta, message_type)    
    local range_default = getDefaultRangeIndex(message_type)
    local range_index = range_default + range_delta
    
    if range_index < 1 then
        range_index =  1
    elseif range_index > #kmchat.ranges[message_type].range then
        range_index = #kmchat.ranges[message_type].range
    end
    
    return range_index
end

-- Get range label
function kmchat.ranges.getLabel(range_delta, message_type)
    if not message_type then message_type = "default" end
    
    if isMessageTypeExist(message_type) then
        local range_index = getRangeIndex(range_delta, message_type)
        
        return kmchat.ranges[message_type].range[range_index][2]
    end
    return ""
end

-- Get range
function kmchat.ranges.getRange(range_delta, message_type)
    if not message_type then message_type = "default" end

    if isMessageTypeExist(message_type) then
        local range_index = getRangeIndex(range_delta, message_type)
        return kmchat.ranges[message_type].range[range_index][1]
    end
    
    return nil
end
