clothing = {}

--{{{ Functions
clothing.get = function (itemstack)
    if itemstack:is_empty() then
        return nil
    end

    local meta = minetest.deserialize(itemstack:get_metadata())
    local default = itemstack:get_definition().clothes

    -- If there is serialized metadata, then we check,
    -- have it clothes path or not.
    -- If not¸ then we try to use default texture.
    -- If there is no serialized metadata, then we still try to use default
    -- texture.

    if meta then
        if meta.clothes == nil then
            if default ~= nil then
                return default
            else
                minetest.log("error",
                    "Item (" .. itemstack:to_string() .. ") "..
                    "doesn't have a clothes texture"
                )
                return nil
            end
        else
            return download(meta.clothes)
        end
    else
        if default ~= nil then
            return default
        else
            minetest.log("error",
                "Item (" .. itemstack:to_string() .. ") " ..
                "doesn't have a serialized metadata"
            )
            return nil
        end
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
            local texture = clothing.get(itemstack)
            if texture then
                skin = skin .. "^" .. texture
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

--{{{ Clothes registration
clothing.list = {
    hat = "Шляпа",
    shirt = "Рубашка",
    pants = "Штаны",
    shoes = "Обувь",
    сoat = "Пальто",
    cape = "Плащ",
    dress = "Платье",
    scarf = "Шарф",
    gloves = "Перчатки",

    -- If player can't define his clothes as anything from above
    dummy = "Одежда",
}

for name, desc in pairs(clothing.list) do
    minetest.register_craftitem("clothing:" .. name, {
        description = desc,
        groups = {clothes = 1},
        inventory_image = "clothing_" ..name.. "_inv.png",
        wield_image = "clothing_" ..name.. "_inv.png",
        stack_max = 1,

        -- Default value
        clothes = "clothing_" ..name.. ".png"
    })
end
--}}}

--{{{ Clothes crafting
--TODO
--}}}
