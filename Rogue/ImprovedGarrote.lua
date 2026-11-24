local _, addon = ...

local ASSASSINATION = 259
local GARROTE = 703
local IMPROVED_GARROTE = 392401
local IMPROVED_GARROTE_TALENT = 381632
local POST_STEALTH_DURATION = 6

addon.garroteSpellID = GARROTE
addon.improvedGarroteSpellID = IMPROVED_GARROTE

local tracking = false
local wasStealthed, fallbackExpiration, scheduledExpiration, timer
local confirmedAura, warned = false, false

local function CancelTimer()
    if timer then
        timer:Cancel()
        timer = nil
    end
    scheduledExpiration = nil
end

local function ResetWindow()
    CancelTimer()
    fallbackExpiration, confirmedAura, warned = nil, false, false
end

local function ReadExpiration()
    if C_Secrets.ShouldSpellAuraBeSecret(IMPROVED_GARROTE) then
        return nil, false
    end

    local ok, aura = pcall(C_UnitAuras.GetPlayerAuraBySpellID, IMPROVED_GARROTE)
    if not ok or issecretvalue(aura) then
        return nil, false
    end
    if not aura then
        return nil, true
    end

    local expiration = aura.expirationTime
    if issecretvalue(expiration) then
        return nil, false
    end
    if type(expiration) == "number" and expiration > 0 then
        return expiration, true
    end
    return nil, true
end

local function UpdateStealth()
    local stealthed = IsStealthed()
    if issecretvalue(stealthed) then
        wasStealthed = nil
        return
    end

    stealthed = not not stealthed
    if stealthed ~= wasStealthed then
        if stealthed or wasStealthed then
            ResetWindow()
        end
        if wasStealthed and not stealthed and C_SpellBook.IsSpellKnown(IMPROVED_GARROTE_TALENT) then
            -- The talent grants a six-second window after leaving Stealth.
            fallbackExpiration = GetTime() + POST_STEALTH_DURATION
        end
        wasStealthed = stealthed
    end
end

local function UpdateWarning()
    if not tracking then
        return
    end

    local expiration, readable = ReadExpiration()
    if not readable then
        expiration = fallbackExpiration
    elseif expiration then
        fallbackExpiration, confirmedAura = expiration, true
    elseif confirmedAura then
        ResetWindow()
        return
    end

    local now = GetTime()
    if not expiration or expiration <= now then
        CancelTimer()
        if fallbackExpiration and fallbackExpiration <= now then
            ResetWindow()
        end
        return
    end
    if warned then
        return
    end

    local delay = expiration - now - addon.settings.improvedGarroteLeadTime
    if delay <= 0 then
        CancelTimer()
        warned = true
        addon.PlayReminderSound(addon.settings.improvedGarroteSound, GARROTE,
            Enum.CooldownViewerAlertEventType.Available)
    elseif expiration ~= scheduledExpiration then
        CancelTimer()
        scheduledExpiration = expiration
        timer = C_Timer.NewTimer(delay, function()
            timer, scheduledExpiration = nil, nil
            UpdateStealth()
            UpdateWarning()
        end)
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
events:RegisterEvent("PLAYER_DEAD")
events:RegisterEvent("PLAYER_ALIVE")
events:RegisterEvent("PLAYER_UNGHOST")

function addon.RefreshImprovedGarroteTracking()
    local _, class = UnitClass("player")
    local spec = class == "ROGUE" and GetSpecialization()
    local enabled = addon.settings and addon.settings.improvedGarroteEnabled
    local shouldTrack = enabled == true and spec and GetSpecializationInfo(spec) == ASSASSINATION
        and not UnitIsDeadOrGhost("player")

    if not shouldTrack then
        tracking, wasStealthed = false, nil
        events:UnregisterEvent("UNIT_AURA")
        events:UnregisterEvent("UPDATE_STEALTH")
        events:UnregisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
        ResetWindow()
        return
    end

    if not tracking then
        tracking = true
        events:RegisterUnitEvent("UNIT_AURA", "player")
        events:RegisterEvent("UPDATE_STEALTH")
        events:RegisterEvent("ADDON_RESTRICTION_STATE_CHANGED")
    end
    UpdateStealth()
    UpdateWarning()
end

events:SetScript("OnEvent", function(_, event, unit)
    if event == "UNIT_AURA" or event == "UPDATE_STEALTH" or event == "ADDON_RESTRICTION_STATE_CHANGED" then
        UpdateStealth()
        UpdateWarning()
        return
    end

    if event == "PLAYER_SPECIALIZATION_CHANGED" and (issecretvalue(unit) or unit ~= "player") then
        return
    end
    if event == "PLAYER_ENTERING_WORLD" then
        wasStealthed = nil
        ResetWindow()
    end
    addon.RefreshImprovedGarroteTracking()
end)
