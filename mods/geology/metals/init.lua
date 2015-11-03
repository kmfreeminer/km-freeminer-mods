metals = {}

metals.registered = {}

metals.register_metal = function (metal, metal_desc)
    metals.registered[metal] = metal_desc

    --{{{ Craftitems
    minetest.register_craftitem("metals:" .. metal .. "_unshaped", {
        description = metal_desc.description .. " (необработано)",
        inventory_image = "metals_" .. metal .. "_unshaped.png",
    })
    
    minetest.register_craftitem("metals:" .. metal .. "_ingot", {
        description = metal_desc.description .. " (слиток)",
        inventory_image = "metals_" .. metal .. "_ingot.png",
    })
    
    --[[
    minetest.register_craftitem("metals:" .. metal .. "_doubleingot", {
        description = metal_desc.description .. " Double Ingot",
        inventory_image = "metals_" .. metal .. "_doubleingot.png",
    })
    --]]
    
    minetest.register_craftitem("metals:" .. metal .. "_sheet", {
        description = metal_desc.description .. " (лист)",
        inventory_image = "metals_" . .. metal .. "_sheet.png",
    })
    
    --[[
    minetest.register_craftitem("metals:" .. metal .. "_doublesheet", {
        description = metal_desc.description .. " Double Sheet",
        inventory_image = "metals_" .. metal .. "_doublesheet.png",
    })
    --]]
    --}}}

    --{{{ Nodes
    minetest.register_node("metals:" .. metal .. "_block", {
        description = metal_desc.description .. " (блок)",
        tiles = {"metals_" .. metal .. "_block.png"},
        particle_image = {"metals_" .. metal .. "_block.png"},
        is_ground_content = false,
        drop = "metals:" .. metal .. "_block",
        groups = {snappy=1,bendy=2,cracky=2,melty=2,level=2,drop_on_dig=1},
        sounds = default.node_sound_stone_defaults(),
    })
    --[[ нужно или нет?
    realtest.register_stair("metals:" .. metal .. "_block",nil,nil,nil,metal_desc.description .. " Stair",nil,
            "metals:" .. metal .. "_doubleingot 3")
    realtest.register_slab("metals:" .. metal .. "_block",nil,nil,nil,metal_desc.description .. " Slab",nil,
            "metals:" .. metal .. "_doubleingot 2")
    --]]
    --}}}

    --{{{ Craft
    --[[ в мод на наковальню
    minetest.register_craft({
        output = "metals:" .. metal .. "_block",
        recipe = {
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
        }
    })
    --]]

    --[[ нужно или нет?
    minetest.register_craft({
        output = "metals:" .. metal .. "_block_slab",
        recipe = {
            {"metals:" .. metal .. "_doubleingot","metals:" .. metal .. "_doubleingot"},
        },
    })
    minetest.register_craft({
        output = "metals:" .. metal .. "_block_stair",
        recipe = {
            {"metals:" .. metal .. "_doubleingot",""},
            {"metals:" .. metal .. "_doubleingot","metals:" .. metal .. "_doubleingot"},
        },
    })
    minetest.register_craft({
        output = "metals:" .. metal .. "_block_stair",
        recipe = {
            {"","metals:" .. metal .. "_doubleingot"},
            {"metals:" .. metal .. "_doubleingot","metals:" .. metal .. "_doubleingot"},
        },
    })
    --]]
    --}}}

    --{{{ Smelting
    if not metal_desc.is_alloy then
        for _, mineral in ipairs(metal_desc.minerals) do
            crafter.register_craft({
                type = "melt",
                recipe = { {"minerals:" .. mineral} },
                output = "metals:" .. metal .. "_unshaped",
            })
        end
    else
        local count = 0
        for _, row in ipairs(metal_desc.alloy) do
            count = count + #row
        end
        crafter.register_craft({
            type = "melt",
            recipe = metal_desc.alloy,
            output = "metals:" .. metal .. "_unshaped " .. count,
        })
    end
    --}}}
end

--{{{ Metals registration
------ Level 0 ------
metals.register_metal("tin", {
    description = "Олово",
    level = 0,
    is_alloy = false,
    minerals = { "cassiterite" }
})

------ Level 1 ------
metals.register_metal("copper", {
    description = "Медь",
    level = 1,
    is_alloy = false,
    minerals = { "malachite", "native_copper" }
})

------ Level 2 ------
metals.register_metal("lead", {
    description = "Свинец",
    level = 2,
    is_alloy = false,
    minerals = { "galena" }
})

metals.register_metal("silver", {
    description = "Серебро",
    level = 2,
    is_alloy = false,
    minerals = { "native_silver" }
})

metals.register_metal("gold", {
    description = "Золото",
    level = 2,
    is_alloy = false,
    minerals = { "native_gold" },
})

-- Alloys
metals.register_metal("brass", {
    description = "Латунь",
    level = 2,
    is_alloy = true,
    alloy = {
        {"metals:copper_unshaped","metals:copper_unshaped"},
        {"metals:copper_unshaped","metals:wrought_iron_unshaped"}
    }
})

metals.register_metal("sterling_silver", {
    description = "Кхатцкое серебро",
    level = 2,
    is_alloy = true,
    alloy = {
        {"metals:silver_unshaped","metals:silver_unshaped"},
        {"metals:silver_unshaped","metals:copper_unshaped"}
    }
})

metals.register_metal("rose_gold", {
    description = "Розовое золото",
    level = 2,
    is_alloy = true,
    alloy = {
        {"metals:gold_unshaped","metals:gold_unshaped"},
        {"metals:gold_unshaped","metals:brass_unshaped"}
    }
})

metals.register_metal("bronze", {
    description = "Бронза",
    level = 2,
    is_alloy = true,
    alloy = {
        {"metals:copper_unshaped","metals:copper_unshaped"},
        {"metals:copper_unshaped","metals:tin_unshaped"}
    }
})

metals.register_metal("black_bronze", {
    description = "Тёмная бронза", -- изобретено ещё людьми, забыто
    level = 2,
    is_alloy = true,
    alloy = {
        {"metals:copper_unshaped","metals:copper_unshaped"},
        {"metals:gold_unshaped","metals:silver_unshaped"}
    }
})

metals.register_metal("tumbaga", {
    description = "Тумбага", -- изобретено ещё людьми, забыто
    level = 2,
    is_alloy = true,
    alloy = {
        {"metals:copper_unshaped","metals:copper_unshaped"},
        {"metals:gold_unshaped","metals:gold_unshaped"}
    }
})

------ Level 3 ------
metals.register_metal("pig_iron", {
    description = "Чугун",
    level = 3,
    is_alloy = false,
    minerals = {"iron_ore"}
})

-- Alloys
metals.register_metal("wrought_iron", {
    description = "Железо",
    level = 3,
    is_alloy = true,
    alloy = { {"metals:pig_iron_unshaped"} }
})

------ Level 4 ------
-- Alloys
metals.register_metal("steel", {
    description = "Сталь",
    level = 4,
    is_alloy = true,
    alloy = {
        {"metals:wrought_iron_unshaped","metals:wrought_iron_unshaped"},
        {"metals:pig_iron_unshaped","group:flux"}
    }
})

------ Level 5 ------
-- Alloys
--}}}
