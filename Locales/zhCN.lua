local _, addon = ...

addon:RegisterLocale("zhCN", {
    TEXT_TO_SPEECH = "文本转语音",
    ALERT_SOUND = "提醒音效",
    ENABLE_REMINDER = "启用%s提醒",
    DUPLICATE_SOUND_EFFECTS = "叠加播放非语音音效",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "同时播放两份提醒音效以提高音量。每次提醒只播放一次文本转语音。",
    DECIMAL_SEPARATOR = ".",

    SHADOW_DANCE = "暗影之舞",
    SHADOW_BLADES = "暗影之刃",
    SHADOW_DANCE_TOOLTIP = "%s结束时，如果%s仍然有效，则播放提醒。",

    IMPROVED_GARROTE = "强化锁喉",
    GARROTE = "锁喉",
    IMPROVED_GARROTE_TOOLTIP = "在%s增益效果结束前播放提醒。"
        .. "文本转语音可朗读本地化的%s（默认）或%s技能名称。",
    IMPROVED_GARROTE_LEAD_TIME = "结束前提醒（秒）",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "设置在%s结束前多少秒播放提醒。",

    ROLL_THE_BONES = "命运骨骰",
    LOADED_DICE = "灌铅骰子",
    ROLL_THE_BONES_TOOLTIP = "%s可用且增益效果剩余2秒时播放提醒。"
        .. "进入战斗或充能结束时，如果技能可用，也会在没有生效的掷骰结果、结果为1级或结果为2级且%s生效的情况下播放提醒。",
    ROLL_THE_BONES_CAST_SOUND = "%s施放音效",
    ROLL_THE_BONES_TTS = "掷骰子",

    KEEP_IT_ROLLING = "时运继延",
    KEEP_IT_ROLLING_TOOLTIP = "%s充能结束时，如果%s的3级或更高级结果仍然有效，则播放提醒。"
        .. "如果技能已可用，掷出新的3级或更高级结果时也会播放提醒。",
    KEEP_IT_ROLLING_TTS = "头奖",
    UNDERMINE = "安德麦",
    UNDERMINE_JACKPOT_SOUND = "%s头奖音效",

    PREPARATION = "伺机待发",
    ADRENALINE_RUSH = "冲动",
    KILLING_SPREE = "影舞步",
    BLADE_RUSH = "刀锋冲刺",
    PREPARATION_TOOLTIP = "使用%s、%s或%s后检查冷却时间。"
        .. "如果%s可用且三个技能都在冷却中，则播放提醒。",
})
