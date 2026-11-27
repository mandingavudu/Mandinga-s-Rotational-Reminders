local _, addon = ...

addon:RegisterLocale("zhTW", {
    TEXT_TO_SPEECH = "文字轉語音",
    ALERT_SOUND = "提醒音效",
    ENABLE_REMINDER = "啟用%s提醒",
    DUPLICATE_SOUND_EFFECTS = "疊加播放非語音音效",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "同時播放兩份提醒音效以提高音量。每次提醒只播放一次文字轉語音。",
    DECIMAL_SEPARATOR = ".",

    SHADOW_DANCE = "暗影之舞",
    SHADOW_BLADES = "暗影之刃",
    SHADOW_DANCE_TOOLTIP = "%s結束時，如果%s仍然有效，就會播放提醒。",

    IMPROVED_GARROTE = "強化絞喉",
    GARROTE = "絞喉",
    IMPROVED_GARROTE_TOOLTIP = "在%s增益效果結束前播放提醒。"
        .. "文字轉語音可朗讀本地化的%s（預設）或%s技能名稱。",
    IMPROVED_GARROTE_LEAD_TIME = "結束前提醒（秒）",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "設定在%s結束前幾秒播放提醒。",

    ROLL_THE_BONES = "命運之骰",
    LOADED_DICE = "灌鉛骰子",
    ROLL_THE_BONES_TOOLTIP = "%s可用且增益效果剩下2秒時播放提醒。"
        .. "進入戰鬥或充能結束時，如果技能可用，且目前沒有擲骰結果、結果為第1階段，或結果為第2階段且%s有效，也會播放提醒。",
    ROLL_THE_BONES_CAST_SOUND = "%s施放音效",
    ROLL_THE_BONES_TTS = "擲骰子",

    KEEP_IT_ROLLING = "骰個不停",
    KEEP_IT_ROLLING_TOOLTIP = "%s充能結束時，如果%s的第3階段或更高階段結果仍然有效，就會播放提醒。"
        .. "若技能已可用，擲出新的第3階段或更高階段結果時也會播放提醒。",
    KEEP_IT_ROLLING_TTS = "中大獎",
    UNDERMINE = "幽坑城",
    UNDERMINE_JACKPOT_SOUND = "%s中大獎音效",

    PREPARATION = "備戰",
    ADRENALINE_RUSH = "能量刺激",
    KILLING_SPREE = "狂舞殘殺",
    BLADE_RUSH = "劍刃猛攻",
    PREPARATION_TOOLTIP = "使用%s、%s或%s後檢查冷卻時間。"
        .. "如果%s可用，而且三個技能都在冷卻中，就會播放提醒。",
})
