stairs = {}

-- Register stairs.
-- Node will be called stairs:stair_<subname>
function stairs.register_stair(subname, recipeitem, groups, images, description, sounds)
    local stair_name = "stairs:stair_" .. subname
    groups.stair = 1

    minetest.register_node(":" .. stair_name, {
        description = description,
        drawtype = "mesh",
        mesh = "stairs_stair.obj",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        is_ground_content = false,
        groups = groups,
        sounds = sounds,
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
                {-0.5, 0, 0, 0.5, 0.5, 0.5},
            },
        },
        collision_box = {
            type = "fixed",
            fixed = {
                {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
                {-0.5, 0, 0, 0.5, 0.5, 0.5},
            },
        },
        on_place = function(itemstack, placer, pointed_thing)
            local param2 = minetest.dir_to_facedir(
                vector.subtract(pointed_thing.above, placer:getpos())
            )

            if placer:get_look_pitch() > 0 then
                param2 = param2 + 20
                if param2 == 21 then
                    param2 = 23
                elseif param2 == 23 then
                    param2 = 21
                end
            end

            return minetest.item_place_node(
                itemstack, placer, pointed_thing, param2
            )
        end,
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            if itemstack:get_name() == "" then
                node.param2 = node.param2 + 1
                minetest.swap_node(pos, node)
                return itemstack
            end
        end,
    })

    if recipeitem then
        minetest.register_craft({
            output = stair_name .. " 8",
            recipe = {
                {recipeitem, "", ""},
                {recipeitem, recipeitem, ""},
                {recipeitem, recipeitem, recipeitem},
            },
        })

        -- Flipped recipe for the silly minecrafters
        minetest.register_craft({
            output = stair_name .. " 8",
            recipe = {
                {"", "", recipeitem},
                {"", recipeitem, recipeitem},
                {recipeitem, recipeitem, recipeitem},
            },
        })
    end
end


-- Register slabs.
-- Node will be called stairs:slab_<subname>

function stairs.register_slab(subname, recipeitem, groups, images, description, sounds)
    groups.slab = 1
    local slab_name = "stairs:slab_" .. subname

    minetest.register_node(":" .. slab_name, {
        description = description,
        drawtype = "nodebox",
        tiles = images,
        paramtype = "light",
        paramtype2 = "facedir",
        is_ground_content = false,
        groups = groups,
        sounds = sounds,
        node_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, 0, 0.5},
        },
        on_place = function(itemstack, placer, pointed_thing)
            -- Upside down or not
            local param2 = nil
            if placer:get_look_pitch() > 0 then
                param2 = 20
            end

            -- If it's being placed on an another similar one,
            -- replace it with a full block
            local under = pointed_thing.under
            local node_under = minetest.get_node(under)
            local above = pointed_thing.above
            local nodename = minetest.get_node(under).name
            local pointed_node_is_upside_down = node_under.param2 >= 20

            if nodename == slab_name
            and (
                (pointed_node_is_upside_down and above.y == under.y - 1)
                or (not pointed_node_is_upside_down and above.y == under.y + 1)
            ) then
                -- Remove the slab
                minetest.remove_node(under)

                -- Make a fake stack of a single item and try to place it
                local fakestack = ItemStack(recipeitem)
                fakestack:set_count(itemstack:get_count())

                --pointed_thing.above = under
                local success = nil
                fakestack, success = minetest.item_place(
                    fakestack, placer, pointed_thing
                )

                -- If the item was taken from the fake stack,
                -- decrement original
                if success then
                    itemstack:set_count(fakestack:get_count())
                -- Else put old node back
                else
                    minetest.set_node(under, slabnode)
                end
                return itemstack
            end

            return minetest.item_place(
                itemstack, placer, pointed_thing, param2
            )
        end,
        on_rightclick = function(pos, node, clicker, itemstack, pointed_thing)
            -- Don't know why, but declaration of this function (even empty)
            -- enable on_place for slabs that are under another slabs.
            if itemstack:get_name() == "" then
                node.param2 = node.param2 + 1
                minetest.swap_node(pos, node)
                return itemstack
            end
        end,
    })

    if recipeitem then
        minetest.register_craft({
            output = slab_name .. " 6",
            recipe = {
                {recipeitem, recipeitem, recipeitem},
            },
        })
    end
    minetest.register_craft({
        type = "shapeless",
        output = recipeitem,
        recipe = {slab_name, slab_name}
    })
end

-- Stair/slab registration function.
-- Nodes will be called stairs:{stair,slab}_<subname>

function stairs.register_stair_and_slab(subname, recipeitem, groups, images,
        desc_stair, desc_slab, sounds)
    stairs.register_stair(subname, recipeitem, groups, images, desc_stair, sounds)
    stairs.register_slab(subname, recipeitem, groups, images, desc_slab, sounds)
end
