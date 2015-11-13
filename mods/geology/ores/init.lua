ores = {}

ores.list = {
    granite = "Гранит",
    marble = "Мрамор",
    limestone = "Известняк",
}

-- This ores will not be regitered by the "for" cycle
ores.manual_reg = {
    anthracite = true,
    bituminous_coal = true,
    charcoal = true,
    sulfur = true,
    -----------------------
    granite = true,
}

--{{{ Functions
function ores.register_ore(name, oredef)
    local name_ = name:gsub(":","_")
    local wherein_name = oredef.wherein or "default:stone"

    -- Generate textures
    local tiles = nil
    if oredef.tiles then
        tiles = oredef.tiles
    else
        tiles = {}

        local wherein = minetest.registered_nodes[wherein_name]
        if wherein.tiles then
            for _, texture in ipairs(wherein.tiles) do
                table.insert(tiles, texture .. "^" .. name_ .. ".png")
            end
        else
            tiles = {name_ .. ".png"}
        end
    end
    
    -- Register node
    minetest.register_node(name, {
        description = oredef.description or "Руда",
        tiles = tiles,
        groups = oredef.groups or {
            cracky = 3,
            ore = 1,
        },
        drop = oredef.drop
            or oredef.mineral
            or "minerals:" .. default.strip_modname(name),
        sounds = oredef.sounds or default.node_sound_stone_defaults()
    })

    -- Register ore
    oredef.ore = name
    minetest.register_ore({
        ore_type = oredef.ore_type or "scatter",
        ore = name,
        wherein = wherein_name,
        clust_scarcity = oredef.ore_scarcity or 3*3*3*2,
        clust_num_ores = oredef.ore_num_ores or 3,
        clust_size = oredef.ore_clust_size or 10,
        y_max = oredef.y_max or 30912,
        y_min = oredef.y_min or -30912,
        flags = oredef.ore_flags or "",
        noise_threshhold = oredef.noise_threshhold or 1.2,
        noise_params = {
            offset = 0,
            scale = 1,
            spread = {x = 100, y = 100, z = 100},
            octaves = 3,
            persist = 0.70,
            seed = oredef.delta_seed or minetest.get_mapgen_params().seed
        },
        random_factor = oredef.vein_random_factor or 1.0,
        biomes = oredef.biomes or nil,
    })
end
--}}}

--{{{ Ores registration
for ore, ore_desc in pairs(minerals.list) do
    if not ores.manual_reg[ore] then
        ores.register_ore("ores:" .. ore, {
            description = ore_desc .. " (руда)"
        }) 
    end
end

for _, ore in pairs({"marble", "limestone"}) do
    ores.register_ore("ores:" .. ore, {
        description = ores.list[ore],
        drop = "ores:" .. ore,
        groups = {
            cracky = 3,
            ore = 1, flux = 1,
        },
    }) 
end

ores.register_ore("ores:granite", {
    description = ores.list.granite,
    tiles = {"ores_granite.png"},
    groups = {
        cracky = 1,
        ore = 1,
    },
    drop = "ores:granite",
    
    ore_type = "sheet",
    --ore_scarcity or 3*3*3*2,
    ore_num_ores = 500000,
    ore_clust_size = 100,
})

ores.register_ore("ores:bituminous_coal", {
    description = minerals.list["bituminous_coal"],
    y_max = -3000,
    y_min = -6000,
    ore_num_ores = 15,
    ore_scarcity = 3*3*3,
})

ores.register_ore("ores:anthracite", {
    description = minerals.list["anthracite"],
    y_max = -6000,
    y_min = -8000,
    ore_num_ores = 15,
    ore_scarcity = 3*3*3,
})

ores.register_ore("ores:sulfur", {
    description = "Руда серы",
    tiles = {"default_stone.png^ores_sulfur.png"},
    groups = {cracky = 3, dig_immediate = 2},
    drop = {
        max_items = 1,
        items = {
            { items = {"minerals:sulfur 3"},
              rarity = 15,
            },
            { items = {"minerals:sulfur 2"},
            }
        }
    },
    ore_scarcity = 8*8*8,
    ore_num_ores = 5,
    ore_clust_size = 3,
    y_min = -1000,
    y_max = -5000,
})
--}}}
