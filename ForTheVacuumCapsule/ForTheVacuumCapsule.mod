return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`ForTheVacuumCapsule` encountered an error loading the Darktide Mod Framework.")

		new_mod("ForTheVacuumCapsule", {
			mod_script       = "ForTheVacuumCapsule/scripts/mods/ForTheVacuumCapsule/ForTheVacuumCapsule",
			mod_data         = "ForTheVacuumCapsule/scripts/mods/ForTheVacuumCapsule/ForTheVacuumCapsule_data",
			mod_localization = "ForTheVacuumCapsule/scripts/mods/ForTheVacuumCapsule/ForTheVacuumCapsule_localization",
		})
	end,
	packages = {},
}
