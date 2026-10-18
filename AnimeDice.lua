local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")

local AUTOEXEC_CODE = [[
loadstring(game:HttpGet("https://raw.githubusercontent.com/arounxaillhc-cyber/RobloxScript/refs/heads/main/AnimeDice.lua"))()
]]

-- Wait for game loading
if not game:IsLoaded() then
    local startTime = os.clock()

    while not game:IsLoaded()
        and os.clock() - startTime < 30 do
        task.wait(0.2)
    end
end

-- Wait for LocalPlayer
local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
    local startTime = os.clock()

    repeat
        task.wait(0.2)
        LocalPlayer = Players.LocalPlayer
    until LocalPlayer or os.clock() - startTime >= 30
end

if not LocalPlayer then
    error("[Anime Dice] LocalPlayer unavailable")
end

-- Wait for PlayerGui
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui", 30)

if not PlayerGui then
    error("[Anime Dice] PlayerGui unavailable")
end
-- Wait for game modules
local startTime = os.clock()

while os.clock() - startTime < 30 do
    if RS:FindFirstChild("Packages")
        and RS:FindFirstChild("Framework") then
        break
    end

    task.wait(0.5)
end

-- Queue AutoExec
local autoExecQueued = false

local function queueAutoExec()
    if autoExecQueued then
        return true
    end

    local q = queue_on_teleport or queueonteleport

    if type(q) ~= "function" then
        warn("[AutoExec] queue_on_teleport unavailable")
        return false
    end

    local ok, err = pcall(function()
        q(AUTOEXEC_CODE)
    end)

    if not ok then
        warn("[AutoExec] Queue failed:", tostring(err))
        return false
    end

    autoExecQueued = true
    print("[AutoExec] Successfully queued")

    return true
end

queueAutoExec()

local Network = require(RS.Packages.Network)
local DC = require(RS.Framework.Features.Data.DataController)
local PlotConfig = require(RS.Framework.Features.Plot.PlotConfig)
local TowersMod = require(RS.Framework.Features.Towers.Towers)
local BoostConfig = require(RS.Framework.Features.Inventory.Kinds.Boost.BoostConfig)

pcall(function()
    require(RS.Framework.Features.Inventory.EntryTypes)
end)

local EntryRegistry = require(RS.Framework.Features.Inventory.EntryRegistry)

local function svcComm(svc)
    return Network.ClientComm.new(RS.Network, false, svc)
end

local function getSig(svc, name)
    local ok, s = pcall(function()
        return svcComm(svc):GetSignal(name)
    end)

    if ok and s then
        return s
    end

    return nil
end

local function getFn(svc, name)
    local ok, f = pcall(function()
        return svcComm(svc):GetFunction(name)
    end)

    if ok and f then
        return f
    end

    return nil
end

local afkConn = LocalPlayer.Idled:Connect(function()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end)

--==================================================
-- HYBRID AUTO REJOIN + AUTO EXEC
--==================================================

local RejoinPlaceId = game.PlaceId
local RejoinJobId = game.JobId

local RejoinBusy = false
local Teleporting = false

LocalPlayer.OnTeleport:Connect(function(state)

    if state == Enum.TeleportState.Started
        or state == Enum.TeleportState.WaitingForServer
        or state == Enum.TeleportState.InProgress then

        Teleporting = true

    elseif state == Enum.TeleportState.Failed then

        Teleporting = false

    end

end)

local function waitTeleport(timeout)

    local deadline = os.clock() + timeout

    while os.clock() < deadline do

        if Teleporting then
            return true
        end

        task.wait(0.25)

    end

    return Teleporting

end

local function StartRejoin()

    if RejoinBusy or Teleporting then
        return
    end

    RejoinBusy = true

    task.spawn(function()

        for attempt = 1, 5 do

            if Teleporting then
                break
            end

            warn("[Rejoin] Attempt:", attempt)

            task.wait(3)

            Teleporting = false

            -- Original server
            pcall(function()
                TS:TeleportToPlaceInstance(
                    RejoinPlaceId,
                    RejoinJobId,
                    LocalPlayer
                )
            end)

            if waitTeleport(8) then
                break
            end

            warn("[Rejoin] Original server failed.")

            Teleporting = false

            -- New server
            pcall(function()
                TS:Teleport(
                    RejoinPlaceId,
                    LocalPlayer
                )
            end)

            if waitTeleport(8) then
                break
            end

            warn("[Rejoin] New server failed.")

            task.wait(5)

        end

        RejoinBusy = false

    end)

end
-- Teleport failure handler
TS.TeleportInitFailed:Connect(function(
    player,
    result,
    msg,
    placeId
)

    if player ~= LocalPlayer then
        return
    end

    Teleporting = false

    warn(
        "[Rejoin] Teleport failed:",
        tostring(msg),
        "| Result:",
        tostring(result)
    )

    StartRejoin()

end)

local fpsRestore = {}

local function applyFpsBoost()
    pcall(function()
        local s = getSig("SettingsService", "SetSetting")
        if s then
            s:Fire("Performance", true)
        end
    end)

    pcall(function()
        local L = game:GetService("Lighting")

        table.insert(fpsRestore, {
            o = L,
            p = "GlobalShadows",
            v = L.GlobalShadows
        })

        L.GlobalShadows = false

        table.insert(fpsRestore, {
            o = L,
            p = "FogEnd",
            v = L.FogEnd
        })

        L.FogEnd = 100000
    end)

    pcall(function()
        local T = workspace.Terrain

        table.insert(fpsRestore, {
            o = T,
            p = "WaterWaveSize",
            v = T.WaterWaveSize
        })

        table.insert(fpsRestore, {
            o = T,
            p = "WaterWaveSpeed",
            v = T.WaterWaveSpeed
        })

        table.insert(fpsRestore, {
            o = T,
            p = "Decoration",
            v = T.Decoration
        })

        T.WaterWaveSize = 0
        T.WaterWaveSpeed = 0
        T.Decoration = false
    end)

    for _, inst in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if inst:IsA("ParticleEmitter")
            or inst:IsA("Trail")
            or inst:IsA("Beam")
            or inst:IsA("Smoke")
            or inst:IsA("Fire")
            or inst:IsA("Sparkles") then

                if inst.Enabled then
                    table.insert(fpsRestore, {
                        o = inst,
                        p = "Enabled",
                        v = true
                    })

                    inst.Enabled = false
                end

            elseif inst:IsA("BasePart") and not inst:IsA("Terrain") then
                if inst.CastShadow then
                    table.insert(fpsRestore, {
                        o = inst,
                        p = "CastShadow",
                        v = true
                    })

                    inst.CastShadow = false
                end

            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if inst.Transparency < 1 then
                    table.insert(fpsRestore, {
                        o = inst,
                        p = "Transparency",
                        v = inst.Transparency
                    })

                    inst.Transparency = 1
                end
            end
        end)
    end
end

task.spawn(applyFpsBoost)

-- Status GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimeDiceStatusUI"
screenGui.ResetOnSpawn = false

pcall(function()
    screenGui.Parent =
        LocalPlayer:FindFirstChildOfClass("PlayerGui")
        or LocalPlayer.PlayerGui
end)

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 175)
mainFrame.Position = UDim2.new(0, 20, 0, 20)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 28)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Anime Dice - Auto Status"
titleLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
titleLabel.TextSize = 14
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

local towerLabel = Instance.new("TextLabel")
towerLabel.Size = UDim2.new(1, -20, 0, 20)
towerLabel.Position = UDim2.new(0, 10, 0, 28)
towerLabel.BackgroundTransparency = 1
towerLabel.Text = "Tower: Loading..."
towerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
towerLabel.TextSize = 13
towerLabel.TextXAlignment = Enum.TextXAlignment.Left
towerLabel.Font = Enum.Font.SourceSans
towerLabel.Parent = mainFrame

local floorLabel = Instance.new("TextLabel")
floorLabel.Size = UDim2.new(1, -20, 0, 20)
floorLabel.Position = UDim2.new(0, 10, 0, 48)
floorLabel.BackgroundTransparency = 1
floorLabel.Text = "Floor: 0 | Round: 0/2"
floorLabel.TextColor3 = Color3.fromRGB(150, 255, 150)
floorLabel.TextSize = 13
floorLabel.TextXAlignment = Enum.TextXAlignment.Left
floorLabel.Font = Enum.Font.SourceSans
floorLabel.Parent = mainFrame

local rollLabel = Instance.new("TextLabel")
rollLabel.Size = UDim2.new(1, -20, 0, 20)
rollLabel.Position = UDim2.new(0, 10, 0, 68)
rollLabel.BackgroundTransparency = 1
rollLabel.Text = "Auto Roll: Active"
rollLabel.TextColor3 = Color3.fromRGB(255, 220, 100)
rollLabel.TextSize = 13
rollLabel.TextXAlignment = Enum.TextXAlignment.Left
rollLabel.Font = Enum.Font.SourceSans
rollLabel.Parent = mainFrame

local potionLabel = Instance.new("TextLabel")
potionLabel.Size = UDim2.new(1, -20, 0, 20)
potionLabel.Position = UDim2.new(0, 10, 0, 88)
potionLabel.BackgroundTransparency = 1
potionLabel.Text = "Auto Potion: Active"
potionLabel.TextColor3 = Color3.fromRGB(255, 150, 200)
potionLabel.TextSize = 13
potionLabel.TextXAlignment = Enum.TextXAlignment.Left
potionLabel.Font = Enum.Font.SourceSans
potionLabel.Parent = mainFrame

local fpsLabel = Instance.new("TextLabel")
fpsLabel.Size = UDim2.new(1, -20, 0, 20)
fpsLabel.Position = UDim2.new(0, 10, 0, 108)
fpsLabel.BackgroundTransparency = 1
fpsLabel.Text = "FPS Boost: Active (Effects Off)"
fpsLabel.TextColor3 = Color3.fromRGB(100, 255, 200)
fpsLabel.TextSize = 13
fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
fpsLabel.Font = Enum.Font.SourceSans
fpsLabel.Parent = mainFrame

local afkLabel = Instance.new("TextLabel")
afkLabel.Size = UDim2.new(1, -20, 0, 20)
afkLabel.Position = UDim2.new(0, 10, 0, 128)
afkLabel.BackgroundTransparency = 1
afkLabel.Text = "Anti-AFK & AutoExec: Enabled"
afkLabel.TextColor3 = Color3.fromRGB(200, 150, 255)
afkLabel.TextSize = 13
afkLabel.TextXAlignment = Enum.TextXAlignment.Left
afkLabel.Font = Enum.Font.SourceSans
afkLabel.Parent = mainFrame

local currentTowerDisplay = "None"
local currentFloorDisplay = 0
local currentRoundDisplay = 0

task.spawn(function()
    while true do
        task.wait(0.5)

        pcall(function()
            towerLabel.Text = "Tower: " .. currentTowerDisplay

            floorLabel.Text =
                "Floor: " .. tostring(currentFloorDisplay)
                .. " | Round: " .. tostring(currentRoundDisplay)
                .. "/2"
        end)
    end
end)

-- Data helpers
local function rebirth()
    local ok, v = pcall(function()
        return DC.Rebirth()
    end)

    return ok and (tonumber(v) or 0) or 0
end

local function slots()
    local ok, v = pcall(function()
        return DC.Slots()
    end)

    return (ok and type(v) == "table") and v or {}
end

local function inventory()
    local ok, v = pcall(function()
        return DC.Inventory()
    end)

    return (ok and type(v) == "table") and v or {}
end

local function unlockedSlots()
    local list, s = {}, slots()
    local maxS = 14

    pcall(function()
        maxS = PlotConfig.GetMaxSlots()
    end)

    local rb = rebirth()

    for i = 1, maxS do
        local req = 0

        pcall(function()
            req = PlotConfig.GetSlotRebirthRequirement(i)
        end)

        if rb >= req then
            table.insert(list, i)
        end
    end

    return list, s
end

local isRunning = true

-- Auto Roll
task.spawn(function()
    local rollSig = getSig("RollService", "SetAutoRoll")

    if rollSig then
        pcall(function()
            rollSig:Fire(true)
        end)
    end
end)

--==================================================
-- AUTO POTION SYSTEM
--==================================================

local POTION_LIST_URL =
    "https://raw.githubusercontent.com/arounxaillhc-cyber/RobloxScript/refs/heads/main/namePotion.txt"

local PotionCatalog = {}
local potionBusy = false

-- Load namePotion.txt
local function loadPotionCatalog()
    local ok, raw = pcall(function()
        return game:HttpGet(POTION_LIST_URL)
    end)

    if not ok or type(raw) ~= "string" then
        warn("[Potion] Failed to load namePotion.txt:", tostring(raw))
        return false
    end

    local catalog = {}
    local current = {}

    local function saveCurrent()
        if current.Name
            and current.Category
            and tonumber(current.Tier) then

            catalog[current.Name] = {
                category = current.Category,
                tier = tonumber(current.Tier)
            }
        end

        current = {}
    end

    for line in raw:gmatch("[^\r\n]+") do
        local key, value =
            line:match("^%s*([%a]+):%s*(.-)%s*$")

        if key == "Name" then
            saveCurrent()
            current.Name = value

        elseif key == "Category" then
            current.Category = value

        elseif key == "Tier" then
            current.Tier = value
        end
    end

    saveCurrent()

    if next(catalog) == nil then
        warn("[Potion] No potion data found")
        return false
    end

    PotionCatalog = catalog

    local count = 0
    for _ in pairs(catalog) do
        count += 1
    end

    print("[Potion] Loaded", count, "potion entries")

    return true
end

-- Get category and tier
local function getPotionInfo(name)
    local listed = PotionCatalog[name]

    if not listed then
        return nil
    end

    local cfg = BoostConfig
        and BoostConfig.entries
        and BoostConfig.entries[name]

    return {
        category = (cfg and cfg.category) or listed.category,
        tier = tonumber(cfg and cfg.tier) or listed.tier
    }
end

-- Calculate remaining potion duration
local function potionLeft(entry)
    if not entry or type(entry) ~= "table" then
        return 0
    end

    if type(entry.startedAt) == "number"
        and type(entry.remaining) == "number" then

        local now = 0

        pcall(function()
            now = workspace:GetServerTimeNow()
        end)

        return math.max(
            0,
            entry.remaining - math.max(0, now - entry.startedAt)
        )
    end

    if type(entry.expiresAt) == "number" then
        local now = 0

        pcall(function()
            now = os.time()
        end)

        return math.max(0, entry.expiresAt - now)
    end

    if type(entry.remaining) == "number" then
        return math.max(0, entry.remaining)
    end

    return 1e9
end

-- Get active potions by category
local function activePotionsByCategory()
    local active = {}

    local ok, activeEntries = pcall(function()
        return DC.ActiveEntries()
    end)

    if not ok or type(activeEntries) ~= "table" then
        return active
    end

    for name, entry in pairs(activeEntries) do
        local potionName = tostring(name)
        local remaining = potionLeft(entry)

        if remaining > 3 then
            local info = getPotionInfo(potionName)

            if not info then
                local cfg = BoostConfig
                    and BoostConfig.entries
                    and BoostConfig.entries[potionName]

                if cfg then
                    info = {
                        category = cfg.category,
                        tier = tonumber(cfg.tier) or 0
                    }
                end
            end

            if info and info.category then
                local category = info.category
                local tier = tonumber(info.tier) or 0

                if not active[category]
                    or tier > active[category].tier then

                    active[category] = {
                        name = potionName,
                        tier = tier,
                        remaining = remaining
                    }
                end
            end
        end
    end

    return active
end

-- Get owned potions from inventory
local function getOwnedPotions()
    local owned = {}

    for key, entry in pairs(inventory()) do
        if type(entry) == "table"
            and entry.name
            and (tonumber(entry.amount) or 0) >= 1 then

            local name = tostring(entry.name)
            local info = getPotionInfo(name)

            if info then
                table.insert(owned, {
                    name = name,
                    category = info.category,
                    tier = info.tier,
                    key = key,
                    amount = tonumber(entry.amount) or 0
                })
            end
        end
    end

    return owned
end

-- Select highest owned tier in each category
local function getBestPotions()
    local best = {}

    for _, potion in ipairs(getOwnedPotions()) do
        local category = potion.category

        if not best[category]
            or potion.tier > best[category].tier then

            best[category] = potion
        end
    end

    return best
end

-- Use potion only if it improves active tier
local function doPotionTick()
    if potionBusy then
        return
    end

    if not BoostConfig or not BoostConfig.entries then
        return
    end

    if next(PotionCatalog) == nil then
        loadPotionCatalog()

        if next(PotionCatalog) == nil then
            return
        end
    end

    potionBusy = true

    local ok, err = pcall(function()
        local bestPotions = getBestPotions()
        local activePotions = activePotionsByCategory()

        local boostSig = getSig("BoostService", "Use")

        if not boostSig then
            return
        end

        for category, bestPotion in pairs(bestPotions) do
            local currentActive = activePotions[category]

            local activeTier = currentActive
                and currentActive.tier
                or 0

            if bestPotion.tier > activeTier then
                print(
                    "[Potion] Using:",
                    bestPotion.name,
                    "| Category:",
                    category,
                    "| Tier:",
                    bestPotion.tier,
                    "| Active Tier:",
                    activeTier
                )

                local used = pcall(function()
                    boostSig:Fire(bestPotion.key)
                end)

                if used then
                    task.wait(0.5)
                end
            else
                print(
                    "[Potion] Skipped:",
                    category,
                    "| Owned Tier:",
                    bestPotion.tier,
                    "| Active Tier:",
                    activeTier
                )
            end
        end
    end)

    if not ok then
        warn("[Potion] Error:", tostring(err))
    end

    potionBusy = false
end

-- Start Auto Potion
task.spawn(function()
    loadPotionCatalog()

    while isRunning do
        task.wait(3)

        if next(PotionCatalog) == nil then
            loadPotionCatalog()
        end

        doPotionTick()
    end
end)

--==================================================
-- END AUTO POTION SYSTEM
--==================================================

-- Auto Collect
local collectDelay = 20

local function doCollect()
    local sig = getSig("PlotService", "CollectBalance")

    if not sig then
        return
    end

    local list, s = unlockedSlots()

    for _, slot in ipairs(list) do
        if not isRunning then
            break
        end

        local d = s[tostring(slot)]
        local amt = d and (tonumber(d.balance) or 0) or 0

        if amt > 0 then
            pcall(function()
                sig:Fire(slot)
            end)

            task.wait(0.15)
        end
    end
end

task.spawn(function()
    while isRunning do
        task.wait(collectDelay)
        pcall(doCollect)
    end
end)

-- Tower system
local towerNames = {
    "Dragon Tower",
    "Cursed Tower",
    "Pirate Tower",
    "Hidden Leaf Tower",
    "Infinity Tower"
}

pcall(function()
    local all = TowersMod.GetAll()
    local tmp = {}

    for k in pairs(all) do
        table.insert(tmp, k)
    end

    table.sort(tmp, function(a, b)
        local oa, ob = 99, 99

        pcall(function()
            oa = TowersMod.Get(a).order or 99
        end)

        pcall(function()
            ob = TowersMod.Get(b).order or 99
        end)

        return oa < ob
    end)

    if #tmp > 0 then
        towerNames = tmp
    end
end)

local function handleTowerSeq(seq)
    local done = false

    for _, act in ipairs(seq) do
        if type(act) == "table" then
            if act.action == "floorStarted"
                and tonumber(act.floor) then

                currentFloorDisplay = tonumber(act.floor)

            elseif act.action == "ended" then
                done = true
                break
            end
        end
    end

    return done
end

local function driveTower(step)
    local done, fails = false, 0

    while isRunning and not done do
        local ok, seq = pcall(step)

        if not ok then
            warn("[Tower Log] Step Error Details:", tostring(seq))
        end

        if ok and type(seq) == "table" then
            if #seq > 0 then
                fails = 0
                done = handleTowerSeq(seq)
            else
                task.wait(0.25)
            end
        else
            fails = fails + 1

            if fails >= 8 then
                done = true
            end

            task.wait(1)
        end
    end
end

task.spawn(function()
    local play = getFn("Towers", "PlayTower")
    local step = getFn("Towers", "CompleteTowerFloor")
    local equipBest = getSig("Towers", "EquipBestTowerTeam")

    if not play or not step then
        return
    end

    while isRunning do
        for _, towerName in ipairs(towerNames) do
            if not isRunning then
                break
            end

            currentTowerDisplay = towerName

            for round = 1, 2 do
                if not isRunning then
                    break
                end

                currentRoundDisplay = round
                currentFloorDisplay = 1

                if equipBest then
                    pcall(function()
                        equipBest:Fire()
                    end)

                    task.wait(0.5)
                end

                local okStart, started = pcall(play, towerName)

                if okStart and started then
                    driveTower(step)
                else
                    local okP, seq = pcall(step)

                    if okP and type(seq) == "table" and #seq > 0 then
                        handleTowerSeq(seq)
                    else
                        task.wait(3)
                    end
                end

                task.wait(2)
            end
        end

        task.wait(5)
    end
end)
