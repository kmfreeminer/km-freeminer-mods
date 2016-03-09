flora = {}

--{{{ Functions
function flora.get_generation(pos)
    local meta = minetest.get_meta(pos)
    return meta:get_int("generation")
end
--}}}

--{{{ register_plant
function flora.register_plant(name, desc)
    if desc.groups ~= nil
    and not minetest.is_yes(desc.groups["plant"])
    then
        desc.groups["plant"] = 1
    end

    description = {
        groups = desc.groups or {plant = 1},
        use_texture_alpha = true,

        drawtype = desc.drawtype or "plantlike",

        paramtype = desc.paramtype or "light",
        sunlight_propagates = desc.sunlight_propagates or true,

        walkable = desc.paramtype or false,
        buildable_to = desc.buildable_to or true,

        drop = desc.drop or "",

        grow = desc.grow or function(pos, node) return true end,
    }
    for k,v in pairs(desc) do
        description[k] = v
    end

    minetest.register_node(name, description)
end
--}}}

--{{{ ABM
minetest.register_abm({
    nodenames = {"group:plant"},
    interval = 1.0,
    chance = 1, -- 1/chance
    action = function(pos, node, active_object_count, active_object_count_wider)
        if default.get_modname(node.name) == "flora" then
            minetest.registered_nodes[node.name].grow(pos, node)
        end
    end,
})
--}}}

--{{{ Registration
flora.register_plant("flora:test_plant", {
    max_generation = 2,

    grow = function (pos, node)
        local gen = flora.get_generation(pos)
        local args = minetest.registered_nodes[node.name]

        if gen < args.max_generation then
            local minp = table.copy(pos)
            minp.x = minp.x - 3
            minp.z = minp.z - 3
            minp.y = minp.y - 3
            local maxp = table.copy(pos)
            maxp.x = maxp.x + 3
            maxp.z = maxp.z + 3
            maxp.y = maxp.y + 3
            local available = minetest.find_nodes_in_area_under_air(minp, maxp, {
                "default:dirt_with_grass",
            })

            local end_c = #available
            for i = 1, end_c do
                local chosen = math.random(#available)
                local new_pos = available[chosen]
                table.remove(available,  chosen)
                new_pos.y = new_pos.y + 1

                local minp = table.copy(new_pos)
                minp.x = minp.x - 1
                minp.z = minp.z - 1
                minp.y = minp.y - 1
                local maxp = table.copy(new_pos)
                maxp.x = maxp.x + 1
                maxp.z = maxp.z + 1
                maxp.y = maxp.y + 1
                plants = minetest.find_nodes_in_area(minp, maxp, {node.name})

                if #plants < 1 then
                    minetest.add_node(new_pos, node)
                    local meta = minetest.get_meta(new_pos)
                    meta:set_int("generation", gen + 1)
                    break
                end
            end
        end
    end
})
--}}}
