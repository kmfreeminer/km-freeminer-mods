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

minetest.register_node("pirates:shell_1", {
	description = "Ракушка",
    drawtype = "plantlike",
    paramtype = "light",
    tiles = {"shell_1.png"},
    groups = {crumbly = 3},
})

minetest.register_node("pirates:shell_2", {
	description = "Ракушка",
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
