--{{{ Stone
minetest.register_node("default:stone", {
    description = "Камень",
    tiles = {"default_stone.png"},
    groups = {cracky=3, stone=1},
    drop = "default:cobble",
    legacy_mineral = true,
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:cobble", {
    description = "Булыжник",
    tiles = {"default_cobble.png"},
    is_ground_content = false,
    groups = {cracky = 3, stone = 2},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:stonebrick", {
    description = "Каменный кирпич",
    tiles = {"default_stone_brick.png"},
    is_ground_content = false,
    groups = {cracky = 2, stone = 1},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:mossycobble", {
    description = "Мшистый булыжник",
    tiles = {"default_mossycobble.png"},
    is_ground_content = false,
    groups = {cracky = 3, stone = 1},
    sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:sandstone", {
    description = "Песчаник",
    tiles = {"default_sandstone.png"},
    groups = {crumbly=2,cracky=3},
    sounds = default.node_sound_stone_defaults(),
})

minetest.register_node("default:sandstonebrick", {
    description = "Кирпич из песчаника",
    tiles = {"default_sandstone_brick.png"},
    is_ground_content = false,
    groups = {cracky=2},
    sounds = default.node_sound_stone_defaults(),
})


minetest.register_node("default:obsidian", {
    description = "Обсидиан",
    tiles = {"default_obsidian.png"},
    sounds = default.node_sound_stone_defaults(),
    groups = {cracky=1,level=2},
})
--}}}

--{{{ Soft / Non-Stone
local flowing_sand_type = "source"
local flowing_sand_leveled = 1
local flowing_sand_paramtype2 = "leveled"
local flowing_sand_liquid_drop = 1
if tonumber(core.setting_get("flowing_sand_disable") or 0) == 1 then
    flowing_sand_type = "none"
    flowing_sand_leveled = 0
    flowing_sand_paramtype2 = "none"
end
if tonumber(core.setting_get("flowing_sand_disable") or 0) >= 1 then
    flowing_sand_liquid_drop = 0
end


minetest.register_node("default:dirt", {
    description = "Почва",
    tiles = {"default_dirt.png"},
    groups = {crumbly = 3, soil = 1},
    sounds = default.node_sound_dirt_defaults(),

    groups = {crumbly = 3, soil = 1, melt = 50, liquid_drop = flowing_sand_liquid_drop, weight = 2000},
    leveled = flowing_sand_leveled,
    liquidtype = flowing_sand_type,
    paramtype2 = flowing_sand_paramtype2,
    drowning = 1,
--  melt = "default:dirt_dry",
})

minetest.register_node("default:dirt_with_grass", {
    description = "Почва с травой",
    tiles = {"default_grass.png", "default_dirt.png",
        {name = "default_dirt.png^default_grass_side.png",
            tileable_vertical = false}},
    groups = {crumbly = 3, soil = 1, melt = 40, freeze = -5 },
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name = "default_grass_footstep", gain = 0.25},
    }),
    drowning = 1,
--  melt = "default:dirt_with_dry_grass",
--  freeze = "default:dirt_with_snow",
})

minetest.register_node("default:dirt_with_grass_footsteps", {
    description = "Почва с травой и следами",
    tiles = {"default_grass.png^default_footprint.png", "default_dirt.png",
        {name = "default_dirt.png^default_grass_side.png",
            tileable_vertical = false}},
    groups = {crumbly = 3, soil = 1, not_in_creative_inventory = 1, melt = 40, freeze = -5},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name = "default_grass_footstep", gain = 0.25},
    }),
    drowning = 1,
--  melt = "default:dirt_with_dry_grass",
--  freeze = "default:dirt_with_snow",
})

minetest.register_node("default:dirt_with_dry_grass", {
    description = "Почва с сухой травой",
    tiles = {"default_dry_grass.png",
        "default_dirt.png",
        {name = "default_dirt.png^default_dry_grass_side.png",
            tileable_vertical = false}},
    groups = {crumbly = 3, soil = 1, melt = 50, freeze = -5},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name = "default_grass_footstep", gain = 0.4},
    }),
    drowning = 1,
--  melt = "default:dirt_dry",
    freeze = "default:dirt_with_snow",
})

minetest.register_node("default:dirt_with_snow", {
    description = "Почва со снегом",
    tiles = {"default_snow.png", "default_dirt.png",
        {name = "default_dirt.png^default_snow_side.png",
            tileable_vertical = false}},
    groups = {crumbly = 3, soil = 1, slippery = 70, melt = 2},
    drop = 'default:dirt',
    sounds = default.node_sound_dirt_defaults({
        footstep = {name = "default_snow_footstep", gain = 0.25},
    }),
    drowning = 1,
--  melt = "default:dirt",
})

minetest.register_node("default:dirt_dry", {
    description = "Сухая почва",
    tiles = {"default_dirt_dry.png"},
    is_ground_content = true,
    groups = {crumbly = 3, soil = 1},
    sounds = default.node_sound_dirt_defaults(),

    groups = {crumbly = 3, soil = 1, liquid_drop = flowing_sand_liquid_drop, weight = 2000},
    leveled = flowing_sand_leveled,
    liquidtype = flowing_sand_type,
    paramtype2 = flowing_sand_paramtype2,
    drowning = 1,
})


minetest.register_node("default:sand", {
    description = "Песок",
    tiles = {"default_sand.png"},
    groups = {crumbly = 3, falling_node = 1, sand = 1},
    sounds = default.node_sound_sand_defaults(),

    is_ground_content = true,
    groups = {crumbly=3, falling_node=1, sand=1, liquid_drop=flowing_sand_liquid_drop, weight=2000},
    leveled = flowing_sand_leveled,
    liquidtype = flowing_sand_type,
    paramtype2 = flowing_sand_paramtype2,
    drowning = 1,
})

minetest.register_node("default:desert_sand", {
    description = "Пустынный песок",
    tiles = {"default_desert_sand.png"},
    groups = {crumbly = 3, falling_node = 1, sand = 1},
    sounds = default.node_sound_sand_defaults(),

    is_ground_content = true,
    leveled = flowing_sand_leveled,
    liquidtype = flowing_sand_type,
    paramtype2 = flowing_sand_paramtype2,
    drowning = 1,
    groups = {crumbly=3, falling_node=1, sand=1, liquid_drop=flowing_sand_liquid_drop, weight=2000},
})

minetest.register_node("default:gravel", {
    description = "Гравий",
    tiles = {"default_gravel.png"},
    groups = {crumbly = 2, falling_node = 1},
    sounds = default.node_sound_dirt_defaults({
        footstep = {name = "default_gravel_footstep", gain = 0.5},
        dug = {name = "default_gravel_footstep", gain = 1.0},
    }),

    groups = {crumbly=2, falling_node=1, liquid_drop=flowing_sand_liquid_drop, weight=2000},
    leveled = flowing_sand_leveled,
    liquidtype = flowing_sand_type,
    paramtype2 = flowing_sand_paramtype2,
    drowning = 1,
})


minetest.register_node("default:clay", {
    description = "Глина",
    tiles = {"default_clay.png"},
    groups = {crumbly=3, melt=1500},
    drop = 'default:clay_lump 4',
    sounds = default.node_sound_dirt_defaults(),
--  melt = "default:stone",
})


minetest.register_node("default:snow", {
    description = "Снег",
    tiles = {"default_snow.png"},
    inventory_image = "default_snowball.png",
    wield_image = "default_snowball.png",
    paramtype = "light",
    buildable_to = true,
    drawtype = "nodebox",
    node_box = {
        type = "leveled",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.25, 0.5},
        },
    },
    groups = {crumbly = 3, falling_node = 1, puts_out_fire = 1, melt = 1, float = 1, slippery = 75},
    sounds = default.node_sound_dirt_defaults({
        footstep = {name = "default_snow_footstep", gain = 0.25},
        dug = {name = "default_snow_footstep", gain = 0.75},
    }),

    on_construct = function(pos)
        pos.y = pos.y - 1
        if minetest.get_node(pos).name == "default:dirt_with_grass" then
            minetest.set_node(pos, {name = "default:dirt_with_snow"}, 2)
        end
    end,
    leveled = 7,
    paramtype2 = "leveled",
--  melt = "default:water_flowing",
})

minetest.register_node("default:snowblock", {
    description = "Блок снега",
    tiles = {"default_snow.png"},
    groups = {crumbly = 3, puts_out_fire = 1, melt = 2, slippery = 80},
    sounds = default.node_sound_dirt_defaults({
        footstep = {name = "default_snow_footstep", gain = 0.25},
        dug = {name = "default_snow_footstep", gain = 0.75},
    }),
--  melt = "default:water_source",
})


minetest.register_node("default:ice", {
    description = "Лёд",
    tiles = {"default_ice.png"},
    is_ground_content = false,
    paramtype = "light",
    groups = {cracky = 3, puts_out_fire = 1, melt = 3, slippery = 90},
    sounds = default.node_sound_glass_defaults(),
--  melt = "default:water_source",
})
--}}}

--{{{ Trees
minetest.register_node("default:tree", {
    description = "Дерево",
    tiles = {"default_tree_top.png", "default_tree_top.png", "default_tree.png"},
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
    sounds = default.node_sound_wood_defaults(),

    on_place = minetest.rotate_node
})

minetest.register_node("default:wood", {
    description = "Доски",
    tiles = {"default_wood.png"},
    is_ground_content = false,
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:sapling", {
    description = "Росток",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_sapling.png"},
    inventory_image = "default_sapling.png",
    wield_image = "default_sapling.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
    },
    groups = {snappy = 2, dig_immediate = 3, flammable = 2,
        attached_node = 1, sapling = 1},
    sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("default:leaves", {
    description = "Листва",
    drawtype = "allfaces_optional",
    waving = 1,
    visual_scale = 1.3,
    tiles = {"default_leaves.png"},
    special_tiles = {"default_leaves_simple.png"},
    paramtype = "light",
    is_ground_content = false,
    groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
    drop = {
        max_items = 1,
        items = {
            {
                -- player will get sapling with 1/20 chance
                items = {'default:sapling'},
                rarity = 20,
            },
            {
                -- player will get leaves only if he get no saplings,
                -- this is because max_items is 1
                items = {'default:leaves'},
            }
        }
    },
    sounds = default.node_sound_leaves_defaults(),

    after_place_node = default.after_place_leaves,
})

minetest.register_node("default:apple", {
    description = "Яблоко",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_apple.png"},
    inventory_image = "default_apple.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    is_ground_content = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.2, -0.5, -0.2, 0.2, 0, 0.2}
    },
    groups = {fleshy = 3, dig_immediate = 3, flammable = 2,
        leafdecay = 3, leafdecay_drop = 1},
    on_use = minetest.item_eat(2),
    sounds = default.node_sound_leaves_defaults(),

    after_place_node = function(pos, placer, itemstack)
        if placer:is_player() then
            minetest.set_node(pos, {name = "default:apple", param2 = 1})
        end
    end,
})


minetest.register_node("default:jungletree", {
    description = "Тропическое дерево",
    tiles = {"default_jungletree_top.png", "default_jungletree_top.png",
        "default_jungletree.png"},
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
    sounds = default.node_sound_wood_defaults(),

    on_place = minetest.rotate_node
})

minetest.register_node("default:junglewood", {
    description = "Доски из тропического дерева",
    tiles = {"default_junglewood.png"},
    is_ground_content = false,
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:jungleleaves", {
    description = "Тропические листья",
    drawtype = "allfaces_optional",
    waving = 1,
    visual_scale = 1.3,
    tiles = {"default_jungleleaves.png"},
    special_tiles = {"default_jungleleaves_simple.png"},
    paramtype = "light",
    is_ground_content = false,
    groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
    drop = {
        max_items = 1,
        items = {
            {items = {'default:junglesapling'}, rarity = 20},
            {items = {'default:jungleleaves'}}
        }
    },
    sounds = default.node_sound_leaves_defaults(),

    after_place_node = default.after_place_leaves,
})

minetest.register_node("default:junglesapling", {
    description = "Росток тропического дерева",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_junglesapling.png"},
    inventory_image = "default_junglesapling.png",
    wield_image = "default_junglesapling.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
    },
    groups = {snappy = 2, dig_immediate = 3, flammable = 2,
        attached_node = 1, sapling = 1},
    sounds = default.node_sound_leaves_defaults(),
})


minetest.register_node("default:pine_tree", {
    description = "Хвойное дерево",
    tiles = {"default_pine_tree_top.png", "default_pine_tree_top.png",
        "default_pine_tree.png"},
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
    sounds = default.node_sound_wood_defaults(),

    on_place = minetest.rotate_node
})

minetest.register_node("default:pine_wood", {
    description = "Доски из хвойного дерева",
    tiles = {"default_pine_wood.png"},
    is_ground_content = false,
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:pine_needles",{
    description = "Хвоя",
    drawtype = "allfaces_optional",
    visual_scale = 1.3,
    tiles = {"default_pine_needles.png"},
    waving = 1,
    paramtype = "light",
    is_ground_content = false,
    groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
    drop = {
        max_items = 1,
        items = {
            {items = {"default:pine_sapling"}, rarity = 20},
            {items = {"default:pine_needles"}}
        }
    },
    sounds = default.node_sound_leaves_defaults(),

    after_place_node = default.after_place_leaves,
})

minetest.register_node("default:pine_sapling", {
    description = "Росток хвойного дерева",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_pine_sapling.png"},
    inventory_image = "default_pine_sapling.png",
    wield_image = "default_pine_sapling.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
    },
    groups = {snappy = 2, dig_immediate = 3, flammable = 2,
        attached_node = 1, sapling = 1},
    sounds = default.node_sound_leaves_defaults(),
})


minetest.register_node("default:acacia_tree", {
    description = "Акация",
    tiles = {"default_acacia_tree_top.png", "default_acacia_tree_top.png",
        "default_acacia_tree.png"},
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = {tree = 1, choppy = 2, oddly_breakable_by_hand = 1, flammable = 2},
    sounds = default.node_sound_wood_defaults(),

    on_place = minetest.rotate_node
})

minetest.register_node("default:acacia_wood", {
    description = "Доски из акации",
    tiles = {"default_acacia_wood.png"},
    is_ground_content = false,
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
    sounds = default.node_sound_wood_defaults(),
})

minetest.register_node("default:acacia_leaves", {
    description = "Листва акации",
    drawtype = "allfaces_optional",
    visual_scale = 1.3,
    tiles = {"default_acacia_leaves.png"},
    waving = 1,
    paramtype = "light",
    is_ground_content = false,
    groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
    drop = {
        max_items = 1,
        items = {
            {items = {"default:acacia_sapling"}, rarity = 20},
            {items = {"default:acacia_leaves"}}
        }
    },
    sounds = default.node_sound_leaves_defaults(),

    after_place_node = default.after_place_leaves,
})

minetest.register_node("default:acacia_sapling", {
    description = "Росток акации",
    drawtype = "plantlike",
    visual_scale = 1.0,
    tiles = {"default_acacia_sapling.png"},
    inventory_image = "default_acacia_sapling.png",
    wield_image = "default_acacia_sapling.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.35, 0.3}
    },
    groups = {snappy = 2, dig_immediate = 3, flammable = 2,
        attached_node = 1, sapling = 1},
    sounds = default.node_sound_leaves_defaults(),
})
--}}}

--{{{ Plantlife (non-cubic)
minetest.register_node("default:cactus", {
    description = "Кактус",
    tiles = {"default_cactus_top.png", "default_cactus_top.png",
        "default_cactus_side.png"},
    paramtype2 = "facedir",
    groups = {snappy = 1, choppy = 3, flammable = 2},
    sounds = default.node_sound_wood_defaults(),
    on_place = minetest.rotate_node,

    after_dig_node = function(pos, node, metadata, digger)
        default.dig_up(pos, node, digger)
    end,
})

minetest.register_node("default:papyrus", {
    description = "Папирус",
    drawtype = "plantlike",
    tiles = {"default_papyrus.png"},
    inventory_image = "default_papyrus.png",
    wield_image = "default_papyrus.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    selection_box = {
        type = "fixed",
        fixed = {-0.3, -0.5, -0.3, 0.3, 0.5, 0.3}
    },
    groups = {snappy = 3, flammable = 2, dig_immediate = 3},
    sounds = default.node_sound_leaves_defaults(),

    after_dig_node = function(pos, node, metadata, digger)
        default.dig_up(pos, node, digger)
    end,
})

minetest.register_node("default:dry_shrub", {
    description = "Сухой росток",
    drawtype = "plantlike",
    waving = 1,
    visual_scale = 1.0,
    tiles = {"default_dry_shrub.png"},
    inventory_image = "default_dry_shrub.png",
    wield_image = "default_dry_shrub.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    buildable_to = true,
    groups = {snappy = 3, flammable = 3, attached_node = 1, dig_immediate = 3, drop_by_liquid = 1},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },
})

minetest.register_node("default:junglegrass", {
    description = "Тропическая трава",
    drawtype = "plantlike",
    waving = 1,
    visual_scale = 1.3,
    tiles = {"default_junglegrass.png"},
    inventory_image = "default_junglegrass.png",
    wield_image = "default_junglegrass.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    buildable_to = true,
    groups = {snappy = 3, flammable = 2, flora = 1, attached_node = 1, dig_immediate = 3, drop_by_liquid = 1, melt = 50},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },
--  melt = "default:dry_grass_5"
})


minetest.register_node("default:grass_1", {
    description = "Трава",
    drawtype = "plantlike",
    waving = 1,
    tiles = {"default_grass_1.png"},
    -- Use texture of a taller grass stage in inventory
    inventory_image = "default_grass_3.png",
    wield_image = "default_grass_3.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    buildable_to = true,
    groups = {snappy = 3, flammable = 3, flora = 1, attached_node = 1, dig_immediate = 3, drop_by_liquid = 1, melt = 40},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },

    on_place = function(itemstack, placer, pointed_thing)
        -- place a random grass node
        local stack = ItemStack("default:grass_" .. math.random(1,5))
        local ret = minetest.item_place(stack, placer, pointed_thing)
        return ItemStack("default:grass_1 " ..
            itemstack:get_count() - (1 - ret:get_count()))
    end,
--  melt = "default:dry_grass_1"
})

for i = 2, 5 do
    minetest.register_node("default:grass_" .. i, {
        description = "Трава",
        drawtype = "plantlike",
        waving = 1,
        tiles = {"default_grass_" .. i .. ".png"},
        inventory_image = "default_grass_" .. i .. ".png",
        wield_image = "default_grass_" .. i .. ".png",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        buildable_to = true,
        drop = "default:grass_1",
        groups = {snappy = 3, flammable = 3, flora = 1,
            attached_node = 1, not_in_creative_inventory = 1,
            dig_immediate = 3, drop_by_liquid = 1, melt = 40},
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
--      melt = "default:dry_grass_" .. i
    })
end


minetest.register_node("default:dry_grass_1", {
    description = "Сухая трава",
    drawtype = "plantlike",
    waving = 1,
    tiles = {"default_dry_grass_1.png"},
    inventory_image = "default_dry_grass_3.png",
    wield_image = "default_dry_grass_3.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    buildable_to = true,
    groups = {snappy = 3, flammable = 3, flora = 1,
        attached_node = 1, dig_immediate = 3, drop_by_liquid = 1},
    sounds = default.node_sound_leaves_defaults(),
    selection_box = {
        type = "fixed",
        fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
    },

    on_place = function(itemstack, placer, pointed_thing)
        -- place a random dry grass node
        local stack = ItemStack("default:dry_grass_" .. math.random(1, 5))
        local ret = minetest.item_place(stack, placer, pointed_thing)
        return ItemStack("default:dry_grass_1 " ..
            itemstack:get_count() - (1 - ret:get_count()))
    end,
})

for i = 2, 5 do
    minetest.register_node("default:dry_grass_" .. i, {
        description = "Сухая трава",
        drawtype = "plantlike",
        waving = 1,
        tiles = {"default_dry_grass_" .. i .. ".png"},
        inventory_image = "default_dry_grass_" .. i .. ".png",
        wield_image = "default_dry_grass_" .. i .. ".png",
        paramtype = "light",
        sunlight_propagates = true,
        walkable = false,
        buildable_to = true,
        groups = {snappy = 3, flammable = 3, flora = 1,
            attached_node = 1, not_in_creative_inventory=1,
            dig_immediate = 3, drop_by_liquid = 1},
        drop = "default:dry_grass_1",
        sounds = default.node_sound_leaves_defaults(),
        selection_box = {
            type = "fixed",
            fixed = {-0.5, -0.5, -0.5, 0.5, -5/16, 0.5},
        },
    })
end
--}}}

--{{{ Liquids
minetest.register_node("default:water_source", {
    description = "Источник воды",
    inventory_image = minetest.inventorycube("default_water.png"),
    drawtype = "liquid",
    tiles = {
        {
            name = "default_water_source_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
        },
    },
    special_tiles = {
        -- New-style water source material (mostly unused)
        {
            name = "default_water_source_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
            backface_culling = false,
        },
    },
    alpha = 160,
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "default:water_flowing",
    liquid_alternative_source = "default:water_source",
    liquid_viscosity = 1,
    post_effect_color = {a = 120, r = 30, g = 60, b = 90},
    groups = {water = 3, liquid = 3, puts_out_fire = 1},
    groups = {water = 3, liquid = 3, puts_out_fire = 1, freeze = -1, melt = 105, liquid_drop = 1, weight = 1000, pressure = 32},
    leveled = 8,
    paramtype2 = "leveled",
    freeze = "default:ice",
--  melt = "air",
})

minetest.register_node("default:water_flowing", {
    description = "Текущая вода",
    inventory_image = minetest.inventorycube("default_water.png"),
    drawtype = "flowingliquid",
    tiles = {"default_water.png"},
    special_tiles = {
        {
            name = "default_water_flowing_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
        {
            name = "default_water_flowing_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
    },
    alpha = 160,
    paramtype = "light",
    paramtype2 = "flowingliquid",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:water_flowing",
    liquid_alternative_source = "default:water_source",
    liquid_viscosity = 1,
    post_effect_color = {a = 120, r = 30, g = 60, b = 90},
    groups = {water = 3, liquid = 3, puts_out_fire = 1,
        not_in_creative_inventory = 1},

    groups = {water = 3, liquid = 3, puts_out_fire = 1,
        not_in_creative_inventory = 1,
        freeze = -5, melt = 100, liquid_drop = 1, weight = 1000},
    leveled = 8,
    paramtype2 = "leveled",
    freeze = "default:snow",
--  melt = "air",
})


minetest.register_node("default:river_water_source", {
    description = "Источник речной воды",
    inventory_image = minetest.inventorycube("default_river_water.png"),
    drawtype = "liquid",
    tiles = {
        {
            name = "default_river_water_source_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
        },
    },
    special_tiles = {
        {
            name = "default_river_water_source_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 2.0,
            },
            backface_culling = false,
        },
    },
    alpha = 160,
    paramtype = "light",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "default:river_water_flowing",
    liquid_alternative_source = "default:river_water_source",
    liquid_viscosity = 1,
    liquid_renewable = false,
    liquid_range = 2,
    post_effect_color = {a = 120, r = 30, g = 76, b = 90},
    groups = {water = 3, liquid = 3, puts_out_fire = 1},
    groups = {water = 3, liquid = 3, puts_out_fire = 1, freeze = -1, melt = 105, liquid_drop = 1, weight = 995, pressure = 32},
    leveled = 4,
    paramtype2 = "leveled",
    freeze = "default:ice",
--  melt = "air",
})

minetest.register_node("default:river_water_flowing", {
    description = "Текущая речная вода",
    inventory_image = minetest.inventorycube("default_river_water.png"),
    drawtype = "flowingliquid",
    tiles = {"default_river_water.png"},
    special_tiles = {
        {
            name = "default_river_water_flowing_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
        {
            name = "default_river_water_flowing_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 0.8,
            },
        },
    },
    alpha = 160,
    paramtype = "light",
    paramtype2 = "flowingliquid",
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:river_water_flowing",
    liquid_alternative_source = "default:river_water_source",
    liquid_viscosity = 1,
    liquid_renewable = false,
    liquid_range = 2,
    post_effect_color = {a = 120, r = 30, g = 76, b = 90},
    groups = {water = 3, liquid = 3, puts_out_fire = 1,
        not_in_creative_inventory = 1},

    groups = {water = 3, liquid = 3, puts_out_fire = 1,
        not_in_creative_inventory = 1,
        freeze = -5, melt = 100, liquid_drop = 1, weight = 999},
    leveled = 4,
    paramtype2 = "leveled",
    freeze = "default:snow",
--  melt = "air",
})


minetest.register_node("default:lava_source", {
    description = "Источник лавы",
    inventory_image = minetest.inventorycube("default_lava.png"),
    drawtype = "liquid",
    tiles = {
        {
            name = "default_lava_source_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 3.0,
            },
        },
    },
    special_tiles = {
        -- New-style lava source material (mostly unused)
        {
            name = "default_lava_source_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 3.0,
            },
            backface_culling = false,
        },
    },
    paramtype = "light",
    light_source = default.LIGHT_MAX - 1,
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "source",
    liquid_alternative_flowing = "default:lava_flowing",
    liquid_alternative_source = "default:lava_source",
    liquid_viscosity = 7,
    liquid_renewable = false,
    damage_per_second = 4 * 2,
    post_effect_color = {a = 192, r = 255, g = 64, b = 0},
    groups = {lava = 3, liquid = 2, hot = 3, igniter = 1},

    groups = {lava = 3, liquid = 2, hot = 1200, igniter = 1,
        wield_light = 5, liquid_drop = 1, weight = 2000, pressure = 32},
    paramtype2 = "leveled",
    leveled = 4,
    freeze = "default:obsidian",
})

minetest.register_node("default:lava_flowing", {
    description = "Текущая лава",
    inventory_image = minetest.inventorycube("default_lava.png"),
    drawtype = "flowingliquid",
    tiles = {"default_lava.png"},
    special_tiles = {
        {
            name = "default_lava_flowing_animated.png",
            backface_culling = false,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 3.3,
            },
        },
        {
            name = "default_lava_flowing_animated.png",
            backface_culling = true,
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 3.3,
            },
        },
    },
    paramtype = "light",
    light_source = default.LIGHT_MAX - 1,
    walkable = false,
    pointable = false,
    diggable = false,
    buildable_to = true,
    is_ground_content = false,
    drop = "",
    drowning = 1,
    liquidtype = "flowing",
    liquid_alternative_flowing = "default:lava_flowing",
    liquid_alternative_source = "default:lava_source",
    liquid_viscosity = 7,
    liquid_renewable = false,
    damage_per_second = 4 * 2,
    post_effect_color = {a = 192, r = 255, g = 64, b = 0},
    groups = {lava = 3, liquid = 2, hot = 3, igniter = 1,
        not_in_creative_inventory = 1},

    groups = {lava = 3, liquid = 2, hot = 700, igniter = 1,
        not_in_creative_inventory = 1,
        wield_light = 2, liquid_drop = 1, weight = 2000},
    paramtype2 = "leveled",
    leveled = 4,
    freeze = "default:stone",
})
--}}}

--{{{ Tools / "Advanced" crafting / Non-"natural"
minetest.register_node("default:torch", {
    description = "Факел",
    drawtype = "torchlike",
    tiles = {
        {
            name = "default_torch_on_floor_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 3.0
            },
        },
        {
            name="default_torch_on_ceiling_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 3.0
            },
        },
        {
            name="default_torch_animated.png",
            animation = {
                type = "vertical_frames",
                aspect_w = 16,
                aspect_h = 16,
                length = 3.0
            },
        },
    },
    inventory_image = "default_torch_on_floor.png",
    wield_image = "default_torch_on_floor.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    is_ground_content = false,
    walkable = false,
    light_source = default.LIGHT_MAX - 1,
    selection_box = {
        type = "wallmounted",
        wall_top = {-0.1, 0.5 - 0.6, -0.1, 0.1, 0.5, 0.1},
        wall_bottom = {-0.1, -0.5, -0.1, 0.1, -0.5 + 0.6, 0.1},
        wall_side = {-0.5, -0.3, -0.1, -0.5 + 0.3, 0.3, 0.1},
    },
    groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1},
    legacy_wallmounted = true,
    sounds = default.node_sound_defaults(),

    groups = {choppy = 2, dig_immediate = 3, flammable = 1, attached_node = 1,
        hot = 30, wield_light = default.LIGHT_MAX-1, drop_by_liquid = 1},
})

local bookshelf_formspec =
    "size[8,7;]" ..
    default.gui_bg ..
    default.gui_bg_img ..
    default.gui_slots ..
    "list[context;books;0,0.3;8,2;]" ..
    "list[current_player;main;0,2.85;8,1;]" ..
    "list[current_player;main;0,4.08;8,3;8]" ..
    "listring[context;books]" ..
    "listring[current_player;main]" ..
    default.get_hotbar_bg(0,2.85)

minetest.register_node("default:bookshelf", {
    description = "Книжная полка",
    tiles = {"default_wood.png", "default_wood.png", "default_bookshelf.png"},
    is_ground_content = false,
    groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3},
    sounds = default.node_sound_wood_defaults(),

    on_construct = function(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", bookshelf_formspec)
        local inv = meta:get_inventory()
        inv:set_size("books", 8 * 2)
    end,
    can_dig = function(pos,player)
        local meta = minetest.get_meta(pos);
        local inv = meta:get_inventory()
        return inv:is_empty("books")
    end,

    allow_metadata_inventory_put = function(pos, listname, index, stack, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local to_stack = inv:get_stack(listname, index)
        if listname == "books" then
            if minetest.get_item_group(stack:get_name(), "book") ~= 0
                    and to_stack:is_empty() then
                return 1
            else
                return 0
            end
        end
    end,

    allow_metadata_inventory_move = function(pos, from_list, from_index,
            to_list, to_index, count, player)
        local meta = minetest.get_meta(pos)
        local inv = meta:get_inventory()
        local stack = inv:get_stack(from_list, from_index)
        local to_stack = inv:get_stack(to_list, to_index)
        if to_list == "books" then
            if minetest.get_item_group(stack:get_name(), "book") ~= 0
                    and to_stack:is_empty() then
                return 1
            else
                return 0
            end
        end
    end,

    on_metadata_inventory_move = function(pos, from_list, from_index,
            to_list, to_index, count, player)
        minetest.log("action", player:get_player_name() ..
            " moves stuff in bookshelf at " .. minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_put = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name() ..
            " moves stuff to bookshelf at " .. minetest.pos_to_string(pos))
    end,
    on_metadata_inventory_take = function(pos, listname, index, stack, player)
        minetest.log("action", player:get_player_name() ..
            " takes stuff from bookshelf at " .. minetest.pos_to_string(pos))
    end,
})


minetest.register_node("default:sign_wall", {
    description = "Табличка",
    drawtype = "nodebox",
    tiles = {"default_sign.png"},
    inventory_image = "default_sign_wall.png",
    wield_image = "default_sign_wall.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    is_ground_content = false,
    walkable = false,
    node_box = {
        type = "wallmounted",
        wall_top    = {-0.4375, 0.4375, -0.3125, 0.4375, 0.5, 0.3125},
        wall_bottom = {-0.4375, -0.5, -0.3125, 0.4375, -0.4375, 0.3125},
        wall_side   = {-0.5, -0.3125, -0.4375, -0.4375, 0.3125, 0.4375},
    },
    groups = {choppy = 2, dig_immediate = 2, attached_node = 1},
    legacy_wallmounted = true,
    sounds = default.node_sound_defaults(),

    on_construct = function(pos)
        --local n = minetest.get_node(pos)
        local meta = minetest.get_meta(pos)
        meta:set_string("formspec", "field[text;;${text}]")
        meta:set_string("infotext", "\"\"")
    end,
    on_receive_fields = function(pos, formname, fields, sender)
        --print("Sign at "..minetest.pos_to_string(pos).." got "..dump(fields))
        if minetest.is_protected(pos, sender:get_player_name()) then
            minetest.record_protection_violation(pos, sender:get_player_name())
            return
        end
        local meta = minetest.get_meta(pos)
        if not fields.text then return end
        minetest.log("action", (sender:get_player_name() or "") .. " wrote \"" ..
            fields.text .. "\" to sign at " .. minetest.pos_to_string(pos))
        meta:set_string("text", fields.text)
        meta:set_string("infotext", '"' .. fields.text .. '"')
    end,
})


minetest.register_node("default:ladder", {
    description = "Лестница",
    drawtype = "signlike",
    tiles = {"default_ladder.png"},
    inventory_image = "default_ladder.png",
    wield_image = "default_ladder.png",
    paramtype = "light",
    paramtype2 = "wallmounted",
    sunlight_propagates = true,
    walkable = false,
    climbable = true,
    is_ground_content = false,
    selection_box = {
        type = "wallmounted",
        --wall_top = = <default>
        --wall_bottom = = <default>
        --wall_side = = <default>
    },
    groups = {choppy = 2, oddly_breakable_by_hand = 3, flammable = 2},
    legacy_wallmounted = true,
    sounds = default.node_sound_wood_defaults(),
})


local fence_texture =
    "default_fence_overlay.png^default_wood.png^default_fence_overlay.png^[makealpha:255,126,126"
minetest.register_node("default:fence_wood", {
    description = "Деревянный забор",
    drawtype = "fencelike",
    tiles = {"default_wood.png"},
    inventory_image = fence_texture,
    wield_image = fence_texture,
    paramtype = "light",
    sunlight_propagates = true,
    is_ground_content = false,
    selection_box = {
        type = "fixed",
        fixed = {-1/7, -1/2, -1/7, 1/7, 1/2, 1/7},
    },
    groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 2},
    sounds = default.node_sound_wood_defaults(),
})


minetest.register_node("default:glass", {
    description = "Стекло",
    drawtype = "glasslike_framed_optional",
    tiles = {"default_glass.png", "default_glass_detail.png"},
    inventory_image = minetest.inventorycube("default_glass.png"),
    paramtype = "light",
    sunlight_propagates = true,
    is_ground_content = false,
    groups = {cracky = 3, oddly_breakable_by_hand = 3, melt = 1500},
    sounds = default.node_sound_glass_defaults(),

--  melt = "default:obsidian_glass",
})

minetest.register_node("default:obsidian_glass", {
    description = "Обсидиановое стекло",
    drawtype = "glasslike_framed_optional",
    tiles = {"default_obsidian_glass.png", "default_obsidian_glass_detail.png"},
    inventory_image = minetest.inventorycube("default_obsidian_glass.png"),
    paramtype = "light",
    is_ground_content = false,
    sunlight_propagates = true,
    sounds = default.node_sound_glass_defaults(),
    groups = {cracky = 3, oddly_breakable_by_hand = 3},
})


minetest.register_node("default:rail", {
    description = "Рельсы",
    drawtype = "raillike",
    tiles = {"default_rail.png", "default_rail_curved.png",
        "default_rail_t_junction.png", "default_rail_crossing.png",
        "default_rail_diagonal.png", "default_rail_diagonal_end.png"},
    inventory_image = "default_rail.png",
    wield_image = "default_rail.png",
    paramtype = "light",
    sunlight_propagates = true,
    walkable = false,
    is_ground_content = false,
    selection_box = {
        type = "fixed",
                -- but how to specify the dimensions for curved and sideways rails?
                fixed = {-1/2, -1/2, -1/2, 1/2, -1/2+1/16, 1/2},
    },
    groups = {bendy = 2, dig_immediate = 2, attached_node = 1,
        connect_to_raillike = minetest.raillike_group("rail")},
})


minetest.register_node("default:brick", {
    description = "Кирпичи",
    tiles = {"default_brick.png"},
    is_ground_content = false,
    groups = {cracky = 3, melt = 3500},
    sounds = default.node_sound_stone_defaults(),

--  melt = "default:lava_source",
})
--}}}

--{{{ Misc
minetest.register_node("default:cloud", {
    description = "Облако",
    tiles = {"default_cloud.png"},
    is_ground_content = false,
    sounds = default.node_sound_defaults(),
    groups = {not_in_creative_inventory = 1},
})
--}}}

--{{{ Stairs and slabs
default.stairs_and_slabs = {
    "clay",
    "tree",
    "jungletree",
    "junglewood",
    "pine_tree",
    "pine_wood",
    "acacia_tree",
    "acacia_wood",
    "ice",
    "snowblock",
    "glass",
    "obsidian_glass",
    "brick",
    "stone",
    "cobble",
    "stonebrick",
    "mossycobble",
    "sandstone",
    "sandstonebrick",
    "obsidian",
}
for _,material in pairs(default.stairs_and_slabs) do
    local name = "default:" .. material
    local def = minetest.registered_nodes[name]

    stairs.register_stair_and_slab(
        material,
        name,
        def.groups,
        def.tiles,
        def.description .. "(лестница)",
        def.description .. "(полублок)",
        def.sounds
    )
end
--}}}
