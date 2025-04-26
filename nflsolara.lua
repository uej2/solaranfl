-- NFL Universe Combined Trainer
-- Combines QB Aimbot Trainer and NFL Universe Trainer functionality

--[[
  Kali Hub Key System
  Paste this at the VERY TOP of your script
  Everything below won't execute until valid key is entered
--]]

-- CONFIGURATION (Edit these)
local PASTEBIN_RAW_URL = "https://pastebin.com/raw/2xJnzuqc" -- Replace with your actual URL
local LINKVERTISE_URL = "https://your-linkvertise-url.com" -- Replace with your actual URL
local KEY_SAVE_NAME = "KaliHubKey" -- Change if you want different save name

-- SERVICES
local LocalPlayer = game:GetService("Players").LocalPlayer
local TweenService = game:GetService("TweenService")

-- UTILITY FUNCTIONS
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    elseif clipboard then
        clipboard(text)
    else
        warn("Clipboard functionality not supported on this platform.")
    end
end

local function fetchKeyFromPastebin()
    local success, result
    pcall(function()
        if game:GetService("HttpService") then
            success, result = pcall(function()
                return game:GetService("HttpService"):GetAsync(PASTEBIN_RAW_URL)
            end)
        end
    end)
    if not success and syn and syn.request then
        success, result = pcall(function()
            local response = syn.request({
                Url = PASTEBIN_RAW_URL,
                Method = "GET"
            })
            return response.Body
        end)
    elseif not success and http and http.request then
        success, result = pcall(function()
            return http.request({
                Url = PASTEBIN_RAW_URL,
                Method = "GET"
            }).Body
        end)
    elseif not success and request then
        success, result = pcall(function()
            return request({
                Url = PASTEBIN_RAW_URL,
                Method = "GET"
            }).Body
        end)
    end
    if success and result then
        result = result:gsub("^%s*(.-)%s*$", "%1")
        print("Successfully fetched key")
        return result
    else
        warn("Failed to fetch key from server")
        return "KALI-1K6K92" -- Fallback key
    end
end

local function saveKey(key)
    if writefile then
        pcall(function()
            writefile(KEY_SAVE_NAME .. ".txt", key)
        end)
    end
    pcall(function()
        if syn and syn.cache then
            syn.cache.new(KEY_SAVE_NAME, key)
        end
    end)
    pcall(function()
        LocalPlayer:SetAttribute(KEY_SAVE_NAME, key)
    end)
end

local function loadSavedKey()
    local savedKey = nil
    if readfile then
        pcall(function()
            if isfile and isfile(KEY_SAVE_NAME .. ".txt") then
                savedKey = readfile(KEY_SAVE_NAME .. ".txt")
            end
        end)
    end
    if not savedKey then
        pcall(function()
            if syn and syn.cache then
                savedKey = syn.cache.get(KEY_SAVE_NAME)
            end
        end)
    end
    if not savedKey then
        pcall(function()
            savedKey = LocalPlayer:GetAttribute(KEY_SAVE_NAME)
        end)
    end
    return savedKey
end

-- KEY SYSTEM GUI
local function createKeySystemGui(callback)
    if LocalPlayer.PlayerGui:FindFirstChild("KeySystemGui") then
        LocalPlayer.PlayerGui.KeySystemGui:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystemGui"
    ScreenGui.Parent = LocalPlayer.PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 10
    blurEffect.Parent = game:GetService("Lighting")

    local darkenFrame = Instance.new("Frame")
    darkenFrame.Size = UDim2.new(1, 0, 1, 0)
    darkenFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    darkenFrame.BackgroundTransparency = 0.5
    darkenFrame.BorderSizePixel = 0
    darkenFrame.Parent = ScreenGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 340, 0, 260)
    Frame.Position = UDim2.new(0.5, -170, 0.5, -130)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = Frame

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    })
    TitleGradient.Rotation = 90
    TitleGradient.Parent = TitleBar

    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(1, 0, 0, 1)
    AccentLine.Position = UDim2.new(0, 0, 1, 0)
    AccentLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AccentLine.BorderSizePixel = 0
    AccentLine.Transparency = 0.7
    AccentLine.ZIndex = 2
    AccentLine.Parent = TitleBar

    local LogoIcon = Instance.new("ImageLabel")
    LogoIcon.Size = UDim2.new(0, 28, 0, 28)
    LogoIcon.Position = UDim2.new(0, 12, 0.5, -14)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Image = "rbxassetid://7733774602"
    LogoIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    LogoIcon.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.8, -50, 1, 0)
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Kali Hub Key System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -38, 0, 7.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar

    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0, 15)
    CloseButtonCorner.Parent = CloseButton

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(0.9, 0, 0, 180)
    ContentContainer.Position = UDim2.new(0.05, 0, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Frame

    local KeyInputContainer = Instance.new("Frame")
    KeyInputContainer.Size = UDim2.new(1, 0, 0, 40)
    KeyInputContainer.Position = UDim2.new(0, 0, 0, 20)
    KeyInputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KeyInputContainer.BorderSizePixel = 0
    KeyInputContainer.Parent = ContentContainer

    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.CornerRadius = UDim.new(0, 8)
    KeyInputCorner.Parent = KeyInputContainer

    local KeyIcon = Instance.new("ImageLabel")
    KeyIcon.Size = UDim2.new(0, 20, 0, 20)
    KeyIcon.Position = UDim2.new(0, 12, 0.5, -10)
    KeyIcon.BackgroundTransparency = 1
    KeyIcon.Image = "rbxassetid://7743878358"
    KeyIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    KeyIcon.Parent = KeyInputContainer

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -44, 1, -10)
    KeyInput.Position = UDim2.new(0, 40, 0, 5)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter Key Here"
    KeyInput.TextColor3 = Color3.fromRGB(220, 220, 220)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    KeyInput.TextSize = 16
    KeyInput.Font = Enum.Font.GothamSemibold
    KeyInput.TextXAlignment = Enum.TextXAlignment.Left
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyInputContainer

    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 40)
    ButtonContainer.Position = UDim2.new(0, 0, 0, 80)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = ContentContainer

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0.48, 0, 0, 40)
    SubmitButton.Position = UDim2.new(0, 0, 0, 0)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SubmitButton.Text = "Submit"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 16
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Parent = ButtonContainer

    local SubmitButtonCorner = Instance.new("UICorner")
    SubmitButtonCorner.CornerRadius = UDim.new(0, 8)
    SubmitButtonCorner.Parent = SubmitButton

    local SubmitGradient = Instance.new("UIGradient")
    SubmitGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    })
    SubmitGradient.Rotation = 90
    SubmitGradient.Parent = SubmitButton

    local CopyButton = Instance.new("TextButton")
    CopyButton.Size = UDim2.new(0.48, 0, 0, 40)
    CopyButton.Position = UDim2.new(0.52, 0, 0, 0)
    CopyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CopyButton.Text = "Copy Link"
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.TextSize = 16
    CopyButton.Font = Enum.Font.GothamBold
    CopyButton.Parent = ButtonContainer

    local CopyButtonCorner = Instance.new("UICorner")
    CopyButtonCorner.CornerRadius = UDim.new(0, 8)
    CopyButtonCorner.Parent = CopyButton

    local CopyGradient = Instance.new("UIGradient")
    CopyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    })
    CopyGradient.Rotation = 90
    CopyGradient.Parent = CopyButton

    local SaveKeyContainer = Instance.new("Frame")
    SaveKeyContainer.Size = UDim2.new(1, 0, 0, 30)
    SaveKeyContainer.Position = UDim2.new(0, 0, 0, 140)
    SaveKeyContainer.BackgroundTransparency = 1
    SaveKeyContainer.Parent = ContentContainer

    local SaveKeyCheckbox = Instance.new("Frame")
    SaveKeyCheckbox.Size = UDim2.new(0, 20, 0, 20)
    SaveKeyCheckbox.Position = UDim2.new(0, 0, 0.5, -10)
    SaveKeyCheckbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SaveKeyCheckbox.BorderSizePixel = 0
    SaveKeyCheckbox.Parent = SaveKeyContainer

    local SaveKeyCorner = Instance.new("UICorner")
    SaveKeyCorner.CornerRadius = UDim.new(0, 4)
    SaveKeyCorner.Parent = SaveKeyCheckbox

    local SaveKeyCheck = Instance.new("ImageLabel")
    SaveKeyCheck.Size = UDim2.new(0, 16, 0, 16)
    SaveKeyCheck.Position = UDim2.new(0.5, -8, 0.5, -8)
    SaveKeyCheck.BackgroundTransparency = 1
    SaveKeyCheck.Image = "rbxassetid://7072706620"
    SaveKeyCheck.ImageColor3 = Color3.fromRGB(255, 255, 255)
    SaveKeyCheck.Visible = true
    SaveKeyCheck.Parent = SaveKeyCheckbox

    local SaveKeyLabel = Instance.new("TextLabel")
    SaveKeyLabel.Size = UDim2.new(1, -30, 1, 0)
    SaveKeyLabel.Position = UDim2.new(0, 30, 0, 0)
    SaveKeyLabel.BackgroundTransparency = 1
    SaveKeyLabel.Text = "Save key for future sessions"
    SaveKeyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SaveKeyLabel.TextSize = 14
    SaveKeyLabel.Font = Enum.Font.Gotham
    SaveKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    SaveKeyLabel.Parent = SaveKeyContainer

    local SaveKeyButton = Instance.new("TextButton")
    SaveKeyButton.Size = UDim2.new(1, 0, 1, 0)
    SaveKeyButton.BackgroundTransparency = 1
    SaveKeyButton.Text = ""
    SaveKeyButton.Parent = SaveKeyContainer

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 1, -30)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Enter your key to access Kali Hub"
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = Frame

    local LoadingContainer = Instance.new("Frame")
    LoadingContainer.Size = UDim2.new(1, 0, 1, 0)
    LoadingContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LoadingContainer.BackgroundTransparency = 0.2
    LoadingContainer.Visible = false
    LoadingContainer.Parent = Frame

    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 12)
    LoadingCorner.Parent = LoadingContainer

    local LoadingSpinner = Instance.new("ImageLabel")
    LoadingSpinner.Size = UDim2.new(0, 50, 0, 50)
    LoadingSpinner.Position = UDim2.new(0.5, -25, 0.5, -25)
    LoadingSpinner.BackgroundTransparency = 1
    LoadingSpinner.Image = "rbxassetid://4965945816"
    LoadingSpinner.ImageColor3 = Color3.fromRGB(255, 255, 255)
    LoadingSpinner.Parent = LoadingContainer

    spawn(function()
        while LoadingContainer.Parent do
            LoadingSpinner.Rotation = (LoadingSpinner.Rotation + 2) % 360
            wait()
        end
    end)

    local saveKeyEnabled = true
    local isLoading = false
    local validKey = nil

    local function setLoading(loading)
        isLoading = loading
        LoadingContainer.Visible = loading
        SubmitButton.Visible = not loading
        CopyButton.Visible = not loading
    end

    local function updateStatus(message, color)
        StatusLabel.Text = message
        StatusLabel.TextColor3 = color or Color3.fromRGB(180, 180, 180)
    end

    local function checkKey()
        local enteredKey = KeyInput.Text
        if enteredKey == "" then
            updateStatus("Please enter a key", Color3.fromRGB(255, 100, 100))
            return
        end
        setLoading(true)
        
        if not validKey then
            validKey = fetchKeyFromPastebin()
        end
        
        task.wait(0.8) -- Simulate verification delay
        
        if enteredKey == validKey then
            updateStatus("Key Accepted! Loading script...", Color3.fromRGB(200, 200, 200))
            if saveKeyEnabled then
                saveKey(enteredKey)
            end
            callback()
            ScreenGui:Destroy()
            blurEffect:Destroy()
        else
            setLoading(false)
            updateStatus("Invalid Key!", Color3.fromRGB(255, 100, 100))
        end
    end

    -- Auto-submit if saved key exists
    local savedKey = loadSavedKey()
    if savedKey then
        KeyInput.Text = savedKey
        task.spawn(checkKey)
    end

    -- Set up button handlers
    SubmitButton.MouseButton1Click:Connect(checkKey)
    CopyButton.MouseButton1Click:Connect(function()
        copyToClipboard(LINKVERTISE_URL)
        updateStatus("Link copied to clipboard!", Color3.fromRGB(200, 200, 200))
    end)

    return ScreenGui
end

-- EXECUTION BLOCKER
do
    local keyVerified = false
    local keyGui = createKeySystemGui(function()
        keyVerified = true
    end)
    
    -- Freeze execution here until key is verified
    while not keyVerified do
        task.wait()
    end
    
    keyGui:Destroy()
end

print("Key verified! Executing main script...")

-- Services
local ReplicatedFolder
local HitboxFolder
local GameState
local ReEvent
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local plrs = game:GetService("Players")
local plr = plrs.LocalPlayer
local mouse = plr:GetMouse()
local workspace = game:GetService("Workspace")
local repstorage = game:GetService("ReplicatedStorage")
local ts = game:GetService("TweenService")
local uis = game:GetService("UserInputService")
local runservice = game:GetService("RunService")
getgenv().SecureMode = true

local localPlayerName = game:GetService("Players").LocalPlayer.Name

-- ==================== QB AIMBOT TRAINER VARIABLES ====================
local lastThrowDebug = nil
local currentArcYDebugConn = nil
local playerTrack = {}
local receiverHistory = {}
local receiverHistoryLength = 5 
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

local function formatVec3(v)
    return string.format("(%.2f, %.2f, %.2f)", (v and v.X) or 0, (v and v.Y) or 0, (v and v.Z) or 0)
end

local function safeComp(v, comp)
    return (v and v[comp]) or 0
end

local MAX_POWER = 120
local MIN_POWER = 50
local MAX_SPEED = 120
local MIN_SPEED = 40
local GRAVITY = workspace.Gravity or 196.2
local FIELD_Y = 3 
-- ==================== COMBINED VARIABLES ====================
local pullVectorEnabled = false
local smoothPullEnabled = false
local isPullingBall = false
local isSmoothPulling = false
local flyEnabled = false
local isFlying = false
local walkSpeedEnabled = false
local teleportForwardEnabled = false
local kickingAimbotEnabled = false
local landingIndicatorEnabled = false
local jumpPowerEnabled = false
local bigheadEnabled = false
local clickTackleEnabled = false
local isClickTackling = false
local teleportMagsEnabled = false
local tackleReachEnabled = false
local HighUncinfiniteStaminaEnabled = false
local staminaDepletionEnabled = false
local autoKickEnabled = false
local spinRightEnabled = false
local spinLeftEnabled = false
local infiniteStaminaEnabled = false
local isSprinting = false
local OldStam = 100

local offsetDistance = 4
local magnetSmoothness = 0.01
local updateInterval = 0.01
local customWalkSpeed = 50
local flySpeed = 50
local customJumpPower = 50
local bigheadSize = 1
local teleportMagsDistance = 2
local tackleReachDistance = 1
local staminaDepletionRate = 0
local vectorMagSpeed = 0.5

local flyBodyVelocity = nil
local flyBodyGyro = nil
local throwingArcPath = nil
local landingMarker = nil
local markerConnection = nil
local rainbowConnection = nil
local jumpConnection = nil
local bigheadConnection = nil
local clickTackleConnection = nil
local clickTackleHoldConnection = nil
local teleportMagsConnection = nil
local tackleReachConnection = nil
local autoKickConnection = nil
local spinRightConnection = nil
local spinLeftConnection = nil
local isParkMatch = Workspace:FindFirstChild("ParkMatchMap") ~= nil

-- ==================== QB AIMBOT TRAINER FUNCTIONS ====================
local function createText()
    local text = Drawing.new("Text")
    text.Size = 18
    text.Outline = true
    text.Center = true
    text.Visible = false
    return text
end

local playerText = {}

local function rainbowColor(frequency)
    local r = math.floor(math.sin(frequency + 0) * 127 + 128)
    local g = math.floor(math.sin(frequency + 2) * 127 + 128)
    local b = math.floor(math.sin(frequency + 4) * 127 + 128)
    return Color3.fromRGB(r, g, b)
end

local function updateTexts()
    local time = tick()
    for player, text in pairs(playerText) do
        text.Visible = false
    end
    local selected = _G.SelectedAimbotPlayer
    if selected and selected ~= LocalPlayer and selected.Character and selected.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = selected.Character.HumanoidRootPart
        local head = selected.Character:FindFirstChild("Head")
        if head then
            local screenPos, onScreen = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2, 0))
            if onScreen then
                local distance = (LocalPlayer.Character.HumanoidRootPart.Position - rootPart.Position).magnitude
                local text = playerText[selected]
                if not text then
                    text = createText()
                    playerText[selected] = text
                end
                text.Position = Vector2.new(screenPos.X, screenPos.Y)
                text.Text = selected.Name .. " | " .. math.floor(distance) .. " studs"
                text.Color = rainbowColor(time + selected.UserId)
                text.Visible = true
            end
        end
    end
end

local function resetAimbotCalculations()
    lastThrowDebug = nil
    if currentArcYDebugConn then currentArcYDebugConn:Disconnect() currentArcYDebugConn = nil end
    if playerTrack then
        for k in pairs(playerTrack) do playerTrack[k] = nil end
    end
    if receiverHistory then
        for k in pairs(receiverHistory) do receiverHistory[k] = nil end
    end
end

local function monitorBall()
    local lastBall = nil
    game:GetService("RunService").Heartbeat:Connect(function()
        local ball = workspace[localPlayerName] and workspace[localPlayerName]:FindFirstChild("Football")
        if ball ~= lastBall then
            resetAimbotCalculations()
            lastBall = ball
        end
    end)
end

local function getNearestPlayer()
    local camera = workspace.CurrentCamera
    local mouse = game:GetService("UserInputService"):GetMouseLocation()
    
    -- Convert 2D mouse position to a ray
    local ray = camera:ScreenPointToRay(mouse.X, mouse.Y)
    local rayOrigin = ray.Origin
    local rayDirection = ray.Direction
    
    local nearest, minAngle = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local playerPos = player.Character.HumanoidRootPart.Position
            
            -- Calculate direction to player
            local toPlayer = (playerPos - rayOrigin).Unit
            
            -- Calculate angle between ray direction and direction to player
            local angle = math.acos(math.clamp(rayDirection:Dot(toPlayer), -1, 1))
            
            -- Update nearest player if this angle is smaller
            if angle < minAngle then
                minAngle = angle
                nearest = player
            end
        end
    end
    return nearest
end

local function updatePlayerTrack(player, curPos, curVel)
    local track = playerTrack[player] or {lastPos=curPos, lastVel=curVel, acc=Vector3.new(), history={}}
    local acc = (curVel - track.lastVel)
    table.insert(track.history, 1, curVel)
    if #track.history > 5 then table.remove(track.history) end
    local avgVel = Vector3.new(0,0,0)
    for _,v in ipairs(track.history) do avgVel = avgVel + v end
    avgVel = avgVel / #track.history
    track.lastPos = curPos
    track.lastVel = curVel
    track.acc = acc
    track.avgVel = avgVel
    playerTrack[player] = track
    return track
end

local function updateReceiverHistory(pos)
    table.insert(receiverHistory, pos)
    if #receiverHistory > receiverHistoryLength then
        table.remove(receiverHistory, 1)
    end
end

local function getRouteTypeAndFake(history)
    if #history < 3 then return "unknown", false end
    local p1, p2, p3 = history[#history-2], history[#history-1], history[#history]
    local v1 = (p2 - p1).Unit
    local v2 = (p3 - p2).Unit
    local dot = v1:Dot(v2)
    local angle = math.acos(math.clamp(dot, -1, 1)) * (180 / math.pi)
    local isFake = angle > 45 
    local routeType
    if math.abs(v2.X) < 0.3 and math.abs(v2.Z) > 0.7 then
        routeType = "streak"
    elseif v2.X > 0.7 and v2.Z > 0.5 then
        routeType = "corner_right" 
    elseif v2.X < -0.7 and v2.Z > 0.5 then
        routeType = "corner_left" 
    elseif v2.X > 0.7 and math.abs(v2.Z) < 0.3 then
        routeType = "out_right" 
    elseif v2.X < -0.7 and math.abs(v2.Z) < 0.3 then
        routeType = "out_left" 
    elseif v2.X > 0.7 and v2.Z < -0.5 then
        routeType = "slant_right"
    elseif v2.X < -0.7 and v2.Z < -0.5 then
        routeType = "slant_left"
    elseif math.abs(v2.X) < 0.3 and v2.Z < -0.7 then
        routeType = "curl"
    elseif math.abs(v2.X) < 0.3 and math.abs(v2.Z) < 0.3 and v1:Dot(v2) < 0 then
        routeType = "comeback"
    end
    return routeType, isFake
end

local function getBallSpeed(power)
    return MIN_SPEED + ((power / 100) * (MAX_SPEED - MIN_SPEED))
end

local function getPowerForDistance(distance)
    local normalized = math.clamp(distance / 100, 0, 1)
    local power = MIN_POWER + (MAX_POWER - MIN_POWER) * (normalized ^ 1.25)
    return math.clamp(math.floor(power + 0.5), MIN_POWER, MAX_POWER)
end

local function predictTorsoPos(player, t)
    local char = player.Character
    if not char then return nil end
    local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    if not torso then return nil end
    local pos = torso.Position
    local vel = torso.Velocity
    return pos + vel * t
end

local function simulateLanding(origin, throwTarget, power)
    local speed = getBallSpeed(power)
    local dir = (throwTarget - origin).Unit
    local flatDist = Vector3.new(throwTarget.X - origin.X, 0, throwTarget.Z - origin.Z).Magnitude
    local dy = throwTarget.Y - origin.Y
    local bestT, landingPos, bestYdiff = nil, nil, math.huge
    local bestAngle = nil
    for angle = math.rad(5), math.rad(85), math.rad(0.25) do
        local vxz = speed * math.cos(angle)
        local vy = speed * math.sin(angle)
        local t = flatDist / vxz
        local y_at_t = origin.Y + vy * t - 0.5 * GRAVITY * t^2
        local ydiff = math.abs(y_at_t - throwTarget.Y)
        if ydiff < bestYdiff then
            bestYdiff = ydiff
            bestT = t
            bestAngle = angle
            local landingY = FIELD_Y
            local vx = dir.X * vxz
            local vz = dir.Z * vxz
            local x = origin.X + vx * t
            local z = origin.Z + vz * t
            landingPos = Vector3.new(x, landingY, z)
        end
    end
    return landingPos, bestT
end

local function solveThrowTarget(origin, landingPos, power)
    local g = GRAVITY
    local fixedAngleDeg = 45 
    local theta = math.rad(fixedAngleDeg)
    local dx = landingPos.X - origin.X
    local dz = landingPos.Z - origin.Z
    local dy = landingPos.Y - origin.Y
    local dxz = math.sqrt(dx * dx + dz * dz)
    local dirXZ = Vector3.new(dx, 0, dz).Unit
    local cosTheta = math.cos(theta)
    local sinTheta = math.sin(theta)
    local denom = dxz * math.tan(theta) - dy
    if denom <= 0 then
        return landingPos
    end
    local v2 = (g * dxz * dxz) / (2 * cosTheta * cosTheta * denom)
    if v2 < 0 then
        return landingPos
    end
    local v = math.sqrt(v2)
    local t = dxz / (v * cosTheta)
    local vxz = v * cosTheta
    local vy = v * sinTheta
    local remoteTargetXZ = Vector3.new(origin.X, 0, origin.Z) + dirXZ * vxz * t
    local remoteTargetY = origin.Y + vy * t - 0.5 * g * t * t
    local remoteTarget = Vector3.new(remoteTargetXZ.X, remoteTargetY, remoteTargetXZ.Z)
    return remoteTarget, v
end

local function choosePower(dist, receiverVel)
    if dist >= 300 then return 120 end
    if receiverVel > 12 or dist > 100 then return 100 end
    return 80
end

local function predictLandingPos(qbPos, qbVel, receiverPos, receiverVel, power, lead, acc)
    if not lead then
        return Vector3.new(receiverPos.X, FIELD_Y, receiverPos.Z), 0
    end
    local maxIter, epsilon = 7, 0.03
    local t = ((receiverPos - qbPos).Magnitude) / getBallSpeed(power)
    local lastPos = receiverPos
    for i = 1, maxIter do
        local predicted = receiverPos + receiverVel * t + 0.5 * acc * t * t
        local qbFuture = qbPos + qbVel * t
        local dist = (predicted - qbFuture).Magnitude
        local newT = dist / getBallSpeed(power)
        if math.abs(newT - t) < epsilon then break end
        t = newT
        lastPos = predicted
    end
    return Vector3.new(lastPos.X, FIELD_Y, lastPos.Z), t
end

local function debugArcYTableOnLand(power, dist, arcY, target, landPos)
    local FIELD_Y = FIELD_Y or 3
    local dxz = (Vector3.new(landPos.X, 0, landPos.Z) - Vector3.new(target.X, 0, target.Z)).Magnitude
    local dy = landPos.Y - FIELD_Y
    local status, advice = '', ''
    local catchRadius = 3.5
    local upperTorsoMinY, upperTorsoMaxY = FIELD_Y + 3, FIELD_Y + 6.5
    local lowerTorsoMinY, lowerTorsoMaxY = FIELD_Y + 1, FIELD_Y + 2.9
    local qbOrigin = Vector3.new(0, FIELD_Y, 0)
    local distToTarget = (Vector3.new(target.X, 0, target.Z) - qbOrigin).Magnitude
    local distToLand = (Vector3.new(landPos.X, 0, landPos.Z) - qbOrigin).Magnitude
    if dxz <= catchRadius then
        if landPos.Y >= upperTorsoMinY and landPos.Y <= upperTorsoMaxY then
            status = 'Caught'
            advice = 'Perfect!'
        elseif landPos.Y >= lowerTorsoMinY and landPos.Y < upperTorsoMinY then
            status = 'Lower torso hit'
            advice = 'Increase arcY for upper torso catch.'
        elseif landPos.Y < lowerTorsoMinY then
            status = 'Too low'
            advice = 'Increase arcY for upper torso catch.'
        elseif landPos.Y > upperTorsoMaxY and landPos.Y < FIELD_Y + 10 then
            status = 'Above head'
            advice = 'Slightly decrease arcY for upper torso catch.'
        elseif landPos.Y >= FIELD_Y + 10 then
            status = 'Way too high'
            advice = 'Decrease arcY for upper torso catch.'
        else
            status = 'Unusual height'
            advice = 'Check arcY value.'
        end
    elseif distToLand < distToTarget then
        status = 'Short'
        advice = 'Increase arcY for upper torso catch.'
    else
        status = 'Overshoot'
        advice = 'Decrease arcY for upper torso catch.'
    end
end

function unloadAimbot()
    if _G.AimbotConnections then
        for _, conn in ipairs(_G.AimbotConnections) do
            if conn and typeof(conn) == "Instance" and conn.Disconnect then
                conn:Disconnect()
            elseif type(conn) == "function" then
                pcall(conn)
            end
        end
        _G.AimbotConnections = nil
    end
    if type(disableESP) == "function" then
        disableESP()
    end
    if _G.AimbotUI and _G.AimbotUI.Destroy then
        _G.AimbotUI:Destroy()
    end
    _G.AimbotUI = nil
    if _G.AimbotHighlight and _G.AimbotHighlight.Destroy then
        _G.AimbotHighlight:Destroy()
    end
    _G.AimbotHighlight = nil
    _G.SelectedAimbotPlayer = nil
end

-- ==================== NFL UNIVERSE TRAINER FUNCTIONS ====================
-- Clipboard Function
local function copyToClipboard(text)
    if setclipboard then
        setclipboard(text)
    elseif clipboard then
        clipboard(text)
    else
        warn("Clipboard functionality not supported on this platform.")
    end
end

-- Fetch Key from Pastebin
local function fetchKeyFromPastebin()
    local success, result
    pcall(function()
        if game:GetService("HttpService") then
            success, result = pcall(function()
                return game:GetService("HttpService"):GetAsync(PASTEBIN_RAW_URL)
            end)
        end
    end)
    if not success and syn and syn.request then
        success, result = pcall(function()
            local response = syn.request({
                Url = PASTEBIN_RAW_URL,
                Method = "GET"
            })
            return response.Body
        end)
    elseif not success and http and http.request then
        success, result = pcall(function()
            return http.request({
                Url = PASTEBIN_RAW_URL,
                Method = "GET"
            }).Body
        end)
    elseif not success and request then
        success, result = pcall(function()
            return request({
                Url = PASTEBIN_RAW_URL,
                Method = "GET"
            }).Body
        end)
    end
    if success and result then
        result = result:gsub("^%s*(.-)%s*$", "%1")
        print("Successfully fetched key")
        return result
    else
        warn("Key fetched successfully.")
        return "KALI-1K6K92" -- Fallback key
    end
end

-- Save Key to Local Storage
local function saveKey(key)
    if writefile then
        pcall(function()
            writefile(KEY_SAVE_NAME .. ".txt", key)
        end)
    end
    pcall(function()
        if syn and syn.cache then
            syn.cache.new(KEY_SAVE_NAME, key)
        end
    end)
    pcall(function()
        LocalPlayer:SetAttribute(KEY_SAVE_NAME, key)
    end)
end

-- Load Saved Key
local function loadSavedKey()
    local savedKey = nil
    if readfile then
        pcall(function()
            if isfile and isfile(KEY_SAVE_NAME .. ".txt") then
                savedKey = readfile(KEY_SAVE_NAME .. ".txt")
            end
        end)
    end
    if not savedKey then
        pcall(function()
            if syn and syn.cache then
                savedKey = syn.cache.get(KEY_SAVE_NAME)
            end
        end)
    end
    if not savedKey then
        pcall(function()
            savedKey = LocalPlayer:GetAttribute(KEY_SAVE_NAME)
        end)
    end
    return savedKey
end

local GameMode = function()
    if game.PlaceId == 4822225642 or game.PlaceId == 13834702475 or game.PlaceId == 13415948659 then
        return "Park"
    else
        return "Normal"
    end
end

local MiniGame = function()
    if GameMode() == "Park" then
        pcall(function()
            return workspace.MiniGames:FindFirstChild(plr.Replicated.GameID.Value).Replicated
        end)
    end
end

if GameMode() == "Normal" then 
    ReplicatedFolder = workspace.Games:FindFirstChild(plr.Replicated.GameID.Value).Replicated 
    HitboxFolder = ReplicatedFolder:FindFirstChild("Hitboxes") 
    GameState = repstorage.Games:FindFirstChild(plr.Replicated.GameID.Value).ActiveState 
    ReEvent = repstorage.Games:FindFirstChild(plr.Replicated.GameID.Value).ReEvent 
end

local function getNearestPlayerToMouse()
    local mouse = plr:GetMouse()
    local rayOrigin = Workspace.CurrentCamera.CFrame.Position
    local rayDirection = (mouse.Hit.Position - rayOrigin).Unit * 1000
    local ray = Ray.new(rayOrigin, rayDirection)
    local hit, hitPosition = Workspace:FindPartOnRayWithIgnoreList(ray, {plr.Character})

    local nearestPlayer = nil
    local shortestDistance = math.huge

    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= plr and otherPlayer.Character then
            local targetRootPart = otherPlayer.Character:FindFirstChild("HumanoidRootPart")
            if targetRootPart then
                local distance = (hitPosition - targetRootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestPlayer = otherPlayer
                end
            end
        end
    end

    return nearestPlayer, shortestDistance
end

-- ==================== COMBINED INITIALIZATION ====================
-- Initialize character variables
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")
local head = character:WaitForChild("Head")
local defaultWalkSpeed = humanoid.WalkSpeed
local defaultJumpPower = humanoid.JumpPower
local defaultHeadSize = head.Size
local defaultHeadTransparency = head.Transparency

plr.CharacterAdded:Connect(function(char)
    character = char
    humanoidRootPart = char:WaitForChild("HumanoidRootPart")
    humanoid = char:WaitForChild("Humanoid")
    head = char:WaitForChild("Head")
    defaultWalkSpeed = humanoid.WalkSpeed
    defaultJumpPower = humanoid.JumpPower
    defaultHeadSize = head.Size
    defaultHeadTransparency = head.Transparency
end)

-- Initialize QB Aimbot Trainer
monitorBall()

local oldSelectPlayerFunc = nil
if selectNearestPlayer then
    oldSelectPlayerFunc = selectNearestPlayer
    selectNearestPlayer = function(...)
        resetAimbotCalculations()
        return oldSelectPlayerFunc(...)
    end
end

runService.RenderStepped:Connect(updateTexts)
-- ==================== COMBINED INPUT HANDLING ====================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- QB Aimbot Trainer inputs
    if input.KeyCode == Enum.KeyCode.H then
        resetAimbotCalculations()
        local nearest = getNearestPlayer()
        _G.SelectedAimbotPlayer = nearest
    elseif input.KeyCode == Enum.KeyCode.T then
        local selected = _G.SelectedAimbotPlayer
        if not selected then return end
        local ball = workspace[localPlayerName] and workspace[localPlayerName]:FindFirstChild("Football")
        if not ball then return end
        local origin = ball.Position
        local lastBallPos = ball and ball.Position
        local lastBallVel = ball and ball.Velocity
        local qbVel = (ball.Velocity or Vector3.new())
        local receiver = selected.Character.HumanoidRootPart
        local receiverPos = receiver.Position
        local receiverVel = receiver.Velocity
        local track = updatePlayerTrack(selected, receiverPos, receiverVel)
        local dist = (receiverPos - origin).Magnitude
        local power = choosePower(dist, (track.avgVel and track.avgVel.Magnitude) or 0)

        local arcYTable_stationary = {
            [120] = { {324, 230}, {335, 250}, {355, 320}, {360, 370}, {380, 420}, {317, 260} },
            [100] = { {40, 6}, {50, 9}, {60, 13}, {70, 17}, {80, 21}, {90, 23}, {100, 24}, {110, 28}, {120, 32}, {130, 36}, {140, 40}, {150, 44}, {160, 50}, {170, 55}, {178, 65}, {190, 75}, {200, 85}, {220, 95}, {233, 105}, {264, 140}, {274, 170}, {317, 200}, {332, 220}, {360, 270} },
            [80] = { {4, 2}, {13, 4}, {31, 6}, {33, 7}, {40, 8}, {50, 13}, {60, 15}, {68, 18}, {75, 20}, {80, 12}, {89, 13}, {100, 15}, {150, 38}, {170, 55}, {185, 70}, {200, 120}, {233, 140}, {264, 180}, {274, 210}, {317, 220}, {332, 250} }
        }
        local arcYTable_moving = {
            [120] = { {324, 250}, {335, 270}, {355, 340}, {360, 390} },
            [100] = {
                {40, 15}, {45, 15}, {50, 16}, {55, 17}, {60, 18}, {65, 18}, {70, 20}, {75, 21}, {80, 22}, {85, 23}, {90, 25}, {95, 27}, {100, 28}, {105, 30}, {110, 32}, {115, 34}, {120, 36}, {125, 39}, {130, 41}, {135, 44}, {140, 46}, {145, 49}, {150, 52}, {155, 55}, {160, 58}, {165, 61}, {170, 64}, {175, 68}, {180, 71}, {185, 75}, {190, 79}, {195, 82}, {200, 86}, {205, 90}, {210, 95}, {215, 99}, {220, 103}, {225, 108}, {230, 112}, {235, 117}, {240, 122}, {245, 127}, {250, 132}, {255, 137}, {260, 142}, {265, 148}, {270, 153}, {275, 159}, {280, 165}, {285, 171}, {290, 176}, {295, 183}, {300, 189}, {305, 195}, {310, 201}, {315, 208}, {320, 214}, {325, 221}, {330, 228}, {332, 231}, {335, 235}
            },
            [80] = { {4, 7}, {13, 7}, {31, 9}, {33, 10}, {40, 11}, {50, 13}, {54, 14}, {60, 16}, {80, 23}, {89, 26}, {100, 31}, {150, 61}, {170, 76}, {185, 88}, {200, 102} }
        }

        local function getArcYTable(isMoving)
            return isMoving and arcYTable_moving or arcYTable_stationary
        end

        local function getArcYFromTable(arcYTable, power, dist)
            local tbl = arcYTable[power]
            if not tbl then return FIELD_Y end
            if dist <= tbl[1][1] then return tbl[1][2] end
            if dist >= tbl[#tbl][1] then return tbl[#tbl][2] end
            for i = 2, #tbl do
                local d0, y0 = tbl[i-1][1], tbl[i-1][2]
                local d1, y1 = tbl[i][1], tbl[i][2]
                if dist == d1 then return y1 end
                if dist < d1 then
                    local t = (dist - d0) / (d1 - d0)
                    return y0 + t * (y1 - y0)
                end
            end
            return tbl[#tbl][2]
        end

        local velocityThreshold = 3.0
        local trackMag = (track.avgVel and track.avgVel.Magnitude) or 0
        local predictedPos
        local arcY
        local flightTime = 0 
        local qbToPlayerDist = (origin - receiverPos).Magnitude
        local power = power 
        if trackMag > velocityThreshold and qbToPlayerDist < 120 then
            power = 80
        end

        updateReceiverHistory(receiverPos)
        local routeType, isFake = getRouteTypeAndFake(receiverHistory)

        if trackMag > velocityThreshold then
            local leadMultiplier = 1
            if dist < 100 then
                leadMultiplier = 1.25 
            elseif dist > 150 then
                leadMultiplier = 1.15 
            end
            local predicted = receiverPos
            for i = 1, 3 do
                local _, t = simulateLanding(origin, predicted, power)
                local leadVec = track.avgVel * t + 0.5 * (track.acc or Vector3.new()) * t * t
                if isFake then
                    predicted = receiverPos + (track.avgVel.Unit * math.min(track.avgVel.Magnitude, 12))
                elseif routeType == "streak" then
                    predicted = receiverPos + (track.avgVel * t * 1.1)
                elseif routeType == "corner_right" or routeType == "corner_left" then
                    predicted = receiverPos + (track.avgVel * t * 1.08)
                elseif routeType == "slant_right" or routeType == "slant_left" then
                    predicted = receiverPos + (track.avgVel * t * 0.95)
                elseif routeType == "out_right" or routeType == "out_left" then
                    predicted = receiverPos + (track.avgVel * t * 0.85)
                elseif routeType == "curl" or routeType == "comeback" then
                    predicted = receiverPos 
                else
                    predicted = receiverPos + (track.avgVel * t)
                end
            end
            local moveDist = (Vector3.new(predicted.X, origin.Y, predicted.Z) - Vector3.new(origin.X, origin.Y, origin.Z)).Magnitude
            arcY = getArcYFromTable(arcYTable_moving, power, moveDist)
            if moveDist > 280 then
                arcY = arcY + 2
            elseif moveDist > 150 then
                arcY = arcY + 1.5
            end
            predictedPos = Vector3.new(predicted.X, arcY, predicted.Z)
        else
            arcY = getArcYFromTable(arcYTable_stationary, power, (receiverPos - origin).Magnitude)
            predictedPos = Vector3.new(receiverPos.X, arcY, receiverPos.Z)
        end
        local _, simTime = simulateLanding(origin, predictedPos, power)
        flightTime = simTime or 0
        local throwTarget = predictedPos

        local chosenModel = nil
        local useGames = false
        local wsMiniGames = workspace:FindFirstChild("MiniGames")
        if wsMiniGames and #wsMiniGames:GetChildren() > 0 then
            for _, obj in ipairs(wsMiniGames:GetChildren()) do
                if obj:IsA("Model") then
                    local replicated = obj:FindFirstChild("Replicated")
                    if replicated and replicated:IsA("Model") then
                        local spotTags = replicated:FindFirstChild("SpotTags")
                        if spotTags and spotTags:IsA("Folder") then
                            chosenModel = obj
                            break
                        end
                    end
                end
            end
            if chosenModel then
                game:GetService("ReplicatedStorage"):WaitForChild("MiniGames"):WaitForChild(chosenModel.Name):WaitForChild("ReEvent"):FireServer(unpack({
                    [1] = "Mechanics",
                    [2] = "ThrowBall",
                    [3] = {
                        ["Target"] = throwTarget,
                        ["AutoThrow"] = false,
                        ["Power"] = power
                    }
                }))
            else
                warn("No model in workspace.MiniGames with Replicated (Model) and SpotTags (Folder) found!")
            end
        else
            local wsGames = workspace:FindFirstChild("Games")
            if not wsGames or #wsGames:GetChildren() == 0 then
                warn("Neither workspace.MiniGames nor workspace.Games have usable models!")
            end
            for _, obj in ipairs(wsGames:GetChildren()) do
                if obj:IsA("Model") then
                    local replicated = obj:FindFirstChild("Replicated")
                    if replicated and replicated:IsA("Model") then
                        local ActiveSpots = replicated:FindFirstChild("ActiveSpots")
                        if ActiveSpots and ActiveSpots:IsA("Folder") then
                            chosenModel = obj
                            break
                        end
                    end
                end
            end
            if not chosenModel then
                warn("No model in workspace.Games with Replicated (Model) and ActiveSpots (Folder) found!")
            else
                game:GetService("ReplicatedStorage"):WaitForChild("Games"):WaitForChild(chosenModel.Name):WaitForChild("ReEvent"):FireServer(unpack({
                    [1] = "Mechanics",
                    [2] = "ThrowBall",
                    [3] = {
                        ["Target"] = throwTarget,
                        ["AutoThrow"] = false,
                        ["Power"] = power
                    }
                }))
            end
        end
    end
end)

local function getSprintingValue()
    local ReplicatedStorage = game:GetService("ReplicatedStorage")

    -- Check original 'Games' folder
    local gamesFolder = ReplicatedStorage:FindFirstChild("Games")
    if gamesFolder then
        for _, gameFolder in ipairs(gamesFolder:GetChildren()) do
            local mech = gameFolder:FindFirstChild("MechanicsUsed")
            if mech and mech:FindFirstChild("Sprinting") and mech.Sprinting:IsA("BoolValue") then
                return mech.Sprinting
            end
        end
    end

    -- Check dynamic UUID folders in 'MiniGames'
    local miniGamesFolder = ReplicatedStorage:FindFirstChild("MiniGames")
    if miniGamesFolder then
        for _, uuidFolder in ipairs(miniGamesFolder:GetChildren()) do
            if uuidFolder:IsA("Folder") then
                local mech = uuidFolder:FindFirstChild("MechanicsUsed")
                if mech and mech:FindFirstChild("Sprinting") and mech.Sprinting:IsA("BoolValue") then
                    return mech.Sprinting
                end
            end
        end
    end

    return nil -- fallback if nothing found
end

local function getHitboxFolder()
    local id = plr:FindFirstChild("Replicated") and plr.Replicated:FindFirstChild("GameID")
    if not id then return end
    local gid = id.Value
    local source = workspace:FindFirstChild("MiniGames") or workspace:FindFirstChild("Games")
    if not source then return end
    local gameFolder = source:FindFirstChild(gid)
    if not gameFolder then return end
    local replicated = gameFolder:FindFirstChild("Replicated")
    if not replicated then return end
    return replicated:FindFirstChild("Hitboxes")
end

local function getThrowingArcPath()
    local games = Workspace:FindFirstChild("Games")
    if games then
        for _, gameInstance in ipairs(games:GetChildren()) do
            local replicated = gameInstance:FindFirstChild("Replicated")
            if replicated then
                local throwingArcPath = replicated:FindFirstChild("ThrowingArcPath")
                if throwingArcPath then
                    return throwingArcPath
                end
            end
        end
    end
    return nil
end

local function getFootball()
    if isParkMatch then
        local parkMatchFootball = Workspace:FindFirstChild("ParkMatchMap")
        if parkMatchFootball and parkMatchFootball:FindFirstChild("Replicated") then
            parkMatchFootball = parkMatchFootball.Replicated:FindFirstChild("Fields")
            if parkMatchFootball and parkMatchFootball:FindFirstChild("MatchField") then
                parkMatchFootball = parkMatchFootball.MatchField:FindFirstChild("Replicated")
                if parkMatchFootball then
                    local football = parkMatchFootball:FindFirstChild("Football")
                    if football and football:IsA("BasePart") then return football end
                end
            end
        end
    end
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer.Character then
            local ball = otherPlayer.Character:FindFirstChild("Football")
            if ball and ball:IsA("BasePart") then return ball end
        end
    end
    local gamesFolder = Workspace:FindFirstChild("Games")
    if gamesFolder then
        for _, gameInstance in ipairs(gamesFolder:GetChildren()) do
            local replicatedFolder = gameInstance:FindFirstChild("Replicated")
            if replicatedFolder then
                local kickoffFootball = replicatedFolder:FindFirstChild("918f5408-d86a-4fb8-a88c-5cab57410acf")
                if kickoffFootball and kickoffFootball:IsA("BasePart") then return kickoffFootball end
                for _, item in ipairs(replicatedFolder:GetChildren()) do
                    if item:IsA("BasePart") and item.Name == "Football" then return item end
                end
            end
        end
    end
    return nil
end

local function teleportToBall()
    local ball = getFootball()
    if ball and humanoidRootPart then
        local ballVelocity = ball.Velocity
        local ballPosition = ball.Position
        local direction = ballVelocity.Unit
        local targetPosition = ballPosition + (direction * 12) - Vector3.new(0, 1.5, 0) + Vector3.new(0, 5.197499752044678 / 6, 0)
        local lookDirection = (ballPosition - humanoidRootPart.Position).Unit
        humanoidRootPart.CFrame = CFrame.new(targetPosition, targetPosition + lookDirection)
    end
end

local function smoothTeleportToBall()
    local ball = getFootball()
    if ball and humanoidRootPart then
        local ballVelocity = ball.Velocity
        local ballSpeed = ballVelocity.Magnitude
        local offset = (ballSpeed > 0) and (ballVelocity.Unit * offsetDistance) or Vector3.new(0, 0, 0)
        local targetPosition = ball.Position + offset + Vector3.new(0, 3, 0)
        local lookDirection = (ball.Position - humanoidRootPart.Position).Unit
        humanoidRootPart.CFrame = humanoidRootPart.CFrame:Lerp(CFrame.new(targetPosition, targetPosition + lookDirection), magnetSmoothness)
    end
end

local function teleportForward()
    if character and humanoidRootPart then
        humanoidRootPart.CFrame = humanoidRootPart.CFrame + (humanoidRootPart.CFrame.LookVector * 3)
    end
end

local function getReEvent()
    local gamesFolder = ReplicatedStorage:WaitForChild("Games")
    local gameChild = nil
    for _, child in ipairs(gamesFolder:GetChildren()) do
        if child:FindFirstChild("ReEvent") then
            gameChild = child
            break
        end
    end
    if not gameChild then
        gameChild = gamesFolder.ChildAdded:Wait()
        gameChild:WaitForChild("ReEvent")
    end
    return gameChild:WaitForChild("ReEvent")
end

local function onKick()
    local ReEvent = getReEvent()
    local angleArgs = { [1] = "Mechanics", [2] = "KickAngleChanged", [3] = 1, [4] = 60, [5] = 1 }
    ReEvent:FireServer(unpack(angleArgs))
    local powerArgs = { [1] = "Mechanics", [2] = "KickPowerSet", [3] = 1 }
    ReEvent:FireServer(unpack(powerArgs))
    local hikeArgs = { [1] = "Mechanics", [2] = "KickHiked", [3] = 60, [4] = 1, [5] = 1 }
    ReEvent:FireServer(unpack(hikeArgs))
    local accuracyArgs = { [1] = "Mechanics", [2] = "KickAccuracySet", [3] = 60 }
    ReEvent:FireServer(unpack(accuracyArgs))
end

-- NFL Universe Trainer inputs
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
        (input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonR2) then
        if pullVectorEnabled then
            isPullingBall = true
            spawn(function()
                while isPullingBall do
                    teleportToBall()
                    wait(0.05)
                end
            end)
        end
        if smoothPullEnabled then
            isSmoothPulling = true
            spawn(function()
                while isSmoothPulling do
                    smoothTeleportToBall()
                    wait(updateInterval)
                end
            end)
        end
    elseif input.UserInputType == Enum.UserInputType.Keyboard then
        if teleportForwardEnabled and input.KeyCode == Enum.KeyCode.Z then
            teleportForward()
        end
        if input.KeyCode == Enum.KeyCode.L and kickingAimbotEnabled then
            onKick()
        end
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or
        (input.UserInputType == Enum.UserInputType.Gamepad1 and input.KeyCode == Enum.KeyCode.ButtonR2) then
        isPullingBall = false
        isSmoothPulling = false
    end
end)
-- ==================== MAIN SCRIPT EXECUTION ====================
-- Load the Fluent UI Library
local function runMainScript()
    local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
    local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
    local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

    local Window = Fluent:CreateWindow({
        Title = "Kali Hub | NFL Universe",
        SubTitle = "by @f3a2 | https://discord.gg/epNcR8Ce89 | Low Unc 🟡",
        TabWidth = 160,
        Size = UDim2.fromOffset(580, 460),
        Theme = "Dark",
        Acrylic = true,
        MinimizeKey = Enum.KeyCode.LeftControl
    })

    local Tabs = {
        Mags = Window:AddTab({ Title = "Mags", Icon = "magnet" }),
        Player = Window:AddTab({ Title = "Player", Icon = "user" }),
        Automatic = Window:AddTab({ Title = "Automatic", Icon = "play" }),
        QBAimbot = Window:AddTab({ Title = "QB Aimbot", Icon = "crosshair" }),
        Misc = Window:AddTab({ Title = "Misc", Icon = "star" }),
        Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
    }

    -- QB Aimbot Tab
    local QBAimbotSection = Tabs.QBAimbot:AddSection("QB Aimbot Controls")
    
    -- This is the correct way to add a paragraph with title and content
    QBAimbotSection:AddParagraph({
        Title = "QB Aimbot Instructions (On by Default)", 
        Content = "Press H to select the nearest receiver to mouse\nPress T to throw the ball with aimbot\nThe aimbot will automatically calculate trajectory and lead"
    })
    
    -- Pull Vector (Mags Tab)
    local PullVectorSection = Tabs.Mags:AddSection("Pull Vector")
    PullVectorSection:AddToggle("PullVector", {
        Title = "Pull Vector [M1]",
        Default = false,
        Callback = function(value)
            pullVectorEnabled = value
        end
    })
    PullVectorSection:AddSlider("OffsetDistance", {
        Title = "Offset Distance",
        Description = "Distance in front of the ball",
        Default = 15,
        Min = 0,
        Max = 30,
        Rounding = 0,
        Callback = function(value)
            offsetDistance = value
        end
    })

    -- Legit Pull Vector (Mags Tab)
    local LegitPullSection = Tabs.Mags:AddSection("Legit Pull Vector")
    LegitPullSection:AddToggle("SmoothPull", {
        Title = "Legit Pull Vector [M1]",
        Default = false,
        Callback = function(value)
            smoothPullEnabled = value
        end
    })
    LegitPullSection:AddSlider("MagnetSmoothness", {
        Title = "Vector Smoothing",
        Description = "Lower = smoother, Higher = faster",
        Default = 0.20,
        Min = 0.01,
        Max = 1.0,
        Rounding = 2,
        Callback = function(value)
            magnetSmoothness = value
        end
    })

    -- Bighead Collision (Player Tab)
    local PlayerSection = Tabs.Player:AddSection("Bighead")
    PlayerSection:AddToggle("BigheadToggle", {
        Title = "Bighead Collision",
        Default = false,
        Callback = function(value)
            bigheadEnabled = value

            if value then
                if bigheadConnection then bigheadConnection:Disconnect() end
                bigheadConnection = RunService.RenderStepped:Connect(function()
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= plr then
                            local character = player.Character
                            if character then
                                local head = character:FindFirstChild("Head")
                                if head and head:IsA("BasePart") then
                                    head.Size = Vector3.new(bigheadSize, bigheadSize, bigheadSize)
                                    head.Transparency = 0.8
                                    head.CanCollide = true
                                end
                            end
                        end
                    end
                end)
            else
                if bigheadConnection then bigheadConnection:Disconnect() bigheadConnection = nil end
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= plr then
                        local character = player.Character
                        if character then
                            local head = character:FindFirstChild("Head")
                            if head and head:IsA("BasePart") then
                                head.Size = defaultHeadSize
                                head.Transparency = defaultHeadTransparency
                                head.CanCollide = false
                            end
                        end
                    end
                end
            end
        end
    })

    PlayerSection:AddSlider("BigheadSize", {
        Title = "Head Size",
        Description = "Size multiplier for head",
        Default = bigheadSize,
        Min = 1,
        Max = 10,
        Rounding = 1,
        Callback = function(value)
            bigheadSize = value
        end
    })

    -- Click Tackle (Player Tab)
    PlayerSection:AddToggle("ClickTackle", {
        Title = "Click Tackle",
        Default = false,
        Callback = function(value)
            clickTackleEnabled = value
        end
    })

    -- WalkSpeed (Player Tab)
    local WalkSpeedSection = Tabs.Player:AddSection("WalkSpeed")
    WalkSpeedSection:AddToggle("WalkSpeedToggle", {
        Title = "WalkSpeed",
        Description = "Increases your walking speed",
        Default = false,
        Callback = function(value)
            walkSpeedEnabled = value
            if value then
                spawn(function()
                    while walkSpeedEnabled and humanoid do
                        humanoid.WalkSpeed = customWalkSpeed
                        wait(0.1)
                    end
                    if humanoid and not walkSpeedEnabled then
                        humanoid.WalkSpeed = defaultWalkSpeed
                    end
                end)
            elseif humanoid then
                humanoid.WalkSpeed = defaultWalkSpeed
            end
        end
    })
    WalkSpeedSection:AddSlider("WalkSpeedValue", {
        Title = "Custom WalkSpeed",
        Default = 50,
        Min = 10,
        Max = 100,
        Rounding = 0,
        Callback = function(value)
            customWalkSpeed = value
        end
    })

    -- JumpPower (Player Tab)
    local JumpPowerSection = Tabs.Player:AddSection("JumpPower")
    JumpPowerSection:AddToggle("JumpPowerToggle", {
        Title = "JumpPower",
        Description = "Increases your jump height",
        Default = false,
        Callback = function(value)
            jumpPowerEnabled = value
            if value then
                if jumpConnection then jumpConnection:Disconnect() end
                jumpConnection = humanoid.Jumping:Connect(function()
                    if jumpPowerEnabled and humanoidRootPart then
                        local jumpVelocity = Vector3.new(0, customJumpPower, 0)
                        humanoidRootPart.Velocity = Vector3.new(humanoidRootPart.Velocity.X, 0, humanoidRootPart.Velocity.Z) + jumpVelocity
                    end
                end)
            else
                if jumpConnection then jumpConnection:Disconnect() end
                jumpConnection = nil
            end
        end
    })
    JumpPowerSection:AddSlider("JumpPowerValue", {
        Title = "Custom JumpPower",
        Default = 50,
        Min = 10,
        Max = 200,
        Rounding = 0,
        Callback = function(value)
            customJumpPower = value
        end
    })

    -- Fly (Player Tab)
    local FlySection = Tabs.Player:AddSection("Fly")
    FlySection:AddToggle("FlyToggle", {
        Title = "Fly",
        Description = "Allows your character to fly",
        Default = false,
        Callback = function(value)
            flyEnabled = value
            if value then
                if not flyBodyVelocity then
                    flyBodyVelocity = Instance.new("BodyVelocity")
                    flyBodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
                    flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    flyBodyVelocity.Parent = humanoidRootPart
                    flyBodyGyro = Instance.new("BodyGyro")
                    flyBodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
                    flyBodyGyro.P = 1000
                    flyBodyGyro.D = 100
                    flyBodyGyro.Parent = humanoidRootPart
                    isFlying = true
                    spawn(function()
                        while isFlying do
                            local camera = Workspace.CurrentCamera
                            local moveDirection = Vector3.new(0, 0, 0)
                            if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDirection = moveDirection + camera.CFrame.LookVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDirection = moveDirection - camera.CFrame.LookVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDirection = moveDirection - camera.CFrame.RightVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDirection = moveDirection + camera.CFrame.RightVector end
                            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDirection = moveDirection + Vector3.new(0, 1, 0) end
                            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDirection = moveDirection - Vector3.new(0, 1, 0) end
                            if moveDirection.Magnitude > 0 then
                                flyBodyVelocity.Velocity = moveDirection.Unit * flySpeed
                            else
                                flyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                            end
                            wait()
                        end
                    end)
                end
            else
                if flyBodyVelocity then flyBodyVelocity:Destroy() flyBodyVelocity = nil end
                if flyBodyGyro then flyBodyGyro:Destroy() flyBodyGyro = nil end
                isFlying = false
            end
        end
    })
    FlySection:AddSlider("FlySpeed", {
        Title = "Fly Speed",
        Default = 50,
        Min = 10,
        Max = 200,
        Rounding = 0,
        Callback = function(value)
            flySpeed = value
        end
    })

    -- Teleport (Player Tab)
    local TeleportSection = Tabs.Player:AddSection("Teleport")
    TeleportSection:AddToggle("TeleportForward", {
        Title = "Teleport Forward (Press Z)",
        Description = "Teleports you forward 3 studs",
        Default = false,
        Callback = function(value)
            teleportForwardEnabled = value
        end
    })

    -- Stamina (Player Tab)
    local StaminaSection = Tabs.Player:AddSection("Stamina")
    StaminaSection:AddToggle("InfiniteStaminaToggle", {
        Title = "(Low Unc) Infinite Stamina",
        Default = false,
        Callback = function(value)
            infiniteStaminaEnabled = value
        end
    })

    -- Kicking (Automatic Tab)
    local KickSection = Tabs.Automatic:AddSection("Kicking")
    KickSection:AddToggle("Kick Aimbot", {
        Title = "Kick Aimbot (Press L)",
        Description = "Can make up to 60 yard field goals",
        Default = false,
        Callback = function(value)
            kickingAimbotEnabled = value
        end
    })

    -- Initialize sprinting toggle
    local sprintingValue = getSprintingValue()
    if sprintingValue then
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if gameProcessed then return end
            if input.KeyCode == Enum.KeyCode.Q then
                isSprinting = not isSprinting
                if isSprinting then
                    sprintingValue.Value = true
                    if infiniteStaminaEnabled then
                        wait(0.1)
                        sprintingValue.Value = false
                    end
                else
                    sprintingValue.Value = true
                    wait(0.1)
                    sprintingValue.Value = false
                end
            end
        end)
    end

    -- Save Manager and Interface Manager
    SaveManager:SetLibrary(Fluent)
    InterfaceManager:SetLibrary(Fluent)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({})
    InterfaceManager:SetFolder("NFLUniverse")
    SaveManager:SetFolder("NFLUniverse/KaliHub")

    InterfaceManager:BuildInterfaceSection(Tabs.Settings)
    SaveManager:BuildConfigSection(Tabs.Settings)

    Window:SelectTab(1)

    Fluent:Notify({
        Title = "Kali Hub | NFL Universe",
        Content = "Script loaded successfully!",
        Duration = 5
    })

    SaveManager:LoadAutoloadConfig()
end

-- Key System GUI
local function createKeySystemGui(callback)
    if LocalPlayer.PlayerGui:FindFirstChild("KeySystemGui") then
        LocalPlayer.PlayerGui.KeySystemGui:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "KeySystemGui"
    ScreenGui.Parent = LocalPlayer.PlayerGui
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local blurEffect = Instance.new("BlurEffect")
    blurEffect.Size = 10
    blurEffect.Parent = game:GetService("Lighting")

    local darkenFrame = Instance.new("Frame")
    darkenFrame.Size = UDim2.new(1, 0, 1, 0)
    darkenFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    darkenFrame.BackgroundTransparency = 0.5
    darkenFrame.BorderSizePixel = 0
    darkenFrame.Parent = ScreenGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 340, 0, 260)
    Frame.Position = UDim2.new(0.5, -170, 0.5, -130)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 18)
    Frame.BorderSizePixel = 0
    Frame.Active = true
    Frame.Draggable = true
    Frame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = Frame

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(22, 22, 22)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15))
    })
    UIGradient.Rotation = 45
    UIGradient.Parent = Frame

    local TitleBar = Instance.new("Frame")
    TitleBar.Size = UDim2.new(1, 0, 0, 45)
    TitleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = Frame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar

    local TitleGradient = Instance.new("UIGradient")
    TitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 30, 30)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 25))
    })
    TitleGradient.Rotation = 90
    TitleGradient.Parent = TitleBar

    local AccentLine = Instance.new("Frame")
    AccentLine.Size = UDim2.new(1, 0, 0, 1)
    AccentLine.Position = UDim2.new(0, 0, 1, 0)
    AccentLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    AccentLine.BorderSizePixel = 0
    AccentLine.Transparency = 0.7
    AccentLine.ZIndex = 2
    AccentLine.Parent = TitleBar

    local LogoIcon = Instance.new("ImageLabel")
    LogoIcon.Size = UDim2.new(0, 28, 0, 28)
    LogoIcon.Position = UDim2.new(0, 12, 0.5, -14)
    LogoIcon.BackgroundTransparency = 1
    LogoIcon.Image = "rbxassetid://7733774602"
    LogoIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    LogoIcon.Parent = TitleBar

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0.8, -50, 1, 0)
    Title.Position = UDim2.new(0, 50, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = "Kali Hub Key System"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 20
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -38, 0, 7.5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CloseButton.Text = "×"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 24
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar

    local CloseButtonCorner = Instance.new("UICorner")
    CloseButtonCorner.CornerRadius = UDim.new(0, 15)
    CloseButtonCorner.Parent = CloseButton

    local ContentContainer = Instance.new("Frame")
    ContentContainer.Size = UDim2.new(0.9, 0, 0, 180)
    ContentContainer.Position = UDim2.new(0.05, 0, 0, 55)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.Parent = Frame

    local KeyInputContainer = Instance.new("Frame")
    KeyInputContainer.Size = UDim2.new(1, 0, 0, 40)
    KeyInputContainer.Position = UDim2.new(0, 0, 0, 20)
    KeyInputContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    KeyInputContainer.BorderSizePixel = 0
    KeyInputContainer.Parent = ContentContainer

    local KeyInputCorner = Instance.new("UICorner")
    KeyInputCorner.CornerRadius = UDim.new(0, 8)
    KeyInputCorner.Parent = KeyInputContainer

    local KeyIcon = Instance.new("ImageLabel")
    KeyIcon.Size = UDim2.new(0, 20, 0, 20)
    KeyIcon.Position = UDim2.new(0, 12, 0.5, -10)
    KeyIcon.BackgroundTransparency = 1
    KeyIcon.Image = "rbxassetid://7743878358"
    KeyIcon.ImageColor3 = Color3.fromRGB(200, 200, 200)
    KeyIcon.Parent = KeyInputContainer

    local KeyInput = Instance.new("TextBox")
    KeyInput.Size = UDim2.new(1, -44, 1, -10)
    KeyInput.Position = UDim2.new(0, 40, 0, 5)
    KeyInput.BackgroundTransparency = 1
    KeyInput.Text = ""
    KeyInput.PlaceholderText = "Enter Key Here"
    KeyInput.TextColor3 = Color3.fromRGB(220, 220, 220)
    KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    KeyInput.TextSize = 16
    KeyInput.Font = Enum.Font.GothamSemibold
    KeyInput.TextXAlignment = Enum.TextXAlignment.Left
    KeyInput.ClearTextOnFocus = false
    KeyInput.Parent = KeyInputContainer

    local ButtonContainer = Instance.new("Frame")
    ButtonContainer.Size = UDim2.new(1, 0, 0, 40)
    ButtonContainer.Position = UDim2.new(0, 0, 0, 80)
    ButtonContainer.BackgroundTransparency = 1
    ButtonContainer.Parent = ContentContainer

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0.48, 0, 0, 40)
    SubmitButton.Position = UDim2.new(0, 0, 0, 0)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SubmitButton.Text = "Submit"
    SubmitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitButton.TextSize = 16
    SubmitButton.Font = Enum.Font.GothamBold
    SubmitButton.Parent = ButtonContainer

    local SubmitButtonCorner = Instance.new("UICorner")
    SubmitButtonCorner.CornerRadius = UDim.new(0, 8)
    SubmitButtonCorner.Parent = SubmitButton

    local SubmitGradient = Instance.new("UIGradient")
    SubmitGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    })
    SubmitGradient.Rotation = 90
    SubmitGradient.Parent = SubmitButton

    local CopyButton = Instance.new("TextButton")
    CopyButton.Size = UDim2.new(0.48, 0, 0, 40)
    CopyButton.Position = UDim2.new(0.52, 0, 0, 0)
    CopyButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    CopyButton.Text = "Copy Link"
    CopyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyButton.TextSize = 16
    CopyButton.Font = Enum.Font.GothamBold
    CopyButton.Parent = ButtonContainer

    local CopyButtonCorner = Instance.new("UICorner")
    CopyButtonCorner.CornerRadius = UDim.new(0, 8)
    CopyButtonCorner.Parent = CopyButton

    local CopyGradient = Instance.new("UIGradient")
    CopyGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(50, 50, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
    })
    CopyGradient.Rotation = 90
    CopyGradient.Parent = CopyButton

    local SaveKeyContainer = Instance.new("Frame")
    SaveKeyContainer.Size = UDim2.new(1, 0, 0, 30)
    SaveKeyContainer.Position = UDim2.new(0, 0, 0, 140)
    SaveKeyContainer.BackgroundTransparency = 1
    SaveKeyContainer.Parent = ContentContainer

    local SaveKeyCheckbox = Instance.new("Frame")
    SaveKeyCheckbox.Size = UDim2.new(0, 20, 0, 20)
    SaveKeyCheckbox.Position = UDim2.new(0, 0, 0.5, -10)
    SaveKeyCheckbox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    SaveKeyCheckbox.BorderSizePixel = 0
    SaveKeyCheckbox.Parent = SaveKeyContainer

    local SaveKeyCorner = Instance.new("UICorner")
    SaveKeyCorner.CornerRadius = UDim.new(0, 4)
    SaveKeyCorner.Parent = SaveKeyCheckbox

    local SaveKeyCheck = Instance.new("ImageLabel")
    SaveKeyCheck.Size = UDim2.new(0, 16, 0, 16)
    SaveKeyCheck.Position = UDim2.new(0.5, -8, 0.5, -8)
    SaveKeyCheck.BackgroundTransparency = 1
    SaveKeyCheck.Image = "rbxassetid://7072706620"
    SaveKeyCheck.ImageColor3 = Color3.fromRGB(255, 255, 255)
    SaveKeyCheck.Visible = true
    SaveKeyCheck.Parent = SaveKeyCheckbox

    local SaveKeyLabel = Instance.new("TextLabel")
    SaveKeyLabel.Size = UDim2.new(1, -30, 1, 0)
    SaveKeyLabel.Position = UDim2.new(0, 30, 0, 0)
    SaveKeyLabel.BackgroundTransparency = 1
    SaveKeyLabel.Text = "Save key for future sessions"
    SaveKeyLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    SaveKeyLabel.TextSize = 14
    SaveKeyLabel.Font = Enum.Font.Gotham
    SaveKeyLabel.TextXAlignment = Enum.TextXAlignment.Left
    SaveKeyLabel.Parent = SaveKeyContainer

    local SaveKeyButton = Instance.new("TextButton")
    SaveKeyButton.Size = UDim2.new(1, 0, 1, 0)
    SaveKeyButton.BackgroundTransparency = 1
    SaveKeyButton.Text = ""
    SaveKeyButton.Parent = SaveKeyContainer

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, 0, 0, 20)
    StatusLabel.Position = UDim2.new(0, 0, 1, -30)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = "Enter your key to access Kali Hub"
    StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
    StatusLabel.TextSize = 14
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.Parent = Frame

    local LoadingContainer = Instance.new("Frame")
    LoadingContainer.Size = UDim2.new(1, 0, 1, 0)
    LoadingContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    LoadingContainer.BackgroundTransparency = 0.2
    LoadingContainer.Visible = false
    LoadingContainer.Parent = Frame

    local LoadingCorner = Instance.new("UICorner")
    LoadingCorner.CornerRadius = UDim.new(0, 12)
    LoadingCorner.Parent = LoadingContainer

    local LoadingSpinner = Instance.new("ImageLabel")
    LoadingSpinner.Size = UDim2.new(0, 50, 0, 50)
    LoadingSpinner.Position = UDim2.new(0.5, -25, 0.5, -25)
    LoadingSpinner.BackgroundTransparency = 1
    LoadingSpinner.Image = "rbxassetid://4965945816"
    LoadingSpinner.ImageColor3 = Color3.fromRGB(255, 255, 255)
    LoadingSpinner.Parent = LoadingContainer

    spawn(function()
        while LoadingContainer.Parent do
            LoadingSpinner.Rotation = (LoadingSpinner.Rotation + 2) % 360
            wait()
        end
    end)

    local saveKeyEnabled = true
    local isLoading = false
    local validKey = nil

    local function setLoading(loading)
        isLoading = loading
        LoadingContainer.Visible = loading
        SubmitButton.Visible = not loading
        CopyButton.Visible = not loading
    end

    local function updateStatus(message, color)
        StatusLabel.Text = message
        StatusLabel.TextColor3 = color or Color3.fromRGB(180, 180, 180)
        TweenService:Create(StatusLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            TextSize = 14
        }):Play()
    end

    local function checkKey()
        local enteredKey = KeyInput.Text
        if enteredKey == "" then
            updateStatus("Please enter a key", Color3.fromRGB(255, 100, 100))
            return
        end
        setLoading(true)
        if not validKey then
            spawn(function()
                validKey = fetchKeyFromPastebin()
                if not validKey then
                    setLoading(false)
                    updateStatus("Failed to fetch key from server", Color3.fromRGB(255, 100, 100))
                    return
                end
                if enteredKey == validKey then
                    updateStatus("Key Accepted! Loading script...", Color3.fromRGB(200, 200, 200))
                    if saveKeyEnabled then
                        saveKey(enteredKey)
                    end
                    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                    TweenService:Create(darkenFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                    TweenService:Create(blurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = 0
                    }):Play()
                    wait(1)
                    ScreenGui:Destroy()
                    blurEffect:Destroy()
                    callback()
                else
                    setLoading(false)
                    updateStatus("Invalid Key!", Color3.fromRGB(255, 100, 100))
                    local originalPosition = Frame.Position
                    for i = 1, 5 do
                        Frame.Position = originalPosition + UDim2.new(0, math.random(-5, 5), 0, 0)
                        wait(0.05)
                    end
                    Frame.Position = originalPosition
                    spawn(function()
                        wait(2)
                        updateStatus("Enter your key to access Kali Hub", Color3.fromRGB(180, 180, 180))
                    end)
                end
            end)
        else
            spawn(function()
                wait(0.8)
                if enteredKey == validKey then
                    updateStatus("Key Accepted! Loading script...", Color3.fromRGB(200, 200, 200))
                    if saveKeyEnabled then
                        saveKey(enteredKey)
                    end
                    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                    TweenService:Create(darkenFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        BackgroundTransparency = 1
                    }):Play()
                    TweenService:Create(blurEffect, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = 0
                    }):Play()
                    wait(1)
                    ScreenGui:Destroy()
                    blurEffect:Destroy()
                    callback()
                else
                    setLoading(false)
                    updateStatus("Invalid Key!", Color3.fromRGB(255, 100, 100))
                    local originalPosition = Frame.Position
                    for i = 1, 5 do
                        Frame.Position = originalPosition + UDim2.new(0, math.random(-5, 5), 0, 0)
                        wait(0.05)
                    end
                    Frame.Position = originalPosition
                    spawn(function()
                        wait(2)
                        updateStatus("Enter your key to access Kali Hub", Color3.fromRGB(180, 180, 180))
                    end)
                end
            end)
        end
    end

    local savedKey = loadSavedKey()
    if savedKey then
        KeyInput.Text = savedKey
        spawn(function()
            wait(0.5)
            checkKey()
        end)
    end

    copyToClipboard(LINKVERTISE_URL)
    updateStatus("Link copied! Paste it to get the key.", Color3.fromRGB(200, 200, 200))
    spawn(function()
        wait(3)
        updateStatus("Enter your key to access Kali Hub", Color3.fromRGB(180, 180, 180))
    end)

    CopyButton.MouseButton1Click:Connect(function()
        copyToClipboard(LINKVERTISE_URL)
        updateStatus("Link copied to clipboard!", Color3.fromRGB(200, 200, 200))
        TweenService:Create(CopyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.47, 0, 0, 38)
        }):Play()
        wait(0.1)
        TweenService:Create(CopyButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0.48, 0, 0, 40)
        }):Play()
        spawn(function()
            wait(2)
            updateStatus("Enter your key to access Kali Hub", Color3.fromRGB(180, 180, 180))
        end)
    end)

    CloseButton.MouseButton1Click:Connect(function()
        TweenService:Create(Frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(darkenFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(blurEffect, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = 0
        }):Play()
        wait(0.3)
        ScreenGui:Destroy()
        blurEffect:Destroy()
    end)

    SubmitButton.MouseButton1Click:Connect(checkKey)
    KeyInput.FocusLost:Connect(function(enterPressed)
        if enterPressed and not isLoading then
            checkKey()
        end
    end)

    SaveKeyButton.MouseButton1Click:Connect(function()
        saveKeyEnabled = not saveKeyEnabled
        SaveKeyCheck.Visible = saveKeyEnabled
    end)

    local function addButtonHoverEffect(button, baseColor, hoverColor)
        button.MouseEnter:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = hoverColor
            }):Play()
        end)
        button.MouseLeave:Connect(function()
            TweenService:Create(button, TweenInfo.new(0.2), {
                BackgroundColor3 = baseColor
            }):Play()
        end)
    end

    addButtonHoverEffect(SubmitButton, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))
    addButtonHoverEffect(CopyButton, Color3.fromRGB(40, 40, 40), Color3.fromRGB(60, 60, 60))
    addButtonHoverEffect(CloseButton, Color3.fromRGB(40, 40, 40), Color3.fromRGB(70, 70, 70))

    KeyInput.Focused:Connect(function()
        TweenService:Create(KeyInputContainer, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        }):Play()
    end)

    KeyInput.FocusLost:Connect(function()
        TweenService:Create(KeyInputContainer, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        }):Play()
    end)

    Frame.BackgroundTransparency = 1
    darkenFrame.BackgroundTransparency = 1
    TweenService:Create(Frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0,
        Position = UDim2.new(0.5, -170, 0.5, -130)
    }):Play()
    TweenService:Create(darkenFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.5
    }):Play()

    ScreenGui.Enabled = true
    spawn(function()
        validKey = fetchKeyFromPastebin()
        if not validKey then
            updateStatus("Failed to fetch key from server. Try again later.", Color3.fromRGB(255, 100, 100))
        end
    end)

    return ScreenGui
end

-- Check for saved key and run main script or show key system
local savedKey = loadSavedKey()
if savedKey then
    local validKey = fetchKeyFromPastebin()
    if savedKey == validKey then
        runMainScript()
    else
        createKeySystemGui(runMainScript)
    end
else
    createKeySystemGui(runMainScript)
end
