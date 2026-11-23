local SUBTLETY = 261
local SHADOW_DANCE = 185313
local SHADOW_DANCE_AURA = 185422
local SHADOW_BLADES = 121471
local CDM_SOUND_SUBTYPE = "Gameplay SFX"

local viewerNames = { "BuffIconCooldownViewer", "BuffBarCooldownViewer" }
local hookedViewers = setmetatable({}, { __mode = "k" })
local hookedItems = setmetatable({}, { __mode = "k" })
local bindings = {}
local tracking = false
local needsDiscovery = true
local sampleQueued = false
local previousDance, previousBlades

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

local function PlayDanceAlert(item)
    local ok, name = pcall(item.GetNameText, item)
    if not ok or issecretvalue(name) or not name or name == "" then
        name = C_Spell.GetSpellName(SHADOW_DANCE)
    end

    if not issecretvalue(name) and name and name ~= "" then
        local alert = CooldownViewerAlert_Create(Enum.CooldownViewerAlertType.Sound,
            Enum.CooldownViewerAlertEventType.OnAuraRemoved, Enum.CooldownViewerSound.TextToSpeech)
        CooldownViewerAlert_PlayAlert(item, name, alert, CDM_SOUND_SUBTYPE)
    else
        C_Sound.PlaySoundWithOptions({ soundKitID = SOUNDKIT.RAID_WARNING, uiSoundSubType = CDM_SOUND_SUBTYPE })
    end
end

local function Sample()
    local dance = ReadTrackedSpell(SHADOW_DANCE)
    local blades = ReadTrackedSpell(SHADOW_BLADES)
    -- Require Blades on both samples so a simultaneous application or loss stays quiet.
    local shouldAlert = previousDance == true and dance == false and previousBlades == true and blades == true
    previousDance, previousBlades = dance, blades
    if shouldAlert then
        PlayDanceAlert(bindings[SHADOW_DANCE].item)
    end
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
    previousDance, previousBlades = nil, nil
    QueueSample()
end

local function DiscoverViewer(viewer)
    if viewer:IsForbidden() then
        return
    end

    if not hookedViewers[viewer] and pcall(hooksecurefunc, viewer, "RefreshData", InvalidateBindings) then
        hookedViewers[viewer] = true
        pcall(viewer.HookScript, viewer, "OnHide", InvalidateBindings)
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

Update = function()
    sampleQueued = false
    if not tracking then
        return
    end

    if needsDiscovery then
        needsDiscovery = false
        bindings = {}
        for _, viewerName in ipairs(viewerNames) do
            local viewer = _G[viewerName]
            if not issecretvalue(viewer) and viewer then
                pcall(DiscoverViewer, viewer)
            end
        end
    end
    Sample()
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
events:RegisterEvent("PLAYER_DEAD")
events:RegisterEvent("PLAYER_ALIVE")
events:RegisterEvent("PLAYER_UNGHOST")
events:RegisterEvent("PLAYER_REGEN_ENABLED")
events:RegisterEvent("COOLDOWN_VIEWER_DATA_LOADED")

events:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_AURA" then
        QueueSample()
        return
    end

    if event == "PLAYER_REGEN_ENABLED" then
        if tracking and (not bindings[SHADOW_DANCE] or not bindings[SHADOW_BLADES]) then
            InvalidateBindings()
        end
        return
    end

    if event == "PLAYER_SPECIALIZATION_CHANGED" and (issecretvalue(unit) or unit ~= "player") then
        return
    end

    local _, class = UnitClass("player")
    local spec = class == "ROGUE" and GetSpecialization()
    local shouldTrack = spec and GetSpecializationInfo(spec) == SUBTLETY and not UnitIsDeadOrGhost("player")
    if shouldTrack then
        events:RegisterUnitEvent("UNIT_AURA", "player")
    else
        events:UnregisterEvent("UNIT_AURA")
        bindings = {}
    end
    tracking = shouldTrack
    InvalidateBindings()
end)
