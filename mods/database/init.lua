database = {}

dofile(minetest.get_modpath("database").."/dummy_connection.lua")

function database_init()
    local db   = minetest.setting_get("database_type") or "sqlite3"
    local name = minetest.setting_get("database_name") or "database.sqlite"
    local user = minetest.setting_get("database_user") or nil
    local pass = minetest.setting_get("database_pass") or nil
    local host = minetest.setting_get("database_host") or nil
    local port = minetest.setting_get("database_port") or nil

    if db == "sqlite3" then
        local path = minetest.get_modpath("database") .. "/" .. name
        local env = require("luasql.sqlite3").sqlite3()
        database.connection = env:connect(path)
    elseif db == "postgres" then
        local env = require("luasql.postgres").postgres()
        database.connection = env:connect(name, user, pass, host, port)
    else
        error("Unable to define database type.")
    end
    
    if not database.connection then
        error("Unable to connect.")
    end
end

function database_init_error(err)
    minetest.log("error",
        "Database initializtion error.\n" ..
        "Reason: " .. err
    )
    
    minetest.log("error", "Creating dummy connection.")
    database.connection = DummyConnection:new()
end

xpcall(database_init, database_init_error)

function database.execute(sql, ...)
    local tmp
    
    -- Escape arguments
    tmp = {}
    for _, binding in pairs({...}) do
        table.insert(tmp, database.connection:escape(binding))
    end
    
    sql = string.format(sql, unpack(tmp))
    local cursor = database.connection:execute(sql)
    
    -- Status
    if type(cursor) == "number" then
        return cursor
    end
    
    -- Fetch data and close cursor
    tmp = {}
    if cursor then
        local data
        repeat
            data = cursor:fetch({}, "a")
            table.insert(tmp, data)
        until not data
    end
    
    -- Return iterator
    local i = 0
    return function()
        i = i + 1
        return tmp[i]
    end
end

function database.stop()
    database.connection:close()
end
