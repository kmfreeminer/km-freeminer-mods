minetest.register_on_joinplayer(function(player)  
    local username = player:get_player_name()
    local active_character = charlist.get_active_character(username)
    if active_character.class_id == -10 or active_character.class == "ГМ" then
        local privileges = minetest.get_player_privs(username)
        -- TODO: Grant privileges
        privileges.whois = true
        minetest.set_player_privs(username, privileges)
    end
end)

