clothing = {}

--{{{ Functions
clothing.get = function (itemstack)
    if itemstack:is_empty() then
        return nil
    end
    local meta = minetest.deserialize(itemstack:get_metadata())
    if meta then
        if meta.clothes == nil then
            minetest.log("error",
                "Item (" .. itemstack:to_string() .. ") "..
                "doesn't have a clothes texture"
            )
            return nil
        else
            return meta.clothes
        end
    else
        minetest.log("error",
            "Item (" .. itemstack:to_string() .. ") " ..
            "doesn't have a serialized metadata"
        )
        return nil
    end
end

local function download(texture)
    return "httpload:" .. texture
end

clothing.update_skin = function (player)
    -- Get base player skin
    local name = player:get_player_name()
    local skin = download(name .. ".png")

    -- Add clothes
    local clothes = player:get_inventory():get_list("clothes")
    if clothes == nil then
        minetest.log("error",
            name ..  " doesn't have an inventory list " .. '"clothes"'
        )
        minetest.log("warning",
            "no clothes were applyed to the skin of player " ..  name
        )
    else
        for _,itemstack in ipairs(clothes) do
            local texture = clothing_get(itemstack)
            if texture then
                skin = skin .. "^" .. download(path)
            end
        end
    end

    -- Update skin only if it really changes
    if player:get_properties().textures[1] ~= skin then
        default.player_set_textures(player, {skin})
        minetest.log("action",
             name .. " updated his skin"
        )
    end
end
--}}}

--{{{ minetest.register...
minetest.register_chatcommand("clothes", {
    params = "<action> <texture> [force]",
    description =
        "Adds texture path into metadata, for clothes.\n" ..
        '    <action> — "set" or "remove",\n' ..
        '    <texture> - texture name without extension, for "set",\n' ..
        '    [force] - optional, will set metadata even if there are errors.',
    privs = {}, --TODO
    func = function(playername, param)
        local params = {}
        for p in string.gmatch(param, "%g+") do table.insert(params, p) end
        local action, texture, force = params[1], params[2], params[3]

        local player = minetest.get_player_by_name(playername)
        local item = player:get_wielded_item()
        local prev = item:to_string()
        local metadata = item:get_metadata()
        local metatable = minetest.deserialize(metadata)

        if metatable == nil then
            if metadata == "" then
                metatable = {}
            else
                if action == "set" and force == "force" then
                    metatable = {}
                else
                    minetest.chat_send_player(playername,
                        "This item has unempty not serialized metadata"
                    )
                    return false
                end
            end
        end
        
        if action == "set" then
            metatable.clothes = texture .. ".png"
            metadata = minetest.serialize(metatable)
            item:set_metadata(metadata)
            minetest.log("action",
                playername ..
                " added a clothes texture to the metadata of item " ..
                "(" ..prev.. ").\n" ..
                "Now the item is: (" ..  item:to_string() .. ")"
            )
            minetest.chat_send_player(playername, "Texture added")
            return true
        elseif action == "remove" then
            metatable.clothes = nil
            metadata = minetest.serialize(metatable)
            item:set_metadata(metadata)
            minetest.log("action",
                playername ..
                " removed a clothes texture from the metadata of item " ..
                "(" ..prev.. ").\n" ..
                "Now the item is: (" ..  item:to_string() .. ")"
            )
            minetest.chat_send_player(playername, "Texture removed")
            return true
        else
            minetest.chat_send_player(playername, "Unrecognized action")
            return false
        end
    end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if (formname == "" or formname:sub(0,9) == "inventory") then
        clothing.update_skin(player)
    end
end)

minetest.register_on_joinplayer(function(player)
    clothing.update_skin(player)
end)
--}}}

--{{{ Cloth

-- Names of items (and textures) for autoregistration
clothing.registered = {
    "black_coat",
    "black_glasses",
    "blue_longskirt",
    "blue_waistcoat",
    "brown_hat",
    "brown_hat_wth_badge",
    "hazel_scarf",
    "jabot",
    "leather_boots",
    "leather_dirty_coat",
    "leather_high_boot",
    "leather_long_gloves",
    "linen_shirt",
    "salmon_long_dress",
    "white_apron",
    "white_blouse",
    "white_bonnet",
    "white_greek_dress",
}

for _,name in pairs(clothing.registered) do
    minetest.register_craftitem("clothing:" .. name, {
        description = name:gsub("_", " "):gsub("^.", string.upper),
        inventory_image = "clothing_" ..name.. "_inv.png",
        wield_image = "clothing_" ..name.. "_inv.png",
        wear_image = "clothing_" ..name.. ".png",
        stack_max = 1,
    })
end

-- Special case
minetest.register_craftitem("clothing:test1", {
    description = "Test cloth 1",
    inventory_image = "None.png",
    wield_image = "None.png",
    wear_image = "None.png",
    stack_max = 1,
})
minetest.register_craftitem("clothing:test2", {
    description = "Test cloth 2",
    inventory_image = "clothing_test2.png",
    wield_image = "clothing_test2.png",
    wear_image = "clothing_test2.png",
    stack_max = 1,
})
minetest.register_craftitem("clothing:test3", {
    description = "Test cloth 3",
    inventory_image = "clothing_test3.png",
    wield_image = "clothing_test3.png",
    wear_image = "clothing_test3.png",
    stack_max = 1,
})
--}}}
