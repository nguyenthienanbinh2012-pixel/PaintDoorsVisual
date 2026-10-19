local Repository = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local success, Obsidian = pcall(function()
    return loadstring(game:HttpGet(Repository .. "Library.lua"))()
end)
if not success or type(Obsidian) ~= "table" then
    task.wait(0.2)
    local ok, lib = pcall(function()
        return loadstring(game:HttpGet(Repository .. "Library.lua"))()
    end)
    if ok and type(lib) == "table" then Obsidian = lib
    else error("Khong the tai thu vien UI Obsidian!") end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local currentLanguage = "Tiếng Việt"
local function L(vi, en) return currentLanguage == "English" and en or vi end

task.spawn(function()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = "rbxassetid://9119802009"
        s.Volume = 2.0
        s.Parent = SoundService
        s:Play()
        task.delay(3, function() if s then s:Destroy() end end)
    end)
end)

local Window = Obsidian:CreateWindow({
    Title = "TwinKhook V11 [Fixed]",
    SubTitle = "By PaintCrack",
    TabWidth = 100,
    Size = UDim2.new(0, 580, 0, 320),
    Center = true,
    AutoShow = true,
    MenuFadeTime = 0.15
})

local Tabs = {
    Main = Window:AddTab("Main", "user"),
    ESP = Window:AddTab("ESP", "eye"),
    Objects = Window:AddTab("Objects", "box"),
    Sound = Window:AddTab("Sound", "music"),
    Settings = Window:AddTab("Settings", "cog")
}

local MainLeft = Tabs.Main:AddLeftGroupbox("Exploits")
local EspLeft = Tabs.ESP:AddLeftGroupbox("Doors & Entities")
local EspRight = Tabs.ESP:AddRightGroupbox("Players & Support")
local ObjectsLeft = Tabs.Objects:AddLeftGroupbox("Room Objects ESP")
local ObjectsRight = Tabs.Objects:AddRightGroupbox("Filters")
local SoundLeft = Tabs.Sound:AddLeftGroupbox("Notification")
local SoundRight = Tabs.Sound:AddRightGroupbox("Alert Settings")
local SettingsLeft = Tabs.Settings:AddLeftGroupbox("Ngôn ngữ / Language")
local SettingsRight = Tabs.Settings:AddRightGroupbox("Menu Settings")

local state = {
    espColor = Color3.fromRGB(0, 255, 200),
    itemColor = Color3.fromRGB(180, 50, 255),
    objectsColor = Color3.fromRGB(0, 255, 100),
    soundEnabled = true,
    soundVolume = 2.0,
    soundId = "rbxassetid://9119802009",
    reachMode = "Teleport",
    reachMultiplier = 1.5,
}

local allEntities = {
    ["rush"]    = {vi="Tấn công nhanh", en="Rush",    enabled=true},
    ["ambush"]  = {vi="Tấn công bất ngờ", en="Ambush", enabled=true},
    ["sally"]   = {vi="Sally",        en="Sally",   enabled=true},
    ["figure"]  = {vi="Con rối",      en="Figure",  enabled=true},
    ["seek"]    = {vi="Mắt đuổi",     en="Seek",    enabled=true},
    ["eyes"]    = {vi="Ánh mắt",      en="Eyes",    enabled=true},
    ["halt"]    = {vi="Dừng lại",     en="Halt",    enabled=true},
    ["glitch"]  = {vi="Lỗi hệ thống", en="Glitch",  enabled=true},
    ["dupe"]    = {vi="Cửa giả",      en="Dupe",    enabled=true},
    ["screech"] = {vi="Tiếng thét",   en="Screech", enabled=true},
    ["timothy"] = {vi="Nhện",         en="Timothy", enabled=true},
    ["a60"]     = {vi="A-60",         en="A-60",    enabled=true},
    ["a90"]     = {vi="A-90",         en="A-90",    enabled=true},
    ["a120"]    = {vi="A-120",        en="A-120",   enabled=true},
}

local function playNotifySound()
    if not state.soundEnabled then return end
    task.spawn(function()
        local s = Instance.new("Sound")
        s.SoundId = state.soundId
        s.Volume = state.soundVolume
        s.Parent = SoundService
        s:Play()
        task.delay(4, function() if s then s:Destroy() end end)
    end)
end

local function notify(title, desc)
    Obsidian:Notify({Title = title, Description = desc, Time = 3})
    playNotifySound()
end

SoundLeft:AddToggle("SoundEnabled", {
    Text = "Bật âm thanh thông báo",
    Default = true,
    Callback = function(v) state.soundEnabled = v end
})

SoundLeft:AddSlider("SoundVolume", {
    Text = "Âm lượng",
    Default = 2, Min = 0, Max = 10, Rounding = 1, Compact = true,
    Callback = function(v) state.soundVolume = v end
})

SoundLeft:AddInput("SoundIdInput", {
    Text = "Sound ID",
    Default = "rbxassetid://9119802009",
    Placeholder = "rbxassetid://...",
    Callback = function(v) state.soundId = v end
})

SoundLeft:AddButton("TestSoundBtn", "🔊 Test Âm Thanh", function()
    notify(L("Test", "Test"), L("Đây là thông báo thử nghiệm!", "This is a test notification!"))
end)

SoundRight:AddButton("TestNotifyBtn", "📢 Test Notify", function()
    Obsidian:Notify({
        Title = L("Xin chào", "Hello"),
        Description = L("Thông báo hoạt động bình thường.", "Notification works fine."),
        Time = 4
    })
end)

SettingsLeft:AddDropdown("LanguageDropdown", {
    Values = {"Tiếng Việt", "English"},
    Default = 1, Multi = false,
    Text = "Chọn ngôn ngữ / Language",
    Callback = function(v) state.selectedLang = v end
})

SettingsLeft:AddButton("ApplyLangBtn", "✅ Áp dụng ngôn ngữ", function()
    currentLanguage = state.selectedLang or "Tiếng Việt"
    notify(
        L("Đã đổi ngôn ngữ", "Language Changed"),
        L("ESP sẽ dùng tiếng Việt.", "ESP will use English.")
    )
    for _, data in pairs(trackedEntities or {}) do
        if data.tl and data.tl.Parent and data.key and allEntities[data.key] then
            local info = allEntities[data.key]
            data.tl.Text = (currentLanguage == "English") and info.en or info.vi
        end
    end
end)

SettingsRight:AddButton("RejoinServer", "🔄 Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

SettingsRight:AddButton("UnloadMenu", "❌ Unload Menu", function()
    Obsidian:Unload()
end)

MainLeft:AddDropdown("ReachModeDropdown", {
    Values = {"Teleport", "RemoteEvent"}, Default = 1, Multi = false,
    Text = "Phương thức Reach",
    Callback = function(v) state.reachMode = v end
})

MainLeft:AddSlider("ReachSlider", {
    Text = "Reach Distance",
    Default = 1.5, Min = 1, Max = 11, Rounding = 1, Compact = true,
    Callback = function(v) state.reachMultiplier = v end
})

local function checkDoorLocked(door)
    if not door then return false end
    if door:GetAttribute("Locked") or door:GetAttribute("IsLocked") then return true end
    for _, v in ipairs(door:GetDescendants()) do
        local n = v.Name:lower()
        if (v:IsA("BasePart") or v:IsA("Model")) and (n:find("lock") or n:find("padlock") or n:find("code")) then
            if (v:IsA("BasePart") and v.Transparency ~= 1) or v:IsA("Model") then return true end
        end
    end
    return false
end

local function checkDoorOpen(door)
    if not door then return false end
    if door:GetAttribute("Opened") or door:GetAttribute("IsOpen") then return true end
    for _, v in ipairs(door:GetDescendants()) do
        local n = v.Name:lower()
        if v:IsA("BoolValue") and (n:find("open") or n:find("unlock")) and v.Value then return true end
    end
    return false
end

local reachToggle = MainLeft:AddToggle("ReachToggle", {
    Text = "Reach Doors", Default = false
})

reachToggle:OnChanged(function(v)
    if not v then return end
    task.spawn(function()
        local lastTP = 0
        while reachToggle.Value do
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if char and hum and hum.Health > 0 and hrp then
                local cur = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
                local rooms = Workspace:FindFirstChild("CurrentRooms")
                local roomObj = rooms and cur and rooms:FindFirstChild(tostring(cur))
                if roomObj and roomObj:FindFirstChild("Door") then
                    local door = roomObj.Door
                    local doorPart = door:FindFirstChild("Door") or door:FindFirstChildWhichIsA("BasePart")
                    if doorPart and (hrp.Position - doorPart.Position).Magnitude <= (state.reachMultiplier * 4.0) then
                        if not checkDoorOpen(door) and not checkDoorLocked(door) and (tick() - lastTP > 0.4) then
                            lastTP = tick()
                            pcall(function()
                                if state.reachMode == "RemoteEvent" then
                                    if door:FindFirstChild("ClientOpen") then door.ClientOpen:FireServer() end
                                    local prompt = door:FindFirstChildWhichIsA("ProximityPrompt", true)
                                    if prompt then fireproximityprompt(prompt) end
                                else
                                    local oldCF = hrp.CFrame
                                    hrp.CFrame = doorPart.CFrame + Vector3.new(0, 0, 2)
                                    RunService.Heartbeat:Wait()
                                    if door:FindFirstChild("ClientOpen") then door.ClientOpen:FireServer() end
                                    hrp.CFrame = oldCF
                                end
                            end)
                        end
                    end
                end
            end
            task.wait(0.2)
        end
    end)
end)

local function createESP(part, color, offsetY, maxDist, sizeX)
    if not part or not part.Parent then return nil, nil end
    local bb = Instance.new("BillboardGui")
    bb.Adornee = part
    bb.Size = UDim2.new(0, sizeX or 180, 0, 50)
    bb.StudsOffsetWorldSpace = Vector3.new(0, offsetY or 2.5, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = maxDist or 2000
    bb.LightInfluence = 0
    bb.ResetOnSpawn = false
    bb.Parent = part
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = color or Color3.fromRGB(255, 255, 255)
    tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    tl.TextStrokeTransparency = 0
    tl.TextScaled = true
    tl.Font = Enum.Font.FredokaOne
    tl.Parent = bb
    local sc = Instance.new("UIScale")
    sc.Scale = 1.1
    sc.Parent = tl
    return bb, tl
end

local function safeDestroy(inst)
    if inst and typeof(inst) == "Instance" and inst.Parent then
        pcall(function() inst:Destroy() end)
    end
end

local doorESPTracks = {}
local doorConn = nil

EspLeft:AddToggle("DoorEspToggle", {
    Text = "Door ESP", Default = false
}):OnChanged(function(v)
    if not v then
        if doorConn then doorConn:Disconnect() doorConn = nil end
        for _, data in pairs(doorESPTracks) do
            safeDestroy(data.hl); safeDestroy(data.bb)
        end
        doorESPTracks = {}
        return
    end
    local frame = 0
    doorConn = RunService.RenderStepped:Connect(function()
        frame = frame + 1
        if frame % 3 ~= 0 then return end
        local cur = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
        local rooms = Workspace:FindFirstChild("CurrentRooms")
        if not cur or not rooms then return end
        local active = {}
        for i = 0, 1 do
            local r = rooms:FindFirstChild(tostring(cur + i))
            if r and r:FindFirstChild("Door") then active[r.Door] = tostring(cur + i) end
        end
        for door, data in pairs(doorESPTracks) do
            if not active[door] or not door.Parent then
                safeDestroy(data.hl); safeDestroy(data.bb)
                doorESPTracks[door] = nil
            end
        end
        local camPos = workspace.CurrentCamera.CFrame.Position
        for door, roomName in pairs(active) do
            local part = door:FindFirstChild("Door") or door:FindFirstChildWhichIsA("BasePart")
            if part then
                if not doorESPTracks[door] then
                    local hl = Instance.new("Highlight")
                    hl.FillTransparency = 0.6
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = door
                    local bb, tl = createESP(part, state.espColor, 2.5, 2000, 200)
                    doorESPTracks[door] = {hl = hl, bb = bb, tl = tl, part = part}
                end
                local data = doorESPTracks[door]
                local locked = checkDoorLocked(door)
                local dist = math.floor((camPos - part.Position).Magnitude)
                local prefix = L("Phòng", "Room")
                local lockStr = locked and L(" [Khóa]", " [Locked]") or ""
                if data.tl and data.tl.Parent then
                    data.tl.Text = string.format("%s %s%s [%dm]", prefix, roomName, lockStr, dist)
                    data.tl.TextColor3 = locked and Color3.fromRGB(255, 50, 50) or state.espColor
                end
                if data.hl then
                    data.hl.FillColor = locked and Color3.fromRGB(255, 50, 50) or state.espColor
                    data.hl.OutlineColor = locked and Color3.fromRGB(255, 50, 50) or state.espColor
                end
            end
        end
    end)
end)

EspLeft:AddLabel("ESP Color"):AddColorPicker("DoorEspColor", {
    Default = Color3.fromRGB(0, 255, 200), Title = "Màu ESP",
    Callback = function(v) state.espColor = v end
})

local trackedEntities = {}
local entityDescConn = nil
local entityHeartConn = nil

local function matchEntityKey(name)
    local lower = name:lower()
    for k, v in pairs(allEntities) do
        if v.enabled and lower:find(k) then return k end
    end
    return nil
end

local function attachEntity(obj, key)
    if trackedEntities[obj] then return end
    local part = obj:IsA("BasePart") and obj or obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
    if not part then return end
    local bb, tl = createESP(part, Color3.fromRGB(255, 0, 0), 3, 2000, 180)
    if bb then
        trackedEntities[obj] = {bb = bb, tl = tl, part = part, key = key}
    end
end

local function detachEntity(obj)
    local data = trackedEntities[obj]
    if not data then return end
    safeDestroy(data.bb)
    trackedEntities[obj] = nil
end

local entityEspToggle = EspLeft:AddToggle("EntityEspToggle", {
    Text = "Entity ESP (Advanced)", Default = false
})

entityEspToggle:OnChanged(function(v)
    if not v then
        if entityDescConn then entityDescConn:Disconnect() entityDescConn = nil end
        if entityHeartConn then entityHeartConn:Disconnect() entityHeartConn = nil end
        for obj in pairs(trackedEntities) do detachEntity(obj) end
        return
    end
    entityDescConn = Workspace.DescendantAdded:Connect(function(obj)
        local key = matchEntityKey(obj.Name)
        if key then task.defer(function() attachEntity(obj, key) end) end
    end)
    for _, obj in ipairs(Workspace:GetDescendants()) do
        local key = matchEntityKey(obj.Name)
        if key then attachEntity(obj, key) end
    end
    local frame = 0
    entityHeartConn = RunService.Heartbeat:Connect(function()
        frame = frame + 1
        if frame % 3 ~= 0 then return end
        local camPos = workspace.CurrentCamera.CFrame.Position
        for obj, data in pairs(trackedEntities) do
            if not obj.Parent or not data.part.Parent or not allEntities[data.key].enabled then
                detachEntity(obj)
            else
                local dist = math.floor((camPos - data.part.Position).Magnitude)
                local info = allEntities[data.key]
                local label = (currentLanguage == "English") and info.en or info.vi
                if data.tl and data.tl.Parent then
                    data.tl.Text = string.format("%s [%dm]", label, dist)
                end
            end
        end
    end)
end)

EspLeft:AddButton("ConfigEntitiesBtn", "⚙️ Chọn Entity ESP", function()
    local CW = Obsidian:CreateWindow({
        Title = "Entity ESP Config", SubTitle = "Chọn thực thể",
        TabWidth = 100, Size = UDim2.new(0, 600, 0, 400),
        Center = true, AutoShow = true, MenuFadeTime = 0.15
    })
    local tab = CW:AddTab("Entities", "list")
    local left = tab:AddLeftGroupbox("Bulk")
    local right = tab:AddRightGroupbox("Danh sách")
    left:AddButton("All", "✔ Chọn tất cả", function()
        for _, d in pairs(allEntities) do d.enabled = true end
    end)
    left:AddButton("None", "❌ Bỏ chọn tất cả", function()
        for _, d in pairs(allEntities) do d.enabled = false end
    end)
    for k, d in pairs(allEntities) do
        right:AddToggle("Ent_" .. k, {
            Text = d.en .. " (" .. d.vi .. ")",
            Default = d.enabled,
            Callback = function(v) d.enabled = v end
        })
    end
end)

local trackedPlayers = {}
local playerAddedConn = nil
local playerCharConns = {}

local function cleanupPlayer(plr)
    local data = trackedPlayers[plr]
    if not data then return end
    safeDestroy(data.hl); safeDestroy(data.bb)
    trackedPlayers[plr] = nil
    if playerCharConns[plr] then
        playerCharConns[plr]:Disconnect()
        playerCharConns[plr] = nil
    end
end

local function setupPlayer(plr)
    if plr == LocalPlayer then return end
    local function onChar(char)
        cleanupPlayer(plr)
        local hl = Instance.new("Highlight")
        hl.FillColor = Color3.fromRGB(190, 130, 80)
        hl.OutlineColor = Color3.fromRGB(240, 180, 110)
        hl.FillTransparency = 0.4
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.Parent = char
        local head = char:WaitForChild("Head", 3)
        local bb, tl
        if head then
            bb, tl = createESP(head, Color3.fromRGB(255, 210, 140), 2.5, 2000, 140)
            if tl then tl.Text = plr.Name end
        end
        trackedPlayers[plr] = {hl = hl, bb = bb, tl = tl}
    end
    if plr.Character then onChar(plr.Character) end
    playerCharConns[plr] = plr.CharacterAdded:Connect(onChar)
end

local playerEspToggle = EspRight:AddToggle("PlayerEspToggle", {
    Text = "Player ESP", Default = false
})

playerEspToggle:OnChanged(function(v)
    if not v then
        if playerAddedConn then playerAddedConn:Disconnect() playerAddedConn = nil end
        for plr in pairs(trackedPlayers) do cleanupPlayer(plr) end
        for plr, conn in pairs(playerCharConns) do
            conn:Disconnect()
            playerCharConns[plr] = nil
        end
        return
    end
    for _, p in ipairs(Players:GetPlayers()) do setupPlayer(p) end
    playerAddedConn = Players.PlayerAdded:Connect(setupPlayer)
end)

local trackedHidden = {}
local hiddenConn = nil

local hiddenToggle = EspRight:AddToggle("HiddenSupportToggle", {
    Text = "Hidden Support ESP", Default = false
})

hiddenToggle:OnChanged(function(v)
    if not v then
        if hiddenConn then hiddenConn:Disconnect() hiddenConn = nil end
        for _, data in pairs(trackedHidden) do
            safeDestroy(data.hl); safeDestroy(data.bb)
        end
        trackedHidden = {}
        return
    end
    local frame = 0
    hiddenConn = RunService.RenderStepped:Connect(function()
        frame = frame + 1
        if frame % 4 ~= 0 then return end
        local cur = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
        if not cur or not Workspace.CurrentRooms then return end
        local seen = {}
        for i = 0, 1 do
            local r = Workspace.CurrentRooms:FindFirstChild(tostring(cur + i))
            if r then
                for _, d in ipairs(r:GetDescendants()) do
                    local n = d.Name:lower()
                    if n:find("wardrobe") or n:find("closet") or n:find("bed") or n:find("hide") then
                        seen[d] = true
                        if not trackedHidden[d] then
                            local part = d:IsA("BasePart") and d or d:FindFirstChildWhichIsA("BasePart")
                            if part then
                                local hl = Instance.new("Highlight")
                                    hl.FillColor = Color3.fromRGB(255, 220, 0)
                                hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                                hl.FillTransparency = 0.5
                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                hl.Parent = d
                                local bb, tl = createESP(part, Color3.fromRGB(255, 220, 0), 2, 2000, 120)
                                if tl then tl.Text = L("Chỗ Trốn", "Hiding Spot") end
                                trackedHidden[d] = {hl = hl, bb = bb, tl = tl}
                            end
                        end
                    end
                end
            end
        end
        for obj, data in pairs(trackedHidden) do
            if not seen[obj] or not obj.Parent then
                safeDestroy(data.hl); safeDestroy(data.bb)
                trackedHidden[obj] = nil
            end
        end
    end)
end)

local validItems = {"candle","lighter","bandaid","cross","crucifix","gun","ammo","bomb","glowstick","book","battery","shears"}
local trackedItems = {}
local itemConn = nil

local itemToggle = ObjectsRight:AddToggle("ItemEspToggle", {
    Text = "Item ESP", Default = false
})

ObjectsRight:AddLabel("Item Color"):AddColorPicker("ItemEspColor", {
    Default = Color3.fromRGB(180, 50, 255), Title = "Màu Item",
    Callback = function(v) state.itemColor = v end
})

itemToggle:OnChanged(function(v)
    if not v then
        if itemConn then itemConn:Disconnect() itemConn = nil end
        for _, data in pairs(trackedItems) do
            safeDestroy(data.hl); safeDestroy(data.bb)
        end
        trackedItems = {}
        return
    end
    local frame = 0
    itemConn = RunService.RenderStepped:Connect(function()
        frame = frame + 1
        if frame % 4 ~= 0 then return end
        local cur = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
        if not cur or not Workspace.CurrentRooms then return end
        local r = Workspace.CurrentRooms:FindFirstChild(tostring(cur))
        if not r then return end
        local seen = {}
        for _, d in ipairs(r:GetDescendants()) do
            local n = d.Name:lower()
            if not n:find("key") and not n:find("padlock") then
                local hasPrompt = d:IsA("ProximityPrompt") or d:FindFirstChildWhichIsA("ProximityPrompt", true)
                if hasPrompt then
                    for _, k in ipairs(validItems) do
                        if n:find(k) then seen[d] = true break end
                    end
                end
            end
        end
        for obj, data in pairs(trackedItems) do
            if not seen[obj] or not obj.Parent then
                safeDestroy(data.hl); safeDestroy(data.bb)
                trackedItems[obj] = nil
            end
        end
        for obj in pairs(seen) do
            if not trackedItems[obj] then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = state.itemColor
                    hl.OutlineColor = state.itemColor
                    hl.FillTransparency = 0.5
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = obj
                    local bb, tl = createESP(part, state.itemColor, 2, 2000, 120)
                    if tl then tl.Text = obj.Name end
                    trackedItems[obj] = {hl = hl, bb = bb, tl = tl}
                end
            end
        end
    end)
end)

local validObjects = {"key","doorkey","keydoor","electrical","box","chest","breaker","padlock","lever"}
local trackedObjects = {}
local objectsConn = nil

local objectsToggle = ObjectsLeft:AddToggle("ObjectsEspToggle", {
    Text = "Objects ESP", Default = false
})

ObjectsLeft:AddLabel("Objects Color"):AddColorPicker("ObjectsEspColor", {
    Default = Color3.fromRGB(0, 255, 100), Title = "Màu Objects",
    Callback = function(v) state.objectsColor = v end
})

objectsToggle:OnChanged(function(v)
    if not v then
        if objectsConn then objectsConn:Disconnect() objectsConn = nil end
        for _, data in pairs(trackedObjects) do
            safeDestroy(data.hl); safeDestroy(data.bb)
        end
        trackedObjects = {}
        return
    end
    local frame = 0
    objectsConn = RunService.RenderStepped:Connect(function()
        frame = frame + 1
        if frame % 4 ~= 0 then return end
        local cur = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
        if not cur or not Workspace.CurrentRooms then return end
        local r = Workspace.CurrentRooms:FindFirstChild(tostring(cur))
        if not r then return end
        local seen = {}
        for _, d in ipairs(r:GetDescendants()) do
            local n = d.Name:lower()
            if not n:find("drawer") and not n:find("locker") then
                local hasPrompt = d:IsA("ProximityPrompt") or d:FindFirstChildWhichIsA("ProximityPrompt", true)
                if hasPrompt then
                    for _, k in ipairs(validObjects) do
                        if n:find(k) then seen[d] = true break end
                    end
                end
            end
        end
        for obj, data in pairs(trackedObjects) do
            if not seen[obj] or not obj.Parent then
                safeDestroy(data.hl); safeDestroy(data.bb)
                trackedObjects[obj] = nil
            end
        end
        for obj in pairs(seen) do
            if not trackedObjects[obj] then
                local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                if part then
                    local hl = Instance.new("Highlight")
                    hl.FillColor = state.objectsColor
                    hl.OutlineColor = state.objectsColor
                    hl.FillTransparency = 0.5
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = obj
                    local displayName = obj.Name
                    if displayName:lower():find("key") then displayName = "Key Door" end
                    local bb, tl = createESP(part, state.objectsColor, 2, 2000, 130)
                    if tl then tl.Text = displayName end
                    trackedObjects[obj] = {hl = hl, bb = bb, tl = tl}
                end
            end
        end
    end)
end)

task.spawn(function()
    task.wait(0.5)
    notify("VisualZpaint",
           L("Xin Chao!",
             "Fixed text tilt, ESP disappearing, Sound & Setting tabs."))
end)
