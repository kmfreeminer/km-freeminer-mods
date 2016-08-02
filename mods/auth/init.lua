auth = {}
auth.user_data = {}

auth.handler = {
	get_auth = function(username)
        local user = database.execute([[
            SELECT `user`.`password_hash` FROM `users` as `user`
            WHERE `user`.`username`='%s'
            LIMIT 1;
        ]], username)()
        
        if not user then
            return nil
        end
        
        return {
			password = user.password_hash,
			privileges = {}
        }
	end,
    
    create_auth = function(name, password)
        return false
	end,

	set_privileges = function(name, privileges)
        
	end,

	set_password = function(username, password_hash)
        database.execute([[
            UPDATE `users`
            SET    `password_hash` = '%s' 
            WHERE  `users`.`username` = '%s'; 
        ]], password_hash, username)
		return true
	end,

    reload = function()
    
    end
}

core.register_authentication_handler(auth.handler)

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
