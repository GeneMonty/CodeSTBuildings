
--[[This is the main code for displaying and accesing a custom Icon into the main build menu.

exmple how to get root directory

variable = Mods["modID"]:GetModRootPath()

this_mod_dir.."UI/st_menu.tga"
]]

function OnMsg.ClassesBuilt()

	stdir = Mods["GxtLPqt"]:GetModRootPath()

	table.insert(BuildCategories,
	{id = "SPECTRA Build Menu",

	name = T({"Spectra-Mars Division"}),

	img = stdir.."UI/st_menu3.tga",
	highlight_img = stdir.."UI/st_menu3.tga"

	--img = "UI/Icons/bmc_power.tga",
	--highlight_img = "UI/Icons/bmc_power.tga"

	})

end
