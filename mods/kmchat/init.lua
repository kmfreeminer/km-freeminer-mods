kmchat = {}

dofile(minetest.get_modpath("kmchat").."/config.lua")
dofile(minetest.get_modpath("kmchat").."/ranges.lua")

function kmchat.get_prefixed_username(player)
    player_name = player:get_player_name();

    if minetest.check_player_privs(player_name, {["gm"]=true,}) then
        return kmchat.gm_prefix .. player_name
    else
        return player_name
    end
end


function get_message_type_and_text(message)
    local substrings = nil

    for rexp, mtype in pairs(kmchat.rexps) do
        substrings = { string.match(message, rexp) }
        if substrings[1] then
            return mtype, substrings[1]
        end
    end

    return "default", message
end

function kmchat.log(message)
    jabber.send(message)
    print(message)
end

function kmchat.process_messages(name, message)
    local player  = minetest.get_player_by_name(name)

    -- Calculate range delta 
    -- {{{
    local range_delta      =    #(string.match(string.gsub(message,"=",""), '!*')) 
    range_delta = range_delta - #(string.match(string.gsub(message,"!",""), '=*'))

    message = string.gsub(message, "^[!=]*", "")
    local is_global = false
    -- }}}

    local nick = kmchat.get_prefixed_username(player)
    local range, range_label = kmchat.ranges.getRangeInfo(range_delta, "speak")

    local action_type, text = get_message_type_and_text(message)
    if not minetest.check_player_privs(player_name, {["gm"]=true,}) and action_type == "event" then
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
        local first_word = nil
        for word in string.gmatch(string.gsub(text, "[,(]", " "), "[%S]+") do
            first_word = word
            break
        end

        for fudge_level_key, fudge_level_orignal in pairs(kmchat.fudge_levels) do
            if fudge_level_orignal == first_word then
                local signs = ""

                for i = 1, 4 do
                    rand = math.random(-1, 1)
                    if rand == 1 then
                        signs = signs.."+"
                    elseif rand == -1 then
                        signs = signs.."-"
                    else
                        signs = signs.."="
                    end
                    fudge_level_key = fudge_level_key+rand
                end

                if fudge_level_key<1 then
                    fudge_level_key = 1
                elseif fudge_level_key>#kmchat.fudge_levels then
                    fudge_level_key = #kmchat.fudge_levels
                end

                local fudge_level_result = kmchat.fudge_levels[fudge_level_key]
                format_string = string.gsub(format_string, "{{signs}}", signs)
                format_string = string.gsub(format_string, "{{fudge_level_orignal}}", fudge_level_orignal)
                format_string = string.gsub(format_string, "{{fudge_level_result}}", fudge_level_result)
                range, range_label = kmchat.ranges.getRangeInfo(range_delta)
            end
        end
    end

    local players = minetest.get_connected_players()

    local result = format_string
    result = string.gsub(result, "{{nick}}", nick)
    result = string.gsub(result, "{{range_label}}", range_label)
    result = string.gsub(result, "{{text}}", text)

    local sender_position = player:getpos()
    for i = 1, #players do
        local reciever_name      = players[i]:get_player_name()
        local reciever_position  = players[i]:getpos()

        if is_global or vector.distance(sender_position, reciever_position) <= range then
            minetest.chat_send_player(reciever_name, freeminer.colorize(color, result))
        elseif minetest.check_player_privs(reciever_name, {gm=true}) then
            minetest.chat_send_player(reciever_name, freeminer.colorize(kmchat.gm_color, result))
        end
    end

    kmchat.log(result)
    return true
end

minetest.register_on_chat_message(kmchat.process_messages)
