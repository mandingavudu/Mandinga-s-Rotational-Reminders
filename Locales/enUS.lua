local _, addon = ...

addon:RegisterLocale("enUS", {
    TEXT_TO_SPEECH = "Text-to-Speech",
    ALERT_SOUND = "Alert sound",
    ENABLE_REMINDER = "Enable %s reminder",
    DUPLICATE_SOUND_EFFECTS = "Duplicate non-TTS sounds",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "Plays two simultaneous copies of each alert sound effect for extra volume. Text-to-speech plays once per alert.",
    DECIMAL_SEPARATOR = ".",

    SHADOW_DANCE = "Shadow Dance",
    SHADOW_BLADES = "Shadow Blades",
    SHADOW_DANCE_TOOLTIP = "Plays an alert when %s ends while %s is still active.",

    IMPROVED_GARROTE = "Improved Garrote",
    GARROTE = "Garrote",
    IMPROVED_GARROTE_TOOLTIP = "Plays an alert before your %s buff expires."
        .. " The text-to-speech (TTS) options use the localized names of %s (default) and %s.",
    IMPROVED_GARROTE_LEAD_TIME = "Seconds before expiration",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "Sets how many seconds before %s expires the alert plays.",

    ROLL_THE_BONES = "Roll the Bones",
    LOADED_DICE = "Loaded Dice",
    ROLL_THE_BONES_TOOLTIP = "Alerts when %s is ready and the buff has 2 seconds remaining."
        .. " On combat entry or recharge, it alerts if the spell is ready and you have no active roll, a stage 1 roll, or a stage 2 roll with %s active.",
    ROLL_THE_BONES_CAST_SOUND = "%s cast sound",
    ROLL_THE_BONES_TTS = "Roll",

    KEEP_IT_ROLLING = "Keep It Rolling",
    KEEP_IT_ROLLING_TOOLTIP = "Alerts when %s finishes recharging with a stage 3 or higher %s roll,"
        .. " or when a new roll of stage 3 or higher is applied while the spell is ready.",
    KEEP_IT_ROLLING_TTS = "Jackpot",
    UNDERMINE = "Undermine",
    UNDERMINE_JACKPOT_SOUND = "%s Jackpot",

    PREPARATION = "Preparation",
    ADRENALINE_RUSH = "Adrenaline Rush",
    KILLING_SPREE = "Killing Spree",
    BLADE_RUSH = "Blade Rush",
    PREPARATION_TOOLTIP = "Checks after casting %s, %s, or %s. Alerts if %s is ready and all three spells are on cooldown.",
})
