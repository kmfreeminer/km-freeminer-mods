-- kmchat - a simple local chat mod for minetest
-- Copyright (C) 2014 hunterdelyx1, vegasd, sullome (Konungstvo Midgard)
--
-- This file is part of KMRP minetest-mods
--
-- KMRP minetest-mods is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- KMRP minetest-mods is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with KMRP minetest-mods.  If not, see <http://www.gnu.org/licenses/>.
--
-------------------------------------------------------------------------------
--
-- Features:
--  * Local chat
--  * Comfortable whisper and shout w/o commands
--  * Colorful chat
--  * Local and global OOC-chat
--  * GM-prefixes
--  * Dices

kmchat = {}

minetest.register_privilege("gm", {
	description = "Позволяет читать все сообщения в чате",
	give_to_singleplayer= false,
})

kmchat.patterns = {}

dofile(minetest.get_modpath("kmchat").."/config.lua")
dofile(minetest.get_modpath("kmchat").."/core.lua")
dofile(minetest.get_modpath("kmchat").."/api.lua")

-- Load modules
dofile(minetest.get_modpath("kmchat").."/modules/default.lua")
dofile(minetest.get_modpath("kmchat").."/modules/rp_chat.lua")
dofile(minetest.get_modpath("kmchat").."/modules/dices.lua")
