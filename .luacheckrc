unused_args = false
allow_defined_top = true

read_globals = {
	"DIR_DELIM",
	"vector", "nodeupdate",
	"VoxelManip", "VoxelArea",
	"PseudoRandom", "ItemStack",
}
globals = { "minetest", "core", "freeminer" }

-- Don't report on legacy definitions of globals.
files["mods/default/legacy.lua"].global = false
