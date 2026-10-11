local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local Camera = Workspace.CurrentCamera

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "LiquidDoorsESP_UI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- TOGGLE BUTTON (NÚT MỞ MENU)
local ToggleIcon = Instance.new("TextButton")
ToggleIcon.Name = "ToggleIcon"
ToggleIcon.Size = UDim2.new(0, 45, 0, 45)
ToggleIcon.Position = UDim2.new(0.05, 0, 0.4, 0)
ToggleIcon.BackgroundColor3 = Color3.fromRGB(15, 12, 18)
ToggleIcon.BorderSizePixel = 0
ToggleIcon.Text = "P"
ToggleIcon.TextColor3 = Color3.fromRGB(255, 60, 170)
ToggleIcon.TextSize = 24
ToggleIcon.Font = Enum.Font.FredokaOne
ToggleIcon.Parent = ScreenGui

local IconCorner = Instance.new("UICorner")
IconCorner.CornerRadius = UDim.new(0, 22)
IconCorner.Parent = ToggleIcon

local IconStroke = Instance.new("UIStroke")
IconStroke.Color = Color3.fromRGB(255, 60, 170)
IconStroke.Thickness = 2
IconStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
IconStroke.Parent = ToggleIcon

-- MAIN MENU FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 420, 0, 250) 
MainFrame.Position = UDim2.new(0.5, -210, 0.5, -125)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

local FrameStroke = Instance.new("UIStroke")
FrameStroke.Color = Color3.fromRGB(255, 60, 170)
FrameStroke.Thickness = 1.5
FrameStroke.Transparency = 0.4
FrameStroke.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -20, 0, 28)
Title.Position = UDim2.new(0, 10, 0, 4)
Title.Text = "LIQUID ESP • DOORS EDITION"
Title.TextColor3 = Color3.fromRGB(255, 100, 190)
Title.TextSize = 13
Title.Font = Enum.Font.Code
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.Parent = MainFrame

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1, -20, 1, -38)
Container.Position = UDim2.new(0, 10, 0, 32)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local UIGrid = Instance.new("UIGridLayout")
UIGrid.CellSize = UDim2.new(0, 125, 0, 42)
UIGrid.CellPadding = UDim2.new(0, 8, 0, 8)
UIGrid.Parent = Container

local function CreateToggleCard(name, defaultState, callback)
	local Card = Instance.new("TextButton")
	Card.BackgroundColor3 = Color3.fromRGB(20, 20, 26)
	Card.AutoButtonColor = false
	Card.Text = ""
	Card.Parent = Container

	local CardCorner = Instance.new("UICorner")
	CardCorner.CornerRadius = UDim.new(0, 6)
	CardCorner.Parent = Card

	local CardStroke = Instance.new("UIStroke")
	CardStroke.Color = Color3.fromRGB(40, 40, 50)
	CardStroke.Thickness = 1
	CardStroke.Parent = Card

	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -6, 0, 20)
	Label.Position = UDim2.new(0, 5, 0, 2)
	Label.Text = name
	Label.TextColor3 = Color3.fromRGB(220, 220, 230)
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
		CardStroke.Color = isToggled and Color3.fromRGB(255, 60, 170) or Color3.fromRGB(40, 40, 50)
		callback(isToggled)
	end)
end

local DoorsESPEnabled = false
local EntityESPEnabled = false
local EntityNotifEnabled = false
local KeyESPEnabled = false
local ObjectsESPEnabled = false
local GoldESPEnabled = false
local ClosetESPEnabled = false
local TopTracerEnabled = false
local PlayerESPEnabled = false

CreateToggleCard("Doors ESP", false, function(state) DoorsESPEnabled = state end)
CreateToggleCard("Entity ESP", false, function(state) EntityESPEnabled = state end)
CreateToggleCard("Notif Entity", false, function(state) EntityNotifEnabled = state end)
CreateToggleCard("Key ESP", false, function(state) KeyESPEnabled = state end)
CreateToggleCard("Objects ESP", false, function(state) ObjectsESPEnabled = state end)
CreateToggleCard("Gold ESP", false, function(state) GoldESPEnabled = state end)
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

-- TỐI ƯU KÉO THẢ UI
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

-- SYSTEM TRACER LINES
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

-- CLOSET ESP
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

-- KEY ESP (CHỈ BẮT CHÌA KHÓA & LOCKPICK CHUẨN XÁC)
local keyESPMap = {}

local function ClearKeyESP()
	for obj, data in pairs(keyESPMap) do
		if data.Highlight then data.Highlight:Destroy() end
		if data.BB then data.BB:Destroy() end
	end
	table.clear(keyESPMap)
end

local function ScanKeys()
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
					
					-- Lọc chuẩn xác các loại chìa khóa và lockpick tránh bị dính rác
					local isKey = (name == "keyob" or name == "key" or name == "skeletonkey" or name:find("lockpick")) 
						and not name:find("keybackboard") and not name:find("keyholder") and not name:find("display")

					if isKey and not keyESPMap[item] then
						local targetPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChild("Handle") or item:FindFirstChildOfClass("BasePart")) or item
						
						if targetPart then
							local data = {}
							local color = Color3.fromRGB(255, 215, 0)
							local textStr = name == "skeletonkey" and "Chìa khóa xương" or (name:find("lockpick") and "Lockpick" or "Chìa khoá")

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
							txt.TextSize = 14
							txt.Font = Enum.Font.Code
							txt.Parent = bb

							local txtStroke = Instance.new("UIStroke")
							txtStroke.Color = Color3.fromRGB(0, 0, 0)
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

-- OBJECTS ESP (CÔNG TẮC, CẦN GẠT, HỘP ĐIỆN, VITAMIN, Ổ KHÓA, HỘP MẠCH MÀN 100)
local objectsESPMap = {}

local function ClearObjectsESP()
	for obj, data in pairs(objectsESPMap) do
		if data.Highlight then data.Highlight:Destroy() end
		if data.BB then data.BB:Destroy() end
	end
	table.clear(objectsESPMap)
end

local function ScanObjects()
	if not ObjectsESPEnabled then
		ClearObjectsESP()
		return
	end

	local CurrentRooms = Workspace:FindFirstChild("CurrentRooms")
	if not CurrentRooms then return end

	local currentRoomNum = tonumber(LocalPlayer:GetAttribute("CurrentRoom")) or 0

	for item, data in pairs(objectsESPMap) do
		if not item.Parent or not item:IsDescendantOf(Workspace) then
			if data.Highlight then data.Highlight:Destroy() end
			if data.BB then data.BB:Destroy() end
			objectsESPMap[item] = nil
		end
	end

	for _, room in pairs(CurrentRooms:GetChildren()) do
		local roomNum = tonumber(room.Name)
		if roomNum and roomNum >= currentRoomNum then
			for _, item in pairs(room:GetDescendants()) do
				if item:IsA("Model") or item:IsA("BasePart") then
					local name = item.Name:lower()

					local isLever = name:find("lever") or name:find("switch") or name:find("công tắc") or name:find("cần gạt")
					local isBox = name:find("fuseholder") or name:find("breakerbox") or name:find("electricalkeypacket") or name:find("box")
					local isVitamin = name:find("vitamin") or name:find("pills")
					local isLocking = name:find("padlock") or name:find("locking") or name:find("ổ khóa")

					if (isLever or isBox or isVitamin or isLocking) and not objectsESPMap[item] then
						local targetPart = item:IsA("Model") and (item.PrimaryPart or item:FindFirstChild("Handle") or item:FindFirstChildOfClass("BasePart")) or item
						
						if targetPart then
							local data = {}
							local color = Color3.fromRGB(0, 255, 120)
							local textStr = "Object"

							if isLever then
								textStr = "Cần gạt / Công tắc"
							elseif isBox then
								textStr = "Hộp điện / Mạch (M100)"
							elseif isVitamin then
								color = Color3.fromRGB(0, 180, 255)
								textStr = "Vitamin"
							elseif isLocking then
								color = Color3.fromRGB(255, 100, 0)
								textStr = "Ổ khóa"
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
							bb.Size = UDim2.new(0, 120, 0, 30)
							bb.AlwaysOnTop = true
							bb.StudsOffset = Vector3.new(0, 2, 0)
							bb.Adornee = targetPart
							bb.Parent = targetPart

							local txt = Instance.new("TextLabel")
							txt.Size = UDim2.new(1, 0, 1, 0)
							txt.BackgroundTransparency = 1
							txt.Text = textStr
							txt.TextColor3 = color
							txt.TextSize = 13
							txt.Font = Enum.Font.Code
							txt.Parent = bb

							local txtStroke = Instance.new("UIStroke")
							txtStroke.Color = Color3.fromRGB(0, 0, 0)
							txtStroke.Thickness = 1.2
							txtStroke.Parent = txt

							data.BB = bb
							data.TargetPart = targetPart
							data.Color = color
							objectsESPMap[item] = data
						end
					end

					if objectsESPMap[item] and objectsESPMap[item].TargetPart then
						AddTopTracer(objectsESPMap[item].TargetPart.Position, objectsESPMap[item].Color)
					end
				end
			end
		end
	end
end

-- GOLD ESP (HIỂN THỊ THỎI VÀNGVÀNG VÀ SỐ TIỀN)
local goldESPMap = {}

local function ClearGoldESP()
	for obj, data in pairs(goldESPMap) do
		if data.Highlight then data.Highlight:Destroy() end
		if data.BB then data.BB:Destroy() end
	end
	table.clear(goldESPMap)
end

local function ScanGold()
	if not GoldESPEnabled then
		ClearGoldESP()
		return
	end

	local CurrentRooms = Workspace:FindFirstChild("CurrentRooms")
	if not CurrentRooms then return end

	for item, data in pairs(goldESPMap) do
		if not item.Parent or not item:IsDescendantOf(Workspace) then
			if data.Highlight then data.Highlight:Destroy() end
			if data.BB then data.BB:Destroy() end
			goldESPMap[item] = nil
		end
	end

	for _, room in pairs(CurrentRooms:GetChildren()) do
		for _, item in pairs(room:GetDescendants()) do
			if item:IsA("Model") and item.Name:lower():find("goldpile") then
				if not goldESPMap[item] then
					local targetPart = item.PrimaryPart or item:FindFirstChildOfClass("BasePart")
					if targetPart then
						local data = {}
						local goldValue = item:GetAttribute("GoldValue") or #item:GetChildren() or 10

						local hl = Instance.new("Highlight")
						hl.FillColor = Color3.fromRGB(255, 215, 0)
						hl.FillTransparency = 0.6
						hl.OutlineColor = Color3.fromRGB(255, 255, 255)
						hl.OutlineTransparency = 0
						hl.Adornee = item
						hl.Parent = item
						data.Highlight = hl

						local bb = Instance.new("BillboardGui")
						bb.Size = UDim2.new(0, 80, 0, 30)
						bb.AlwaysOnTop = true
						bb.StudsOffset = Vector3.new(0, 1.5, 0)
						bb.Adornee = targetPart
						bb.Parent = targetPart

						local txt = Instance.new("TextLabel")
						txt.Name = "Label"
						txt.Size = UDim2.new(1, 0, 1, 0)
						txt.BackgroundTransparency = 1
						txt.Text = "Gold [" .. tostring(goldValue) .. "]"
						txt.TextColor3 = Color3.fromRGB(255, 215, 0)
						txt.TextSize = 13
						txt.Font = Enum.Font.Code
						txt.Parent = bb

						local txtStroke = Instance.new("UIStroke")
						txtStroke.Color = Color3.fromRGB(0, 0, 0)
						txtStroke.Thickness = 1.2
						txtStroke.Parent = txt

						data.BB = bb
						data.TargetPart = targetPart
						data.Color = Color3.fromRGB(255, 215, 0)
						goldESPMap[item] = data
					end
				end

				if goldESPMap[item] and goldESPMap[item].TargetPart then
					AddTopTracer(goldESPMap[item].TargetPart.Position, goldESPMap[item].Color)
				end
			end
		end
	end
end

-- ENTITY ESP
local entityESPMap = {}

local function CleanEntityName(rawName)
	local cleaned = rawName:gsub("Moving", ""):gsub("Rig", ""):gsub("%d", "")
	return string.upper(cleaned)
end

local function CheckAndRegisterEntity(obj)
	if not obj or not obj:IsA("Model") then return end
	if Players:GetPlayerFromCharacter(obj) then return end

	local name = obj.Name:lower()
	local isEntity = false

	if name:find("rush") or name:find("ambush") or name:find("seek") or name:find("eyes") or name:find("figure") or name:find("screech") or name:find("halt") or name:find("dupe") or name:find("a-60") or name:find("a-120") or name:find("a-90") or name:find("snare") or name:find("jack") then
		isEntity = true
	end

	if isEntity and not entityESPMap[obj] then
		local displayName = CleanEntityName(obj.Name)
		ShowEntityNotification(displayName)

		local primaryPart = obj.PrimaryPart or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildOfClass("BasePart") or obj:WaitForChild("Base", 2)
		
		if primaryPart then
			local data = {}

			local hl = Instance.new("Highlight")
			hl.Name = "EntityHL"
			hl.FillColor = Color3.fromRGB(255, 30, 30)
			hl.FillTransparency = 0.5
			hl.OutlineColor = Color3.fromRGB(255, 0, 0)
			hl.OutlineTransparency = 0
			hl.Adornee = obj
			hl.Enabled = EntityESPEnabled
			hl.Parent = obj
			data.Highlight = hl

			local bb = Instance.new("BillboardGui")
			bb.Name = "EntityBB"
			bb.Size = UDim2.new(0, 160, 0, 40)
			bb.AlwaysOnTop = true
			bb.Enabled = EntityESPEnabled
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
			data.Highlight.Enabled = EntityESPEnabled
			data.BB.Enabled = EntityESPEnabled
			
			if EntityESPEnabled then
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

-- LOOP RENDER
RunService.RenderStepped:Connect(function()
	ClearTracers()
	activeTracerIndex = 0
	UpdateDoorsESP()
	UpdateEntityVisibility()
	UpdatePlayerESP()
	ScanClosets()
	ScanKeys()
	ScanObjects()
	ScanGold()
end)
