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
    local drawborder = "false"

    local image_width = 2.25
    local image_height = 4.5
    local image_ratio = 2/150 -- or 4/300. Cells/Pixels

    local parts = {
        head = {
            y = 0, x = 50,
            y2 = 43, x2 = 85,
            tooltip = "Голова"
        },
        body = {
            y = nil, x = 38,
            y2 = 131, x2  = 95,
            tooltip = "Тело"
        },
        lhand = {
            y = 48, x = 14,
            y2 = 189, x2 = 34,
            tooltip = "Левая рука"
        },
        rhand = {
            y = 53, x = nil,
            y2 = 179, x2 = 126,
            tooltip = "Правая рука"
        },
        legs = {
            y2 = 245, x2 = 95,
            tooltip = "Ноги"
        },
        feet = {
            y = nil, x = 26,
            y2 = 300, x2 = 105,
            tooltip = "Ступни"
        },
        --local back = {
        --    y = , x = ,
        --    height = , width =
        --}
    }
    parts.body.y = parts.head.y2
    parts.rhand.x = parts.body.x2
    parts.legs.y = parts.body.y2
    parts.legs.x = parts.lhand.x2
    parts.feet.y = parts.legs.y2

    local buttons = ""
    local button_margin_y = 0.019
    local button_margin_x = 0.09
    local button_fix = 0.16
    for part, coords in pairs(parts) do
        local bx = coords.x * image_ratio - button_margin_x
        local by = coords.y * image_ratio - button_margin_y
        local width = coords.x2 * image_ratio - bx + button_fix
        local height = coords.y2 * image_ratio - by + button_fix

        buttons = buttons
            .. "image_button["
                .. (x + bx) .. "," .. (y + by) .. ";"
                .. width .. "," .. height .. ";"
                .. ";btn_" .. part .. ";;false;" .. drawborder .. ";"
                .. "]"
            .. "tooltip["
                .. "btn_" .. part .. ";" .. coords.tooltip
                .. "]"
    end

    return "image["
            .. x .. "," .. y .. ";"
            .. image_width .. "," .. image_height .. ";"
            .. "character_puppet.png"
            .. "]"
        .. buttons
        .. "list[current_player;clothes;"
            .. (x + image_width) .. "," .. y .. ";"
            .. "2,4;"
            .. "]"
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
