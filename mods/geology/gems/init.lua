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
    rock_crystal = "ghostwhite#10",
    citrine      = "lemonchiffon",
    chatoyance   = "lightpink",
    smoky        = "lightgrey",
    morion       = "black", --dimgray??
}

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
        inventory_image = "gems_quartz.png[colorize:" .. gems.color[quartz],
    })

    minetest.register_node("gems:" .. quartz .. "_in_stone", {
        description = description .. " (руда)",
        tiles = {
            "default_stone.png^" .. 
            "(gems_quartz_ore.png[colorize:" .. gems.color[quartz] ..")"
        },
        groups = {
            cracky = 3,
            drop_on_dig  =1,
            ore = 1,
            dropping_like_stone = 1
        },
        drop = "gems:" .. quartz,
        sounds = default.node_sound_stone_defaults()
    })

    minetest.register_ore({
        ore_type = "scatter",
        ore = "gems:" .. quartz .. "_in_stone",
        wherein = "default:stone",
        clust_scarcity = 8*8*8,
        clust_num_ores = 3,
        clust_size = 2,
        y_max = 0,
        y_min = -1000,
        noise_threshhold = 1.2,
        noise_params = {
            offset = 0,
            scale = 1,
            spread = {x = 100, y = 100, z = 100},
            octaves = 3,
            persist = 0.70,
            seed = minetest.get_mapgen_params().seed
        },
    })
end
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

gems.register_drop("ores:iron_ore_in_stone", {
    ruby = gems.rare,
    opal = gems.rare,
    sapphire = gems.rare,
    topaz = gems.very_rare,
    emerald = gems.very_rare,
})

gems.register_drop("ores:cassiterite_in_stone", {
    topaz = gems.very_rare,
})

gems.register_drop("ores:native_copper_in_stone", {
    emerald = gems.very_rare,
})

gems.register_drop("ores:anthracite_in_stone", {
    diamond = gems.very_rare,
})

gems.register_drop("ores:bituminous_coal_in_stone", {
    diamond = gems.very_rare,
})

for quartz,_ in pairs(gems.quartz) do
    gems.register_drop("gems:" .. quartz .. "_in_stone", {
        ruby = gems.rare,
        amethyst = gems.rare,
        sapphire = gems.very_rare,
    })
end

gems.register_drop("ГРАНИТ", {
    topaz = gems.rare,
    emerald = gems.very_rare,
    aquamarine = gems.very_rare,
    amethyst = gems.very_rare,
    diamond = gems.very_rare,
})
--}}}
