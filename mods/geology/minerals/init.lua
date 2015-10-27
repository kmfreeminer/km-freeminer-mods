MINERALS_LIST={
	'lazurite',
	'anthracite',
	'lignite',
	'bituminous_coal',
	'magnetite',
	'hematite',
	'limonite',
	'bismuthinite',
	'cassiterite',
	'galena',
	'garnierite',
	'malachite',
	'native_copper',
	'native_gold',
	'native_platinum',
	'native_silver',
	'sphalerite',
	'tetrahedrite',
	'bauxite',
	---------------------------
	'cinnabar',
	'cryolite',
	'graphite',
	'gypsum',
	'jet',
	'kaolinite',
	'kimberlite',
	'olivine',
	'petrified_wood',
	'pitchblende',
	'saltpeter',
	'satin_spar',
	'serpentine',
	'sulfur',
	'sylvite',
	'tenorite',
	'charcoal'
}

MINERALS_DESC_LIST={
	'Лазурит',
	'Антрацит',
	'Бурый уголь', -- Lignite
	'Каменный уголь', -- Bituminous coal
	'Магнетит',
	'Гематит',
	'Лимонит',
	'Висмутин',
	'Касситерит',
	'Галенит',
	'Гарниерит',
	'Малахит',
	'Самородная медь',
	'Самородное золото',
	'Самородная платина',
	'Самородное серебро',
	'Сфалерит',
	'Тетраэдрит',
	'Боксит',
	---------------------------
	'Киноварь',
	'Криолит',
	'Графит',
	'Гипс',
	'Гагат', -- Jet
	'Каолинит',
	'Кимберлит',
	'Оливин',
	'Окаменелое дерево',
	'Настуран',
	'Селитра',
	'Селенит', -- Satin spar
	'Змеевик',
	'Сера',
	'Сильвин',
	'Тенорит',
	'Древесный уголь'
}

for i=1, #MINERALS_LIST do
	minetest.register_craftitem("minerals:"..MINERALS_LIST[i], {
		description = MINERALS_DESC_LIST[i],
		inventory_image = "minerals_"..MINERALS_LIST[i]..".png",
	})
end

minetest.register_craftitem("minerals:flux", {
	description = "Flux",
	inventory_image = "minerals_flux.png",
})

minetest.register_craftitem("minerals:borax", {
	description = "Borax",
	inventory_image = "minerals_borax.png",
})

-------------------------------------------------

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:charcoal",
	burntime = 20,
})

minetest.register_craft({
	type = "fuel",
	recipe = "minerals:lignite",
	burntime = 25,
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
