real_locks = {}

real_locks.formspec =
    "size[" ..inventory.width.. "," ..(inventory.height + 1).. "]" ..
    default.gui_bg..
    default.gui_bg_img..
    default.gui_slots..
    "field[0.3,0.3;2,1;keypass;Форма ключа;]" ..
    "list[current_name;src;2.5,0;1,1;]" ..
    "image[3.5,0;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
    "list[current_name;dstl;4.5,0;1,1;]" ..
    "list[current_name;dstk;5.5,0;1,1;]" ..
    "button[7,0;2,1;craft;Создать]" ..
    inventory.main(0, 1.2) ..
    "listring[current_name;dstl]" ..
    "listring[current_player;main]" ..
    "listring[current_name;dstk]" ..
    "listring[current_player;main]" ..
    "listring[current_name;src]" ..
    "listring[current_player;main]"

--{{{ Functions
real_locks.can_open_locked = function (pos, wield)
    if minetest.get_item_group(wield, "key") > 0 then 
		local lock_pass = minetest.get_meta(pos):get_string("keyform")
		local key_pass = minetest.deserialize(wield:get_metadata()).keyform

		return lock_pass == key_pass
    else
        return false
    end
end

local function get_metal(name)
    return name:sub(name:find(":") + 1, name:find("_sheet") - 1)
end

real_locks.craft = function(pos, keyform)
    local meta = minetest.get_meta(pos)
    local inv = meta:get_inventory()
    local src = inv:get_stack("src", 1):get_name()

    if minetest.get_item_group(src, "metal") > 0
    and minetest.get_item_group(src, "sheet") > 0
    then
        local metal = get_metal(src)
        local key = ItemStack({
            name = "real_locks:key_" .. metal,
            count = 1,
            metadata = minetest.serialize({keyform = keyform})
        })
        local lock = ItemStack({
            name = "real_locks:lock_" .. metal,
            count = 1,
            metadata = minetest.serialize({keyform = keyform})
        })

        if inv:room_for_item("dstk", key)
        and inv:room_for_item("dstl", lock)
        then
            inv:add_item("dstk", key)
            inv:add_item("dstl", lock)
            inv:remove_item("src", src)
        end
    end
end
--}}}

--{{{ Craft table
minetest.register_node("real_locks:table", {
    description = "Стол для создания замко́в",
    groups = {},
    tiles = {},
    sounds = default.node_sound_stone_defaults(),

    on_construct = function (pos)
        local meta = minetest.get_meta(pos)

        -- Inizialize inventory
        local inv = meta:get_inventory()
        inv:set_size("src", 1)
        inv:set_size("dstl", 1)
        inv:set_size("dstk", 1)

        meta:set_string("formspec", real_locks.formspec)
    end,

    after_dig_node = function(pos, oldnode, oldmetadata, digger)
        for _, invlist in pairs({"src", "dst"}) do
            local item = oldmetadata.inventory[invlist][1]
            if item:get_name() ~= "" then minetest.add_item(pos, item) end
        end
    end,

	allow_metadata_inventory_put = function(pos,listname, index, stack, player)
        if listname == "src" then
            return stack:get_count()
        elseif listname:sub(1,-2) == "dst" then
            return 0
        end
    end,
	allow_metadata_inventory_move =
        function (pos, from_list, from_index, to_list, to_index, count, player)
            if from_list:sub(1,-2) == "dst" or to_list:sub(1,-2) == "dst" then
                return 0
            else
                return count
            end
        end,

    on_receive_fields = function (pos, formname, fields, sender)
        if fields.craft and fields.keypass ~= "" then
            real_locks.craft(pos, fields.keypass)
        end
    end,
})
--}}}

--{{{Register keys and locks
for metal, props in pairs(metals.registered) do
    minetest.register_craftitem("real_locks:key_" .. metal, {
        description = "Ключ (" .. props.description .. ")",
        groups = {metal = 1, key = 1, level = props.level},
        inventory_image = "real_locks_key_" .. metal .. ".png",
        stack_max = 1,
        range = 2,
    })

    minetest.register_craftitem("real_locks:lock_" .. metal, {
        description = "Замок (" .. props.description .. ")",
        groups = {metal = 1, key = 1, level = props.level},
        inventory_image = "real_locks_lock_" .. metal .. ".png",
        wield_image = "real_locks_lock_" .. metal .. ".png",
        stack_max = 1,
        range = 2,
    })
end

minetest.register_craftitem("real_locks:bolt", {
    description = "Bolt",
    groups = {},
    inventory_image = "real_locks_bolt.png",
    wield_image = "real_locks_bolt.png",
    stack_max = 1,
    range = 2,
})
--}}}
