local _, addon = ...

local OUTLAW = 260
local PREPARATION = 1277933

local preparationCooldowns = {
    13750, -- Adrenaline Rush
    51690, -- Killing Spree
    271877, -- Blade Rush
}

addon.preparationSpellID = PREPARATION
addon.preparationCooldownSpellIDs = preparationCooldowns

local function GetPreparationAlert(sample)
    local now = GetTime()
    for _, spellID in ipairs(preparationCooldowns) do
        if sample.casts[spellID] then
            -- Allow the cast's cooldown updates to reach the client before checking.
            sample.preparationCheckUntil = now + 0.5
            break
        end
    end
    if not sample.preparationCheckUntil then
        return
    end
    if sample.preparationCheckUntil < now or sample.ready[PREPARATION] == false then
        sample.preparationCheckUntil = nil
        return
    end
    if sample.ready[PREPARATION] ~= true then
        return
    end
    for _, spellID in ipairs(preparationCooldowns) do
        if sample.ready[spellID] ~= false then
            return
        end
    end
    sample.preparationCheckUntil = nil
    return Enum.CooldownViewerAlertEventType.Available
end

addon.RegisterCooldownReminder(OUTLAW, "preparation", PREPARATION, GetPreparationAlert, preparationCooldowns)
