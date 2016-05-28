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
    for skill_name, _ in pairs(skill_table) do
        if string.match(text_unparsed, "^"..skill_name) then
            return skill_name
        end
    end
    return nil
end

local color_pattern = "(\v[0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f][0-9A-Fa-f])"

function kmchat.colorize_fix(message, default_color)
    if not default_color then
        default_color = freeminer.color("ffffff")
    end
    
    local new_colors = {}
    for color in string.gfind(message, color_pattern) do
        if color == default_color and #new_colors ~= 0 then
            table.insert(new_colors, new_colors[#new_colors - 1])
        else
            table.insert(new_colors, color)
        end
    end
    
    message = string.gsub(message, color_pattern, "\vnew")

    for _,color in pairs(new_colors) do
        message = string.gsub(message, "\vnew", color, 1)
    end
    return message
end

function kmchat.colorize_escape(message)
    return string.gsub(message, color_pattern, "")
end

function kmchat.log(message)
    message = kmchat.colorize_escape(message)
    jabber.send(message)
    minetest.log("action", "CHAT: "..message)
end

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
            
            format_string = string.gsub(format_string, "{{signs}}", signs)
            format_string = string.gsub(format_string, "{{fudge_level_orignal}}", level)
            format_string = string.gsub(format_string, "{{fudge_level_result}}",  result_level)
            range, range_label = kmchat.ranges.getRangeInfo(range_delta)            
        end
    end

    local players = minetest.get_connected_players()

    local result = format_string
    result = string.gsub(result, "{{username}}", username)
    result = string.gsub(result, "{{visible_name}}", freeminer.colorize(name_color, visible_name))
    result = string.gsub(result, "{{real_name}}", real_name)
    result = string.gsub(result, "{{range_label}}", range_label)
    result = string.gsub(result, "{{text}}", text)

    local sender_position = player:getpos()
    for i = 1, #players do
        local reciever_username  = players[i]:get_player_name()
        local reciever_position  = players[i]:getpos()
        
        if is_global or vector.distance(sender_position, reciever_position) <= range then
            minetest.chat_send_player(reciever_username, kmchat.colorize_fix(freeminer.colorize(color, result)))
        elseif minetest.check_player_privs(reciever_username, {gm=true}) then
            minetest.chat_send_player(reciever_username, kmchat.colorize_fix(freeminer.colorize(kmchat.gm_color, "(".. username .. ") " .. result)))
        end
    end
    
    kmchat.log("(".. username .. ") " .. result)
    return true
end

minetest.register_on_chat_message(kmchat.process_messages)
