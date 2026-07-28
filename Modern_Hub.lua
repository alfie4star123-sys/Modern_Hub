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
local CoreGui = game:GetService("CoreGui")

local player = Players.LocalPlayer

-------------------------------------------------
-- VARIABLES
-------------------------------------------------

tabsLocked = true
tutorialRunning = false
flySpeed = 60
tracerRange = 250
performanceMode = false
selectedPlayer = nil

-------------------------------------------------
-- MAIN GUI
-------------------------------------------------

local gui = Instance.new("ScreenGui")
gui.Name = "ModernHub"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- CoreGui + executor protection
if syn and syn.protect_gui then
	syn.protect_gui(gui)
	gui.Parent = CoreGui
elseif gethui then
	gui.Parent = gethui()
else
	gui.Parent = CoreGui
end

-------------------------------------------------
-- MAIN WINDOW
-------------------------------------------------

local main = Instance.new("Frame")
main.Size = UDim2.new(0, 700, 0, 450)
main.Position = UDim2.new(0.5, -350, 0.5, -225)
main.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
main.BorderSizePixel = 0
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 16)
corner.Parent = main

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

-------------------------------------------------
-- PAGE CREATOR
-------------------------------------------------

local function createPage()
	local page = Instance.new("Frame")
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.Parent = content
	return page
end

-------------------------------------------------
-- PAGES
-------------------------------------------------

local Home = createPage()
local PlayerPage = createPage()
local Visuals = createPage()
local Settings = createPage()
local Credits = createPage()

-------------------------------------------------
-- SCROLLABLE MISC PAGE
-------------------------------------------------

local Misc = Instance.new("ScrollingFrame")
Misc.Size = UDim2.new(1, 0, 1, 0)
Misc.BackgroundTransparency = 1
Misc.BorderSizePixel = 0
Misc.CanvasSize = UDim2.new(0, 0, 0, 1200)
Misc.ScrollBarThickness = 6
Misc.Parent = content

local miscLayout = Instance.new("UIListLayout")
miscLayout.Padding = UDim.new(0, 10)
miscLayout.Parent = Misc

-------------------------------------------------
-- HIDE PAGES
-------------------------------------------------

PlayerPage.Visible = false
Visuals.Visible = false
Settings.Visible = false
Credits.Visible = false
Misc.Visible = false

-------------------------------------------------
-- PAGE SWITCHER
-------------------------------------------------

function showPage(page)
	for _, v in pairs(content:GetChildren()) do
		if v:IsA("Frame") or v:IsA("ScrollingFrame") then
			v.Visible = false
		end
	end
	page.Visible = true
end

-------------------------------------------------
-- WELCOME PAGE
-------------------------------------------------

local welcome = Instance.new("TextLabel")
welcome.Size = UDim2.new(1, 0, 0, 60)
welcome.Position = UDim2.new(0, 0, 0, 50)
welcome.BackgroundTransparency = 1
welcome.Text = "Welcome to Modern Hub"
welcome.TextColor3 = Color3.new(1, 1, 1)
welcome.Font = Enum.Font.GothamBold
welcome.TextSize = 30
welcome.Parent = Home

local description = Instance.new("TextLabel")
description.Size = UDim2.new(0, 400, 0, 50)
description.Position = UDim2.new(0.5, -200, 0, 110)
description.BackgroundTransparency = 1
description.Text = "Press Get Started to unlock features"
description.TextColor3 = Color3.fromRGB(200, 200, 200)
description.Font = Enum.Font.Gotham
description.TextSize = 17
description.Parent = Home

local getStarted = Instance.new("TextButton")
getStarted.Size = UDim2.new(0, 180, 0, 50)
getStarted.Position = UDim2.new(0.5, -90, 0, 190)
getStarted.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
getStarted.Text = "Get Started"
getStarted.TextColor3 = Color3.new(1, 1, 1)
getStarted.Font = Enum.Font.GothamBold
getStarted.TextSize = 20
getStarted.Parent = Home

Instance.new("UICorner", getStarted).CornerRadius = UDim.new(0, 12)

-------------------------------------------------
-- TUTORIAL OBJECTS
-------------------------------------------------

tutorialArrow = Instance.new("TextLabel")
tutorialArrow.Size = UDim2.new(0, 50, 0, 50)
tutorialArrow.BackgroundTransparency = 1
tutorialArrow.Text = "➜"
tutorialArrow.TextColor3 = Color3.fromRGB(0, 170, 255)
tutorialArrow.TextSize = 35
tutorialArrow.Visible = false
tutorialArrow.Parent = gui

tutorialText = Instance.new("TextLabel")
tutorialText.Size = UDim2.new(0, 250, 0, 60)
tutorialText.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
tutorialText.TextColor3 = Color3.new(1, 1, 1)
tutorialText.TextWrapped = true
tutorialText.Font = Enum.Font.Gotham
tutorialText.TextSize = 16
tutorialText.Visible = false
tutorialText.Parent = gui

Instance.new("UICorner", tutorialText).CornerRadius = UDim.new(0, 10)

-------------------------------------------------
-- SIDEBAR BUTTON CREATOR
-------------------------------------------------

local function createButton(text, page)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 145, 0, 40)
	button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	button.Text = text
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextSize = 16
	button.BorderSizePixel = 0
	button.Parent = holder

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = button

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(75, 75, 75)
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(45, 45, 45)
		}):Play()
	end)

	button.MouseButton1Click:Connect(function()
		if tabsLocked then
			return
		end
		showPage(page)
	end)

	return button
end

-------------------------------------------------
-- SIDEBAR TABS
-------------------------------------------------

homeButton = createButton("Home", Home)
playerButton = createButton("Player", PlayerPage)
visualsButton = createButton("Visuals", Visuals)
settingsButton = createButton("Settings", Settings)
creditsButton = createButton("Credits", Credits)
miscButton = createButton("Misc", Misc)

-------------------------------------------------
-- PLAYER PAGE
-------------------------------------------------

local playerTitle = Instance.new("TextLabel")
playerTitle.Size = UDim2.new(1, 0, 0, 40)
playerTitle.Position = UDim2.new(0, 20, 0, 15)
playerTitle.BackgroundTransparency = 1
playerTitle.Text = "Player"
playerTitle.TextColor3 = Color3.new(1, 1, 1)
playerTitle.Font = Enum.Font.GothamBold
playerTitle.TextSize = 26
playerTitle.TextXAlignment = Enum.TextXAlignment.Left
playerTitle.Parent = PlayerPage

-------------------------------------------------
-- WALKSPEED
-------------------------------------------------

local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 120, 0, 35)
speedBox.Position = UDim2.new(0, 20, 0, 70)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
speedBox.Text = "16"
speedBox.TextColor3 = Color3.new(1, 1, 1)
speedBox.Font = Enum.Font.Gotham
speedBox.TextSize = 18
speedBox.Parent = PlayerPage

Instance.new("UICorner", speedBox).CornerRadius = UDim.new(0, 8)

local speedButton = Instance.new("TextButton")
speedButton.Size = UDim2.new(0, 40, 0, 35)
speedButton.Position = UDim2.new(0, 150, 0, 70)
speedButton.Text = "✓"
speedButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
speedButton.TextColor3 = Color3.fromRGB(0, 170, 0)
speedButton.Parent = PlayerPage

Instance.new("UICorner", speedButton).CornerRadius = UDim.new(0, 8)

speedButton.MouseButton1Click:Connect(function()
	local amount = tonumber(speedBox.Text)
	if amount then
		local char = player.Character or player.CharacterAdded:Wait()
		local humanoid = char:FindFirstChildOfClass("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = amount
		end
	end
end)

-------------------------------------------------
-- COORDINATE BOXES
-------------------------------------------------

local function createBox(text, pos)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 80, 0, 35)
	box.Position = pos
	box.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	box.Text = text
	box.TextColor3 = Color3.new(1, 1, 1)
	box.Font = Enum.Font.Gotham
	box.TextSize = 16
	box.Parent = PlayerPage

	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
	return box
end

local xBox = createBox("X", UDim2.new(0, 20, 0, 130))
local yBox = createBox("Y", UDim2.new(0, 110, 0, 130))
local zBox = createBox("Z", UDim2.new(0, 200, 0, 130))

-------------------------------------------------
-- TELEPORT BUTTON
-------------------------------------------------

local teleport = Instance.new("TextButton")
teleport.Size = UDim2.new(0, 40, 0, 35)
teleport.Position = UDim2.new(0, 290, 0, 130)
teleport.Text = "✓"
teleport.BackgroundColor3 = Color3.new(1, 1, 1)
teleport.TextColor3 = Color3.fromRGB(0, 170, 0)
teleport.Parent = PlayerPage

Instance.new("UICorner", teleport).CornerRadius = UDim.new(0, 8)

teleport.MouseButton1Click:Connect(function()
	local x = tonumber(xBox.Text)
	local y = tonumber(yBox.Text)
	local z = tonumber(zBox.Text)

	if x and y and z then
		local root = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
		root.CFrame = CFrame.new(x, y, z)
	end
end)

-------------------------------------------------
-- GET COORDS
-------------------------------------------------

local getCoords = Instance.new("TextButton")
getCoords.Size = UDim2.new(0, 160, 0, 35)
getCoords.Position = UDim2.new(0, 20, 0, 190)
getCoords.Text = "Get Coordinates"
getCoords.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
getCoords.TextColor3 = Color3.new(1, 1, 1)
getCoords.Parent = PlayerPage

Instance.new("UICorner", getCoords).CornerRadius = UDim.new(0, 8)

getCoords.MouseButton1Click:Connect(function()
	local root = (player.Character or player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
	local pos = root.Position
	xBox.Text = math.floor(pos.X)
	yBox.Text = math.floor(pos.Y)
	zBox.Text = math.floor(pos.Z)
end)

-------------------------------------------------
-- COPY COORDS
-------------------------------------------------

local copyCoords = Instance.new("TextButton")
copyCoords.Size = UDim2.new(0, 160, 0, 35)
copyCoords.Position = UDim2.new(0, 200, 0, 190)
copyCoords.Text = "Copy Coordinates"
copyCoords.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
copyCoords.TextColor3 = Color3.new(1, 1, 1)
copyCoords.Parent = PlayerPage

Instance.new("UICorner", copyCoords).CornerRadius = UDim.new(0, 8)

copyCoords.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard(xBox.Text .. "," .. yBox.Text .. "," .. zBox.Text)
		copyCoords.Text = "Copied!"
		task.wait(1)
		copyCoords.Text = "Copy Coordinates"
	end
end)

-------------------------------------------------
-- FLY SETTINGS
-------------------------------------------------

local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0, 140, 0, 40)
flyButton.Position = UDim2.new(0, 20, 0, 250)
flyButton.Text = "Fly: OFF"
flyButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flyButton.TextColor3 = Color3.new(1, 1, 1)
flyButton.Parent = PlayerPage

Instance.new("UICorner", flyButton).CornerRadius = UDim.new(0, 8)

local flySpeedBox = Instance.new("TextBox")
flySpeedBox.Size = UDim2.new(0, 120, 0, 35)
flySpeedBox.Position = UDim2.new(0, 20, 0, 310)
flySpeedBox.Text = "60"
flySpeedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
flySpeedBox.TextColor3 = Color3.new(1, 1, 1)
flySpeedBox.Parent = PlayerPage

Instance.new("UICorner", flySpeedBox).CornerRadius = UDim.new(0, 8)

flySpeedBox.FocusLost:Connect(function()
	local value = tonumber(flySpeedBox.Text)
	if value then
		flySpeed = value
	end
end)

-------------------------------------------------
-- FLY SYSTEM
-------------------------------------------------

local flying = false
local flyConnection

local function startFlying()
	local character = player.Character or player.CharacterAdded:Wait()
	local root = character:WaitForChild("HumanoidRootPart")

	local velocity = Instance.new("BodyVelocity")
	velocity.Name = "ModernHubVelocity"
	velocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	velocity.Velocity = Vector3.zero
	velocity.Parent = root

	local gyro = Instance.new("BodyGyro")
	gyro.Name = "ModernHubGyro"
	gyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	gyro.P = 9000
	gyro.Parent = root

	flyConnection = RunService.RenderStepped:Connect(function()
		local camera = workspace.CurrentCamera
		local direction = Vector3.zero

		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			direction += camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			direction -= camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			direction -= camera.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			direction += camera.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			direction += Vector3.new(0, 1, 0)
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
			direction -= Vector3.new(0, 1, 0)
		end

		if direction.Magnitude > 0 then
			direction = direction.Unit
		end

		velocity.Velocity = direction * flySpeed
		gyro.CFrame = camera.CFrame
	end)
end

local function stopFlying()
	if flyConnection then
		flyConnection:Disconnect()
		flyConnection = nil
	end

	local character = player.Character
	if character then
		local root = character:FindFirstChild("HumanoidRootPart")
		if root then
			for _, v in pairs(root:GetChildren()) do
				if v.Name == "ModernHubVelocity" or v.Name == "ModernHubGyro" then
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
-- GET STARTED SYSTEM
-------------------------------------------------

getStarted.MouseButton1Click:Connect(function()
	if tutorialRunning then
		return
	end

	tutorialRunning = true
	tabsLocked = false
	getStarted.Visible = false
	description.Text = "Features unlocked!"

	task.wait(0.5)

	local function tutorial(button, text)
		tutorialArrow.Visible = true
		tutorialText.Visible = true

		tutorialArrow.Position = UDim2.new(0, button.AbsolutePosition.X + button.AbsoluteSize.X, 0, button.AbsolutePosition.Y)
		tutorialText.Position = UDim2.new(0, button.AbsolutePosition.X + 80, 0, button.AbsolutePosition.Y + 20)
		tutorialText.Text = text

		task.wait(3)
	end

	tutorial(playerButton, "Player: Speed, teleport and flying.")
	tutorial(visualsButton, "Visuals: Player visuals and performance.")
	tutorial(settingsButton, "Settings: Customise the hub.")
	tutorial(miscButton, "Misc: Extra tools and utilities.")
	tutorial(creditsButton, "Credits: Creator information.")

	tutorialArrow.Visible = false
	tutorialText.Visible = false
end)

-------------------------------------------------
-- CLOSE BUTTON
-------------------------------------------------

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -35, 0, 5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.new(1, 1, 1)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 18
closeButton.Parent = topBar

Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 8)

closeButton.MouseButton1Click:Connect(function()
	gui.Enabled = false
end)

-------------------------------------------------
-- MINIMISE BUTTON
-------------------------------------------------

local normalSize = main.Size
local minimized = false

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -70, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.Parent = topBar

Instance.new("UICorner", minimizeButton).CornerRadius = UDim.new(0, 8)

minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		sidebar.Visible = false
		content.Visible = false
		TweenService:Create(main, TweenInfo.new(0.25), {
			Size = UDim2.new(0, 700, 0, 40)
		}):Play()
	else
		sidebar.Visible = true
		content.Visible = true
		TweenService:Create(main, TweenInfo.new(0.25), {
			Size = normalSize
		}):Play()
	end
end)

-------------------------------------------------
-- DRAGGING
-------------------------------------------------

local dragging = false
local dragStart
local startPosition

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPosition = main.Position
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
		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end)

-------------------------------------------------
-- RIGHT CTRL TOGGLE
-------------------------------------------------

UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == Enum.KeyCode.RightControl then
		gui.Enabled = not gui.Enabled
	end
end)

-------------------------------------------------
-- VISUALS PAGE
-------------------------------------------------

local visualsTitle = Instance.new("TextLabel")
visualsTitle.Size = UDim2.new(1, 0, 0, 40)
visualsTitle.Position = UDim2.new(0, 20, 0, 15)
visualsTitle.BackgroundTransparency = 1
visualsTitle.Text = "Visuals"
visualsTitle.TextColor3 = Color3.new(1, 1, 1)
visualsTitle.Font = Enum.Font.GothamBold
visualsTitle.TextSize = 26
visualsTitle.TextXAlignment = Enum.TextXAlignment.Left
visualsTitle.Parent = Visuals

-------------------------------------------------
-- BUTTON CREATOR
-------------------------------------------------

local function visualButton(text, pos)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 230, 0, 40)
	button.Position = pos
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.Text = text
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Font = Enum.Font.Gotham
	button.TextSize = 16
	button.Parent = Visuals

	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

	button.MouseEnter:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(75, 75, 75)
		}):Play()
	end)

	button.MouseLeave:Connect(function()
		TweenService:Create(button, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		}):Play()
	end)

	return button
end

-------------------------------------------------
-- HIGHLIGHTS
-------------------------------------------------

local highlightEnabled = false
local highlightButton = visualButton("Highlights: OFF", UDim2.new(0, 20, 0, 70))

local function updateHighlights()
	for _, plr in pairs(Players:GetPlayers()) do
		if plr \~= player and plr.Character then
			local old = plr.Character:FindFirstChild("ModernHubHighlight")

			if highlightEnabled then
				if not old then
					local h = Instance.new("Highlight")
					h.Name = "ModernHubHighlight"
					h.FillColor = Color3.fromRGB(0, 170, 255)
					h.OutlineColor = Color3.new(1, 1, 1)
					h.Parent = plr.Character
				end
			elseif old then
				old:Destroy()
			end
		end
	end
end

highlightButton.MouseButton1Click:Connect(function()
	highlightEnabled = not highlightEnabled
	updateHighlights()
	highlightButton.Text = highlightEnabled and "Highlights: ON" or "Highlights: OFF"
end)

-------------------------------------------------
-- NAME TAGS
-------------------------------------------------

local namesEnabled = false
local namesButton = visualButton("Name Tags: OFF", UDim2.new(0, 20, 0, 120))

local function addName(plr)
	if plr.Character and plr.Character:FindFirstChild("Head") and not plr.Character.Head:FindFirstChild("ModernHubName") then
		local gui = Instance.new("BillboardGui")
		gui.Name = "ModernHubName"
		gui.Size = UDim2.new(0, 150, 0, 30)
		gui.StudsOffset = Vector3.new(0, 3, 0)
		gui.Parent = plr.Character.Head

		local text = Instance.new("TextLabel")
		text.Size = UDim2.new(1, 0, 1, 0)
		text.BackgroundTransparency = 1
		text.Text = plr.Name
		text.TextColor3 = Color3.new(1, 1, 1)
		text.TextStrokeTransparency = 0
		text.Font = Enum.Font.GothamBold
		text.TextSize = 16
		text.Parent = gui
	end
end

namesButton.MouseButton1Click:Connect(function()
	namesEnabled = not namesEnabled

	for _, plr in pairs(Players:GetPlayers()) do
		if plr \~= player then
			if namesEnabled then
				addName(plr)
			elseif plr.Character then
				local head = plr.Character:FindFirstChild("Head")
				if head then
					local old = head:FindFirstChild("ModernHubName")
					if old then
						old:Destroy()
					end
				end
			end
		end
	end

	namesButton.Text = namesEnabled and "Name Tags: ON" or "Name Tags: OFF"
end)

-------------------------------------------------
-- HEALTH BARS
-------------------------------------------------

local healthEnabled = false
local healthButton = visualButton("Health Bars: OFF", UDim2.new(0, 20, 0, 170))

local function addHealth(plr)
	if plr.Character and plr.Character:FindFirstChild("Head") and not plr.Character.Head:FindFirstChild("ModernHubHealth") then
		local gui = Instance.new("BillboardGui")
		gui.Name = "ModernHubHealth"
		gui.Size = UDim2.new(0, 120, 0, 15)
		gui.StudsOffset = Vector3.new(0, 4, 0)
		gui.Parent = plr.Character.Head

		local bg = Instance.new("Frame")
		bg.Size = UDim2.new(1, 0, 1, 0)
		bg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		bg.BorderSizePixel = 0
		bg.Parent = gui

		local bar = Instance.new("Frame")
		bar.Name = "Bar"
		bar.Size = UDim2.new(1, 0, 1, 0)
		bar.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
		bar.BorderSizePixel = 0
		bar.Parent = bg

		local hum = plr.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			hum.HealthChanged:Connect(function()
				bar.Size = UDim2.new(hum.Health / hum.MaxHealth, 0, 1, 0)
			end)
		end
	end
end

healthButton.MouseButton1Click:Connect(function()
	healthEnabled = not healthEnabled

	for _, plr in pairs(Players:GetPlayers()) do
		if plr \~= player and healthEnabled then
			addHealth(plr)
		end
	end

	healthButton.Text = healthEnabled and "Health Bars: ON" or "Health Bars: OFF"
end)

-------------------------------------------------
-- FPS ABOVE HEAD
-------------------------------------------------

local fpsEnabled = false
local fpsGui
local fpsButton = visualButton("FPS Above Head: OFF", UDim2.new(0, 280, 0, 70))

local frames = 0
local lastFPS = tick()

fpsButton.MouseButton1Click:Connect(function()
	fpsEnabled = not fpsEnabled

	if fpsEnabled then
		local head = player.Character and player.Character:FindFirstChild("Head")
		if head then
			fpsGui = Instance.new("BillboardGui")
			fpsGui.Name = "ModernHubFPS"
			fpsGui.Size = UDim2.new(0, 120, 0, 30)
			fpsGui.StudsOffset = Vector3.new(0, 5, 0)
			fpsGui.Parent = head

			local label = Instance.new("TextLabel")
			label.Name = "FPS"
			label.Size = UDim2.new(1, 0, 1, 0)
			label.BackgroundTransparency = 1
			label.TextColor3 = Color3.fromRGB(0, 255, 255)
			label.TextStrokeTransparency = 0
			label.Font = Enum.Font.GothamBold
			label.TextSize = 18
			label.Parent = fpsGui
		end
	else
		if fpsGui then
			fpsGui:Destroy()
		end
	end
end)

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - lastFPS >= 1 then
		if fpsEnabled and fpsGui and fpsGui:FindFirstChild("FPS") then
			fpsGui.FPS.Text = "FPS: " .. frames
		end
		frames = 0
		lastFPS = tick()
	end
end)

-------------------------------------------------
-- PERFORMANCE MODE
-------------------------------------------------

local performanceButton = visualButton("3D Rendering: ON", UDim2.new(0, 280, 0, 120))

performanceButton.MouseButton1Click:Connect(function()
	performanceMode = not performanceMode

	if performanceMode then
		Lighting.GlobalShadows = false
		Lighting.EnvironmentDiffuseScale = 0
		Lighting.EnvironmentSpecularScale = 0

		for _, obj in pairs(workspace:GetDescendants()) do
			if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
				obj.Enabled = false
			end
			if obj:IsA("BasePart") then
				obj.CastShadow = false
			end
		end

		performanceButton.Text = "3D Rendering: OFF"
	else
		Lighting.GlobalShadows = true
		Lighting.EnvironmentDiffuseScale = 1
		Lighting.EnvironmentSpecularScale = 1
		performanceButton.Text = "3D Rendering: ON"
	end
end)

-------------------------------------------------
-- SETTINGS PAGE
-------------------------------------------------

local settingsTitle = Instance.new("TextLabel")
settingsTitle.Size = UDim2.new(1, 0, 0, 40)
settingsTitle.Position = UDim2.new(0, 20, 0, 15)
settingsTitle.BackgroundTransparency = 1
settingsTitle.Text = "Settings"
settingsTitle.TextColor3 = Color3.new(1, 1, 1)
settingsTitle.Font = Enum.Font.GothamBold
settingsTitle.TextSize = 26
settingsTitle.TextXAlignment = Enum.TextXAlignment.Left
settingsTitle.Parent = Settings

-------------------------------------------------
-- TRACER RANGE
-------------------------------------------------

local tracerLabel = Instance.new("TextLabel")
tracerLabel.Size = UDim2.new(0, 250, 0, 30)
tracerLabel.Position = UDim2.new(0, 20, 0, 80)
tracerLabel.BackgroundTransparency = 1
tracerLabel.Text = "Tracer Range: " .. tracerRange
tracerLabel.TextColor3 = Color3.new(1, 1, 1)
tracerLabel.Font = Enum.Font.Gotham
tracerLabel.TextSize = 18
tracerLabel.TextXAlignment = Enum.TextXAlignment.Left
tracerLabel.Parent = Settings

local tracerBar = Instance.new("Frame")
tracerBar.Size = UDim2.new(0, 250, 0, 10)
tracerBar.Position = UDim2.new(0, 20, 0, 125)
tracerBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tracerBar.Parent = Settings

Instance.new("UICorner", tracerBar).CornerRadius = UDim.new(1, 0)

local tracerFill = Instance.new("Frame")
tracerFill.Size = UDim2.new(tracerRange / 1000, 0, 1, 0)
tracerFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
tracerFill.Parent = tracerBar

Instance.new("UICorner", tracerFill).CornerRadius = UDim.new(1, 0)

local tracerKnob = Instance.new("TextButton")
tracerKnob.Size = UDim2.new(0, 20, 0, 20)
tracerKnob.Position = UDim2.new(tracerRange / 1000, -10, 0.5, -10)
tracerKnob.Text = ""
tracerKnob.BackgroundColor3 = Color3.new(1, 1, 1)
tracerKnob.Parent = tracerBar

Instance.new("UICorner", tracerKnob).CornerRadius = UDim.new(1, 0)

local tracerDragging = false

tracerKnob.MouseButton1Down:Connect(function()
	tracerDragging = true
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		tracerDragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if tracerDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local percent = math.clamp((input.Position.X - tracerBar.AbsolutePosition.X) / tracerBar.AbsoluteSize.X, 0, 1)
		tracerRange = math.floor(50 + percent * 950)

		tracerFill.Size = UDim2.new(percent, 0, 1, 0)
		tracerKnob.Position = UDim2.new(percent, -10, 0.5, -10)
		tracerLabel.Text = "Tracer Range: " .. tracerRange
	end
end)

-------------------------------------------------
-- CONFIG SAVE
-------------------------------------------------

local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0, 180, 0, 40)
saveButton.Position = UDim2.new(0, 20, 0, 190)
saveButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
saveButton.Text = "Save Config"
saveButton.TextColor3 = Color3.new(1, 1, 1)
saveButton.Font = Enum.Font.GothamBold
saveButton.TextSize = 18
saveButton.Parent = Settings

Instance.new("UICorner", saveButton).CornerRadius = UDim.new(0, 10)

local savedConfig = {}

saveButton.MouseButton1Click:Connect(function()
	savedConfig = {
		TracerRange = tracerRange,
		FlySpeed = flySpeed,
		Performance = performanceMode
	}

	saveButton.Text = "Saved!"
	task.wait(1)
	saveButton.Text = "Save Config"
end)

-------------------------------------------------
-- CREDITS PAGE
-------------------------------------------------

local creditsTitle = Instance.new("TextLabel")
creditsTitle.Size = UDim2.new(1, 0, 0, 40)
creditsTitle.Position = UDim2.new(0, 20, 0, 20)
creditsTitle.BackgroundTransparency = 1
creditsTitle.Text = "Credits"
creditsTitle.TextColor3 = Color3.new(1, 1, 1)
creditsTitle.Font = Enum.Font.GothamBold
creditsTitle.TextSize = 28
creditsTitle.TextXAlignment = Enum.TextXAlignment.Left
creditsTitle.Parent = Credits

local creatorText = Instance.new("TextLabel")
creatorText.Size = UDim2.new(1, 0, 0, 35)
creatorText.Position = UDim2.new(0, 20, 0, 80)
creatorText.BackgroundTransparency = 1
creatorText.Text = "Made by Linux_Fan1248970"
creatorText.TextColor3 = Color3.fromRGB(230, 230, 230)
creatorText.Font = Enum.Font.Gotham
creatorText.TextSize = 20
creatorText.TextXAlignment = Enum.TextXAlignment.Left
creatorText.Parent = Credits

-------------------------------------------------
-- TIKTOK CARD
-------------------------------------------------

local tiktokCard = Instance.new("TextButton")
tiktokCard.Size = UDim2.new(0, 350, 0, 75)
tiktokCard.Position = UDim2.new(0, 20, 0, 140)
tiktokCard.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
tiktokCard.Text = ""
tiktokCard.Parent = Credits

Instance.new("UICorner", tiktokCard).CornerRadius = UDim.new(0, 12)

local tiktokIcon = Instance.new("ImageLabel")
tiktokIcon.Size = UDim2.new(0, 50, 0, 50)
tiktokIcon.Position = UDim2.new(0, 15, 0, 12)
tiktokIcon.BackgroundTransparency = 1
tiktokIcon.Image = "rbxassetid://6031075938"
tiktokIcon.Parent = tiktokCard

local tiktokText = Instance.new("TextLabel")
tiktokText.Size = UDim2.new(0, 200, 0, 40)
tiktokText.Position = UDim2.new(0, 80, 0, 18)
tiktokText.BackgroundTransparency = 1
tiktokText.Text = "@linux_fan1248970"
tiktokText.TextColor3 = Color3.new(1, 1, 1)
tiktokText.Font = Enum.Font.GothamBold
tiktokText.TextSize = 18
tiktokText.TextXAlignment = Enum.TextXAlignment.Left
tiktokText.Parent = tiktokCard

local arrow = Instance.new("TextLabel")
arrow.Size = UDim2.new(0, 40, 0, 40)
arrow.Position = UDim2.new(1, -45, 0, 18)
arrow.BackgroundTransparency = 1
arrow.Text = "↗"
arrow.TextColor3 = Color3.new(1, 1, 1)
arrow.Font = Enum.Font.GothamBold
arrow.TextSize = 25
arrow.Parent = tiktokCard

tiktokCard.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://www.tiktok.com/@linux_fan1248970")
	end
end)

-------------------------------------------------
-- HOVER ANIMATION
-------------------------------------------------

local oldCardSize = tiktokCard.Size

tiktokCard.MouseEnter:Connect(function()
	TweenService:Create(tiktokCard, TweenInfo.new(0.2), {
		Size = UDim2.new(0, 370, 0, 80),
		BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	}):Play()
end)

tiktokCard.MouseLeave:Connect(function()
	TweenService:Create(tiktokCard, TweenInfo.new(0.2), {
		Size = oldCardSize,
		BackgroundColor3 = Color3.fromRGB(45, 45, 45)
	}):Play()
end)

-------------------------------------------------
-- MISC PAGE
-------------------------------------------------

local miscTitle = Instance.new("TextLabel")
miscTitle.Size = UDim2.new(1, 0, 0, 40)
miscTitle.Position = UDim2.new(0, 20, 0, 15)
miscTitle.BackgroundTransparency = 1
miscTitle.Text = "Misc Tools"
miscTitle.TextColor3 = Color3.new(1, 1, 1)
miscTitle.Font = Enum.Font.GothamBold
miscTitle.TextSize = 26
miscTitle.TextXAlignment = Enum.TextXAlignment.Left
miscTitle.Parent = Misc

-------------------------------------------------
-- PLAYER SEARCH
-------------------------------------------------

local searchBox = Instance.new("TextBox")
searchBox.Size = UDim2.new(0, 230, 0, 35)
searchBox.Position = UDim2.new(0, 20, 0, 70)
searchBox.PlaceholderText = "Search player..."
searchBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
searchBox.TextColor3 = Color3.new(1, 1, 1)
searchBox.Parent = Misc

Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 8)

-------------------------------------------------
-- DROPDOWN
-------------------------------------------------

local dropdown = Instance.new("TextButton")
dropdown.Size = UDim2.new(0, 230, 0, 40)
dropdown.Position = UDim2.new(0, 20, 0, 115)
dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
dropdown.Text = "Select Orbit Target"
dropdown.TextColor3 = Color3.new(1, 1, 1)
dropdown.Parent = Misc

Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(0, 230, 0, 150)
playerList.Position = UDim2.new(0, 20, 0, 160)
playerList.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
playerList.Visible = false
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.ScrollBarThickness = 5
playerList.Parent = Misc

local listLayout = Instance.new("UIListLayout")
listLayout.Padding = UDim.new(0, 5)
listLayout.Parent = playerList

local function refreshPlayers()
	for _, v in pairs(playerList:GetChildren()) do
		if v:IsA("TextButton") then
			v:Destroy()
		end
	end

	local amount = 0

	for _, plr in pairs(Players:GetPlayers()) do
		if plr \~= player then
			amount += 1

			local button = Instance.new("TextButton")
			button.Size = UDim2.new(1, -10, 0, 35)
			button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			button.Text = plr.Name
			button.TextColor3 = Color3.new(1, 1, 1)
			button.Parent = playerList

			button.MouseButton1Click:Connect(function()
				selectedPlayer = plr
				dropdown.Text = "Target: " .. plr.Name
				playerList.Visible = false
			end)
		end
	end

	playerList.CanvasSize = UDim2.new(0, 0, 0, amount * 40)
end

dropdown.MouseButton1Click:Connect(function()
	refreshPlayers()
	playerList.Visible = not playerList.Visible
end)

-------------------------------------------------
-- ORBIT SETTINGS
-------------------------------------------------

local orbiting = false
local orbitConnection
local orbitDistance = 15
local orbitSpeed = 3
local orbitAngle = 0

local orbitLabel = Instance.new("TextLabel")
orbitLabel.Size = UDim2.new(0, 250, 0, 30)
orbitLabel.Position = UDim2.new(0, 20, 0, 340)
orbitLabel.BackgroundTransparency = 1
orbitLabel.Text = "Orbit Distance: " .. orbitDistance
orbitLabel.TextColor3 = Color3.new(1, 1, 1)
orbitLabel.Font = Enum.Font.Gotham
orbitLabel.TextSize = 17
orbitLabel.TextXAlignment = Enum.TextXAlignment.Left
orbitLabel.Parent = Misc

-------------------------------------------------
-- DISTANCE SLIDER
-------------------------------------------------

local distanceBar = Instance.new("Frame")
distanceBar.Size = UDim2.new(0, 230, 0, 10)
distanceBar.Position = UDim2.new(0, 20, 0, 380)
distanceBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
distanceBar.Parent = Misc

local distanceFill = Instance.new("Frame")
distanceFill.Size = UDim2.new(0.25, 0, 1, 0)
distanceFill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
distanceFill.Parent = distanceBar

local distanceKnob = Instance.new("TextButton")
distanceKnob.Size = UDim2.new(0, 20, 0, 20)
distanceKnob.Position = UDim2.new(0.25, -10, 0.5, -10)
distanceKnob.Text = ""
distanceKnob.BackgroundColor3 = Color3.new(1, 1, 1)
distanceKnob.Parent = distanceBar

local distanceDragging = false

distanceKnob.MouseButton1Down:Connect(function()
	distanceDragging = true
end)

UserInputService.InputChanged:Connect(function(input)
	if distanceDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local percent = math.clamp((input.Position.X - distanceBar.AbsolutePosition.X) / distanceBar.AbsoluteSize.X, 0, 1)
		orbitDistance = math.floor(5 + percent * 45)

		distanceFill.Size = UDim2.new(percent, 0, 1, 0)
		distanceKnob.Position = UDim2.new(percent, -10, 0.5, -10)
		orbitLabel.Text = "Orbit Distance: " .. orbitDistance
	end
end)

UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		distanceDragging = false
	end
end)

-------------------------------------------------
-- ORBIT BUTTON
-------------------------------------------------

local orbitButton = Instance.new("TextButton")
orbitButton.Size = UDim2.new(0, 230, 0, 40)
orbitButton.Position = UDim2.new(0, 20, 0, 420)
orbitButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
orbitButton.Text = "Orbit: OFF"
orbitButton.TextColor3 = Color3.new(1, 1, 1)
orbitButton.Parent = Misc

Instance.new("UICorner", orbitButton).CornerRadius = UDim.new(0, 8)

orbitButton.MouseButton1Click:Connect(function()
	if not selectedPlayer then
		return
	end

	orbiting = not orbiting

	if orbiting then
		orbitButton.Text = "Orbit: ON"

		orbitConnection = RunService.RenderStepped:Connect(function()
			if selectedPlayer.Character and selectedPlayer.Character:FindFirstChild("HumanoidRootPart") then
				local target = selectedPlayer.Character.HumanoidRootPart
				local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

				if root then
					orbitAngle += math.rad(orbitSpeed)
					root.CFrame = CFrame.new(
						target.Position + Vector3.new(
							math.cos(orbitAngle) * orbitDistance,
							5,
							math.sin(orbitAngle) * orbitDistance
						),
						target.Position
					)
				end
			end
		end)
	else
		orbitButton.Text = "Orbit: OFF"
		if orbitConnection then
			orbitConnection:Disconnect()
			orbitConnection = nil
		end
	end
end)

-------------------------------------------------
-- SPECTATE
-------------------------------------------------

local spectating = false
local spectateButton = Instance.new("TextButton")
spectateButton.Size = UDim2.new(0, 230, 0, 40)
spectateButton.Position = UDim2.new(0, 20, 0, 480)
spectateButton.Text = "Spectate Player"
spectateButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
spectateButton.TextColor3 = Color3.new(1, 1, 1)
spectateButton.Parent = Misc

spectateButton.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character then
		local hum = selectedPlayer.Character:FindFirstChildOfClass("Humanoid")
		if hum then
			workspace.CurrentCamera.CameraSubject = hum
		end
	end
end)

-------------------------------------------------
-- FOLLOW PLAYER
-------------------------------------------------

local followButton = Instance.new("TextButton")
followButton.Size = UDim2.new(0, 230, 0, 40)
followButton.Position = UDim2.new(0, 20, 0, 530)
followButton.Text = "Follow Player"
followButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
followButton.TextColor3 = Color3.new(1, 1, 1)
followButton.Parent = Misc

followButton.MouseButton1Click:Connect(function()
	if selectedPlayer and selectedPlayer.Character then
		local target = selectedPlayer.Character:FindFirstChild("HumanoidRootPart")
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")

		if target and root then
			root.CFrame = target.CFrame * CFrame.new(0, 0, 5)
		end
	end
end)

-------------------------------------------------
-- WAYPOINTS
-------------------------------------------------

local waypoint

local saveWaypoint = Instance.new("TextButton")
saveWaypoint.Size = UDim2.new(0, 230, 0, 40)
saveWaypoint.Position = UDim2.new(0, 20, 0, 580)
saveWaypoint.Text = "Save Waypoint"
saveWaypoint.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
saveWaypoint.TextColor3 = Color3.new(1, 1, 1)
saveWaypoint.Parent = Misc

saveWaypoint.MouseButton1Click:Connect(function()
	local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
	if root then
		waypoint = root.CFrame
	end
end)

local tpWaypoint = Instance.new("TextButton")
tpWaypoint.Size = UDim2.new(0, 230, 0, 40)
tpWaypoint.Position = UDim2.new(0, 20, 0, 630)
tpWaypoint.Text = "Teleport Waypoint"
tpWaypoint.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
tpWaypoint.TextColor3 = Color3.new(1, 1, 1)
tpWaypoint.Parent = Misc

tpWaypoint.MouseButton1Click:Connect(function()
	if waypoint then
		local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame = waypoint
		end
	end
end)

-------------------------------------------------
-- SERVER INFO
-------------------------------------------------

local serverTitle = Instance.new("TextLabel")
serverTitle.Size = UDim2.new(0, 250, 0, 30)
serverTitle.Position = UDim2.new(0, 300, 0, 70)
serverTitle.BackgroundTransparency = 1
serverTitle.Text = "Server Info"
serverTitle.TextColor3 = Color3.new(1, 1, 1)
serverTitle.Font = Enum.Font.GothamBold
serverTitle.TextSize = 20
serverTitle.TextXAlignment = Enum.TextXAlignment.Left
serverTitle.Parent = Misc

local serverInfo = Instance.new("TextLabel")
serverInfo.Size = UDim2.new(0, 300, 0, 100)
serverInfo.Position = UDim2.new(0, 300, 0, 110)
serverInfo.BackgroundTransparency = 1
serverInfo.TextColor3 = Color3.fromRGB(220, 220, 220)
serverInfo.Font = Enum.Font.Gotham
serverInfo.TextSize = 16
serverInfo.TextWrapped = true
serverInfo.TextXAlignment = Enum.TextXAlignment.Left
serverInfo.Parent = Misc

local function updateServerInfo()
	serverInfo.Text = "Players: " .. #Players:GetPlayers() .. "\nServer ID: " .. game.JobId .. "\nPlace ID: " .. game.PlaceId
end

updateServerInfo()

-------------------------------------------------
-- COPY BUTTON FUNCTION
-------------------------------------------------

local function copyButton(text, pos, value)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 140, 0, 35)
	button.Position = pos
	button.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	button.Text = text
	button.TextColor3 = Color3.new(1, 1, 1)
	button.Parent = Misc

	Instance.new("UICorner", button).CornerRadius = UDim.new(0, 8)

	button.MouseButton1Click:Connect(function()
		if setclipboard then
			setclipboard(value)
			button.Text = "Copied!"
			task.wait(1)
			button.Text = text
		end
	end)
end

copyButton("Copy User ID", UDim2.new(0, 300, 0, 240), tostring(player.UserId))
copyButton("Copy Game Link", UDim2.new(0, 300, 0, 285), "https://www.roblox.com/games/" .. game.PlaceId)
copyButton("Copy Job ID", UDim2.new(0, 300, 0, 330), game.JobId)

-------------------------------------------------
-- REJOIN
-------------------------------------------------

local rejoin = Instance.new("TextButton")
rejoin.Size = UDim2.new(0, 140, 0, 35)
rejoin.Position = UDim2.new(0, 300, 0, 380)
rejoin.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
rejoin.Text = "Rejoin Server"
rejoin.TextColor3 = Color3.new(1, 1, 1)
rejoin.Parent = Misc

rejoin.MouseButton1Click:Connect(function()
	TeleportService:Teleport(game.PlaceId, player)
end)

-------------------------------------------------
-- FOV SLIDER
-------------------------------------------------

local fov = workspace.CurrentCamera.FieldOfView

local fovLabel = Instance.new("TextLabel")
fovLabel.Size = UDim2.new(0, 250, 0, 30)
fovLabel.Position = UDim2.new(0, 300, 0, 440)
fovLabel.BackgroundTransparency = 1
fovLabel.Text = "FOV: " .. fov
fovLabel.TextColor3 = Color3.new(1, 1, 1)
fovLabel.Parent = Misc

local fovBox = Instance.new("TextBox")
fovBox.Size = UDim2.new(0, 100, 0, 35)
fovBox.Position = UDim2.new(0, 300, 0, 480)
fovBox.Text = tostring(fov)
fovBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
fovBox.TextColor3 = Color3.new(1, 1, 1)
fovBox.Parent = Misc

fovBox.FocusLost:Connect(function()
	local value = tonumber(fovBox.Text)
	if value then
		workspace.CurrentCamera.FieldOfView = math.clamp(value, 40, 120)
		fovLabel.Text = "FOV: " .. workspace.CurrentCamera.FieldOfView
	end
end)

-------------------------------------------------
-- CAMERA SHAKE
-------------------------------------------------

local shake = false
local shakeButton = Instance.new("TextButton")
shakeButton.Size = UDim2.new(0, 140, 0, 35)
shakeButton.Position = UDim2.new(0, 300, 0, 540)
shakeButton.Text = "Camera Shake OFF"
shakeButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
shakeButton.TextColor3 = Color3.new(1, 1, 1)
shakeButton.Parent = Misc

shakeButton.MouseButton1Click:Connect(function()
	shake = not shake
	shakeButton.Text = shake and "Camera Shake ON" or "Camera Shake OFF"
end)

RunService.RenderStepped:Connect(function()
	if shake then
		local cam = workspace.CurrentCamera
		cam.CFrame *= CFrame.Angles(
			math.rad(math.random(-2, 2)),
			math.rad(math.random(-2, 2)),
			0
		)
	end
end)

-------------------------------------------------
-- RGB CHARACTER
-------------------------------------------------

local rgb = false
local rgbButton = Instance.new("TextButton")
rgbButton.Size = UDim2.new(0, 140, 0, 35)
rgbButton.Position = UDim2.new(0, 300, 0, 590)
rgbButton.Text = "RGB OFF"
rgbButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
rgbButton.TextColor3 = Color3.new(1, 1, 1)
rgbButton.Parent = Misc

rgbButton.MouseButton1Click:Connect(function()
	rgb = not rgb
	rgbButton.Text = rgb and "RGB ON" or "RGB OFF"
end)

RunService.RenderStepped:Connect(function()
	if rgb and player.Character then
		for _, v in pairs(player.Character:GetChildren()) do
			if v:IsA("BasePart") then
				v.Color = Color3.fromHSV(tick() % 5 / 5, 1, 1)
			end
		end
	end
end)

-------------------------------------------------
-- SPIN CHARACTER
-------------------------------------------------

local spinning = false
local spinButton = Instance.new("TextButton")
spinButton.Size = UDim2.new(0, 140, 0, 35)
spinButton.Position = UDim2.new(0, 300, 0, 640)
spinButton.Text = "Spin OFF"
spinButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
spinButton.TextColor3 = Color3.new(1, 1, 1)
spinButton.Parent = Misc

spinButton.MouseButton1Click:Connect(function()
	spinning = not spinning
	spinButton.Text = spinning and "Spin ON" or "Spin OFF"
end)

RunService.RenderStepped:Connect(function()
	if spinning and player.Character then
		local root = player.Character:FindFirstChild("HumanoidRootPart")
		if root then
			root.CFrame *= CFrame.Angles(0, math.rad(10), 0)
		end
	end
end)

-------------------------------------------------
-- QUICK ACTIONS
-------------------------------------------------

local function quick(text, pos, func)
	local b = Instance.new("TextButton")
	b.Size = UDim2.new(0, 140, 0, 35)
	b.Position = pos
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	b.TextColor3 = Color3.new(1, 1, 1)
	b.Parent = Misc
	b.MouseButton1Click:Connect(func)
end

quick("Reset", UDim2.new(0, 470, 0, 240), function()
	player.Character:FindFirstChildOfClass("Humanoid"):ChangeState(Enum.HumanoidStateType.Dead)
end)

quick("Sit", UDim2.new(0, 470, 0, 285), function()
	player.Character:FindFirstChildOfClass("Humanoid").Sit = true
end)

quick("Jump", UDim2.new(0, 470, 0, 330), function()
	player.Character:FindFirstChildOfClass("Humanoid").Jump = true
end)

-------------------------------------------------
-- LIVE STATS PANEL
-------------------------------------------------

local statsLabel = Instance.new("TextLabel")
statsLabel.Size = UDim2.new(0, 250, 0, 80)
statsLabel.Position = UDim2.new(0, 470, 0, 400)
statsLabel.BackgroundTransparency = 1
statsLabel.TextColor3 = Color3.fromRGB(0, 255, 255)
statsLabel.Font = Enum.Font.GothamBold
statsLabel.TextSize = 16
statsLabel.TextXAlignment = Enum.TextXAlignment.Left
statsLabel.Parent = Misc

local statFrames = 0
local statTime = tick()

RunService.RenderStepped:Connect(function()
	statFrames += 1
	if tick() - statTime >= 1 then
		local ping = "N/A"
		pcall(function()
			ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
		end)

		statsLabel.Text = "FPS: " .. statFrames .. "\nPing: " .. ping .. " ms"
		statFrames = 0
		statTime = tick()
	end
end)

-------------------------------------------------
-- PART SPAWNER
-------------------------------------------------

local partSpawnerTitle = Instance.new("TextLabel")
partSpawnerTitle.Size = UDim2.new(0, 250, 0, 30)
partSpawnerTitle.Position = UDim2.new(0, 470, 0, 520)
partSpawnerTitle.BackgroundTransparency = 1
partSpawnerTitle.Text = "Part Spawner"
partSpawnerTitle.TextColor3 = Color3.new(1, 1, 1)
partSpawnerTitle.Font = Enum.Font.GothamBold
partSpawnerTitle.TextSize = 20
partSpawnerTitle.TextXAlignment = Enum.TextXAlignment.Left
partSpawnerTitle.Parent = Misc

local spawnPartButton = Instance.new("TextButton")
spawnPartButton.Size = UDim2.new(0, 140, 0, 35)
spawnPartButton.Position = UDim2.new(0, 470, 0, 570)
spawnPartButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
spawnPartButton.Text = "Spawn Part"
spawnPartButton.TextColor3 = Color3.new(1, 1, 1)
spawnPartButton.Font = Enum.Font.GothamBold
spawnPartButton.TextSize = 16
spawnPartButton.Parent = Misc

Instance.new("UICorner", spawnPartButton).CornerRadius = UDim.new(0, 8)

local spawnedParts = {}

spawnPartButton.MouseButton1Click:Connect(function()
	local character = player.Character
	if character then
		local root = character:FindFirstChild("HumanoidRootPart")
		if root then
			local part = Instance.new("Part")
			part.Size = Vector3.new(5, 5, 5)
			part.Position = root.Position + Vector3.new(0, 5, 0)
			part.Color = Color3.fromRGB(0, 170, 255)
			part.Material = Enum.Material.Neon
			part.Anchored = true
			part.Name = "ModernHubPart"
			part.Parent = workspace
			table.insert(spawnedParts, part)
		end
	end
end)

local deletePartsButton = Instance.new("TextButton")
deletePartsButton.Size = UDim2.new(0, 140, 0, 35)
deletePartsButton.Position = UDim2.new(0, 620, 0, 570)
deletePartsButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
deletePartsButton.Text = "Delete Parts"
deletePartsButton.TextColor3 = Color3.new(1, 1, 1)
deletePartsButton.Parent = Misc

Instance.new("UICorner", deletePartsButton).CornerRadius = UDim.new(0, 8)

deletePartsButton.MouseButton1Click:Connect(function()
	for _, part in pairs(spawnedParts) do
		if part then
			part:Destroy()
		end
	end
	spawnedParts = {}
end)

print("Modern Hub Loaded Successfully")
