minerals = {}

minerals.list = {
    anthracite      = "Антрацит",
    bituminous_coal = "Каменный уголь",
    charcoal        = "Древесный уголь",
    ---------------------------------------
    iron_ore        = "Железная руда",
    cassiterite     = "Касситерит",
    galena          = "Галенит",
    native_copper   = "Самородная медь",
    native_gold     = "Самородное золото",
    native_silver   = "Самородное серебро",
    cinnabar        = "Киноварь",
    saltpeter       = "Селитра",
    sulfur          = "Сера",
    ---------------------------------------
    lazurite        = "Лазурит",
    malachite       = "Малахит",
    marble          = "Мрамор",
    limestone       = "Известняк",
}

for mineral, mineral_desc in pairs(minerals.list) do
	minetest.register_craftitem("minerals:"..mineral, {
		description = mineral_desk,
		inventory_image = "minerals_"..mineral..".png",
	})
end

minetest.override_item("minerals:marble", { groups = {flux = 1} })
minetest.override_item("minerals:limestone", { groups = {flux = 1} })

--{{{ Fuel registration
minetest.register_craft({
	type = "fuel",
	recipe = "minerals:charcoal",
	burntime = 20,
})

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:bituminous_coal",
	burntime = 35,
})

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:anthracite",
	burntime = 50,
})
--}}}
