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

-- dices
function dices_proc(pattern, submes, name)
    local dice = submes[1]
    if dice=="4" or dice=="6" or dice=="8" or dice=="10" or dice=="12" or dice=="20" then
        local dice_result = math.random(dice)
        local pattern_result = string.format(pattern, "%s", dice, "%s")
        return pattern_result, dice_result
    else
        return "%s: %s", nil
    end

end

-- fudge dices
fudge_levels = {"-","terrible--","terrible-","terrible", "poor", "mediocre", "fair", "good", "great", "superb", "legendary", "legendary+", "legendary++","like Allah"}

function fudge_proc(pattern, submes, name)
    local fudge_dice_tmp = submes[1]
    for key, val in pairs(fudge_levels) do
        local fudge_level = string.match(fudge_dice_tmp, "^("..val..".*)")
        local fudge_level_key = key
        
        if fudge_level~=nil then
            local diff = 0
            local signs = ""
            
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
            
            local pattern_result = string.format(pattern, "%s", signs, fudge_level, "%s")

            fudge_level_key = fudge_level_key+diff
            
            if fudge_level_key<1 then
                fudge_level_key = 1
            elseif fudge_level_key>#fudge_levels then
                fudge_level_key = #fudge_levels
            end
            
            local dice_result = fudge_levels[fudge_level_key]
            return pattern_result, dice_result
        end
    end
    return "%s: %s", nil
end

-- language
minetest.register_privilege("i_lang", "")
minetest.register_privilege("c_lang", "")
minetest.register_privilege("a_lang", "")

function word_to_number(word)

    return number
end

function lang_translate(word, lang_letter)

    return "test"
end

function lang_proc(pattern, submes, name)
    local phrase = ""
    for word in string.gmatch(submes[2], "%S+") do
        if string.match(word, "[A-z]") then
            phrase = phrase .. word .. " "
        else
            phrase = phrase .. translated_word .. " "            
        end
    end
    
    proc_message(name, phrase)
    return pattern, submes[2]
end

-- config zone {{{
DEFAULT_FORMAT     = "%s: %s" 
DEFAULT_RANGE      = 18
DEFAULT_COLOR      = "EEF3EE"
DICE_COLOR         = "FFFF00"
GMSPY_COLOR        = "666666"
GM_PREFIX          = "[GM] "

-- formats
formats = {
-- ["MATCH"]        = {"FORMAT"                                                            RANGE     COLOR      PRIV    PRIV_LIST   PROC_FUNCTION}, --
   ["^_(.+)"]        = {"%s (OOC): (( %s ))",                                               18,    "9966AA",    nil,      nil,      nil        },
   ["^%(%((.+)%)%)"] = {"%s (OOC): (( %s ))",                                               18,    "9966AA",    nil,      nil,      nil        },
   ["^!(.+)"]        = {"%s (shouts): %s",                                                  68,    "FFFFFF",    nil,      nil,      nil        },
   ["^=(.+)"]        = {"%s (whispers): %s",                                                3,     "E0EEE0",    nil,      nil,      nil        },
   ["^*(.+)"]        = {"* %s %s",                                                          18,    "FFFF00",    nil,      nil,      nil        },
   ["^#(.+)"]        = {"*** %s: %s ***",                                                   18,    "FFFF00",    "gm",     nil,      nil        },
   ["^?(.+)"]        = {"%s (OOC): %s ***",                                                 31000, "20EEDD",    nil,      nil,      nil        },
   ["^d(%d+).*"]     = {"*** %s rolls d%s and the result is %s ***",                        18,    DICE_COLOR,  nil,      nil,      dices_proc },
   ["^sd(%d+).*"]    = {"*** %s rolls d%s silently and the result is %s ***",               3,     "D8DBB6",    nil,      nil,      dices_proc },
   ["^4dF (.*)$"]    = {"*** %s rolls 4df (%s) from %s and the result is %s ***",           18,    DICE_COLOR,  nil,      nil,      fudge_proc },
   ["^s4dF (.*)$"]   = {"*** %s rolls 4df (%s) from %s silently and the result is %s ***",  3,     "D8DBB6",    nil,      nil,      fudge_proc },
   ["^%+(i)%+(.*)$"] = {"[[%s (альвийский): %s]]",                                          18,  DEFAULT_COLOR, "i_lang", "i_lang", lang_proc  },
   ["^%+(c)%+(.*)$"] = {"[[%s (цвергийский): %s]]",                                         18,  DEFAULT_COLOR, "c_lang", "c_lang", lang_proc  },
   ["^%+(a)%+(.*)$"] = {"[[%s (авоонский): %s]]",                                           18,  DEFAULT_COLOR, "a_lang", "a_lang", lang_proc  },
}

-- config zone }}}
minetest.register_privilege("gm", "Gives accses to reading all messages in the chat")

function proc_message(name, message)
    local fmt = DEFAULT_FORMAT 
    local range = DEFAULT_RANGE
    local color = DEFAULT_COLOR
    local priv = nil
    
    local pl = minetest.get_player_by_name(name)
    local pls = minetest.get_connected_players()
    
    local submes = nil
    
    -- formats (see config zone)
    for m, f in pairs(formats) do
        submes = {string.match(message, m)}
        if submes[1] then
            if (not f[4]) or minetest.check_player_privs(name, {[f[4]]=true}) then  -- if PRIV==nil
                fmt = f[1]
                range = f[2]
                color = f[3]
                priv = f[5]
                
                if f[6]~=nil then
                    fmt, submes = f[6](fmt, submes, name)
                else
                    submes = submes[1]
                end
                break
            end
        end
        submes = submes[1]
    end

    if not submes then
        submes = message
        color = DEFAULT_COLOR
    end

    -- GM's prefix
    if minetest.check_player_privs(name, {["gm"]=true,}) then
        name = GM_PREFIX .. name
    end

    local senderpos = pl:getpos()
    for i = 1, #pls do 
        local recieverpos = pls[i]:getpos()
        local player_name = pls[i]:get_player_name()
        if math.sqrt((senderpos.x-recieverpos.x)^2 + (senderpos.y-recieverpos.y)^2 + (senderpos.z-recieverpos.z)^2) < range then
            if (not priv) or minetest.check_player_privs(pls[i]:get_player_name(), {[priv]=true}) then
                minetest.chat_send_player(player_name , freeminer.colorize(color, string.format(fmt, name, submes)))
            end
        elseif minetest.check_player_privs(pls[i]:get_player_name(), {gm=true}) then
			minetest.chat_send_player(player_name , freeminer.colorize(GMSPY_COLOR, string.format(fmt, name, submes)))
        end
        print(string.format(fmt, name, submes))
    end

    return true
end

minetest.register_on_chat_message(proc_message)
