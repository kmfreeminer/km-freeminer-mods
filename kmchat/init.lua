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

-- config zone {{{
formats = {
-- ["MATCH"]        = {"FORMAT"                  RANGE  COLOR     PRIV}, --
   ["_(.+)"]        = {"%s (OOC): (( %s ))",     18,    "9966AA", nil },
   ["%(%((.+)%)%)"] = {"%s (OOC): (( %s ))",     18,    "9966AA", nil },
   ["!(.+)"]       = {"%s (shouts): %s",        68,    "FFFFFF", nil },
   ["=(.+)"]        = {"%s (whispers): %s",      3,     "E0EEE0", nil },
   ["*(.+)"]       = {"* %s %s",                18,    "FFFF00", nil },
   ["#(.+)"]       = {"*** %s: %s ***",         18,    "FFFF00", "gm"},
   ["?(.+)"]       = {"%s (OOC): %s ***",       31000, "20EEDD", nil },
}
DEFAULT_FORMAT     = "%s: %s" 
DEFAULT_RANGE      = 18
DEFAULT_COLOR      = "EEF3EE"
DICE_COLOR         = "FFFF00"
GMSPY_COLOR        = "666666"
GM_PREFIX          = "[GM] "

fudge_levels = {"-","terrible--","terrible-","terrible", "poor", "mediocre", "fair", "good", "great", "superb", "legendary", "legendary+", "legendary++","like Allah"}

-- config zone }}}
minetest.register_privilege("gm", "Gives accses to reading all messages in the chat")

minetest.register_on_chat_message(function(name, message)
    fmt = DEFAULT_FORMAT 
    range = DEFAULT_RANGE
    color = DEFAULT_COLOR
    pl = minetest.get_player_by_name(name)
    pls = minetest.get_connected_players()
    -- formats (see config zone)
    for m, f in pairs(formats) do
        submes = string.match(message, m)
        if submes then
            if not f[4] then  -- if PRIV==nil
                fmt = f[1]
                range = f[2]
                color = f[3]
                break
            elseif minetest.check_player_privs(name, {[f[4]]=true}) then
                fmt = f[1]
                range = f[2]
                color = f[3]
                break
            end
        end
    end

    -- dices
    dice = string.match(message, "^d(%d+).*")
    if dice=="4" or dice=="6" or dice=="8" or dice=="10" or dice=="12" or dice=="20" then
        fmt = "*** %s rolls d"..dice.." and the result is %s ***"
        color = DICE_COLOR
        submes = math.random(dice)
    end
    
    --Temporary solution for 4dF
    fudge_dice_tmp = string.match(message, "^4dF (.*)$")
    if fudge_dice_tmp~=nil then
        for key, val in pairs(fudge_levels) do
            fudge_level = string.match(fudge_dice_tmp, "^("..val..".*)")
            fudge_level_key = key
            
            if fudge_level~=nil then
                diff = 0
                signs = ""
                
                for i = 1, 4 do
                    rand = math.random(3)
                    if rand == 1 then
                        diff=diff+1
                        signs = signs.."+"
                    elseif rand == 2 then
                        diff=diff-1
                        signs = signs.."-"
                    else
                        signs = signs.."="
                    end
                end
                
                fmt = "*** %s rolls 4df ("..signs..") from "..fudge_level.." and the result is %s ***"
                color = DICE_COLOR
                
                fudge_level_key = fudge_level_key+diff
                
                if fudge_level_key<1 then
                    fudge_level_key = 1
                elseif fudge_level_key>#fudge_levels then
                    fudge_level_key = #fudge_levels
                end
                
                submes = fudge_levels[fudge_level_key]
                break
            end
        end
    end
    
    if not submes then
        submes = message
    end

    -- GM's prefix
    if minetest.check_player_privs(name, {["gm"]=true,}) then
        name = GM_PREFIX .. name
    end

    senderpos = pl:getpos()
    for i = 1, #pls do
        recieverpos = pls[i]:getpos()
        player_name = pls[i]:get_player_name()
        if math.sqrt((senderpos.x-recieverpos.x)^2 + (senderpos.y-recieverpos.y)^2 + (senderpos.z-recieverpos.z)^2) < range then
			minetest.chat_send_player(player_name , freeminer.colorize(color, string.format(fmt, name, submes)))
        elseif minetest.check_player_privs(pls[i]:get_player_name(), {gm=true}) then
			minetest.chat_send_player(player_name , freeminer.colorize(GMSPY_COLOR, string.format(fmt, name, submes)))
        end
        print(string.format(fmt, name, submes))
    end

    return true
end)
