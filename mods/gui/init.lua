gui = {}
gui.bg = "bgcolor[#080808BB;true]"
gui.bg_img = "background[0,0;1,1;gui_formbg.png;true]"
gui.slots = "listcolors[#00000069;#5A5A5A;#141318;#F8F2E7;#000]"

function gui.get_bg_img(w, h)
    return "background[0,0;" .. w .. "," .. h .. ";gui_formbg.png]"
end

function gui.get_hotbar_bg(x, y, w)
    local out = ""
    for i = 0, (w - 1) do
        out = out .."image[" .. (x + i) .. "," .. y .. ";1,1;gui_hb_bg.png]"
    end
    return out
end

minetest.register_on_joinplayer(function(player)
    local hud_flags = player:hud_get_flags()
    hud_flags.minimap = false
    hud_flags.healthbar = false
    player:hud_set_flags(hud_flags)
end)
