gems = {}

-- This will be 1/value, actually.
-- See node drop definition for more information
gems.rare = 255
gems.very_rare = 1024

-- ColorString, "#RRGGBBAA", named colors supported
gems.color = {
    ruby       = "",
    opal       = "",
    topaz      = "",
    emerald    = "",
    aquamarine = "aquamarine",
    sapphire   = "",
    amethyst   = "",
    diamond    = "",
    -----
    rock_crystal = "ghostwhite",
    citrine      = "lemonchiffon",
    chatoyance   = "lightpink",
    smoky        = "lightgray",
    morion       = "black", --dimgray??
}

gems.crystal_light = 4

--{{{ Gems definitions
gems.list = {
    ruby       = "Рубин",
    opal       = "Опал",
    topaz      = "Топаз",
    emerald    = "Изумруд",
    aquamarine = "Аквамарин",
    sapphire   = "Сапфир",
    amethyst   = "Аметист",
    diamond    = "Алмаз",
}

for gem, description in pairs(gems.list) do
    minetest.register_craftitem("gems:" .. gem, {
        description = description,
        groups = {jewel = 1, gem = 1},
        inventory_image = "gems_" .. gem .. ".png",
    })
end
--}}}

--{{{ Quartz definition
gems.quartz = {
    rock_crystal = "Горный хрусталь",
    citrine      = "Цитрин",
    chatoyance   = "Кошачий глаз",
    smoky        = "Раухтопаз",
    morion       = "Морион",
}

for quartz, description in pairs(gems.quartz) do
    minetest.register_craftitem("gems:" .. quartz, {
        description = description,
        groups = {quartz = 1, gem = 1},
        inventory_image = "gems_quartz.png^[colorize:" .. gems.color[quartz] .. ":130",
    })

    ores.register_ore(":ores:" .. quartz, {
        description = description .. " (руда)",
        tiles = {
            "default_stone.png^" .. 
            "(gems_quartz_ore.png^[colorize:" .. gems.color[quartz] ..":0)"
        },
        drop = "gems:" .. quartz,
        clust_size = 2,
        y_max = 0,
        y_min = -1000,
    })
end
--}}}

--{{{ Cr-r-rystals
--{{{ Items
minetest.register_craftitem("gems:glowcrystal_shard", {
    description = "Осколок кристалла",
    groups = { crystal = 1, gem = 1},
    inventory_image = "gems_glowcrystal_shard.png",
    wield_light = gems.crystal_light,
})

minetest.register_craftitem("gems:glowcrystal", {
    description = "Кристалл",
    groups = { crystal = 1, gem = 1},
    inventory_image = "gems_glowcrystal.png",
    wield_light = gems.crystal_light * 2,
})
--}}}

--{{{ Nodes
minetest.register_node("gems:glowcrystal_small", {
    description = "An",
    groups = {
        attached_node = 1,
        snappy = 2, cracky = 5, oddly_breakable_by_hand = 2,
        crystal = 1, gem = 1,
    },
    tiles = { "gems_glowcrystal_node.png" }, --TODO
    use_texture_alpha = true,
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    light_source = gems.crystal_light,
    node_box = {
        type = "fixed",
        fixed = {
            -- {x1,   y1,    z1,   x2,   y2,   z2},
            {    0, -0.5,     0, 4/16, 4/16, 4/16},
            {    0, -0.5, -4/16, 2/16, 2/16,-2/16},
            {-2/16, -0.5, -2/16,    0, 1/16,    0},
            {-6/16, -0.5, -4/16,-4/16,    0,-2/16},
            {-4/16, -0.5,  2/16,-2/16, 1/16, 4/16},
            { 4/16, -0.5,  4/16, 6/16, 2/16, 6/16},
        }
    },
})

minetest.register_node("gems:glowcrystal_normal", {
    description = "Xayc",
    groups = {
        falling_node = 1,
        snappy = 1, cracky = 3, oddly_breakable_by_hand = 1,
        crystal = 1, gem = 1,
    },
    tiles = { "gems_glowcrystal_node.png" }, --TODO
    use_texture_alpha = true,
    drawtype = "glasslike",
    paramtype = "light",
    sunlight_propagates = true,
    light_source = gems.crystal_light * 3,
})

local pyramid = {}
for i = -8, -7 do
    table.insert(pyramid, {i/16, i/16, i/16, -i/16, (i+1)/16, -i/16})
end

minetest.register_node("gems:glowcrystal_normal_top", {
    description = "Xayc",
    groups = {
        falling_node = 1,
        snappy = 1, cracky = 3, oddly_breakable_by_hand = 1,
        crystal = 1, gem = 1,
    },
    tiles = { "gems_glowcrystal_node.png" },
    use_texture_alpha = true,
    sunlight_propagates = true,
    drawtype = "nodebox",
    paramtype = "light",
    light_source = gems.crystal_light * 2.5,
    node_box = {
        type = "fixed",
        fixed = pyramid,
    },
})

minetest.register_node("gems:glowcrystal_large_inside", {
    description = "Crystal-Ann",
    groups = {
        cracky = 2,
        crystal = 1, gem = 1,
    },
    tiles = { "gems_glowcrystal_node.png" }, --TODO
    use_texture_alpha = true,
    drawtype = "glasslike",
    paramtype = "light",
    sunlight_propagates = true,
    light_source = gems.crystal_light * 4,
})

local function corner (nodebox, coord1, coord2, side, perm_coord_num)
    if perm_coord_num == 1 then
        table.insert(nodebox, {
            -0.5, coord1/16, coord2/16,
             0.5, (coord1 + side)/16, (coord2 + side)/16
         })
    elseif perm_coord_num == 2 then
        table.insert(nodebox, {
            coord1/16, -0.5, coord2/16,
            (coord1 + side)/16,  0.5, (coord2 + side)/16
         })
    elseif perm_coord_num == 3 then
        table.insert(nodebox, {
            coord1/16, coord2/16, -0.5, 
            (coord1 + side)/16, (coord2 + side)/16, 0.5, 
         })
    else
        return
    end

    local newside = side/2
    if math.abs(newside) >= 1 then
        corner(nodebox, coord1 + side, coord2, newside, perm_coord_num)
        corner(nodebox, coord1, coord2 + side, newside, perm_coord_num)
    end
end

local vcorner = {}
corner(vcorner, -8, -8, 8, 2)

minetest.register_node("gems:glowcrystal_large_vcorner", {
    description = "Crystal-Ann",
    groups = {
        cracky = 2,
        crystal = 1, gem = 1,
    },
    tiles = { "gems_glowcrystal_node.png" }, --TODO
    use_texture_alpha = true,
    drawtype = "node_box",
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    light_source = gems.crystal_light * 3.5,
    node_box = {
        type = "fixed",
        fixed = vcorner
    },
})

local hdcorner = {}
corner(hdcorner, 8, 8, -8, 1)

minetest.register_node("gems:glowcrystal_large_hdcorner", {
    description = "Crystal-Ann",
    groups = {
        cracky = 2,
        crystal = 1, gem = 1,
    },
    tiles = { "gems_glowcrystal_node.png" },
    use_texture_alpha = true,
    drawtype = "node_box",
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    light_source = gems.crystal_light * 3.5,
    node_box = hdcorner,
})

local htcorner = {}
corner(htcorner, -8, -8, 8, 1)

minetest.register_node("gems:glowcrystal_large_hdcorner", {
    description = "Crystal-Ann",
    groups = {
        cracky = 2,
        crystal = 1, gem = 1,
    },
    tiles = { "gems_glowcrystal_node.png" },
    use_texture_alpha = true,
    drawtype = "node_box",
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    light_source = gems.crystal_light * 3.5,
    node_box = htcorner,
})
--}}}

--{{{ Decorations

--{{{ schematics
local normal_crystal = minetest.register_schematic({
    size = {x = 5, y = 5, z = 5},
    yslice_prob = {
        {ypos = 2, prob = 255 * 0.6},
        {ypos = 3, prob = 255 * 0.6},
    },
    data = {
        {name="gems:glowcrystal_small", param1=32, param2=0},
        {name="gems:glowcrystal_small", param1=96, param2=0},
        {name="gems:glowcrystal_small", param1=160, param2=0},
        {name="gems:glowcrystal_small", param1=96, param2=0},
        {name="gems:glowcrystal_small", param1=32, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        --
        {name="gems:glowcrystal_small", param1=96, param2=0},
        {name="default:stone", param1=255, param2=0},
        {name="default:stone", param1=255, param2=0},
        {name="default:stone", param1=255, param2=0},
        {name="gems:glowcrystal_small", param1=96, param2=0},
        {name="air", param1=255, param2=0},
        {name="gems:glowcrystal_small", param1=192, param2=0},
        {name="gems:glowcrystal_small", param1=224, param2=0},
        {name="gems:glowcrystal_small", param1=192, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        --
        {name="gems:glowcrystal_small", param1=160, param2=0},
        {name="default:stone", param1=255, param2=0},
        {name="gems:glowcrystal_normal", param1=255, param2=0, force_place = true},
        {name="default:stone", param1=255, param2=0},
        {name="gems:glowcrystal_small", param1=160, param2=0},
        {name="air", param1=255, param2=0},
        {name="gems:glowcrystal_small", param1=224, param2=0},
        {name="gems:glowcrystal_normal", param1=255, param2=0, force_place = true},
        {name="gems:glowcrystal_small", param1=224, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="gems:glowcrystal_normal", param1=255, param2=0, force_place = true},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="gems:glowcrystal_normal", param1=255, param2=0, force_place = true},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="gems:glowcrystal_normal_top", param1=255, param2=0, force_place = true},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        --
        {name="gems:glowcrystal_small", param1=96, param2=0},
        {name="default:stone", param1=255, param2=0},
        {name="default:stone", param1=255, param2=0},
        {name="default:stone", param1=255, param2=0},
        {name="gems:glowcrystal_small", param1=96, param2=0},
        {name="air", param1=255, param2=0},
        {name="gems:glowcrystal_small", param1=192, param2=0},
        {name="gems:glowcrystal_small", param1=224, param2=0},
        {name="gems:glowcrystal_small", param1=192, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        --
        {name="gems:glowcrystal_small", param1=32, param2=0},
        {name="gems:glowcrystal_small", param1=96, param2=0},
        {name="gems:glowcrystal_small", param1=160, param2=0},
        {name="gems:glowcrystal_small", param1=96, param2=0},
        {name="gems:glowcrystal_small", param1=32, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
        {name="air", param1=255, param2=0},
    },
})
--}}}

minetest.register_decoration({
    deco_type = "schematic", -- See "Decoration types"
    place_on = "default:dirt_with_grass",
    sidelen = 8,
    fill_ratio = 0.02,
    biomes = nil,
    y_min = -31000,
    y_max = 31000,
    
    ----- Schematic-type parameters
    schematic = normal_crystal,
    flags = "place_center_x, place_center_z",
    rotation = "random"
})
--}}}

--{{{ Register function
gems.register_drop = function(wherein, gems)
    if not ItemStack(wherein):is_known() then
        minetest.log("error",
            "failed to register drop for " .. wherein .. ". " ..
            wherein .. " is not a known item."
        )
        return false
    end

    local wherein_def = ItemStack(wherein):get_definition()
    local drops = wherein_def.drop
    local too_many_items = false
	if drops == nil then
		drops = {
            max_items = 2,
            items = { {items = {wherein}}, }
        }
	elseif type(drops) == "string" then
		drops = {
            max_items = 2,
            items = { {items = {drops}}, }
        }
	elseif drops.items == nil then
		-- drop = {} in definition disables default drop
        drops = table.copy(wherein_def.drop) -- we never should modify original table
		drops = {
            max_items = 1,
            items = {}
        }
    elseif #drops.items > 1 then
        too_many_items = true
        drops = table.copy(wherein_def.drop) -- we never should modify original table
        drops.items = {}
    else
        drops = table.copy(wherein_def.drop) -- we never should modify original table
        drops.max_items = drops.max_items + 1
	end

    local prev = 0
    for gem, howrare in pairs(gems) do
        table.insert(drops.items, {
            items = {"gems:" .. gem},
            rarity = howrare * (1 - prev),
        })
        prev = prev + 1/howrare
    end

    if not too_many_items then
        minetest.override_item(wherein, {
            drop = drops,
        })
    else
        local old_after_dig_node = wherein_def.after_dig_node
        if old_after_dig_node == nil then
            old_after_dig_node = function (pos, oldnode, oldmetadata, digger)
            end
        end

        minetest.override_item(wherein, {
            after_dig_node = function (pos, oldnode, oldmetadata, digger)
                old_after_dig_node(pos, oldnode, oldmetadata, digger)

                for _, item in ipairs(drops.items) do
                    if math.random(item.rarity) == 1 then
                        local inv = digger:get_inventory()
                        if inv:room_for_item("main", item.items[1]) then
                            inv:add_item("main", item.items[1])
                        else
                            minetest.add_item(pos, item.items[1])
                        end
                        break
                    end
                end
            end
        })
    end
    return true
end
--}}}

--{{{ Drop registration
gems.register_drop("default:stone", {
    aquamarine = gems.very_rare,
    amethyst = gems.very_rare,
    diamond = gems.very_rare,
})

gems.register_drop("ores:iron_ore", {
    ruby = gems.rare,
    opal = gems.rare,
    sapphire = gems.rare,
    topaz = gems.very_rare,
    emerald = gems.very_rare,
})

gems.register_drop("ores:cassiterite", {
    topaz = gems.very_rare,
})

gems.register_drop("ores:native_copper", {
    emerald = gems.very_rare,
})

gems.register_drop("ores:anthracite", {
    diamond = gems.very_rare,
})

gems.register_drop("ores:bituminous_coal", {
    diamond = gems.very_rare,
})

for quartz,_ in pairs(gems.quartz) do
    gems.register_drop("gems:" .. quartz, {
        ruby = gems.rare,
        amethyst = gems.rare,
        sapphire = gems.very_rare,
    })
end

gems.register_drop("ores:granite", {
    topaz = gems.rare,
    emerald = gems.very_rare,
    aquamarine = gems.very_rare,
    amethyst = gems.very_rare,
    diamond = gems.very_rare,
})

gems.register_drop("gems:glowcrystal_small", {
    glowcrystal = 4,
})
gems.register_drop("gems:glowcrystal_small", {
    ["glowcrystal_shard 3"] = 2,
    ["glowcrystal_shard 2"] = 4,
    ["glowcrystal_shard 4"] = 4,
})

gems.register_drop("gems:glowcrystal_normal", {
    ["glowcrystal 3"] = 4,
    ["glowcrystal 4"] = 2,
    ["glowcrystal 5"] = 4,
})
gems.register_drop("gems:glowcrystal_normal", {
    ["glowcrystal_shard 4"] = 2,
    ["glowcrystal_shard 3"] = 4,
    ["glowcrystal_shard 5"] = 4,
})

gems.register_drop("gems:glowcrystal_normal_top", {
    ["glowcrystal_shard 4"] = 2,
    ["glowcrystal_shard 3"] = 4,
    ["glowcrystal_shard 5"] = 4,
})
--}}}
