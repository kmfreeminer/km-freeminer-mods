roleplay = {}

local user_skill_get_url = "http://pastebin.com/raw/EsHgzJMu" -- testing url

local data_folder = minetest.get_modpath("roleplay").."/data/"
local httpenv = core.request_http_api()

dofile(minetest.get_modpath("roleplay").."/skills.lua")
dofile(minetest.get_modpath("roleplay").."/wounds.lua")

function roleplay.skills.fetch_data(username, callback)
    assert(type(callback) == "function")

    local url = string.gsub(user_skill_get_url, "{{nick}}", username)

    if httpenv then
        httpenv.fetch({ url = url, timeout = 2 }, 
            function(result)
                local skills = {}
                if result.succeeded then
                    local skills_tmp = minetest.parse_json(result.data)
                    
                    if type(skills_tmp) == "table" then
                        skills = skills_tmp
                    end
                end
                
                callback(skills)
            end)
    else
        minetest.log("error", "Unable to get HTTPApiTable, maybe you should add secure.trusted_mods = roleplay or secure.http_mods = roleplay to your .conf file")
        callback({})
    end
end
