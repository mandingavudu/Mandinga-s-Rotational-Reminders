local _, addon = ...

addon:RegisterLocale("deDE", {
    TEXT_TO_SPEECH = "Text zu Sprache",
    ALERT_SOUND = "Warnton",
    ENABLE_REMINDER = "Erinnerung für %s aktivieren",
    DUPLICATE_SOUND_EFFECTS = "Warntöne ohne Sprachausgabe doppelt abspielen",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "Spielt jeden Warnton zweimal gleichzeitig ab, um ihn lauter zu machen. Die Sprachausgabe erfolgt einmal pro Warnung.",
    DECIMAL_SEPARATOR = ",",

    SHADOW_DANCE = "Schattentanz",
    SHADOW_BLADES = "Schattenklingen",
    SHADOW_DANCE_TOOLTIP = "Warnt, wenn %s endet und %s noch aktiv ist.",

    IMPROVED_GARROTE = "Verbessertes Erdrosseln",
    GARROTE = "Erdrosseln",
    IMPROVED_GARROTE_TOOLTIP = "Warnt, bevor Euer Stärkungseffekt durch %s endet."
        .. " Die Sprachausgabe verwendet die lokalisierten Namen von %s (Standard) und %s.",
    IMPROVED_GARROTE_LEAD_TIME = "Sekunden vor Ablauf",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "Legt fest, wie viele Sekunden vor Ablauf von %s die Warnung ertönt.",

    ROLL_THE_BONES = "Schicksalswürfel",
    LOADED_DICE = "Gezinkte Würfel",
    ROLL_THE_BONES_TOOLTIP = "Warnt, wenn %s bereit ist und der Stärkungseffekt noch 2 Sekunden anhält."
        .. " Warnt bei Kampfbeginn oder nach Ablauf der Aufladezeit, falls die Fähigkeit bereit ist und kein Würfelergebnis aktiv ist, ein Ergebnis der Stufe 1 aktiv ist oder ein Ergebnis der Stufe 2 zusammen mit %s aktiv ist.",
    ROLL_THE_BONES_CAST_SOUND = "Zaubergeräusch von %s",
    ROLL_THE_BONES_TTS = "Würfeln",

    KEEP_IT_ROLLING = "Großer Wurf",
    KEEP_IT_ROLLING_TOOLTIP = "Warnt, wenn %s wieder bereit ist und ein Ergebnis von %s der Stufe 3 oder höher aktiv ist."
        .. " Warnt auch bei einem neuen Ergebnis der Stufe 3 oder höher, wenn die Fähigkeit bereit ist.",
    KEEP_IT_ROLLING_TTS = "Volltreffer",
    UNDERMINE = "Lorenhall",
    UNDERMINE_JACKPOT_SOUND = "Volltreffer aus %s",

    PREPARATION = "Vorbereitung",
    ADRENALINE_RUSH = "Adrenalinrausch",
    KILLING_SPREE = "Mordlust",
    BLADE_RUSH = "Klingenansturm",
    PREPARATION_TOOLTIP = "Prüft nach dem Einsatz von %s, %s oder %s die Abklingzeiten."
        .. " Warnt, wenn %s bereit ist und alle drei Fähigkeiten Abklingzeit haben.",
})
