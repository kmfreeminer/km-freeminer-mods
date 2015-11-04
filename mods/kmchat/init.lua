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
--function dices_proc(pattern, substr, name)
function dices_proc(name, pattern, range, color, priv, substr)
    local dice = substr[1]
    if dice=="4" or dice=="6" or dice=="8" or dice=="10" or dice=="12" or dice=="20" then
        local dice_result = math.random(dice)
        local pattern_result = string.format(pattern, "%s", dice, "%s")
        --return pattern_result, dice_result
        return name, pattern_result, range, color, priv, dice_result
    else
        --return "%s: %s", nil
        return name, "%s: %s", range, color, priv, nil
    end

end

-- fudge dices
fudge_levels = {"-","ужасно--","ужасно-","ужасно", "плохо", "посредственно", "нормально", "хорошо", "отлично", "супер", "легендарно", "легендарно+", "легендарно++","как Аллах"}


--function fudge_proc(pattern, substr, name)
function fudge_proc(name, pattern, range, color, priv, substr)
    local fudge_dice_tmp = substr[1]
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
            --return pattern_result, dice_result
            return name, pattern_result, range, color, priv, dice_result
        end
    end
    return name, "%s: %s", range, color, priv, nil
end

-- language
minetest.register_privilege("i_lang", "")
minetest.register_privilege("c_lang", "")
minetest.register_privilege("a_lang", "")

function word_to_number(word)
    local number = 0

    for i = 1, #word do
        local char = string.sub(word, i, i)
            number = number * (256) + string.byte(char)
    end

    return number
end

cyrillic_uppercase = {"А","Б","В","Г","Д","Е","Ё","Ж","З","И","Й","К","Л","М","Н","О","П","Р","С","Т","У","Ф","Х","Ц","Ч","Ш","Щ","Ъ","Ы","Ь","Э","Ю","Я"}
cyrillic_lowercase = {"а","б","в","г","д","е","ё","ж","з","и","й","к","л","м","н","о","п","р","с","т","у","ф","х","ц","ч","ш","щ","ъ","ы","ь","э","ю","я"}

function cyrillic_lower(phrase)
    for i = 1, #cyrillic_uppercase do 
        phrase = string.gsub(phrase, cyrillic_uppercase[i], cyrillic_lowercase[i])
    end
    return phrase
end

i_lang_parts = {"эль", "эль", "и", "ха", "ля", "ля", "р", "ая", "ма", "кю", "лют", "пил"}
i_lang_max_size = 4

lang_translate = {
["i"] = function(word)
    math.randomseed(word_to_number(word))
    
    local size = math.random(i_lang_max_size)
    local translated_word = ""
    for i = 1, size do 
        local tmp = math.random(#i_lang_parts)
        translated_word = translated_word .. i_lang_parts[tmp]
    end
    
    return translated_word
end,
["c"] = function(word)
    return word
end,
["a"] = function(word)    
    return word
end,
}


--function lang_proc(pattern, substr, name)
function lang_proc(name, pattern, range, color, priv, substr)
    local phrase = ""
    local original = string.gsub(substr[2], "#", "")
    print('test')
    substr[2] = cyrillic_lower(substr[2])
    for word in string.gmatch(substr[2], "%S+") do
        local appendix  = ""
        local prefix = ""
        
        loop = true
        while loop do
            tmp_char = string.sub(word, 0, 1)
            loop = string.match(tmp_char, '%p')
            if loop then
                prefix = prefix .. tmp_char
                word = string.sub(word, 2)
            end
        end
        
        local loop = true
        while loop do
            tmp_char = string.sub(word, -1)
            loop = string.match(tmp_char, '%p')
            if loop then
                appendix = tmp_char .. appendix
                word = string.sub(word, 0, -2)
            end
        end
        
        if string.match(prefix, "#") or word == "" then
            prefix = string.gsub(prefix, "#", "")
            phrase =  phrase .. prefix ..word .. appendix .. " "
        else
            translated_word = lang_translate[substr[1]](word)
            phrase = phrase .. prefix .. translated_word .. appendix .. " " 
        end    
    end
    
    local range_delta = range - DEFAULT_RANGE
    if range_delta     > 0 then
        phrase = string.rep("!", range_delta)..phrase
    elseif range_delta < 0 then
        range_delta = -range_delta
        phrase = string.rep("=", range_delta)..phrase
    end
    print(phrase)
    proc_message(name, phrase)
    -- return pattern, original
    return name, pattern, range, color, priv, original 
end

-- config zone {{{
DEFAULT_FORMAT     = "%s%s: %s" 
DEFAULT_RANGE      = 3
DEFAULT_COLOR      = "EEF3EE"
DICE_COLOR         = "FFFF00"
GMSPY_COLOR        = "666666"
GM_PREFIX          = "[GM] "
RANGES             = {
                         {3,  "(скрытно)"}, 
                         {8,  "(тихо)"  }, 
                         {14, ""        }, 
                         {24, "(громко)"}, 
                         {65, "(громогласно)"}
                     }

-- formats
formats = {
-- ["MATCH"]            = {"FORMAT"                                                  COLOR      PRIV    PRIV_LIST   PROC_FUNCTION}, --
   ["^_(.+)"]           = {"%s%s (OOC): (( %s ))",                                   "9966AA",    nil,      nil,      nil        },
   ["^%(%((.+)%)%)"]    = {"%s%s (OOC): (( %s ))",                                   "9966AA",    nil,      nil,      nil        },
   ["^*%s?(.+)"]        = {"* %s%s %s",                                              "FFFF00",    nil,      nil,      nil        },
   ["^#%s?(.+)"]        = {"*** %s%s: %s ***",                                       "FFFF00",    "gm",     nil,      nil        },
   ["^?%s?(.+)"]        = {"%s%s (OOC): %s ***",                                     "20EEDD",    nil,      nil,      nil        },
   ["^d(%d+).*"]        = {"*** %s%s кидает d%s и выкидывает %s ***",                DICE_COLOR,  nil,      nil,      dices_proc },
   ["^4d[Ff] (.*)$"]    = {"*** %s%s кидает 4df (%s) от %s и выкидывает %s ***",     DICE_COLOR,  nil,      nil,      fudge_proc },
   ["^%%%%%% (.*)$"]    = {"*** %s%s кидает 4df (%s) от %s и выкидывает %s ***",     DICE_COLOR,  nil,      nil,      fudge_proc },
   ["^%+(i)%+%s?(.*)$"] = {"%s%s (альвийский): %s",                                  "BBBBBB",   "i_lang", "i_lang",  lang_proc  },
   ["^%+(c)%+%s?(.*)$"] = {"%s%s (цвергийский): %s",                                 "BBBBBB",   "c_lang", "c_lang",  lang_proc  },
   ["^%+(a)%+%s?(.*)$"] = {"%s%s (авоонский): %s",                                   "BBBBBB",   "a_lang", "a_lang",  lang_proc  },
}

-- config zone }}}

minetest.register_privilege("gm", "Позволяет читать все сообщения в чате")

function proc_message(name, message)
    local fmt       = DEFAULT_FORMAT 
    local range     = DEFAULT_RANGE
    local color     = DEFAULT_COLOR
    local privilege = nil
    
    local player_name = name
        
    local player  = minetest.get_player_by_name(player_name)
    local players = minetest.get_connected_players()
    
    local loud_control = string.match(message, '^[!=]*')
    range = range + #(string.match(string.gsub(message,"=",""), '!*'))
    range = range - #(string.match(string.gsub(message,"!",""), '=*'))
    
    if range < 1 then
        range = 1
    elseif range > #RANGES then
        range = #RANGES
    end
    
    message = string.gsub(message, "^[!=]*", "")
    
    local substr = nil
    -- formats (see config zone)
    for regexp, properties in pairs(formats) do
        substr = {string.match(message, regexp)}
        if substr[1] then
            if (not properties[3]) or minetest.check_player_privs(player_name, {[properties[3]]=true}) then  -- if PRIV==nil
                if properties[5]~=nil then
                    player_name, fmt, range, color, priv, substr = properties[5](player_name, properties[1], range, properties[2], properties[4], substr)
                else
                    fmt    = properties[1];
                    color  = properties[2];
                    priv   = properties[4];
                    substr = substr[1]
                end
                break
            end
        end
        substr = substr[1]
    end

    if not substr then
        substr = message
        color = DEFAULT_COLOR
    end

    -- GM's prefix
    if minetest.check_player_privs(name, {["gm"]=true,}) then
        player_name = GM_PREFIX .. player_name
    end

    local sender_pos = player:getpos()
    for i = 1, #players do 
        local reciever_name = players[i]:get_player_name()
        local reciever_pos  = players[i]:getpos()
        if math.sqrt((sender_pos.x-reciever_pos.x)^2 + (sender_pos.y-reciever_pos.y)^2 + (sender_pos.z-reciever_pos.z)^2) < RANGES[range][1] then
            if (not priv) or minetest.check_player_privs(reciever_name, {[priv]=true}) then
                minetest.chat_send_player(reciever_name, freeminer.colorize(color, string.format(fmt, player_name, RANGES[range][2], substr)))
            end
        elseif minetest.check_player_privs(players[i]:get_player_name(), {gm=true}) then
			minetest.chat_send_player(reciever_name , freeminer.colorize(GMSPY_COLOR, string.format(fmt, player_name, RANGES[range][2],  substr)))
        end
        print(string.format(fmt, player_name, RANGES[range][2], substr))
    end

    return true
end

minetest.register_on_chat_message(proc_message)
