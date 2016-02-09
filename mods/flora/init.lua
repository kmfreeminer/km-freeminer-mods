flora = {}

function flora.get_generation(pos)
end

minetest.register_node("flora:test_plant", {
    groups = {"plant"},
    drawtype = "plantlike",
    tiles = nil,
    use_texture_alpha = true,

    paramtype = "light",
    sunlight_propagates = true,

    walkable = false,
    buildable_to = true,

    sounds = {
        footstep = nil,
        dig = nil, -- "__group" = group-based sound (default)
        dug = nil,
        place = nil,
    },

    drop = "",

    max_generation = 2,
    grow_check = function () end,
})

minetest.register_abm({
    nodenames = {"group:plant"},
    interval = 10.0,
    chance = 5, -- 1/5
    action = function(pos, node, active_object_count, active_object_count_wider)
    end,
})
