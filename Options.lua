local addonName, addon = ...

local TEXT_TO_SPEECH = Enum.CooldownViewerSound.TextToSpeech
local isPortuguese = GetLocale() == "ptBR"
local textToSpeechLabel = COOLDOWN_VIEWER_SETTINGS_ALERT_LABEL_SOUND_TYPE_TEXT_TO_SPEECH or TEXT_TO_SPEECH_LABEL
    or (isPortuguese and "Síntese de voz" or "Text-to-Speech")

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
            spellName = addon.GetReminderSpellName(reminder.spokenSpellID or reminder.spellID),
        }, CreateRadio, IsSelected, SetSelected, useHighlightStyle)
        CooldownViewerUtil.BuildSoundMenus(rootDescription, IsSelected, SetSelected, useHighlightStyle)
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

local function RegisterOptions()
    if type(MandingasRotationalRemindersDB) ~= "table" then
        MandingasRotationalRemindersDB = {}
    end
    addon.settings = MandingasRotationalRemindersDB

    local category, layout = Settings.RegisterVerticalLayoutCategory("Mandinga's Rotational Reminders")
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(
        isPortuguese and "Ladino de Subterfúgio" or "Subtlety Rogue"))
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
    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(
        isPortuguese and "Ladino de Assassinato" or "Assassination Rogue"))
    local garroteEnabledControl, garroteEnabledSetting = RegisterReminder(category, {
        key = "improvedGarrote",
        variable = "IMPROVED_GARROTE",
        spellID = addon.improvedGarroteSpellID,
        spokenSpellID = addon.garroteSpellID,
        fallbackName = isPortuguese and "Garrote Aprimorado" or "Improved Garrote",
        tooltip = isPortuguese
            and "Toca um aviso antes de terminar o efeito de Garrote Aprimorado."
                .. " A síntese de voz (TTS) usa o nome localizado da habilidade Garrote."
            or "Plays an alert before your Improved Garrote buff expires."
                .. " Text-to-speech (TTS) uses the localized name of the Garrote spell.",
        refreshTracking = addon.RefreshImprovedGarroteTracking,
    })
    RegisterImprovedGarroteTiming(category, garroteEnabledControl, garroteEnabledSetting)

    layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(
        isPortuguese and "Ladino Fora da Lei" or "Outlaw Rogue"))
    RegisterReminder(category, {
        key = "rollTheBones",
        variable = "ROLL_THE_BONES",
        spellID = addon.rollTheBonesSpellID,
        fallbackName = isPortuguese and "Rolar os Dados" or "Roll the Bones",
        tooltip = isPortuguese
            and "Toca um aviso quando faltam 2 segundos para o efeito terminar ou quando a recarga acaba com um resultado no estágio 1 ou no estágio 2 com Dados Viciados ativo."
            or "Alerts when the buff has 2 seconds remaining, or when Roll the Bones finishes recharging at stage 1 or at stage 2 with Loaded Dice active.",
        refreshTracking = addon.RefreshCooldownReminderTracking,
    })
    RegisterReminder(category, {
        key = "keepItRolling",
        variable = "KEEP_IT_ROLLING",
        spellID = addon.keepItRollingSpellID,
        fallbackName = "Keep It Rolling",
        tooltip = isPortuguese
            and "Toca um aviso quando a recarga acaba com um resultado no estágio 3 ou superior, ou quando um novo resultado nesse estágio é aplicado com a habilidade pronta."
            or "Alerts when Keep It Rolling finishes recharging with a stage 3 or higher roll, or when a new roll of stage 3 or higher is applied while Keep It Rolling is ready.",
        refreshTracking = addon.RefreshCooldownReminderTracking,
    })
    RegisterReminder(category, {
        key = "preparation",
        variable = "PREPARATION",
        spellID = addon.preparationSpellID,
        fallbackName = isPortuguese and "Preparação" or "Preparation",
        tooltip = isPortuguese
            and ("Verifica após usar %s, %s ou %s. Avisa se Preparação estiver pronta e as três habilidades estiverem em recarga."):format(
                addon.GetReminderSpellName(13750) or "Adrenaline Rush",
                addon.GetReminderSpellName(51690) or "Killing Spree",
                addon.GetReminderSpellName(271877) or "Blade Rush")
            or "Checks after casting Adrenaline Rush, Killing Spree, or Blade Rush. Alerts if Preparation is ready and all three spells are on cooldown.",
        refreshTracking = addon.RefreshCooldownReminderTracking,
    })

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
