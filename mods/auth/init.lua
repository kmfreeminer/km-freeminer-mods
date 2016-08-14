auth = {}

if core.setting_get("development") and core.setting_getbool("development") then
    if not (core.setting_get("auth_development") and core.setting_getbool("auth_development")) then
        return
    end
end

core.auth_table = {}

local function generate_privileges(user_type)
    local privileges = {}
    privileges.interact = true
    privileges.shout = true
        
    if user_type == "gm" then
        privileges.fly = true
        privileges.fast = true
        privileges.whois = true
        privileges.minimap = true
        privileges.setspawn = true
        privileges.vanish = true
        privileges.privs = true
    end
    
    return privileges
end


local reserved_nick = "admin"
core.auth_table[reserved_nick] = {}
core.auth_table[reserved_nick].password = -1
core.auth_table[reserved_nick].privileges = generate_privileges("gm")

auth.handler = {
	get_auth = function(username)
        assert(type(username) == "string")
        return core.auth_table[username]
	end,
    create_auth = function(username, password)
        assert(type(username) == "string")
        return auth.handler.reload(username)
	end,
	set_privileges = function(username, privileges)
        assert(type(username) == "string")
        assert(username ~= reserved_nick)
		assert(type(privileges) == "table")
        
        -- TODO: implement
        
        assert(auth.handler.reload(username))
	end,
	set_password = function(username, password_hash)
        assert(type(username) == "string")
        assert(username ~= reserved_nick)
		assert(type(password_hash) == "string")
        
        -- TODO: implement
        
        assert(auth.handler.reload(username))
	end,
    reload = function(username)
        assert(type(username) == "string")
        assert(username ~= reserved_nick)

        core.auth_table[username] = nil
             
        local user = database.execute([[
            SELECT `user`.`password_hash` FROM `users` as `user`
            WHERE `user`.`username`='%s'
            LIMIT 1;
        ]], username)()
                
        if not user then
            return false
        end
        
        local active_character = charsheet.get_active_character(username)
        
        if active_character == {} then
            return false
        end
        
        core.auth_table[username] = {}
        core.auth_table[username].password = user.password_hash

        if active_character.privileges then
            core.auth_table[username].privileges = minetest.string_to_privs(active_character.privileges)
        else
            if active_character.class == "ГМ" then
                core.auth_table[username].privileges = generate_privileges("gm")
            else
                core.auth_table[username].privileges = generate_privileges()
            end
        end
        
        core.notify_authentication_modified(username)
        return true
    end
}

core.register_authentication_handler(auth.handler)

core.register_on_leaveplayer(function(player)
    local username = player:get_player_name()
    core.auth_table[username] = nil
end)
