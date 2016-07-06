kmchat = {}

dofile(minetest.get_modpath("kmchat").."/config.lua")
dofile(minetest.get_modpath("kmchat").."/ranges.lua")

dofile(minetest.get_modpath("kmchat").."/chat_string.lua")

local function get_message_type_and_text(message)
    local substrings;

    for rexp, mtype in pairs(kmchat.rexps) do
        substrings = { string.match(message, rexp) }
        if substrings[1] then
            return mtype, substrings[1]
        end
    end

    return "default", message
end

local function find_skill_name(username, text_unparsed)
    local skill_table = charlist.get_skill_table(username)
    for skill_name, _ in pairs(skill_table) do
        if string.match(text_unparsed, "^"..skill_name) then
            return skill_name
        end
    end
    return nil
end

function kmchat.log(message)
    jabber.send(message)
    minetest.log("action", "CHAT: "..message)
end

function kmchat.process_messages(username, message)
    local player  = minetest.get_player_by_name(username)

    -- Special object for avoiding lua and lua_api shit
    local chatString = ChatString:new()
    
    -- Calculate range delta 
    -- {{{
    local range_delta = #(string.match(string.gsub(message,"=",""), '!*')) 
    range_delta = range_delta - #(string.match(string.gsub(message,"!",""), '=*'))

    message = string.gsub(message, "^[!=]*", "")
    local is_global = false
    -- }}}
    
    local name_color   = charlist.get_color(username)
    local real_name    = charlist.get_real_name(username) or username
    local visible_name = charlist.get_visible_name(username) or real_name
    
    local range, range_label = kmchat.ranges.getRangeInfo(range_delta, "speak")

    local action_type, text = get_message_type_and_text(message)
    if not minetest.check_player_privs(username, {["gm"]=true,}) and action_type == "event" then
        action_type = "default"
    end
    
    local color = kmchat[action_type].color
    chatString:setFormatString(kmchat[action_type].format_string)

    if action_type == "global_ooc" then
        is_global = true
    elseif action_type == "dice" then
        local dice = text
        if dice=="4" or dice=="6" or dice=="8" or dice=="10" or dice=="12" or dice=="20" then
            local dice_result = math.random(dice)
            chatString:setVariable("dice", dice)
            chatString:setVariable("dice_result", dice_result)
            range, range_label = kmchat.ranges.getRangeInfo(range_delta)
        end
    elseif action_type == "fudge_dice" then
        local level = string.split(string.gsub(text, "[,(]", " "), " ")[1]
                    
        if not fudge.is_valid(level) then
            local skill_name = find_skill_name(username, text)
            
            if skill_name then
                level = charlist.get_skill_level(username, skill_name)
                if fudge.is_valid(level)  then
                    text = string.format("%s (%s)", level, text)
                end
            end
        end
        
        if fudge.is_valid(level)  then
            level = fudge.normalize(level)
            
            local dices = fudge.roll()
            local signs = fudge.dices_to_string(dices)
            local result_level = fudge.add_modifiers(level, dices)
            
            chatString:setVariable("signs", signs)
            chatString:setVariable("fudge_level_orignal", level)
            chatString:setVariable("fudge_level_result", result_level)
            range, range_label = kmchat.ranges.getRangeInfo(range_delta)   
        else
            chatString:setFormatString(kmchat["default"].format_string)
            color = kmchat["default"].color
        end
    end

    local players = minetest.get_connected_players()

    chatString:setVariable("username", username)
    chatString:setVariable("visible_name", visible_name, name_color)
    chatString:setVariable("real_name", real_name)
    chatString:setVariable("range_label", range_label)
    chatString:setVariable("text", text)
    
    local sender_position = player:getpos()
    for i = 1, #players do
        local reciever_username  = players[i]:get_player_name()
        local reciever_position  = players[i]:getpos()
        
        if is_global or vector.distance(sender_position, reciever_position) <= range then
            minetest.chat_send_player(reciever_username, chatString:get(color))
        elseif minetest.check_player_privs(reciever_username, {gm=true}) then
            minetest.chat_send_player(reciever_username, "(".. username .. ") " .. chatString:get(kmchat.gm_color))
        end
    end
    
    kmchat.log("(".. username .. ") " .. chatString:get())
    return true
end

minetest.register_on_chat_message(kmchat.process_messages)
