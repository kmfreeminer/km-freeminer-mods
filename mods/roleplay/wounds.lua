roleplay.wounds = {}

roleplay.wounds.types = {
    ["scar"]    = { 
        ["penalty"] = 0
    },
    ["scratch"] = { 
        ["penalty"] = -1
    }
}

roleplay.wounds.data = {
    ["xunto"] = {
        {
            ["type"] = "scratch",
            ["description"] = "Рана на тыльной стороне запястья"
        }
    }
}

minetest.register_on_joinplayer(function(player)
    local player_name = player:get_player_name()
    
    if not roleplay.wounds.data[player_name] then
        roleplay.wounds.data[player_name] = {}
    end
end)

function roleplay.wounds.save()
    roleplay.save("wounds", roleplay.wounds.data)
end

function roleplay.wounds.load()
    local data = roleplay.load("wounds")
    if data then
        roleplay.wounds.data = data
    end
end

-- Save data on shutdown
minetest.register_on_shutdown(function()
    roleplay.wounds.save()
end)

roleplay.wounds.load()

