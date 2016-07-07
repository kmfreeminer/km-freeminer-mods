hunger = {}

hunger.MAX = 8*60*60*100
hunger.conf = {
    -- Order is important
    [1] = {bound = 1*60*60*100, timer_limit = 5*60*100, text = "Вы очень голодны."},
    [2] = {bound = 3*60*60*100, timer_limit = 20*60*100, text = "Вы немного голодны."},
    [3] = {bound = 7*60*60*100, timer_limit = -1, text = "Вы сыты."},
    [4] = {bound = 8*60*60*100, timer_limit = -1, text = "Вы очень сыты."},
}
hunger.timers = {}

function hunger.need_to_take(playername)
    if minetest.check_player_privs(playername, {["don't starve"] = true})
    or minetest.get_player_by_name(playername):is_chat_opened()
    then
        return false
    else
        return true
    end
end

function hunger.set(player, count)
    local inv = player:get_inventory()
    inv:set_stack("hunger", 1,
        ItemStack({
            name = "hunger:counter",
            count = 1,
            metadata = count
        })
    )
    return tonumber(inv:get_stack("hunger", 1):get_metadata())
end

function hunger.get(player)
    local inv = player:get_inventory()
    local counter = inv:get_stack("hunger", 1)

    if not counter:get_name() then
        inv:set_size("hunger", 1)
        hunger.set(player, hunger.MAX)
        return inv:get_stack("hunger", 1):get_metadata()
    end

    return counter:get_metadata()
end

function hunger.take(player)
    local inv = player:get_inventory()
    local count = tonumber(inv:get_stack("hunger", 1):get_metadata())
    count = count - 1
    return hunger.set(player, count)
end

function hunger.state(count)
    for index, state in  ipairs(hunger.conf) do
        if count > state.bound then
            return state
        end
    end
end

minetest.register_globalstep(function(dtime)
    for k, player in pairs(minetest.get_connected_players()) do
        local name = player:get_player_name()
        if hunger.need_to_take(name) then
            local count = hunger.take(player)
            local state = hunger.state(count)

            if state then
                local timer = hunger.timers[name] or 0
                timer = timer - 1
                if timer < 0 then
                    hunger.timers[name] = state.timer_limit
                elseif timer == 0 then
                    hunger.timers[name] = state.timer_limit
                    minetest.chat_send_player(name, state.text)
                    if state.callback then state.callback() end
                else
                    hunger.timers[name] = timer
                end
            end

        end
    end
end)

minetest.register_craftitem("hunger:counter", {})

minetest.register_privilege("don't starve", {
    description = "Не снижать значение сытости игрока",
})

minetest.register_on_joinplayer(function(player)
    local inv = player:get_inventory()
    if not inv:get_list("hunger") then
        inv:set_size("hunger", 1)
        hunger.set(player, hunger.MAX)
    end
end)
