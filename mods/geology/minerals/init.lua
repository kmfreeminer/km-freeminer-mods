minerals = {}

minerals.list = {
    lazurite          = 'Лазурит',
    anthracite        = 'Антрацит',
    lignite           = 'Бурый уголь',
    bituminous_coal   = 'Каменный уголь',
    magnetite         = 'Магнетит',
    hematite          = 'Гематит',
    limonite          = 'Лимонит',
    bismuthinite      = 'Висмутин',
    cassiterite       = 'Касситерит',
    galena            = 'Галенит',
    garnierite        = 'Гарниерит',
    malachite         = 'Малахит',
    native_copper     = 'Самородная медь',
    native_gold       = 'Самородное золото',
    native_platinum   = 'Самородная платина',
    native_silver     = 'Самородное серебро',
    sphalerite        = 'Сфалерит',
    tetrahedrite      = 'Тетраэдрит',
    bauxite           = 'Боксит',
    cinnabar          = 'Киноварь',
    cryolite          = 'Криолит',
    graphite          = 'Графит',
    gypsum            = 'Гипс',
    jet               = 'Гагат',
    kaolinite         = 'Каолинит',
    kimberlite        = 'Кимберлит',
    olivine           = 'Оливин',
    petrified_wood    = 'Окаменелое дерево',
    pitchblende       = 'Настуран',
    saltpeter         = 'Селитра',
    satin_spar        = 'Селенит',
    serpentine        = 'Змеевик',
    sulfur            = 'Сера',
    sylvite           = 'Сильвин',
    tenorite          = 'Тенорит',
    charcoal          = 'Древесный уголь',
    flux              = 'Флюс', -- может убрать? херь какая-то
    borax             = 'Бура́',
}

for mineral, mineral_desc in pairs(minerals.list) do
	minetest.register_craftitem("minerals:"..mineral, {
		description = mineral_desk,
		inventory_image = "minerals_"..mineral..".png",
	})
end

--{{{ Fuel registration
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
--}}}
