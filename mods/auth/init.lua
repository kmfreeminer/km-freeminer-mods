local auth = {}
auth.user_data = {}

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
		assert(type(privileges) == "table")
        
        -- TODO: database.execute, set privileges
        
        assert(auth.handler.reload(username))
	end,
	set_password = function(username, password_hash)
        assert(type(username) == "string")
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
        
        auth.user_data[username] = nil
             
        local user = database.execute([[
            SELECT `user`.`password_hash` FROM `users` as `user`
            WHERE `user`.`username`='%s'
            LIMIT 1;
        ]], username)()
        
        if not user then
            return false
        end
        
        local active_character = charlist.get_active_character(username)
        
        if not active_character then
            return false
        end
        
        auth.user_data[username] = {}
        auth.user_data[username].password = user.password_hash
        auth.user_data[username].privileges = {}
        
        core.notify_authentication_modified(username)
        return true
    end
}

core.register_authentication_handler(auth.handler)

core.register_on_leaveplayer(function(player)
    local username = player:get_player_name()
    auth.user_data[username] = nil
end)

minetest.register_on_joinplayer(function(player)
    local username = player:get_player_name()
    
    local active_character = charlist.get_active_character(username)

    if active_character.class_id == -10 or active_character.class == "ГМ" then
        -- HUD minimap
        local hud_flags = player:hud_get_flags()
        hud_flags.minimap = true
        player:hud_set_flags(hud_flags)

        -- Privileges
        local privileges = minetest.get_player_privs(username)
        privileges.whois = true
        privileges.setspawn = true
        minetest.set_player_privs(username, privileges)
    end
end)
