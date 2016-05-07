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

function kmchat.log(message)
    jabber.send(message)
    print(message)
end



function kmchat.process_messages(name, message)
    local player  = minetest.get_player_by_name(name)
    
    -- [Calculate range delta]
    local range_delta = 0
    range_delta = range_delta + #(string.match(string.gsub(message,"=",""), '!*'))
    range_delta = range_delta - #(string.match(string.gsub(message,"!",""), '=*'))
    
    message = string.gsub(message, "^[!=]*", "")
    
    local is_global = false
    -- [/Calculate range delta]

    
    -- [Default values]
    local format_string = kmchat.default_format_string
    
    local nick = kmchat.get_prefixed_username(player)
    local text = message
    
    local range       = kmchat.ranges.getRange(range_delta, "speak")
    local range_label = kmchat.ranges.getLabel(range_delta, "speak")

    local color = kmchat.default_color
    -- [/Default values]

    repeat
        local substrings = nil

        -- local OOC chat
        substrings = { string.match(message, "^_(.+)") }
        
        if not substrings[1] then
            substrings = { string.match(message, "^%(%((.+)%)%)") }
        end
        
        if substrings[1] then
            format_string = kmchat.local_ooc_format_string
            color = kmchat.local_ooc_color
            
            text = substrings[1]
            break
        end
        
        -- global OOC chat
        substrings = { string.match(message, "^?%s?(.+)") }
        
        if substrings[1] then
            is_global = true
            
            format_string = kmchat.global_ooc_format_string
            color = kmchat.global_ooc_color
            
            text = substrings[1]
            break
        end
        
        -- role-play action
        substrings = { string.match(message, "^*%s?(.+)") }
        
        if substrings[1] then
            format_string = kmchat.action_format_string
            color = kmchat.action_color
            
            text = substrings[1]
            break
        end
        
        -- dice
        substrings = { string.match(message, "^d(%d+)(.*)$") }
        
        if substrings[1] then
            local dice = substrings[1]
            if dice=="4" or dice=="6" or dice=="8" or dice=="10" or dice=="12" or dice=="20" then
                local dice_result = math.random(dice)
                format_string = kmchat.dice_format_string
                format_string = string.gsub(format_string, "{{dice}}", dice)
                format_string = string.gsub(format_string, "{{dice_result}}", dice_result)
                
                color = kmchat.dice_color
                
                range = kmchat.ranges.getRange(range_delta)
                range_label = kmchat.ranges.getLabel(range_delta)
            end
            break
        end
        
        -- [4dF dice]
        substrings = { string.match(message, "^4d[Ff] (.*)$") }
        
        if not substrings[1] then
            substrings = { string.match(message, "^%%%%%% (.*)$") }
        end
        
        if substrings[1] then
            local fudge_dice_string = substrings[1]

            local first_word = nil
            for word in string.gmatch(string.gsub(fudge_dice_string, "[,(]", " "), "[%S]+") do
                first_word = word
                break
            end
            
            for key, val in pairs(kmchat.fudge_levels) do
                if val == first_word then
                    local fudge_level_orignal = first_word
                    local fudge_level_key = key
                    
                    local diff = 0
                    local signs = ""
                    
                    for i = 1, 4 do
                        rand = math.random(3)
                        if rand == 1 then
                            diff=diff+1
                            signs = signs.."+"
                        elseif rand == 2 then
                            diff=diff-1
                            signs = signs.."-"
                        else
                            signs = signs.."="
                        end
                    end
                    
                    fudge_level_key = fudge_level_key+diff
                    
                    if fudge_level_key<1 then
                        fudge_level_key = 1
                    elseif fudge_level_key>#kmchat.fudge_levels then
                        fudge_level_key = #kmchat.fudge_levels
                    end
                    
                    local fudge_level_result = kmchat.fudge_levels[fudge_level_key]
                    
                    format_string = kmchat.fudge_dice_format_string
                    format_string = string.gsub(format_string, "{{signs}}", signs)
                    format_string = string.gsub(format_string, "{{fudge_level_orignal}}", fudge_level_orignal)
                    format_string = string.gsub(format_string, "{{fudge_dice_string}}", fudge_dice_string)
                    format_string = string.gsub(format_string, "{{fudge_level_result}}", fudge_level_result)
                    
                    color = kmchat.dice_color
                    
                    range = kmchat.ranges.getRange(range_delta)
                    range_label = kmchat.ranges.getLabel(range_delta)
                end
            end
            break
        end
        -- [/4dF dice]

        -- event [gm-only]
        if minetest.check_player_privs(player_name, {["gm"]=true,}) then
            substrings = { string.match(message, "^#%s?(.+)") }
            
            if substrings[1] then
                format_string = kmchat.event_format_string
                color = kmchat.event_color
                
                text = substrings[1]
                break
            end
        end
    until true
    
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
