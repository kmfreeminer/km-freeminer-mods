smelter={}

--{{{ smelter.register_craft and smelter.get_result
smelter.registered = {}

smelter.register_craft = function(output, inputdef)
    local modname = minetest.get_current_modname()
    if modname == nil then
        modname = ""
    else
        modname = 'Mod "' .. modname .. '": '
    end

    -- Protection
    if not ItemStack(output):is_known() then
        minetest.log("error",
            modname ..
            "failed to register smelter recipe for item " .. output ..": "..
            output .. " is not a known item."
        )
        return false
    end
    for itemname, count in pairs(inputdef.items) do
        if (not ItemStack(itemname):is_known())
        and itemname:sub(1, itemname:find(":") - 1) ~= "group"
        then
            minetest.log("error",
                modname ..
                "failed to register smelter recipe for item " .. output ..": "..
                itemname .. " is not a known item."
            )
            return false
        elseif count < 1 then
            minetest.log("error",
                modname ..
                "failed to register smelter recipe for item " .. output ..": "..
                itemname .. " count must be greater than 0."
            )
            return false
        end
    end
    if inputdef.fuel ~= nil then
        if not ItemStack(inputdef.fuel):is_known() then
            minetest.log("error",
                modname ..
                "failed to register smelter recipe for item " ..output..": "..
                inputdef.fuel .. " is not a known item."
            )
            return false
        end

        local fuel, afterfuel = minetest.get_craft_result({
            method = "fuel",
            width = 1,
            items = {[1] = ItemStack(inputdef.fuel)}
        })
        if fuel.time == 0 then
            minetest.log("error",
                modname ..
                "failed to register smelter recipe for item " ..output..": "..
                inputdef.fuel .. " is not a valid fuel."
            )
            return false
        end
    end
    if inputdef.time < 0 then
        minetest.log("error",
            modname ..
            "failed to register smelter recipe for item " .. output ..": "..
            "time must be positive (>= 0)."
        )
        return false
    end

    local recipe = {}
    recipe.items = inputdef.items
    recipe.fuel = inputdef.fuel
    recipe.time = inputdef.time
    smelter.registered[output] = recipe
    return true
end

smelter.get_craft_result = function (sourcelist)
    local source = {}
    local empty = true
    for k, itemstack in ipairs(sourcelist) do
        local name = itemstack:get_name()
        if name ~= nil  and name ~= "" then
            if source[name] == nil then
                source[name] = 1
            else
                source[name] = source[name] + 1
            end
            empty = false
        end
    end

    if empty then
        return nil, nil, 0
    end

    for result, recipe in pairs(smelter.registered) do
        local checked = {}
        local groups = {}
        local equal = false
        for itemname, count in pairs(recipe.items) do
            if itemname:sub(1, itemname:find(":") - 1) ~= "group" then
                if source[itemname] == nil or source[itemname] < count then
                    equal = false
                    break
                else
                    checked[itemname] = true
                    equal = true
                end
            else
                table.insert(groups, itemname:sub(itemname:find(":") + 1))
            end
        end

        if #groups > 0 then
            for itemname, count in pairs(source) do
                if not checked[itemname] then
                    for i = 1, #groups do
                        if minetest.get_item_group(itemname,groups[i]) > 0 then
                            checked[itemname] = true
                        end
                    end

                    if not checked[itemname] then
                        equal = false
                        break
                    end
                end
            end
        end

        if equal then
            for itemname, count in pairs(source) do
                if not checked[itemname] then
                    equal = false
                    break
                end
            end

            if equal then
                return result, recipe.fuel, recipe.time
            end
        end
    end
    
    return nil, nil, 0
end

smelter.take_source = function (invref, from_invlist)
    for k, itemstack in ipairs(invref:get_list(from_invlist)) do
        itemstack:take_item()
        invref:set_stack(from_invlist, k, itemstack)
    end
end
--}}}

--{{{ Formspecs
smelter.inactive_formspec =
	"size[" .. inventory.width .. "," .. (inventory.height + 4) .. "]"..
    default.gui_bg..
    default.gui_bg_img..
    default.gui_slots..
	"list[current_name;src;2,0;2,2;]"..
	"image[4.5,0.5;1,1;gui_furnace_arrow_bg.png^[transformR270]"..
	"list[current_name;dst;6,0.5;1,1;]"..
	"image[2.5,2;1,1;default_furnace_fire_bg.png]"..
	"list[current_name;fuel;2.5,3;1,1;]"..
    inventory.main(0,4.2) ..
    "listring[current_name;dst]"..
    "listring[current_player;main]"..
    "listring[current_name;src]"..
    "listring[current_player;main]"
	--default.get_hotbar_bg(0, 4.25)

smelter.active_formspec = function(fuel_percent, item_percent)
    return "size[" .. inventory.width ..",".. (inventory.height + 4) .."]"..
    default.gui_bg..
    default.gui_bg_img..
    default.gui_slots..
	"list[current_name;src;2,0;2,2;]"..
	"image[4.5,0.5;1,1;gui_furnace_arrow_bg.png^"..
        "[lowpart:" .. item_percent .. ":gui_furnace_arrow_fg.png^" ..
        "[transformR270" ..
    "]"..
	"list[current_name;dst;6,0.5;1,1;]"..
	"image[2.5,2;1,1;default_furnace_fire_bg.png^"..
        "[lowpart:" .. fuel_percent .. ":default_furnace_fire_fg.png" ..
    "]"..
	"list[current_name;fuel;2.5,3;1,1;]"..
    inventory.main(0,4.2) ..
    "listring[current_name;dst]"..
    "listring[current_player;main]"..
    "listring[current_name;src]"..
    "listring[current_player;main]"
	--default.get_hotbar_bg(0, 4.25)
end
--}}}

--{{{ Functions that are the same for active and inactive smelter
smelter.allow_metadata_inventory_put =
function (pos, listname, index, stack, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	if listname == "fuel" then
		if minetest.get_craft_result({
            method="fuel",
            width=1,
            items={stack}
        }).time ~= 0 then
			return stack:get_count()
		else
			return 0
		end
	elseif listname == "src" then
		return stack:get_count()
	elseif listname == "dst" then
		return 0
	end
end

smelter.allow_metadata_inventory_move = 
function (pos, from_list, from_index, to_list, to_index, count, player)
	local meta = minetest.get_meta(pos)
	local inv = meta:get_inventory()
	local stack = inv:get_stack(from_list, from_index)
	return smelter.allow_metadata_inventory_put(
        pos, to_list, to_index, stack, player
    )
end
--}}}

--{{{ Nodes
minetest.register_node("smelter:smelter", {
	description = "Плавильня",
	tiles = {
        "smelter_smelter_top.png", "smelter_smelter_base.png",
        "smelter_smelter_side.png", "smelter_smelter_side.png",
        "smelter_smelter_side.png", "smelter_smelter_front.png"
    },
	paramtype2 = "facedir",
	groups = {cracky=2},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),

    on_construct = function (pos)
        local meta = minetest.get_meta(pos)

        -- Inizialize inventory
        local inv = meta:get_inventory()
        for listname, size in pairs({src = 4, fuel = 1, dst = 1}) do
            inv:set_size(listname, size)
        end

        meta:set_string("formspec", smelter.inactive_formspec)
    end,
	--can_dig = function(pos,player) -- REWORK
	allow_metadata_inventory_put = smelter.allow_metadata_inventory_put,
	allow_metadata_inventory_move = smelter.allow_metadata_inventory_move,
})

minetest.register_node("smelter:smelter_active", {
	description = "Плавильня",
	tiles = {
        "smelter_smelter_top.png", "smelter_smelter_base.png",
        "smelter_smelter_side.png", "smelter_smelter_side.png",
        "smelter_smelter_side.png", "smelter_smelter_front_active.png" -- ANIMATION
    },
	paramtype2 = "facedir",
	light_source = 8,
	groups = {cracky=2, not_in_creative_inventory=1},
	legacy_facedir_simple = true,
	is_ground_content = false,
	sounds = default.node_sound_stone_defaults(),
	drop = "smelter:smelter",

	--can_dig = function(pos,player) -- REWORK
	allow_metadata_inventory_put = smelter.allow_metadata_inventory_put,
	allow_metadata_inventory_move = smelter.allow_metadata_inventory_move,
})
--}}}

--{{{ ABM
local function swap_node(pos, name)
	local node = minetest.get_node(pos)
	if node.name == name then
		return
	end
	node.name = name
	minetest.swap_node(pos, node)
end

smelter.step = function (pos, node, meta)
    local fuel_time = meta:get_float("fuel_time") or 0
    local src_time = meta:get_float("src_time") or 0
    local fuel_totaltime = meta:get_float("fuel_totaltime") or 0

    -- Check inventory
    local inv = meta:get_inventory()
    for listname, size in pairs({src = 4, fuel = 1, dst = 1}) do
        if inv:get_size(listname) ~= size then
            inv:set_size(listname, size)
        end
    end
    local srclist = inv:get_list("src")
    local fuellist = inv:get_list("fuel")
    local dstlist = inv:get_list("dst")
    
    -- Smelting
    -- Check if we have meltable content
    local result, fuel, melt_time = smelter.get_craft_result(srclist)

    local meltable = true
    if melt_time == 0 then meltable = false end
    
    -- Check if we have enough fuel to burn
    if fuel_time < fuel_totaltime then
        -- The furnace is currently active and has enough fuel
        fuel_time = fuel_time + 1
        
        -- If there is a meltable item then check if it is ready yet
        if meltable then
            src_time = src_time + 1
            if src_time >= melt_time then
                -- Place result in dst list if possible
                if inv:room_for_item("dst", result) then
                    inv:add_item("dst", result)
                    smelter.take_source(inv, "src")
                    src_time = 0
                end
            end
        end
    else
        -- Furnace ran out of fuel
        if meltable then
            -- We need to get new fuel
            local fuel_in, afterfuel = minetest.get_craft_result({
                method = "fuel",
                width = 1,
                items = fuellist
            })
            
            if fuel_in.time == 0 or
                (fuel ~= nil and fuel_in.item:get_name() ~= fuel) then
                -- No valid fuel in fuel list
                fuel_totaltime = 0
                fuel_time = 0
                src_time = 0
            else
                -- Take fuel from fuel list
                inv:set_stack("fuel", 1, afterfuel.items[1])
                
                fuel_totaltime = fuel_in.time
                fuel_time = 0
                
            end
        else
            -- We don't need to get new fuel since there is no cookable item
            fuel_totaltime = 0
            fuel_time = 0
            src_time = 0
        end
    end
    
    -- Update formspec, infotext and node
    local formspec = smelter.inactive_formspec

    local item_percent = 0
    if meltable then
        item_percent =  math.floor(src_time / melt_time * 100)
    end
    
    if fuel_time <= fuel_totaltime and fuel_totaltime ~= 0 then
        local fuel_percent = math.floor(fuel_time / fuel_totaltime * 100)

        formspec = smelter.active_formspec(fuel_percent, item_percent)
        node.name = "smelter:smelter_active"
    else
        node.name = "smelter:smelter"
    end
    
    --
    -- Set meta values
    --
    meta:set_float("fuel_totaltime", fuel_totaltime)
    meta:set_float("fuel_time", fuel_time)
    meta:set_float("src_time", src_time)
    meta:set_string("formspec", formspec)
end

minetest.register_abm({
	nodenames = {"smelter:smelter","smelter:smelter_active"},
	interval = 1.0,
	chance = 1,
	action = function(pos, node, active_object_count, active_object_count_wider)
		local meta = minetest.get_meta(pos)
		local gametime = minetest.get_gametime()
		if meta:get_string("game_time") == "" then
			meta:set_int("game_time", gametime - 1)
		end

		for i = 1, math.min(1200, gametime - meta:get_int("game_time")) do
			smelter.step(pos, node, meta)
			if node.name == "smelter:smelter" then break end
		end
		swap_node(pos, node.name)
		meta:set_int("game_time", gametime)
	end,
})

minetest.register_craft({
	output = 'smelter:smelter',
	recipe = {
		{'default:brick', 'default:brick', 'default:brick'},
		{'default:brick', ''             , 'default:brick'},
		{'default:cobble', 'default:cobble', 'default:cobble'},
	}
})
--}}}
