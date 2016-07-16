minetest.register_on_joinplayer(function(player)  
    local username = player:get_player_name()
    local active_character = charlist.get_active_character(username)
    
    local hud_flags = player:hud_get_flags()
    local privileges = minetest.get_player_privs(username)

    hud_flags.minimap = false
    if active_character.class_id == -10 or active_character.class == "ГМ" then
        hud_flags.minimap = true
        -- Privileges
        privileges.whois = true
        privileges.setspawn = true
    end
    player:hud_set_flags(hud_flags)
    minetest.set_player_privs(username, privileges)
end)

