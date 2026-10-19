local Repository = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
local success, Obsidian = pcall(function()
    return loadstring(game:HttpGet(Repository .. "Library.lua"))()
end)

if not success or type(Obsidian) ~= "table" then
    task.wait(0.1)
    local retrySuccess, retryLib = pcall(function()
        return loadstring(game:HttpGet(Repository .. "Library.lua"))()
    end)
    if retrySuccess and type(retryLib) == "table" then
        Obsidian = retryLib
    else
        error("Khong the tai thu vien UI Obsidian!")
    end
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local SoundService = game:GetService("SoundService")
local LocalPlayer = Players.LocalPlayer

local currentLanguage = "Tiếng Việt"

-- Khởi tạo âm thanh an toàn với bộ nhớ
task.spawn(function()
    pcall(function()
        local initSound = Instance.new("Sound")
        initSound.SoundId = "rbxassetid://9119802009"
        initSound.Volume = 2.0
        initSound.Parent = SoundService
        initSound:Play()
        task.delay(3, function()
            if initSound then initSound:Destroy() end
        end)
    end)
    task.wait(0.5)
    Obsidian:Notify({
        Title = "TwinKhook V10 - Strict Mode",
        Description = "Đã tối ưu hóa hiệu năng & chống rò rỉ RAM!",
        Time = 3
    })
end)

local Window = Obsidian:CreateWindow({
    Title = "TwinKhook V10 [Optimized]",
    SubTitle = "By PaintCrack",
    TabWidth = 100,
    Size = UDim2.new(0, 550, 0, 280),
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
local MainRight = Tabs.Main:AddRightGroupbox("Optimization")
local EspLeft = Tabs.ESP:AddLeftGroupbox("Doors & Entities")
local EspRight = Tabs.ESP:AddRightGroupbox("Players & Support")
local ObjectsLeft = Tabs.Objects:AddLeftGroupbox("Room Objects ESP")
local ObjectsRight = Tabs.Objects:AddRightGroupbox("Filters")
local SoundLeft = Tabs.Sound:AddLeftGroupbox("Entity Notification")
local SoundRight = Tabs.Sound:AddRightGroupbox("Alert Settings")
SoundLeft:AddToggle("Patch_SoundOn", {
    Text = "Bật âm thanh thông báo",
    Default = true,
    Callback = function(v) _G.__soundEnabled = v end
})
_G.__soundEnabled = true

SoundLeft:AddButton("Patch_TestSound", "🔊 Test Âm Thanh", function()
    local s = Instance.new("Sound")
    s.SoundId = "rbxassetid://9119802009"
    s.Volume = 2
    s.Parent = SoundService
    s:Play()
    task.delay(3, function() if s then s:Destroy() end end)
    Obsidian:Notify({Title = "Test", Description = "Âm thanh + thông báo hoạt động!", Time = 3})
end)
local SettingsLeft = Tabs.Settings:AddLeftGroupbox("Ngôn ngữ / Language")
local SettingsRight = Tabs.Settings:AddRightGroupbox("Menu Settings")

-- SETTINGS
local selectedLang = "Tiếng Việt"
local langDropdown = SettingsLeft:AddDropdown("LanguageDropdown", {
    Values = {"Tiếng Việt", "English"}, Default = 1, Multi = false,
    Text = "Chọn ngôn ngữ", Tooltip = "Đổi ngôn ngữ giao diện & ESP"
})
langDropdown:OnChanged(function(v) selectedLang = v end)

SettingsLeft:AddButton("Change Translation", function()
    currentLanguage = selectedLang
    Obsidian:Notify({
        Title = currentLanguage == "English" and "Language Updated" or "Đã cập nhật",
        Description = currentLanguage == "English" and "Switched to English!" or "Đã chuyển sang Tiếng Việt!",
        Time = 3
    })
end)

SettingsRight:AddButton("RejoinServer", "Rejoin Game", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
end)

SettingsRight:AddButton("UnloadMenu", "Unload Menu", function()
    Obsidian:Unload()
end)

-- REACH DOORS (Tối ưu hóa vòng lặp, kiểm tra kỹ trạng thái nhân vật)
local reachMode = "Teleport"
MainLeft:AddDropdown("ReachModeDropdown", {
    Values = {"Teleport", "RemoteEvent"}, Default = 1, Multi = false,
    Text = "Phương thức Reach", Tooltip = "Chọn cách thức mở cửa"
}):OnChanged(function(v) reachMode = v end)

local reachMultiplier = 1.5
MainLeft:AddSlider("ReachSlider", {
    Text = "Reach Distance", Default = 1.5, Min = 1, Max = 11, Rounding = 1, Compact = true
}):OnChanged(function(v) reachMultiplier = v end)

local reachToggle = MainLeft:AddToggle("ReachToggle", {
    Text = "Reach Doors", Default = false, Tooltip = "Tự động mở cửa từ xa an toàn"
})

local function checkDoorLocked(door)
    if not door then return false end
    if door:GetAttribute("Locked") or door:GetAttribute("IsLocked") then return true end
    if door.Parent and door.Parent:GetAttribute("Locked") then return true end
    for _, v in pairs(door:GetDescendants()) do
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
    for _, v in pairs(door:GetDescendants()) do
        local n = v.Name:lower()
        if v:IsA("BoolValue") and (n:find("open") or n:find("unlock")) and v.Value then return true end
    end
    return false
end

reachToggle:OnChanged(function(Value)
    task.spawn(function()
        local lastTP = 0
        while reachToggle.Value do
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            
            if char and hum and hum.Health > 0 and hrp then
                local currentRoom = LocalPlayer:GetAttribute("CurrentRoom")
                local rooms = Workspace:FindFirstChild("CurrentRooms")
                local roomObj = rooms and rooms:FindFirstChild(tostring(currentRoom))
                
                if roomObj and roomObj:FindFirstChild("Door") then
                    local door = roomObj.Door
                    local doorPart = door:FindFirstChild("Door") or door:FindFirstChildWhichIsA("BasePart")
                    if doorPart and (hrp.Position - doorPart.Position).Magnitude <= (reachMultiplier * 4.0) then
                        if not checkDoorOpen(door) and not checkDoorLocked(door) and (tick() - lastTP > 0.4) then
                            lastTP = tick()
                            pcall(function()
                                if reachMode == "RemoteEvent" then
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

if not doorESPTracks[door] then
local doorESPTracks = {}
local doorConn = nil

EspLeft:AddToggle("DoorEspToggle", {
    Text = "Door Hiển Thị", Default = false, Tooltip = "Hiển thị cửa hiện tại và tiếp theo"
}):OnChanged(function(v)
    if not v then
        if doorConn then doorConn:Disconnect() doorConn = nil end
        for door, data in pairs(doorESPTracks) do
            if data.hl then data.hl:Destroy() end
            if data.bb then data.bb:Destroy() end
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
                if data.hl then data.hl:Destroy() end
                if data.bb then data.bb:Destroy() end
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
                    local bb = Instance.new("BillboardGui")
                    bb.Adornee = part
                    bb.Size = UDim2.new(0, 200, 0, 50)
                    bb.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = true
                    bb.MaxDistance = 2000
                    bb.LightInfluence = 0
                    bb.ResetOnSpawn = false
                    bb.Parent = part
                    local tl = Instance.new("TextLabel")
                    tl.Size = UDim2.new(1, 0, 1, 0)
                    tl.BackgroundTransparency = 1
                    tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                    tl.TextStrokeTransparency = 0
                    tl.TextScaled = true
                    tl.Font = Enum.Font.FredokaOne
                    tl.Parent = bb
                    local sc = Instance.new("UIScale")
                    sc.Scale = 1.1
                    sc.Parent = tl
                    doorESPTracks[door] = {hl = hl, bb = bb, tl = tl, part = part}
                end
                local data = doorESPTracks[door]
                local locked = checkDoorLocked(door)
                local dist = math.floor((camPos - part.Position).Magnitude)
                local prefix = (currentLanguage == "English") and "Room" or "Phòng"
                local lockStr = locked and ((currentLanguage == "English") and " [Locked]" or " [Khóa]") or ""
                if data.tl and data.tl.Parent then
                    data.tl.Text = string.format("%s %s%s [%dm]", prefix, roomName, lockStr, dist)
                    data.tl.TextColor3 = locked and Color3.fromRGB(255, 50, 50) or espColor
                end
                if data.hl then
                    data.hl.FillColor = locked and Color3.fromRGB(255, 50, 50) or espColor
                    data.hl.OutlineColor = locked and Color3.fromRGB(255, 50, 50) or espColor
                end
            end
        end
    end)
end)

EspLeft:AddLabel("ESP Color"):AddColorPicker("DoorEspColor", {
    Default = Color3.fromRGB(0, 255, 200), Title = "Màu ESP",
    Callback = function(v) espColor = v end
})

-- ENTITY ESP (An toàn bộ nhớ, hủy toàn bộ connection khi tắt toggle)
local allEntities = {
    ["rush"] = {vi = "Tấn công nhanh", en = "Rush", enabled = true},
    ["ambush"] = {vi = "Tấn công bất ngờ", en = "Ambush", enabled = true},
    ["sally"] = {vi = "Sally", en = "Sally", enabled = true},
    ["figure"] = {vi = "Con rối", en = "Figure", enabled = true},
    ["seek"] = {vi = "Mắt đuổi", en = "Seek", enabled = true},
    ["eyes"] = {vi = "Ánh mắt", en = "Eyes", enabled = true},
    ["halt"] = {vi = "Dừng lại", en = "Halt", enabled = true},
    ["glitch"] = {vi = "Lỗi hệ thống", en = "Glitch", enabled = true},
    ["dupe"] = {vi = "Cửa giả", en = "Dupe", enabled = true},
    ["screech"] = {vi = "Tiếng thét", en = "Screech", enabled = true},
    ["timothy"] = {vi = "Nhện nhện", en = "Timothy", enabled = true},
    ["a60"] = {vi = "A-60", en = "A-60", enabled = true},
    ["a90"] = {vi = "A-90", en = "A-90", enabled = true},
    ["a120"] = {vi = "A-120", en = "A-120", enabled = true}
}

local entityEspToggle = EspLeft:AddToggle("EntityEspToggle", {
    Text = "Entity ESP (Advanced)", Default = false, Tooltip = "Vẽ thực thể thông minh"
})

EspLeft:AddButton("ConfigEntitiesBtn", "⚙️ Chọn Entity ESP (Bảng Ngang)", function()
    local ConfigWindow = Obsidian:CreateWindow({
        Title = "Danh sách Entity ESP", SubTitle = "Chọn thực thể",
        TabWidth = 100, Size = UDim2.new(0, 580, 0, 340), Center = true, AutoShow = true, MenuFadeTime = 0.15
    })
    local ConfigTab = ConfigWindow:AddTab("Entities", "list")
    local ConfigGroup = ConfigTab:AddLeftGroupbox("Quản lý tùy chọn")
    
    ConfigGroup:AddButton("SelectAllEnt", "✔ Chọn Tất Cả", function()
        for _, data in pairs(allEntities) do data.enabled = true end
    end)
    ConfigGroup:AddButton("DeselectAllEnt", "❌ Bỏ Chọn Tất Cả", function()
        for _, data in pairs(allEntities) do data.enabled = false end
    end)
    
    local ConfigRightGroup = ConfigTab:AddRightGroupbox("Bộ lọc chi tiết")
    for k, data in pairs(allEntities) do
        ConfigRightGroup:AddToggle("Ent_"..k, {
            Text = data.en .. " (" .. data.vi .. ")", Default = data.enabled,
            Callback = function(v) data.enabled = v end
        })
    end
end)

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
    local bb = Instance.new("BillboardGui")
    bb.Adornee = part
    bb.Size = UDim2.new(0, 180, 0, 50)
    bb.StudsOffsetWorldSpace = Vector3.new(0, 3, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 2000
    bb.LightInfluence = 0
    bb.ResetOnSpawn = false
    bb.Parent = part
    local tl = Instance.new("TextLabel")
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.TextColor3 = Color3.fromRGB(255, 0, 0)
    tl.TextStrokeTransparency = 0
    tl.TextScaled = true
    tl.Font = Enum.Font.FredokaOne
    tl.Text = allEntities[key].en
    tl.Parent = bb
    local sc = Instance.new("UIScale")
    sc.Scale = 1.1
    sc.Parent = tl
    trackedEntities[obj] = {bb = bb, tl = tl, part = part, key = key}
end

local function detachEntity(obj)
    local data = trackedEntities[obj]
    if not data then return end
    if data.bb then data.bb:Destroy() end
    trackedEntities[obj] = nil
end

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

entityEspToggle:OnChanged(function(Value)
    if Value then
        table.insert(activeConnections, Workspace.DescendantAdded:Connect(registerEntity))
        for _, obj in ipairs(Workspace:GetDescendants()) do
            registerEntity(obj)
        end
    else
        for _, conn in ipairs(activeConnections) do
            if typeof(conn) == "RBXScriptConnection" then conn:Disconnect() end
        end
        activeConnections = {}
        for obj, _ in pairs(trackedEntities) do
            if obj then
                for _, v in pairs(obj:GetDescendants()) do
                    if v:IsA("Highlight") or v:IsA("BillboardGui") then v:Destroy() end
                end
            end
        end
        trackedEntities = {}
    end
end)

local playerEspToggle = EspRight:AddToggle("PlayerEspToggle", {
    Text = "Player ESP", Default = false, Tooltip = "Vẽ người chơi"
})

local trackedPlayers = {}
local playerAddedConn = nil
local playerCharConns = {}

local function cleanupPlayer(plr)
    local data = trackedPlayers[plr]
    if not data then return end
    if data.hl then data.hl:Destroy() end
    if data.bb then data.bb:Destroy() end
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
            bb = Instance.new("BillboardGui")
            bb.Adornee = head
            bb.Size = UDim2.new(0, 140, 0, 40)
            bb.StudsOffsetWorldSpace = Vector3.new(0, 2.5, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = 2000
            bb.LightInfluence = 0
            bb.ResetOnSpawn = false
            bb.Parent = head
            tl = Instance.new("TextLabel")
            tl.Size = UDim2.new(1, 0, 1, 0)
            tl.BackgroundTransparency = 1
            tl.TextColor3 = Color3.fromRGB(255, 210, 140)
            tl.TextStrokeTransparency = 0
            tl.TextScaled = true
            tl.Font = Enum.Font.FredokaOne
            tl.Text = plr.Name
            tl.Parent = bb
            local sc = Instance.new("UIScale")
            sc.Scale = 1.1
            sc.Parent = tl
        end
        trackedPlayers[plr] = {hl = hl, bb = bb, tl = tl}
    end
    if plr.Character then onChar(plr.Character) end
    playerCharConns[plr] = plr.CharacterAdded:Connect(onChar)
end

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

-- HIDDEN SUPPORT ESP
local hiddenSupportToggle = EspRight:AddToggle("HiddenSupportToggle", {
    Text = "Hidden Support ESP", Default = false,
    Tooltip = "Vẽ tủ trốn / giường trốn màu vàng"
})

local trackedHidden = {}
local hiddenConn = nil

hiddenSupportToggle:OnChanged(function(Value)
    if Value then
        local throttle = 0
        hiddenConn = RunService.RenderStepped:Connect(function()
            throttle = throttle + 1
            if throttle % 4 ~= 0 then return end
            
            local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
            if not currentRoomNum then return end
            
            for i = 0, 1 do
                local roomObj = Workspace.CurrentRooms:FindFirstChild(tostring(currentRoomNum + i))
                if roomObj then
                    for _, descendant in ipairs(roomObj:GetDescendants()) do
                        local name = descendant.Name:lower()
                        if name:find("wardrobe") or name:find("closet") or name:find("bed") or name:find("hide") then
                            if not trackedHidden[descendant] then
                                local part = descendant:IsA("BasePart") and descendant or descendant:FindFirstChildWhichIsA("BasePart")
                                if part then
                                    local hl = Instance.new("Highlight")
                                    hl.FillColor = Color3.fromRGB(255, 220, 0)
                                    hl.OutlineColor = Color3.fromRGB(255, 255, 0)
                                    hl.FillTransparency = 0.5
                                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                    hl.Parent = descendant
                                    
                                    local bb = Instance.new("BillboardGui")
                                    bb.Size = UDim2.new(0, 100, 0, 30)
                                    bb.StudsOffset = Vector3.new(0, 2, 0)
                                    bb.AlwaysOnTop = true
                                    bb.MaxDistance = 400
                                    local tl = Instance.new("TextLabel")
                                    tl.Size = UDim2.new(1, 0, 1, 0)
                                    tl.BackgroundTransparency = 1
                                    tl.TextColor3 = Color3.fromRGB(255, 220, 0)
                                    tl.TextStrokeTransparency = 0
                                    tl.TextSize = 13
                                    tl.Font = Enum.Font.FredokaOne
                                    tl.Text = (currentLanguage == "English") and "Hiding Spot" or "Chỗ Trốn"
                                    tl.Parent = bb
                                    bb.Parent = part
                                    
                                    trackedHidden[descendant] = {hl = hl, bb = bb, label = tl}
                                end
                            else
                                if trackedHidden[descendant] and trackedHidden[descendant].label then
                                    trackedHidden[descendant].label.Text = (currentLanguage == "English") and "Hiding Spot" or "Chỗ Trốn"
                                end
                            end
                        end
                    end
                end
            end
        end)
    else
        if hiddenConn then hiddenConn:Disconnect() hiddenConn = nil end
        for obj, data in pairs(trackedHidden) do
            if data.hl then data.hl:Destroy() end
            if data.bb then data.bb:Destroy() end
        end
        trackedHidden = {}
    end
end)

-- ITEM ESP
local itemEspToggle = ObjectsRight:AddToggle("ItemEspToggle", {
    Text = "Item ESP (Purple & No Keys)", Default = false,
    Tooltip = "Vẽ item tương tác màu tím, loại bỏ tuyệt đối Key"
})

local itemColor = Color3.fromRGB(180, 50, 255)
ObjectsRight:AddLabel("Item Color"):AddColorPicker("ItemEspColor", {
    Default = Color3.fromRGB(180, 50, 255),
    Title = "Màu Item",
    Callback = function(v) itemColor = v end
})

local trackedItems = {}
local itemConn = nil
itemEspToggle:OnChanged(function(Value)
    if Value then
        local throttle = 0
        itemConn = RunService.RenderStepped:Connect(function()
            throttle = throttle + 1
            if throttle % 4 ~= 0 then return end
            
            local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
            if not currentRoomNum then return end
            
            local roomObj = Workspace.CurrentRooms:FindFirstChild(tostring(currentRoomNum))
            if not roomObj then return end
            
            local currentRoomItems = {}
            for _, descendant in ipairs(roomObj:GetDescendants()) do
                local name = descendant.Name:lower()
                if not name:find("key") and not name:find("padlock") then
                    local hasPrompt = descendant:FindFirstChildWhichIsA("ProximityPrompt", true) or descendant:IsA("ProximityPrompt")
                    if hasPrompt then
                        local validItems = {"candle", "lighter", "bandaid", "cross", "crucifix", "gun", "ammo", "bomb", "glowstick", "book", "battery", "shears"}
                        local isValid = false
                        for _, k in ipairs(validItems) do
                            if name:find(k) then isValid = true break end
                        end
                        if isValid then
                            currentRoomItems[descendant] = true
                        end
                    end
                end
            end
            
            for obj, data in pairs(trackedItems) do
                if not currentRoomItems[obj] or not obj.Parent then
                    if data.hl then data.hl:Destroy() end
                    if data.bb then data.bb:Destroy() end
                    trackedItems[obj] = nil
                end
            end
            
            for obj, _ in pairs(currentRoomItems) do
                if not trackedItems[obj] then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local hl = Instance.new("Highlight")
                        hl.FillColor = itemColor
                        hl.OutlineColor = itemColor
                        hl.FillTransparency = 0.5
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = obj
                        
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 30)
                        bb.StudsOffset = Vector3.new(0, 2, 0)
                        bb.AlwaysOnTop = true
                        bb.MaxDistance = 400
                        local tl = Instance.new("TextLabel")
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = itemColor
                        tl.TextStrokeTransparency = 0
                        tl.TextSize = 13
                        tl.Font = Enum.Font.FredokaOne
                        tl.Text = obj.Name
                        tl.Parent = bb
                        bb.Parent = part
                        
                        trackedItems[obj] = {hl = hl, bb = bb}
                    end
                end
            end
        end)
    else
        if itemConn then itemConn:Disconnect() itemConn = nil end
        for obj, data in pairs(trackedItems) do
            if data.hl then data.hl:Destroy() end
            if data.bb then data.bb:Destroy() end
        end
        trackedItems = {}
    end
end)

-- OBJECTS ESP
local objectsEspToggle = ObjectsLeft:AddToggle("ObjectsEspToggle", {
    Text = "Objects ESP (Key & Box)", Default = false,
    Tooltip = "Vẽ Key Door, Hộp điện, Rương"
})

local objectsColor = Color3.fromRGB(0, 255, 100)
ObjectsLeft:AddLabel("Objects Color"):AddColorPicker("ObjectsEspColor", {
    Default = Color3.fromRGB(0, 255, 100),
    Title = "Màu Objects",
    Callback = function(v) objectsColor = v end
})

local trackedObjects = {}
local objectsConn = nil
objectsEspToggle:OnChanged(function(Value)
    if Value then
        local throttle = 0
        objectsConn = RunService.RenderStepped:Connect(function()
            throttle = throttle + 1
            if throttle % 4 ~= 0 then return end
            
            local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom"))
            if not currentRoomNum then return end
            
            local roomObj = Workspace.CurrentRooms:FindFirstChild(tostring(currentRoomNum))
            if not roomObj then return end
            
            local currentRoomObjects = {}
            for _, descendant in ipairs(roomObj:GetDescendants()) do
                local name = descendant.Name:lower()
                if not name:find("drawer") and not name:find("locker") then
                    local hasPrompt = descendant:FindFirstChildWhichIsA("ProximityPrompt", true) or descendant:IsA("ProximityPrompt")
                    if hasPrompt then
                        local validKeys = {"key", "doorkey", "keydoor", "electrical", "box", "chest", "breaker", "padlock", "lever"}
                        local isValid = false
                        for _, k in ipairs(validKeys) do
                            if name:find(k) then isValid = true break end
                        end
                        if isValid then
                            currentRoomObjects[descendant] = true
                        end
                    end
                end
            end
            
            for obj, data in pairs(trackedObjects) do
                if not currentRoomObjects[obj] or not obj.Parent then
                    if data.hl then data.hl:Destroy() end
                    if data.bb then data.bb:Destroy() end
                    trackedObjects[obj] = nil
                end
            end
            
            for obj, _ in pairs(currentRoomObjects) do
                if not trackedObjects[obj] then
                    local part = obj:IsA("BasePart") and obj or obj:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local hl = Instance.new("Highlight")
                        hl.FillColor = objectsColor
                        hl.OutlineColor = objectsColor
                        hl.FillTransparency = 0.5
                        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        hl.Parent = obj
                        
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 110, 0, 30)
                        bb.StudsOffset = Vector3.new(0, 2, 0)
                        bb.AlwaysOnTop = true
                        bb.MaxDistance = 400
                        local tl = Instance.new("TextLabel")
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = objectsColor
                        tl.TextStrokeTransparency = 0
                        tl.TextSize = 14
                        tl.Font = Enum.Font.FredokaOne
                        local displayName = obj.Name
                        if displayName:lower():find("key") then
                            displayName = "Key Door"
                        end
                        tl.Text = displayName
                        tl.Parent = bb
                        bb.Parent = part
                        
                        trackedObjects[obj] = {hl = hl, bb = bb}
                    end
                end
            end
        end)
    else
        if objectsConn then objectsConn:Disconnect() objectsConn = nil end
        for obj, data in pairs(trackedObjects) do
            if data.hl then data.hl:Destroy() end
            if data.bb then data.bb:Destroy() end
        end
        trackedObjects = {}
    end
end)
