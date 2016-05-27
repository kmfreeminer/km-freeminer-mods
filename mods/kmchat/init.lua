kmchat = {}

dofile(minetest.get_modpath("kmchat").."/config.lua")
dofile(minetest.get_modpath("kmchat").."/ranges.lua")

local function get_message_type_and_text(message)
    local substrings = nil

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
    
    assert(skill_table)
    
    for skill, level in pairs(skill_table) do
        if string.match(text_unparsed, "^"..skill) then
            return skill
        end
    end
    return nil
end

function kmchat.log(message)
    jabber.send(message)
    minetest.log("action", "CHAT: "..message)
end

--function kmchat.colorize(color, message, clear_color)
    --clear_color = clear_color or "FFFFFF"
    --return freeminer.color(clear_color) .. message .. freeminer.color(clear_color)
--end

function kmchat.process_messages(username, message)
    local player  = minetest.get_player_by_name(username)

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
    local format_string = kmchat[action_type].format_string
    local color = kmchat[action_type].color

    if action_type == "global_ooc" then
        is_global = true
    elseif action_type == "dice" then
        local dice = text
        if dice=="4" or dice=="6" or dice=="8" or dice=="10" or dice=="12" or dice=="20" then
            local dice_result = math.random(dice)
            format_string = string.gsub(format_string, "{{dice}}", dice)
            format_string = string.gsub(format_string, "{{dice_result}}", dice_result)
            range, range_label = kmchat.ranges.getRangeInfo(range_delta)
        end
    elseif action_type == "fudge_dice" then
        local first_word = string.split(string.gsub(text, "[,(]", " "), " ")[1]
        local level_key = fudge.to_number(first_word)
            
        if not level_key then
            local skill_name = find_skill_name(username, text)
            
            if skill_name then
                level_key = charlist.get_skill_level(username, skill_name)
                
                if level_key then
                    text = string.format("%s (%s)", fudge.to_string(level_key), text)
                end
            end
        end
        
        if level_key then
            level_key = fudge.normalize(level_key)
            
            local dices = fudge.roll()
            local signs = fudge.dices_to_string(dices)
            local result_key = fudge.calculate(level_key, dices)
            
            format_string = string.gsub(format_string, "{{signs}}", signs)
            format_string = string.gsub(format_string, "{{fudge_level_orignal}}", fudge.to_string(level_key))
            format_string = string.gsub(format_string, "{{fudge_level_result}}",  fudge.to_string(result_key))
            range, range_label = kmchat.ranges.getRangeInfo(range_delta)            
        end
    end

    local players = minetest.get_connected_players()

    local result = format_string
    result = string.gsub(result, "{{username}}", username)
    result = string.gsub(result, "{{visible_name}}", visible_name) -- TODO: add colorize
    result = string.gsub(result, "{{real_name}}", real_name)
    result = string.gsub(result, "{{range_label}}", range_label)
    result = string.gsub(result, "{{text}}", text)

    local sender_position = player:getpos()
    for i = 1, #players do
        local reciever_username  = players[i]:get_player_name()
        local reciever_position  = players[i]:getpos()
        
        if is_global or vector.distance(sender_position, reciever_position) <= range then
            minetest.chat_send_player(reciever_username, freeminer.colorize(color, tmp))
        elseif minetest.check_player_privs(reciever_username, {gm=true}) then
            minetest.chat_send_player(reciever_username, freeminer.colorize(kmchat.gm_color, "(".. username .. ") " .. result))
        end
    end

    kmchat.log("(".. username .. ") " .. result)
    return true
end

minetest.register_on_chat_message(kmchat.process_messages)
