database = {}

function database_init()
    local env = require("luasql.sqlite3").sqlite3()
    database.connection = env:connect(minetest.get_modpath("database") .. "/database.sqlite")
end

if pcall(database_init) then    
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
else
    minetest.log("error", "Unable to initialize database. Please, install \"luasql.sqlite3\".")
    minetest.log("error", "Creating dummy database functions.")

    function database.execute()
        return function()
            return {}
        end
    end
    
    function database.stop() end
end
