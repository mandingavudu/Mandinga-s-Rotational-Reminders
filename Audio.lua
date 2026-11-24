local _, addon = ...

local CDM_SOUND_SUBTYPE = "Gameplay SFX"
local TEXT_TO_SPEECH = Enum.CooldownViewerSound.TextToSpeech
local JACKPOT_SOUND_KIT_ID = 283499 -- Liberation of Undermine tier set proc
local ROLL_THE_BONES_SOUND_KIT_ID = 58682

addon.JACKPOT_SOUND = -1
addon.ROLL_THE_BONES_CAST_SOUND = -2

function addon.GetReminderSpellName(spellID)
    local name = C_Spell.GetSpellName(spellID)
    if not issecretvalue(name) and name and name ~= "" then
        return name
    end
end

function addon.PlayReminderSound(sound, spellID, alertEvent)
    local soundKit, volumeOverride
    if sound == addon.JACKPOT_SOUND then
        soundKit = JACKPOT_SOUND_KIT_ID
    elseif sound == addon.ROLL_THE_BONES_CAST_SOUND then
        soundKit = ROLL_THE_BONES_SOUND_KIT_ID
        volumeOverride = 1.0 -- The cast kit's base volume is about 0.5.
    elseif sound ~= TEXT_TO_SPEECH and CooldownViewerUtil then
        soundKit = CooldownViewerUtil.GetSoundTypeSoundKit(sound)
    end
    if soundKit then
        local options = {
            soundKitID = soundKit,
            uiSoundSubType = CDM_SOUND_SUBTYPE,
            volumeOverride = volumeOverride,
            forceNoDuplicates = false,
        }
        -- Mix a second instance into the same alert to boost its level on Gameplay SFX.
        if C_Sound.PlaySoundWithOptions(options) and addon.settings.duplicateSoundEffects then
            C_Sound.PlaySoundWithOptions(options)
        end
        return
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
