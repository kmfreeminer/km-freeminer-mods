inventory = {}

inventory.width = 9
inventory.height = 1
inventory.clothes_height = 3

minetest.register_on_newplayer(function(player)
    local invref = player:get_inventory()

    -- Main list
    invref:set_size("main", inventory.width * inventory.height)

    -- Clothes list
    invref:set_list("clothes", {})
    invref:set_size("clothes", inventory.width * inventory.clothes_height)

    -- Left and right hand (is this needed?)
    --invref:set_list("left_hand", {})
    --invref:set_size("left_hand", 1)
    --invref:set_list("right_hand", {})
    --invref:set_size("right_hand", 1)
end)

minetest.register_on_joinplayer(function(player)
    -- For already existing players
    if not player:get_inventory():get_list("clothes") then
        local invref = player:get_inventory()
        invref:set_list("clothes", {})
        invref:set_size("clothes", inventory.width * inventory.clothes_height)
    end

	if not minetest.check_player_privs(player:get_player_name(), {creative = true}) then
		player:set_inventory_formspec(inventory.craft)
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

inventory.base = 
    "size[" ..inventory.width.. "," ..(inventory.height + 4).. "]"..
    default.gui_bg..
    default.gui_bg_img..
    default.gui_slots..
    "button[0.25,4.9;4.25,0.1;craft_inv;Craft]"..
    "button[4.5,4.9;4.25,0.1;clothes_inv;Clothes]"--..
    --"button[6.25,4.9;2.5,0.1;notes_inv;Notes]"

inventory.main = function(x,y)
    return "list[current_player;main;"..
        x.. "," ..y.. ";"..
        inventory.width.. "," ..inventory.height.. ";]"
end

inventory.craft =
    inventory.base..
    "list[current_player;craft;2,0;3,3;]"..
    "image[5,1;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
    "list[current_player;craftpreview;6,1;1,1;]"..
    inventory.main(0,3.5)

    -- Left and right hand
    --"list[current_player;left_hand;0.25,1;1,1;]"..
    --"list[current_player;right_hand;7.75,1;1,1;]"..
    

inventory.clothes = 
    inventory.base..
    "list[current_player;clothes;0,0;"..
        inventory.width .. "," .. inventory.clothes_height .. ";]"..
    inventory.main(0,3.5)

inventory.notes = 
    inventory.base..
    "textarea[0.3,0;" .. inventory.width .. ",4.5;inv_notes;Quick notes;]"
