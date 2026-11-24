local _, addon = ...

local OUTLAW = 260
local ROLL_THE_BONES = 315508
local ROLL_THE_BONES_AURA = 1214909
local KEEP_IT_ROLLING = 381989
local LOADED_DICE = 256171
local LOADED_DICE_TALENT = 256170
local ALERT_EVENT = Enum.CooldownViewerAlertEventType
local AURA_UPDATE_WAIT = 0.5
local EXPIRATION_LEAD = 2
local EXPIRY_TOLERANCE = 1
local ROLL_DURATION = 30
local KEEP_IT_ROLLING_EXTENSION = 30

local rollAuras = {
    1214933, -- One of a Kind
    1214934, -- Double Trouble
    1214935, -- Triple Threat
    1214937, -- Jackpot
}
local buffViewers = { "BuffIconCooldownViewer", "BuffBarCooldownViewer" }
local hookedViewers = setmetatable({}, { __mode = "k" })
local hookedItems = setmetatable({}, { __mode = "k" })

addon.rollTheBonesSpellID = ROLL_THE_BONES

local function GetAuraExpiration(aura)
    if not issecretvalue(aura) and type(aura) == "table" then
        local expiresAt = aura.expirationTime
        if not issecretvalue(expiresAt) and type(expiresAt) == "number" and expiresAt > 0 then
            return expiresAt
        end
    end
end

local function ReadAura(spellID)
    if C_Secrets.ShouldSpellAuraBeSecret(spellID) then
        return
    end
    local ok, aura = pcall(C_UnitAuras.GetPlayerAuraBySpellID, spellID)
    if not ok or issecretvalue(aura) then
        return
    end
    if type(aura) ~= "table" then
        return false
    end
    local id = aura.auraInstanceID
    return true, not issecretvalue(id) and id or nil, GetAuraExpiration(aura)
end

local function IsRollAura(spellID)
    return not issecretvalue(spellID) and (spellID == ROLL_THE_BONES or spellID == ROLL_THE_BONES_AURA)
end

local function IsLoadedDiceAura(spellID)
    return not issecretvalue(spellID) and (spellID == LOADED_DICE or spellID == LOADED_DICE_TALENT)
end

local function GetRollStage(spellID)
    if not issecretvalue(spellID) then
        for stage, auraID in ipairs(rollAuras) do
            if spellID == auraID then
                return stage
            end
        end
    end
end

local function IdentifyTracker(info)
    local tracksRoll, tracksDice, fixedStage, mixedStages
    local function IncludeSpell(spellID)
        tracksRoll = tracksRoll or IsRollAura(spellID)
        tracksDice = tracksDice or IsLoadedDiceAura(spellID)
        local stage = GetRollStage(spellID)
        if stage then
            mixedStages = mixedStages or (fixedStage and fixedStage ~= stage)
            fixedStage = stage
        end
    end
    IncludeSpell(info.spellID)
    IncludeSpell(info.overrideSpellID)
    IncludeSpell(info.overrideTooltipSpellID)
    local links = info.linkedSpellIDs
    if not issecretvalue(links) and type(links) == "table" then
        for _, spellID in ipairs(links) do
            IncludeSpell(spellID)
        end
    end
    return tracksRoll, tracksDice, fixedStage and not (mixedStages or tracksRoll) and fixedStage or nil
end

local function GetStageByName(name)
    if not issecretvalue(name) and type(name) == "string" then
        for stage, spellID in ipairs(rollAuras) do
            if name == addon.GetReminderSpellName(spellID) then
                return stage
            end
        end
    end
end

local function GetSpellTexture(spellID)
    local icon = C_Spell.GetSpellTexture(spellID)
    return not issecretvalue(icon) and icon or nil
end

local function GetStageByTexture(icon)
    if issecretvalue(icon) or type(icon) ~= "number" or icon <= 0 or not C_Spell.GetSpellTexture then
        return
    end
    if icon == GetSpellTexture(ROLL_THE_BONES) or icon == GetSpellTexture(ROLL_THE_BONES_AURA) then
        return
    end
    local match
    for stage, spellID in ipairs(rollAuras) do
        if icon == GetSpellTexture(spellID) then
            if match then
                return
            end
            match = stage
        end
    end
    return match
end

local function GetStageFromAura(aura)
    if not issecretvalue(aura) and type(aura) == "table" then
        return GetRollStage(aura.spellId) or GetStageByName(aura.name)
    end
end

local function ReadAuraInstance(id)
    if id and C_UnitAuras.GetAuraDataByAuraInstanceID then
        local ok, aura = pcall(C_UnitAuras.GetAuraDataByAuraInstanceID, "player", id)
        if ok and not issecretvalue(aura) and type(aura) == "table" then
            return aura
        end
    end
end

local function ReadDisplayedStage(item, id)
    local aura = item.GetAuraDataCached and item:GetAuraDataCached()
    local stage = GetStageFromAura(aura) or GetStageFromAura(ReadAuraInstance(id))
    if stage then
        return stage
    end
    if not issecretvalue(aura) and type(aura) == "table" then
        stage = GetStageByTexture(aura.icon)
        if stage then
            return stage
        end
    end
    local label = item.GetNameFontString and item:GetNameFontString()
    if label and not label:IsForbidden() then
        local shown = label:IsShown()
        if not issecretvalue(shown) and shown then
            stage = GetStageByName(label:GetText())
            if stage then
                return stage
            end
        end
    end
    if item.GetNameText then
        local ok, name = pcall(item.GetNameText, item)
        if ok then
            stage = GetStageByName(name)
        end
        if stage then
            return stage
        end
    end
    local texture = item.GetIconTexture and item:GetIconTexture()
    if texture and not texture:IsForbidden() and texture.GetTextureFileID then
        return GetStageByTexture(texture:GetTextureFileID())
    end
end

local function ReadStageFromAuraChanges(sample)
    local stage, stageID, rollID
    for id, spellID in pairs(sample.addedAuras) do
        if not sample.removedAuras[id] then
            local namedStage = GetRollStage(spellID)
            if not namedStage and (spellID == true or IsRollAura(spellID)) then
                namedStage = GetStageFromAura(ReadAuraInstance(id))
            end
            if namedStage then
                stage, stageID = namedStage, id
            end
            if IsRollAura(spellID) then
                rollID = id
            end
        end
    end
    if not stage then
        for id in pairs(sample.updatedAuras) do
            if not sample.removedAuras[id] then
                stage = GetStageFromAura(ReadAuraInstance(id))
                if stage then
                    stageID = id
                    break
                end
            end
        end
    end
    return stage, stageID, rollID
end

local function HookViewer(viewer)
    if not hookedViewers[viewer] then
        local queue = addon.QueueCooldownReminderUpdate
        if pcall(hooksecurefunc, viewer, "RefreshData", queue) then
            hookedViewers[viewer] = true
            pcall(viewer.HookScript, viewer, "OnShow", queue)
            pcall(viewer.HookScript, viewer, "OnHide", queue)
        end
    end
end

local function HookItem(item)
    if not hookedItems[item] then
        local queue = addon.QueueCooldownReminderUpdate
        if pcall(hooksecurefunc, item, "OnActiveStateChanged", queue) then
            hookedItems[item] = true
            pcall(hooksecurefunc, item, "OnAuraInstanceInfoSet", queue)
            pcall(hooksecurefunc, item, "OnAuraInstanceInfoCleared", queue)
        end
    end
end

local function ReadViewerAuras(viewer, needsExpiration)
    if viewer:IsForbidden() then
        return
    end
    HookViewer(viewer)
    local visible = viewer:IsVisible()
    if issecretvalue(visible) or not visible or viewer:IsEditing() then
        return
    end

    local stage, loadedDice, rollActive, instanceID, trackerID, expiresAt
    for item in viewer.itemFramePool:EnumerateActive() do
        if not issecretvalue(item) and not item:IsForbidden() then
            local info, active = item:GetCooldownInfo(), item:IsActive()
            if not issecretvalue(info) and type(info) == "table" then
                local isRoll, isDice, fixedStage = IdentifyTracker(info)
                if isRoll or isDice or fixedStage then
                    HookItem(item)
                    local id = item.GetAuraSpellInstanceID and item:GetAuraSpellInstanceID()
                    id = not issecretvalue(id) and id or nil
                    local readableActivity = not issecretvalue(active) and type(active) == "boolean"
                    if (readableActivity and active == true) or (not readableActivity and id) then
                        local auraSpellID, unit = item:GetAuraSpellID(), item:GetAuraDataUnit()
                        local selfAura = info.selfAura
                        local playerAura = not issecretvalue(unit) and unit == "player"
                        if not playerAura and (issecretvalue(unit) or unit == nil) then
                            playerAura = not issecretvalue(selfAura) and selfAura == true
                        end
                        if playerAura then
                            local rollStage = GetRollStage(auraSpellID) or GetRollStage(info.linkedSpellID)
                                or fixedStage or (isRoll and ReadDisplayedStage(item, id))
                            if isRoll then
                                trackerID = id or trackerID
                            end
                            if rollStage or (isRoll and rollActive ~= true) then
                                stage, rollActive, instanceID = rollStage, true, id
                            end
                            if needsExpiration and not expiresAt and (isRoll or rollStage) then
                                local aura = item.GetAuraDataCached and item:GetAuraDataCached()
                                expiresAt = GetAuraExpiration(ReadAuraInstance(id)) or GetAuraExpiration(aura)
                            end
                            if isDice or IsLoadedDiceAura(auraSpellID) or IsLoadedDiceAura(info.linkedSpellID) then
                                loadedDice = true
                            end
                        end
                    elseif readableActivity then
                        if isRoll and rollActive == nil then
                            stage, rollActive = 0, false
                        end
                        if isDice and loadedDice ~= true then
                            loadedDice = false
                        end
                    end
                end
            end
        end
    end
    return stage, loadedDice, rollActive, instanceID, trackerID, expiresAt
end

local function ReadRollStage()
    local active, rollID, expiresAt = ReadAura(ROLL_THE_BONES_AURA)
    local allAbsent = true
    for stage, spellID in ipairs(rollAuras) do
        local stageActive, id, stageExpiresAt = ReadAura(spellID)
        if stageActive == true then
            return stage, true, id, rollID, expiresAt or stageExpiresAt
        end
        allAbsent = allAbsent and stageActive == false
    end
    if active == true then
        return nil, true, rollID, rollID, expiresAt
    end
    if allAbsent or active == false then
        return 0, false
    end
end

local function ReadRollTheBonesState(sample, needsLoadedDice)
    local stage, active, instanceID, rollID, expiresAt = ReadRollStage()
    local source = instanceID and "aura"
    if not stage or stage == 0 then
        local eventStage, stageID, eventRollID = ReadStageFromAuraChanges(sample)
        rollID = rollID or eventRollID
        if eventStage then
            stage, active, instanceID, source = eventStage, true, stageID, "aura"
        elseif eventRollID then
            stage, active, instanceID, source = nil, true, eventRollID, "aura"
        end
    end
    local loadedDice
    if needsLoadedDice and (stage == nil or stage == 2) then
        loadedDice = ReadAura(LOADED_DICE)
        if loadedDice ~= true then
            for id, spellID in pairs(sample.addedAuras) do
                if spellID == LOADED_DICE and not sample.removedAuras[id] then
                    loadedDice = true
                    break
                end
            end
        end
        if loadedDice == nil and not C_SpellBook.IsSpellKnown(LOADED_DICE_TALENT) then
            loadedDice = false
        end
    end

    local needsRollID = active and not rollID and sample.lastRoll and sample.lastRoll.rollID
    local needsExpiration = addon.settings.rollTheBonesEnabled and active == true and not expiresAt
    if needsExpiration then
        expiresAt = GetAuraExpiration(ReadAuraInstance(rollID or instanceID))
    end
    if not stage or stage == 0 or needsRollID or (needsExpiration and not expiresAt)
        or (needsLoadedDice and stage == 2 and loadedDice == nil) then
        for _, viewerName in ipairs(buffViewers) do
            local viewer = _G[viewerName]
            if not issecretvalue(viewer) and viewer then
                local readExpiration = addon.settings.rollTheBonesEnabled and not expiresAt
                local ok, viewerStage, viewerDice, viewerActive, viewerInstanceID, trackerID, viewerExpiresAt =
                    pcall(ReadViewerAuras, viewer, readExpiration)
                if ok then
                    rollID = rollID or trackerID
                    expiresAt = expiresAt or viewerExpiresAt
                    if viewerActive == true
                        and (active ~= true or (stage == nil and viewerStage ~= nil)) then
                        stage, active, instanceID, source = viewerStage, true, viewerInstanceID, viewer
                    elseif active == nil and viewerActive == false then
                        stage, active = 0, false
                    end
                    if loadedDice == nil then
                        loadedDice = viewerDice
                    end
                end
            end
        end
    end
    return {
        stage = stage, loadedDice = loadedDice, active = active, instanceID = instanceID, source = source, rollID = rollID,
        expiresAt = expiresAt,
    }
end

function addon.GetRollTheBonesChanges(sample)
    if sample.roll then
        return sample.roll
    end

    if sample.ready[ROLL_THE_BONES_AURA] == false then
        sample.usesRollCastCooldown = true
    end
    local cooldownID = sample.usesRollCastCooldown and ROLL_THE_BONES_AURA or ROLL_THE_BONES
    local recharged = sample.recharged[cooldownID]
    local cast = sample.casts[ROLL_THE_BONES] or sample.casts[ROLL_THE_BONES_AURA]
    local roll = ReadRollTheBonesState(sample, addon.settings.rollTheBonesEnabled
        and (recharged or (sample.diceSnapshotUntil and sample.diceSnapshotUntil >= GetTime())))
    roll.recharged, roll.cast = recharged, cast
    roll.coolingDown = sample.ready[cooldownID] == false
    local previous = sample.lastRoll
    local sameRoll = previous and roll.rollID and roll.rollID == previous.rollID
    local sameInstance = previous and roll.instanceID and roll.instanceID == previous.instanceID
    local removed
    if previous and previous.active == true then
        removed = (previous.rollID and sample.removedAuras[previous.rollID])
            or (previous.instanceID and sample.removedAuras[previous.instanceID])
        if roll.active == nil and removed then
            roll.active = false
        elseif roll.active == nil and not cast and previous.stage and ReadAuraInstance(previous.instanceID) then
            roll.active, roll.instanceID, roll.source = true, previous.instanceID, previous.source
            roll.stage, roll.rollID = previous.stage, previous.rollID
        end
    end
    if cast then
        sample.rollCastUntil = GetTime() + AURA_UPDATE_WAIT
    end
    if roll.active == true then
        local instanceID = roll.instanceID
        local addedRoll = roll.rollID and not sameRoll and sample.addedAuras[roll.rollID]
        local addedStage = instanceID and not sameInstance and sample.addedAuras[instanceID]
            and (not sameRoll or (previous.stage and previous.instanceID ~= previous.rollID))
        roll.applied = addedRoll or addedStage
            or (previous and (previous.active == false
                or (roll.stage and previous.stage and roll.stage ~= previous.stage)
                or (not sameRoll and roll.rollID and previous.rollID and roll.source == previous.source)
                or (not sameRoll and instanceID and previous.instanceID and roll.source == previous.source
                    and (roll.stage ~= nil) == (previous.stage ~= nil)
                    and instanceID ~= previous.instanceID)))
        -- Rerolling the same stage can refresh the existing aura instance.
        if not roll.applied and instanceID and sample.updatedAuras[instanceID]
            and sample.rollCastUntil and sample.rollCastUntil >= GetTime() then
            roll.applied = true
        end
        local identityHidden = not roll.rollID and not instanceID
        if not roll.applied and cast and identityHidden then
            -- The successful cast distinguishes a new roll when the tracker hides both instance IDs.
            roll.applied = true
            if previous and roll.stage == previous.stage then
                roll.stage = nil
            end
        end
        if roll.applied then
            sample.rollCastUntil = nil
        elseif not cast and not removed and previous and previous.active == true
            and (sameRoll or sameInstance or (identityHidden and not previous.rollID and not previous.instanceID)) then
            -- The tracker can expose the stage briefly and hide it again during the same roll.
            roll.stage = roll.stage or previous.stage
        end
    elseif roll.active == false then
        roll.faded = previous and previous.active == true
    end
    if roll.active ~= nil then
        sample.lastRoll = roll
    end
    sample.roll = roll
    return roll
end

local function GetExpirationAlert(sample, roll, now)
    local window = sample.rollWindow
    if roll.cast then
        window = { expiresAt = now + ROLL_DURATION, castAt = now, staleExpiry = window and window.expiresAt }
        sample.rollWindow = window
    elseif roll.active == false then
        if not (window and window.castAt and now - window.castAt <= AURA_UPDATE_WAIT) then
            sample.rollWindow = nil
        end
        return
    elseif roll.applied and not (window and window.castAt and now - window.castAt <= AURA_UPDATE_WAIT) then
        window = nil
        sample.rollWindow = nil
    end

    local expiresAt = roll.expiresAt
    if not window then
        if not expiresAt then
            return
        end
        window = {}
        sample.rollWindow = window
    end

    local previousExpiry = window.expiresAt
    local observedExtension = previousExpiry and expiresAt and expiresAt - previousExpiry > EXPIRY_TOLERANCE
    if sample.casts[KEEP_IT_ROLLING] and previousExpiry and previousExpiry > now and not observedExtension
        and not (window.extendedAt and now - window.extendedAt <= AURA_UPDATE_WAIT) then
        -- The tracker can still report the old expiry when the successful cast arrives.
        window.expiresAt = previousExpiry + KEEP_IT_ROLLING_EXTENSION
        window.staleExpiry = previousExpiry
        window.warned = nil
    end
    if expiresAt and (not window.staleExpiry or math.abs(expiresAt - window.staleExpiry) > EXPIRY_TOLERANCE) then
        window.expiresAt, window.staleExpiry = expiresAt, nil
        if observedExtension and not roll.cast then
            window.extendedAt, window.warned = now, nil
        end
    end

    local remaining = window.expiresAt and window.expiresAt - now
    if roll.active == true and not window.warned and remaining and remaining > 0 and remaining <= EXPIRATION_LEAD then
        window.warned = true
        return ALERT_EVENT.Available
    end
end

local function GetRerollAlert(sample, roll, now)
    if roll.faded then
        sample.rerollPending, sample.diceSnapshotUntil = nil, nil
        return
    end
    if roll.cast or roll.applied or roll.coolingDown or roll.active == false then
        sample.rerollPending, sample.diceSnapshotUntil = nil, nil
    end
    if roll.recharged and roll.active ~= false and not roll.cast then
        sample.rerollPending = true
        sample.diceAtRecharge = roll.loadedDice
        sample.diceSnapshotUntil = roll.loadedDice == nil and now + AURA_UPDATE_WAIT or nil
    end
    if not sample.rerollPending then
        return
    end
    if sample.diceSnapshotUntil then
        if sample.diceSnapshotUntil < now then
            sample.diceSnapshotUntil = nil
        elseif roll.loadedDice ~= nil then
            sample.diceAtRecharge, sample.diceSnapshotUntil = roll.loadedDice, nil
        end
    end
    if roll.active ~= true or not roll.stage then
        return
    end
    if roll.stage == 1 or (roll.stage == 2 and sample.diceAtRecharge == true) then
        sample.rerollPending, sample.diceSnapshotUntil = nil, nil
        return ALERT_EVENT.Available
    end
    if roll.stage > 2 or not sample.diceSnapshotUntil then
        sample.rerollPending, sample.diceSnapshotUntil = nil, nil
    end
end

local function GetRollAlert(sample)
    local roll = addon.GetRollTheBonesChanges(sample)
    local now = GetTime()
    local expiryAlert = GetExpirationAlert(sample, roll, now)
    return GetRerollAlert(sample, roll, now) or expiryAlert
end

addon.RegisterCooldownReminder(OUTLAW, "rollTheBones", ROLL_THE_BONES, GetRollAlert,
    { ROLL_THE_BONES, ROLL_THE_BONES_AURA, KEEP_IT_ROLLING })
