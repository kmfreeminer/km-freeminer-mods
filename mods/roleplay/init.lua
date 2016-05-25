roleplay = {}

data_folder = minetest.get_modpath("roleplay").."/data/"

function roleplay.save(filename, data)
    local storage = io.open(data_folder .. filename, "w")
    storage:write(minetest.serialize(data))
    storage:close()
end

function roleplay.load(filename)
    local storage = io.open(data_folder ..filename, "r")
    
    if not storage then
        return nil
    end
    
    local result = minetest.deserialize(storage:read("*all"))
    if type(result) ~= "table" then
        return nil
    end
    
    storage:close()
    
    return result
end

dofile(minetest.get_modpath("roleplay").."/skills.lua")
dofile(minetest.get_modpath("roleplay").."/wounds.lua")
