DummyConnection = {}

function DummyConnection:new()
    local tmp = {}
    setmetatable(tmp, self)
    self.__index = self
    return tmp
end

function DummyConnection:execute()
    return nil
end

function DummyConnection:escape(data)
    return data
end

function DummyConnection:close() 
end
