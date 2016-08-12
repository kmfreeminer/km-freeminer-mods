if core.setting_get("development") and core.setting_getbool("development") then
    if not (core.setting_get("auth_development") and core.setting_getbool("auth_development")) then
        return
    end
end

local auth = {}
auth.user_data = {}

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
    end
    
    return privileges
end

local reserved_nick = "admin"
auth.user_data[reserved_nick] = {}
auth.user_data[reserved_nick].password = -1
auth.user_data[reserved_nick].privileges = generate_privileges("gm")

auth.handler = {
	get_auth = function(username)
        assert(type(username) == "string")
        return auth.user_data[username]
	end,
    create_auth = function(username, password)
        assert(type(username) == "string")
        return auth.handler.reload(username)
	end,
	set_privileges = function(username, privileges)
        assert(type(username) == "string")
        assert(username ~= reserved_nick)
		assert(type(privileges) == "table")
        
        -- TODO: database.execute, set privileges
        
        assert(auth.handler.reload(username))
	end,
	set_password = function(username, password_hash)
        assert(type(username) == "string")
        assert(username ~= reserved_nick)
		assert(type(password_hash) == "string")
        
        database.execute([[
            UPDATE `users`
            SET    `password_hash` = '%s' 
            WHERE  `users`.`username` = '%s'; 
        ]], password_hash, username)
        
        assert(auth.handler.reload(username))
	end,
    reload = function(username)
        assert(type(username) == "string")
        assert(username ~= reserved_nick)

        auth.user_data[username] = nil
             
        local user = database.execute([[
            SELECT `user`.`password_hash` FROM `users` as `user`
            WHERE `user`.`username`='%s'
            LIMIT 1;
        ]], username)()
        
        if not user then
            return false
        end
        
        local active_character = charsheet.get_active_character(username)
        
        if not active_character then
            return false
        end
        
        auth.user_data[username] = {}
        auth.user_data[username].password = user.password_hash
        
        if not active_character.privileges then
            if active_character.class == "ГМ" then
                auth.user_data[username].privileges = generate_privileges("gm")
            else
                auth.user_data[username].privileges = generate_privileges()
            end
        else
            auth.user_data[username].privileges = {}
        end
        
        core.notify_authentication_modified(username)
        return true
    end
}

core.register_authentication_handler(auth.handler)

core.register_on_leaveplayer(function(player)
    local username = player:get_player_name()
    auth.user_data[username] = nil
end)
