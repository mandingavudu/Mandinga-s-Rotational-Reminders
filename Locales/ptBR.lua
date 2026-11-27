local _, addon = ...

addon:RegisterLocale("ptBR", {
    TEXT_TO_SPEECH = "Texto em Fala",
    ALERT_SOUND = "Som do aviso",
    ENABLE_REMINDER = "Ativar lembrete de %s",
    DUPLICATE_SOUND_EFFECTS = "Duplicar sons sem TTS",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "Toca duas cópias simultâneas do efeito sonoro do addon para aumentar o volume. O texto em fala toca uma vez por aviso.",
    DECIMAL_SEPARATOR = ",",

    SHADOW_DANCE = "Dança das Sombras",
    SHADOW_BLADES = "Lâminas Sombrias",
    SHADOW_DANCE_TOOLTIP = "Toca um aviso quando %s termina e o efeito de %s permanece ativo.",

    IMPROVED_GARROTE = "Garrote Aprimorado",
    IMPROVED_GARROTE_TOOLTIP = "Toca um aviso antes de terminar o efeito de %s."
        .. " As opções de texto em fala (TTS) usam os nomes localizados de %s (padrão) e %s.",
    IMPROVED_GARROTE_LEAD_TIME = "Tempo de antecedência",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "Define quantos segundos antes do fim de %s o aviso toca.",

    ROLL_THE_BONES = "Golpe de Sorte",
    LOADED_DICE = "Dados Viciados",
    ROLL_THE_BONES_TOOLTIP = "Avisa quando a habilidade %s está pronta e faltam 2 segundos para o efeito terminar."
        .. " Ao entrar em combate ou ao terminar a recarga, avisa se a habilidade estiver pronta e você estiver sem efeito ativo, no estágio 1 ou no estágio 2 com o bônus de %s ativo.",
    ROLL_THE_BONES_CAST_SOUND = "Som de %s",
    ROLL_THE_BONES_TTS = "Role",

    KEEP_IT_ROLLING = "Sorte Grande",
    KEEP_IT_ROLLING_TOOLTIP = "Avisa quando %s termina a recarga com um resultado de %s no estágio 3 ou superior,"
        .. " ou quando você obtém um resultado nesses estágios com a habilidade pronta.",
    UNDERMINE = "Inframina",
    UNDERMINE_JACKPOT_SOUND = "Jackpot da %s",

    PREPARATION = "Preparação",
    ADRENALINE_RUSH = "Adrenalina",
    KILLING_SPREE = "Matança",
    BLADE_RUSH = "Ímpeto da Lâmina",
    PREPARATION_TOOLTIP = "Verifica as recargas após você usar %s, %s ou %s. Avisa se %s estiver pronta e as três habilidades estiverem em recarga.",
})
