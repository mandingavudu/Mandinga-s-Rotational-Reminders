local _, addon = ...

addon:RegisterLocale("esMX", {
    TEXT_TO_SPEECH = "Texto a voz",
    ALERT_SOUND = "Sonido de alerta",
    ENABLE_REMINDER = "Activar recordatorio de %s",
    DUPLICATE_SOUND_EFFECTS = "Duplicar sonidos sin texto a voz",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "Reproduce dos copias simultáneas de cada efecto de sonido de alerta para aumentar el volumen. El texto a voz se reproduce una vez por alerta.",
    DECIMAL_SEPARATOR = ".",

    SHADOW_DANCE = "Danza de las Sombras",
    SHADOW_BLADES = "Hojas de las Sombras",
    SHADOW_DANCE_TOOLTIP = "Reproduce una alerta cuando termina %s mientras el efecto de %s sigue activo.",

    IMPROVED_GARROTE = "Garrote mejorado",
    GARROTE = "Garrote",
    IMPROVED_GARROTE_TOOLTIP = "Reproduce una alerta antes de que termine tu beneficio de %s."
        .. " Las opciones de texto a voz usan los nombres localizados de %s (predeterminado) y %s.",
    IMPROVED_GARROTE_LEAD_TIME = "Segundos antes de que termine",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "Ajusta cuántos segundos antes de que termine %s suena la alerta.",

    ROLL_THE_BONES = "Lanzar huesos",
    LOADED_DICE = "Dado cargado",
    ROLL_THE_BONES_TOOLTIP = "Avisa cuando %s está disponible y le quedan 2 segundos al beneficio."
        .. " Al entrar en combate o terminar la recarga, avisa si la habilidad está disponible y no tienes una tirada activa, tienes una de nivel 1 o tienes una de nivel 2 con %s activo.",
    ROLL_THE_BONES_CAST_SOUND = "Sonido al usar %s",
    ROLL_THE_BONES_TTS = "Lanza los dados",

    KEEP_IT_ROLLING = "Huesos fuertes",
    KEEP_IT_ROLLING_TOOLTIP = "Avisa cuando %s termina de recargarse con una tirada de %s de nivel 3 o superior,"
        .. " o cuando obtienes una tirada nueva de nivel 3 o superior con la habilidad disponible.",
    KEEP_IT_ROLLING_TTS = "Premio",
    UNDERMINE = "Minahonda",
    UNDERMINE_JACKPOT_SOUND = "Premio de %s",

    PREPARATION = "Preparación",
    ADRENALINE_RUSH = "Subidón de adrenalina",
    KILLING_SPREE = "Asesinato múltiple",
    BLADE_RUSH = "Carga de hojas",
    PREPARATION_TOOLTIP = "Revisa los tiempos de reutilización después de usar %s, %s o %s."
        .. " Avisa si %s está disponible y las tres habilidades están en tiempo de reutilización.",
})
