-- File save/load functions
-- {{
local function file_save(username, data)
    local storage = io.open(charlist.data_folder .. username, "w")
    storage:write(minetest.serialize(data))
    storage:close()
end

local function file_load(username)
    local storage = io.open(charlist.data_folder ..username, "r")
    
    if not storage then
        return nil
    end
    
    local result = minetest.deserialize(storage:read("*all"))
    if type(result) ~= "table" then
        return nil
    end
    
    storage:close()
    
    charlist.data[username] = result
end
-- }}

-- Server load function
-- {{
local function server_load(httpenv, username)
    local url = string.gsub(charlist.user_get_url, "{{username}}", username)
    if httpenv then
        httpenv.fetch({ url = url, timeout = 2 }, 
            function(result)
                if result.succeeded then
                    local fetched_data = minetest.parse_json(result.data)
                    if type(fetched_data) == "table" then
                        charlist.data[username]["name"]   = fetched_data["name"]
                        charlist.data[username]["quenta"] = fetched_data["quenta"]
                        charlist.data[username]["skills"] = fetched_data["skills"]
                    end
                end
            end)
    else
        minetest.log("error", "Unable to get HTTPApiTable, maybe you should add secure.trusted_mods = roleplay or secure.http_mods = roleplay to your .conf file")
    end
end
-- }}

function charlist.load_data(httpenv, username)
    charlist.data[username] = {}
    charlist.data[username].skills = {}
    charlist.data[username].wounds = {}

    file_load(username)
    charlist.data[username].color = "AAAAAA"
    server_load(httpenv, username)
end

function charlist.save_data(username, data)
    file_save(username, data)
    charlist.data[username] = nil
end
