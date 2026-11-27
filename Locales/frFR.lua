local _, addon = ...

addon:RegisterLocale("frFR", {
    TEXT_TO_SPEECH = "Synthèse vocale",
    ALERT_SOUND = "Son d’alerte",
    ENABLE_REMINDER = "Activer le rappel pour %s",
    DUPLICATE_SOUND_EFFECTS = "Doubler les sons sans synthèse vocale",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "Joue chaque effet sonore d’alerte deux fois simultanément pour augmenter son volume. La synthèse vocale ne se lance qu’une fois par alerte.",
    DECIMAL_SEPARATOR = ",",

    SHADOW_DANCE = "Danse de l’ombre",
    SHADOW_BLADES = "Lames de l’ombre",
    SHADOW_DANCE_TOOLTIP = "Joue une alerte quand l’effet de %s prend fin alors que celui de %s est encore actif.",

    IMPROVED_GARROTE = "Garrot amélioré",
    GARROTE = "Garrot",
    IMPROVED_GARROTE_TOOLTIP = "Joue une alerte avant la fin de l’effet de %s."
        .. " Les options de synthèse vocale utilisent les noms localisés de %s (par défaut) et de %s.",
    IMPROVED_GARROTE_LEAD_TIME = "Secondes avant la fin de l’effet",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "Définit combien de secondes avant la fin de l’effet de %s l’alerte se déclenche.",

    ROLL_THE_BONES = "Jet d’osselets",
    LOADED_DICE = "Dés pipés",
    ROLL_THE_BONES_TOOLTIP = "Vous avertit quand %s est disponible et qu’il reste 2 secondes à l’effet."
        .. " En entrant en combat ou à la fin de la recharge, vous avertit si la technique est disponible et qu’aucun résultat n’est actif, qu’un résultat de niveau 1 est actif ou qu’un résultat de niveau 2 est actif avec %s.",
    ROLL_THE_BONES_CAST_SOUND = "Son de lancement de %s",
    ROLL_THE_BONES_TTS = "Lance les dés",

    KEEP_IT_ROLLING = "Osselets relancés",
    KEEP_IT_ROLLING_TOOLTIP = "Vous avertit quand %s est de nouveau disponible avec un résultat de %s de niveau 3 ou plus,"
        .. " ou lorsqu’un nouveau résultat de niveau 3 ou plus est obtenu alors que la technique est disponible.",
    KEEP_IT_ROLLING_TTS = "Jackpot",
    UNDERMINE = "Terremine",
    UNDERMINE_JACKPOT_SOUND = "Jackpot de %s",

    PREPARATION = "Préparation",
    ADRENALINE_RUSH = "Poussée d'adrénaline",
    KILLING_SPREE = "Série meurtrière",
    BLADE_RUSH = "Volée de lames",
    PREPARATION_TOOLTIP = "Vérifie les temps de recharge après l’utilisation de %s, de %s ou de %s."
        .. " Vous avertit si %s est disponible et que les trois techniques sont en cours de recharge.",
})
