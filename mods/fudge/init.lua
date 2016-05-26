fudge = {}

function fudge.validate(level_key, is_result)
    print(level_key)
    assert(type(level_key) == "number")
    
    if is_result == nil then
        is_result = false
    end
    assert(type(is_result) == "boolean")
    
    math.floor(level_key)
    
    local min_level = fudge.min_level
    local max_level = fudge.max_level
    
    local info = nil
    
    if is_result then
        min_level = 0
        max_level = #fudge.levels
    else
        min_level = fudge.min_level
        max_level = fudge.max_level
    end
    
    if level_key < fudge.min_level then
        return fudge.min_level, "min"
    end
    
    if level_key > fudge.max_level then
        return fudge.max_level, "max"
    end
    
    return level_key, nil
end

function fudge.to_number(level_text) 
    for fudge_level_key, fudge_level_orignal in pairs(fudge.levels) do
        if fudge_level_orignal == level_text then
            return fudge_level_key, fudge_level_orignal
        end
    end
    return nil
end

function fudge.to_string(level_key)
    assert(type(level_key) == "number")
    
    local level_text = fudge.levels[level_key]
    assert(level_text, "Уровень не найден")
    
    return level_text
end

function fudge.parse(unparsed_text)
    local first_word = string.split(string.gsub(unparsed_text, "[,(]", " "), " ")[1]
    
    local level_key = fudge.to_number(first_word)
    if not level_key then
        return nil
    end
    
    return level_key
end

fudge.levels = {"-","ужасно--","ужасно-","ужасно", "плохо", "посредственно", "нормально", "хорошо", "прекрасно", "превосходно", "легендарно", "легендарно+", "легендарно++","как Аллах"}

fudge.default   = fudge.to_number("плохо")      or math.floor(#fudge.levels / 2)
fudge.min_level = fudge.to_number("ужасно")     or 0
fudge.max_level = fudge.to_number("легендарно") or #fudge.levels

dofile(minetest.get_modpath("fudge").."/fudge_calculate.lua")
dofile(minetest.get_modpath("fudge").."/fudge_roll.lua")

