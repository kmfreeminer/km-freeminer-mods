inventory = {}

inventory.width = 10
inventory.height = 3
inventory.clothes_width = 2
inventory.clothes_height = 5

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
        invref:set_list("clothes", {})
        invref:set_size("clothes", inventory.clothes_width * inventory.clothes_height)

        invref:set_list("head", {})
        invref:set_size("head", 1)

        invref:set_list("back", {})
        invref:set_size("back", 3)

        invref:set_list("chest", {})
        invref:set_size("chest", 2)

        invref:set_list("hands", {})
        invref:set_size("hands", 2)

        invref:set_list("belt", {})
        invref:set_size("belt", 3)
    --end

    if not minetest.check_player_privs(player:get_player_name(), {creative = true}) then
        player:set_inventory_formspec(inventory.default)
    end

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
    return "list[current_player;craft;".. x .. "," .. y ..";3,3;]"
        .. "image["
            .. (x + 1) .. "," .. (y + 3) .. ";"
            .. "1,1;gui_furnace_arrow_bg.png^[transformR180]"
        .. "list[current_player;craftpreview;"
            .. (x + 1) .. "," .. (y + 4) .. ";"
            .. "1,1;]"
end

function inventory.character (x, y)
    return "list[current_player;head;"
            .. (x + 1) .. "," .. y .. ";1,1;]"
        .. "list[current_player;back;"
            .. x .. "," .. (y + 1) .. ";3,1;]"
        .. "list[current_player;hands;"
            .. (x - 0.5) .. "," .. (y + 2) .. ";1,1;]"
        .. "list[current_player;hands;"
            .. (x + 2.5) .. "," .. (y + 2) .. ";1,1;1]"
        .. "list[current_player;chest;"
            .. (x + 1) .. "," .. (y + 2) .. ";1,2;]"
        .. "list[current_player;belt;"
            .. x .. "," .. (y + 4) .. ";3,1;]"
end

function inventory.clothes (x, y)
    return "list[current_player;clothes;"
        .. x .. "," .. y .. ";"
        .. inventory.clothes_width .. "," .. inventory.clothes_height .. ";]"
end

inventory.default =
    "size[" ..inventory.width.. "," ..(inventory.height + 6).. "]"
    .. default.gui_bg
    .. default.gui_bg_img
    .. default.gui_slots
    .. inventory.craft(0, 0)
    .. inventory.character(4, 0)
    .. inventory.clothes(8, 0)
    .. inventory.main(0, 6)

--{{{ Attachments
-- Bones list:
-- |- Body
-- |   |- Head
-- |   |- Arm_Left
-- |   \- Arm_Right
-- |- Leg_Right
-- \- Leg_Left
--}}}
