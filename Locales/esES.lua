local _, addon = ...

addon:RegisterLocale("esES", {
    TEXT_TO_SPEECH = "Texto a voz",
    ALERT_SOUND = "Sonido de alerta",
    ENABLE_REMINDER = "Activar recordatorio de %s",
    DUPLICATE_SOUND_EFFECTS = "Duplicar sonidos sin texto a voz",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "Reproduce dos copias simultáneas de cada efecto sonoro de alerta para aumentar el volumen. El texto a voz se reproduce una vez por alerta.",
    DECIMAL_SEPARATOR = ",",

    SHADOW_DANCE = "Danza de las Sombras",
    SHADOW_BLADES = "Hojas de las Sombras",
    SHADOW_DANCE_TOOLTIP = "Reproduce una alerta cuando termina %s mientras el efecto de %s sigue activo.",

    IMPROVED_GARROTE = "Garrote mejorado",
    GARROTE = "Garrote",
    IMPROVED_GARROTE_TOOLTIP = "Reproduce una alerta antes de que expire tu beneficio de %s."
        .. " Las opciones de texto a voz usan los nombres localizados de %s (predeterminado) y %s.",
    IMPROVED_GARROTE_LEAD_TIME = "Segundos antes de que expire",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "Ajusta cuántos segundos antes de que expire %s suena la alerta.",

    ROLL_THE_BONES = "A suertes",
    LOADED_DICE = "Dados trucados",
    ROLL_THE_BONES_TOOLTIP = "Avisa cuando %s está disponible y le quedan 2 segundos al beneficio."
        .. " Al entrar en combate o terminar la recarga, avisa si la facultad está disponible y no tienes una tirada activa, tienes una de nivel 1 o tienes una de nivel 2 con %s activo.",
    ROLL_THE_BONES_CAST_SOUND = "Sonido al lanzar %s",
    ROLL_THE_BONES_TTS = "Tira los dados",

    KEEP_IT_ROLLING = "Suerte prolongada",
    KEEP_IT_ROLLING_TOOLTIP = "Avisa cuando %s termina de recargarse con una tirada de %s de nivel 3 o superior,"
        .. " o cuando consigues una tirada nueva de nivel 3 o superior con la facultad disponible.",
    KEEP_IT_ROLLING_TTS = "Premio",
    UNDERMINE = "Minahonda",
    UNDERMINE_JACKPOT_SOUND = "Premio de %s",

    PREPARATION = "Preparación",
    ADRENALINE_RUSH = "Subidón de adrenalina",
    KILLING_SPREE = "Asesinato múltiple",
    BLADE_RUSH = "Carga de hojas",
    PREPARATION_TOOLTIP = "Comprueba los tiempos de reutilización tras usar %s, %s o %s."
        .. " Avisa si %s está disponible y las tres facultades están en tiempo de reutilización.",
})
