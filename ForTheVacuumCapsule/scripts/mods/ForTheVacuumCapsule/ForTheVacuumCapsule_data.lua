local mod = get_mod("ForTheVacuumCapsule")

-- Voice line enum.
local VoiceLines = mod:io_dofile("ForTheVacuumCapsule/scripts/mods/ForTheVacuumCapsule/definitions/ForTheVacuumCapsule_voiceLines")

--[[
  - Returns a fresh list of the voice lines in alphabetical order.
  - It must be a new list each time since the framework functions operating on the list are destructive.
]]--
local function get_options()
    return {
        { text = "option_nil", value = VoiceLines.NIL },
        { text = "option_ammo", value = VoiceLines.AMMO },
        { text = "option_ammo_crate", value = VoiceLines.AMMO_CRATE },
        { text = "option_cryonic_rod", value = VoiceLines.CRYONIC_ROD },
        { text = "option_diamantine", value = VoiceLines.DIAMANTINE },
        { text = "option_enemy", value = VoiceLines.ENEMY },
        { text = "option_following", value = VoiceLines.FOLLOWING },
        { text = "option_for_the_emperor", value = VoiceLines.FOR_THE_EMPEROR },
        { text = "option_go_there", value = VoiceLines.GO_THERE },
        { text = "option_grenade", value = VoiceLines.GRENADE },
        { text = "option_grimoire", value = VoiceLines.GRIMOIRE },
        { text = "option_health_booster", value = VoiceLines.HEALTH_BOOSTER },
        { text = "option_look_there", value = VoiceLines.LOOK_THERE },
        { text = "option_medicae_station", value = VoiceLines.MEDICATE_STATION },
        { text = "option_medipack", value = VoiceLines.MEDIPACK },
        { text = "option_medipack_down", value = VoiceLines.MEDIPACK_DOWN },
        { text = "option_mine", value = VoiceLines.MINE },
        { text = "option_need_ammo", value = VoiceLines.NEED_AMMO },
        { text = "option_need_healing", value = VoiceLines.NEED_HEALING },
        { text = "option_no", value = VoiceLines.NO },
        { text = "option_plasteel", value = VoiceLines.PLASTEEL },
        { text = "option_power_cell", value = VoiceLines.POWER_CELL },
        { text = "option_relic", value = VoiceLines.RELIC },
        { text = "option_scripture", value = VoiceLines.SCRIPTURE },
        { text = "option_thanks", value = VoiceLines.THANKS },
        --{ text = "option_uncharged_medicae", value = VoiceLines.UNCHARGED_MEDICAE }, Doesn't work
        { text = "option_vacuum_capsule", value = VoiceLines.VACUUM_CAPSULE },
        { text = "option_yes", value = VoiceLines.YES },
    }
end

--[[
  - Converts a fresh list of voice lines into a list of widgets.
]]--
local function get_keybind_widgets()
    local widgets = {}

    for i, option in ipairs(get_options()) do
        if option.value > 0 then
            widgets[i - 1] = {
                setting_id = option.text,
                type = "keybind",
                keybind_trigger = "pressed",
                keybind_type = "function_call",
                function_name = "keybind_" .. option.value,
                default_value = {},
            }
        end
    end

    return widgets
end

return {
    name = mod:localize("mod_title"),
    description = mod:localize("mod_description"),
    is_togglable = true,
    options = {
        widgets = {
            -- The 8 wheel spots have a dropdown, where any of the voice lines can be selected.
            {
                setting_id = "plugin_wheel_top_left",
                type = "dropdown",
                default_value = 0,
                options = get_options(),
            },
            {
                setting_id = "plugin_wheel_top",
                type = "dropdown",
                default_value = 0,
                options = get_options(),
            },
            {
                setting_id = "plugin_wheel_top_right",
                type = "dropdown",
                default_value = 0,
                options = get_options(),
            },
            {
                setting_id = "plugin_wheel_left",
                type = "dropdown",
                default_value = 0,
                options = get_options(),
            },
            {
                setting_id = "plugin_wheel_right",
                type = "dropdown",
                default_value = 0,
                options = get_options(),
            },
            {
                setting_id = "plugin_wheel_bottom_left",
                type = "dropdown",
                default_value = 0,
                options = get_options(),
            },
            {
                setting_id = "plugin_wheel_bottom",
                type = "dropdown",
                default_value = 0,
                options = get_options(),
            },
            {
                setting_id = "plugin_wheel_bottom_right",
                type = "dropdown",
                default_value = 0,
                options = get_options(),
            },
            
            -- Hotkeys
            {
                setting_id = "plugin_keybinds",
                type = "group",
                sub_widgets = get_keybind_widgets(),
            },
        },
    },
}
