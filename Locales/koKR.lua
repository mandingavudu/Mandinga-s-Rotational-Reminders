local _, addon = ...

addon:RegisterLocale("koKR", {
    TEXT_TO_SPEECH = "텍스트 음성 변환",
    ALERT_SOUND = "경고음",
    ENABLE_REMINDER = "%s 알림 사용",
    DUPLICATE_SOUND_EFFECTS = "음성 안내 외 경고음 겹쳐 재생",
    DUPLICATE_SOUND_EFFECTS_TOOLTIP = "각 경고음을 동시에 두 번 재생하여 소리를 키웁니다. 텍스트 음성 변환은 알림당 한 번만 재생됩니다.",
    DECIMAL_SEPARATOR = ".",

    SHADOW_DANCE = "어둠의 춤",
    SHADOW_BLADES = "어둠의 칼날",
    SHADOW_DANCE_TOOLTIP = "%s 효과가 끝날 때 %s 효과가 아직 활성화되어 있으면 알립니다.",

    IMPROVED_GARROTE = "목조르기 연마",
    GARROTE = "목조르기",
    IMPROVED_GARROTE_TOOLTIP = "%s 강화 효과가 끝나기 전에 알립니다."
        .. " 음성 안내는 현재 언어의 %s(기본값) 또는 %s 이름을 읽습니다.",
    IMPROVED_GARROTE_LEAD_TIME = "효과 종료 전 알림 시간(초)",
    IMPROVED_GARROTE_LEAD_TIME_TOOLTIP = "%s 효과가 끝나기 몇 초 전에 알릴지 설정합니다.",

    ROLL_THE_BONES = "뼈주사위",
    LOADED_DICE = "납 주사위",
    ROLL_THE_BONES_TOOLTIP = "%s 사용이 가능하고 강화 효과가 2초 남았을 때 알립니다."
        .. " 전투를 시작하거나 재충전이 끝났을 때, 기술을 사용할 수 있고 활성화된 주사위 결과가 없거나 1단계 결과가 활성화되어 있거나 %s 효과와 2단계 결과가 함께 활성화되어 있으면 알립니다.",
    ROLL_THE_BONES_CAST_SOUND = "%s 시전 소리",
    ROLL_THE_BONES_TTS = "주사위를 굴려",

    KEEP_IT_ROLLING = "도박의 연속",
    KEEP_IT_ROLLING_TOOLTIP = "%s의 재충전이 끝났을 때 %s의 3단계 이상 결과가 활성화되어 있으면 알립니다."
        .. " 기술을 사용할 수 있는 상태에서 새로 3단계 이상 결과를 얻어도 알립니다.",
    KEEP_IT_ROLLING_TTS = "횡재",
    UNDERMINE = "언더마인",
    UNDERMINE_JACKPOT_SOUND = "%s 횡재 효과음",

    PREPARATION = "마음가짐",
    ADRENALINE_RUSH = "아드레날린 촉진",
    KILLING_SPREE = "광기의 학살자",
    BLADE_RUSH = "질풍 칼날",
    PREPARATION_TOOLTIP = "%s, %s, %s 중 하나를 사용하면 재사용 대기시간을 확인합니다."
        .. " %s 사용이 가능하고 세 기술 모두 재사용 대기 중이면 알립니다.",
})
