local function potionLeft(entry)
    if not entry or type(entry) ~= "table" then return 0 end
    if type(entry.remaining) == "number" then return math.max(0, entry.remaining) end
    return 1e9
end

local function activePotionsWithTier()
    local active = {}
    local ok, ae = pcall(function() return DC.ActiveEntries() end)
    if not ok or type(ae) ~= "table" then return active end
    
    local entries = (BoostConfig and BoostConfig.entries) or {}
    for name, e in pairs(ae) do
        local strName = tostring(name)
        if type(e) == "table" and potionLeft(e) > 3 then
            local cfg = entries[strName] or { tier = 1 }
            local stageGroup = strName:gsub("%s+[Tt]ier%s*%d+", ""):gsub("%s+%d+", "")
            active[stageGroup] = {
                name = strName,
                tier = cfg.tier or 1,
                remaining = potionLeft(e)
            }
        end
    end
    return active
end

local function potionKeys()
    local out = {}
    local inv = inventory()
    for key, e in pairs(inv) do
        if type(e) == "table" and e.name then
            local strName = tostring(e.name)
            local amt = tonumber(e.amount) or 0
            if amt >= 1 then
                local ok, cfg = pcall(function() return EntryRegistry.getEntryConfig(strName) end)
                if (ok and cfg and cfg.kind == "Boost") or strName:lower():find("potion") or strName:lower():find("boost") then
                    out[strName] = key
                end
            end
        end
    end
    return out
end

task.spawn(function()
    while isRunning do
        task.wait(3)
        pcall(function()
            if not BoostConfig or not BoostConfig.entries then return end
            local entries = BoostConfig.entries
            local have = potionKeys()
            local activeGroups = activePotionsWithTier()

            local stagePotions = {}
            for name, key in pairs(have) do
                local lowerName = tostring(name):lower()
                if lowerName:find("money") or lowerName:find("coin") then
                    local e = entries[name] or { tier = 1 }
                    local stageGroup = name:gsub("%s+[Tt]ier%s*%d+", ""):gsub("%s+%d+", "")
                    if not stagePotions[stageGroup] then
                        stagePotions[stageGroup] = {}
                    end
                    table.insert(stagePotions[stageGroup], { 
                        name = name, 
                        tier = tonumber(e.tier) or 1, 
                        key = key 
                    })
                end
            end

            local boostSig = getSig("BoostService", "Use")
            if not boostSig then return end

            for groupName, pots in pairs(stagePotions) do
                table.sort(pots, function(a, b) return a.tier > b.tier end)
                local bestPotion = pots[1]
                local currentActive = activeGroups[groupName]

                if not currentActive or (bestPotion.tier > currentActive.tier) then
                    pcall(function() boostSig:Fire(bestPotion.key) end)
                    task.wait(0.5)
                end
            end
        end)
    end
end)
