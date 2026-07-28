-------------------------------------------------
-- SERVICES
-------------------------------------------------
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local Stats = game:GetService("Stats")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-------------------------------------------------
-- VARIABLES
-------------------------------------------------
local flySpeed = 60
local tracerRange = 250
local performanceMode = false
local selectedPlayer = nil
local scriptStartTime = tick()

local tracerColor = Color3.fromRGB(0, 170, 255)
local highlightColor = Color3.fromRGB(0, 170, 255)
local nameTagColor = Color3.fromRGB(255, 255, 255)

local tracersEnabled = false
local highlightEnabled = false
local namesEnabled = false
local healthEnabled = false
local flying = false
local flyConnection = nil

-------------------------------------------------
-- MAIN GUI (StarterGui version)
-------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "ModernHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = playerGui

-------------------------------------------------
-- MAIN WINDOW
-------------------------------------------------
local main = Instance.new("Frame")
main.Size = UDim2.new(0, 700, 0, 450)
main.Position = UDim2.new(0.5, -350, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
main.BorderSizePixel = 0
main.Parent = gui
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

-------------------------------------------------
-- TOP BAR
-------------------------------------------------
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
topBar.BorderSizePixel = 0
topBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Modern Hub"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.Parent = topBar

-------------------------------------------------
-- SIDEBAR
-------------------------------------------------
local sidebar = Instance.new("Frame")
sidebar.Size = UDim2.new(0, 170, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
sidebar.BorderSizePixel = 0
sidebar.Parent = main

local holder = Instance.new("Frame")
holder.Size = UDim2.new(1, 0, 1, 0)
holder.BackgroundTransparency = 1
holder.Parent = sidebar

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.Parent = holder

-------------------------------------------------
-- CONTENT
-------------------------------------------------
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -190, 1, -60)
content.Position = UDim2.new(0, 180, 0, 50)
content.BackgroundColor3 = Color3.fromRGB(42, 42, 42)
content.BorderSizePixel = 0
content.Parent = main

local function createPage()
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Visible = false
	page.Parent = content
	return page
end

local Home = createPage()
local PlayerPage = createPage()
local Visuals = createPage()
local SettingsPage = createPage()
local Credits = createPage()
local Misc = createPage()

Home.Visible = true

local function showPage(page)
	for _, v in pairs(content:GetChildren()) do
		if v:IsA("Frame") then
			v.Visible = false
		end
	end
	page.Visible = true
end

-------------------------------------------------
-- SIDEBAR BUTTONS
-------------------------------------------------
local function createButton(text, page)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 145, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.Text = text
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextSize = 16
	button.Parent = holder
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 10)

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(75, 75, 75)}):Play()
	end)
	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
	end)
	button.MouseButton1Click:Connect(function()
		showPage(page)
	end)
	return button
end

createButton("Home", Home)
createButton("Player", PlayerPage)
createButton("Visuals", Visuals)
createButton("Settings", SettingsPage)
createButton("Credits", Credits)
createButton("Misc", Misc)

-------------------------------------------------
-- HOME PAGE
-------------------------------------------------
local welcome = Instance.new("TextLabel")
welcome.Size = UDim2.new(1, 0, 0, 45)
welcome.Position = UDim2.new(0, 0, 0, 25)
welcome.BackgroundTransparency = 1
welcome.Text = "Welcome to Modern Hub"
welcome.TextColor3 = Color3.new(1, 1, 1)
welcome.Font = Enum.Font.GothamBold
welcome.TextSize = 26
welcome.Parent = Home

local specsLabel = Instance.new("TextLabel")
specsLabel.Size = UDim2.new(1, -40, 0, 80)
specsLabel.Position = UDim2.new(0, 20, 0, 90)
specsLabel.BackgroundTransparency = 1
specsLabel.Text = "Place ID: " .. tostring(game.PlaceId) .. "\nJob ID: " .. tostring(game.JobId) .. "\nPlayers: " .. #Players:GetPlayers()
specsLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
specsLabel.Font = Enum.Font.Gotham
specsLabel.TextSize = 15
specsLabel.TextXAlignment = Enum.TextXAlignment.Left
specsLabel.TextYAlignment = Enum.TextYAlignment.Top
specsLabel.Parent = Home

local runtimeLabel = Instance.new("TextLabel")
runtimeLabel.Size = UDim2.new(1, -40, 0, 25)
runtimeLabel.Position = UDim2.new(0, 20, 0, 185)
runtimeLabel.BackgroundTransparency = 1
runtimeLabel.Text = "Runtime: 0s"
runtimeLabel.TextColor3 = Color3.fromRGB(0, 255, 170)
runtimeLabel.Font = Enum.Font.GothamBold
runtimeLabel.TextSize = 16
runtimeLabel.TextXAlignment = Enum.TextXAlignment.Left
runtimeLabel.Parent = Home

RunService.Heartbeat:Connect(function()
	local seconds = math.floor(tick() - scriptStartTime)
	local mins = math.floor(seconds / 60)
	local secs = seconds % 60
	runtimeLabel.Text = string.format("Runtime: %dm %ds", mins, secs)
	specsLabel.Text = "Place ID: " .. tostring(game.PlaceId) .. "\nJob ID: " .. tostring(game.JobId) .. "\nPlayers: " .. #Players:GetPlayers()
end)

-------------------------------------------------
-- PLAYER PAGE
-------------------------------------------------
local playerTitle = Instance.new("TextLabel")
playerTitle.Size = UDim2.new(1, 0, 0, 35)
playerTitle.Position = UDim2.new(0, 20, 0, 15)
playerTitle.BackgroundTransparency = 1
playerTitle.Text = "Player"
playerTitle.TextColor3 = Color3.new(1, 1, 1)
playerTitle.Font = Enum.Font.GothamBold
playerTitle.TextSize = 24
playerTitle.TextXAlignment = Enum.TextXAlignment.Left
playerTitle.Parent = PlayerPage

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 110, 0, 32)
speedBox.Position = UDim2.new(0, 20, 0, 65)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.Text = "16"
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 16
speedBox.Parent = PlayerPage
Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 40, 0, 32)
speedButton.Position = UDim2.new(0, 140, 0, 65)
speedButton.Text = "✓"
speedButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
speedButton.TextColor3 = Color3.new(1, 1, 1)
speedButton.Parent = PlayerPage
Instance.new("UICorner", speedButton).CornerRadius = UDim.new(0, 8)

speedButton.MouseButton1Click:Connect(function()
	local amount = tonumber(speedBox.Text)
	if amount and player.Character then
		local hum = player.Character:FindFirstChildOfClass("Humanoid")
		if hum then hum.WalkSpeed = amount end
	end
end)

local function createCoordBox(text, pos)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 75, 0, 32)
	box.Position = pos
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.Text = text
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.Gotham
	box.TextSize = 15
	box.Parent = PlayerPage
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
	return box
end

local xBox = createCoordBox("X", UDim2.new(0, 20, 0, 115))
local yBox = createCoordBox("Y", UDim2.new(0, 105, 0, 115))
local zBox = createCoordBox("Z", UDim2.new(0, 190, 0, 115))

local teleportBtn = Instance.new("TextButton")
teleportBtn.Size = UDim2.new(0, 40, 0, 32)
teleportBtn.Position = UDim2.new(0, 275, 0, 115)
teleportBtn.Text = "✓"
teleportBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
teleportBtn.TextColor3 = Color3.new(1, 1, 1)
teleportBtn.Parent = PlayerPage
Instance.new("UICorner", teleportBtn).CornerRadius = UDim.new(0, 8)

teleportBtn.MouseButton1Click:Connect(function()
	local x, y, z = tonumber(xBox.Text), tonumber(yBox.Text), tonumber(zBox.Text)
	if x and y and z and player.Character then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root then root.CFrame = CFrame.new(x, y, z) end
	end
end)

local getCoords = Instance.new("TextButton")
getCoords.Size = UDim2.new(0, 145, 0, 32)
getCoords.Position = UDim2.new(0, 20, 0, 165)
getCoords.Text = "Get Coords"
getCoords.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
getCoords.TextColor3 = Color3.new(1, 1, 1)
getCoords.Parent = PlayerPage
Instance.new("UICorner", getCoords).CornerRadius = UDim.new(0, 8)

getCoords.MouseButton1Click:Connect(function()
	if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
		local pos = player.Character.HumanoidRootPart.Position
		xBox.Text = math.floor(pos.X)
		yBox.Text = math.floor(pos.Y)
		zBox.Text = math.floor(pos.Z)
	end
end)

-- Fly
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 140, 0, 35)
flyButton.Position = UDim2.new(0, 20, 0, 220)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Parent = PlayerPage
Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 8)

local flySpeedBox = Instance.new("TextBox")
flySpeedBox.Size = UDim2.new(0, 110, 0, 32)
flySpeedBox.Position = UDim2.new(0, 20, 0, 270)
flySpeedBox.Text = "60"
flySpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flySpeedBox.TextColor3 = Color3.new(1, 1, 1)
flySpeedBox.Parent = PlayerPage
Instance.new("UICorner", flySpeedBox).CornerRadius = UDim.new(0, 8)

flySpeedBox.FocusLost:Connect(function()
	local val = tonumber(flySpeedBox.Text)
	if val then flySpeed = val end
end)

local function startFlying()
	local char = player.Character
	if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then return end

	local bv = Instance.new("BodyVelocity")
	bv.Name = "ModernHubFly"
	bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
	bv.Velocity = Vector3.zero
	bv.Parent = root

	local bg = Instance.new("BodyGyro")
	bg.Name = "ModernHubGyro"
	bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
	bg.P = 9e4
	bg.Parent = root

	flyConnection = RunService.RenderStepped:Connect(function()
		if not root or not root.Parent then return end
		local cam = workspace.CurrentCamera
		local dir = Vector3.zero
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - cam.CFrame.LookVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + cam.CFrame.RightVector end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then dir = dir + Vector3.new(0, 1, 0) end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then dir = dir - Vector3.new(0, 1, 0) end
		if dir.Magnitude > 0 then dir = dir.Unit end
		bv.Velocity = dir * flySpeed
		bg.CFrame = cam.CFrame
	end)
end

local function stopFlying()
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end
	if player.Character then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			for _, v in pairs(root:GetChildren()) do
				if v.Name == "ModernHubFly" or v.Name == "ModernHubGyro" then
					v:Destroy()
				end
			end
		end
	end
end

flyButton.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		flyButton.Text = "Fly: ON"
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
		startFlying()
	else
		flyButton.Text = "Fly: OFF"
		flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		stopFlying()
	end
end)

-------------------------------------------------
-- VISUALS PAGE
-------------------------------------------------
local visualsTitle = Instance.new("TextLabel")
visualsTitle.Size = UDim2.new(1, 0, 0, 35)
visualsTitle.Position = UDim2.new(0, 20, 0, 15)
visualsTitle.BackgroundTransparency = 1
visualsTitle.Text = "Visuals"
visualsTitle.TextColor3 = Color3.new(1, 1, 1)
visualsTitle.Font = Enum.Font.GothamBold
visualsTitle.TextSize = 24
visualsTitle.TextXAlignment = Enum.TextXAlignment.Left
visualsTitle.Parent = Visuals

local function makeVisualBtn(text, pos)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 220, 0, 36)
	b.Position = pos
	b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	b.Text = text
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.Gotham
	b.TextSize = 15
	b.Parent = Visuals
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)
	return b
end

local highlightBtn = makeVisualBtn("Highlights: OFF", UDim2.new(0, 20, 0, 65))
highlightBtn.MouseButton1Click:Connect(function()
	highlightEnabled = not highlightEnabled
	highlightBtn.Text = highlightEnabled and "Highlights: ON" or "Highlights: OFF"
	for _, plr in pairs(Players:GetPlayers()) do
		if plr \~= player and plr.Character then
			local old = plr.Character:FindFirstChild("ModernHubHL")
			if highlightEnabled then
				if not old then
					local h = Instance.new("Highlight")
					h.Name = "ModernHubHL"
					h.FillColor = highlightColor
					h.OutlineColor = Color3.new(1, 1, 1)
					h.Parent = plr.Character
				end
			else
				if old then old:Destroy() end
			end
		end
	end
end)

local namesBtn = makeVisualBtn("Name Tags: OFF", UDim2.new(0, 20, 0, 110))
namesBtn.MouseButton1Click:Connect(function()
	namesEnabled = not namesEnabled
	namesBtn.Text = namesEnabled and "Name Tags: ON" or "Name Tags: OFF"
	for _, plr in pairs(Players:GetPlayers()) do
		if plr \~= player and plr.Character and plr.Character:FindFirstChild("Head") then
			local old = plr.Character.Head:FindFirstChild("ModernHubName")
			if namesEnabled then
				if not old then
					local bill = Instance.new("BillboardGui")
					bill.Name = "ModernHubName"
					bill.Size = UDim2.new(0, 120, 0, 25)
					bill.StudsOffset = Vector3.new(0, 2.8, 0)
					bill.AlwaysOnTop = true
					bill.Parent = plr.Character.Head
					local lbl = Instance.new("TextLabel")
					lbl.Size = UDim2.new(1, 0, 1, 0)
					lbl.BackgroundTransparency = 1
					lbl.Text = plr.Name
					lbl.TextColor3 = nameTagColor
					lbl.TextStrokeTransparency = 0.3
					lbl.Font = Enum.Font.GothamBold
					lbl.TextSize = 14
					lbl.Parent = bill
				end
			else
				if old then old:Destroy() end
			end
		end
	end
end)

-------------------------------------------------
-- SETTINGS PAGE
-------------------------------------------------
local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 35)
settingsTitle.Position = UDim2.new(0, 20, 0, 15)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Settings"
settingsTitle.TextColor3 = Color3.new(1, 1, 1)
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 24
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Parent = SettingsPage

local function colorBtn(name, default, y, callback)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 180, 0, 34)
	b.Position = UDim2.new(0, 20, 0, y)
	b.BackgroundColor3 = default
	b.Text = name
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Font = Enum.Font.GothamBold
	b.TextSize = 14
	b.Parent = SettingsPage
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8)

	local colors = {
		Color3.fromRGB(0, 170, 255),
		Color3.fromRGB(255, 60, 60),
		Color3.fromRGB(60, 255, 100),
		Color3.fromRGB(255, 170, 0),
		Color3.fromRGB(180, 70, 255),
		Color3.fromRGB(255, 255, 255),
		Color3.fromRGB(255, 100, 180)
	}
	b.MouseButton1Click:Connect(function()
		local idx = 1
		for i, c in ipairs(colors) do
			if c == b.BackgroundColor3 then idx = i break end
		end
		local nextC = colors[(idx % #colors) + 1]
		b.BackgroundColor3 = nextC
		callback(nextC)
	end)
end

colorBtn("Highlight Colour", highlightColor, 70, function(c) highlightColor = c end)
colorBtn("Name Tag Colour", nameTagColor, 115, function(c) nameTagColor = c end)

-------------------------------------------------
-- CREDITS
-------------------------------------------------
local creditsTitle = Instance.new("TextLabel")
creditsTitle.Size = UDim2.new(1, 0, 0, 35)
creditsTitle.Position = UDim2.new(0, 20, 0, 20)
creditsTitle.BackgroundTransparency = 1
creditsTitle.Text = "Credits"
creditsTitle.TextColor3 = Color3.new(1, 1, 1)
creditsTitle.Font = Enum.Font.GothamBold
creditsTitle.TextSize = 24
creditsTitle.TextXAlignment = Enum.TextXAlignment.Left
creditsTitle.Parent = Credits

local madeBy = Instance.new("TextLabel")
madeBy.Size = UDim2.new(1, -40, 0, 30)
madeBy.Position = UDim2.new(0, 20, 0, 70)
madeBy.BackgroundTransparency = 1
madeBy.Text = "Made by Linux_Fan1248970"
madeBy.TextColor3 = Color3.fromRGB(220, 220, 220)
madeBy.Font = Enum.Font.Gotham
madeBy.TextSize = 18
madeBy.TextXAlignment = Enum.TextXAlignment.Left
madeBy.Parent = Credits

-------------------------------------------------
-- CLOSE + MINIMIZE + DRAG
-------------------------------------------------
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -34, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 55, 55)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.Parent = topBar
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
closeBtn.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -68, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
minBtn.Text = "-"
minBtn.TextColor3 = Color3.new(1, 1, 1)
minBtn.Parent = topBar
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)

local minimized = false
local oldSize = main.Size
minBtn.MouseButton1Click:Connect(function()
	minimized = not minimized
	if minimized then
		sidebar.Visible = false
		content.Visible = false
		TweenService:Create(main, TweenInfo.new(0.2), {Size = UDim2.new(0, 700, 0, 40)}):Play()
	else
		sidebar.Visible = true
		content.Visible = true
		TweenService:Create(main, TweenInfo.new(0.2), {Size = oldSize}):Play()
	end
end)

-- Dragging
local dragging = false
local dragStart, startPos
topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)
topBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Right Control toggle
UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.RightControl then
		gui.Enabled = not gui.Enabled
	end
end)

print("[Modern Hub] Loaded as StarterGui")
