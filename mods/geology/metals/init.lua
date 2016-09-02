metals = {}
metals.registered = {}

-- How many wire crafts from metal sheet.
-- If this is >4 then it's not possible to melt wire into ingot in smelter,
-- so choose carefully.
-- Also used in anvil mod (craft recipes). Check before changing this value.
metals.WIRECOUNT = 4

-- Function that check if inventory list contains metal items.
-- Use for cheking if craft is possible
metals.contains_metals = function (invlist)
    for k, itemstack in ipairs(invlist) do
        local itemname = itemstack:get_name()
        if itemname ~= "" and (
            itemname:sub(1, itemname:find(":") - 1) == "metals"
            or minetest.get_item_group(itemname, "metal") > 0
        ) then
            return true
        end
    end

    return false
end

--{{{ metals.register_metal
metals.register_metal = function (metal, metal_desc)
    metals.registered[metal] = metal_desc

    -- Craftitems
    minetest.register_craftitem("metals:" .. metal .. "_unshaped", {
        description = metal_desc.description .. " (необработано)",
        inventory_image = "metals_" .. metal .. "_unshaped.png",
        groups = {metal = 1, unshaped = 1, level = metal_desc.level},
    })
    
    minetest.register_craftitem("metals:" .. metal .. "_ingot", {
        description = metal_desc.description .. " (слиток)",
        inventory_image = "metals_" .. metal .. "_ingot.png",
        groups = {metal = 1, ingot = 1, level = metal_desc.level},
    })
    
    minetest.register_craftitem("metals:" .. metal .. "_sheet", {
        description = metal_desc.description .. " (лист)",
        inventory_image = "metals_" .. metal .. "_sheet.png",
        groups = {metal = 1, sheet = 1, level = metal_desc.level - 1},
    })

    minetest.register_craftitem("metals:" .. metal .. "_wire", {
        description = metal_desc.description .. " (проволока)",
        inventory_image = "metals_" .. metal .. "_wire.png",
        groups = {metal = 1, wire = 1, level = metal_desc.level - 1},
    })

    -- Nodes
    minetest.register_node("metals:" .. metal .. "_block", {
        description = metal_desc.description .. " (блок)",
        tiles = {"metals_" .. metal .. "_block.png"},
        particle_image = {"metals_" .. metal .. "_block.png"},
        is_ground_content = false,
        drop = "metals:" .. metal .. "_block",
        groups = {
            snappy = 1,
            bendy = 2,
            cracky = 2,
            melty = 2,
            metal = 2,
            level = metal_desc.level,
        },
        sounds = default.node_sound_stone_defaults(),
    })
    
    -- Stair and slab
    stairs.register_stair_and_slab(
        "metals_" .. metal, 
        "metals:" .. metal .. "_block", 
        {
            snappy = 1,
            bendy = 2,
            cracky = 2,
            melty = 2,
            metal = 2,
            level = metal_desc.level,
        },
        {"metals_" .. metal .. "_block.png"},
        metal_desc.description .. " (ступени)",
        metal_desc.description .. " (полублок)",
        default.node_sound_stone_defaults()
    )

    -- Craft
    minetest.register_craft({
        output = "metals:" .. metal .. "_block",
        recipe = {
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
        }
    })

    minetest.register_craft({
        type = "shapeless",
        output = "metals:" .. metal .. "_ingot",
        recipe = { "metals:" .. metal .. "_unshaped" },
    })

    minetest.register_craft({
        type = "shapeless",
        output = "metals:" .. metal .. "_sheet",
        recipe = { "metals:" .. metal .. "_ingot" },
    })

    minetest.register_craft({
        type = "shapeless",
        output = "metals:" .. metal .. "_wire" .. metals.WIRECOUNT,
        recipe = { "metals:" .. metal .. "_sheet" },
    })

    -- Smelting
    if not metal_desc.is_alloy then
        for _, mineral in ipairs(metal_desc.minerals) do
            smelter.register_craft("metals:" .. metal .. "_unshaped", {
                items = {["minerals:" .. mineral] = 1},
                time = 5,
            })
        end
    else
        local total_count = 0
        for metal, count in pairs(metal_desc.alloy) do
            total_count = total_count + count
        end
        smelter.register_craft("metals:"..metal.."_unshaped "..total_count, {
            items = metal_desc.alloy,
            time = 7,
        })
    end
    smelter.register_craft("metals:"..metal.."_unshaped", {
        items = { ["metals:" ..metal.. "_ingot"] = 1 },
        time = 5,
    })
    smelter.register_craft("metals:"..metal.."_unshaped", {
        items = { ["metals:" ..metal.. "_sheet"] = 1 },
        time = 5,
    })
    smelter.register_craft("metals:"..metal.."_unshaped", {
        items = { ["metals:" ..metal.. "_wire"] = metals.WIRECOUNT },
        time = 5,
    })
end
--}}}

--{{{ Metals registration
------ Level 0 ------
metals.register_metal("tin", {
    description = "Олово",
    level = 0,
    uses_mod = 0.3,
    color = "#ABB0B5:127",
    is_alloy = false,
    minerals = { "cassiterite" }
})

------ Level 1 ------
metals.register_metal("copper", {
    description = "Медь",
    level = 1,
    uses_mod = 4,
    color = "#805144:127",
    is_alloy = false,
    minerals = { "malachite", "native_copper" }
})

------ Level 2 ------
metals.register_metal("lead", {
    description = "Свинец",
    level = 2,
    uses_mod = 0.17,
    color = "#5B5E65:127",
    is_alloy = false,
    minerals = { "galena" }
})

metals.register_metal("silver", {
    description = "Серебро",
    level = 2,
    uses_mod = 3,
    color = "#8C8C8C:127",
    is_alloy = false,
    minerals = { "native_silver" }
})

metals.register_metal("gold", {
    description = "Золото",
    level = 2,
    uses_mod = 2,
    color = "#A59B37:127",
    is_alloy = false,
    minerals = { "native_gold" },
})

-- Alloys
metals.register_metal("sterling_silver", {
    description = "Кхатцкое серебро",
    level = 2,
    uses_mod = 3.25,
    color = "#8F837A:127",
    is_alloy = true,
    alloy = {
        ["metals:silver_unshaped"] = 3,
        ["metals:copper_unshaped"] = 1,
    }
})

metals.register_metal("bronze", {
    description = "Бронза",
    level = 2,
    uses_mod = 7,
    color = "#60543A:127",
    is_alloy = true,
    alloy = {
        ["metals:copper_unshaped"] = 3,
        ["metals:tin_unshaped"] = 1,
    }
})

metals.register_metal("black_bronze", {
    description = "Тёмная бронза", -- изобретено ещё людьми, забыто
    level = 2,
    uses_mod = 5,
    color = "#35212E:127",
    is_alloy = true,
    alloy = {
        ["metals:copper_unshaped"] = 2,
        ["metals:gold_unshaped"] = 1,
        ["metals:silver_unshaped"] = 1,
    }
})

metals.register_metal("tumbaga", {
    description = "Тумбага", -- изобретено ещё людьми, забыто
    level = 2,
    uses_mod = 4.5,
    color = "#8B7225:127",
    is_alloy = true,
    alloy = {
        ["metals:copper_unshaped"] = 1,
        ["metals:gold_unshaped"] = 1,
    }
})

------ Level 3 ------
metals.register_metal("pig_iron", {
    description = "Чугун",
    level = 3,
    uses_mod = 2.3,
    color = "#605759:127",
    is_alloy = false,
    minerals = {"iron"}
})

-- Alloys
metals.register_metal("wrought_iron", {
    description = "Железо",
    level = 3,
    uses_mod = 4.6,
    color = "#767676:127",
    is_alloy = true,
    alloy = { ["metals:pig_iron_unshaped"] = 1 }
})

-- depends
metals.register_metal("brass", {
    description = "Латунь",
    level = 2,
    uses_mod = 5.5,
    color = "#645F3A:127",
    is_alloy = true,
    alloy = {
        ["metals:copper_unshaped"] = 2,
        ["metals:tin_unshaped"] = 1,
        ["metals:wrought_iron_unshaped"] = 1,
    }
})
metals.register_metal("rose_gold", {
    description = "Розовое золото",
    level = 2,
    uses_mod = 2.7,
    color = "#A47453:127",
    is_alloy = true,
    alloy = {
        ["metals:gold_unshaped"] = 3,
        ["metals:brass_unshaped"] = 1,
    }
})

------ Level 4 ------
-- Alloys
metals.register_metal("steel", {
    description = "Сталь",
    level = 4,
    uses_mod = 10,
    color = "#5B5E65:127",
    is_alloy = true,
    alloy = {
        ["metals:wrought_iron_unshaped"] = 2,
        ["metals:pig_iron_unshaped"] = 1,
        ["group:flux"] = 1,
    }
})

------ Level 5 ------
-- Alloys
--}}}
