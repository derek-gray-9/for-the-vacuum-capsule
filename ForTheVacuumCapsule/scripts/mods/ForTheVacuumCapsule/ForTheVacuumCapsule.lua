local mod = get_mod("ForTheVacuumCapsule")

-- Native libraries used for activating voice lines.
local VOQueryConstants = require("scripts/settings/dialogue/vo_query_constants")
local Vo = require("scripts/utilities/vo")

-- Used for for finding the player who activated the voice line when hotkeys are pressed.
local HudElementSmartTagging_instance

-- Local enums
local VoiceLines = mod:io_dofile("ForTheVacuumCapsule/scripts/mods/ForTheVacuumCapsule/definitions/ForTheVacuumCapsule_voiceLines")
local WheelPositions = mod:io_dofile("ForTheVacuumCapsule/scripts/mods/ForTheVacuumCapsule/definitions/ForTheVacuumCapsule_wheelPositions")

--[[
  - Hook into the native localize function to add tag wheel names.
  - Since these language tokens are used by the game, and not by the mod framework, we can't handle
  - the translation on our end, and must directly add these strings.
]]--
mod:hook(LocalizationManager, "localize", function(func, self, key, no_cache, context)
    self._string_cache.loc_ammo = "Ammo"
    self._string_cache.loc_ammo_crate = "Ammo Crate"
    self._string_cache.loc_cryonic_rod = "Cryonic Rod"
    self._string_cache.loc_diamantine = "Diamantine"
    self._string_cache.loc_enemy = "Enemy"
    self._string_cache.loc_following = "Following"
    self._string_cache.loc_for_the_emperor = "For the Emperor!"
    self._string_cache.loc_go_there = "Go There"
    self._string_cache.loc_grenade = "Grenade"
    self._string_cache.loc_grimoire = "Grimoire"
    self._string_cache.loc_health_booster = "Health Booster"
    self._string_cache.loc_look_there = "Look There"
    self._string_cache.loc_medicae_station = "Medicae Station"
    self._string_cache.loc_medipack = "Medipack"
    self._string_cache.loc_medipack_down = "Medipack Down"
    self._string_cache.loc_mine = "Mine"
    self._string_cache.loc_need_ammo = "Need Ammo"
    self._string_cache.loc_need_healing = "Need Healing"
    self._string_cache.loc_no = "No"
    self._string_cache.loc_plasteel = "Plasteel"
    self._string_cache.loc_power_cell = "Power Cell"
    self._string_cache.loc_relic = "Relic"
    self._string_cache.loc_scripture = "Scripture"
    self._string_cache.loc_thanks = "Thanks"
    self._string_cache.loc_uncharged_medicae = "Uncharged Medicae"
    self._string_cache.loc_vacuum_capsule = "Vacuum Capsule"
    self._string_cache.loc_yes = "Yes"
    return func(self, key, no_cache, context)
end)

--[[
  - All the available voice lines in the native object layout so that they can be activated by the social wheel.
  -
  - The structure is as follows:
  - [local enum] = {
  -     icon = "path to image to display on the social wheel",
  -     display_name = "language token",
  -     voice_event_data = {
  -         voice_tag_concept = native trigger method
  -         voice_tag_id = native voice line id
  -     }
  - }
]]--
local voiceLines = {
    [VoiceLines.FOR_THE_EMPEROR] = {
        icon = "content/ui/materials/icons/system/escape/achievements",
        display_name = "loc_for_the_emperor",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_for_the_emperor,
        },
    },
    [VoiceLines.VACUUM_CAPSULE] = {
        icon = "content/ui/materials/hud/interactions/icons/training_grounds",
        display_name = "loc_vacuum_capsule",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_container,
        },
    },
    [VoiceLines.YES] = {
        icon = "content/ui/materials/icons/pocketables/hud/scripture",
        display_name = "loc_yes",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_yes,
        },
    },
    [VoiceLines.NO] = {
        icon = "content/ui/materials/icons/system/settings/category_interface",
        display_name = "loc_no",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_no,
        },
    },
    [VoiceLines.CRYONIC_ROD] = {
        icon = "content/ui/materials/hud/interactions/icons/training_grounds",
        display_name = "loc_cryonic_rod",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_control_rod,
        },
    },
    [VoiceLines.POWER_CELL] = {
        icon = "content/ui/materials/hud/interactions/icons/training_grounds",
        display_name = "loc_power_cell",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_battery
        },
    },
    [VoiceLines.SCRIPTURE] = {
        icon = "content/ui/materials/icons/pocketables/hud/scripture",
        display_name = "loc_scripture",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_side_mission_tome,
        },
    },
    [VoiceLines.GRIMOIRE] = {
        icon = "content/ui/materials/icons/pocketables/hud/grimoire",
        display_name = "loc_grimoire",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_side_mission_grimoire,
        },
    },
    [VoiceLines.RELIC] = {
        icon = "content/ui/materials/icons/pocketables/hud/grimoire",
        display_name = "loc_relic",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_side_mission_consumable,
        },
    },
    [VoiceLines.HEALTH_BOOSTER] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_medkit",
        display_name = "loc_health_booster",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_health_booster,
        },
    },
    [VoiceLines.MINE] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_default",
        display_name = "loc_mine",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_need_that,
        },
    },
    [VoiceLines.AMMO] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_ammo",
        display_name = "loc_ammo",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_ammo,
        },
    },
    [VoiceLines.GRENADE] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_default",
        display_name = "loc_grenade",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_small_grenade,
        },
    },
    [VoiceLines.PLASTEEL] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_default",
        display_name = "loc_plasteel",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_forge_metal,
        },
    },
    [VoiceLines.DIAMANTINE] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_default",
        display_name = "loc_diamantine",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_platinum,
        },
    },
    [VoiceLines.FOLLOWING] = {
        icon = "content/ui/materials/icons/pocketables/hud/scripture",
        display_name = "loc_following",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_follow_you,
        },
    },
    [VoiceLines.MEDICATE_STATION] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_medkit",
        display_name = "loc_medicae_station",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_station_health,
        },
    },
    [VoiceLines.UNCHARGED_MEDICAE] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_medkit",
        display_name = "loc_uncharged_medicae",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_station_health_without_battery,
        },
    },
    [VoiceLines.MEDIPACK] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_medkit",
        display_name = "loc_medipack",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_medical_crate,
        },
    },
    [VoiceLines.MEDIPACK_DOWN] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_medkit",
        display_name = "loc_medipack_down",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_deployed_medical_crate,
        },
    },
    [VoiceLines.AMMO_CRATE] = {
        icon = "content/ui/materials/hud/interactions/icons/pocketable_ammo",
        display_name = "loc_ammo_crate",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_vo_tag_item,
            voice_tag_id = VOQueryConstants.trigger_ids.smart_tag_vo_pickup_deployed_ammo_crate,
        },
    },
    [VoiceLines.NEED_AMMO] = {
        icon = "content/ui/materials/hud/communication_wheel/icons/ammo",
        display_name = "loc_need_ammo",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_need_ammo,
        },
    },
    [VoiceLines.NEED_HEALING] = {
        icon = "content/ui/materials/hud/communication_wheel/icons/health",
        display_name = "loc_need_healing",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_need_health,
        },
    },
    [VoiceLines.LOOK_THERE] = {
        icon = "content/ui/materials/hud/communication_wheel/icons/attention",
        display_name = "loc_look_there",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_over_here,
        },
    },
    [VoiceLines.GO_THERE] = {
        icon = "content/ui/materials/hud/communication_wheel/icons/location",
        display_name = "loc_go_there",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_lets_go_this_way,
        },
    },
    [VoiceLines.ENEMY] = {
        icon = "content/ui/materials/hud/communication_wheel/icons/enemy",
        display_name = "loc_enemy",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_enemy_over_here,
        },
    },
    [VoiceLines.THANKS] = {
        icon = "content/ui/materials/hud/communication_wheel/icons/thanks",
        display_name = "loc_thanks",
        voice_event_data = {
            voice_tag_concept = VOQueryConstants.concepts.on_demand_com_wheel,
            voice_tag_id = VOQueryConstants.trigger_ids.com_wheel_vo_thank_you,
        },
    },
}

--[[
  - Bind to the event: the tagging wheel is initialized.
  - We replace options that are changed from the default by the user, otherwise keeping the default in that slot.
]]--
mod:hook("HudElementSmartTagging", "_populate_wheel", function(func, self, options)
    local setting = 0

    setting = mod:get("plugin_wheel_bottom")
    if setting > 0 then
        options[WheelPositions.BOTTOM] = voiceLines[setting]
    end

    setting = mod:get("plugin_wheel_bottom_right")
    if setting > 0 then
        options[WheelPositions.BOTTOM_RIGHT] = voiceLines[setting]
    end

    setting = mod:get("plugin_wheel_right")
    if setting > 0 then
        options[WheelPositions.RIGHT] = voiceLines[setting]
    end

    setting = mod:get("plugin_wheel_top_right")
    if setting > 0 then
        options[WheelPositions.TOP_RIGHT] = voiceLines[setting]
    end

    setting = mod:get("plugin_wheel_top")
    if setting > 0 then
        options[WheelPositions.TOP] = voiceLines[setting]
    end

    setting = mod:get("plugin_wheel_top_left")
    if setting > 0 then
        options[WheelPositions.TOP_LEFT] = voiceLines[setting]
    end

    setting = mod:get("plugin_wheel_left")
    if setting > 0 then
        options[WheelPositions.LEFT] = voiceLines[setting]
    end

    setting = mod:get("plugin_wheel_bottom_left")
    if setting > 0 then
        options[WheelPositions.BOTTOM_LEFT] = voiceLines[setting]
    end
 
    func(self, options)
end)

--[[
  - Binds keys to voice commands.
  - The "user pressing a key -> run a function" part is actually handled by the mod framework. We
  - are just setting up what each function will do (play the desired voice line).
]]--
local function setup_keybind_functions()
    for key, option in pairs(voiceLines) do
        mod["keybind_" .. key] = function()
            local voice_event_data = option.voice_event_data

            if voice_event_data then
                local parent = HudElementSmartTagging_instance._parent
                local player_unit = parent:player_unit()

                if player_unit then
                    Vo.on_demand_vo_event(
                        player_unit,
                        voice_event_data.voice_tag_concept,
                        voice_event_data.voice_tag_id
                    )
                end
            end
        end
    end
end

--[[
  - Bind to the game's update loop.
  - On the first update, we replace the social wheel options with our own and initiate the keybinds.
  - We can be sure the player is in a match and the necessary classes are instantiated by the game.
]]--
mod:hook_safe("HudElementSmartTagging", "update", function(self)
    if not HudElementSmartTagging_instance then
        HudElementSmartTagging_instance = self

        setup_keybind_functions()
    end

    if mod.setting_dirty then
        self:_populate_wheel()
        mod.setting_dirty = false
    end
end)

--[[
  - Initialize each voiceline keybind to a do-nothing function.
  - This is to address the case where the voice activation by the game has not yet been initialized,
  - but the user tries to activate a voice line with one of their hotkeys. These do-nothing functions
  - will be overwritten once the player is in a match.
]]--
local function init_keybind_functions()
    local nilFunction = function()
        return
    end
    for key in pairs(voiceLines) do
        mod["keybind_" .. key] = nilFunction
    end
end

init_keybind_functions()