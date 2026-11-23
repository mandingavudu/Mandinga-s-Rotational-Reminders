local _, addon = ...

local CDM_SOUND_SUBTYPE = "Gameplay SFX"
local TEXT_TO_SPEECH = Enum.CooldownViewerSound.TextToSpeech

function addon.GetReminderSpellName(spellID)
    local name = C_Spell.GetSpellName(spellID)
    if not issecretvalue(name) and name and name ~= "" then
        return name
    end
end

function addon.PlayReminderSound(sound, spellID, alertEvent)
    if sound ~= TEXT_TO_SPEECH and CooldownViewerUtil then
        local soundKit = CooldownViewerUtil.GetSoundTypeSoundKit(sound)
        if soundKit then
            C_Sound.PlaySoundWithOptions({ soundKitID = soundKit, uiSoundSubType = CDM_SOUND_SUBTYPE })
            return
        end
    end

    local name = addon.GetReminderSpellName(spellID)
    if not name then
        return
    end

    if CooldownViewerAlert_PlayAlert then
        local alert = CooldownViewerAlert_Create(Enum.CooldownViewerAlertType.Sound, alertEvent, TEXT_TO_SPEECH)
        CooldownViewerAlert_PlayAlert(nil, name, alert, CDM_SOUND_SUBTYPE)
        return
    end

    local voice = TextToSpeech_GetSelectedVoice and TextToSpeech_GetSelectedVoice(Enum.TtsVoiceType.Standard)
    if voice then
        C_VoiceChat.SpeakText(voice.voiceID, name, C_TTSSettings.GetSpeechRate(), C_TTSSettings.GetSpeechVolume(), true)
    end
end
