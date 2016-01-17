hunger = {}

hunger.MAX = 5000
hunger.conf = {
    [1] = {1000, 60, "Вы очень голодны."},
    [2] = {3000, 600, "Вы немного голодны."},
    [3] = {4000, -1, "Вы сыты."}
}

function hunger.need_to_take(player)
    return true
end

function hunger.get(player)
    local inv = player:get_inventory()
    local hunger = inv:get_stack("hunger", 1)

    if not hunger.name then
        inv:set_size("hunger", 1)
        inv:set_stack("hunger", 1, ItemStack("hunger:count " .. hunger.MAX))
        return inv:get_stack("hunger", 1).count
    end

    return hunger.count
end

minetest.register_globalstep(function(dtime)
    for k, player in pairs(minetest.get_connected_players()) do
        print(hunger.get(player))
    end
end)
