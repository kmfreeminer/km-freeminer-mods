ChatString = {}

function ChatString:new()
    tmp = {}
    setmetatable(tmp, self)
    self.__index = self

    self.variables = {}
    self.build = {}
    
    return tmp
end

function ChatString:setFormatString(format_string)
    self.build = {}
    local begin = 0
    local finish = 0
    repeat
        finish = begin
        local new_begin, new_finish, variable = string.find(format_string, "{{(.-)}}", begin)
        if new_begin then
            if new_begin ~= begin + 1 then
                table.insert(self.build, { ["text"] = string.sub(format_string, begin + 1, new_begin - 1) })
            end
            table.insert(self.build, { ["variable"] = string.trim(variable) })
        end
        begin = new_finish
    until not begin
    
    if finish ~= #format_string then
        table.insert(self.build, { ["text"] = string.sub(format_string, finish + 1, #format_string) })
    end

end

function ChatString:setVariable(variableName, variableValue, color)
    self.variables[variableName] = {}
    self.variables[variableName].value = variableValue
    self.variables[variableName].color = color
end

function ChatString:get(base_color)
    local tmp = ""
    for _, part in pairs(self.build) do
        local text = ""
        local color = ""
        
        if part.variable then
            self.variables[part.variable] = self.variables[part.variable] or {}
            text = self.variables[part.variable].value or "undefined"
            color = self.variables[part.variable].color or base_color
        elseif part.text  then
            text = part.text
            color = base_color
        end
        
        if base_color then
            text = core.colorize(color, text)
        end
        
        tmp = tmp .. text
    end
    return tmp;
end
