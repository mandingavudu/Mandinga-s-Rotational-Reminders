local _, addon = ...

local GLOBAL_COOLDOWN = 61304

local groups = {}
local activeGroup
local sample
local readyOnGlobalCooldown = {}
local ticker
local updateQueued = false

function addon.RegisterCooldownReminder(specID, key, spellID, getAlert, castSpellIDs)
    local group = groups[specID]
    if not group then
        group = { reminders = {}, spellIDs = {}, castSpellIDs = {} }
        groups[specID] = group
    end
    group.reminders[#group.reminders + 1] = {
        spellID = spellID,
        enabledKey = key .. "Enabled",
        soundKey = key .. "Sound",
        getAlert = getAlert,
    }
    group.spellIDs[spellID] = true
    if castSpellIDs then
        for _, castSpellID in ipairs(castSpellIDs) do
            group.spellIDs[castSpellID] = true
            group.castSpellIDs[castSpellID] = true
        end
    end
end

local function GetCooldownInfo(spellID)
    local info = C_Spell.GetSpellCooldown(spellID)
    if not issecretvalue(info) and type(info) == "table" then
        return info
    end
end

local function IsReady(spellID)
    if not C_SpellBook.IsSpellKnown(spellID) then
        return
    end

    local info = GetCooldownInfo(spellID)
    if not info or issecretvalue(info.isEnabled) or issecretvalue(info.isActive)
        or info.isEnabled ~= true or type(info.isActive) ~= "boolean" then
        return
    end
    if info.isActive == false then
        return true
    end

    local duration = C_Spell.GetSpellCooldownDuration(spellID, true)
    if not issecretvalue(duration) and duration then
        local remaining = duration:GetRemainingDuration()
        if not issecretvalue(remaining) and type(remaining) == "number" then
            return remaining <= 0
        end
    end

    local gcd = GetCooldownInfo(GLOBAL_COOLDOWN)
    if gcd and not issecretvalue(gcd.isActive) and gcd.isActive == false then
        return false
    end
    return readyOnGlobalCooldown[spellID]
end

local function Update()
    updateQueued = false
    if not activeGroup then
        return
    end

    for spellID in pairs(activeGroup.spellIDs) do
        sample.ready[spellID] = IsReady(spellID)
    end

    local settings = addon.settings
    for _, reminder in ipairs(activeGroup.reminders) do
        if settings[reminder.enabledKey] then
            local alert = reminder.getAlert(sample)
            if alert then
                addon.PlayReminderSound(settings[reminder.soundKey], reminder.spellID, alert)
            end
        end
    end
    wipe(readyOnGlobalCooldown)
    wipe(sample.casts)
end

local function QueueUpdate()
    if ticker and not updateQueued then
        updateQueued = true
        C_Timer.After(0, Update)
    end
end

local events = CreateFrame("Frame")
events:RegisterEvent("PLAYER_ENTERING_WORLD")
events:RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
events:RegisterEvent("PLAYER_DEAD")
events:RegisterEvent("PLAYER_ALIVE")
events:RegisterEvent("PLAYER_UNGHOST")

function addon.RefreshCooldownReminderTracking()
    local spec = GetSpecialization()
    local settings = addon.settings
    local group = spec and settings and groups[GetSpecializationInfo(spec)]
    local enabled
    if group and not UnitIsDeadOrGhost("player") then
        for _, reminder in ipairs(group.reminders) do
            if settings[reminder.enabledKey] then
                enabled = true
                break
            end
        end
    end
    group = enabled and group or nil

    activeGroup = group
    wipe(readyOnGlobalCooldown)
    sample = group and { ready = {}, casts = {} }
    if group and not ticker then
        events:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
        events:RegisterEvent("SPELL_UPDATE_COOLDOWN")
        -- Cooldown expiry does not always send SPELL_UPDATE_COOLDOWN.
        ticker = C_Timer.NewTicker(0.2, QueueUpdate)
    elseif not group and ticker then
        ticker:Cancel()
        ticker = nil
        events:UnregisterEvent("UNIT_SPELLCAST_SUCCEEDED")
        events:UnregisterEvent("SPELL_UPDATE_COOLDOWN")
    end
    QueueUpdate()
end

events:SetScript("OnEvent", function(_, event, unit, _castGUID, spellID)
    if event == "UNIT_SPELLCAST_SUCCEEDED" then
        if sample and not issecretvalue(spellID) and activeGroup.castSpellIDs[spellID] then
            sample.casts[spellID] = true
            QueueUpdate()
        end
    elseif event == "SPELL_UPDATE_COOLDOWN" and activeGroup then
        -- Blizzard documents isOnGCD as reliable in this event.
        for spellID in pairs(activeGroup.spellIDs) do
            local info = GetCooldownInfo(spellID)
            local isOnGCD = info and info.isOnGCD
            if info and not issecretvalue(isOnGCD) then
                readyOnGlobalCooldown[spellID] = isOnGCD == true
            else
                readyOnGlobalCooldown[spellID] = nil
            end
        end
        QueueUpdate()
    elseif event ~= "PLAYER_SPECIALIZATION_CHANGED" or (not issecretvalue(unit) and unit == "player") then
        addon.RefreshCooldownReminderTracking()
    end
end)
