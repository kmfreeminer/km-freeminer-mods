inventory = {}

--{{{ Constants
inventory.width = 10
inventory.height = 1
inventory.part_width = 2
inventory.part_height = 4
inventory.creative_width = 5

inventory.parts = {
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
        y = 53, x = nil,
        y2 = 179, x2 = 126,
        tooltip = "Левая рука"
    },
    rhand = {
        y = 48, x = 14,
        y2 = 189, x2 = 34,
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
}
inventory.parts.body.y = inventory.parts.head.y2
inventory.parts.lhand.x = inventory.parts.body.x2
inventory.parts.legs.y = inventory.parts.body.y2
inventory.parts.legs.x = inventory.parts.rhand.x2
inventory.parts.feet.y = inventory.parts.legs.y2
--}}}

--{{{ Inventory formspec definitions
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

function inventory.character (x, y, part)
    local drawborder = "false"

    local image_width = 2.25
    local image_height = 4.5
    local image_ratio = 2/150 -- or 4/300. Cells/Pixels

    local buttons = ""
    local button_margin_y = 0.019
    local button_margin_x = 0.09
    local button_fix = 0.16
    for part, coords in pairs(inventory.parts) do
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

    local part = part or "body"
    local selected = "image["
            .. x .. "," .. y .. ";"
            .. image_width .. "," .. image_height .. ";"
            .. "character_" .. part .. "_selected.png"
            .. "]"
        .. "label["
            .. (x + image_width) .. "," .. (y - 0.35) .. ";"
            .. inventory.parts[part].tooltip
            .. "]"
        .. "list[current_player;" .. part .. ";"
            .. (x + image_width) .. "," .. y .. ";"
            .. "2,4;"
            .. "]"

    return "image["
            .. x .. "," .. y .. ";"
            .. image_width .. "," .. image_height .. ";"
            .. "character_puppet.png"
            .. "]"
        .. selected
        .. buttons
end

function inventory.default(part)
    return "size["
        .. inventory.width .. "," .. (inventory.height + inventory.part_height)
        .. "]"
    .. default.gui_bg
    .. default.gui_bg_img
    .. default.gui_slots
    .. "tabheader["
        .. "0,0;"
        .. "tabs;"
        .. "Инвентарь,Характеристики,Квента;"
        .. "1;false;true"
        .. "]"
    .. inventory.character(1.20, 0, part)
    .. inventory.craft(5.80, 0)
    .. inventory.main(0, 4.25)
end

function inventory.creative(start_i, pagenum, part)
    pagenum = math.floor(pagenum)
    local height = inventory.height + inventory.part_height
    local width = inventory.creative_width
    local pagemax = math.floor(
        (creative.creative_inventory_size - 1) / (height * width) + 1
    )

    local default = inventory.default(part)
    default = default:gsub("size%[.-%]", "")

    return "size["
            .. (inventory.width + width + 1) .. "," .. height
            .. "]"
        .. default
        .. "list[detached:creative;main;"
            .. "0,0;5,".. height .. ";"
            .. tostring(start_i)
            .. "]"
        .. "label["
            .. "2," .. (height - 0.45) .. ";"
            .. tostring(pagenum) .. "/" .. tostring(pagemax) .. "]"
        .. "button["
            .. "0.3," .. (height - 0.5) .. ";"
            .. "1.6,1;creative_prev;<<"
            .. "]"
        .. "button["
            .. "2.7," .. (height - 0.5) .. ";"
            .. "1.6,1;creative_next;>>"
            .. "]"
        .. "listring[current_player;main]"
        .. "listring[current_player;craft]"
        .. "listring[current_player;main]"
        .. "listring[detached:creative;main]"
        .. "label[" .. width .. ",1.5;Trash:]"
        .. "list[detached:creative_trash;main;" .. width .. ",2;1,1;]"
end
--}}}

--{{{ minetest.register
local function create_inventory(invref)
    -- Main list
    invref:set_size("main", inventory.width * inventory.height)

    -- Bodypart list
    for part, _ in pairs(inventory.parts) do
        invref:set_list(part, {})
        invref:set_size(part, inventory.part_width * inventory.part_height)
    end
end

local function correct_inventory(invref)
    if invref:get_size("main") ~= inventory.width * inventory.height then
        return false
    end
    for part, _ in pairs(inventory.parts) do
        if invref:get_list(part) == nil then
            return false
        elseif invref:get_size(part) ~=
            inventory.part_width * inventory.part_height then
            return false
        end
    end
    return true
end

minetest.register_on_newplayer(function(player)
    local invref = player:get_inventory()
    create_inventory(invref)
end)

minetest.register_on_joinplayer(function(player)
    local invref = player:get_inventory()

    -- For already existing players
    if not correct_inventory(invref) then create_inventory(invref) end

    player:set_inventory_formspec(inventory.default())

    player:hud_set_hotbar_image("gui_hotbar.png")
    player:hud_set_hotbar_selected_image("gui_hotbar_selected.png")
    player:hud_set_hotbar_itemcount(inventory.width)
end)

minetest.register_on_player_receive_fields(function(player, formname, fields)
    print(dump(fields))
    if (formname == "" or formname:sub(0,9) == "inventory") then
        if fields.tabs == 1 then
            minetest.show_formspec(
                player:get_player_name(),
                "",
                inventory.default()
            )
        elseif fields.tabs == 2 then
            minetest.show_formspec(
                player:get_player_name(),
                "inventory:stats",
                inventory.stats
            )
        elseif fields.tabs == 3 then
            minetest.show_formspec(
                player:get_player_name(),
                "inventory:quenta",
                inventory.quenta
            )
        end

        for part, _ in pairs(inventory.parts) do
            if fields["btn_" .. part] ~= nil then
                minetest.show_formspec(
                    player:get_player_name(),
                    "",
                    inventory.default(part)
                )
            end
        end

        if minetest.check_player_privs(name, {creative = true}) then
            local formspec = player:get_inventory_formspec()
            local start_i = string.match(formspec, "list%[detached:creative;main;[%d.]+,[%d.]+;[%d.]+,[%d.]+;(%d+)%]")
            start_i = tonumber(start_i) or 0

            local h = inventory.height + inventory.part_height
            local w = inventory.creative_width
            local page = h*w

            if fields.creative_prev then
                start_i = start_i - page
            end
            if fields.creative_next then
                start_i = start_i + page
            end

            if start_i < 0 then
                start_i = start_i + page
            end
            if start_i >= creative.creative_inventory_size then
                start_i = start_i - page
            end

            if start_i < 0 or start_i >= creative.creative_inventory_size then
                start_i = 0
            end

            local pagenum = start_i / page + 1

            minetest.show_formspec(
                player:get_player_name(),
                "",
                inventory.creative(player, start_i, pagenum)
            )
        end
    end
end)
--}}}

--{{{ Attachments
-- Bones list:
-- |- Body
-- |   |- Head
-- |   |- Arm_Left
-- |   \- Arm_Right
-- |- Leg_Right
-- \- Leg_Left
--}}}
