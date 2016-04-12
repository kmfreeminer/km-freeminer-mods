local function get_range_index(range_delta)
    local range_index = kmchat.config.default_ranges.default + range_delta
    
    if range_index < 1 then
        range_index =  1
    elseif range_index > #kmchat.config.default_ranges["ranges"] then
        range_index = #kmchat.config.default_ranges["ranges"]
    end
    
    return range_index
end

-- d4, d10 and etc.
kmchat.register_chat_pattern({
        regexp = "^d(%d+).*",
        process_function = function(event)
            local sender   = event.sender;
            local reciever = event.reciever;
            
            local range_index = get_range_index(event.range_delta)
            local range       = kmchat.config.default_ranges["ranges"][range_index][1]
            local range_label = kmchat.config.default_ranges["ranges"][range_index][2]
        
            local generated_string = nil
            
            local dice = event.substrings[1]
            if dice=="4" or dice=="6" or dice=="8" or dice=="10" or dice=="12" or dice=="20" then
                local dice_result = math.random(dice)
                generated_string = string.format("*** %s%s кидает d%s и выкидывает %s ***", kmchat.get_prefixed_username(sender), range_label, dice, dice_result)
            else
                return nil
            end
                        
            if (vector.distance(sender:getpos(), reciever:getpos())>range) then
                if minetest.check_player_privs(reciever:get_player_name(), {["gm"]=true,}) then
                    return kmchat.colorize_string(generated_string, kmchat.config.gm_color)
                end
                return nil 
            end
            
            return kmchat.colorize_string(generated_string, kmchat.config.dice_color)
        end
})

---- fudge dices
--local fudge_levels = {"-","ужасно--","ужасно-","ужасно", "плохо", "посредственно", "нормально", "хорошо", "отлично", "супер", "легендарно", "легендарно+", "легендарно++","как Аллах"}

--function fudge_process(player, substrings, range)
            --local fudge_dice_tmp = substrings[1]
            
            --for key, val in pairs(fudge_levels) do
                --local fudge_level = string.match(fudge_dice_tmp, "^("..val..".*)")
                --local fudge_level_key = key
                
                --if fudge_level~=nil then
                    --local diff = 0
                    --local signs = ""
                    
                    --for i = 1, 4 do
                        --rand = math.random(3)
                        --if rand == 1 then
                            --diff=diff+1
                            --signs = signs.."+"
                        --elseif rand == 2 then
                            --diff=diff-1
                            --signs = signs.."-"
                        --else
                            --signs = signs.."="
                        --end
                    --end
                            
                    --fudge_level_key = fudge_level_key+diff
                    
                    --if fudge_level_key<1 then
                        --fudge_level_key = 1
                    --elseif fudge_level_key>#fudge_levels then
                        --fudge_level_key = #fudge_levels
                    --end
                    
                    --local dice_result = fudge_levels[fudge_level_key]
                    
                    --return string.format("*** %s%s кидает 4df (%s) от %s и выкидывает %s ***", kmchat.get_prefixed_username(player), kmchat.config.default_ranges["ranges"][range][2], "хуй", fudge_level, dice_result)
                --end
            --end
            --return nil
--end


--kmchat.register_chat_pattern({
        --regexp = "^4d[Ff] (.*)$",
        --process_function = fudge_process
--})

--kmchat.register_chat_pattern({
        --regexp = "^%%%%%% (.*)$",
        --process_function = fudge_process
--})
