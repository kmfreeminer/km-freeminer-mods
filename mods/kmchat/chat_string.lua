ChatString = {}

function ChatString:new()
    local tmp = {}
    setmetatable(tmp, self)
    self.__index = self
    self.variables = {}
    return tmp
end

function ChatString:set_format_string(format_string)
    self.tokens = {}
    local begin = 0
    local finish = 0
    repeat
        finish = begin
        local new_begin, new_finish, variable = string.find(format_string, "{{(.-)}}", begin)
        if new_begin then
            if new_begin ~= begin + 1 then
                table.insert(self.tokens, { ["text"] = string.sub(format_string, begin + 1, new_begin - 1) })
            end
            table.insert(self.tokens, { ["variable_name"] = string.trim(variable) })
        end
        begin = new_finish
    until not begin
    
    if finish ~= #format_string then
        table.insert(self.tokens, { ["text"] = string.sub(format_string, finish + 1, #format_string) })
    end
end

function ChatString:set_base_color(color)
    self.color = color
end

function ChatString:set_variable(variable_name, variable_value, color)
    assert(type(variable_name) == "string")
    self.variables[variable_name] = {}
    self.variables[variable_name].value = variable_value
    self.variables[variable_name].color = color
end

function ChatString:build(base_color)
    if base_color == nil then
        base_color = self.color
    end
    
    local result = ""
    for _, part in pairs(self.tokens) do
        local text = ""
        local color = ""
        
        if part.variable_name then
            local variable = self.variables[part.variable_name] or {}
            text = variable.value or "undefined"
            color = variable.color or base_color
        elseif part.text  then
            text = part.text
            color = base_color
        end
        
        if base_color then
            text = core.colorize(color, text)
        end
        
        result = result .. text
    end
    
    return result;
end
