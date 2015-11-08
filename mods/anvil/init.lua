anvil = {}

anvil.formspec = function (pos)
	local spos = pos.x .. "," .. pos.y .. "," .. pos.z
    return
        "size[" ..inventory.width.. "," ..(inventory.height + 3).. "]" ..
        default.gui_bg..
        default.gui_bg_img..
        default.gui_slots..
        "list[nodemeta:" .. spos .. ";src;2,0;3,3;]" ..
        "image[5,1;1,1;gui_furnace_arrow_bg.png^[transformR270]" ..
        "list[nodemeta:" .. spos .. ";dst;6,1;1,1;]" ..
        inventory.main(0, 3.2) ..
        "listring[nodemeta:" .. spos .. ";dst]" ..
        "listring[current_player;main]" ..
        "listring[nodemeta:" .. spos .. ";src]" ..
        "listring[current_player;main]"
end

anvil.contains_metals = function (invlist)
    for k, itemstack in ipairs(invlist) do
        if itemstack:sub(1, itemstack:find(":") - 1) == "metals"
        or minetest.get_item_group(itemstack:get_name(), "metal") > 0 then
            return true
        end
    end

    return false
end

--{{{ Functions
anvil.craft_predict = function(pos, player)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local craftlist = inv:get_list("src")

    local output, decr_input = minetest.get_craft_result({
        method = "normal",
        width = inv:get_width("src") or 3,
        items = craftlist
    })

    if output.item:get_name() ~= "" and output.time == 0 then
        if anvil.contains_metals(craftlist) then
            local hammer = player:get_wielded_item()
            local hammer_level = minetest.get_item_group(hammer, "level")
            local output_level = minetest.get_item_group(output.item, "level")

            if hammer_level >= output_level - 1 then
                inv:set_stack("dst", 1, output.item)
            else
                inv:set_stack("dst", 1, nil)
            end
        else
            inv:set_stack("dst", 1, output.item)
        end
    else
        inv:set_stack("dst", 1, nil)
    end
end

anvil.craft = function (pos, player)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local craftlist = inv:get_list("src")

    local output, decr_input = minetest.get_craft_result({
        method = "normal",
        width = inv:get_width("src") or 3,
        items = craftlist
    })

    if anvil.contains_metals(craftlist) then
        local hammer = player:get_wielded_item()
        local hammer_level = minetest.get_item_group(hammer, "level")
        local output_level = minetest.get_item_group(output.item, "level")
        local uses = minetest.get_item_group(hammer, "uses")

        inv:set_list("src", decr_input.items)

        local leveldiff = hammer_level - output_level
        if leveldiff == -1 then leveldiff = 0 end
        hammer:add_wear(65535/(uses*3^leveldiff)) -- CHECK IN SOURCE
        player:set_wielded_item(hammer)
    else
        inv:set_list("src", decr_input.items)
    end
end

anvil.register = function (material, anvil_def)
    local material_name = material:sub(material:find(":") + 1)

    minetest.register_node("anvil:" .. material_name, {
        description = anvil_def.description or "Накавайня",
        tiles = {
            "anvil_" .. material_name .. "_top.png",
            "anvil_" .. material_name .. "_top.png",
            "anvil_" .. material_name .. "_side.png"},
        drawtype = "nodebox",
        paramtype = "light",
        paramtype2 = "facedir",
        node_box = {
            type = "fixed",
            fixed = {
                {-0.5,-0.5,-0.3,0.5,-0.4,0.3},
                {-0.35,-0.4,-0.25,0.35,-0.3,0.25},
                {-0.3,-0.3,-0.15,0.3,-0.1,0.15},
                {-0.35,-0.1,-0.2,0.35,0.1,0.2},
            },
        },
        selection_box = {
            type = "fixed",
            fixed = {
                {-0.5,-0.5,-0.3,0.5,-0.4,0.3},
                {-0.35,-0.4,-0.25,0.35,-0.3,0.25},
                {-0.3,-0.3,-0.15,0.3,-0.1,0.15},
                {-0.35,-0.1,-0.2,0.35,0.1,0.2},
            },
        },
        groups = anvil_def.groups or
            {oddly_breakable_by_hand = 2, falling_node = 1, dig_immediate = 1},
        sounds = anvil_def.sounds or
            default.node_sound_stone_defaults(),

        -- can_dig = function(pos,player) -- TODO
        -- end,
        on_construct = function(pos)
            local meta = minetest.get_meta(pos)
            local inv = meta:get_inventory()
            inv:set_size("src", 9)
            inv:set_width("src", 3)
            inv:set_size("dst", 1)
        end,
        on_rightclick = function (pos, node, clicker, itemstack, pointed_thing)
            if minetest.get_item_group(itemstack, "hammer") > 0 then
                minetest.show_formspec(
                    clicker:get_player_name(),
                    "anvil:" .. material_name,
                    anvil.formspec(pos)
                )
                return itemstack
            end
            return itemstack
        end,

        allow_metadata_inventory_put =
            function (pos, listname, index, stack, player)
                if listname == "dst" then
                    return 0
                else
                    return stack:get_count()
                end
            end,
        allow_metadata_inventory_move = 
            function (pos, from_list, from_index, to_list, to_index, count, player)
                if to_list == "dst" then
                    return 0
                else
                    return count
                end
            end,

        on_metadata_inventory_move =
            function (pos, from_list, from_index, to_list, to_index, count, player)
                anvil.craft_predict(pos, player)
            end,
        on_metadata_inventory_put =
            function (pos, listname, index, stack, player)
                anvil.craft_predict(pos, player)
            end,
        on_metadata_inventory_take =
            function (pos, listname, index, stack, player)
                if listname == "src" then
                    anvil.craft_predict(pos, player)
                elseif listname == "dst" then
                    anvil.craft(pos, player)
                end
            end,
    })

    if material:sub(1, material:find(":") - 1) == "metals" then
        material = material .. "_ingot"
    end
    minetest.register_craft({
        output = "anvil:" .. material_name,
        recipe = {
            { material, material, material },
            {""       , material, ""       },
            { material, material, material },
        }
    })
end
--}}}

--{{{ Anvils registrations
anvil.register("default:stone", {})
anvil.register("metals:bronze", {})

local anvils = {
    {'stone', 'Stone', 0, 61*2.3},
    {'desert_stone', 'Desert Stone', 0, 61*2.3},
    {'copper', 'Copper', 1, 411*2.3},
    {'bronze', 'Bronze', 2, 601*2.3},
    {'wrought_iron', 'Wrought Iron', 3, 801*2.3},
    {'steel', 'Steel', 4, 1101*2.3},
}
--}}}

--{{{ Crafts

--for i, metal in ipairs(metals.list) do
--    realtest.register_anvil_recipe({
--        item1 = "metals:"..metal.."_unshaped",
--        output = "metals:"..metal.."_ingot",
--        material = metal,
--    })
--    realtest.register_anvil_recipe({
--        item1 = "metals:"..metal.."_sheet",
--        item2 = "scribing_table:plan_bucket",
--        rmitem2 = false,
--        output = "instruments:bucket_"..metal,
--        level = metals.levels[i],
--        material = metal,
--    })
--    realtest.register_anvil_recipe({
--        item1 = "metals:"..metal.."_doubleingot",
--        output = "metals:"..metal.."_sheet",
--        level = metals.levels[i] - 1,
--        material = metal,
--    })
--    realtest.register_anvil_recipe({
--        item1 = "metals:"..metal.."_doubleingot",
--        output = "metals:"..metal.."_ingot 2",
--        level = metals.levels[i] - 1,
--        instrument = "chisel",
--        material = metal,
--    })
--    realtest.register_anvil_recipe({
--        item1 = "metals:"..metal.."_doublesheet",
--        output = "metals:"..metal.."_sheet 2",
--        level = metals.levels[i] - 1,
--        instrument = "chisel",
--        material = metal,
--    })
--    realtest.register_anvil_recipe({
--        type = "weld",
--        item1 = "metals:"..metal.."_ingot",
--        item2 = "metals:"..metal.."_ingot",
--        output = "metals:"..metal.."_doubleingot",
--        level = metals.levels[i] - 1,
--        material = metal,
--    })
--    realtest.register_anvil_recipe({
--        type = "weld",
--        item1 = "metals:"..metal.."_sheet",
--        item2 = "metals:"..metal.."_sheet",
--        output = "metals:"..metal.."_doublesheet",
--        level = metals.levels[i] - 1,
--        material = metal,
--    })
--    realtest.register_anvil_recipe({
--        item1 = "metals:"..metal.."_ingot",
--        item2 = "scribing_table:plan_lock",
--        rmitem2 = false,
--        output = "metals:"..metal.."_lock",
--        level = metals.levels[i],
--        material = metal,
--    })
--    realtest.register_anvil_recipe({
--        item1 = "metals:"..metal.."_ingot",
--        item2 = "scribing_table:plan_hatch",
--        rmitem2 = false,
--        output = "hatches:"..metal.."_hatch_closed",
--        level = metals.levels[i],
--        material = metal,
--    })
--end
---- receipe for coin production
--realtest.register_anvil_recipe({
--    item1 = "metals:gold_sheet",
--    output = "money:coin 15",
--    level = metals.levels[i],
--    instrument = "chisel",
--    material = "gold",
--})
----Instruments
--local anvil_instruments = 
--    {{"axe", "_ingot"}, 
--     {"pick", "_ingot"},
--     {"shovel", "_ingot"},
--     {"spear", "_ingot"},
--     {"chisel", "_ingot"},
--     {"sword", "_doubleingot"},
--     {"hammer", "_doubleingot"},
--     {"saw", "_sheet"}
--    }
--for _, instrument in ipairs(anvil_instruments) do
--    for i, metal in ipairs(metals.list) do
--        -- the proper way to do that is to check whether we have metal in instruments.metals list or not
--        -- but who cares?
--        local output_name = "instruments:"..instrument[1].."_"..metal.."_head"
--        if minetest.registered_items[output_name] then
--            realtest.register_anvil_recipe({
--                item1 = "metals:"..metal..instrument[2],
--                item2 = "scribing_table:plan_"..instrument[1],
--                rmitem2 = false,
--                output = output_name,
--                level = metals.levels[i],
--                material = metal,
--            })
--        end
--    end
--end
--}}}
