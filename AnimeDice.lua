local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local TS = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer

if game.PlaceId ~= 113290951185459 then
    error("[Anime Dice] This script only works in Anime Dice.", 0)
end

local AUTOEXEC_CODE = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/arounxaillhc-cyber/RobloxScript/refs/heads/main/AnimeDice.lua"))()]]

local function armReexec()
    local q = queue_on_teleport or queueonteleport
    if typeof(q) == "function" then
        pcall(q, AUTOEXEC_CODE)
    end
end
pcall(armReexec)

local Network = require(RS.Packages.Network)
local DC = require(RS.Framework.Features.Data.DataController)
local PlotConfig = require(RS.Framework.Features.Plot.PlotConfig)
local TowersMod = require(RS.Framework.Features.Towers.Towers)
local BoostConfig = require(RS.Framework.Features.Inventory.Kinds.Boost.BoostConfig)
local EntryRegistry = require(RS.Framework.Features.Inventory.EntryRegistry)

local function svcComm(svc) return Network.ClientComm.new(RS.Network, false, svc) end
local function getSig(svc, name)
    local ok, s = pcall(function() return svcComm(svc):GetSignal(name) end)
    if ok and s then return s end
    return nil
end

local function getFn(svc, name)
    local ok, f = pcall(function() return svcComm(svc):GetFunction(name) end)
    if ok and f then return f end
    return nil
end

local afkConn = LocalPlayer.Idled:Connect(function()
    pcall(function()
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new())
    end)
end)

TS.TeleportInitFailed:Connect(function(_, _, msg)
    task.wait(3)
    pcall(function()
        TS:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end)

local fpsRestore = {}
local function applyFpsBoost()
    pcall(function()
        local s = getSig("SettingsService", "SetSetting")
        if s then s:Fire("Performance", true) end
    end)
    
    pcall(function()
        local L = game:GetService("Lighting")
        table.insert(fpsRestore, { o = L, p = "GlobalShadows", v = L.GlobalShadows })
        L.GlobalShadows = false
        table.insert(fpsRestore, { o = L, p = "FogEnd", v = L.FogEnd })
        L.FogEnd = 100000
    end)

    pcall(function()
        local T = workspace.Terrain
        table.insert(fpsRestore, { o = T, p = "WaterWaveSize", v = T.WaterWaveSize })
        table.insert(fpsRestore, { o = T, p = "WaterWaveSpeed", v = T.WaterWaveSpeed })
        table.insert(fpsRestore, { o = T, p = "Decoration", v = T.Decoration })
        T.WaterWaveSize = 0
        T.WaterWaveSpeed = 0
        T.Decoration = false
    end)

    for _, inst in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("Smoke") or inst:IsA("Fire") or inst:IsA("Sparkles") then
                if inst.Enabled then table.insert(fpsRestore, { o = inst, p = "Enabled", v = true }) inst.Enabled = false end
            elseif inst:IsA("BasePart") and not inst:IsA("Terrain") then
                if inst.CastShadow then table.insert(fpsRestore, { o = inst, p = "CastShadow", v = true }) inst.CastShadow = false end
            elseif inst:IsA("Decal") or inst:IsA("Texture") then
                if inst.Transparency < 1 then table.insert(fpsRestore, { o = inst, p = "Transparency", v = inst.Transparency }) inst.Transparency = 1 end
            end
        end)
    end
end

task.spawn(applyFpsBoost)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimeDiceStatusUI"
screenGui.ResetOnSpawn = false
pcall(function()
    screenGui.Parent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer.PlayerGui
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
potionLabel.Text = "Auto Money Potion: Active"
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
            floorLabel.Text = "Floor: " .. tostring(currentFloorDisplay) .. " | Round: " .. tostring(currentRoundDisplay) .. "/2"
        end)
    end
end)

local function rebirth() 
    local ok, v = pcall(function() return DC.Rebirth() end) 
    return ok and (tonumber(v) or 0) or 0 
end

local function slots() 
    local ok, v = pcall(function() return DC.Slots() end) 
    return (ok and type(v) == "table") and v or {} 
end

local function inventory() 
    local ok, v = pcall(function() return DC.Inventory() end) 
    return (ok and type(v) == "table") and v or {} 
end

local function unlockedSlots()
    local list, s = {}, slots()
    local maxS = 14
    pcall(function() maxS = PlotConfig.GetMaxSlots() end)
    local rb = rebirth()
    for i = 1, maxS do
        local req = 0
        pcall(function() req = PlotConfig.GetSlotRebirthRequirement(i) end)
        if rb >= req then table.insert(list, i) end
    end
    return list, s
end

local isRunning = true

task.spawn(function()
    local rollSig = getSig("RollService", "SetAutoRoll")
    if rollSig then
        pcall(function() rollSig:Fire(true) end)
    end
end)

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

local collectDelay = 20

local function doCollect()
    local sig = getSig("PlotService", "CollectBalance")
    if not sig then return end
    local list, s = unlockedSlots()
    for _, slot in ipairs(list) do
        if not isRunning then break end
        local d = s[tostring(slot)]
        local amt = d and (tonumber(d.balance) or 0) or 0
        if amt > 0 then
            pcall(function() sig:Fire(slot) end)
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

local towerNames = { "Dragon Tower", "Cursed Tower", "Pirate Tower", "Hidden Leaf Tower", "Infinity Tower" }
pcall(function()
    local all = TowersMod.GetAll()
    local tmp = {}
    for k in pairs(all) do table.insert(tmp, k) end
    table.sort(tmp, function(a, b)
        local oa, ob = 99, 99
        pcall(function() oa = TowersMod.Get(a).order or 99 end)
        pcall(function() ob = TowersMod.Get(b).order or 99 end)
        return oa < ob
    end)
    if #tmp > 0 then towerNames = tmp end
end)

local function handleTowerSeq(seq)
    local done = false
    for _, act in ipairs(seq) do
        if type(act) == "table" then
            if act.action == "floorStarted" and tonumber(act.floor) then
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
        if ok and type(seq) == "table" then
            if #seq > 0 then
                fails = 0
                done = handleTowerSeq(seq)
            else
                task.wait(0.25)
            end
        else
            fails = fails + 1
            if fails >= 8 then done = true end
            task.wait(1)
        end
    end
end

task.spawn(function()
    local play = getFn("Towers", "PlayTower")
    local step = getFn("Towers", "CompleteTowerFloor")
    local equipBest = getSig("Towers", "EquipBestTowerTeam")

    if not play or not step then return end

    while isRunning do
        for _, towerName in ipairs(towerNames) do
            if not isRunning then break end
            currentTowerDisplay = towerName
            
            for round = 1, 2 do
                if not isRunning then break end
                currentRoundDisplay = round
                currentFloorDisplay = 1

                if equipBest then
                    pcall(function() equipBest:Fire() end)
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
