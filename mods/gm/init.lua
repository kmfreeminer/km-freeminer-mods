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
