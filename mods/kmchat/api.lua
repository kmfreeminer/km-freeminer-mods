function kmchat.register_chat_pattern(definition)
    if not definition["regexp"] then 
        return nil 
    end

    if not definition["process_per_player_function"] and definition["color"] then 
        definition["process_per_player_function"] = kmchat.create_range_pp(definition["color"], msg_type)
    end

    table.insert(kmchat.patterns, definition)
end

function kmchat.log(message)
    jabber.send(message)
    print(message)
end

function kmchat.overdrive_default_functions(definition)
    if(definition["init_process_function"]) then
        kmchat.default.init_process_function  = definition["init_process_function"]
    end
    
    if(definition["process_per_player_function"]) then
        kmchat.default.process_per_player_function = definition["process_per_player_function"]
    end
    
    if(definition["сolor"]) then
        kmchat.default.color = definition["сolor"]
    end
end

function kmchat.get_prefixed_username(player)
    player_name = player:get_player_name();
    
    if minetest.check_player_privs(player_name, {["gm"]=true,}) then
        return kmchat.config.gm_prefix .. player_name
    else
        return player_name
    end
end

function kmchat.colorize_string(given_string, color)
    return freeminer.colorize(color, given_string)
end

function kmchat.create_range_pp(color, msg_type)
    if not msg_type then msg_type = "default" end
    
    return function(event)
        local sender   = event.sender;
        local reciever = event.reciever;
        
        local range = kmchat.config.ranges.getRange(event.range_delta, msg_type)
                        
        if (vector.distance(sender:getpos(), reciever:getpos()) <= range) then
            return kmchat.colorize_string(event.message_result, color)
        end
        
        if (minetest.check_player_privs(reciever:get_player_name(), {["gm"]=true,})) then
            return kmchat.colorize_string(event.message_result, kmchat.config.gm_color)
        end
                
        return nil
    end
    
end

-- ==== CONFIG API ====
local function is_message_type_exist(message_type)
    if kmchat.config.ranges[message_type]         and
       kmchat.config.ranges[message_type].default and
       kmchat.config.ranges[message_type].range
    then
        return true
    end
    
    return false
end

-- Default range index
local function get_default_range_index(message_type)
    return kmchat.config.ranges[message_type].default
end

-- Validate range index
local function get_range_index(range_delta, message_type)    
    local range_default = get_default_range_index(message_type)
    local range_index = range_default + range_delta
    
    if range_index < 1 then
        range_index =  1
    elseif range_index > #kmchat.config.ranges[message_type].range then
        range_index = #kmchat.config.ranges[message_type].range
    end
    
    return range_index
end

-- Get range label
function kmchat.config.ranges.getLabel(range_delta, message_type)
    if not message_type then message_type = "default" end
    
    if is_message_type_exist(message_type) then
        local range_index = get_range_index(range_delta, message_type)
        
        return kmchat.config.ranges[message_type].range[range_index][2]
    end
    return ""
end

-- Get range by label
function kmchat.config.ranges.getRange(range_delta, message_type)
    if not message_type then message_type = "default" end

    if is_message_type_exist(message_type) then
        local range_index = get_range_index(range_delta, message_type)
        return kmchat.config.ranges[message_type].range[range_index][1]
    end
    
    return nil
end
