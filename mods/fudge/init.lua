fudge = {}

fudge.default = "плохо"
fudge.levels = {"-","ужасно--","ужасно-","ужасно", "плохо", "посредственно", "нормально", "хорошо", "отлично", "супер", "легендарно", "легендарно+", "легендарно++","как Аллах"}

function fudge.parse_level(unparsed_text)
    local first_word = string.split(string.gsub(unparsed_text, "[,(]", " "), " ")[1]

    for fudge_level_key, fudge_level_orignal in pairs(fudge.levels) do
        if fudge_level_orignal == first_word then
            return fudge_level_key, fudge_level_orignal
        end
    end
    
    return nil
end

function fudge.get_level(fudge_level_key)
    fudge_level_key = math.floor(fudge_level_key)
    if fudge_level_key < 1 then
        fudge_level_key = 1
    elseif fudge_level_key > #fudge.levels then
        fudge_level_key = #fudge.levels
    end
    
    return fudge_level_key, fudge.levels[fudge_level_key]
end

dofile(minetest.get_modpath("fudge").."/fudge_calc.lua")
