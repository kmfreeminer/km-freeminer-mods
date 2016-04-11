-- d4, d10 and etc.
kmchat.register_chat_pattern({
        regexp = "^d(%d+).*",
        process_function = function(player, substrings, range)
            local dice = substrings[1]
            if dice=="4" or dice=="6" or dice=="8" or dice=="10" or dice=="12" or dice=="20" then
                local dice_result = math.random(dice)
                local generated_string = string.format("*** %s%s кидает d%s и выкидывает %s ***", kmchat.get_prefixed_username(player), RANGES[range][2], dice, dice_result)
                return kmchat.colorize_string(generated_string, DICE_COLOR)
            else
                return nil
            end
        end
})

-- fudge dices
local fudge_levels = {"-","ужасно--","ужасно-","ужасно", "плохо", "посредственно", "нормально", "хорошо", "отлично", "супер", "легендарно", "легендарно+", "легендарно++","как Аллах"}

function fudge_process(player, substrings, range)
            local fudge_dice_tmp = substrings[1]
            
            for key, val in pairs(fudge_levels) do
                local fudge_level = string.match(fudge_dice_tmp, "^("..val..".*)")
                local fudge_level_key = key
                
                if fudge_level~=nil then
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
                    elseif fudge_level_key>#fudge_levels then
                        fudge_level_key = #fudge_levels
                    end
                    
                    local dice_result = fudge_levels[fudge_level_key]
                    
                    local generated_string = string.format("*** %s%s кидает 4df (%s) от %s и выкидывает %s ***", kmchat.get_prefixed_username(player), RANGES[range][2], "хуй", fudge_level, dice_result)
                    return kmchat.colorize_string(generated_string, DICE_COLOR)
                end
            end
            return nil
end


kmchat.register_chat_pattern({
        regexp = "^4d[Ff] (.*)$",
        process_function = fudge_process
})

kmchat.register_chat_pattern({
        regexp = "^%%%%%% (.*)$",
        process_function = fudge_process
})
