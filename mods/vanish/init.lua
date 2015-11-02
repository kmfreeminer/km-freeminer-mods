vanish = {}
vanish.is_vanished = {}

minetest.register_privilege("vanish", "Allow to use /vanish command")

minetest.register_chatcommand("vanish", {
    params = "",
    description = "Make user invisible",
    privs = {vanish = true},
    func = function(name, param)
        local player = minetest.get_player_by_name(name)

        -- Toggle vanish
        vanish.is_vanished[name] = not vanish.is_vanished[name]
        
        if vanished_players[name] then
            -- Hide model
            player:set_properties({
                visual_size = {x = 0,y = 0},
                collisionbox = {0, 0, 0, 0, 0, 0,},
            })
            -- Hide nickname
            player:set_nametag_attributes({color = 0x00000000})
        else 
            -- Show model
            player:set_properties({
                -- default player size
                visual_size = {x = 1,y = 1},
                collisionbox = {-0.35, -1, -0.35, 0.35, 1, 0.35},
            })
            -- Show nickname
            player:set_nametag_attributes({color = 0xFFFFFFFF})
        end
    end
})
