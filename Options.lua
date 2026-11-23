local addonName, addon = ...

local TEXT_TO_SPEECH = Enum.CooldownViewerSound.TextToSpeech
local isPortuguese = GetLocale() == "ptBR"
local textToSpeechLabel = COOLDOWN_VIEWER_SETTINGS_ALERT_LABEL_SOUND_TYPE_TEXT_TO_SPEECH or TEXT_TO_SPEECH_LABEL
    or (isPortuguese and "Síntese de voz" or "Text-to-Speech")

local function RegisterOptions()
    if type(MandingasRotationalRemindersDB) ~= "table" then
        MandingasRotationalRemindersDB = {}
    end
    local settings = MandingasRotationalRemindersDB
    if type(settings.shadowDanceEnabled) ~= "boolean" then
        settings.shadowDanceEnabled = true
    end
    if type(settings.shadowDanceSound) ~= "number" then
        settings.shadowDanceSound = TEXT_TO_SPEECH
    end
    addon.settings = settings

    local category, layout = Settings.RegisterVerticalLayoutCategory("Mandinga's Rotational Reminders")
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(
        isPortuguese and "Ladino de Subterfúgio" or "Subtlety Rogue"))

    local spellName = addon.GetShadowDanceName() or (isPortuguese and "Dança das Sombras" or "Shadow Dance")
    local enabledLabel = (isPortuguese and "Ativar lembrete de %s" or "Enable %s reminder"):format(spellName)
    local enabledSetting = Settings.RegisterAddOnSetting(category, addonName .. "_SHADOW_DANCE_ENABLED",
        "shadowDanceEnabled", settings, Settings.VarType.Boolean, enabledLabel, true)
    local enabledTooltip = isPortuguese
        and "Toca um aviso quando Dança das Sombras termina e o efeito de Lâminas Sombrias permanece ativo."
        or "Plays an alert when Shadow Dance ends while Shadow Blades is still active."
    local enabledControl = Settings.CreateCheckbox(category, enabledSetting, enabledTooltip)
    enabledSetting:SetValueChangedCallback(addon.RefreshShadowDanceTracking)

    local soundLabel = isPortuguese and "Som do aviso" or "Alert sound"
    local soundSetting = Settings.RegisterAddOnSetting(category, addonName .. "_SHADOW_DANCE_SOUND",
        "shadowDanceSound", settings, Settings.VarType.Number, soundLabel, TEXT_TO_SPEECH)
    local soundControl = Settings.CreateDropdown(category, soundSetting, function()
        return {}
    end)
    soundControl:Indent()
    soundControl:SetParentInitializer(enabledControl, function()
        return enabledSetting:GetValue()
    end)

    local function IsSelected(sound)
        local selected = soundSetting:GetValue()
        if selected ~= TEXT_TO_SPEECH and CooldownViewerUtil and CooldownViewerUtil.GetSoundTypeText(selected) then
            return selected == sound
        end
        return sound == TEXT_TO_SPEECH
    end

    local function SetSelected(sound)
        soundSetting:SetValue(sound)
    end

    soundControl.customOptionHandler = function(rootDescription)
        if not CooldownViewerUtil then
            rootDescription:CreateRadio(textToSpeechLabel, IsSelected, SetSelected, TEXT_TO_SPEECH)
            return
        end

        local function CreateRadio(...)
            return rootDescription:CreateRadio(...)
        end
        local useHighlightStyle = false
        CooldownViewerUtil.AddSoundAlertRadio({
            text = textToSpeechLabel,
            soundEnum = TEXT_TO_SPEECH,
            spellName = addon.GetShadowDanceName(),
        }, CreateRadio, IsSelected, SetSelected, useHighlightStyle)
        CooldownViewerUtil.BuildSoundMenus(rootDescription, IsSelected, SetSelected, useHighlightStyle)
    end

    Settings.RegisterAddOnCategory(category)
    SLASH_MANDINGASROTATIONALREMINDERS1 = "/mrr"
    SlashCmdList.MANDINGASROTATIONALREMINDERS = function()
        Settings.OpenToCategory(category:GetID())
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("ADDON_LOADED")
events:SetScript("OnEvent", function(self, _, loadedAddon)
    if loadedAddon == addonName then
        self:UnregisterEvent("ADDON_LOADED")
        RegisterOptions()
    end
end)
