package.path = package.path .. ";" .. minetest.get_modpath("fudge") .. "/luafudge/?.lua"

if require("fudge") then
    fudge.set_lang("russian")
end
