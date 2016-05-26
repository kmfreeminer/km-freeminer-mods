function fudge.roll(level_key)
    assert(type(level_key)=="number")
    
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
        level_key = level_key + rand
    end
    
    return fudge.validate(level_key, true), signs
end
