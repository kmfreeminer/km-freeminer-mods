inventory = {}

--{{{ Constants
inventory.width = 10
inventory.height = 1
inventory.part = { width = 2, height = 4 }
inventory.creative = { width = 5 }

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

function inventory.creative(x, y, w, h, start)
    local start = start or 0
    local page = h * (w - 1)
    local pagemax = math.ceil(creative.creative_inventory_size / page)

    -- Cycling
    if start < 0 then
        start = page * (pagemax - 1)
    elseif start >= creative.creative_inventory_size then
        start = 0
    end

    local pagenum = nil
    if start > 0 then
        for i = 1, pagemax do
            local start_i = page * (i - 1)
            if start >= start_i and start < page * i then
                start = start_i
                pagenum = i
                break
            end
        end
    else
        pagenum = 1
    end

    return "list[detached:creative;main;"
            .. x .. "," .. y .. ";"
            .. (w - 1) .. "," .. h .. ";"
            .. tostring(start)
            .. "]"
        .. "label["
            .. (x + w - 0.75) .. "," .. y .. ";"
            .. tostring(pagenum) .. "/" .. tostring(pagemax)
            .. "]"
        .. "button["
            .. (x + w - 1) .. "," .. (y + 0.4) .. ";"
            .. "1,1;creative_prev;<<"
            .. "]"
        .. "button["
            .. (x + w - 1) .. "," .. (y + 1.1) .. ";"
            .. "1,1;creative_next;>>"
            .. "]"
        .. "label["
            .. (x + w - 1) .. "," .. (y + h - 1.5) .. ";"
            .. "Trash:"
            .. "]"
        .. "list[detached:creative_trash;main;"
            .. (x + w - 1) .. "," .. (y + h - 1) .. ";"
            .. "1,1;"
            .. "]"
        .. "listring[current_player;main]"
        .. "listring[current_player;craft]"
        .. "listring[current_player;main]"
        .. "listring[detached:creative;main]"
end

function inventory.default(part, creative, start)
    local creative = creative or false
    local width = inventory.width
    local height = inventory.height + inventory.part.height

    local creative_fc = ''
    if creative then
        local creative_width = 6
        creative_fc = inventory.creative(width, 0, creative_width, height, start)
        width = width + creative_width
    end

    return "size["
        .. width .. "," .. height
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
    .. "button["
        .. (inventory.width - 1) .. ",0;"
        .. "1,1;creative_toggle;CR"
        .. "]"
    .. creative_fc
end
--}}}

--{{{ Functions
local function create_inventory(invref)
    -- Main list
    invref:set_size("main", inventory.width * inventory.height)

    -- Bodypart list
    for part, _ in pairs(inventory.parts) do
        invref:set_list(part, {})
        invref:set_size(part, inventory.part.width * inventory.part.height)
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
            inventory.part.width * inventory.part.height then
            return false
        end
    end
    return true
end

local function turn_creative_page(formspec, backward)
    local backward = backward or false
    local w, h, start = string.match(formspec,
        "list%[detached:creative;main;[%d.]+,[%d.]+;([%d.]+),([%d.]+);(%d+)%]"
    )
    local page = w * h
    if backward
        then return start - page
        else return start + page
    end
end
--}}}

--{{{ minetest.register
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
        local formspec = player:get_inventory_formspec()
        local name = player:get_player_name()

        if fields.tabs == 1 then
            player:set_inventory_formspec(inventory.default())
        elseif fields.tabs == 2 then
            --player:set_inventory_formspec(inventory.stats())
        elseif fields.tabs == 3 then
            --player:set_inventory_formspec(inventory.quenta())

        elseif fields.creative_toggle then
            if string.find(formspec, "list%[detached:creative") then
                player:set_inventory_formspec(inventory.default(part))
            else
                if minetest.check_player_privs(name, {creative = true}) then
                    player:set_inventory_formspec(inventory.default(part,true))
                end
            end
        elseif fields.creative_next then
            local start = turn_creative_page(formspec)
            player:set_inventory_formspec(inventory.default(part, true, start))
        elseif fields.creative_prev then
            local start = turn_creative_page(formspec, true)
            player:set_inventory_formspec(inventory.default(part, true, start))
        else
            for part, _ in pairs(inventory.parts) do
                if fields["btn_" .. part] then
                    player:set_inventory_formspec(inventory.default(part))
                end
            end
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
