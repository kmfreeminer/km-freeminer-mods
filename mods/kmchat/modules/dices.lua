-- d4, d10 and etc.
kmchat.register_chat_pattern({
        regexp = "^d(%d+).*",
        
        init_process_function = function(event)
            local sender = event.sender;              
              
            local range_label = kmchat.config.ranges.getLabel(event.range_delta)
            
            local dice = event.substrings[1]
            if dice=="4" or dice=="6" or dice=="8" or dice=="10" or dice=="12" or dice=="20" then
                local dice_result = math.random(dice)
                
                return string.format("*** %s%s кидает d%s и выкидывает %s ***", kmchat.get_prefixed_username(sender), range_label, dice, dice_result)
            end
            
            return nil
        end,
        
        color = kmchat.config.dice_color
})

-- fudge dices
local fudge_levels = {"-","ужасно--","ужасно-","ужасно", "плохо", "посредственно", "нормально", "хорошо", "отлично", "супер", "легендарно", "легендарно+", "легендарно++","как Аллах"}

local function fudge_process(event)
    local sender = event.sender;              
              
    local range_label = kmchat.config.ranges.getLabel(event.range_delta)
    
    local fudge_dice_tmp = event.substrings[1]
    
    local words = {}
    for word in string.gmatch(fudge_dice_tmp, "%S+") do
        table.insert(words, word)
    end
    
    for key, val in pairs(fudge_levels) do
        if val == words[1] then
            local fudge_level = words[1]
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
            elseif fudge_level_key>#fudge_levels then
                fudge_level_key = #fudge_levels
            end
            
            local dice_result = fudge_levels[fudge_level_key]

            return string.format("*** %s%s кидает 4df (%s) от %s и выкидывает %s ***", kmchat.get_prefixed_username(sender), range_label, signs, fudge_level, dice_result)
        end
    end
    return nil
end

kmchat.register_chat_pattern({
        regexp = "^4d[Ff] (.*)$",
        init_process_function = fudge_process,
        color = kmchat.config.dice_color
})

kmchat.register_chat_pattern({
        regexp = "^%%%%%% (.*)$",
        init_process_function = fudge_process,
        color = kmchat.config.dice_color
})
