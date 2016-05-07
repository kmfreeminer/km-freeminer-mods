creative = {}

creative.DIG_TIME = 0.5
creative.creative_inventory_size = 0

minetest.register_privilege("creative", "Creative game mode.")

-- {{{ Creative inventory
-- Create detached creative inventory after loading all mods
minetest.after(0, function()
    local inv = minetest.create_detached_inventory("creative", {
        allow_move = function(inv, from_list, from_index, to_list, to_index, count, player)
            local name = player:get_player_name()
            if minetest.check_player_privs(name, {creative = true}) then
                return count
            else
                return 0
            end
        end,
        allow_put = function(inv, listname, index, stack, player)
            return 0
        end,
        allow_take = function(inv, listname, index, stack, player)
            local name = player:get_player_name()
            if minetest.check_player_privs(name, {creative = true}) then
                return -1
            else
                return 0
            end
        end,
        on_move = function(inv, from_list, from_index, to_list, to_index, count, player)
        end,
        on_put = function(inv, listname, index, stack, player)
        end,
        on_take = function(inv, listname, index, stack, player)
            --print(player:get_player_name().." takes item from creative inventory; listname="..dump(listname)..", index="..dump(index)..", stack="..dump(stack))
            if stack then
                minetest.log("action", player:get_player_name().." takes "..dump(stack:get_name()).." from creative inventory")
                --print("stack:get_name()="..dump(stack:get_name())..", stack:get_count()="..dump(stack:get_count()))
            end
        end,
    })
    local creative_list = {}
    for name,def in pairs(minetest.registered_items) do
        if (not def.groups.not_in_creative_inventory or def.groups.not_in_creative_inventory == 0)
                and def.description and def.description ~= "" then
            table.insert(creative_list, name)
        end
    end
    table.sort(creative_list)
    inv:set_size("main", #creative_list)
    for _,itemstring in ipairs(creative_list) do
        inv:add_item("main", ItemStack(itemstring))
    end
    creative.creative_inventory_size = #creative_list
end)

-- Create the trash field
local trash = minetest.create_detached_inventory("creative_trash", {
    -- Allow the stack to be placed and remove it in on_put()
    -- This allows the creative inventory to restore the stack
    allow_put = function(inv, listname, index, stack, player)
        local name = player:get_player_name()
        if minetest.check_player_privs(name, {creative = true}) then
            return stack:get_count()
        else
            return 0
        end
    end,
    on_put = function(inv, listname, index, stack, player)
        inv:set_stack(listname, index, "")
    end,
})
trash:set_size("main", 1)
--}}}

minetest.register_on_punchnode(function (pos, node, puncher, pointed_thing)
    local name = puncher:get_player_name()
    if minetest.check_player_privs(name, {creative = true}) then
        minetest.after(creative.DIG_TIME, function (pos, digger)
            minetest.dig_node(pos)
        end, pos, puncher)
    end
end)

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack)
    local name = placer:get_player_name()
    return minetest.check_player_privs(name, {creative = true})
end)
