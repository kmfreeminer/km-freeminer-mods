inventory = {}

inventory.width = 10
inventory.height = 1
inventory.clothes_width = 2
inventory.clothes_height = 4

minetest.register_on_newplayer(function(player)
    local invref = player:get_inventory()

    -- Main list
    invref:set_size("main", inventory.width * inventory.height)

    -- Clothes list
    invref:set_list("clothes", {})
    invref:set_size("clothes", inventory.clothes_width * inventory.clothes_height)

    -- Left and right hand (is this needed?)
    --invref:set_list("left_hand", {})
    --invref:set_size("left_hand", 1)
    --invref:set_list("right_hand", {})
    --invref:set_size("right_hand", 1)
end)

minetest.register_on_joinplayer(function(player)
    -- For already existing players
    --if not player:get_inventory():get_list("head") then
        local invref = player:get_inventory()
        invref:set_size("main", inventory.width * inventory.height)
        invref:set_list("clothes", {})
        invref:set_size("clothes", inventory.clothes_width * inventory.clothes_height)
    --end

    --if not minetest.check_player_privs(player:get_player_name(), {creative = true}) then
        player:set_inventory_formspec(inventory.default)
    --end

    player:hud_set_hotbar_image("gui_hotbar.png")
    player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
    player:hud_set_hotbar_itemcount(inventory.width)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
    if (formname == "" or formname:sub(0,9) == "inventory") then
        if fields.craft_inv then
            minetest.show_formspec(
                player:get_player_name(),
                "",
                inventory.craft
            )
        elseif fields.clothes_inv then
            minetest.show_formspec(
                player:get_player_name(),
                "inventory:clothes",
                inventory.clothes
            )
        --elseif fields.notes_inv then
        --    minetest.show_formspec(
        --        player:get_player_name(),
        --        "inventory:notes",
        --        inventory.notes
        --    )
        end
    end
end)

function inventory.main (x, y)
    return "list[current_player;main;"
            .. x .. "," .. y .. ";"
            .. inventory.width .. "," .. inventory.height .. ";]"
end

function inventory.craft (x, y)
    return "list[current_player;craft;"
            .. x .. "," .. y
            ..";3,3;]"
        .. "image["
            .. (x + 1) .. "," .. (y + 3) .. ";"
            .. "1,1;gui_furnace_arrow_bg.png^[transformR270]"
        .. "list[current_player;craftpreview;"
            .. (x + 2) .. "," .. (y + 3) .. ";"
            .. "1,1;]"
end

function inventory.character (x, y)
    return "image_button["
            .. x .. "," .. y .. ";"
            .. "2,4;"
            .. "character_puppet.png;"
            .. "big_button;;false;false;]"
        .. "list[current_player;clothes;"
            .. (x + 2.25) .. "," .. y .. ";2,4;]"
end

inventory.default =
    "size[" ..inventory.width.. "," ..(inventory.height + 4).. "]"
    .. default.gui_bg
    .. default.gui_bg_img
    .. default.gui_slots
    .. inventory.character(1.20, 0)
    .. inventory.craft(5.80, 0)
    .. inventory.main(0, 4.25)

--{{{ Attachments
-- Bones list:
-- |- Body
-- |   |- Head
-- |   |- Arm_Left
-- |   \- Arm_Right
-- |- Leg_Right
-- \- Leg_Left
--}}}
