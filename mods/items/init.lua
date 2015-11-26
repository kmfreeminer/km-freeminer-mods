items = {}

items.tools = {
    pick   = "Кирка",
    shovel = "Лопата",
    axe    = "Топор",
    hammer = "Молот",
    hoe    = "Мотыга",
    scythe = "Коса",
    -- Удочка
}

items.weapons = {
    dagger          = "Кинжал",
    stiletto        = "Стилет",
    throwing_knife  = "Метательный нож",
    throwing_axe    = "Метательный топорик",
    club            = "Дубина",
    sword           = "Короткий меч",
    scimitar        = "Ятаган",
    saber           = "Сабля",
    smallsword      = "Шпага",
    battle_axe      = "Секира",
    twohanded_sword = "Двуручный меч",
    trident         = "Трезубец",
    spear           = "Копьё",
    halberd         = "Алебарда",
    shortbow        = "Короткий лук",
    longbow         = "Длинный лук",
    crossbow        = "Арбалет",
    arrow           = "Стрела",
    morning_star    = "Моргенштерн",
    flail           = "Цеп",
}

for item, name in pairs(items.tools) do
    for metal, metaldef in pairs(metals.registered) do
        minetest.register_tool("items:" .. item .. "_" .. metal, {
            description = name .. "(" .. metaldef.description .. ")",
            inventory_image = "items_" .. item .. "_hand.png" ..
                "^(" ..
                    "items_" .. item .. "_head.png" ..
                    "^[colorize:" .. metaldef.color ..
                ")",
            range = 2.0,

            tool_capabilities = {
                full_punch_interval = 1.0,
                max_drop_level=0,
                groupcaps={
                    snappy={times={[2]=0.80, [3]=0.40}, maxwear=0.05, maxlevel=1},
                    choppy={times={[3]=0.90}, maxwear=0.05, maxlevel=0}
                },
                damage_groups = {groupname=damage},
            },
        })
    end
end
