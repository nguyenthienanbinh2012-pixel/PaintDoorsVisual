local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VisualCrackPaintXcode"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- NÚT P NỔI BẬT & PHỐI MÀU NEON
local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Name = "ToggleIcon"
ToggleIcon.Size = UDim2.new(0, 48, 0, 48)
ToggleIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(18, 18, 25)
ToggleIcon.BorderSizePixel = 0
ToggleIcon.Text = "P"
ToggleIcon.TextColor3 = Color3.fromRGB(0, 255, 200)
ToggleIcon.TextSize = 22
ToggleIcon.Font = Enum.Font.FredokaOne
ToggleIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 24)
IconCorner.Parent = ToggleIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(0, 255, 200)
IconStroke.Thickness = 2.5
IconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
IconStroke.Parent = ToggleIcon

-- MAIN MENU PHỐI MÀU SANG TRỌNG
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 220) 
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -110)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(0, 255, 200)
FrameStroke.Thickness = 2
FrameStroke.Transparency = 0.3
FrameStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 30)
Title.Position = UDim2.new(0, 12, 0, 6)
Title.Text = "LIQUID ESP • OPTIMIZED EDITION"
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.TextSize = 13
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -24, 1, -42)
Container.Position = UDim2.new(0, 12, 0, 36)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIGrid = Instance.new("UIGridLayout")
UIGrid.CellSize = UDim2.new(0, 126, 0, 42)
UIGrid.CellPadding = UDim2.new(0, 8, 0, 8)
UIGrid.Parent = Container

local function CreateToggleCard(name, defaultState, callback)
	local Card = Instance.new("TextButton")
	Card.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
	Card.AutoButtonColor = false
	Card.Text = ""
	Card.Parent = Container

	local CardCorner = Instance.new("UICorner")
	CardCorner.CornerRadius = UDim.new(0, 6)
	CardCorner.Parent = Card

	local CardStroke = Instance.new("UIStroke")
	CardStroke.Color = Color3.fromRGB(40, 40, 55)
	CardStroke.Thickness = 1
	CardStroke.Parent = Card

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -6, 0, 20)
	Label.Position = UDim2.new(0, 5, 0, 2)
	Label.Text = name
	Label.TextColor3 = Color3.fromRGB(220, 220, 240)
	Label.TextSize = 10
	Label.Font = Enum.Font.Code
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.TextWrapped = true
	Label.BackgroundTransparency = 1
	Label.Parent = Card

	local StatusText = Instance.new("TextLabel")
	StatusText.Size = UDim2.new(1, -6, 0, 16)
	StatusText.Position = UDim2.new(0, 5, 0, 22)
	StatusText.Text = defaultState and "• ON" or "• OFF"
	StatusText.TextColor3 = defaultState and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 70, 70)
	StatusText.TextSize = 10
	StatusText.Font = Enum.Font.Code
	StatusText.TextXAlignment = Enum.TextXAlignment.Left
	StatusText.BackgroundTransparency = 1
	StatusText.Parent = Card

	local isToggled = defaultState

	Card.MouseButton1Click:Connect(function()
		isToggled = not isToggled
		StatusText.Text = isToggled and "• ON" or "• OFF"
		StatusText.TextColor3 = isToggled and Color3.fromRGB(0, 255, 150) or Color3.fromRGB(255, 70, 70)
		CardStroke.Color = isToggled and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(40, 40, 55)
		callback(isToggled)
	end)
end

local DoorsESPEnabled = false
local EntityESPEnabled = false
local EntityNotifEnabled = false
local KeyESPEnabled = false
local ClosetESPEnabled = false
local TopTracerEnabled = false
local PlayerESPEnabled = false

CreateToggleCard("Doors ESP", false, function(state) DoorsESPEnabled = state end)
CreateToggleCard("Entity ESP", false, function(state) EntityESPEnabled = state end)
CreateToggleCard("Notif Entity", false, function(state) EntityNotifEnabled = state end)
CreateToggleCard("Lockpick Tool", false, function(state) KeyESPEnabled = state end)
CreateToggleCard("Closet ESP", false, function(state) ClosetESPEnabled = state end)
CreateToggleCard("Line Top ESP", false, function(state) TopTracerEnabled = state end)
CreateToggleCard("Player ESP", false, function(state) PlayerESPEnabled = state end)

local NotifContainer = Instance.new("Frame")
NotifContainer.Name = "NotifContainer"
NotifContainer.Size = UDim2.new(0, 200, 0, 300)
NotifContainer.Position = UDim2.new(1, -210, 0, 15)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.VerticalAlignment = Enum.VerticalAlignment.Top
NotifLayout.Padding = UDim.new(0, 6)
NotifLayout.Parent = NotifContainer

local SoundToang = Instance.new("Sound")
SoundToang.SoundId = "rbxassetid://9114223178"
SoundToang.Volume = 2.5
SoundToang.Parent = ScreenGui

local function ShowEntityNotification(entityName)
	if not EntityNotifEnabled then return end
	SoundToang:Play()

	local NotifCard = Instance.new("Frame")
	NotifCard.Size = UDim2.new(0, 0, 0, 38)
	NotifCard.BackgroundColor3 = Color3.fromRGB(20, 15, 22)
	NotifCard.BorderSizePixel = 0
	NotifCard.ClipsDescendants = true
	NotifCard.Parent = NotifContainer

	local CardCorner = Instance.new("UICorner")
	CardCorner.CornerRadius = UDim.new(0, 6)
	CardCorner.Parent = NotifCard

	local CardStroke = Instance.new("UIStroke")
	CardStroke.Color = Color3.fromRGB(255, 50, 80)
	CardStroke.Thickness = 1.2
	CardStroke.Parent = NotifCard

	local MsgLabel = Instance.new("TextLabel")
	MsgLabel.Size = UDim2.new(1, -10, 1, 0)
	MsgLabel.Position = UDim2.new(0, 8, 0, 0)
	MsgLabel.Text = "⚠️ ENTITY: " .. string.upper(entityName)
	MsgLabel.TextColor3 = Color3.fromRGB(255, 80, 100)
	MsgLabel.TextSize = 11
	MsgLabel.Font = Enum.Font.Code
	MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
	MsgLabel.BackgroundTransparency = 1
	MsgLabel.Parent = NotifCard

	TweenService:Create(NotifCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 0, 38)
	}):Play()

	task.delay(2.7, function()
		if NotifCard and NotifCard.Parent then
			local hideTween = TweenService:Create(NotifCard, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
				Size = UDim2.new(0, 0, 0, 38)
			})
			hideTween:Play()
			hideTween.Completed:Connect(function()
				NotifCard:Destroy()
			end)
		end
	end)
end

-- KÉO THẢ UI
local function MakeDraggable(guiObject)
	local dragging, dragInput, dragStart, startPos
	local dragged = false

	guiObject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragged = false
			dragStart = input.Position
			startPos = guiObject.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	guiObject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			dragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == dragInput and dragging then
			local delta = input.Position - dragStart
			if delta.Magnitude > 6 then
				dragged = true
			end
			guiObject.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)

	return function() return dragged end
end

local isIconMoved = MakeDraggable(ToggleIcon)
MakeDraggable(MainFrame)

ToggleIcon.MouseButton1Click:Connect(function()
	if not isIconMoved() then
		MainFrame.Visible = not MainFrame.Visible
	end
end)

-- TRACER SYSTEM DÙNG DRAWING LIB (Tối ưu hóa tuyệt đối không gây lag)
local tracerPool = {}

local function ClearTracers()
	for _, line in pairs(tracerPool) do
		line.Visible = false
	end
end

local function GetTracerLine(index)
	if not tracerPool[index] then
		local line = Drawing.new("Line")
		line.Thickness = 1.5
		line.Transparency = 1
		line.Visible = false
		tracerPool[index] = line
	end
	return tracerPool[index]
end

local activeTracerIndex = 0

local function AddTopTracer(targetPos, color)
	if not TopTracerEnabled then return end
	local screenPos, onScreen = Camera:WorldToViewportPoint(targetPos)
	if onScreen then
		activeTracerIndex = activeTracerIndex + 1
		local line = GetTracerLine(activeTracerIndex)
		line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
		line.To = Vector2.new(screenPos.X, screenPos.Y)
		line.Color = color
		line.Visible = true
	end
end

-- DOORS ESP
local doorESPMap = {}

local function UpdateDoorsESP()
	local CurrentRooms = Workspace:FindFirstChild("CurrentRooms")
	if not CurrentRooms then return end

	local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0

	for roomName, data in pairs(doorESPMap) do
		local roomNum = tonumber(roomName)
		if not DoorsESPEnabled or (roomNum and roomNum < currentRoomNum) then
			if data.Highlight then data.Highlight:Destroy() end
			if data.BB then data.BB:Destroy() end
			doorESPMap[roomName] = nil
		end
	end

	if not DoorsESPEnabled then return end

	for _, room in pairs(CurrentRooms:GetChildren()) do
		local roomNumber = tonumber(room.Name)
		if roomNumber and roomNumber >= currentRoomNum then
			local door = room:FindFirstChild("Door")
			if door then
				local doorBase = door:FindFirstChild("Door") or door:FindFirstChild("PrimaryPart") or door
				
				if not doorESPMap[room.Name] and doorBase then
					local data = {}
					local displayDoorNum = roomNumber + 1

					local highlight = Instance.new("Highlight")
					highlight.Name = "DoorHighlight"
					highlight.FillTransparency = 0.85
					highlight.FillColor = Color3.fromRGB(0, 230, 255)
					highlight.OutlineColor = Color3.fromRGB(0, 235, 255)
					highlight.OutlineTransparency = 0
					highlight.Adornee = doorBase
					highlight.Parent = doorBase
					data.Highlight = highlight

					local bb = Instance.new("BillboardGui")
					bb.Size = UDim2.new(0, 80, 0, 30)
					bb.AlwaysOnTop = true
					bb.StudsOffset = Vector3.new(0, 3.5, 0)
					bb.Adornee = doorBase
					bb.Parent = doorBase

					local txt = Instance.new("TextLabel")
					txt.Size = UDim2.new(1, 0, 1, 0)
					txt.BackgroundTransparency = 1
					txt.Text = tostring(displayDoorNum)
					txt.TextColor3 = Color3.fromRGB(0, 235, 255)
					txt.TextSize = 22
					txt.Font = Enum.Font.Code
					txt.Parent = bb

					local txtStroke = Instance.new("UIStroke")
					txtStroke.Color = Color3.fromRGB(255, 255, 255)
					txtStroke.Thickness = 1.5
					txtStroke.Parent = txt

					data.BB = bb
					data.TargetPart = doorBase
					data.Color = Color3.fromRGB(0, 235, 255)
					doorESPMap[room.Name] = data
				end

				if doorESPMap[room.Name] and doorESPMap[room.Name].TargetPart then
					AddTopTracer(doorESPMap[room.Name].TargetPart.Position, doorESPMap[room.Name].Color)
				end
			end
		end
	end
end

-- CLOSET ESP (Chỉ quét đồ tương tác)
local closetESPMap = {}

local function ClearClosetESP()
	for item, hl in pairs(closetESPMap) do
		if hl then hl:Destroy() end
	end
	table.clear(closetESPMap)
end

local function ScanClosets()
	if not ClosetESPEnabled then
		ClearClosetESP()
		return
	end

	local CurrentRooms = Workspace:FindFirstChild("CurrentRooms")
	if not CurrentRooms then return end

	for item, hl in pairs(closetESPMap) do
		if not item.Parent or not item:IsDescendantOf(Workspace) then
			if hl then hl:Destroy() end
			closetESPMap[item] = nil
		end
	end

	for _, room in pairs(CurrentRooms:GetChildren()) do
		for _, item in pairs(room:GetDescendants()) do
			if item:IsA("Model") then
				local name = item.Name:lower()
				if name:find("wardrobe") or name:find("bed") or name:find("closet") or name:find("locker") or name:find("stutteringdesk") then
					if not closetESPMap[item] then
						local hl = Instance.new("Highlight")
						hl.Name = "ClosetHL"
						hl.FillColor = Color3.fromRGB(255, 120, 0)
						hl.FillTransparency = 0.7
						hl.OutlineColor = Color3.fromRGB(255, 140, 0)
						hl.OutlineTransparency = 0
						hl.Adornee = item
						hl.Parent = item
						closetESPMap[item] = hl
					end

					local part = item.PrimaryPart or item:FindFirstChildOfClass("BasePart")
					if part then
						AddTopTracer(part.Position, Color3.fromRGB(255, 140, 0))
					end
				end
			end
		end
	end
end

-- KEY & TOOL ESP (Chỉ bắt đúng vật phẩm tương tác, loại bỏ bảng)
local keyESPMap = {}

local function ClearKeyESP()
	for obj, data in pairs(keyESPMap) do
		if data.Highlight then data.Highlight:Destroy() end
		if data.BB then data.BB:Destroy() end
	end
	table.clear(keyESPMap)
end

local function ScanKeyAndTools()
	if not KeyESPEnabled then
		ClearKeyESP()
		return
	end

	local CurrentRooms = Workspace:FindFirstChild("CurrentRooms")
	if not CurrentRooms then return end

	local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0

	for item, data in pairs(keyESPMap) do
		if not item.Parent or not item:IsDescendantOf(Workspace) then
			if data.Highlight then data.Highlight:Destroy() end
			if data.BB then data.BB:Destroy() end
			keyESPMap[item] = nil
		end
	end

	for _, room in pairs(CurrentRooms:GetChildren()) do
		local roomNum = tonumber(room.Name)
		if roomNum and roomNum >= currentRoomNum then
			for _, item in pairs(room:GetDescendants()) do
				if item:IsA("Model") or item:IsA("BasePart") then
					local name = item.Name:lower()
					
					local isKey = (name == "keyob" or name == "key" or (name:find("key") and not name:find("keybackboard") and not name:find("keyholder") and not name:find("display"))) or name:find("lockpick")
					local isLever = name:find("lever") or name:find("switch")
					local isBox = name:find("livehintbook") or name:find("fuseholder") or name:find("electricalkey") or name:find("fuse")

					if (isKey or isLever or isBox) and not keyESPMap[item] then
						local targetPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChild("Handle") or item:FindFirstChildOfClass("BasePart")) or item
						
						if targetPart then
							local data = {}
							local color = Color3.fromRGB(255, 215, 0)
							local textStr = "Key"

							if isLever then
								color = Color3.fromRGB(0, 255, 120)
								textStr = "Cần gạt"
							elseif isBox then
								color = Color3.fromRGB(0, 255, 120)
								textStr = "Box"
							end

							local hl = Instance.new("Highlight")
							hl.FillColor = color
							hl.FillTransparency = 0.5
							hl.OutlineColor = Color3.fromRGB(255, 255, 255)
							hl.OutlineTransparency = 0
							hl.Adornee = item
							hl.Parent = item
							data.Highlight = hl

							local bb = Instance.new("BillboardGui")
							bb.Size = UDim2.new(0, 100, 0, 30)
							bb.AlwaysOnTop = true
							bb.StudsOffset = Vector3.new(0, 2, 0)
							bb.Adornee = targetPart
							bb.Parent = targetPart

							local txt = Instance.new("TextLabel")
							txt.Size = UDim2.new(1, 0, 1, 0)
							txt.BackgroundTransparency = 1
							txt.Text = textStr
							txt.TextColor3 = color
							txt.TextSize = 15
							txt.Font = Enum.Font.Code
							txt.Parent = bb

							local txtStroke = Instance.new("UIStroke")
							txtStroke.Color = Color3.fromRGB(255, 255, 255)
							txtStroke.Thickness = 1.2
							txtStroke.Parent = txt

							data.BB = bb
							data.TargetPart = targetPart
							data.Color = color
							keyESPMap[item] = data
						end
					end

					if keyESPMap[item] and keyESPMap[item].TargetPart then
						AddTopTracer(keyESPMap[item].TargetPart.Position, keyESPMap[item].Color)
					end
				end
			end
		end
	end
end

-- ENTITY ESP (Đã khắc phục hoàn toàn lỗi lọt sang cửa sổ, vẽ viền đỏ chuẩn xác)
local entityESPMap = {}

local function CleanEntityName(rawName)
	local cleaned = rawName:gsub("Moving", ""):gsub("Rig", ""):gsub("%d", "")
	return string.upper(cleaned)
end

local function CheckAndRegisterEntity(obj)
	if not obj or not obj:IsA("Model") then return end
	if Players:GetPlayerFromCharacter(obj) then return end

	local name = obj.Name:lower()
	local validEntities = {"rush", "ambush", "seek", "eyes", "figure", "screech", "halt", "dupe", "a-60", "a-120", "a-90", "snare", "jack"}
	local isEntity = false

	for _, v in ipairs(validEntities) do
		if name:find(v) then
			isEntity = true
			break
		end
	end

	if isEntity and not entityESPMap[obj] then
		local displayName = CleanEntityName(obj.Name)
		ShowEntityNotification(displayName)

		local primaryPart = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("BasePart")
		
		if primaryPart then
			local data = {}

			local hl = Instance.new("Highlight")
			hl.Name = "EntityHL"
			hl.FillColor = Color3.fromRGB(255, 30, 30)
			hl.FillTransparency = 0.5
			hl.OutlineColor = Color3.fromRGB(255, 0, 0)
			hl.OutlineTransparency = 0
			hl.Adornee = obj
			hl.Parent = hl
			-- Đảm bảo luôn hiển thị xuyên thấu vượt trội
			hl.Enabled = true
			hl.Parent = obj
			data.Highlight = hl

			local bb = Instance.new("BillboardGui")
			bb.Name = "EntityBB"
			bb.Size = UDim2.new(0, 160, 0, 40)
			bb.AlwaysOnTop = true
			bb.Adornee = primaryPart
			bb.Parent = primaryPart

			local txt = Instance.new("TextLabel")
			txt.Name = "Label"
			txt.Size = UDim2.new(1, 0, 1, 0)
			txt.BackgroundTransparency = 1
			txt.Text = displayName
			txt.TextColor3 = Color3.fromRGB(255, 50, 50)
			txt.TextSize = 14
			txt.Font = Enum.Font.Code
			txt.Parent = bb
			data.BB = bb
			data.TargetPart = primaryPart
			data.Color = Color3.fromRGB(255, 30, 30)

			entityESPMap[obj] = data

			obj.Destroying:Connect(function()
				if entityESPMap[obj] then
					if entityESPMap[obj].Highlight then entityESPMap[obj].Highlight:Destroy() end
					if entityESPMap[obj].BB then entityESPMap[obj].BB:Destroy() end
					entityESPMap[obj] = nil
				end
			end)
		end
	end
end

Workspace.ChildAdded:Connect(function(child)
	task.defer(function()
		CheckAndRegisterEntity(child)
	end)
end)

for _, child in pairs(Workspace:GetChildren()) do
	CheckAndRegisterEntity(child)
end

local function UpdateEntityVisibility()
	for obj, data in pairs(entityESPMap) do
		if obj and obj.Parent then
			local activeState = EntityESPEnabled
			data.Highlight.Enabled = activeState
			data.BB.Enabled = activeState
			
			if activeState then
				if data.BB and data.BB:FindFirstChild("Label") then
					local primaryPart = obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart")
					local char = LocalPlayer.Character
					if primaryPart and char and char:FindFirstChild("HumanoidRootPart") then
						local dist = math.floor((primaryPart.Position - char.HumanoidRootPart.Position).Magnitude)
						data.BB.Label.Text = CleanEntityName(obj.Name) .. " [" .. dist .. "m]"
					end
				end
				if data.TargetPart then
					AddTopTracer(data.TargetPart.Position, data.Color)
				end
			end
		else
			if data.Highlight then data.Highlight:Destroy() end
			if data.BB then data.BB:Destroy() end
			entityESPMap[obj] = nil
		end
	end
end

-- PLAYER ESP (280 studs)
local playerESPMap = {}

local function ClearPlayerESP()
	for plr, data in pairs(playerESPMap) do
		if data.Highlight then data.Highlight:Destroy() end
		if data.BB then data.BB:Destroy() end
	end
	table.clear(playerESPMap)
end

local function UpdatePlayerESP()
	if not PlayerESPEnabled then
		ClearPlayerESP()
		return
	end

	local localChar = LocalPlayer.Character
	local localHRP = localChar and localChar:FindFirstChild("HumanoidRootPart")

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= LocalPlayer then
			local char = player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")

			if char and hrp and localHRP then
				local dist = (hrp.Position - localHRP.Position).Magnitude

				if dist <= 280 then
					if not playerESPMap[player] then
						local data = {}

						local hl = Instance.new("Highlight")
						hl.Name = "PlayerHL"
						hl.FillColor = Color3.fromRGB(255, 255, 255)
						hl.FillTransparency = 0.8
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						hl.OutlineTransparency = 0
						hl.Adornee = char
						hl.Parent = char
						data.Highlight = hl

						local bb = Instance.new("BillboardGui")
						bb.Size = UDim2.new(0, 150, 0, 30)
						bb.AlwaysOnTop = true
						bb.StudsOffset = Vector3.new(0, 3, 0)
						bb.Adornee = hrp
						bb.Parent = hrp

						local txt = Instance.new("TextLabel")
						txt.Name = "Label"
						txt.Size = UDim2.new(1, 0, 1, 0)
						txt.BackgroundTransparency = 1
						txt.Text = player.DisplayName .. " [" .. math.floor(dist) .. "m]"
						txt.TextColor3 = Color3.fromRGB(255, 255, 255)
						txt.TextSize = 14
						txt.Font = Enum.Font.Code
						txt.Parent = bb

						local txtStroke = Instance.new("UIStroke")
						txtStroke.Color = Color3.fromRGB(0, 0, 0)
						txtStroke.Thickness = 1.2
						txtStroke.Parent = txt

						data.BB = bb
						data.TargetPart = hrp
						data.Color = Color3.fromRGB(255, 255, 255)
						playerESPMap[player] = data
					else
						local data = playerESPMap[player]
						if data.BB:FindFirstChild("Label") then
							data.BB.Label.Text = player.DisplayName .. " [" .. math.floor(dist) .. "m]"
						end
					end

					if playerESPMap[player] and playerESPMap[player].TargetPart then
						AddTopTracer(playerESPMap[player].TargetPart.Position, playerESPMap[player].Color)
					end
				else
					if playerESPMap[player] then
						if playerESPMap[player].Highlight then playerESPMap[player].Highlight:Destroy() end
						if playerESPMap[player].BB then playerESPMap[player].BB:Destroy() end
						playerESPMap[player] = nil
					end
				end
			else
				if playerESPMap[player] then
					if playerESPMap[player].Highlight then playerESPMap[player].Highlight:Destroy() end
					if playerESPMap[player].BB then playerESPMap[player].BB:Destroy() end
					playerESPMap[player] = nil
				end
			end
		end
	end
end

-- TỐI ƯU HÓA VÒNG LẶP CHỐNG LAG CPU
task.spawn(function()
	while true do
		ScanClosets()
		ScanKeyAndTools()
		task.wait(0.6)
	end
end)

RunService.RenderStepped:Connect(function()
	ClearTracers()
	activeTracerIndex = 0

	UpdateDoorsESP()
	UpdateEntityVisibility()
	UpdatePlayerESP()
end)
