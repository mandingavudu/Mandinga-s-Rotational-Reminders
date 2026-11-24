local addonName, addon = ...

local TEXT_TO_SPEECH = Enum.CooldownViewerSound.TextToSpeech
local isPortuguese = GetLocale() == "ptBR"
local textToSpeechLabel = COOLDOWN_VIEWER_SETTINGS_ALERT_LABEL_SOUND_TYPE_TEXT_TO_SPEECH or TEXT_TO_SPEECH_LABEL
    or (isPortuguese and "Texto em Fala" or "Text-to-Speech")

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
    local spellName = addon.GetReminderSpellName(reminder.spellID) or reminder.fallbackName
    local enabledLabel = (isPortuguese and "Ativar lembrete de %s" or "Enable %s reminder"):format(spellName)
    local enabledSetting = Settings.RegisterAddOnSetting(category, variable .. "_ENABLED",
        enabledKey, settings, Settings.VarType.Boolean, enabledLabel, true)
    local enabledControl = Settings.CreateCheckbox(category, enabledSetting, reminder.tooltip)
    enabledSetting:SetValueChangedCallback(reminder.refreshTracking)

    local soundLabel = isPortuguese and "Som do aviso" or "Alert sound"
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

local function RegisterImprovedGarroteTiming(category, enabledControl, enabledSetting)
    local minLead, maxLead, defaultLead = 0.5, 5, 1.5
    local settings = addon.settings
    local lead = settings.improvedGarroteLeadTime
    if type(lead) ~= "number" or not (lead >= minLead and lead <= maxLead) then
        settings.improvedGarroteLeadTime = defaultLead
    end

    local label = isPortuguese and "Tempo de antecedência" or "Seconds before expiration"
    local tooltip = isPortuguese
        and "Define quantos segundos antes do fim de Garrote Aprimorado o aviso toca."
        or "Sets how many seconds before Improved Garrote expires the alert plays."
    local setting = Settings.RegisterAddOnSetting(category, addonName .. "_IMPROVED_GARROTE_LEAD_TIME",
        "improvedGarroteLeadTime", settings, Settings.VarType.Number, label, defaultLead)

    local options = Settings.CreateSliderOptions(minLead, maxLead, 0.1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
        local seconds = ("%.1f s"):format(value)
        return isPortuguese and (seconds:gsub("%.", ",")) or seconds
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
    RegisterReminder(category, {
        key = "shadowDance",
        variable = "SHADOW_DANCE",
        spellID = addon.shadowDanceSpellID,
        fallbackName = isPortuguese and "Dança das Sombras" or "Shadow Dance",
        tooltip = isPortuguese
            and "Toca um aviso quando Dança das Sombras termina e o efeito de Lâminas Sombrias permanece ativo."
            or "Plays an alert when Shadow Dance ends while Shadow Blades is still active.",
        refreshTracking = addon.RefreshShadowDanceTracking,
    })
    local _, assassinationName = GetSpecializationInfoForSpecID(259)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(assassinationName))
    local garroteEnabledControl, garroteEnabledSetting = RegisterReminder(category, {
        key = "improvedGarrote",
        variable = "IMPROVED_GARROTE",
        spellID = addon.improvedGarroteSpellID,
        alternateTTSSound = addon.GARROTE_TTS,
        fallbackName = isPortuguese and "Garrote Aprimorado" or "Improved Garrote",
        tooltip = isPortuguese
            and "Toca um aviso antes de terminar o efeito de Garrote Aprimorado."
                .. " As opções de texto em fala (TTS) usam os nomes localizados de Garrote Aprimorado (padrão) e Garrote."
            or "Plays an alert before your Improved Garrote buff expires."
                .. " The text-to-speech (TTS) options use the localized names of Improved Garrote (default) and Garrote.",
        refreshTracking = addon.RefreshImprovedGarroteTracking,
    })
    RegisterImprovedGarroteTiming(category, garroteEnabledControl, garroteEnabledSetting)

    local _, outlawName = GetSpecializationInfoForSpecID(260)
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(outlawName))
    RegisterReminder(category, {
        key = "rollTheBones",
        variable = "ROLL_THE_BONES",
        spellID = addon.rollTheBonesSpellID,
        fallbackName = isPortuguese and "Golpe de Sorte" or "Roll the Bones",
        customSound = addon.ROLL_THE_BONES_CAST_SOUND,
        customSoundLabel = isPortuguese and "Som de Golpe de Sorte" or "Roll the Bones cast sound",
        alternateTTSSound = addon.ROLL_THE_BONES_TTS,
        tooltip = isPortuguese
            and "Avisa quando a habilidade está pronta e faltam 2 segundos para o efeito terminar. Ao entrar em combate ou ao terminar a recarga, avisa se a habilidade estiver pronta e você estiver sem efeito ativo, no estágio 1 ou no estágio 2 com o bônus de Dados Viciados ativo."
            or "Alerts when Roll the Bones is ready and the buff has 2 seconds remaining. On combat entry or recharge, it alerts if the spell is ready and you have no active roll, a stage 1 roll, or a stage 2 roll with Loaded Dice active.",
        refreshTracking = addon.RefreshCooldownReminderTracking,
    })
    RegisterReminder(category, {
        key = "keepItRolling",
        variable = "KEEP_IT_ROLLING",
        spellID = addon.keepItRollingSpellID,
        fallbackName = isPortuguese and "Sorte Grande" or "Keep It Rolling",
        customSound = addon.JACKPOT_SOUND,
        customSoundLabel = isPortuguese and "Jackpot da Inframina" or "Undermine Jackpot",
        alternateTTSSound = addon.KEEP_IT_ROLLING_TTS,
        tooltip = isPortuguese
            and "Avisa quando a recarga acaba com um resultado de Golpe de Sorte no estágio 3 ou superior, ou quando você obtém um resultado nesses estágios com Sorte Grande pronta."
            or "Alerts when Keep It Rolling finishes recharging with a stage 3 or higher roll, or when a new roll of stage 3 or higher is applied while Keep It Rolling is ready.",
        refreshTracking = addon.RefreshCooldownReminderTracking,
    })
    RegisterReminder(category, {
        key = "preparation",
        variable = "PREPARATION",
        spellID = addon.preparationSpellID,
        fallbackName = isPortuguese and "Preparação" or "Preparation",
        tooltip = isPortuguese
            and ("Verifica as recargas após você usar %s, %s ou %s. Avisa se Preparação estiver pronta e as três habilidades estiverem em recarga."):format(
                addon.GetReminderSpellName(13750) or "Adrenalina",
                addon.GetReminderSpellName(51690) or "Matança",
                addon.GetReminderSpellName(271877) or "Ímpeto da Lâmina")
            or "Checks after casting Adrenaline Rush, Killing Spree, or Blade Rush. Alerts if Preparation is ready and all three spells are on cooldown.",
        refreshTracking = addon.RefreshCooldownReminderTracking,
    })

    Settings.RegisterAddOnCategory(category)
end

local function RegisterOptions()
    if type(MandingasRotationalRemindersDB) ~= "table" then
        MandingasRotationalRemindersDB = {}
    end
    addon.settings = MandingasRotationalRemindersDB

    local category, layout = Settings.RegisterVerticalLayoutCategory("Mandinga's Rotational Reminders")
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(AUDIO_LABEL))
    local settings = addon.settings
    if type(settings.duplicateSoundEffects) ~= "boolean" then
        settings.duplicateSoundEffects = true
    end
    local duplicateLabel = isPortuguese and "Duplicar sons sem TTS" or "Duplicate non-TTS sounds"
    local duplicateTooltip = isPortuguese
        and "Toca duas cópias simultâneas do efeito sonoro de cada aviso para aumentar o volume. O texto em fala toca uma vez por aviso."
        or "Plays two simultaneous copies of each alert sound effect for extra volume. Text-to-speech plays once per alert."
    local duplicateSetting = Settings.RegisterAddOnSetting(category, addonName .. "_DUPLICATE_SOUND_EFFECTS",
        "duplicateSoundEffects", settings, Settings.VarType.Boolean, duplicateLabel, true)
    Settings.CreateCheckbox(category, duplicateSetting, duplicateTooltip)

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
