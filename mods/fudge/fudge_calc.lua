local function escape_magic(str)
    return string.gsub(str, "[().%+-*?[^$]", "%%%1")
end

function fudge.calculate_fudge(fudge_string)
    fudge_string = string.gsub(fudge_string, "%b\"\"", " %1 ")

    for fudge_level_key, fudge_level in pairs(fudge.levels) do
        fudge_string = string.gsub(fudge_string, escape_magic("\""..fudge_level.."\""), fudge_level_key)
    end

    local calculator = loadstring("return " .. fudge_string)
    if calculator then
        setfenv(calculator, {})
        local status, result = pcall(calculator);
        if not status then
            return nil
        end
        
        return result
    end
    
    return nil;
end

minetest.register_chatcommand("fudge", {
	params = "<fudge_expression>",
	description = "Позволяет сравнивать",
	func = function(name, param)
        local result = fudge.calculate_fudge(param)
        if result then 
            local fudge_key, fudge_level = fudge.get_level(result)
            local result_string = 
                "Число: " .. result .. "\n" ..
                "Валидный индекс: " .. fudge_key .. "\n" ..
                "Fudge-уровень: " .. fudge_level
                
            return true, result_string
        else
            return false, "Ошибка в синтакисе выражения"
        end
 	end,
})

