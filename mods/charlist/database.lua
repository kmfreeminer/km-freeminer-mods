local enviroment = nil

database = {}
database.null = {
    ["null"] = true
}

database.connection = nil
database.enviroment = nil

function escape(value)
    if type(value) == 'string' then
        return "'" .. value .. "'"
    elseif type(value) == 'table' then
        if value.null then
            return "NULL"
        end
    end
    
    return value
end

function escape2(value)
    return "`" .. value .. "`"
end


function database.init(definition)
    if definition.type == "sqlite" then
        assert(definition.path)
        local sqlite3 = require "luasql.sqlite3"
        database.enviroment = sqlite3.sqlite3();
        
        database.connection = database.enviroment:connect(definition.path)
        return true
    end
    
    if definition.type == "mysql" then
        local mysql = require "luasql.mysql"
        database.enviroment = mysql.mysql();
        
        database.connection = database.enviroment:connect(definition.database, definition.user, definition.password)
        return true
    end
    
    return false;
end

function database.stop()
    database.connection:close()
    env:close()
end

function database.find(table_name, where, limit) 
    local sql = "SELECT * FROM " .. escape2(table_name) .. " AS " .. escape2("record") 
    
    if where then
        sql = sql .. " WHERE "
        local tmp = "";
        for key, value in pairs(where) do 
            sql = sql .. tmp .. escape2("record") .. "." .. escape2(key)  .. "=" .. escape(value)
            tmp = " AND "
        end
    end
    
    if limit then
        sql = sql .. string.format(" LIMIT %s", limit)
    end
    sql = sql .. ";"
    return database.connection:execute(sql)
end

return database
