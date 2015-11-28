items = {}

items.weapons_groupcaps = {
    crumbly = {uses = 100, times = {10.0, 9.0, 8.0} },
    cracky = {uses = 10, times = {10.0, 9.0, 8.0} },
    snappy = {uses = 30, times = {1.2, 0.9, 0.5} },
    choppy = {uses = 20, times = {2.0, 1.6, 1.2} },
}

items.tools = {
    -- Tools
    pick   = {"Кирка", {cracky = {uses = 20, times = {1.60, 1.20, 0.80}} }},
    shovel = {"Лопата",{crumbly = {uses = 20, times = {1.60, 1.20, 0.80}} }},
    axe    = {"Топор", {choppy = {uses = 20, times = {1.60, 1.20, 0.80}} }},
    hammer = {"Молот", {
        cracky = {uses = 20, times = {1.60, 1.20, 0.80}},
        anvil = {uses = 100},
    }},
    hoe    = {"Мотыга",{crumbly = {uses = 20, times = {1.60, 1.20, 0.80}} }},
    scythe = {"Коса",  {snappy = {uses = 20, times = {1.60, 1.20, 0.80}} }},
    -- Удочка

    -- Weapons
    dagger          = {"Кинжал",              items.weapons_groupcaps, 1},
    stiletto        = {"Стилет",              items.weapons_groupcaps, 1},
    throwing_knife  = {"Метательный нож",     items.weapons_groupcaps, 1},
    throwing_axe    = {"Метательный топорик", items.weapons_groupcaps, 1},
    club            = {"Дубина",              items.weapons_groupcaps, 2},
    sword           = {"Короткий меч",        items.weapons_groupcaps, 3},
    scimitar        = {"Ятаган",              items.weapons_groupcaps, 3},
    saber           = {"Сабля",               items.weapons_groupcaps, 3},
    smallsword      = {"Шпага",               items.weapons_groupcaps, 3},
    battle_axe      = {"Секира",              items.weapons_groupcaps, 3},
    twohanded_sword = {"Двуручный меч",       items.weapons_groupcaps, 4},
    trident         = {"Трезубец",            items.weapons_groupcaps, 4},
    spear           = {"Копьё",               items.weapons_groupcaps, 4},
    halberd         = {"Алебарда",            items.weapons_groupcaps, 4},
    shortbow        = {"Короткий лук",        items.weapons_groupcaps, 2},
    longbow         = {"Длинный лук",         items.weapons_groupcaps, 3},
    crossbow        = {"Арбалет",             items.weapons_groupcaps, 3},
    arrow           = {"Стрела",              items.weapons_groupcaps, 0},
    morning_star    = {"Моргенштерн",         items.weapons_groupcaps, 3},
    flail           = {"Цеп",                 items.weapons_groupcaps, 3},
}

for item, itemdef in pairs(items.tools) do
    for metal, metaldef in pairs(metals.registered) do
        local groupcaps = table.copy(itemdef[2])
        for _, group in pairs(groupcaps) do
            if metaldef.uses_mod then
                group.uses = group.uses * metaldef.uses_mod
            end
        end

        local damage = nil
        if itemdef[3] then damage = {fudge = itemdef[3]} end

        if metaldef.color == nil then metaldef.color = "#606060:0" end

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
