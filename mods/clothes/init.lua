clothes = {}

clothes.privilege = "clothes"
clothes.chatcommand = "clothes"

clothes.privilege_desc = "Разрешает изменять текстуру одежды у предмета " ..
    "(команда /" .. clothes.chatcommand .. ")"
clothes.command_desc = [[Добавляет текстуру одежды в соответствующее поле метадаты у предмета в руке.
    <action> — "set" или "remove",
    <texture> - название текстуры (без расширения), учитывается только при "set",
    [force] - не обязательный параметр, включает игнорирование ошибок, учитывается только при "set".]]

local function download(texture)
    return "httpload:" .. texture
end

--{{{ Functions
clothes.get = function (itemstack)
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

clothes.update_skin = function (player)
    -- Get base player skin
    local name = player:get_player_name()
    local skin = download(name .. ".png")

    -- Add clothes
    local clothes_list = player:get_inventory():get_list("clothes")
    if clothes_list == nil then
        minetest.log("error",
            name ..  " doesn't have an inventory list " .. '"clothes"'
        )
        minetest.log("warning",
            "no clothes were applyed to the skin of player " ..  name
        )
    else
        for _,itemstack in ipairs(clothes_list) do
            local texture = clothes.get(itemstack)
            if texture then
                skin = skin .. "^" .. texture
            end
        end
    end

    -- Update skin only if it really changes
    if player:get_properties().textures[1] ~= skin then
        default.player_set_textures(player, {skin})
        minetest.log("action",
             name .. " updated his skin. Now his skin is: " ..
             player:get_properties().textures[1]
        )
    end
end
--}}}

--{{{ minetest.register...
minetest.register_privilege(clothes.privilege, clothes.privilege_desc)

minetest.register_chatcommand(clothes.chatcommand, {
    params = "<action> <texture> [force]",
    description = clothes.command_desc,
    privs = {[clothes.privilege] = true},
    func = function(playername, param)
        -- Parse parameters
        local params = {}
        for p in string.gmatch(param, "%g+") do table.insert(params, p) end
        local action, texture, force = params[1], params[2], params[3]

        -- Locals
        local player = minetest.get_player_by_name(playername)
        local item = player:get_wielded_item()
        local prev = item
        local metadata = item:get_metadata()
        local metatable = minetest.deserialize(metadata)

        -- Item metadata check
        if metatable == nil then
            if metadata == "" then
                metatable = {}
            else
                if action == "set" and force == "force" then
                    metatable = {}
                else
                    return false, "This item has unempty not serialized metadata"
                end
            end
        end
        
        -- Applying needed changes
        if action == "set" then
            metatable.clothes = texture .. ".png"
            metadata = minetest.serialize(metatable)
            item:set_metadata(metadata)
            player:set_wielded_item(item)

            local new = player:get_wielded_item()

            minetest.log("action",
                playername ..
                " added a clothes texture to the metadata of item " ..
                "(" .. prev:to_string() .. ").\n" ..
                "Now the item is: " ..
                "(" .. new:to_string() .. ")"
            )
            return true, "Texture added: " ..
                dump(minetest.deserialize(new:get_metadata()))

        elseif action == "remove" then
            metatable.clothes = nil
            metadata = minetest.serialize(metatable)
            item:set_metadata(metadata)
            player:set_wielded_item(item)

            local new = player:get_wielded_item()

            minetest.log("action",
                playername ..
                " removed a clothes texture from the metadata of item " ..
                "(" .. prev:to_string() .. ").\n" ..
                "Now the item is: " ..
                "(" .. new:to_string() .. ")"
            )
            return true, "Texture removed: " ..
                dump(minetest.deserialize(new:get_metadata()))

        elseif action == nil then
            return true, "/clothes <action> <texture> [force]\n" ..
                clothes.command_desc
        else
            return false, "Unrecognized action. Command description:\n" ..
                clothes.command_desc
        end
    end
})

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if (formname == "" or formname:sub(0,9) == "inventory") then
        clothes.update_skin(player)
    end
end)

minetest.register_on_joinplayer(function(player)
    clothes.update_skin(player)
end)
--}}}

--{{{ Clothes registration
clothes.list = {
    hat    = "Шляпа",
    shirt  = "Рубашка",
    pants  = "Штаны",
    shoes  = "Обувь",
    coat   = "Пальто",
    cape   = "Плащ",
    dress  = "Платье",
    scarf  = "Шарф",
    gloves = "Перчатки",

    -- If player can't define his clothes as anything from above
    dummy  = "Одежда",
}

for name, desc in pairs(clothes.list) do
    minetest.register_craftitem("clothes:" .. name, {
        description = desc,
        groups = {clothes = 1},
        inventory_image = "clothes_" ..name.. "_inv.png",
        wield_image = "clothes_" ..name.. "_inv.png",
        stack_max = 1,

        -- Default value
        clothes = "clothes_" ..name.. ".png"
    })
end
--}}}

--{{{ Clothes crafting
--TODO
--}}}
