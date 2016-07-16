minetest.register_node("pirates:yellow_star", {
    description = "Желтая морская звезда",
    inventory_image = "star_yellow.png",
    drawtype = "nodebox",
    paramtype = "light",
    tiles = {"star_yellow.png"},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.49, 0.5 }
        },
    },
	selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5 }
        },
    },
	groups = { snappy = 3 },
})

minetest.register_node("pirates:yellow_star_sand", {
    description = "Песок с желтой морской звездой",
    inventory_image = "default_sand.png^star_yellow.png",
    tiles = {"default_sand.png^star_yellow.png", "default_sand.png"},
    groups = {crumbly = 3, falling_node = 1, sand = 1},
    sounds = default.node_sound_sand_defaults(),
    on_punch = function(pos, node, puncher, pointed_thing)
        puncher:get_inventory():add_item("main", "pirates:star_yellow")
        minetest.set_node(pos, {name="default:sand"})
    end,
})

minetest.register_node("pirates:blue_star", {
    description = "Синяя морская звезда",
    inventory_image = "star_blue.png",
    drawtype = "nodebox",
    paramtype = "light",
    tiles = {"star_blue.png"},
    node_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.49, 0.5 }
        },
    },
	selection_box = {
        type = "fixed",
        fixed = {
            {-0.5, -0.5, -0.5, 0.5, -0.4, 0.5 }
        },
    },
	groups = { snappy = 3 },
})

minetest.register_node("pirates:blue_star_sand", {
    description = "Песок с синей морской звездой",
    inventory_image = "default_sand.png^star_blue.png",
    tiles = {"default_sand.png^star_blue.png", "default_sand.png"},
    groups = {crumbly = 3, falling_node = 1, sand = 1},
    sounds = default.node_sound_sand_defaults(),
    on_punch = function(pos, node, puncher, pointed_thing)
        puncher:get_inventory():add_item("main", "pirates:blue_star")
        minetest.set_node(pos, {name="default:sand"})
    end,
})

minetest.register_node("pirates:skeleton", {
	description = "Скелет",
    drawtype = "mesh",
    paramtype = "light",
    mesh = "skeleton.b3d",
    tiles = {"skeleton.png"},
    visual_scale = 0.12,
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	is_ground_content = false,
	selection_box = {
        type = "fixed",
        fixed = {
            {-0.25, -0.5, -0.5, 0.25, -0.25, 0.6 }
        },
    },
	groups = { oddly_breakable_by_hand = 1 }
})

minetest.register_craftitem("pirates:perl", {
    description = "Жемчужена",
    inventory_image = "perl.png",
     wield_image = "perl.png",
})

minetest.register_node("pirates:shell_1", {
	description = "Ракушка",
    drawtype = "plantlike",
    paramtype = "light",
    tiles = {"shell_1.png"},
    groups = {crumbly = 3},
})

minetest.register_node("pirates:shell_2", {
	description = "Ракушка с жемчуженой",
    drawtype = "plantlike",
    paramtype = "light",
    tiles = {"shell_2.png"},
    groups = {crumbly = 3},
})

minetest.register_node("pirates:shell_3", {
	description = "Ракушка",
    drawtype = "nodebox",
    paramtype = "light",
    tiles = {"shell_3.png"},
	paramtype2 = "facedir",
	legacy_facedir_simple = true,
	is_ground_content = false,
    node_box = {
        type = "fixed",
        fixed = {
            {0, -0.5, -0.4, 0, 0, 0.4 }
        },
    },
    groups = {crumbly = 3},
})

minetest.register_node("pirates:shell_4", {
	description = "Ракушка",
    drawtype = "plantlike",
    paramtype = "light",
    tiles = {"shell_3.png"},
    groups = {crumbly = 3},
})

minetest.register_node("pirates:flower_1", {
	description = "Экзотический цветок",
    drawtype = "plantlike",
    paramtype = "light",
    tiles = {"flower_1.png"},
    groups = {snappy = 2, dig_immediate = 3, flammable = 2,
        attached_node = 1, sapling = 1},
    sounds = default.node_sound_leaves_defaults(),
})

minetest.register_node("pirates:flower_2", {
	description = "Экзотический цветок",
    drawtype = "plantlike",
    paramtype = "light",
    tiles = {"flower_2.png"},
    groups = {snappy = 2, dig_immediate = 3, flammable = 2,
        attached_node = 1, sapling = 1},
    sounds = default.node_sound_leaves_defaults(),
})
