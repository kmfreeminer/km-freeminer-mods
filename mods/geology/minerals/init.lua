minerals = {}

minerals.list = {
    anthracite      = "Антрацит",
    bituminous_coal = "Каменный уголь",
    charcoal        = "Древесный уголь",
    ---------------------------------------
    cassiterite     = "Касситерит",
    cinnabar        = "Киноварь",
    galena          = "Галенит",
    iron_ore        = "Железная руда",
    native_copper   = "Самородная медь",
    native_gold     = "Самородное золото",
    native_silver   = "Самородное серебро",
    saltpeter       = "Селитра",
    sulfur          = "Сера",
    ---------------------------------------
    lazurite        = "Лазурит",
    malachite       = "Малахит",
}

for mineral, mineral_desc in pairs(minerals.list) do
    minetest.register_craftitem("minerals:"..mineral, {
        description = mineral_desc,
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
    recipe = "minerals:bituminous_coal",
    burntime = 35,
})

minetest.register_craft({
    type = "fuel",
    recipe = "minerals:anthracite",
    burntime = 50,
})
--}}}
