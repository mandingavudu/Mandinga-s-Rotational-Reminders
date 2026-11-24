local _, addon = ...

local OUTLAW = 260
local KEEP_IT_ROLLING = 381989

addon.keepItRollingSpellID = KEEP_IT_ROLLING

addon.RegisterCooldownReminder(OUTLAW, "keepItRolling", KEEP_IT_ROLLING, function(sample)
    local roll = addon.GetRollTheBonesChanges(sample)
    local ready = sample.ready[KEEP_IT_ROLLING]
    if roll.cast or roll.applied or sample.recharged[KEEP_IT_ROLLING] then
        sample.keepRollPending = true
    end
    if roll.active == false or (roll.stage and roll.stage < 3) or ready == false then
        sample.keepRollPending = nil
        return
    end
    if ready and (not roll.cast or roll.applied) and roll.active == true
        and roll.stage and roll.stage >= 3 and sample.keepRollPending then
        sample.keepRollPending = nil
        return Enum.CooldownViewerAlertEventType.Available
    end
end)
