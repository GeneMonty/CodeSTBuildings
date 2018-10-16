
--[[

Spectra.lua is used to call the mod directory,
and populate the Spectra Menu and Icon.

]]

-----------------------------------
--Updated Spectra Build Menu Code
--thanks to ChoGGi
-----------------------------------


function OnMsg.ClassesBuilt()

    stdir = CurrentModPath.."UI/st_menu19.tga" -- Maybe "UI/" if img are diff.

    table.insert(
        BuildCategories,
        {
            id ="SPECTRA Build Menu",
            name = T{"Spectra-Mars Division"},
            img = stdir, --stdir.."st_menu14.tga" -maybe?
            highlight_img = stdir, --stdir.."st_menu19.tga" -maybe?
        }
    )
end


---------------------------------
--Spectra Menu Old Working code
---------------------------------

-- function OnMsg.ClassesBuilt()
--
-- 	stdir = Mods["GxtLPqt"]:GetModRootPath()
--
-- 	table.insert(BuildCategories,
-- 		{id = "SPECTRA Build Menu",
-- 		name = T({"Spectra-Mars Division"}),
--
-- 	img = stdir.."UI/st_menu19.tga",
-- 	highlight_img = stdir.."UI/st_menu19.tga"
--
-- })
-- end

---------------------------------
---------------------------------
--[[

exmple how to get root directory

variable = Mods["modID"]:GetModRootPath()

this_mod_dir.."UI/st_menu.tga"

icons that look good

st_menu14.tga
st_menu19.tga

This is the main code for displaying and accesing a custom Icon
into the main build menu.

exmple how to get root directory

variable = Mods["modID"]:GetModRootPath()

this_mod_dir.."UI/st_menu.tga"

]]--
