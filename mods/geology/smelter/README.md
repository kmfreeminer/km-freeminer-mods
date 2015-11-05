=== Crafter MOD for MINETEST-C55 ===
by Master Gollum

Introduction:

  This MOD introduces a new kind of Furnace called Smelter. 
  It is intended for provide a mean for smelt materials, for 
  example to create alloys in a more realistic way.
  This MOD adds also a new kind of crafts (smelting) with a 
  2x2 grid.


  The first release transform iron_ore in iron_ingot also
  iron_ingot + coal_lump in steel_ingot as example of 
  uses.

  CRAFT for a Smelter
  [cobble] [cobble] [cobble]
  [cobble] [furnace] [cobble] 
  [cobble] [cobble] [cobble]

For developers:

  Anyone that intends to define a new smelting they MUST 
  be registered with the crafter MOD.

  crafter.register_craft({
	  type = "smelting",
	  output = "smelter:iron_ingot",
	  recipe = {
      {"default:iron_lump"}
    }
  })

  crafter.register_craft({
	  type = "smelting",
	  output = "default:steel_ingot",
	  recipe = {
      {"smelter:iron_ingot"},
      {"default:coal_lump"}
    }
  })

Depends
  default
  crafter


Release Notes

  Version 0.1
     Initial version

PS: This document has been structured as the README.txt of PilzAdam in 
    his Bed MOD.

How to install:
  Unzip the archive an place it in minetest-base-directory/mods/minetest/
  if you have a windows client or a linux run-in-place client. If you 
  have a linux system-wide instalation place it in 
  ~/.minetest/mods/minetest/.
  If you want to install this mod only in one world create the folder
  worldmods/ in your worlddirectory.
  For further information or help see:
    http://wiki.minetest.com/wiki/Installing_Mods


License:
Sourcecode: WTFPL (see below)
Graphics: WTFPL (see below)

See also:
http://minetest.net/

         DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
                    Version 2, December 2004

 Copyright (C) 2004 Sam Hocevar <sam@hocevar.net>

 Everyone is permitted to copy and distribute verbatim or modified
 copies of this license document, and changing it is allowed as long
 as the name is changed.

            DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
   TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

  0. You just DO WHAT THE FUCK YOU WANT TO. 





