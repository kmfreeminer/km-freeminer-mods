vanish = {}
vanish.is_vanished = {}

vanish.set = function(player, is_vanished)
    if is_vanished then
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
        player:set_nametag_attributes({color =
            {a = default.nametag_alpha, r = 255, g = 255, b = 255}
        })
    end
end

minetest.register_privilege("vanish", "Allow to use /vanish command")

minetest.register_chatcommand("vanish", {
    params = "",
    description = "Make user invisible",
    privs = {vanish = true},
    func = function(name, param)
        -- Toggle vanish
        vanish.is_vanished[name] = not vanish.is_vanished[name]
        local state = vanish.is_vanished[name]

        vanish.set(
            minetest.get_player_by_name(name),
            state
        )
        if state then
            return true, "You are vanished now."
        else
            return true, "You are visible now."
        end
    end
})

minetest.register_on_joinplayer(function(player)
    local name = player:get_player_name()
    local state = vanish.is_vanished[name]

    vanish.set(player, state)

    if state then
        minetest.chat_send_player(name, "You are vanished.")
    end
end)
