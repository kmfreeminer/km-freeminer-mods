ores = {}

--{{{ Functions

-- Seed for noise_params
ores.d_seed = 0

-- lua don't have a default function for this ☹
local function copytable(t)
    t2 = {}
    for k,i in pairs(t) do
        t2[k] = i
    end
    return t2
end

function ores.register_ore(name, OreDef)
    -- Define ore params (or use defaults)
    local ore = {
        name = name,
        description = OreDef.description or "Ore",
        mineral = OreDef.mineral or "minerals:"..name:remove_modname_prefix(),
        wherein = OreDef.wherein or {"default:stone"},
        ore_type = "scatter",
        clust_scarcity = 1/(OreDef.chunks_per_volume or 1/3/3/3/2),
        clust_size = OreDef.chunk_size or 3,
        clust_num_ores = OreDef.ore_per_chunk or 10,
        height_min = OreDef.height_min or -30912,
        height_max = OreDef.height_max or 30912,
        noise_threshhold = OreDef.noise_min or 1.2,
        noise_params = {offset=0, scale=1, spread={x=100, y=100, z=100}, octaves=3, persist=0.70, seed = OreDef.delta_seed or ores.d_seed},
    }
    ores.d_seed = ores.d_seed + 1
    ore.particle_image = OreDef.particle_image or ore.mineral:gsub(":","_")..".png"

    -- Register ore nodes
    local name_ = name:gsub(":","_")
    for i, wherein in ipairs(ore.wherein) do
        local wherein_ = wherein:gsub(":","_")
        local wherein_textures = {}
        if minetest.registered_nodes[wherein].tiles or minetest.registered_nodes[wherein].tile_images then
            for _, texture in ipairs(minetest.registered_nodes[wherein].tiles) do
                table.insert(wherein_textures, texture.."^"..name_..".png")
            end
        else
            wherein_textures = {name_..".png"}
        end
        minetest.register_node(":"..name.."_in_"..wherein_, {
            description = ore.description .. " (руда)",
            tiles = wherein_textures,
            particle_image = {ore.particle_image},
            groups = {cracky=3,drop_on_dig=1,ore=1,dropping_like_stone=1},
            drop = {
                max_items = 1,
                items = {
                    {
                        items = {ore.mineral.." 2"},
                        rarity = 2
                    },
                    {
                        items = {ore.mineral}
                    }
                }
            },
            sounds = default.node_sound_stone_defaults()
        })

        -- Register ore
        if not OreDef.generate == false then
            -- copy is needed becouse some ores are in several whereins,
            -- so there be several different tables
            local oredef = copytable(ore)
            oredef.ore = name.."_in_"..wherein_
            oredef.wherein = wherein
            minetest.register_ore(oredef)
        end
    end
end
--}}}

--{{{ Ores registration

-- This ores will not be regitered by the "for" cycle
ores.manual_reg = {
    lignite = true,
    anthracite = true,
    bituminous_coal = true,
    native_copper = true,
    native_gold = true,
    graphite = true,
    pitchblende = true,
    sulfur = true,
    charcoal = true,
    flux = true,
    borax = true,
}

for ore, ore_desc in pairs(minerals.list) do
    if not ores.manual_reg[ore] then
        ores.register_ore("ores:"..ore, {description = ore_desc}) 
    end
end

-- Semi-manual registration, becouse not all parameters are defaults
ores.register_ore("ores:native_copper", {
    description = minerals.list["native_copper"],
    wherein = {"default:stone", "default:desert_stone"}
})

ores.register_ore("ores:native_gold", {
    description = minerals.list["native_gold"],
    wherein = {"default:stone", "default:desert_stone"}
})

ores.register_ore("ores:lignite", {
    description = minerals.list["lignite"],
    height_max = -500,
    height_min = -3000,
    ore_per_chunk = 15,
    chunks_per_volume = 1/3/3/3,
})

ores.register_ore("ores:bituminous_coal", {
    description = minerals.list["bituminous_coal"],
    height_max = -3000,
    height_min = -6000,
    ore_per_chunk = 15,
    chunks_per_volume = 1/3/3/3,
})

ores.register_ore("ores:anthracite", {
    description = minerals.list["anthracite"],
    height_max = -6000,
    height_min = -8000,
    ore_per_chunk = 15,
    chunks_per_volume = 1/3/3/3,
})

ores.register_ore("ores:graphite", {
    description = minerals.list["graphite"],
    height_max = -8000,
    ore_per_chunk = 15,
})
--}}}

--{{{ Manual registration

-- Sulfur
-- Ore is not registered
minetest.register_node("ores:sulfur", {
    description = "Руда серы",
    tile_images = {"default_stone.png^ores_sulfur.png"},
    particle_image = {"minerals_sulfur.png"},
    paramtype = "light",
    groups = {cracky=3,drop_on_dig=1,dig_immediate=2},
    drop = {
        max_items = 1,
        items = {
            {
                items = {"minerals:sulfur 3"},
                rarity = 15,
            },
            {
                items = {"minerals:sulfur 2"},
            }
        }
    },
})

-- Peat
minetest.register_node("ores:peat", {
    description = "Торф",
    tile_images = {"ores_peat.png"},
    particle_image = {"ores_peat.png"},
    groups = {crumbly=3,drop_on_dig=1,falling_node=1},
    sounds = default.node_sound_dirt_defaults(),
})

minetest.register_craft({
    type = "fuel",
    recipe = "ores:peat",
    burntime = 15
})

minetest.register_ore({
    ore_type       = "scatter",
    ore            = "ores:peat",
    wherein        = "default:dirt",
    clust_scarcity = 20*20*20,
    clust_num_ores = 343,
    clust_size     = 7,
    height_min     = -31000,
    height_max     = 0,
})
--}}}
