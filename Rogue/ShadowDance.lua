local _, addon = ...

local SUBTLETY = 261
local SHADOW_DANCE = 185313
local SHADOW_DANCE_AURA = 185422
local SHADOW_BLADES = 121471
local CDM_SOUND_SUBTYPE = "Gameplay SFX"
local TEXT_TO_SPEECH = Enum.CooldownViewerSound.TextToSpeech

local viewerNames = { "BuffIconCooldownViewer", "BuffBarCooldownViewer" }
local hookedViewers = setmetatable({}, { __mode = "k" })
local hookedItems = setmetatable({}, { __mode = "k" })
local bindings = {}
local tracking = false
local needsDiscovery = true
local sampleQueued = false
local previousDance, previousBlades, previousFromViewer

local function GetTrackedSpell(spellID)
    if issecretvalue(spellID) then
        return
    end
    if spellID == SHADOW_DANCE or spellID == SHADOW_DANCE_AURA then
        return SHADOW_DANCE
    end
    if spellID == SHADOW_BLADES then
        return SHADOW_BLADES
    end
end

local function IdentifyItem(item)
    if item:IsForbidden() then
        return
    end

    local cooldownID = item:GetCooldownID()
    if issecretvalue(cooldownID) or type(cooldownID) ~= "number" then
        return
    end

    -- This is CDM configuration metadata. GetSpellID can resolve to a secret aura ID.
    local info = item:GetCooldownInfo()
    if issecretvalue(info) or type(info) ~= "table" then
        return
    end

    local spell = GetTrackedSpell(info.spellID) or GetTrackedSpell(info.overrideTooltipSpellID)
        or GetTrackedSpell(info.overrideSpellID)
    local linked = info.linkedSpellIDs
    if not spell and not issecretvalue(linked) and type(linked) == "table" then
        for _, spellID in ipairs(linked) do
            spell = GetTrackedSpell(spellID)
            if spell then
                break
            end
        end
    end
    return spell, cooldownID
end

local function ViewerIsTracking(viewer)
    if viewer:IsForbidden() then
        return false
    end
    local visible = viewer:IsVisible()
    return not issecretvalue(visible) and visible and not viewer:IsEditing()
end

local function ReadActivity(binding)
    local item = binding.item
    if not ViewerIsTracking(binding.viewer) or item:IsForbidden() then
        return
    end

    local cooldownID = item:GetCooldownID()
    if issecretvalue(cooldownID) or cooldownID ~= binding.cooldownID then
        return
    end
    local active = item:IsActive()
    if issecretvalue(active) or type(active) ~= "boolean" then
        return
    end
    if active then
        local unit = item:GetAuraDataUnit()
        if issecretvalue(unit) then
            return
        end
        return unit == "player"
    end
    return false
end

local function ReadTrackedSpell(spell)
    local binding = bindings[spell]
    if binding then
        local ok, active = pcall(ReadActivity, binding)
        if ok then
            return active
        end
    end
end

local function ReadPlayerAura(spellID)
    -- A secret aura can look absent in a spell-ID lookup.
    if C_Secrets.ShouldSpellAuraBeSecret(spellID) then
        return
    end
    local ok, aura = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellID)
    if ok and not issecretvalue(aura) then
        return type(aura) == "table"
    end
end

local function ReadShadowDance()
    local aura = ReadPlayerAura(SHADOW_DANCE_AURA)
    if aura == true then
        return true
    end
    local spell = ReadPlayerAura(SHADOW_DANCE)
    if spell == true then
        return true
    end
    if aura == false and spell == false then
        return false
    end
end

function addon.GetShadowDanceName()
    local name = C_Spell.GetSpellName(SHADOW_DANCE)
    if not issecretvalue(name) and name and name ~= "" then
        return name
    end
end

local function PlayDanceAlert()
    local sound = addon.settings.shadowDanceSound
    if sound ~= TEXT_TO_SPEECH and CooldownViewerUtil then
        local soundKit = CooldownViewerUtil.GetSoundTypeSoundKit(sound)
        if soundKit then
            C_Sound.PlaySoundWithOptions({ soundKitID = soundKit, uiSoundSubType = CDM_SOUND_SUBTYPE })
            return
        end
    end

    local name = addon.GetShadowDanceName()
    if name then
        if CooldownViewerAlert_PlayAlert then
            local alert = CooldownViewerAlert_Create(Enum.CooldownViewerAlertType.Sound,
                Enum.CooldownViewerAlertEventType.OnAuraRemoved, TEXT_TO_SPEECH)
            CooldownViewerAlert_PlayAlert(nil, name, alert, CDM_SOUND_SUBTYPE)
            return
        end

        local voice = TextToSpeech_GetSelectedVoice and TextToSpeech_GetSelectedVoice(Enum.TtsVoiceType.Standard)
        if voice then
            C_VoiceChat.SpeakText(voice.voiceID, name, C_TTSSettings.GetSpeechRate(), C_TTSSettings.GetSpeechVolume(), true)
            return
        end
    end

    C_Sound.PlaySoundWithOptions({ soundKitID = SOUNDKIT.RAID_WARNING, uiSoundSubType = CDM_SOUND_SUBTYPE })
end

local Update
local function QueueSample()
    if tracking and not sampleQueued then
        sampleQueued = true
        -- Both viewers may get the same aura update in either order.
        C_Timer.After(0, Update)
    end
end

local function InvalidateBindings()
    needsDiscovery = true
    if previousFromViewer then
        previousDance, previousBlades = nil, nil
    end
    QueueSample()
end

local function DiscoverViewer(viewer)
    if viewer:IsForbidden() then
        return
    end

    if not hookedViewers[viewer] and pcall(hooksecurefunc, viewer, "RefreshData", InvalidateBindings) then
        hookedViewers[viewer] = true
        pcall(viewer.HookScript, viewer, "OnHide", InvalidateBindings)
        pcall(viewer.HookScript, viewer, "OnShow", InvalidateBindings)
    end

    if not ViewerIsTracking(viewer) then
        return
    end

    -- The pool includes tracked entries that are hidden when their buff is inactive.
    for item in viewer.itemFramePool:EnumerateActive() do
        if not issecretvalue(item) then
            local ok, spell, cooldownID = pcall(IdentifyItem, item)
            if ok and spell and not bindings[spell] then
                bindings[spell] = { item = item, viewer = viewer, cooldownID = cooldownID }
                if not hookedItems[item] then
                    hookedItems[item] = pcall(hooksecurefunc, item, "OnActiveStateChanged", QueueSample) or nil
                end
            end
        end
    end
end

local function ReadViewerAuras()
    if needsDiscovery or not previousFromViewer then
        needsDiscovery = false
        bindings = {}
        for _, viewerName in ipairs(viewerNames) do
            local viewer = _G[viewerName]
            if not issecretvalue(viewer) and viewer then
                pcall(DiscoverViewer, viewer)
            end
        end
    end
    return ReadTrackedSpell(SHADOW_DANCE), ReadTrackedSpell(SHADOW_BLADES)
end

Update = function()
    sampleQueued = false
    if not tracking then
        return
    end

    local dance, blades = ReadShadowDance(), ReadPlayerAura(SHADOW_BLADES)
    local fromViewer = dance == nil or blades == nil
    if fromViewer then
        dance, blades = ReadViewerAuras()
    end

    -- A source change or a simultaneous Blades transition cannot confirm a reminder.
    local shouldAlert = previousFromViewer == fromViewer and previousDance == true and dance == false
        and previousBlades == true and blades == true
    previousDance, previousBlades, previousFromViewer = dance, blades, fromViewer
    if shouldAlert then
        PlayDanceAlert()
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
events:RegisterEvent("PLAYER_DEAD")
events:RegisterEvent("PLAYER_ALIVE")
events:RegisterEvent("PLAYER_UNGHOST")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
events:RegisterEvent("COOLDOWN_VIEWER_DATA_LOADED")

function addon.RefreshShadowDanceTracking()
    local _, class = UnitClass("player")
    local spec = class == "ROGUE" and GetSpecialization()
    local enabled = addon.settings and addon.settings.shadowDanceEnabled
    local shouldTrack = enabled and spec and GetSpecializationInfo(spec) == SUBTLETY and not UnitIsDeadOrGhost("player")
    if shouldTrack then
        events:RegisterUnitEvent("UNIT_AURA", "player")
    else
        events:UnregisterEvent("UNIT_AURA")
        bindings = {}
    end
    tracking = shouldTrack
    previousDance, previousBlades, previousFromViewer = nil, nil, nil
    InvalidateBindings()
end

events:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_AURA" or event == "ADDON_RESTRICTION_STATE_CHANGED" then
        QueueSample()
        return
    end

    if event == "COOLDOWN_VIEWER_DATA_LOADED" then
        InvalidateBindings()
        return
    end

    if event == "PLAYER_REGEN_ENABLED" then
        if not bindings[SHADOW_DANCE] or not bindings[SHADOW_BLADES] then
            needsDiscovery = true
        end
        QueueSample()
        return
    end

    if event == "PLAYER_SPECIALIZATION_CHANGED" and (issecretvalue(unit) or unit ~= "player") then
        return
    end

    addon.RefreshShadowDanceTracking()
end)
