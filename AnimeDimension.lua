repeat
    wait()
until game:IsLoaded()

repeat
    wait()
until game:GetService("Players").LocalPlayer ~= nil

if not game:GetService("Players").LocalPlayer.Character then
    game:GetService("Players").LocalPlayer.CharacterAdded:Wait()
    wait()
end

game.Players.LocalPlayer:WaitForChild("PlayerGui")
wait(0.7)
if not shared.AutoLoad then
    shared.AutoLoad = true
    queue_on_teleport("loadstring(game:HttpGet('https://raw.githubusercontent.com/arounxaillhc-cyber/RobloxScript/refs/heads/main/AnimeDimension.lua'))()")

    if game.PlaceId == 6938803436 or game.PlaceId == 6990129309 or game.PlaceId == 6990133340 or game.PlaceId == 6990131029 or game.PlaceId == 7338881230 or game.PlaceId == 7274690025 then
        local function fn()
            local tbl = {}
            local n = -1
            local now = tick()
            local n2, n3, n4, n5

            repeat
                wait(0.25)
                tbl = {}

                pcall(function()
                    for k, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayFrame.Frame.PlayRoomFrame.MapSelectionScrollingFrame:GetChildren()) do
                        if child.ClassName == "ImageButton" and child.Name ~= "MapSelectionTemplate" then
                            table.insert(tbl, child.Name)
                        end
                    end
                end)

                if #tbl > 0 and #tbl == n then
                    n2 = #tbl
                    if tick() - now > 30 then
                        return tbl
                    end
                    wait(0.25)
                    tbl = {}

                    pcall(function()
                        for k, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayFrame.Frame.PlayRoomFrame.MapSelectionScrollingFrame:GetChildren()) do
                            if child.ClassName == "ImageButton" and child.Name ~= "MapSelectionTemplate" then
                                table.insert(tbl, child.Name)
                            end
                        end
                    end)

                    if #tbl > 0 and #tbl == n2 then
                        n3 = #tbl
                        if tick() - now > 30 then
                            return tbl
                        end
                        wait(0.25)
                        tbl = {}

                        pcall(function()
                            for k, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayFrame.Frame.PlayRoomFrame.MapSelectionScrollingFrame:GetChildren()) do
                                if child.ClassName == "ImageButton" and child.Name ~= "MapSelectionTemplate" then
                                    table.insert(tbl, child.Name)
                                end
                            end
                        end)

                        if #tbl > 0 and #tbl == n3 then
                            n4 = #tbl
                            if tick() - now > 30 then
                                return tbl
                            end
                            wait(0.25)
                            tbl = {}

                            pcall(function()
                                for k, child in pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayFrame.Frame.PlayRoomFrame.MapSelectionScrollingFrame:GetChildren()) do
                                    if child.ClassName == "ImageButton" and child.Name ~= "MapSelectionTemplate" then
                                        table.insert(tbl, child.Name)
                                    end
                                end
                            end)

                            if #tbl > 0 and #tbl == n4 then
                                n5 = #tbl
                                return tbl
                            end
                        end
                    end
                end

                n = #tbl
            until tick() - now > 30

            return tbl
        end

        if game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 then
            if game.PlaceId == 7338881230 then
                local v2 = fn()
                RaidSelection = v2
            end
        else
            MapSelection = {"TimeChallenge"}

            for i, v2 in ipairs(fn()) do
                table.insert(MapSelection, v2)
            end
        end

        local lib = (function()
                local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
                local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
                local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

                local Window
                local usedIds = {}
                local TabIcons = {
                    Main = "swords",
                    More = "layers",
                    Character = "user",
                    Setting = "sliders-horizontal",
                    Buy = "shopping-cart",
                    Misc = "wrench",
                }

                local function safe(callback, ...)
                    pcall(callback, ...)
                end

                local function makeId(scope, name)
                    local base = (scope .. "_" .. name):gsub("%s+", "")
                    local id = base
                    local n = 1
                    while usedIds[id] do
                        n = n + 1
                        id = base .. "_" .. n
                    end
                    usedIds[id] = true
                    return id
                end

                local function pretty(name)
                    local s = name:gsub("%s*%(OnlyNumber%)", "")
                    s = s:gsub("(%l)(%u)", "%1 %2")
                    s = s:gsub("(%d)(%u)", "%1 %2")
                    s = s:gsub("(%w)%(", "%1 (")
                    return s
                end

                local function bind(option, callback, convert)
                    local fired = false
                    local function handler(value)
                        fired = true
                        if value == nil then
                            return
                        end
                        if convert then
                            value = convert(value)
                        end
                        safe(callback, value)
                    end
                    option:OnChanged(handler)
                    if not fired then
                        handler(option.Value)
                    end
                end

                local Sector = {}
                Sector.__index = Sector

                function Sector:AddToggle(name, default, callback)
                    local toggle = self.section:AddToggle(makeId(self.scope, name), {
                        Title = pretty(name),
                        Default = default == true,
                    })
                    bind(toggle, callback)
                    return toggle
                end

                function Sector:AddDropdown(name, values, default, multi, callback)
                    local config = {
                        Title = pretty(name),
                        Values = values or {},
                        Multi = multi == true,
                    }
                    if multi then
                        config.Default = {}
                    elseif type(default) == "string" then
                        config.Default = table.find(config.Values, default)
                    end
                    local dropdown = self.section:AddDropdown(makeId(self.scope, name), config)
                    bind(dropdown, callback, multi and function(value)
                        local selected = {}
                        for key, state in pairs(value) do
                            if state then
                                table.insert(selected, key)
                            end
                        end
                        table.sort(selected)
                        return selected
                    end or nil)
                    return dropdown
                end

                function Sector:AddTextbox(name, default, callback)
                    local input = self.section:AddInput(makeId(self.scope, name), {
                        Title = pretty(name),
                        Default = tostring(default or ""),
                        Placeholder = "Type here...",
                        Numeric = name:find("OnlyNumber", 1, true) ~= nil,
                        Finished = false,
                    })
                    bind(input, function(value)
                        if value ~= "" then
                            callback(value)
                        end
                    end)
                    return input
                end

                function Sector:AddButton(name, callback)
                    return self.section:AddButton({
                        Title = pretty(name),
                        Callback = function()
                            safe(callback)
                        end,
                    })
                end

                function Sector:AddLabel(text)
                    return self.section:AddParagraph({
                        Title = tostring(text),
                        Content = "",
                    })
                end

                local Tab = {}
                Tab.__index = Tab

                function Tab:CreateSector(name)
                    return setmetatable({
                        section = self.tab:AddSection(name),
                        scope = self.name .. "_" .. name,
                    }, Sector)
                end

                local lib = {}

                function lib:CreateWindow()
                    Window = Fluent:CreateWindow({
                        Title = "Anime Dimensions",
                        SubTitle = "Auto Farm",
                        TabWidth = 150,
                        Size = UDim2.fromOffset(580, 440),
                        Acrylic = false,
                        Theme = "Dark",
                        MinimizeKey = Enum.KeyCode.RightControl,
                    })
                    return self
                end

                function lib:CreateTab(name)
                    local ok, tab = pcall(Window.AddTab, Window, {Title = name, Icon = TabIcons[name] or ""})
                    if not ok or not tab then
                        tab = Window:AddTab({Title = name, Icon = ""})
                    end
                    return setmetatable({tab = tab, name = name}, Tab)
                end

                function lib:ToggleGui()
                    Window:Minimize()
                end

                function lib:Finish(configName)
                    SaveManager:SetLibrary(Fluent)
                    InterfaceManager:SetLibrary(Fluent)
                    SaveManager:IgnoreThemeSettings()
                    SaveManager:SetIgnoreIndexes({})
                    InterfaceManager:SetFolder("AnimeDimensions")
                    SaveManager:SetFolder("AnimeDimensions/configs")

                    local settingsTab = Window:AddTab({Title = "Settings", Icon = "settings"})
                    InterfaceManager:BuildInterfaceSection(settingsTab)
                    SaveManager:BuildConfigSection(settingsTab)
                    Window:SelectTab(1)

                    pcall(function()
                        SaveManager:Load(configName)
                    end)

                end

                function lib:SaveConfig(configName)
                    SaveManager:Save(configName)
                end


                return lib
            end)()
        local v2 = lib:CreateWindow("Anime Dimensions")
        local Main = v2:CreateTab("Main")
        local Farming = Main:CreateSector("Farming", "left")

        Farming:AddDropdown("MapSelection(AutoUpdate!)", MapSelection, false, false, function(mapSelection)
            _G.MapSelection = mapSelection
        end)

        Farming:AddDropdown("SelectDifficulty", {"Easy", "Hard", "Nightmare"}, false, false, function(difficulty)
            _G.Difficulty = difficulty
        end)

        Farming:AddTextbox("WaitOnLobbyAfterJoin(OnlyNumber)", "10", function(cooldownOnlobby)
            _G.CooldownOnlobby = cooldownOnlobby
        end)

        Farming:AddToggle("AutoPlay", false, function(autoPlay)
            _G.AutoPlay = autoPlay
        end)

        Farming:AddToggle("Hardcore", false, function(hardcore)
            _G.Hardcore = hardcore
        end)

        Farming:AddToggle("AutoReplay", false, function(replay)
            _G.Replay = replay
        end)

        Farming:AddToggle("FriendOnly", false, function(friendOnly)
            _G.FriendOnly = friendOnly
        end)

        Farming:AddToggle("AutoSelectMap(DetectedLevel)", false, function(autoSelectMap)
            _G.AutoSelectMap = autoSelectMap
        end)

        local InGame = Main:CreateSector("InGame", "Right")

        InGame:AddDropdown("Method", {"Behind", "Front", "Over", "Under"}, "Behind", false, function(method)
            _G.Method = method
        end)

        InGame:AddTextbox("ImportDistance(OnlyNumber)", "7", function(arg)
            _G.Distance = tonumber(arg)
        end)

        InGame:AddTextbox("TweenSpeed(OnlyNumber)", "500", function(twSpeed)
            _G.TWSpeed = twSpeed
        end)

        InGame:AddToggle("AutoMob", true, function(automob)
            _G.Automob = automob
        end)

        InGame:AddToggle("Kill Aura(Only ExtremeDimension)", false, function(autoKill)
            _G.AutoKill = autoKill
        end)

        InGame:AddTextbox("DistanceToSkill(OnlyNumber)", "30", function(arg)
            _G.DistanceToSkill = tonumber(arg)
        end)

        InGame:AddToggle("AutoSkill", true, function(autoSkill)
            _G.AutoSkill = autoSkill
        end)

        InGame:AddToggle("AutoAssistSkill", true, function(autoAssistSkill)
            _G.AutoAssistSkill = autoAssistSkill
        end)

        InGame:AddToggle("AutoFruitSkill", true, function(autoFruitSkill)
            _G.AutoFruitSkill = autoFruitSkill
        end)

        InGame:AddDropdown("SelectAttackMethod", {"Remote", "Click"}, "Click", false, function(selectAttackMethod)
            _G.SelectAttackMethod = selectAttackMethod
        end)

        InGame:AddToggle("AutoMelee", true, function(autoMelee)
            _G.AutoMelee = autoMelee
        end)

        local More = v2:CreateTab("More")
        local JoiningCombo = More:CreateSector("JoiningCombo", "left")
        JoiningCombo:AddLabel("JoinRaidLobby To ShowRaid", true)

        JoiningCombo:AddDropdown("RaidSelection", RaidSelection, false, false, function(raidSelection)
            _G.RaidSelection = raidSelection
        end)

        JoiningCombo:AddDropdown("SelectExtremeDimensionDifficulty", {"Easy", "Normal", "Nightmare", "Extreme"}, "Extreme", false, function(difficultyExtremeDimension)
            _G.DifficultyExtremeDimension = difficultyExtremeDimension
        end)

        JoiningCombo:AddDropdown("ExtremeDimensionMinReward(%)", {"100", "75", "50", "25", "15"}, "15", false, function(extremeDimensionMinReward)
            _G.ExtremeDimensionMinReward = extremeDimensionMinReward
        end)

        JoiningCombo:AddTextbox("Cooldown JoinRaid(OnlyNumber)", "10", function(waitonJoinRiad)
            _G.waitonJoinRiad = waitonJoinRiad
        end)

        JoiningCombo:AddToggle("AutoRaid", false, function(autoRaid)
            _G.AutoRaid = autoRaid
        end)

        JoiningCombo:AddToggle("FreeBossRush", false, function(freeBossRush)
            _G.FreeBossRush = freeBossRush
        end)

        JoiningCombo:AddToggle("BossRush", false, function(bossRush)
            _G.BossRush = bossRush
        end)

        JoiningCombo:AddToggle("AutoSpeedRaid(RandomSelect)", false, function(autoSpeedRaid)
            _G.AutoSpeedRaid = autoSpeedRaid
        end)

        JoiningCombo:AddToggle("AutoRaidChallenge(IfRewardAvailable)", false, function(autoRaidChallenge)
            _G.AutoRaidChallenge = autoRaidChallenge
        end)

        JoiningCombo:AddToggle("ExtremeDimension(MinReward%)", false, function(autoExtremeDimension)
            _G.AutoExtremeDimension = autoExtremeDimension
        end)

        local MoreFunction = More:CreateSector("MoreFunction", "Right")

        MoreFunction:AddButton("Return To Lobby", function()
            game:GetService("TeleportService"):Teleport(6938803436)
        end)

        MoreFunction:AddToggle("AutoDodgeSkill", true, function(autoDodgeSkill)
            _G.AutoDodgeSkill = autoDodgeSkill
        end)

        MoreFunction:AddToggle("AutoDeleteMap", false, function(autoDeletemap)
            _G.AutoDeletemap = autoDeletemap
        end)

        MoreFunction:AddToggle("AutoRedeemAllCode", false, function(autoRedeemAllCode)
            _G.AutoRedeemAllCode = autoRedeemAllCode
        end)

        MoreFunction:AddToggle("BackToLobbyIfGotExploitsDetected", false, function(backToLobbyIfGotExploitsDetected)
            _G.BackToLobbyIfGotExploitsDetected = backToLobbyIfGotExploitsDetected
        end)

        MoreFunction:AddToggle("HideName", false, function(hideName)
            _G.HideName = hideName
        end)

        MoreFunction:AddToggle("DashNoCooldown", false, function(dashNoCooldown)
            _G.DashNoCooldown = dashNoCooldown
        end)

        MoreFunction:AddToggle("AutoWalk(Only Boss)", false, function(autoWalk)
            _G.AutoWalk = autoWalk
        end)

        MoreFunction:AddToggle("AutoClaimQuestAndReward", false, function(autoClaimQuestAndReward)
            _G.AutoClaimQuestAndReward = autoClaimQuestAndReward
        end)

        MoreFunction:AddDropdown("GoLobbyMethod", {"ResetCharacter", "TeleportToLobby"}, "TeleportToLobby", false, function(goLobbyMethod)
            _G.GoLobbyMethod = goLobbyMethod
        end)

        MoreFunction:AddToggle("BackToLobbyIfRaidOpen", false, function(onRaidOpen)
            _G.OnRaidOpen = onRaidOpen
        end)

        MoreFunction:AddToggle("StopReplayIfRaidOpen", false, function(stopReplay)
            _G.StopReplay = stopReplay
        end)

        MoreFunction:AddToggle("Disable Noclip", false, function(dontNoclip)
            _G.DontNoclip = dontNoclip
        end)

        MoreFunction:AddToggle("DoNotThingIfHavePlayer", false, function(doNotThingIfHavePlayer)
            _G.DoNotThingIfHavePlayer = doNotThingIfHavePlayer
        end)

        local tbl = {}

        Save_Config = function()
            writefile("Character_SLH.json", game:GetService("HttpService"):JSONEncode(tbl))

        end

        if isfile("Character_SLH.json") then
            tbl = game:GetService("HttpService"):JSONDecode(readfile("Character_SLH.json"))
        end

        local Character = v2:CreateTab("Character")
        local Character2 = Character:CreateSector("Character", "left")

        Character2:AddToggle("AutoEquip Character", false, function(autoEquipCharacter)
            _G.AutoEquipCharacter = autoEquipCharacter
        end)

        Character2:AddToggle("Auto Reset To Main", false, function(automainCharacter)
            _G.AutomainCharacter = automainCharacter
        end)

        Character2:AddToggle("Auto Reset To First Assist", false, function(autoAssist1)
            _G.AutoAssist1 = autoAssist1
        end)

        Character2:AddButton("SaveCharacter", function()
            local character1 = game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].CharacterName.Value
            tbl.Character1 = character1
            local character2 = game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName1.Value
            tbl.Character2 = character2
            local character3 = game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName2.Value
            tbl.Character3 = character3
            Save_Config()
        end)

        local SellCard = Character:CreateSector("SellCard", "Right")
        Cardtabel = {}

        SellCard:AddDropdown("SelectRarity", {"Common", "Uncommon", "Rare", "Epic", "Legendary"}, false, true, function(arg)
            Cardtabel = arg
        end)

        SellCard:AddToggle("AutoSellCard", false, function(autoSell)
            _G.AutoSell = autoSell
        end)

        local EquipCard = Character:CreateSector("EquipCard", "Right")

        EquipCard:AddToggle("EquipBestCard", false, function(equipBestCard)
            _G.EquipBestCard = equipBestCard
        end)

        EquipCard:AddDropdown("EquipBestCardMode", {"Damage/Crit", "HP"}, "Damage/Crit", false, function(equipBestCardMode)
            _G.EquipBestCardMode = equipBestCardMode
        end)

        local Setting = v2:CreateTab("Setting")
        local v3 = Setting:CreateSector("Setting DodgeSkill", "left")

        v3:AddTextbox("SizeDodgePart (OnlyNumber)", "3.5", function(sizeDodgePart)
            _G.SizeDodgePart = sizeDodgePart
        end)

        v3:AddTextbox("SizeDodgePart Y (OnlyNumber)", "100", function(sizeDodgePartY)
            _G.SizeDodgePartY = sizeDodgePartY
        end)

        v3:AddTextbox("TweenSpeedDodgePart (Sec)", "0.15", function(tweenDodgePart)
            _G.TweenDodgePart = tweenDodgePart
        end)

        v3:AddTextbox("DodgePartTransparency (OnlyNumber)", "0.9", function(dodgePartTransparency)
            _G.DodgePartTransparency = dodgePartTransparency
        end)

        local MoreFunction2 = Setting:CreateSector("MoreFunction2", "left")

        MoreFunction2:AddToggle("Go AFK (If Raid Not Open)", false, function(autoGoAFK)
            _G.AutoGoAFK = autoGoAFK
        end)

        MoreFunction2:AddTextbox("SelectWaveToReset", "100", function(selectWaveToEnd)
            _G.SelectWaveToEnd = selectWaveToEnd
        end)

        MoreFunction2:AddToggle("Reset INF Mode (SelectWave)", false, function(resetifWave)
            _G.ResetifWave = resetifWave
        end)

        local v4 = Setting:CreateSector("Setting AutoSkill", "Right")

        v4:AddDropdown("SkillFirst", {"1", "2", "3", "4", "5"}, "4", false, function(skill1)
            _G.skill1 = skill1
        end)

        v4:AddDropdown("SkillSecond", {"1", "2", "3", "4", "5"}, "3", false, function(skill2)
            _G.skill2 = skill2
        end)

        v4:AddDropdown("SkillThird", {"1", "2", "3", "4", "5"}, "5", false, function(skill3)
            _G.skill3 = skill3
        end)

        v4:AddDropdown("SkillFourth", {"1", "2", "3", "4", "5"}, "1", false, function(skill4)
            _G.skill4 = skill4
        end)

        v4:AddDropdown("SkillFifth", {"1", "2", "3", "4", "5"}, "2", false, function(skill5)
            _G.skill5 = skill5
        end)

        local AutoBuy = v2:CreateTab("Buy"):CreateSector("AutoBuy", "left")

        AutoBuy:AddDropdown("Select method buy", {"(Raid)", "(Gem)"}, false, false, function(methodbuy)
            _G.methodbuy = methodbuy
        end)

        AutoBuy:AddToggle("BuyRushTicket", false, function(buyRushTicket)
            _G.BuyRushTicket = buyRushTicket
        end)

        AutoBuy:AddToggle("Buy100RaidToken(BossRushToken)", false, function(buy100RaidToken)
            _G.Buy100RaidToken = buy100RaidToken
        end)

        spawn(function()
            pcall(function()
                while wait(1) do
                    pcall(function()
                        if _G.AutomainCharacter == true and _G.AutoAssist1 == false and _G.isonlobby == false and not isextreme then
                            local value = game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName1.Value
                            local value2 = game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName2.Value

                            if game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].BattleCharacterName.Value == value then
                                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                            elseif game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].BattleCharacterName.Value == value2 then
                                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(1) do
                    pcall(function()
                        if _G.AutoAssist1 == true and _G.AutomainCharacter == false and _G.isonlobby == false and not isextreme then
                            if game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.BossName.Text == "Shadow Shiro" or game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.BossName.Text == "Shadow Slime" or game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.BossName.Text == "Shadow Ramura" or game.workspace.Folders.Monsters:FindFirstChild("Shadow Red Emperor") or game.workspace.Folders.Monsters:FindFirstChild("Shadow Esper") or game.workspace.Folders.Monsters:FindFirstChild("Shadow Combat Titan") or game.workspace.Folders.Monsters:FindFirstChild("Shadow Esdeaf") or game.workspace.Folders.Monsters:FindFirstChild("Shadow Tengu") or game.workspace.Folders.Monsters:FindFirstChild("Shadow Yomiichi") then
                                return
                            end
                            local value = game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].CharacterName.Value
                            local value2 = game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName2.Value

                            if game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].BattleCharacterName.Value == value then
                                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                            elseif game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].BattleCharacterName.Value == value2 then
                                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if tonumber(os.date("!*t").min) <= 9 then
                            _G.RaidOpened = true
                        else
                            _G.RaidOpened = false
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.Enabled == true then
                            _G.isonlobby = true
                        else
                            _G.isonlobby = false
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if workspace.Folders.Monsters:GetChildren()[4].ExtremeDimension_NormalParticle then
                            isextreme = true
                        else
                            isextreme = false
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.WaveClearClearText.Visible == true and not isoninfmode then
                            _G.isoninfmode = true
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible == true and game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.BossName.Text == "Ghoul" and not game.workspace.Folders.Monsters:FindFirstChild("Koneki") then
                            game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible = false
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible == true and game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.BossName.Text == "Spear Guy" and not game.workspace.Folders.Monsters:FindFirstChild("Lance Guy") then
                            game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible = false
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible == true and game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.BossName.Text == "Reaper" and not game.workspace.Folders.Monsters:FindFirstChild("Reaper") then
                            game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible = false
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible == true and game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.BossName.Text == "Conductor" and not game.workspace.Folders.Monsters:FindFirstChild("Emmu") then
                            game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible = false
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(0.2) do
                    spawn(function()
                        if _G.BuyRushTicket == true and _G.methodbuy == "(Gem)" and _G.isonlobby == true then
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(unpack({"BuyBossRushShopItem", "Boss Rush Ticket (Gem)"}))
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(1) do
                    spawn(function()
                        if _G.BuyRushTicket == true and _G.methodbuy == "(Raid)" and _G.isonlobby == true then
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(unpack({"BuyBossRushShopItem", "Boss Rush Ticket (Raid)"}))
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(0.2) do
                    spawn(function()
                        if _G.Buy100RaidToken == true and _G.isonlobby == true then
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(unpack({"BuyBossRushShopItem", "100 Raid Tokens"}))
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if _G.AutoSelectMap == true then
                            Lvl = game.Players.LocalPlayer.leaderstats.Level.Value

                            if Lvl > 0 and Lvl < 6 then
                                _G.Difficulty = "Easy"
                                _G.MapSelection = "Titan Dimension"
                            elseif Lvl > 5 and Lvl < 11 then
                                _G.Difficulty = "Hard"
                                _G.MapSelection = "Titan Dimension"
                            elseif Lvl > 10 and Lvl < 16 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Titan Dimension"
                            elseif Lvl > 15 and Lvl < 21 then
                                _G.Difficulty = "Easy"
                                _G.MapSelection = "Demon Dimension"
                            elseif Lvl > 20 and Lvl < 26 then
                                _G.Difficulty = "Hard"
                                _G.MapSelection = "Demon Dimension"
                            elseif Lvl > 25 and Lvl < 31 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Demon Dimension"
                            elseif Lvl > 30 and Lvl < 36 then
                                _G.Difficulty = "Easy"
                                _G.MapSelection = "Curse Dimension"
                            elseif Lvl > 35 and Lvl < 41 then
                                _G.Difficulty = "Hard"
                                _G.MapSelection = "Curse Dimension"
                            elseif Lvl > 40 and Lvl < 46 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Curse Dimension"
                            elseif Lvl > 45 and Lvl < 51 then
                                _G.Difficulty = "Easy"
                                _G.MapSelection = "Villain Dimension"
                            elseif Lvl > 50 and Lvl < 56 then
                                _G.Difficulty = "Hard"
                                _G.MapSelection = "Villain Dimension"
                            elseif Lvl > 55 and Lvl < 61 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Villain Dimension"
                            elseif Lvl > 60 and Lvl < 68 then
                                _G.Difficulty = "Easy"
                                _G.MapSelection = "Sword Dimension"
                            elseif Lvl > 67 and Lvl < 76 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Sword Dimension"
                            elseif Lvl > 75 and Lvl < 83 then
                                _G.Difficulty = "Easy"
                                _G.MapSelection = "Ghoul Dimension"
                            elseif Lvl > 82 and Lvl < 91 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Ghoul Dimension"
                            elseif Lvl > 90 and Lvl < 98 then
                                _G.Difficulty = "Easy"
                                _G.MapSelection = "Fate Dimension"
                            elseif Lvl > 97 and Lvl < 106 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Fate Dimension"
                            elseif Lvl > 105 and Lvl < 113 then
                                _G.Difficulty = "Easy"
                                _G.MapSelection = "Slime Dimension"
                            elseif Lvl > 112 and Lvl < 121 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Slime Dimension"
                            elseif Lvl > 120 and Lvl < 131 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Devil Dimension"
                            elseif Lvl > 130 and Lvl < 141 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Pirate Dimension"
                            elseif Lvl > 140 and Lvl < 151 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Alien Dimension"
                            elseif Lvl > 150 and Lvl < 161 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Level Dimension"
                            elseif Lvl > 160 then
                                _G.Difficulty = "Nightmare"
                                _G.MapSelection = "Death Dimension"
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(1) do
                    pcall(function()
                        if _G.Replay == true and not isextreme and not DoneReset and game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.ResultUI.Visible == true then
                            wait(1)

                            if _G.RaidOpened ~= true or _G.StopReplay ~= true then
                                if game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.ResultUI.Frame.ResultLayout.RetryDungeonButton.Visible == true and game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.WaveClearClearText.Text ~= "1" then
                                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("RetryDungeon")
                                elseif game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.ResultUI.Frame.ResultLayout.RetryDungeonButton.Visible == true and game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.WaveClearClearText.Text == "1" then
                                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("RetryDungeon")
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        local v5 = nil

        local function fn3(arg)
            if not v5 then
                pcall(function()
                    for i, v6 in ipairs(getgc(false)) do
                        if type(v6) == "function" and islclosure(v6) and debug.getinfo(v6).name == "returnExtremeDimensionRewardPercent" then
                            v5 = v6
                            break
                        end
                    end
                end)
            end

            local ok, result = pcall(v5, arg)
            if ok and tonumber(result) then
                return tonumber(result)
            end

            if arg <= 3 then
                return 100
            end

            if arg <= 6 then
                return 75
            end

            if arg <= 9 then
                return 50
            end

            if arg <= 14 then
                return 25
            end
            return 15
        end

        spawn(function()
            pcall(function()
                local value = nil
                local flag = false

                while wait(1) do
                    pcall(function()
                        local exDimRewardClaimed = game.ReplicatedStorage[game.Players.LocalPlayer.Name .. "StatDisplay"].Ex_Dim_Reward_Claimed
                        local resultUI = game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.ResultUI

                        if resultUI.Visible == false then
                            flag = false

                            if #workspace.Folders.Monsters:GetChildren() > 0 then
                                value = exDimRewardClaimed.Value
                            end

                            return
                        end

                        if flag then
                            return
                        end
                        flag = true
                        if _G.Replay ~= true or not isextreme or DoneReset then
                            return
                        end

                        if _G.RaidOpened == true and _G.StopReplay == true then
                            return
                        end
                        wait(6)
                        local max = math.max
                        local value2 = exDimRewardClaimed.Value
                        local v6 = value
                        local value3 = v6 or exDimRewardClaimed.Value
                        local v7 = fn3(max(value2, value3 + 1) + 1)
                        local num = tonumber(_G.ExtremeDimensionMinReward)
                        local n = num or 15

                        if n <= v7 and resultUI.Visible == true and resultUI.Frame.ResultLayout.RetryDungeonButton.Visible == true then
                            game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("RetryDungeon")
                        end
                    end)
                end
            end)
        end)

        local function fn4()
            local huge = math.huge
            local v6 = nil
            local v7 = next
            local children, v8 = workspace.Folders.Monsters:GetChildren()

            for k, v9 in v7, children, v8 do
                if v9:FindFirstChildOfClass("BillboardGui") and v9.EnemyHealthBarGui.Enabled == false then
                    local magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v9.HumanoidRootPart.Position).magnitude

                    if magnitude < huge then
                        huge = magnitude
                        v6 = v9
                    end
                end
            end

            return v6
        end

        local function fn5()
            local huge = math.huge
            local v6 = nil
            local v7 = next
            local children, v8 = workspace.Folders.Monsters:GetChildren()

            for k, v9 in v7, children, v8 do
                if v9:FindFirstChildOfClass("BillboardGui") then
                    local magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v9.HumanoidRootPart.Position).magnitude

                    if magnitude < huge then
                        huge = magnitude
                        v6 = v9
                    end
                end
            end

            return v6
        end

        local function fn6()
            local position = fn5().HumanoidRootPart.Position
            local position2 = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
            local vector = Vector3.new(position2.X - position.X, 0, position2.Z - position.Z)
            local vector2 = vector

            if vector.Magnitude < 0.1 then
                vector2 = Vector3.new(0, 0, 1)
            end

            return CFrame.new(position + vector2.Unit * 4, position)
        end

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if tonumber(#game.Players:GetPlayers()) > 1 then
                            _G.CheckPlayer = true
                        else
                            _G.CheckPlayer = false
                        end
                    end)
                end
            end)
        end)

        walk = function(arg)
            if _G.isonlobby ~= false or _G.DoNotThingIfHavePlayer ~= true or _G.CheckPlayer ~= true then
                game.Players.LocalPlayer.Character.Humanoid.WalkToPoint = arg.HumanoidRootPart.Position
            end
        end

        Tween = function(arg)
            if _G.isonlobby ~= false or _G.DoNotThingIfHavePlayer ~= true or _G.CheckPlayer ~= true then
                game:GetService("TweenService"):Create(game.Players.LocalPlayer.Character.HumanoidRootPart, TweenInfo.new((fn5().HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude / tonumber(_G.TWSpeed), Enum.EasingStyle.Linear), {CFrame = arg}):Play()
            end
        end

        melee = function()
            if _G.AutoMelee == true then
                if _G.SelectAttackMethod == "Remote" then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6(), attackNumber = 1, combo = 1}, "BasicAttack")
                elseif _G.SelectAttackMethod == "Click" then
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 1)
                    game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 1)
                end
            end
        end

        skill = function()
            if _G.AutoSkill == true then
                if _G.skill1 == "5" and game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.Skill5.Visible == true and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill1].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill1))
                elseif _G.skill1 ~= "5" and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill1].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill1))
                elseif _G.skill2 == "5" and game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.Skill5.Visible == true and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill2].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill2))
                elseif _G.skill2 ~= "5" and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill2].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill2))
                elseif _G.skill3 == "5" and game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.Skill5.Visible == true and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill3].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill3))
                elseif _G.skill3 ~= "5" and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill3].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill3))
                elseif _G.skill4 == "5" and game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.Skill5.Visible == true and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill4].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill4))
                elseif _G.skill4 ~= "5" and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill4].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill4))
                elseif _G.skill5 == "5" and game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.Skill5.Visible == true and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill5].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill5))
                elseif _G.skill5 ~= "5" and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder["Skill" .. _G.skill5].SkillName.Text) == nil then
                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseSkill", {hrpCFrame = fn6()}, tonumber(_G.skill5))
                end
            end
        end

        skillmelee = function()
            if _G.AutoSkill == true and _G.AutoMelee == true then
                skill()
                melee()
            end
        end

        spawn(function()
            pcall(function()
                while wait(0.2) do
                    pcall(function()
                        if _G.isonlobby ~= false or _G.DoNotThingIfHavePlayer ~= true or _G.CheckPlayer ~= true then
                            local magnitude = (fn5().HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                            Distance = magnitude

                            if game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 and Distance <= tonumber(_G.DistanceToSkill) then
                                if _G.AutoMelee == true and _G.AutoSkill == true then
                                    skillmelee()
                                elseif _G.AutoMelee == true and _G.AutoSkill == false then
                                    melee()
                                elseif _G.AutoMelee == false and _G.AutoSkill == true then
                                    skill()
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                local tbl2 = {
                    {"Curse Dimension", "CurseTeleportDestination"},
                    {"TitanDimensionNightmare", "AOTTeleportDestination"},
                    {"Fate Dimension", "CenterTeleportDestination"},
                    {"Pirate Dimension", "Part2TeleportDestination"},
                }

                local v6 = nil
                local v7 = nil

                while wait(1) do
                    pcall(function()
                        local magnitude = (fn5().HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        Distance = magnitude

                        if game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 then
                            local automob = _G.Automob
                            local flag = automob

                            if automob then
                                local flag2 = _G.AutoKill == true and isextreme == true

                                if flag2 then
                                    flag = false
                                else
                                    flag = true
                                end
                            end

                            if flag then
                                local v8 = Distance
                                local num = tonumber(_G.DistanceToSkill)
                                local n = num or 30
                                flag = n + 10 < v8
                            end

                            if flag then
                                if not v6 or Distance < v6 - 5 then
                                    local now = os.clock()
                                    v6 = Distance
                                    v7 = now
                                end
                            else
                                v6 = nil
                                v7 = nil
                            end

                            local flag2 = v7 ~= nil and os.clock() - v7 >= 3

                            if Distance > 500 or flag2 then
                                v6 = nil
                                v7 = nil

                                for i, v8 in ipairs(tbl2) do
                                    local v9 = workspace.GameMap:FindFirstChild(v8[1])
                                    local v10 = v9 and v9:FindFirstChild(v8[2])
                                    local cFrame = v10 and v10.CFrame or _G.LastGameMap == v8[1] and _G.MapTeleportCache and _G.MapTeleportCache[v8[1] .. "/" .. v8[2]]
                                    if cFrame then
                                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cFrame
                                        break
                                    end
                                    continue
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(0.2) do
                    pcall(function()
                        local magnitude = (fn5().HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        Distance = magnitude

                        if game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 and Distance <= 30 then
                            if (_G.AutoAssistSkill ~= true or tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.SkillAssist1.SkillName.Text) ~= nil) and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.SkillAssist1.SkillName.Text) ~= 0 then
                                if _G.AutoAssistSkill == true and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.SkillAssist2.SkillName.Text) == nil or tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.SkillAssist2.SkillName.Text) == 0 then
                                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseAssistSkill", {hrpCFrame = fn6()}, 2)
                                end
                            else
                                game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseAssistSkill", {hrpCFrame = fn6()}, 1)
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(0.2) do
                    pcall(function()
                        local magnitude = (fn5().HumanoidRootPart.Position - game.Players.LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        Distance = magnitude

                        if game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 and Distance <= 30 then
                            if (_G.AutoFruitSkill ~= true or tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.SkillFruit1.SkillName.Text) ~= nil) and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.SkillFruit1.SkillName.Text) ~= 0 then
                                if _G.AutoFruitSkill == true and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.SkillFruit2.SkillName.Text) == nil or tonumber(game:GetService("Players").LocalPlayer.PlayerGui.UniversalGui.UniversalCenterUIFrame.SlotsHolder.SkillFruit2.SkillName.Text) == 0 then
                                    game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseFruitSkill", {hrpCFrame = fn6()}, 2)
                                end
                            else
                                game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent:FireServer("UseFruitSkill", {hrpCFrame = fn6()}, 1)
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(1) do
                    pcall(function()
                        if _G.ResetifWave then
                            local num = tonumber(game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.WaveClearClearText.Text)

                            if tonumber(_G.SelectWaveToEnd) <= num and game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible == false then
                                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                                DoneReset = true
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(1) do
                    pcall(function()
                        if _G.DashNoCooldown then
                            game.ReplicatedStorage[game.Players.LocalPlayer.Name .. "StatDisplay"].No_DashCooldown.Value = true
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(1) do
                    pcall(function()
                        if _G.AutoClaimQuestAndReward and (game.PlaceId == 6938803436 or game.PlaceId == 7274690025 or game.PlaceId == 7338881230) then
                            for i = 1, 9 do
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("ClaimWeeklySpeedRaidReward", i)
                            end

                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("GiveFreeDailyGemFromShop")
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(unpack({"CompleteDailyQuest", "WeeklyQuest_Logins"}))
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(unpack({"CompleteDailyQuest", "WeeklyQuest_TimePlayed"}))
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(unpack({"CompleteDailyQuest", "WeeklyQuest_Raid"}))
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(unpack({"CompleteDailyQuest", "WeeklyQuest_SpeedRaid"}))
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CompleteDailyQuest", "DailyQuest_Login")
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CompleteDailyQuest", "DailyQuest_DungeonClear")
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CompleteDailyQuest", "DailyQuest_Enemies")
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CompleteDailyQuest", "DailyQuest_TimeChallenge")
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CompleteDailyQuest", "DailyQuest_Raid")
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CompleteDailyQuest", "DailyQuest_BossRush")
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CompleteDailyQuest", "DailyQuest_AllQuestClear")
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CompleteDailyQuest", "WeeklyQuest_Logins")
                            wait(600)
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if _G.AutoWalk == true and game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 then
                            walk(fn4())
                        end
                    end)
                end
            end)
        end)

        local tbl2 = {
            ["Obsidian Guardian"] = CFrame.new(0, 15, 0) * CFrame.Angles(math.rad(-90), 0, 0),
        }

        local v6 = nil
        local v7 = nil

        local function fn7()
            local character = game.Players.LocalPlayer.Character

            if character ~= v6 then
                local now = os.clock()
                v6 = character
                v7 = now
            end

            local flag = os.clock() - v7 >= 7
            return flag
        end

        local obj = setmetatable({}, {__mode = "k"})
        local cframe = nil
        local v8 = nil

        local function fn8()
            local ok, result = pcall(gethiddenproperty, game.Players.LocalPlayer, "SimulationRadius")
            local n = ok and tonumber(result) or 30
            return n
        end

        local function fn9()
            if not isnetworkowner then
                return nil
            end
            local character = game.Players.LocalPlayer.Character

            if character ~= v8 then
                cframe = nil
                v8 = character
            end

            local position = character.HumanoidRootPart.Position
            local v9 = fn8()
            local n = math.clamp(v9 * 0.85, 15, 800)
            local tbl3 = {}

            for i, child in ipairs(workspace.Folders.Monsters:GetChildren()) do
                local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")

                if humanoidRootPart and child:FindFirstChildOfClass("Humanoid") and child:FindFirstChildOfClass("BillboardGui") then
                    table.insert(tbl3, humanoidRootPart)

                    if (humanoidRootPart.Position - position).Magnitude <= v9 * 0.6 and not isnetworkowner(humanoidRootPart) then
                        local v10 = obj[child]
                        local now = v10 or os.clock()
                        obj[child] = now
                        if os.clock() - obj[child] > 6 then
                            return nil
                        end
                        continue
                    end

                    obj[child] = nil
                end
            end

            if #tbl3 == 0 then
                return cframe
            end
            local v10 = nil
            local huge = math.huge

            for i, v11 in ipairs(tbl3) do
                local magnitude = (v11.Position - position).Magnitude

                if magnitude < huge then
                    v10 = v11
                    huge = magnitude
                end
            end

            if n < 80 then
                cframe = CFrame.new(v10.Position + Vector3.new(0, math.clamp(n * 0.9, 30, 70), 0))
                return cframe
            end
            local n2 = math.max(n, 80)
            local vector = Vector3.zero
            local n3 = 0

            for i, v11 in ipairs(tbl3) do
                if (v11.Position - v10.Position).Magnitude <= n2 then
                    vector = vector + v11.Position
                    n3 = n3 + 1
                end
            end

            cframe = CFrame.new(vector / n3 + Vector3.new(0, 70, 0))
            return cframe
        end

        local tbl3 = {}
        local obj2 = setmetatable({}, {__mode = "k"})

        game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent.OnClientEvent:Connect(function(arg, arg2, arg3, arg4, arg5)
            if arg == "CreateTelegraphTimer" and typeof(arg2) == "CFrame" and typeof(arg3) == "Vector3" then
                local insert = table.insert
                local tbl4 = {cf = arg2, size = arg3}
                local now = os.clock()
                local num = tonumber(arg5)
                local n = num or 1
                tbl4.expires = now + n + 0.6
                insert(tbl3, tbl4)
            end
        end)

        task.spawn(function()
            workspace:WaitForChild("Folders"):WaitForChild("Debris").DescendantAdded:Connect(function(descendant)
                if descendant:IsA("BasePart") and descendant.Name:lower() == "telegraph" then
                    obj2[descendant] = true
                end
            end)
        end)

        local function fn10(arg)
            local now = os.clock()

            for i = #tbl3, 1, -1 do
                local v9 = tbl3[i]
                if v9.expires < now then
                    table.remove(tbl3, i)
                    continue
                end
                local v10 = v9.cf:PointToObjectSpace(arg)
                if math.abs(v10.X) <= v9.size.X / 2 + 6 and math.abs(v10.Z) <= v9.size.Z / 2 + 6 and v10.Y >= -10 and v10.Y <= v9.size.Y + 10 then
                    return true
                end
            end

            for k in pairs(obj2) do
                if not k.Parent then
                    obj2[k] = nil
                    continue
                end
                local v9 = k.CFrame:PointToObjectSpace(arg)
                local n = k.Size / 2
                if math.abs(v9.X) <= n.X + 6 and math.abs(v9.Z) <= n.Z + 6 and v9.Y >= -10 and v9.Y <= 300 then
                    return true
                end
            end

            return false
        end

        local function fn11(arg)
            local position = arg.Position
            if not fn10(position) then
                return arg
            end
            local v9, v10, v11 = ipairs({20, 40, 80, 160})
            local v12 = v11
            local v13 = v9
            local v14 = v10

            while true do
                local v15, v16 = v13(v14, v12)
                if v15 == nil then
                    break
                end

                for i = 0, 7 do
                    local v17 = math.rad(i * 45)
                    local n = position + Vector3.new(math.cos(v17) * v16, 0, math.sin(v17) * v16)
                    if not fn10(n) then
                        return CFrame.new(n)
                    end
                end

                v12 = v15
            end

            return arg
        end

        local function fn12(arg)
            if _G.isonlobby == false and _G.DoNotThingIfHavePlayer == true and _G.CheckPlayer == true then
                return
            end
            local v9 = fn11(arg)
            local humanoidRootPart = game.Players.LocalPlayer.Character.HumanoidRootPart
            local magnitude = (humanoidRootPart.Position - v9.Position).Magnitude

            if magnitude > 20 then
                local TweenService = game:GetService("TweenService")
                local create = TweenService.Create
                local tweenInfo = TweenInfo.new
                local num = tonumber(_G.TWSpeed)
                local n = num or 500
                create(TweenService, humanoidRootPart, tweenInfo(magnitude / n, Enum.EasingStyle.Linear), {CFrame = v9}):Play()
            else
                humanoidRootPart.CFrame = v9
            end
        end

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        local flag = _G.AutoKill == true and isextreme == true

                        if (_G.Automob and not flag or flag and fn7()) and game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 then
                            if _G.Method == "Behind" and not game.workspace.Folders.Monsters:FindFirstChild("Monke Titan") and not _G.isoninfmode then
                                local n = CFrame.new(0, 0, _G.Distance) * CFrame.Angles(math.rad(0), 0, 0)
                                MethodFarm = n
                            elseif _G.Method == "Front" then
                                local n = CFrame.new(0, 0, -_G.Distance) * CFrame.Angles(math.rad(0), 1800, 0)
                                MethodFarm = n
                            elseif _G.Method == "Under" and not game.workspace.Folders.Monsters:FindFirstChild("Monke Titan") and not _G.isoninfmode then
                                local n = CFrame.new(0, -_G.Distance, 0) * CFrame.Angles(math.rad(90), 0, 0)
                                MethodFarm = n
                            elseif _G.Method == "Over" and not game.workspace.Folders.Monsters:FindFirstChild("Monke Titan") and not _G.isoninfmode then
                                local n = CFrame.new(0, _G.Distance, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                                MethodFarm = n
                            elseif (_G.Method ~= "Behind" or not game.workspace.Folders.Monsters:FindFirstChild("Monke Titan")) and _G.isoninfmode ~= true then
                                if (_G.Method ~= "Under" or not game.workspace.Folders.Monsters:FindFirstChild("Monke Titan")) and _G.isoninfmode ~= true then
                                    if (_G.Method ~= "Over" or not game.workspace.Folders.Monsters:FindFirstChild("Monke Titan")) and _G.isoninfmode ~= true then
                                        local cframe2 = CFrame.new(0, 0, _G.Distance)
                                        MethodFarm = cframe2
                                    else
                                        local n = CFrame.new(0, 0, -_G.Distance) * CFrame.Angles(math.rad(0), 1800, 0)
                                        MethodFarm = n
                                    end
                                else
                                    local n = CFrame.new(0, 0, -_G.Distance) * CFrame.Angles(math.rad(0), 1800, 0)
                                    MethodFarm = n
                                end
                            else
                                local n = CFrame.new(0, 0, -_G.Distance) * CFrame.Angles(math.rad(0), 1800, 0)
                                MethodFarm = n
                            end

                            local vector = Vector3.new(0, 0, 0)

                            for i, descendant in ipairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                                if descendant:IsA("BasePart") then
                                    descendant.Velocity = vector
                                    descendant.RotVelocity = vector
                                end
                            end

                            if flag then
                                local v9 = fn9()

                                if v9 then
                                    fn12(v9)
                                end

                                return
                            end

                            local flag2 = game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible == true and fn4()

                            if flag2 then
                                local v9 = Tween
                                local cFrame = flag2.HumanoidRootPart.CFrame
                                local v10 = tbl2[flag2.Name]
                                local v11 = v10 or MethodFarm
                                v9(cFrame * v11)
                            else
                                local v9 = Tween
                                local n = fn5().HumanoidRootPart.CFrame * MethodFarm
                                local cframe2 = n or CFrame.new(0, 0, _G.Distance)
                                v9(cframe2)
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            local obj3 = setmetatable({}, {__mode = "k"})
            local obj4 = setmetatable({}, {__mode = "k"})

            game:GetService("ReplicatedStorage").RemoteEvents.MainRemoteEvent.OnClientEvent:Connect(function(arg, arg2)
                if arg == "FadeCharacterOnDeath" and typeof(arg2) == "Instance" then
                    obj4[arg2] = true
                end
            end)

            while task.wait() do
                pcall(function()
                    if _G.AutoKill == true and isextreme == true and isnetworkowner and game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 then
                        if _G.DoNotThingIfHavePlayer == true and _G.CheckPlayer == true then
                            return
                        end

                        for i, child in ipairs(workspace.Folders.Monsters:GetChildren()) do
                            local humanoidRootPart = child:FindFirstChild("HumanoidRootPart")
                            local humanoid = child:FindFirstChildOfClass("Humanoid")

                            if humanoidRootPart and humanoid and not obj4[child] then
                                humanoid.HealthDisplayType = Enum.HumanoidHealthDisplayType.AlwaysOff
                                humanoid.BreakJointsOnDeath = false

                                if isnetworkowner(humanoidRootPart) then
                                    humanoid.WalkSpeed = 0
                                end

                                if obj3[child] then
                                    if os.clock() - obj3[child] > 1.5 then
                                        obj3[child] = os.clock()
                                        humanoid.Health = humanoid.MaxHealth
                                        humanoid:ChangeState(Enum.HumanoidStateType.Running)

                                        task.delay(0.05, function()
                                            humanoid.Health = 0
                                        end)
                                    elseif humanoid.Health <= 0 and humanoid:GetState() ~= Enum.HumanoidStateType.Dead then
                                        humanoid:ChangeState(Enum.HumanoidStateType.Dead)
                                    end
                                else
                                    obj3[child] = os.clock()
                                    humanoid.Health = 0
                                end
                            end
                        end
                    end
                end)
            end
        end)

        local function fn13(arg)
            local v9, v10, v11 = ipairs(arg:GetChildren())
            local v12 = v11
            local v13 = v9
            local v14 = v10

            while true do
                local v15, v16 = v13(v14, v12)
                if v15 == nil then
                    break
                end
                v12 = v15

                if v16:IsA("ImageButton") and v16:FindFirstChild("CardClick") then
                    local v17, v18, v19 = pairs(getconnections(v16.CardClick.MouseButton1Click))
                    local v20 = v15
                    local v21 = v13
                    local v22 = v14
                    local v23 = v19
                    local v24 = v17
                    local v25 = v18

                    while true do
                        local v26, v27 = v24(v25, v23)
                        if v26 == nil then
                            break
                        end
                        v23 = v26
                        if not v27.Function then
                            continue
                        end

                        for k, v28 in pairs(debug.getupvalues(v27.Function)) do
                            if type(v28) == "table" and type(rawget(v28, "Cards")) == "table" and type(rawget(v28, "CardSlots")) == "table" then
                                return v28
                            end
                        end

                        v23 = v26
                    end

                    v12 = v20
                    v13 = v21
                    v14 = v22
                end
            end
        end

        local v9 = nil

        local function fn14()
            if not v9 then
                for i, v10 in ipairs(getgc(true)) do
                    if type(v10) == "table" and type(rawget(v10, "returnStat")) == "function" and type(rawget(v10, "returnStatObject")) == "function" then
                        v9 = v10
                        break
                    end
                end
            end

            return v9
        end

        spawn(function()
            local tbl4 = {
                "Sub_AttackPercent",
                "Sub_TeamAttackPercent",
                "Sub_CriticalChance",
                "Sub_CriticalDamage",
                "Sub_HealthPercent",
            }

            wait(5)

            while true do
                pcall(function()
                    if _G.EquipBestCard then
                        local ReplicatedStorage = game:GetService("ReplicatedStorage")
                        local settings = require(ReplicatedStorage.Modules.settings)
                        local FormulaModule = require(ReplicatedStorage.Modules.FormulaModule)
                        local v10 = fn14()
                        local v11 = fn13(game.Players.LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CardInventoryFrame.CardInventoryScrollingFrame)
                        if not v10 or not v11 then
                            return
                        end

                        local function fn15(arg)
                            local num = tonumber(v10.returnStat(game.Players.LocalPlayer, arg))
                            local n = num or 0
                            return n
                        end

                        local equipBestCardMode = _G.EquipBestCardMode
                        local str = equipBestCardMode or "Damage/Crit"

                        local tbl5 = {
                            Attack = fn15("Attack"),
                            Health = fn15("CardHealth"),
                            AttackPercent = fn15("Sub_AttackPercent") + fn15("Sub_TeamAttackPercent"),
                            CritChance = fn15("CriticalChance") + fn15("Sub_CriticalChance"),
                            CritDamage = fn15("CriticalDamage") + fn15("Sub_CriticalDamage"),
                            HealthPercent = fn15("Sub_HealthPercent"),
                        }

                        local Level = fn15("Level")
                        local tbl6 = {}
                        local tbl7 = {}
                        local v12, v13, v14 = pairs(v11.Cards)
                        local v15 = v14
                        local v16 = v12
                        local v17 = v13

                        while true do
                            local v18, v19 = v16(v17, v15)
                            if v18 == nil then
                                break
                            end
                            v15 = v18
                            local v20 = settings.CardInfo[v19.CardName]

                            if v20 and v19.Unique_ID == v18 then
                                local isDivine = v19.IsDivine
                                local rarity = isDivine and "Divine" or v20.rarity
                                local returnAttackAndHealthFromData = FormulaModule.returnAttackAndHealthFromData
                                local levelReq = v19.LevelReq
                                local level = v19.Level
                                local n = level or 0
                                local v21 = returnAttackAndHealthFromData(levelReq, rarity, n)
                                local tbl8 = {}

                                for i, v22 in ipairs(tbl4) do
                                    tbl8[v22] = 0
                                end

                                local v22 = v16
                                local v23 = v17

                                for i = 1, 5 do
                                    local v24 = v19["Substat" .. i .. "Name"]
                                    local num = tonumber(v19["Substat" .. i .. "Amount"])

                                    if v24 and num and tbl8[v24] then
                                        tbl8[v24] = tbl8[v24] + num
                                    end
                                end

                                v15 = v18
                                v16 = v22
                                v17 = v23

                                local tbl9 = {
                                    id = v18,
                                    Attack = v21.Attack,
                                    Health = v21.Health,
                                    AttackPercent = tbl8.Sub_AttackPercent + tbl8.Sub_TeamAttackPercent,
                                    CritChance = tbl8.Sub_CriticalChance,
                                    CritDamage = tbl8.Sub_CriticalDamage,
                                    HealthPercent = tbl8.Sub_HealthPercent,
                                }

                                if v19.Equipped then
                                    table.insert(tbl7, tbl9)

                                    for k in pairs(tbl5) do
                                        tbl5[k] = tbl5[k] - tbl9[k]
                                    end

                                    v15 = v18
                                    v16 = v22
                                    v17 = v23
                                end

                                local levelReq2 = v19.LevelReq
                                local n2 = levelReq2 or 0

                                if n2 <= Level then
                                    table.insert(tbl6, tbl9)
                                end
                            end
                        end

                        local function fn16(arg)
                            local tbl8 = {}

                            for k, v18 in pairs(tbl5) do
                                tbl8[k] = v18
                            end

                            local v18, v19, v20 = ipairs(arg)
                            local v21 = v20
                            local v22 = v18
                            local v23 = v19

                            while true do
                                local v24, v25 = v22(v23, v21)
                                if v24 == nil then
                                    break
                                end

                                for k in pairs(tbl8) do
                                    tbl8[k] = tbl8[k] + v25[k]
                                end

                                v21 = v24
                            end

                            if str == "HP" then
                                return (settings.GameSettings.DefaultMaxHealth + tbl8.Health) * (1 + tbl8.HealthPercent / 100)
                            end
                            return tbl8.Attack * (1 + tbl8.AttackPercent / 100) * (1 + math.min(1, tbl8.CritChance / 100) * (0.5 + tbl8.CritDamage / 100))
                        end

                        for i, v18 in ipairs(tbl6) do
                            v18.single = fn16({v18})
                        end

                        table.sort(tbl6, function(arg, arg2)
                            local flag = arg2.single < arg.single
                            return flag
                        end)

                        local tbl8 = {}

                        for i = 1, math.min(20, #tbl6) do
                            tbl8[i] = tbl6[i]
                        end

                        local tbl9 = tbl8
                        local n = fn16(tbl8)

                        if #tbl8 > 3 then
                            n = -1
                            local n2 = 0
                            local n3 = #tbl8 - 2 + 0

                            while true do
                                local n4 = n2 + 1
                                if n4 > n3 then
                                    break
                                end
                                local v18 = n4
                                local v19 = n3

                                for i = n4 + 1, #tbl8 - 1 do
                                    for i2 = i + 1, #tbl8 do
                                        local v20 = fn16({tbl8[n4], tbl8[i], tbl8[i2]})

                                        if n < v20 then
                                            tbl9 = {tbl8[n4], tbl8[i], tbl8[i2]}
                                            n = v20
                                        end
                                    end
                                end

                                n3 = v19
                                n2 = v18
                            end
                        end

                        if n <= fn16(tbl7) * 1.0001 then
                            return
                        end
                        local tbl10 = {}

                        for i, v18 in ipairs(tbl9) do
                            tbl10[v18.id] = true
                        end

                        local mainRemoteFunction = ReplicatedStorage.RemoteFunctions.MainRemoteFunction

                        for i, v18 in ipairs(tbl7) do
                            if not tbl10[v18.id] then
                                mainRemoteFunction:InvokeServer("UnequipCard", v18.id)
                                wait(0.3)
                            end
                        end

                        for k in pairs(tbl10) do
                            if v11.Cards[k] and not v11.Cards[k].Equipped then
                                mainRemoteFunction:InvokeServer("EquipCard", k)
                                wait(0.3)
                            end
                        end
                    end
                end)

                wait(30)
            end
        end)

        spawn(function()
            local tbl4 = {
                Common = true,
                Uncommon = true,
                Rare = true,
                Epic = true,
                Legendary = true,
            }

            wait(5)

            while wait(1) do
                pcall(function()
                    if _G.AutoSell == true and type(Cardtabel) == "table" then
                        local tbl5 = {}

                        for k, v10 in pairs(Cardtabel) do
                            if type(v10) == "string" and tbl4[v10] then
                                tbl5[v10] = true
                            end
                        end

                        if next(tbl5) == nil then
                            return
                        end
                        local settings = require(game:GetService("ReplicatedStorage").Modules.settings)
                        local v10 = fn13(game.Players.LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CardInventoryFrame.CardInventoryScrollingFrame)
                        if not v10 then
                            return
                        end
                        local tbl6 = {}

                        for k in pairs(v10.Cards) do
                            table.insert(tbl6, k)
                        end

                        for i, v11 in ipairs(tbl6) do
                            if _G.AutoSell ~= true then
                                break
                            end
                            local v12 = v10.Cards[v11]
                            local v13 = v12 and settings.CardInfo[v12.CardName]
                            if not v12 or not v13 or v12.Unique_ID ~= v11 or v12.IsDivine then
                                continue
                            end
                            local num = tonumber(v12.DivineLevel)
                            local n = num or 0
                            if n ~= 0 or v12.Locked or v12.Equipped or v13.Limited or not tbl4[v13.rarity] or not tbl5[v13.rarity] then
                                continue
                            end
                            local response = game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("SellCard", v11)
                            if type(response) == "table" and response.status == "Fail" then
                                break
                            end
                            wait(0.3)
                        end

                        wait(60)
                    end
                end)
            end
        end)

        spawn(function()
            pcall(function()
                wait(10)

                while wait(1) do
                    pcall(function()
                        if game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 then
                            if _G.GoLobbyMethod == "ResetCharacter" and _G.OnRaidOpen == true and _G.RaidOpened == true and game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible == false then
                                game.Players.LocalPlayer.Character.Humanoid.Health = 0
                            elseif _G.GoLobbyMethod == "TeleportToLobby" and _G.OnRaidOpen == true and _G.RaidOpened == true and game:GetService("Players").LocalPlayer.PlayerGui.BattleGui.CenterUIFrame.BossHealthFrame.Visible == false then
                                game:GetService("TeleportService"):Teleport(6938803436)
                                wait(60)
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                wait(tonumber(_G.waitonJoinRiad))

                while wait() do
                    pcall(function()
                        if _G.AutoMadokiRaid == true and tonumber(game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"]["Madoki Raid Key"].Value) <= 0 then
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("BuyRaidShopItem", "Madoki Raid Key (2 Per Day)")
                        elseif game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"]:FindFirstChild("Madoki Raid Key") and tonumber(game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"]["Madoki Raid Key"].Value) > 0 and _G.AutoMadokiRaid == true then
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                Difficulty = "Easy",
                                FriendsOnly = _G.FriendOnly,
                                MapName = "Goddess Madoki Raid",
                                Hardcore = false,
                            })

                            wait(1)
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportPlayers")
                        elseif _G.AutoRaid == true and _G.AutoGoAFK == true then
                            if _G.RaidOpened == true then
                                if game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 then
                                    if game.PlaceId == 6990131029 then
                                        game:GetService("ReplicatedStorage"):WaitForChild("RemoteFunctions"):WaitForChild("MainRemoteFunction"):InvokeServer("TeleportToLobbyAFK", true)
                                    end
                                else
                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                        Difficulty = "Easy",
                                        FriendsOnly = _G.FriendOnly,
                                        MapName = tostring(_G.RaidSelection),
                                        Hardcore = false,
                                    })

                                    wait()
                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportPlayers")
                                end
                            elseif _G.RaidOpened == false and game.PlaceId ~= 6990131029 then
                                wait(10)
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToAFK")
                            end
                        elseif _G.AutoRaid == true and _G.AutoGoAFK == false then
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                Difficulty = "Easy",
                                FriendsOnly = _G.FriendOnly,
                                MapName = tostring(_G.RaidSelection),
                                Hardcore = false,
                            })

                            wait(1)
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportPlayers")
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                wait(tonumber(_G.CooldownOnlobby))

                while wait() do
                    pcall(function()
                        if _G.AutoRaid == true then
                            if _G.FreeBossRush == true and game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.BossRushFrame.BossRushFreeEntry.Text == "1 Free Entry Left" and _G.RaidOpened == false and _G.isonlobby == true then
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToBossRush")
                            elseif _G.BossRush == true and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.BossRushFrame.BossRushEntryPassCount.Text) > 0 and _G.RaidOpened == false and _G.isonlobby == true then
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToBossRush")
                            elseif _G.AutoTraitTokens == true and game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayFrame.Frame.PlayRoomFrame.MapSelectionScrollingFrame["Infinite Mode"].PlayerReq.Text == "Trait Tokens Available" and game.Players.LocalPlayer.leaderstats.Level.Value >= 20 and _G.RaidOpened == false and _G.isonlobby == true then
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                    Difficulty = "Infinite",
                                    FriendsOnly = _G.FriendOnly,
                                    MapName = "Infinite Mode",
                                    Hardcore = false,
                                })
                            elseif _G.AutoSpeedRaid == true and game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayButtonsFrame.Frame.SpeedRaidBanner.SpeedRaidBannerOpenText.Text == "Ready to enter" and _G.RaidOpened == false and _G.isonlobby == true then
                                local v10, v11, v12 = pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.SpeedRaidCharacterSelector.Shade.SpeedRaidCharacterInventoryScrollingFrame:GetChildren())
                                local v13 = v12
                                local v14 = v10
                                local v15 = v11

                                while true do
                                    local v16, v17 = v14(v15, v13)
                                    if v16 == nil then
                                        break
                                    end
                                    v13 = v16

                                    if v17.ClassName == "ImageButton" then
                                        for k, child in pairs(v17:GetChildren()) do
                                            if child.ClassName == "ImageButton" and child.Name == "CharacterImage" and child.ImageTransparency == 0 and v17.Name ~= game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName1.Value and v17.Name ~= game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName2.Value then
                                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToShadowRaid", v17.Name)
                                                wait(60)
                                            end
                                        end

                                        v13 = v16
                                    end
                                end
                            end
                        elseif _G.AutoRaid == false then
                            if _G.FreeBossRush == true and game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.BossRushFrame.BossRushFreeEntry.Text == "1 Free Entry Left" then
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToBossRush")
                            elseif _G.BossRush == true and tonumber(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.BossRushFrame.BossRushEntryPassCount.Text) > 0 then
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToBossRush")
                            elseif _G.AutoTraitTokens == true and game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayFrame.Frame.PlayRoomFrame.MapSelectionScrollingFrame["Infinite Mode"].PlayerReq.Text == "Trait Tokens Available" and game.Players.LocalPlayer.leaderstats.Level.Value >= 20 then
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                    Difficulty = "Infinite",
                                    FriendsOnly = _G.FriendOnly,
                                    MapName = "Infinite Mode",
                                    Hardcore = false,
                                })
                            elseif _G.AutoSpeedRaid == true and _G.isonlobby == true and game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayButtonsFrame.Frame.SpeedRaidBanner.SpeedRaidBannerOpenText.Text == "Ready to enter" then
                                local v10, v11, v12 = pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.SpeedRaidCharacterSelector.Shade.SpeedRaidCharacterInventoryScrollingFrame:GetChildren())
                                local v13 = v12
                                local v14 = v10
                                local v15 = v11

                                while true do
                                    local v16, v17 = v14(v15, v13)
                                    if v16 == nil then
                                        break
                                    end
                                    v13 = v16

                                    if v17.ClassName == "ImageButton" then
                                        for k, child in pairs(v17:GetChildren()) do
                                            if child.ClassName == "ImageButton" and child.Name == "CharacterImage" and child.ImageTransparency == 0 and v17.Name ~= game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName1.Value and v17.Name ~= game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName2.Value then
                                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToShadowRaid", v17.Name)
                                                wait(60)
                                            end
                                        end

                                        v13 = v16
                                    end
                                end
                            end
                        end

                        wait(60)
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                wait(tonumber(_G.CooldownOnlobby))
                wait(5)

                while wait() do
                    pcall(function()
                        if _G.AutoPlay == true then
                            if _G.GetAllDimensionCharacter == true then
                                if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Sakura") then
                                    if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Natsu") then
                                        if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Killua") then
                                            if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Asta") then
                                                if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Itadori") then
                                                    if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Akaza") then
                                                        if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Sasuke") then
                                                            if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Gray") then
                                                                if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Sukuna") then
                                                                    if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Rukia") then
                                                                        if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Shinra") then
                                                                            if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("All Might") then
                                                                                if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Zoro") then
                                                                                    if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("AsunaCharacter") then
                                                                                        if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Emiya Archer") then
                                                                                            if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("KanekiCharacter") then
                                                                                                if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Lancer") then
                                                                                                    if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Saber Alter Character") then
                                                                                                        if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Diablo") then
                                                                                                            if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Rimuru") then
                                                                                                                if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("PowerCharacter") then
                                                                                                                    if game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.Inventory.Frame.CharacterInventoryFrame.CharacterInventoryScrollingFrame:FindFirstChild("Yamato") then
                                                                                                                        if _G.MapSelection == "Infinite Mode" then
                                                                                                                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                                                Difficulty = "Infinite",
                                                                                                                                FriendsOnly = _G.FriendOnly,
                                                                                                                                MapName = "Infinite Mode",
                                                                                                                                Hardcore = false,
                                                                                                                            })
                                                                                                                        elseif _G.MapSelection == "TimeChallenge" then
                                                                                                                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToTimeChallenge")
                                                                                                                        elseif _G.MapSelection ~= "Infinite Mode" then
                                                                                                                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                                                Difficulty = _G.Difficulty,
                                                                                                                                FriendsOnly = _G.FriendOnly,
                                                                                                                                MapName = _G.MapSelection,
                                                                                                                                Hardcore = _G.Hardcore,
                                                                                                                            })
                                                                                                                        end
                                                                                                                    else
                                                                                                                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                                            Difficulty = "Nightmare",
                                                                                                                            FriendsOnly = true,
                                                                                                                            MapName = "Pirate Dimension",
                                                                                                                            Hardcore = _G.Hardcore,
                                                                                                                        })
                                                                                                                    end
                                                                                                                else
                                                                                                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                                        Difficulty = "Nightmare",
                                                                                                                        FriendsOnly = true,
                                                                                                                        MapName = "Devil Dimension",
                                                                                                                        Hardcore = _G.Hardcore,
                                                                                                                    })
                                                                                                                end
                                                                                                            else
                                                                                                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                                    Difficulty = "Nightmare",
                                                                                                                    FriendsOnly = true,
                                                                                                                    MapName = "Slime Dimension",
                                                                                                                    Hardcore = _G.Hardcore,
                                                                                                                })
                                                                                                            end
                                                                                                        else
                                                                                                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                                Difficulty = "Easy",
                                                                                                                FriendsOnly = true,
                                                                                                                MapName = "Slime Dimension",
                                                                                                                Hardcore = _G.Hardcore,
                                                                                                            })
                                                                                                        end
                                                                                                    else
                                                                                                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                            Difficulty = "Nightmare",
                                                                                                            FriendsOnly = true,
                                                                                                            MapName = "Fate Dimension",
                                                                                                            Hardcore = _G.Hardcore,
                                                                                                        })
                                                                                                    end
                                                                                                else
                                                                                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                        Difficulty = "Easy",
                                                                                                        FriendsOnly = true,
                                                                                                        MapName = "Fate Dimension",
                                                                                                        Hardcore = _G.Hardcore,
                                                                                                    })
                                                                                                end
                                                                                            else
                                                                                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                    Difficulty = "Nightmare",
                                                                                                    FriendsOnly = true,
                                                                                                    MapName = "Ghoul Dimension",
                                                                                                    Hardcore = _G.Hardcore,
                                                                                                })
                                                                                            end
                                                                                        else
                                                                                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                                Difficulty = "Easy",
                                                                                                FriendsOnly = true,
                                                                                                MapName = "Ghoul Dimension",
                                                                                                Hardcore = _G.Hardcore,
                                                                                            })
                                                                                        end
                                                                                    else
                                                                                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                            Difficulty = "Nightmare",
                                                                                            FriendsOnly = true,
                                                                                            MapName = "Sword Dimension",
                                                                                            Hardcore = _G.Hardcore,
                                                                                        })
                                                                                    end
                                                                                else
                                                                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                        Difficulty = "Easy",
                                                                                        FriendsOnly = true,
                                                                                        MapName = "Sword Dimension",
                                                                                        Hardcore = _G.Hardcore,
                                                                                    })
                                                                                end
                                                                            else
                                                                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                    Difficulty = "Nightmare",
                                                                                    FriendsOnly = true,
                                                                                    MapName = "Villain Dimension",
                                                                                    Hardcore = _G.Hardcore,
                                                                                })
                                                                            end
                                                                        else
                                                                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                                Difficulty = "Hard",
                                                                                FriendsOnly = true,
                                                                                MapName = "Villain Dimension",
                                                                                Hardcore = _G.Hardcore,
                                                                            })
                                                                        end
                                                                    else
                                                                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                            Difficulty = "Easy",
                                                                            FriendsOnly = true,
                                                                            MapName = "Villain Dimension",
                                                                            Hardcore = _G.Hardcore,
                                                                        })
                                                                    end
                                                                else
                                                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                        Difficulty = "Nightmare",
                                                                        FriendsOnly = true,
                                                                        MapName = "Curse Dimension",
                                                                        Hardcore = _G.Hardcore,
                                                                    })
                                                                end
                                                            else
                                                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                    Difficulty = "Hard",
                                                                    FriendsOnly = true,
                                                                    MapName = "Curse Dimension",
                                                                    Hardcore = _G.Hardcore,
                                                                })
                                                            end
                                                        else
                                                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                                Difficulty = "Easy",
                                                                FriendsOnly = true,
                                                                MapName = "Curse Dimension",
                                                                Hardcore = _G.Hardcore,
                                                            })
                                                        end
                                                    else
                                                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                            Difficulty = "Nightmare",
                                                            FriendsOnly = true,
                                                            MapName = "Demon Dimension",
                                                            Hardcore = _G.Hardcore,
                                                        })
                                                    end
                                                else
                                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                        Difficulty = "Hard",
                                                        FriendsOnly = true,
                                                        MapName = "Demon Dimension",
                                                        Hardcore = _G.Hardcore,
                                                    })
                                                end
                                            else
                                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                    Difficulty = "Easy",
                                                    FriendsOnly = true,
                                                    MapName = "Demon Dimension",
                                                    Hardcore = _G.Hardcore,
                                                })
                                            end
                                        else
                                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                                Difficulty = "Nightmare",
                                                FriendsOnly = true,
                                                MapName = "Titan Dimension",
                                                Hardcore = _G.Hardcore,
                                            })
                                        end
                                    else
                                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                            Difficulty = "Hard",
                                            FriendsOnly = true,
                                            MapName = "Titan Dimension",
                                            Hardcore = _G.Hardcore,
                                        })
                                    end
                                else
                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                        Difficulty = "Easy",
                                        FriendsOnly = true,
                                        MapName = "Titan Dimension",
                                        Hardcore = _G.Hardcore,
                                    })
                                end
                            elseif _G.MapSelection == "Infinite Mode" then
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                    Difficulty = "Infinite",
                                    FriendsOnly = _G.FriendOnly,
                                    MapName = "Infinite Mode",
                                    Hardcore = false,
                                })
                            elseif _G.MapSelection == "TimeChallenge" then
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToTimeChallenge")
                            elseif _G.MapSelection ~= "Infinite Mode" then
                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("CreateRoom", {
                                    Difficulty = _G.Difficulty,
                                    FriendsOnly = _G.FriendOnly,
                                    MapName = _G.MapSelection,
                                    Hardcore = _G.Hardcore,
                                })
                            end

                            wait(1)
                            game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportPlayers")
                            wait(60)
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(1) do
                    pcall(function()
                        if _G.AutoEquipCharacter and _G.isonlobby == true then
                            if isfile("Character_SLH.json") then
                                tbl = game:GetService("HttpService"):JSONDecode(readfile("Character_SLH.json"))
                            end

                            for k, v10 in pairs(tbl) do
                                if tostring(k) == "Character1" then
                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("EquipCharacter", tostring(v10))
                                elseif tostring(k) == "Character2" then
                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("EquipCharacterAssist", tostring(v10), 1)
                                elseif tostring(k) == "Character3" then
                                    game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("EquipCharacterAssist", tostring(v10), 2)
                                end
                            end

                            wait(6000)
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    if game:GetService("Players").LocalPlayer.DevCameraOcclusionMode ~= "Invisicam" then
                        game:GetService("Players").LocalPlayer.DevCameraOcclusionMode = "Invisicam"
                    end
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if _G.DontNoclip == true then
                            for k, child in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                if child:IsA("BasePart") then
                                    child.CanCollide = true
                                end
                            end
                        else
                            local automob = _G.Automob
                            local flag = automob or _G.AutoKill == true and isextreme == true

                            if _G.AutoDodgeSkill == true and game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 then
                                if flag then
                                    if workspace.Folders.Debris:FindFirstChild("DodgePart") then
                                        for k, child in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                            if child:IsA("BasePart") then
                                                child.CanCollide = true
                                            end
                                        end
                                    elseif not workspace.Folders.Debris:FindFirstChild("DodgePart") then
                                        for k, child in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                            if child:IsA("BasePart") then
                                                child.CanCollide = false
                                            end
                                        end
                                    end
                                else
                                    for k, child in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                        if child:IsA("BasePart") then
                                            child.CanCollide = true
                                        end
                                    end
                                end
                            elseif _G.AutoDodgeSkill == false and game.PlaceId ~= 6938803436 and game.PlaceId ~= 7274690025 and game.PlaceId ~= 7338881230 then
                                for k, child in pairs(game.Players.LocalPlayer.Character:GetChildren()) do
                                    if child:IsA("BasePart") then
                                        child.CanCollide = false
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if _G.BackToLobbyIfGotExploitsDetected and game.ReplicatedStorage[game.Players.LocalPlayer.Name .. "StatDisplay"].ExploitsDetected.Value == true then
                            game:GetService("TeleportService"):Teleport(6938803436)
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if _G.HideName then
                            for k, child in pairs(game.Players.LocalPlayer.Character.Head:GetChildren()) do
                                if child.ClassName == "BillboardGui" then
                                    child:Destroy()
                                end
                            end
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                workspace.Folders.Debris.ChildAdded:Connect(function(child)
                    pcall(function()
                        if table.find({"telegraph"}, child.Name:lower()) and child.Material ~= Enum.Material.Neon and _G.AutoDodgeSkill == true then
                            local material = child.Material
                            local clone = child:Clone()
                            local n = math.clamp(tonumber(_G.SizeDodgePart), 0, 10)
                            local n2 = child.Size + Vector3.new(n, tonumber(_G.SizeDodgePartY), n)
                            clone.Size = Vector3.new(0, 0, child.Size.Z)

                            if child.ClassName == "MeshPart" then
                                clone.Size = Vector3.new(0, 0, 100)
                                n2 = child.Size + Vector3.new(n, n, 100)
                            end

                            game:GetService("TweenService"):Create(clone, TweenInfo.new(tonumber(_G.TweenDodgePart)), {Size = n2}):Play()
                            clone.CFrame = child.CFrame + Vector3.new(0, 0, 0)
                            clone.Anchored = true
                            clone.Transparency = tonumber(_G.DodgePartTransparency)
                            clone.CanCollide = true
                            clone.Name = "DodgePart"
                            clone.Parent = child.Parent

                            repeat
                                wait()
                            until not child.Parent

                            clone:Destroy()
                        end
                    end)
                end)
            end)
        end)

        local Misc = v2:CreateTab("Misc")
        local Section1 = Misc:CreateSector("Section1", "left")

        Section1:AddTextbox("Speed", "16", function(speed)
            _G.Speed = speed
        end)

        Section1:AddTextbox("Jump", "50", function(jump)
            _G.Jump = jump
        end)

        Section1:AddToggle("WalkSpeed", false, function(walkSpeed)
            _G.WalkSpeed = walkSpeed
        end)

        Section1:AddToggle("JumpPower", false, function(jumpPower)
            _G.JumpPower = jumpPower
        end)

        Section1:AddToggle("Ctrl+ClickTP", false, function(ctrlClickTP)
            _G.CtrlClickTP = ctrlClickTP
        end)

        Section1:AddToggle("CloseGuiAfterExecute", false, function(closeGuiAfterExecute)
            _G.CloseGuiAfterExecute = closeGuiAfterExecute
        end)

        Section1:AddButton("Rejoin", function()
            game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, game.JobId, game:GetService("Players").LocalPlayer)
        end)

        Section1:AddButton("HopServer", function()
            local placeId = game.PlaceId
            local tbl4 = {}
            local str = ""
            local hour = os.date("!*t").hour

            if not pcall(function()
                tbl4 = game:GetService("HttpService"):JSONDecode(readfile("NotSameServers.json"))
            end) then
                table.insert(tbl4, hour)
                writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(tbl4))
            end

            TPReturner = function()
                local data

                if str == "" then
                    data = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100"))
                else
                    data = game.HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. placeId .. "/servers/Public?sortOrder=Asc&limit=100&cursor=" .. str))
                end

                local str2 = ""

                if data.nextPageCursor and data.nextPageCursor ~= "null" and data.nextPageCursor ~= nil then
                    str = data.nextPageCursor
                end

                local n = 0
                local v10, v11, v12 = pairs(data.data)
                local v13 = v12
                local v14 = v10
                local v15 = v11

                while true do
                    local v16, v17 = v14(v15, v13)
                    if v16 == nil then
                        break
                    end
                    v13 = v16
                    local flag = true
                    str2 = tostring(v17.id)
                    local num = tonumber(v17.maxPlayers)

                    if tonumber(v17.playing) < num then
                        for k, v18 in pairs(tbl4) do
                            if n == 0 then
                                if tonumber(hour) ~= tonumber(v18) then
                                    pcall(function()
                                        delfile("NotSameServers.json")
                                        tbl4 = {}
                                        table.insert(tbl4, hour)
                                    end)
                                end
                            elseif str2 == tostring(v18) then
                                flag = false
                            end

                            n = n + 1
                        end

                        v13 = v16

                        if flag == true then
                            table.insert(tbl4, str2)
                            wait()

                            pcall(function()
                                writefile("NotSameServers.json", game:GetService("HttpService"):JSONEncode(tbl4))
                                wait()
                                game:GetService("TeleportService"):TeleportToPlaceInstance(placeId, str2, game.Players.LocalPlayer)
                            end)

                            wait(4)
                        end
                    end
                end
            end

            Teleport = function()
                while wait() do
                    pcall(function()
                        TPReturner()

                        if str ~= "" then
                            TPReturner()
                        end
                    end)
                end
            end

            Teleport()
        end)

        Section1:AddButton("FireProximityPrompt", function()
            for k, descendant in pairs(game:GetService("Workspace"):GetDescendants()) do
                if descendant:IsA("ProximityPrompt") then
                    fireproximityprompt(descendant)
                end
            end
        end)

        Section1:AddButton("InstantProximityPrompt", function()
            game:GetService("ProximityPromptService").PromptButtonHoldBegan:Connect(function(prompt)
                prompt.HoldDuration = 0
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if _G.WalkSpeed then
                            pcall(function()
                                game.Players.LocalPlayer.character.Humanoid.WalkSpeed = tonumber(_G.Speed)
                            end)
                        end
                    end)
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while task.wait() do
                    pcall(function()
                        if _G.JumpPower then
                            pcall(function()
                                game.Players.LocalPlayer.character.Humanoid.JumpPower = tonumber(_G.Jump)
                            end)
                        end
                    end)
                end
            end)
        end)

        ClickTP = function()
            local UserInputService = game:GetService("UserInputService")
            local mouse = game.Players.LocalPlayer:GetMouse()

            GetCharacter = function()
                return game.Players.LocalPlayer.Character
            end

            Teleport = function(arg)
                local v10 = GetCharacter()

                if v10 then
                    v10:MoveTo(arg)
                end
            end

            UserInputService.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and _G.CtrlClickTP == true then
                    Teleport(mouse.Hit.p)
                end
            end)
        end

        local Section2 = Misc:CreateSector("Section2", "Right")

        Section2:AddToggle("RejoinIfGotKick", false, function(rejoinKick)
            _G.rejoinKick = rejoinKick
        end)

        spawn(function()
            getgenv().rejoin = game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
                if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") and _G.rejoinKick == true then
                    game:GetService("TeleportService"):Teleport(6938803436)
                end
            end)
        end)

        Section2:AddToggle("Whitescreen(Reduce Cpu)", false, function(whitescreen)
            _G.Whitescreen = whitescreen
        end)

        do
            local Players = game:GetService("Players")
            local Workspace = game:GetService("Workspace")
            local Lighting = game:GetService("Lighting")
            local LocalPlayer = Players.LocalPlayer
            local FpsSection = Misc:CreateSector("FPS Boost", "Right")

            -- สร้างระบบแต่ละฟีเจอร์: จำค่าเดิมไว้ แล้วคืนค่าให้เมื่อปิด
            local function newFeature(roots, applyFn, extraFn)
                local feature = {
                    saved = setmetatable({}, {__mode = "k"}),
                    connections = {},
                    token = 0,
                }

                local function set(inst, prop, value)
                    local props = feature.saved[inst]
                    if not props then
                        props = {}
                        feature.saved[inst] = props
                    end
                    if props[prop] == nil then
                        local ok, old = pcall(function()
                            return inst[prop]
                        end)
                        if not ok then
                            return
                        end
                        props[prop] = old
                    end
                    pcall(function()
                        inst[prop] = value
                    end)
                end

                function feature.disable()
                    feature.token = feature.token + 1
                    for _, connection in ipairs(feature.connections) do
                        connection:Disconnect()
                    end
                    feature.connections = {}
                    for inst, props in pairs(feature.saved) do
                        for prop, old in pairs(props) do
                            pcall(function()
                                inst[prop] = old
                            end)
                        end
                    end
                    feature.saved = setmetatable({}, {__mode = "k"})
                end

                function feature.enable()
                    feature.disable()
                    local token = feature.token
                    local function isActive()
                        return feature.token == token
                    end

                    if extraFn then
                        pcall(extraFn, set, isActive)
                    end

                    if applyFn then
                        for _, root in ipairs(roots) do
                            table.insert(feature.connections, root.DescendantAdded:Connect(function(inst)
                                pcall(applyFn, inst, set)
                            end))
                        end

                        task.spawn(function()
                            local count = 0
                            for _, root in ipairs(roots) do
                                for _, inst in ipairs(root:GetDescendants()) do
                                    if not isActive() then
                                        return
                                    end
                                    pcall(applyFn, inst, set)
                                    count = count + 1
                                    if count % 300 == 0 then
                                        task.wait()
                                    end
                                end
                            end
                        end)
                    end
                end

                function feature.toggle(state)
                    if state then
                        feature.enable()
                    else
                        feature.disable()
                    end
                end

                return feature
            end

            -- 1) ปิดเอฟเฟกต์ (อนุภาค, แสง, เบลอ, Bloom ฯลฯ) ตัวที่ทำ FPS ตกมากที่สุดตอนใช้สกิล
            local EffectProps = {
                ParticleEmitter = "Enabled",
                Trail = "Enabled",
                Beam = "Enabled",
                Fire = "Enabled",
                Smoke = "Enabled",
                Sparkles = "Enabled",
                Explosion = "Visible",
                PointLight = "Enabled",
                SpotLight = "Enabled",
                SurfaceLight = "Enabled",
                BlurEffect = "Enabled",
                BloomEffect = "Enabled",
                ColorCorrectionEffect = "Enabled",
                SunRaysEffect = "Enabled",
                DepthOfFieldEffect = "Enabled",
            }

            local noEffects = newFeature({Workspace, Lighting}, function(inst, set)
                local prop = EffectProps[inst.ClassName]
                if prop then
                    set(inst, prop, false)
                    if inst.ClassName == "ParticleEmitter" then
                        set(inst, "Lifetime", NumberRange.new(0))
                    end
                end
            end)

            -- 2) ลดรายละเอียดของแมพ (วัสดุ, เงา, ลายพื้นผิว, โมเดลละเอียด)
            local simplifyMap = newFeature({Workspace}, function(inst, set)
                if inst:IsA("Terrain") then
                    return
                end
                if inst:IsA("BasePart") then
                    set(inst, "Material", Enum.Material.SmoothPlastic)
                    set(inst, "Reflectance", 0)
                    set(inst, "CastShadow", false)
                    if inst:IsA("MeshPart") then
                        set(inst, "RenderFidelity", Enum.RenderFidelity.Performance)
                    end
                elseif inst:IsA("Decal") or inst:IsA("Texture") then
                    set(inst, "Transparency", 1)
                end
            end)

            -- 3) กราฟิกต่ำ (เงา, หมอก, น้ำ, คุณภาพภาพ)
            local lowGraphics = newFeature({}, nil, function(set)
                set(Lighting, "GlobalShadows", false)
                set(Lighting, "FogEnd", 9e9)
                for _, child in ipairs(Lighting:GetChildren()) do
                    if child:IsA("Atmosphere") then
                        set(child, "Density", 0)
                        set(child, "Haze", 0)
                    end
                end
                local terrain = Workspace:FindFirstChildOfClass("Terrain")
                if terrain then
                    set(terrain, "WaterWaveSize", 0)
                    set(terrain, "WaterWaveSpeed", 0)
                    set(terrain, "WaterReflectance", 0)
                    set(terrain, "WaterTransparency", 1)
                    pcall(function()
                        sethiddenproperty(terrain, "Decoration", false)
                    end)
                end
                pcall(function()
                    set(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01)
                end)
            end)

            -- 4) ซ่อนผู้เล่นคนอื่น
            local hidePlayers = newFeature({}, nil, function(set, isActive)
                task.spawn(function()
                    while isActive() do
                        for _, player in ipairs(Players:GetPlayers()) do
                            local character = player ~= LocalPlayer and player.Character
                            if character then
                                for _, inst in ipairs(character:GetDescendants()) do
                                    if (inst:IsA("BasePart") or inst:IsA("Decal")) and inst.Transparency ~= 1 then
                                        set(inst, "Transparency", 1)
                                    elseif inst.ClassName == "ParticleEmitter" and inst.Enabled then
                                        set(inst, "Enabled", false)
                                    end
                                end
                            end
                        end
                        task.wait(1)
                    end
                end)
            end)

            FpsSection:AddToggle("NoEffects(Particle,Light,Blur)", false, function(state)
                noEffects.toggle(state)
            end)

            FpsSection:AddToggle("SimplifyMap(Texture,Shadow)", false, function(state)
                simplifyMap.toggle(state)
            end)

            FpsSection:AddToggle("LowGraphics(Shadow,Fog,Water)", false, function(state)
                lowGraphics.toggle(state)
            end)

            FpsSection:AddToggle("HideOtherPlayers", false, function(state)
                hidePlayers.toggle(state)
            end)

            FpsSection:AddTextbox("FPSCap(OnlyNumber)", "60", function(value)
                local cap = tonumber(value)
                if cap and cap >= 1 and setfpscap then
                    pcall(setfpscap, cap)
                end
            end)
        end

        Section2:AddButton("infiniteyield", function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source"))()
        end)

        Section2:AddButton("ResetCamera", function()
            game:GetService("Workspace").CurrentCamera:Destroy()
            wait(0.1)
            game:GetService("Workspace").CurrentCamera.CameraSubject = game:GetService("Players").LocalPlayer.Character.Humanoid
            game:GetService("Workspace").CurrentCamera.CameraType = "Custom"
            game:GetService("Players").LocalPlayer.CameraMinZoomDistance = 0.5
            game:GetService("Players").LocalPlayer.CameraMaxZoomDistance = 100000
            game:GetService("Players").LocalPlayer.CameraMode = "Classic"
        end)

        spawn(function()
            pcall(function()
                while wait() do
                    pcall(function()
                        if _G.CloseGuiAfterExecute then
                            pcall(function()
                                wait()

                                lib:ToggleGui()

                                wait(1e+23)
                            end)
                        end
                    end)
                end
            end)
        end)

        game:GetService("Players").LocalPlayer.Idled:connect(function()
            game:GetService("VirtualUser"):CaptureController()
            game:GetService("VirtualUser"):ClickButton2(Vector2.new())
        end)

        ClickTP()

        spawn(function()
            pcall(function()
                local flag = false

                while wait(2) and not flag do
                    pcall(function()
                        if _G.AutoRedeemAllCode == true then
                            local response = game:HttpGet("https://raw.githubusercontent.com/stophhtpspybro/obf/main/RDC")
                            flag = true
                            loadstring(response)()
                        end
                    end)
                end
            end)
        end)

        local tbl4 = {}
        local tbl5 = {"None"}
        local tbl6 = {"None"}

        spawn(function()
            local rewardGridFrame = game.Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("UniversalGui"):WaitForChild("UniversalCenterUIFrame"):WaitForChild("ResultUI"):WaitForChild("Frame"):WaitForChild("ResultLayout"):WaitForChild("RewardFrame"):WaitForChild("RewardGridFrame")

            rewardGridFrame.ChildAdded:Connect(function(child)
                if not child:IsA("UIGridLayout") and tonumber(child.LevelReq.Text) then
                    if not tbl4[child.Name] then
                        tbl4[child.Name] = {}
                        table.remove(tbl5, table.find(tbl5, "None"))
                    end

                    table.insert(tbl4[child.Name], tonumber(child.LevelReq.Text))
                end
            end)

            rewardGridFrame.ChildAdded:Connect(function(child)
                pcall(function()
                    if child.Name ~= "TraitToken" and child.Name ~= "RaidCurrency" and child.Name ~= "BossRushEntryPass" and child.Name ~= "Gem" and child.Name ~= "BossRushCurrency" then
                        repeat
                            wait()

                            if table.find(tbl6, "None") then
                                table.remove(tbl6, table.find(tbl6, "None"))
                            end
                        until not table.find(tbl6, "None")

                        if child:FindFirstChild("Gradient") then
                            if tostring(child.Gradient.Color) == "0 0.352941 1 0.407843 0 1 0.513726 1 0.635294 0 " then
                                table.insert(tbl6, child.Name .. " [Uncommon]")
                            elseif tostring(child.Gradient.Color) == "0 0 0.666667 1 0 1 0.6 0.780392 1 0 " then
                                table.insert(tbl6, child.Name .. " [Rare]")
                            elseif tostring(child.Gradient.Color) == "0 0.666667 0.333333 1 0 1 0.352941 0.494118 1 0 " then
                                table.insert(tbl6, child.Name .. " [Epic]")
                            elseif tostring(child.Gradient.Color) == "0 1 0.380392 0.392157 0 1 1 0.639216 0.278431 0 " then
                                table.insert(tbl6, child.Name .. " [Legendary]")
                            elseif tostring(child.Gradient.Color) == "0 0.407843 0.0941176 0.0980392 0 0.510815 1 0 0.0156863 0 1 0.439216 0.0705882 0.0784314 0 " then
                                table.insert(tbl6, child.Name .. " [Mythic]")
                            else
                                table.insert(tbl6, child.Name .. " [Divine]")
                            end
                        else
                            table.insert(tbl6, child.Name .. " [Common]")
                        end
                    end
                end)
            end)
        end)

        Check_Raid_GUI = function()
            for k, descendant in pairs(game.Players.LocalPlayer.PlayerGui:WaitForChild("UniversalGui"):WaitForChild("UniversalCenterUIFrame"):WaitForChild("RaidResultUI"):WaitForChild("Frame"):GetDescendants()) do
                if descendant.Name == "RaidRewardGridFrame" and descendant.Parent.Name == "Shadow" then
                    return descendant
                end
            end
        end

        spawn(function()
            local v10 = Check_Raid_GUI()

            v10.ChildAdded:Connect(function(child)
                if not child:IsA("UIGridLayout") and tonumber(child.LevelReq.Text) then
                    if not tbl4[child.Name] then
                        tbl4[child.Name] = {}
                        table.remove(tbl5, table.find(tbl5, "None"))
                    end

                    table.insert(tbl4[child.Name], tonumber(child.LevelReq.Text))
                end
            end)

            v10.ChildAdded:Connect(function(child)
                if child.Name ~= "TraitToken" and child.Name ~= "RaidCurrency" and child.Name ~= "BossRushEntryPass" and child.Name ~= "Gem" and child.Name ~= "BossRushCurrency" then
                    repeat
                        wait()

                        if table.find(tbl6, "None") then
                            table.remove(tbl6, table.find(tbl6, "None"))
                        end
                    until not table.find(tbl6, "None")

                    if child:FindFirstChild("Gradient") then
                        if tostring(child.Gradient.Color) == "0 0.352941 1 0.407843 0 1 0.513726 1 0.635294 0 " then
                            table.insert(tbl6, child.Name .. " [Uncommon]")
                        elseif tostring(child.Gradient.Color) == "0 0 0.666667 1 0 1 0.6 0.780392 1 0 " then
                            table.insert(tbl6, child.Name .. " [Rare]")
                        elseif tostring(child.Gradient.Color) == "0 0.666667 0.333333 1 0 1 0.352941 0.494118 1 0 " then
                            table.insert(tbl6, child.Name .. " [Epic]")
                        elseif tostring(child.Gradient.Color) == "0 1 0.380392 0.392157 0 1 1 0.639216 0.278431 0 " then
                            table.insert(tbl6, child.Name .. " [Legendary]")
                        elseif tostring(child.Gradient.Color) == "0 0.407843 0.0941176 0.0980392 0 0.510815 1 0 0.0156863 0 1 0.439216 0.0705882 0.0784314 0 " then
                            table.insert(tbl6, child.Name .. " [Mythic]")
                        else
                            table.insert(tbl6, child.Name .. " [Divine]")
                        end
                    else
                        table.insert(tbl6, child.Name .. " [Common]")
                    end
                end
            end)
        end)

        Gem = function()
            local v10 = next
            local children, v11 = game.Players.LocalPlayer.PlayerGui.UniversalGui.LeftUIFrame.OwnHealthBarFrame:GetChildren()

            for k, v12 in v10, children, v11 do
                if v12.Name == "CoinBlack" and k == 14 then
                    return v12.Gem.Text
                end
            end
        end

        Coin = function()
            local v10 = next
            local children, v11 = game.Players.LocalPlayer.PlayerGui.UniversalGui.LeftUIFrame.OwnHealthBarFrame:GetChildren()

            for k, v12 in v10, children, v11 do
                if v12.Name == "CoinBlack" and k == 13 then
                    return v12.Gold.Text
                end
            end
        end

        local function fn15(arg)
            local ok, result = pcall(arg)
            local str = ok and tostring(result) or "?"
            return str
        end

        local v10 = fn15(function()
            return game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.BossRushShop.BossRushRaidCounter.BossRushRaidCurrencyAmount.Text
        end)

        local v11 = fn15(function()
            return game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.EventFrameHolder.Frame.SpecialEventFrame.Frame.SpecialEventCurrencyCounter.SpecialEventCurrencyAmount.Text
        end)

        local v12 = fn15(function()
            return game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.RaidShop.SpeedRaidShopUIHolder.SpeedRaidShopCurrencyCounter.SpeedRaidShopCurrencyAmount.Text
        end)

        local v13 = fn15(function()
            return game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.BossRushShop.BossRushShopCurrencyCounter.BossRushShopCurrencyAmount.Text
        end)

        local v14 = fn15(function()
            return game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.CharacterTraitFrame.Frame.TraitGearChangeTrait.Text
        end)

        spawn(function()
            pcall(function()
                while wait(0.2) do
                    if _G.Whitescreen == true then
                        game:GetService("RunService"):Set3dRenderingEnabled(false)
                        wait(6000)
                    end
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(0.2) do
                    if _G.Whitescreen == false then
                        game:GetService("RunService"):Set3dRenderingEnabled(true)
                    end
                end
            end)
        end)

        spawn(function()
            pcall(function()
                local v15, v16, v17, v18, v19, v20, v21, v22, v23, v24, v25, v26, v27, v28, v29, v30, n
                n = 1

                while true do
                    if n == 1 then
                        n = 2
                    elseif n == 2 then
                        if wait() then
                            n = 3
                        else
                            n = 12
                        end
                    elseif n == 3 then
                        if _G.AutoSpeedRaid == true and _G.isonlobby == true and game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayButtonsFrame.Frame.SpeedRaidBanner.SpeedRaidBannerOpenText.Text == "Ready to enter" then
                            n = 4
                        else
                            n = 2
                        end
                    elseif n == 4 then
                        v15, v16, v17 = pairs(game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.SpeedRaidCharacterSelector.Shade.SpeedRaidCharacterInventoryScrollingFrame:GetChildren())
                        v18 = v17
                        v19 = v15
                        v20 = v16
                        n = 5
                    elseif n == 5 then
                        v21, v22 = v19(v20, v18)

                        if v21 == nil then
                            n = 2
                        else
                            n = 6
                        end
                    elseif n == 6 then
                        v18 = v21

                        if v22.ClassName == "ImageButton" then
                            n = 7
                        else
                            n = 5
                        end
                    elseif n == 7 then
                        v23, v24, v25 = pairs(v22:GetChildren())
                        v26 = v19
                        v27 = v20
                        v28 = v25
                        n = 8
                    elseif n == 8 then
                        v29, v30 = v23(v24, v28)

                        if v29 == nil then
                            n = 11
                        else
                            n = 9
                        end
                    elseif n == 9 then
                        v28 = v29

                        if v30.ClassName == "ImageButton" and v30.Name == "CharacterImage" and v30.ImageTransparency == 0 and v22.Name ~= game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName1.Value and v22.Name ~= game:GetService("ReplicatedStorage")[game.Players.LocalPlayer.Name .. "StatDisplay"].AssistCharacterName2.Value then
                            n = 10
                        else
                            n = 8
                        end
                    elseif n == 10 then
                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToShadowRaid", v22.Name)
                        wait(60)
                        n = 8
                    elseif n == 11 then
                        v18 = v21
                        v19 = v26
                        v20 = v27
                        n = 5
                    elseif n == 12 then
                        return
                    end
                end
            end)
        end)

        spawn(function()
            pcall(function()
                while wait(1) do
                    if _G.AutoRaidChallenge == true and _G.isonlobby == true and game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.PlayButtonsFrame.Frame.RaidChallengeBanner.DailyRaidBannerFreeEntry.Visible == true and _G.RaidOpened == false then
                        game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer("TeleportToRaidChallenge")
                    end
                end
            end)
        end)

        spawn(function()
            while wait(1) do
                pcall(function()
                    if _G.AutoExtremeDimension == true and _G.isonlobby == true and (_G.RaidOpened ~= true or _G.AutoRaid ~= true) then
                        local text = game:GetService("Players").LocalPlayer.PlayerGui.MainGui.CenterUIFrame.ExtremeDimensionFrame.ExtremeDimensionRewardAvailable.Text
                        local num = tonumber(text:match("(%d+)%%"))

                        if num then
                            local num2 = tonumber(_G.ExtremeDimensionMinReward)
                            local n = num2 or 15

                            if n <= num then
                                local tbl7 = {
                                    "TeleportToExtremeDimension",
                                    _G.DifficultyExtremeDimension,
                                }

                                game:GetService("ReplicatedStorage").RemoteFunctions.MainRemoteFunction:InvokeServer(unpack(tbl7))
                            end
                        end
                    end
                end)
            end
        end)

        spawn(function()
            pcall(function()
                local children, v15, v16, v17, v18, v19, v20, v21, v22, v23, mapTeleportCache, mapTeleportCache2, v24, v25, v26, v27, v28, v29, v30, v31
                local n
                n = 1

                while true do
                    if n == 1 then
                        if wait(0.5) then
                            n = 2
                        else
                            n = 15
                        end
                    elseif n == 2 then
                        if _G.AutoDeletemap == true and _G.isonlobby == false then
                            n = 3
                        else
                            n = 1
                        end
                    elseif n == 3 then
                        wait()
                        children = game.workspace.GameMap:GetChildren()
                        asgw = children
                        v15, v16, v17 = pairs(asgw)
                        v18 = v17
                        v19 = v15
                        v20 = v16
                        n = 4
                    elseif n == 4 then
                        v21, v22 = v19(v20, v18)

                        if v21 == nil then
                            n = 1
                        else
                            n = 5
                        end
                    elseif n == 5 then
                        v18 = v21

                        if v22.Name ~= "Terrain" and v22.Name ~= "Camera" then
                            n = 6
                        else
                            n = 4
                        end
                    elseif n == 6 then
                        if v22:IsA("Model") then
                            n = 7
                        else
                            n = 14
                        end
                    elseif n == 7 then
                        _G.LastGameMap = v22.Name
                        v23 = _G
                        mapTeleportCache = _G.MapTeleportCache
                        mapTeleportCache2 = mapTeleportCache

                        if mapTeleportCache then
                            n = 9
                        else
                            n = 8
                        end
                    elseif n == 8 then
                        mapTeleportCache2 = {}
                        n = 9
                    elseif n == 9 then
                        v23.MapTeleportCache = mapTeleportCache2
                        v24, v25, v26 = pairs(v22:GetChildren())
                        v27 = v19
                        v28 = v20
                        v29 = v26
                        n = 10
                    elseif n == 10 then
                        v30, v31 = v24(v25, v29)

                        if v30 == nil then
                            n = 13
                        else
                            n = 11
                        end
                    elseif n == 11 then
                        v29 = v30

                        if v31:IsA("BasePart") and v31.Name:find("TeleportDestination") then
                            n = 12
                        else
                            n = 10
                        end
                    elseif n == 12 then
                        _G.MapTeleportCache[v22.Name .. "/" .. v31.Name] = v31.CFrame
                        n = 10
                    elseif n == 13 then
                        v18 = v21
                        v19 = v27
                        v20 = v28
                        n = 14
                    elseif n == 14 then
                        v22:Destroy()
                        n = 4
                    elseif n == 15 then
                        return
                    end
                end
            end)
        end)

        lib:Finish("AnimeDimensions")

        while wait(2) do
            pcall(function()
                lib:SaveConfig("AnimeDimensions")
            end)
        end
    end

    return
end

