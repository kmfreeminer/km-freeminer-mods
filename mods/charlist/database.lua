local enviroment = nil

database = {}
database.null = {
    ["null"] = true
}

database.connection = nil
database.enviroment = nil

function escape(value)
    if type(value) == 'string' then
        value = "'" .. database.connection:escape(value) .. "'"
    elseif type(value) == 'table' then
        if value.null then
            value = "NULL"
        end
    end
    return value
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
    database.enviroment:close()
end

local function rows(connection, sql_statement)
  local cursor = assert (connection:execute (sql_statement))
  return function ()
    return cursor:fetch({}, "a")
  end
end

local function build_condition(where, sql_operator)
    local tmp = "";
    local sql = "("
    for key, value in pairs(where) do 
        if type(value) == "table"  then
            if key == "OR" then
                sql = sql .. build_condition(value, "OR")
            else
                sql = sql .. build_condition(value, "AND")
            end
        else
            sql = sql .. string.format("%s`%s`.`%s`=%s", tmp, "record", key, escape(value))
            tmp = " " .. sql_operator .. " "
        end
    end
    sql = sql .. ")"
    return sql
end

function database.find(table_name, where, limit) 
    local sql = string.format("SELECT * FROM `%s` AS `record`", table_name)
    
    if where then
        sql = sql .. " WHERE "
        sql = sql .. build_condition(where, "AND")
    end
    
    if limit then
        sql = sql .. string.format(" LIMIT %s", limit)
    end
    
    sql = sql .. ";"
    
    minetest.log("verbose", sql)
    return rows(database.connection, sql)
end

return database
