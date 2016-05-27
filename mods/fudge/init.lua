fudge = {}

local levels = {"хуже некуда","ужасно---" , "ужасно--","ужасно-","ужасно", "плохо", "посредственно", "нормально", "хорошо", "прекрасно", "превосходно", "легендарно", "легендарно+", "легендарно++", "легендарно+++", "как Аллах"}

local levels_tmp = {}
for key, level in pairs(levels) do
    levels_tmp[level] = key
end

function fudge.to_number(level_text) 
    --for fudge_level_key, fudge_level_orignal in pairs(levels) do
        --if fudge_level_orignal == level_text then
            --return fudge_level_key
        --end
    --end
    return levels_tmp[level_text]
end

function fudge.to_string(level_key)
    assert(type(level_key) == "number")
    
    local level_text = levels[level_key]
    assert(level_text, "Уровень не найден")
    
    return level_text
end

function fudge.normalize(level_key)
    assert(type(level_key) == "number")
    
    level_key = math.floor(level_key)
    if level_key < fudge.min_level then
        return fudge.min_level
    end
    
    if level_key > fudge.max_level then
        return fudge.max_level
    end
    
    return level_key
end

function fudge.roll()    
    local dices = {}
    for i = 1, 4 do
        table.insert(dices, math.random(-1, 1))
    end
    return dices
end

function fudge.dices_to_string(dices)
    local signs = ""
    for _, value in pairs(dices) do
        if value > 0 then
            signs = signs .. "+"
        elseif value < 0 then
            signs = signs .. "-"
        else
            signs = signs .. "="
        end
    end
    return signs
end

function fudge.calculate(level_key, modifiers)
    for _, value in pairs(modifiers) do
        level_key = level_key + value
    end
    return level_key
end

fudge.default   = fudge.to_number("плохо")
fudge.min_level = fudge.to_number("ужасно")
fudge.max_level = fudge.to_number("легендарно")
