items = {}

--{{{ Definitions
items.weapons_groupcaps = {
    crumbly = {uses = 100, times = {10.0, 9.0, 8.0} },
    cracky = {uses = 10, times = {10.0, 9.0, 8.0} },
    snappy = {uses = 30, times = {1.2, 0.9, 0.5} },
    choppy = {uses = 20, times = {2.0, 1.6, 1.2} },
}

items.tools_metal = {
    -- Tools
    pick   = {"Кирка", {cracky = {uses = 20, times = {1.60, 1.20, 0.80}} }, 2},
    shovel = {"Лопата",{crumbly = {uses = 20, times = {1.60, 1.20, 0.80}} }, 2},
    axe    = {"Топор", {choppy = {uses = 20, times = {1.60, 1.20, 0.80}} }, 2},
    hammer = {"Молот",
        {
            cracky = {uses = 20, times = {1.60, 1.20, 0.80}},
            anvil = {uses = 100},
        },
        2
    },
    hoe    = {"Мотыга",{crumbly = {uses = 20, times = {1.60, 1.20, 0.80}} }, 1},
    scythe = {"Коса",  {snappy = {uses = 20, times = {1.60, 1.20, 0.80}} }, 3},

    -- Kitchen tools
    fork  = {"Вилка", {
        crumbly = {uses = 10, times = {10.0, 9.0, 8.0} },
        cracky  = {uses = 10, times = {10.0, 9.0, 8.0} },
    }},
    spoon = {"Ложка", {
        crumbly = {uses = 10, times = {10.0, 9.0, 8.0} },
        cracky  = {uses = 10, times = {10.0, 9.0, 8.0} },
    }},
    knife = {"Нож", items.weapons_groupcaps, 1},

    -- Weapons
    dagger          = {"Кинжал",              items.weapons_groupcaps, 1},
    stiletto        = {"Стилет",              items.weapons_groupcaps, 1},
    throwing_knife  = {"Метательный нож",     items.weapons_groupcaps, 1},
    throwing_axe    = {"Метательный топорик", items.weapons_groupcaps, 1},
    sword           = {"Короткий меч",        items.weapons_groupcaps, 3},
    scimitar        = {"Ятаган",              items.weapons_groupcaps, 3},
    saber           = {"Сабля",               items.weapons_groupcaps, 3},
    smallsword      = {"Шпага",               items.weapons_groupcaps, 3},
    battle_axe      = {"Секира",              items.weapons_groupcaps, 3},
    twohanded_sword = {"Двуручный меч",       items.weapons_groupcaps, 4},
    trident         = {"Трезубец",            items.weapons_groupcaps, 4},
    spear           = {"Копьё",               items.weapons_groupcaps, 4},
    halberd         = {"Алебарда",            items.weapons_groupcaps, 4},
    morning_star    = {"Моргенштерн",         items.weapons_groupcaps, 3},
    flail           = {"Цеп",                 items.weapons_groupcaps, 3},
}

items.tools = {

    -- Weapons
    club            = {"Дубина",              items.weapons_groupcaps, 2},
    shortbow        = {"Короткий лук",        items.weapons_groupcaps, 2},
    longbow         = {"Длинный лук",         items.weapons_groupcaps, 3},
    crossbow        = {"Арбалет",             items.weapons_groupcaps, 3},
    arrow           = {"Стрела",              items.weapons_groupcaps},
}
--}}}

--{{{ Tools registration
for item, itemdef in pairs(items.tools_metal) do
    for metal, metaldef in pairs(metals.registered) do
        local groupcaps = table.copy(itemdef[2])
        for _, group in pairs(groupcaps) do
            if metaldef.uses_mod then
                group.uses = group.uses * metaldef.uses_mod
            end
        end

        local damage = nil
        if itemdef[3] then damage = {fudge = itemdef[3]} end

        if metaldef.color == nil then metaldef.color = "#000000:0" end

        minetest.register_tool("items:" .. item .. "_" .. metal, {
            description = itemdef[1] ..
                "(" .. metaldef.description:lower_cyr() .. ")",
            inventory_image = "items_" .. item .. "_hand.png" ..
                "^(" ..
                    "items_" .. item .. "_head.png" ..
                    "^[colorize:" .. metaldef.color ..
                ")",
            range = 2.0,

            tool_capabilities = {
                full_punch_interval = 1.0,
                max_drop_level = 0,
                groupcaps = groupcaps,
                damage_groups = damage,
            },
        })
    end
end

for item, itemdef in pairs(items.tools) do
    local groupcaps = table.copy(itemdef[2])

    local damage = nil
    if itemdef[3] then damage = {fudge = itemdef[3]} end

    minetest.register_tool("items:" .. item, {
        description = itemdef[1],
        inventory_image = "items_" .. item .. ".png",
        range = 2.0,

        tool_capabilities = {
            full_punch_interval = 1.0,
            max_drop_level = 0,
            groupcaps = groupcaps,
            damage_groups = damage,
        },
    })
end

minetest.register_tool("items:hammer_stone", {
    description = "Каменный молот",
    inventory_image = "items_hammer_hand.png^items_hammer_head.png",
    range = 2.0,

    tool_capabilities = {
        full_punch_interval = 1.0,
        max_drop_level = 0,
        groupcaps = {
            cracky = {uses = 10, times = {1.60, 1.20, 0.80}},
            anvil = {uses = 50},
        },
        damage_groups = {fudge = 2},
    },
})
--}}}

--{{{ Craftitems registration
minetest.register_craftitem("items:fishing_rod", {
    description = "Удочка",
    inventory_image = "items_fishing_rod.png",
    liquids_pointable = true,
})

minetest.register_craftitem("items:smoking_pipe", {
    description = "Курительная трубка",
    inventory_image = "items_smoking_pipe.png",
})
--}}}

--{{{ Craft recipes with metals
for metal, metaldef in pairs(metals.registered) do
    crafter.register_craft({
        type = "anvil",
        output = "items:fork_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:spoon_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:knife_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:dagger_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
            {"default:stick"}
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:stiletto_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
            {"default:stick"}
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:throwing_knife_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
            {"default:stick"}
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:axe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet", "metals:" .. metal .. "_sheet"},
            {"metals:" .. metal .. "_sheet", "default:stick"},
            {                  "", "default:stick"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:axe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet", "metals:" .. metal .. "_sheet"},
            {"default:stick",      "metals:" .. metal .. "_sheet"},
            {"default:stick",      ""},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:throwing_axe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet", "metals:" .. metal .. "_sheet"},
            {"metals:" .. metal .. "_sheet", "default:stick"},
            {                  "", "default:stick"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:throwing_axe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet", "metals:" .. metal .. "_sheet"},
            {"default:stick",      "metals:" .. metal .. "_sheet"},
            {"default:stick",      ""},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:battle_axe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet", "metals:" .. metal .. "_sheet"},
            {"metals:" .. metal .. "_sheet", "default:stick"},
            {                  "", "default:stick"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:battle_axe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet", "metals:" .. metal .. "_sheet"},
            {"default:stick",      "metals:" .. metal .. "_sheet"},
            {"default:stick",      ""},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:sword_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot"},
            {"metals:" .. metal .. "_ingot"},
            {"default:stick"},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:scimitar_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
            {"metals:" .. metal .. "_sheet"},
            {"default:stick"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:saber_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
            {"metals:" .. metal .. "_sheet"},
            {"default:stick"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:smallsword_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
            {"metals:" .. metal .. "_sheet"},
            {"default:stick"},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:saber_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot"},
            {"metals:" .. metal .. "_ingot"},
            {"metals:" .. metal .. "_ingot"},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:trident_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot"},
            {"default:stick"},
            {"default:stick"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:spear_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot"},
            {"default:stick"},
            {"default:stick"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:halberd_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot"},
            {"default:stick"},
            {"default:stick"},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:morning_star_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot"},
            {"metals:" .. metal .. "_wire"},
            {"default:stick"},
        }
    })
    
    crafter.register_craft({
        type = "anvil",
        output = "items:flail_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot"},
            {"metals:" .. metal .. "_wire"},
            {"default:stick"},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:pick_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
            {                  "",      "default:stick",                   ""},
            {                  "",      "default:stick",                   ""},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:shovel_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_sheet"},
            {"default:stick"},
            {"default:stick"},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:hammer_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
            {                  "",      "default:stick",                   ""},
        }
    })

    --

    crafter.register_craft({
        type = "anvil",
        output = "items:hoe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
            {                  "",      "default:stick"},
            {                  "",      "default:stick"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:hoe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
            {     "default:stick",                   ""},
            {     "default:stick",                   ""},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:scythe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
            {                  "",      "default:stick"},
            {                  "",      "default:stick"},
        }
    })

    crafter.register_craft({
        type = "anvil",
        output = "items:scythe_" .. metal,
        recipe = {
            {"metals:" .. metal .. "_ingot", "metals:" .. metal .. "_ingot"},
            {     "default:stick",                   ""},
            {     "default:stick",                   ""},
        }
    })
end
--}}}

--{{{ Regular craft recipes

-- Tools
minetest.register_craft({
    output = "items:hammer_stone",
    recipe = {
        {"default:cobble", "default:cobble", "default:cobble"},
        {"default:cobble", "default:cobble", "default:cobble"},
        {              "",  "default:stick",               ""},
    }
})

-- Weapons
minetest.register_craft({
    output = "items:club",
    recipe = {
        {"default:stick"},
        {"default:stick"},
    }
})

minetest.register_craft({
    output = "items:shortbow",
    recipe = {
        {"default:stick", "default:string"},
        {"default:stick", "default:string"},
    }
})

minetest.register_craft({
    output = "items:shortbow",
    recipe = {
        {"default:string", "default:stick"},
        {"default:string", "default:stick"},
    }
})

minetest.register_craft({
    output = "items:longbow",
    recipe = {
        {             "", "default:stick", "default:string"},
        {"default:stick",              "", "default:string"},
        {             "", "default:stick", "default:string"},
    }
})

minetest.register_craft({
    output = "items:longbow",
    recipe = {
        {"default:string", "default:stick",              ""},
        {"default:string",              "", "default:stick"},
        {"default:string", "default:stick",              ""},
    }
})

minetest.register_craft({
    output = "items:crossbow",
    recipe = {
        { "default:stick",    "group:ingot", "default:stick"},
        {    "group:wire", "default:string",    "group:wire"},
        {              "",  "default:stick",              ""},
    }
})

minetest.register_craft({
    output = "items:arrow",
    recipe = {
        {"group:ingot"},
        {"default:stick"},
        {"default:feather"}
    }
})

-- Craftitems
minetest.register_craft({
    output = "items:fishing_rod",
    recipe = {
        { "default:stick",              "", ""},
        {"default:string", "default:stick", ""},
        {"default:string", "", "default:stick"}
    }
})

minetest.register_craft({
    output = "items:fishing_rod",
    recipe = {
        {"",              "",  "default:stick"},
        {"", "default:stick", "default:string"},
        {"default:stick", "", "default:string"}
    }
})

minetest.register_craft({
    output = "items:smoking_pipe",
    recipe = {
        {"", "default:stick"},
        {"default:stick", ""}
    }
})

minetest.register_craft({
    output = "items:smoking_pipe",
    recipe = {
        {"default:stick", ""},
        {"", "default:stick"}
    }
})
--}}}



minetest.register_tool("items:mage_staff", {
    description = "Посох алого пламени",
    inventory_image = "items_mage_staff.png",
    range = 2.0,
})
