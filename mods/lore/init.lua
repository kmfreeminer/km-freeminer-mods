lore = {
    max_length = 50,
    delta = 10,
}

minetest.register_privilege("lore", "Изменение описаний предметов")

--{{{ Functions
function lore.set (itemstack, text, playername)
    if itemstack then
        -- Split lines
        -- 1. граница - 50 символов
        -- 2. Ищем в пределах delta = 5 символом точку или запятую, бьём по ней
        -- 3. если нет — ищем ближайший пробел и бьём по нему.
        local lines = {}
        text = text:gsub("\n", " ")

        -- Split text into lines
        while text:len() > lore.max_length do
            local split_pos =
                text:find_nearest("%.", lore.max_length, lore.delta)
                or text:find_nearest(",", lore.max_length, lore.delta)
                or text:find_nearest(" ", lore.max_length)
            table.insert(lines, text:sub(1, split_pos))
            text = text:sub(split_pos + 1)
        end
        table.insert(lines, text)
        text = ""

        -- Stick them together
        for i, line in ipairs(lines) do
            if i == 1 then
                text = line
            else
                -- Remove space at the start of the line
                if line:sub(1,1) == " " then
                    line = line:sub(2)
                end
                text = text .. "\n" .. line
            end
        end

        -- Write lore
        itemstack:set_inventory_label(text)
        minetest.log("action",
            "Player " .. playername
            .. " changed item description of " .. itemstack:get_name() .. ".\n"
            .. "New item description: " .. itemstack:get_inventory_label()
        )
        return itemstack, true
    end
    return itemstack, false
end

function lore.get (itemstack)
    if itemstack then
        return itemstack:get_inventory_label()
    else
        return ""
    end
end
--}}}

--{{{ minetest.register
--minetest.register_chatcommand("lore", {
--    params = "<action> [description]",
--    description = "Изменяет описание предмета"
--    .. "\n    "
--    .. "<action> - добавить (add), записать целиком (set) или удалить (delete) описание"
--    .. "\n    "
--    .. "[description] - текст описания (для add и set), указывать без кавычек",
--    privs = { lore = true },
--    func = function (playername, param)
--        local player = minetest.get_player_by_name(playername)
--        local item = player:get_wielded_item()
--        local current_label = item:get_inventory_label() or ""
--
--        if param == "delete" then
--            item = lore.set(item, "", playername)
--            player:set_wielded_item(item)
--            return true, "Описание удалено."
--        elseif param == "" or param == nil then
--            return false
--        else
--            local action, description = string.match("(%a-) (.*)", param)
--            if action == "add" then
--                item = lore.set(item, current_label .. description, playername)
--                player:set_wielded_item(item)
--                return true, "Описание обновлено."
--            elseif action == "set" then
--                item = lore.set(item, description, playername)
--                player:set_wielded_item(item)
--                return true, "Описание обновлено."
--            end
--        end
--    end,
--})
--}}}
