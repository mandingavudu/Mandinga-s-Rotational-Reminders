local _, addon = ...

addon:RegisterLocale("itIT", {
    TEXT_TO_SPEECH = "Sintesi vocale",
    ALERT_SOUND = "Suono di avviso",
    ENABLE_REMINDER = "Attiva promemoria per %s",
    DUPLICATE_SOUND_EFFECTS = "Raddoppia i suoni senza sintesi vocale",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "Riproduce due copie simultanee di ogni effetto sonoro di avviso per aumentarne il volume. La sintesi vocale viene riprodotta una volta per avviso.",
    DECIMAL_SEPARATOR = ",",

    SHADOW_DANCE = "Danza dell'Ombra",
    SHADOW_BLADES = "Lame d'Ombra",
    SHADOW_DANCE_TOOLTIP = "Riproduce un avviso quando termina l'effetto di %s mentre quello di %s è ancora attivo.",

    IMPROVED_GARROTE = "Garrota Migliorata",
    GARROTE = "Garrota",
    IMPROVED_GARROTE_TOOLTIP = "Riproduce un avviso prima che termini il beneficio di %s."
        .. " Le opzioni di sintesi vocale usano i nomi localizzati di %s (predefinito) e %s.",
    IMPROVED_GARROTE_LEAD_TIME = "Secondi prima della scadenza",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "Imposta quanti secondi prima della scadenza di %s viene riprodotto l'avviso.",

    ROLL_THE_BONES = "Roulette Assassina",
    LOADED_DICE = "Giochi Truccati",
    ROLL_THE_BONES_TOOLTIP = "Avvisa quando %s è disponibile e al beneficio restano 2 secondi."
        .. " All'ingresso in combattimento o al termine della ricarica, avvisa se l'abilità è disponibile e non hai un risultato attivo, ne hai uno di livello 1 o ne hai uno di livello 2 con %s attivo.",
    ROLL_THE_BONES_CAST_SOUND = "Suono di lancio di %s",
    ROLL_THE_BONES_TTS = "Tira i dadi",

    KEEP_IT_ROLLING = "Roulette Eterna",
    KEEP_IT_ROLLING_TOOLTIP = "Avvisa quando %s termina la ricarica con un risultato di %s di livello 3 o superiore,"
        .. " o quando ottieni un nuovo risultato di livello 3 o superiore con l'abilità disponibile.",
    KEEP_IT_ROLLING_TTS = "Jackpot",
    UNDERMINE = "Cavafonda",
    UNDERMINE_JACKPOT_SOUND = "Jackpot di %s",

    PREPARATION = "Preparazione",
    ADRENALINE_RUSH = "Scarica d'Adrenalina",
    KILLING_SPREE = "Furia Omicida",
    BLADE_RUSH = "Scatto Tagliente",
    PREPARATION_TOOLTIP = "Controlla i tempi di recupero dopo l'uso di %s, %s o %s."
        .. " Avvisa se %s è disponibile e tutte e tre le abilità sono in ricarica.",
})
