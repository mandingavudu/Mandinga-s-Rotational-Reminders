local addonName, addon = ...

local L = addon.L
local TEXT_TO_SPEECH = Enum.CooldownViewerSound.TextToSpeech
local textToSpeechLabel = COOLDOWN_VIEWER_SETTINGS_ALERT_LABEL_SOUND_TYPE_TEXT_TO_SPEECH or TEXT_TO_SPEECH_LABEL
    or L.TEXT_TO_SPEECH
local soundLabel = COOLDOWN_VIEWER_SETTINGS_ALERT_TYPE_SOUND or L.ALERT_SOUND

local function GetSettingsSpellName(spellID, fallbackName)
    return addon.GetReminderSpellName(spellID) or fallbackName
end

local function RegisterReminder(category, reminder)
    local settings = addon.settings
    local enabledKey = reminder.key .. "Enabled"
    local soundKey = reminder.key .. "Sound"
    local variable = addonName .. "_" .. reminder.variable
    if type(settings[enabledKey]) ~= "boolean" then
        settings[enabledKey] = true
    end
    if type(settings[soundKey]) ~= "number" then
        settings[soundKey] = TEXT_TO_SPEECH
    end
    local spellName = reminder.spellName
    local enabledLabel = L.ENABLE_REMINDER:format(spellName)
    local enabledSetting = Settings.RegisterAddOnSetting(category, variable .. "_ENABLED",
        enabledKey, settings, Settings.VarType.Boolean, enabledLabel, true)
    local enabledControl = Settings.CreateCheckbox(category, enabledSetting, reminder.tooltip)
    enabledSetting:SetValueChangedCallback(reminder.refreshTracking)

    local customSound = reminder.customSound
    local alternateTTSSound = reminder.alternateTTSSound
    local fullTTSLabel = alternateTTSSound and ("%s (%s)"):format(textToSpeechLabel, spellName) or textToSpeechLabel
    local soundSetting = Settings.RegisterAddOnSetting(category, variable .. "_SOUND",
        soundKey, settings, Settings.VarType.Number, soundLabel, TEXT_TO_SPEECH)
    local soundControl = Settings.CreateDropdown(category, soundSetting, function()
        return {}
    end)
    soundControl:Indent()
    soundControl:SetParentInitializer(enabledControl, function()
        return enabledSetting:GetValue()
    end)

    local function IsSelected(sound)
        local selected = soundSetting:GetValue()
        if selected == TEXT_TO_SPEECH or (customSound and selected == customSound)
            or (alternateTTSSound and selected == alternateTTSSound)
            or (CooldownViewerUtil and CooldownViewerUtil.GetSoundTypeText(selected)) then
            return selected == sound
        end
        return sound == TEXT_TO_SPEECH
    end

    local function SetSelected(sound)
        soundSetting:SetValue(sound)
    end

    soundControl.customOptionHandler = function(rootDescription)
        local function AddCustomSound(label, sound)
            local radio = rootDescription:CreateRadio(label, IsSelected, SetSelected, sound)
            if CooldownViewerAlert_SetupTypeButton then
                radio:AddInitializer(function(button)
                    local preview = MenuTemplates.AttachUtilityButton(button)
                    preview.Texture:Hide()
                    CooldownViewerAlert_SetupTypeButton(preview, Enum.CooldownViewerAlertType.Sound)
                    MenuTemplates.SetUtilityButtonAnchor(preview, MenuVariants.GearButtonAnchor, button, 0, 0)
                    MenuTemplates.SetUtilityButtonTooltipText(preview, COOLDOWN_VIEWER_SETTINGS_ALERT_MENU_PLAY_SAMPLE)
                    MenuTemplates.SetUtilityButtonClickHandler(preview, function()
                        addon.PlayReminderSound(sound, reminder.spellID, Enum.CooldownViewerAlertEventType.Available)
                    end)
                end)
            end
        end

        local useHighlightStyle = false
        if CooldownViewerUtil then
            local function CreateRadio(...)
                return rootDescription:CreateRadio(...)
            end
            CooldownViewerUtil.AddSoundAlertRadio({
                text = fullTTSLabel,
                soundEnum = TEXT_TO_SPEECH,
                spellName = spellName,
            }, CreateRadio, IsSelected, SetSelected, useHighlightStyle)
        else
            rootDescription:CreateRadio(fullTTSLabel, IsSelected, SetSelected, TEXT_TO_SPEECH)
        end
        local alternateText = alternateTTSSound and addon.GetReminderTTSText(alternateTTSSound)
        if alternateText then
            AddCustomSound(("%s (%s)"):format(textToSpeechLabel, alternateText), alternateTTSSound)
        end
        if customSound then
            AddCustomSound(reminder.customSoundLabel, customSound)
        end
        if CooldownViewerUtil then
            CooldownViewerUtil.BuildSoundMenus(rootDescription, IsSelected, SetSelected, useHighlightStyle)
        end
    end
    return enabledControl, enabledSetting
end

local function RegisterImprovedGarroteTiming(category, enabledControl, enabledSetting, spellName)
    local minLead, maxLead, defaultLead = 0.5, 5, 1.5
    local settings = addon.settings
    local lead = settings.improvedGarroteLeadTime
    if type(lead) ~= "number" or not (lead >= minLead and lead <= maxLead) then
        settings.improvedGarroteLeadTime = defaultLead
    end

    local tooltip = L.IMPROVED_GARROTE_LEAD_TIME_TOOLTIP:format(spellName)
    local setting = Settings.RegisterAddOnSetting(category, addonName .. "_IMPROVED_GARROTE_LEAD_TIME",
        "improvedGarroteLeadTime", settings, Settings.VarType.Number, L.IMPROVED_GARROTE_LEAD_TIME, defaultLead)

    local options = Settings.CreateSliderOptions(minLead, maxLead, 0.1)
    local decimalSeparator = DECIMAL_SEPERATOR or L.DECIMAL_SEPARATOR
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
        return (("%.1f s"):format(value):gsub("[.,]", decimalSeparator))
    end)
    local control = Settings.CreateSlider(category, setting, options, tooltip)
    control:Indent()
    control:SetParentInitializer(enabledControl, function()
        return enabledSetting:GetValue()
    end)
end

local function RegisterRogueOptions(parentCategory)
    local category, layout = Settings.RegisterVerticalLayoutSubcategory(parentCategory, LOCALIZED_CLASS_NAMES_MALE.ROGUE)
    local _, subtletyName = GetSpecializationInfoForSpecID(261)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(subtletyName))
    local shadowDanceName = GetSettingsSpellName(addon.shadowDanceSpellID, L.SHADOW_DANCE)
    local shadowBladesName = GetSettingsSpellName(addon.shadowBladesSpellID, L.SHADOW_BLADES)
    RegisterReminder(category, {
        key = "shadowDance",
        variable = "SHADOW_DANCE",
        spellID = addon.shadowDanceSpellID,
        spellName = shadowDanceName,
        tooltip = L.SHADOW_DANCE_TOOLTIP:format(shadowDanceName, shadowBladesName),
        refreshTracking = addon.RefreshShadowDanceTracking,
    })
    local _, assassinationName = GetSpecializationInfoForSpecID(259)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(assassinationName))
    local improvedGarroteName = GetSettingsSpellName(addon.improvedGarroteSpellID, L.IMPROVED_GARROTE)
    local garroteName = GetSettingsSpellName(addon.garroteSpellID, L.GARROTE)
    local garroteEnabledControl, garroteEnabledSetting = RegisterReminder(category, {
        key = "improvedGarrote",
        variable = "IMPROVED_GARROTE",
        spellID = addon.improvedGarroteSpellID,
        alternateTTSSound = addon.GARROTE_TTS,
        spellName = improvedGarroteName,
        tooltip = L.IMPROVED_GARROTE_TOOLTIP:format(improvedGarroteName, improvedGarroteName, garroteName),
        refreshTracking = addon.RefreshImprovedGarroteTracking,
    })
    RegisterImprovedGarroteTiming(category, garroteEnabledControl, garroteEnabledSetting, improvedGarroteName)

    local _, outlawName = GetSpecializationInfoForSpecID(260)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(outlawName))
    local rollTheBonesName = GetSettingsSpellName(addon.rollTheBonesSpellID, L.ROLL_THE_BONES)
    local loadedDiceName = GetSettingsSpellName(addon.loadedDiceSpellID, L.LOADED_DICE)
    RegisterReminder(category, {
        key = "rollTheBones",
        variable = "ROLL_THE_BONES",
        spellID = addon.rollTheBonesSpellID,
        spellName = rollTheBonesName,
        customSound = addon.ROLL_THE_BONES_CAST_SOUND,
        customSoundLabel = L.ROLL_THE_BONES_CAST_SOUND:format(rollTheBonesName),
        alternateTTSSound = addon.ROLL_THE_BONES_TTS,
        tooltip = L.ROLL_THE_BONES_TOOLTIP:format(rollTheBonesName, loadedDiceName),
        refreshTracking = addon.RefreshCooldownReminderTracking,
    })
    local keepItRollingName = GetSettingsSpellName(addon.keepItRollingSpellID, L.KEEP_IT_ROLLING)
    local undermine = C_Map.GetMapInfo(2346)
    local undermineName = undermine and undermine.name or L.UNDERMINE
    RegisterReminder(category, {
        key = "keepItRolling",
        variable = "KEEP_IT_ROLLING",
        spellID = addon.keepItRollingSpellID,
        spellName = keepItRollingName,
        customSound = addon.JACKPOT_SOUND,
        customSoundLabel = L.UNDERMINE_JACKPOT_SOUND:format(undermineName),
        alternateTTSSound = addon.KEEP_IT_ROLLING_TTS,
        tooltip = L.KEEP_IT_ROLLING_TOOLTIP:format(keepItRollingName, rollTheBonesName),
        refreshTracking = addon.RefreshCooldownReminderTracking,
    })
    local preparationName = GetSettingsSpellName(addon.preparationSpellID, L.PREPARATION)
    local preparationCooldowns = addon.preparationCooldownSpellIDs
    RegisterReminder(category, {
        key = "preparation",
        variable = "PREPARATION",
        spellID = addon.preparationSpellID,
        spellName = preparationName,
        tooltip = L.PREPARATION_TOOLTIP:format(
            GetSettingsSpellName(preparationCooldowns[1], L.ADRENALINE_RUSH),
            GetSettingsSpellName(preparationCooldowns[2], L.KILLING_SPREE),
            GetSettingsSpellName(preparationCooldowns[3], L.BLADE_RUSH),
            preparationName),
        refreshTracking = addon.RefreshCooldownReminderTracking,
    })

    Settings.RegisterAddOnCategory(category)
end

local function RegisterOptions()
    if type(MandingasRotationalRemindersDB) ~= "table" then
        MandingasRotationalRemindersDB = {}
    end
    addon.settings = MandingasRotationalRemindersDB

    local title = C_AddOns.GetAddOnMetadata(addonName, "Title") or addonName
    local category, layout = Settings.RegisterVerticalLayoutCategory(title)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(AUDIO_LABEL))
    local settings = addon.settings
    if type(settings.duplicateSoundEffects) ~= "boolean" then
        settings.duplicateSoundEffects = true
    end
    local duplicateSetting = Settings.RegisterAddOnSetting(category, addonName .. "_DUPLICATE_SOUND_EFFECTS",
        "duplicateSoundEffects", settings, Settings.VarType.Boolean, L.DUPLICATE_SOUND_EFFECTS, true)
    Settings.CreateCheckbox(category, duplicateSetting, L.DUPLICATE_SOUND_EFFECTS_TOOLTIP)

    Settings.RegisterAddOnCategory(category)
    RegisterRogueOptions(category)

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
