gems = {}

-- This will be 1/value, actually.
-- See node drop definition for more information
gems.rare = 255
gems.very_rare = 1024

local color_alpha = 140
-- ColorString, "#RRGGBBAA", named colors supported
gems.color = { --TODO
    ruby       = "red",
    opal       = "orangered",
    topaz      = "gold",
    emerald    = "green",
    aquamarine = "aquamarine",
    sapphire   = "royalblue",
    amethyst   = "darkviolet",
    diamond    = "azure",
    -----
    rock_crystal = "ghostwhite",
    citrine      = "yellow",
    chatoyance   = "pink",
    smoky        = "gray",
    morion       = "black",
}

gems.crystal_light = 3

--{{{ Jewels definitions
gems.jewels = {
    ruby       = "Рубин",
    opal       = "Опал",
    topaz      = "Топаз",
    emerald    = "Изумруд",
    aquamarine = "Аквамарин",
    sapphire   = "Сапфир",
    amethyst   = "Аметист",
    diamond    = "Алмаз",
}

for gem, description in pairs(gems.jewels) do
    minetest.register_craftitem("gems:" .. gem, {
        description = description,
        groups = {jewel = 1, gem = 1},
        inventory_image = "gems_jewel_raw.png" ..
            "^[colorize:" .. gems.color[gem] .. ":" .. color_alpha,
    })

    minetest.register_craftitem("gems:" .. gem .. "_cut", {
        description = description,
        groups = {jewel = 1, gem = 1},
        inventory_image = "gems_jewel_cut.png" ..
            "^[colorize:" .. gems.color[gem] .. ":" .. color_alpha
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
        inventory_image = "gems_quartz_raw.png" ..
            "^[colorize:" .. gems.color[quartz] .. ":" .. color_alpha
    })

    minetest.register_craftitem("gems:" .. quartz .. "_cut", {
        description = description,
        groups = {quartz = 1, gem = 1},
        inventory_image = "gems_quartz_cut.png" ..
            "^[colorize:" .. gems.color[quartz] .. ":" .. color_alpha,
        inventory_image = "gems_quartz_cut.png" ..
            "^[colorize:" .. gems.color[quartz] .. ":" .. color_alpha ..
            "^[transformFX"
    })

    ores.register_ore(":ores:" .. quartz, {
        description = description .. " (руда)",
        tiles = { "default_stone.png^(gems_quartz_ore.png" ..
            "^[colorize:" .. gems.color[quartz] ..":" ..color_alpha ..
            ")"
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
    inventory_image = "gems_glowcrystal_shard.png", --TODO
    wield_light = gems.crystal_light,
})

minetest.register_craftitem("gems:glowcrystal", {
    description = "Кристалл",
    groups = { crystal = 1, gem = 1},
    inventory_image = "gems_glowcrystal.png", --TODO
    wield_light = gems.crystal_light * 2,
})
--}}}

--{{{ Nodes
minetest.register_node("gems:glowcrystal_normal", {
    description = "An",
    groups = {
        attached_node = 1,
        snappy = 2, cracky = 5, oddly_breakable_by_hand = 2,
        crystal = 1, gem = 1,
    },
    tiles = {
        "gems_glowcrystal_normal_top.png", "gems_glowcrystal_normal_top.png",
        "gems_glowcrystal_normal_pos_xside.png",
        "gems_glowcrystal_normal_neg_xside.png",
        "gems_glowcrystal_normal_pos_zside.png",
        "gems_glowcrystal_normal_neg_zside.png",
    },
    use_texture_alpha = true,
    drawtype = "nodebox",
    paramtype = "light",
    paramtype2 = "facedir",
    sunlight_propagates = true,
    light_source = gems.crystal_light,
    drop = {},
    node_box = {
        type = "fixed",
        fixed = {
            -- {x1,   y1,    z1,   x2,   y2,   z2},
            {    0, -0.5,     0, 1/16, 3/16, 1/16},
            {    0, -0.5,  3/16, 1/16, 3/16, 4/16},
            { 3/16, -0.5,     0, 4/16, 3/16, 1/16},
            { 3/16, -0.5,  3/16, 4/16, 3/16, 4/16},
            { 1/16, -0.5,     0, 3/16, 4/16, 1/16},
            { 1/16, -0.5,  3/16, 3/16, 4/16, 4/16},
            {    0, -0.5,  1/16, 1/16, 4/16, 3/16},
            { 3/16, -0.5,  1/16, 4/16, 4/16, 3/16},
            { 1/16, 4/16,  1/16, 3/16, 5/16, 3/16},
            --{    0, -0.5,     0, 4/16, 4/16, 4/16},
            {    0, -0.5, -4/16, 2/16, 2/16,-2/16},
            {-2/16, -0.5, -2/16,    0, 1/16,    0},
            {-6/16, -0.5, -4/16,-4/16,    0,-2/16},
            {-4/16, -0.5,  2/16,-2/16, 1/16, 4/16},
            { 4/16, -0.5,  4/16, 6/16, 2/16, 6/16},
        }
    },
})

minetest.register_node("gems:glowcrystal_large", {
    description = "Xayc",
    groups = {
        falling_node = 1,
        snappy = 1, cracky = 3, oddly_breakable_by_hand = 1,
        crystal = 1, gem = 1,
    },
    tiles = { "gems_glowcrystal_large_side.png" },
    use_texture_alpha = true,
    drawtype = "glasslike",
    paramtype = "light",
    sunlight_propagates = true,
    light_source = gems.crystal_light * 3,
    drop = {},
})

local pyramid = {}
local y = -8
for i = -8, -1 do
    table.insert(pyramid, {i/16, y/16, i/16, -i/16, (y + 2)/16, -i/16})
    y = y + 2
end

minetest.register_node("gems:glowcrystal_spike", {
    description = "Xayc",
    groups = {
        falling_node = 1,
        snappy = 1, cracky = 3, oddly_breakable_by_hand = 1,
        crystal = 1, gem = 1,
    },
    tiles = {
        "gems_glowcrystal_spike_top.png", "gems_glowcrystal_large_top.png",
        "gems_glowcrystal_spike_side.png", "gems_glowcrystal_spike_side.png",
        "gems_glowcrystal_spike_side.png", "gems_glowcrystal_spike_side.png",
    },
    use_texture_alpha = true,
    sunlight_propagates = true,
    drawtype = "nodebox",
    paramtype = "light",
    light_source = gems.crystal_light * 2.5,
    node_box = {
        type = "fixed",
        fixed = pyramid,
    },
    drop = {},
})

pyramid = {}
y = 8
for i = -8, -1 do
    table.insert(pyramid, {i/16, y/16, i/16, -i/16, (y - 2)/16, -i/16})
    y = y - 2
end

minetest.register_node("gems:glowcrystal_spike_down", {
    description = "Xayc",
    groups = {
        falling_node = 1,
        snappy = 1, cracky = 3, oddly_breakable_by_hand = 1,
        crystal = 1, gem = 1,
    },
    tiles = {
        "gems_glowcrystal_large_top.png", "gems_glowcrystal_spike_top.png",
        "gems_glowcrystal_spike_side.png^[transformFY",
        "gems_glowcrystal_spike_side.png^[transformFY",
        "gems_glowcrystal_spike_side.png^[transformFY",
        "gems_glowcrystal_spike_side.png^[transformFY",
    },
    use_texture_alpha = true,
    sunlight_propagates = true,
    drawtype = "nodebox",
    paramtype = "light",
    light_source = gems.crystal_light * 2.5,
    node_box = {
        type = "fixed",
        fixed = pyramid,
    },
    drop = {},
})
--}}}

--{{{ schematics
local xz = minetest.dir_to_facedir({x = -1, y = 0, z = 0})
local xZ = minetest.dir_to_facedir({x =  1, y = 0, z = 0})
local Xz = minetest.dir_to_facedir({x = 0, y = 0, z = -1})
local XZ = minetest.dir_to_facedir({x = 0, y = 0, z =  1})

local cr_schem_data = {}
for i = 1, 125 do
    cr_schem_data[i] = {name="air", param1=255, param2=0}
end

-- y == 0
cr_schem_data[1] = {name="gems:glowcrystal_normal", param1=32, param2=math.random(4)-1}
cr_schem_data[2] = {name="gems:glowcrystal_normal", param1=96, param2=math.random(4)-1}
cr_schem_data[3] = {name="gems:glowcrystal_normal", param1=160, param2=math.random(4)-1}
cr_schem_data[4] = {name="gems:glowcrystal_normal", param1=96, param2=math.random(4)-1}
cr_schem_data[5] = {name="gems:glowcrystal_normal", param1=32, param2=math.random(4)-1}

cr_schem_data[25 + 1] = {name="gems:glowcrystal_normal", param1=96, param2=math.random(4)-1}
cr_schem_data[25 + 2] = {name="default:stone", param1=255, param2=0}
cr_schem_data[25 + 3] = {name="default:stone", param1=255, param2=0}
cr_schem_data[25 + 4] = {name="default:stone", param1=255, param2=0}
cr_schem_data[25 + 5] = {name="gems:glowcrystal_normal", param1=96, param2=math.random(4)-1}

cr_schem_data[50 + 1] = {name="gems:glowcrystal_normal", param1=160, param2=math.random(4)-1}
cr_schem_data[50 + 2] = {name="default:stone", param1=255, param2=0}
cr_schem_data[50 + 3] = {name="gems:glowcrystal_large", param1=255, param2=0, force_place = true}
cr_schem_data[50 + 4] = {name="default:stone", param1=255, param2=0}
cr_schem_data[50 + 5] = {name="gems:glowcrystal_normal", param1=160, param2=math.random(4)-1}

cr_schem_data[75 + 1] = {name="gems:glowcrystal_normal", param1=96, param2=math.random(4)-1}
cr_schem_data[75 + 2] = {name="default:stone", param1=255, param2=0}
cr_schem_data[75 + 3] = {name="default:stone", param1=255, param2=0}
cr_schem_data[75 + 4] = {name="default:stone", param1=255, param2=0}
cr_schem_data[75 + 5] = {name="gems:glowcrystal_normal", param1=96, param2=math.random(4)-1}

cr_schem_data[100 + 1] = {name="gems:glowcrystal_normal", param1=32, param2=math.random(4)-1}
cr_schem_data[100 + 2] = {name="gems:glowcrystal_normal", param1=96, param2=math.random(4)-1}
cr_schem_data[100 + 3] = {name="gems:glowcrystal_normal", param1=160, param2=math.random(4)-1}
cr_schem_data[100 + 4] = {name="gems:glowcrystal_normal", param1=96, param2=math.random(4)-1}
cr_schem_data[100 + 5] = {name="gems:glowcrystal_normal", param1=32, param2=math.random(4)-1}

-- y == 1
cr_schem_data[30 + 2] = {name="gems:glowcrystal_normal", param1=192, param2=math.random(4)-1}
cr_schem_data[30 + 3] = {name="gems:glowcrystal_normal", param1=224, param2=math.random(4)-1}
cr_schem_data[30 + 4] = {name="gems:glowcrystal_normal", param1=192, param2=math.random(4)-1}

cr_schem_data[55 + 2] = {name="gems:glowcrystal_normal", param1=224, param2=math.random(4)-1}
cr_schem_data[55 + 3] = {name="gems:glowcrystal_large", param1=255, param2=0, force_place = true}
cr_schem_data[55 + 4] = {name="gems:glowcrystal_normal", param1=224, param2=math.random(4)-1}

cr_schem_data[80 + 2] = {name="gems:glowcrystal_normal", param1=192, param2=math.random(4)-1}
cr_schem_data[80 + 3] = {name="gems:glowcrystal_normal", param1=224, param2=math.random(4)-1}
cr_schem_data[80 + 4] = {name="gems:glowcrystal_normal", param1=192, param2=math.random(4)-1}

-- y == 2
cr_schem_data[50 + 10 + 3] = {name="gems:glowcrystal_large", param1=255, param2=0, force_place = true}

-- y == 3
cr_schem_data[50 + 15 + 3] = {name="gems:glowcrystal_large", param1=255, param2=0, force_place = true}

-- y == 4
cr_schem_data[50 + 20 + 3] = {name="gems:glowcrystal_spike", param1=255, param2=0}

gems.crystal_decoration = minetest.register_schematic({
    size = {x = 5, y = 5, z = 5},
    yslice_prob = {
        {ypos = 2, prob = 255 * 0.6},
        {ypos = 3, prob = 255 * 0.6},
    },
    data = cr_schem_data,
})

gems.crystal_large = minetest.register_schematic({
    size = {x = 1, y = 7, z = 1},
    yslice_prob = {
        {ypos = 2, prob = 255 * 0.5},
        {ypos = 3, prob = 255 * 0.5},
        {ypos = 4, prob = 255 * 0.5},
        {ypos = 5, prob = 255 * 0.5},
    },
    data = {
        {name="gems:glowcrystal_spike_down", param1=255, param2=0, force_place = true},
        {name="gems:glowcrystal_large", param1=255, param2=0, force_place = true},
        {name="gems:glowcrystal_large", param1=255, param2=0, force_place = true},
        {name="gems:glowcrystal_large", param1=255, param2=0, force_place = true},
        {name="gems:glowcrystal_large", param1=255, param2=0, force_place = true},
        {name="gems:glowcrystal_large", param1=255, param2=0, force_place = true},
        {name="gems:glowcrystal_spike", param1=255, param2=0, force_place = true},
    },
})
--}}}

--{{{ Decorations
minetest.register_decoration({
    deco_type = "schematic", -- See "Decoration types"
    place_on = "default:stone",
    sidelen = 8,
    fill_ratio = 0.02, --TODO
    biomes = nil,
    y_min = -31000,
    y_max = 0,

    ----- Schematic-type parameters
    schematic = gems.crystal_decoration,
    flags = "place_center_x, place_center_z",
    rotation = "random"
})
--}}}
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

gems.register_drop("ores:iron", {
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

gems.register_drop("gems:glowcrystal_normal", {
    glowcrystal = 4,
})
gems.register_drop("gems:glowcrystal_normal", {
    ["glowcrystal_shard 3"] = 2,
    ["glowcrystal_shard 2"] = 4,
    ["glowcrystal_shard 4"] = 4,
})

gems.register_drop("gems:glowcrystal_large", {
    ["glowcrystal 3"] = 4,
    ["glowcrystal 4"] = 2,
    ["glowcrystal 5"] = 4,
})
gems.register_drop("gems:glowcrystal_large", {
    ["glowcrystal_shard 4"] = 2,
    ["glowcrystal_shard 3"] = 4,
    ["glowcrystal_shard 5"] = 4,
})

gems.register_drop("gems:glowcrystal_spike", {
    ["glowcrystal_shard 4"] = 2,
    ["glowcrystal_shard 3"] = 4,
    ["glowcrystal_shard 5"] = 4,
})

gems.register_drop("gems:glowcrystal_spike_down", {
    ["glowcrystal_shard 4"] = 2,
    ["glowcrystal_shard 3"] = 4,
    ["glowcrystal_shard 5"] = 4,
})
--}}}
