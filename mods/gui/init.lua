gui = {}
gui.bg = "bgcolor[#080808BB;true]"
gui.bg_img = "background[5,5;1,1;gui_formbg.png;true]"
gui.slots = "listcolors[#00000069;#5A5A5A;#141318;#30434C;#FFF]"
function gui.get_hotbar_bg(x,y)
	local out = ""
	for i=0,7,1 do
		out = out .."image["..x+i..","..y..";1,1;gui_hb_bg.png]"
	end
	return out
end
