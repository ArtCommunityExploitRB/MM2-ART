-- ArtMM2 Hub | Phone Version
-- Компактный GUI с плавающими кнопками, авто-аим + стрельба по нажатию 🎯

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("ArtMM2") then CoreGui.ArtMM2:Destroy() end

-- Глобальные настройки
local _G = {
    AutoFarm = false,
    ESP = false,
    Noclip = false,
    InfJump = false,
    FarmSpeed = 25,
    AutoRejoin = true,
    CollectedCoins = 0,
    NoclipFarm = false,
    AutoWin = false,
    TinyMode = false,
    RTXEnabled = false,
    AimKey = nil,
    AimTarget = nil,
    AutoFlingMurderer = false,
    AutoFlingAll = false,
    FlingPower = 100,
    ShowRoleOnRoundStart = false,
    AutoShoot = false,          -- управляется кнопкой Aim
    IsMobile = true            -- телефон
}

-- ==========================================
-- СИСТЕМА УВЕДОМЛЕНИЙ
-- ==========================================
local function Notify(title, text, duration)
    duration = duration or 3
    local NotifFrame = Instance.new("Frame")
    local Corner = Instance.new("UICorner")
    local Stroke = Instance.new("UIStroke")
    local TitleLabel = Instance.new("TextLabel")
    local ContentLabel = Instance.new("TextLabel")

    NotifFrame.Name = "Notification"
    NotifFrame.Parent = CoreGui:FindFirstChild("ArtMM2") or CoreGui
    NotifFrame.Size = UDim2.new(0, 250, 0, 70)
    NotifFrame.Position = UDim2.new(1, 20, 1, -100)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.ZIndex = 10

    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifFrame

    Stroke.Color = Color3.fromRGB(120, 81, 255)
    Stroke.Thickness = 2
    Stroke.Parent = NotifFrame

    TitleLabel.Size = UDim2.new(1, -20, 0, 30)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title:upper()
    TitleLabel.TextColor3 = Color3.fromRGB(120, 81, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 14
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 11
    TitleLabel.Parent = NotifFrame

    ContentLabel.Size = UDim2.new(1, -20, 0, 30)
    ContentLabel.Position = UDim2.new(0, 10, 0, 30)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = text
    ContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 13
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true
    ContentLabel.ZIndex = 11
    ContentLabel.Parent = NotifFrame

    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(1, -270, 1, -100)}):Play()

    task.delay(duration, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Position = UDim2.new(1, 20, 1, -100)}):Play()
        task.wait(0.5)
        NotifFrame:Destroy()
    end)
end

-- ==========================================
-- КОНФИГУРАЦИЯ ДЛЯ ТЕЛЕФОНА
-- ==========================================
local viewportX = workspace.CurrentCamera.ViewportSize.X
local viewportY = workspace.CurrentCamera.ViewportSize.Y
local UIConfig = {
    MainWidth = math.max(300, viewportX - 20),
    MainHeight = math.max(300, viewportY - 40),
    SidebarWidth = 100,
    ButtonHeight = 45,
    FontSize = 18,
    SliderHeight = 60,
    ScrollThickness = 6,
    TabBtnHeight = 45,
    StartMinimized = true,
    FloatingHub = true
}

local ArtMM2 = Instance.new("ScreenGui")
ArtMM2.Name = "ArtMM2"
ArtMM2.Parent = CoreGui
ArtMM2.ResetOnSpawn = false

-- Плавающие кнопки
-- Кнопка быстрого Aim (правый верхний угол)
local MobileAimButton = Instance.new("TextButton", ArtMM2)
MobileAimButton.Size = UDim2.new(0, 55, 0, 55)
MobileAimButton.Position = UDim2.new(1, -70, 0, 30)
MobileAimButton.BackgroundColor3 = Color3.fromRGB(120, 81, 255)
MobileAimButton.Text = "🎯"
MobileAimButton.TextSize = 24
MobileAimButton.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", MobileAimButton).CornerRadius = UDim.new(1, 0)
MobileAimButton.ZIndex = 5
MobileAimButton.Active = true
MobileAimButton.Draggable = true

-- Кнопка быстрого Farm (нижний правый угол)
local MobileFarmButton = Instance.new("TextButton", ArtMM2)
MobileFarmButton.Size = UDim2.new(0, 55, 0, 55)
MobileFarmButton.Position = UDim2.new(1, -70, 1, -100)
MobileFarmButton.BackgroundColor3 = Color3.fromRGB(60, 200, 120)
MobileFarmButton.Text = "🏃"
MobileFarmButton.TextSize = 24
MobileFarmButton.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", MobileFarmButton).CornerRadius = UDim.new(1, 0)
MobileFarmButton.ZIndex = 5
MobileFarmButton.Active = true
MobileFarmButton.Draggable = true

-- Главная кнопка Hub (нижний левый угол)
local HubButton = Instance.new("TextButton", ArtMM2)
HubButton.Size = UDim2.new(0, 50, 0, 50)
HubButton.Position = UDim2.new(0, 20, 1, -80)
HubButton.BackgroundColor3 = Color3.fromRGB(120, 81, 255)
HubButton.Text = "💠"
HubButton.TextSize = 20
HubButton.Font = Enum.Font.SourceSansBold
Instance.new("UICorner", HubButton).CornerRadius = UDim.new(1, 0)
HubButton.ZIndex = 5

local Main = Instance.new("Frame", ArtMM2)
Main.Name = "MainFrame"
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Position = UDim2.new(0, 10, 0, 10)
Main.Size = UDim2.new(0, UIConfig.MainWidth, 0, UIConfig.MainHeight)
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(120, 81, 255)
Main.Visible = false  -- скрыто, показывается по кнопке Hub

local TopBar = Instance.new("Frame", Main)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Size = UDim2.new(1, 0, 0, 40)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 10)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Text = "ARTMM2"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = UIConfig.FontSize + 4
TitleLabel.Position = UDim2.new(0, 15, 0, 0)
TitleLabel.Size = UDim2.new(0, 200, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 40, 0, 40)
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = UIConfig.FontSize + 6
CloseBtn.Font = Enum.Font.GothamBold

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 40, 0, 40)
MinBtn.Position = UDim2.new(1, -80, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = UIConfig.FontSize + 6
MinBtn.Font = Enum.Font.GothamBold

local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Sidebar.Position = UDim2.new(0, 10, 0, 50)
Sidebar.Size = UDim2.new(0, UIConfig.SidebarWidth, 1, -60)
Sidebar.ScrollBarThickness = UIConfig.ScrollThickness
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 8)
local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 5)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Container = Instance.new("Frame", Main)
Container.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Container.Position = UDim2.new(0, UIConfig.SidebarWidth + 20, 0, 50)
Container.Size = UDim2.new(1, -(UIConfig.SidebarWidth + 30), 1, -60)
Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 8)

local isHidden = false
MinBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    local targetSize = isHidden and UDim2.new(0, UIConfig.MainWidth, 0, 40) or UDim2.new(0, UIConfig.MainWidth, 0, UIConfig.MainHeight)
    TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    HubButton.Visible = true
end)

-- Перетаскивание окна
local dragToggle, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragToggle = true
        dragStart = input.Position
        startPos = Main.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragToggle and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragToggle = false end
end)

-- При нажатии на Hub-кнопку показываем/скрываем Main
HubButton.MouseButton1Click:Connect(function()
    Main.Visible = not Main.Visible
    if Main.Visible then
        HubButton.Visible = false
    else
        HubButton.Visible = true
    end
end)

-- Вкладки
local Tabs = {}
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.9, 0, 0, UIConfig.TabBtnHeight)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = UIConfig.FontSize
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, -10, 1, -10)
    Page.Position = UDim2.new(0, 5, 0, 5)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = UIConfig.ScrollThickness
    Page.BorderSizePixel = 0
    
    local layout = Instance.new("UIListLayout", Page)
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        for _, tab in pairs(Tabs) do
            tab.Page.Visible = false
            TweenService:Create(tab.Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 35), TextColor3 = Color3.fromRGB(180, 180, 180)}):Play()
        end
        Page.Visible = true
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120, 81, 255), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    table.insert(Tabs, {Page = Page, Btn = TabBtn})
    return Page
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, UIConfig.ButtonHeight)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamSemibold
    Btn.TextSize = UIConfig.FontSize
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    
    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(120, 81, 255)}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        Notify("Action", "Executed: " .. text, 2)
        pcall(callback)
    end)
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(1, 0, 0, UIConfig.ButtonHeight)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = UIConfig.FontSize
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Check = Instance.new("TextButton", ToggleFrame)
    Check.Size = UDim2.new(0, 25, 0, 25)
    Check.Position = UDim2.new(1, -35, 0.5, -12.5)
    Check.BackgroundColor3 = default and Color3.fromRGB(120, 81, 255) or Color3.fromRGB(20, 20, 25)
    Check.Text = ""
    Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 6)

    local state = default
    Check.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Check, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(120, 81, 255) or Color3.fromRGB(20, 20, 25)}):Play()
        Notify("Toggle", text .. " is now " .. (state and "Enabled" or "Disabled"), 2)
        pcall(callback, state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", parent)
    SliderFrame.Size = UDim2.new(1, 0, 0, UIConfig.SliderHeight)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 6)

    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(1, -20, 0, 25)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = UIConfig.FontSize
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Background = Instance.new("Frame", SliderFrame)
    Background.Size = UDim2.new(1, -20, 0, 6)
    Background.Position = UDim2.new(0, 10, 0, 30)
    Background.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    Instance.new("UICorner", Background).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", Background)
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(120, 81, 255)
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Btn = Instance.new("TextButton", Background)
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""

    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - Background.AbsolutePosition.X) / Background.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. tostring(value)
        pcall(callback, value)
    end

    local dragging = false
    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
    end)
end

-- ==========================================
-- ИНИЦИАЛИЗАЦИЯ ВКЛАДОК
-- ==========================================
local InfoTab = CreateTab("Info")
local PlayerTab = CreateTab("Player")
local FarmTab = CreateTab("Auto Farm")
local EspTab = CreateTab("ESP")
local WinTab = CreateTab("Fast Win")
local TargetTab = CreateTab("Target")
local FlingTab = CreateTab("Fling")
local TPTab = CreateTab("Teleport")

-- INFO TAB
local Avatar = Instance.new("ImageLabel", InfoTab)
Avatar.Size = UDim2.new(0, 70, 0, 70)
Avatar.Position = UDim2.new(0.5, -35, 0, 10)
Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Avatar.BackgroundTransparency = 1
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local InfoText = Instance.new("TextLabel", InfoTab)
InfoText.Size = UDim2.new(1, 0, 0, 130)
InfoText.Position = UDim2.new(0, 0, 0, 90)
InfoText.BackgroundTransparency = 1
InfoText.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = UIConfig.FontSize
InfoText.TextYAlignment = Enum.TextYAlignment.Top

task.spawn(function()
    while task.wait(1) do
        local ping = "N/A"
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        local role = "Innocent"
        if LocalPlayer.Backpack:FindFirstChild("Knife") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife")) then role = "Murderer"
        elseif LocalPlayer.Backpack:FindFirstChild("Gun") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")) then role = "Sheriff" end
        InfoText.Text = string.format("User: %s\nRole: %s\nPing: %s ms\nCoins: %s", LocalPlayer.Name, role, ping, _G.CollectedCoins)
    end
end)

-- Функция определения роли и уведомления
local lastRoleNotified = nil
local function CheckAndNotifyRole()
    if not _G.ShowRoleOnRoundStart then return end
    if not LocalPlayer.Character then return end
    if workspace:FindFirstChild("Lobby") then return end
    local role = nil
    if LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife") then
        role = "Murderer"
    elseif LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun") then
        role = "Sheriff"
    else
        role = "Innocent"
    end
    if role ~= lastRoleNotified then
        lastRoleNotified = role
        Notify("ROLE", "You are "..role.."!", 4)
    end
end

task.spawn(function()
    while task.wait(1) do
        pcall(CheckAndNotifyRole)
    end
end)

CreateToggle(InfoTab, "Show Role On Round Start", false, function(s)
    _G.ShowRoleOnRoundStart = s
    if s then
        lastRoleNotified = nil
        CheckAndNotifyRole()
    end
end)

-- PLAYER TAB
CreateSlider(PlayerTab, "WalkSpeed", 16, 150, 16, function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end end)
CreateSlider(PlayerTab, "JumpPower", 50, 200, 50, function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = v end end)
CreateToggle(PlayerTab, "Noclip", false, function(s) _G.Noclip = s end)
CreateToggle(PlayerTab, "Infinite Jump", false, function(s) _G.InfJump = s end)
CreateToggle(PlayerTab, "Tiny Mode", false, function(s)
    _G.TinyMode = s
    local char = LocalPlayer.Character
    if char then
        for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = s and 0.5 or 0 end end
        if char:FindFirstChild("Humanoid") then char.Humanoid.HipHeight = s and 1 or 2 end
        if char:FindFirstChild("Head") then char.Head.MeshId = s and "rbxassetid://0" or "" end
        char:ScaleTo(s and 0.5 or 1)
    end
end)

UserInputService.JumpRequest:Connect(function()
    if _G.InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    end
end)

RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, p in pairs(LocalPlayer.Character:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end
    end
end)

-- TARGET TAB & AUTO AIM + AUTO SHOOT (для мобильных через кнопку Aim)
local TargetListFrame = Instance.new("Frame", TargetTab)
TargetListFrame.Size = UDim2.new(1, 0, 0, 150)
TargetListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Instance.new("UICorner", TargetListFrame).CornerRadius = UDim.new(0, 6)

local TargetScrolling = Instance.new("ScrollingFrame", TargetListFrame)
TargetScrolling.Size = UDim2.new(1, -10, 1, -10)
TargetScrolling.Position = UDim2.new(0, 5, 0, 5)
TargetScrolling.BackgroundTransparency = 1
TargetScrolling.ScrollBarThickness = UIConfig.ScrollThickness
TargetScrolling.CanvasSize = UDim2.new(0,0,0,0)
TargetScrolling.BorderSizePixel = 0

local TargetLayout = Instance.new("UIListLayout", TargetScrolling)
TargetLayout.Padding = UDim.new(0, 4)
TargetLayout.SortOrder = Enum.SortOrder.LayoutOrder
TargetLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TargetScrolling.CanvasSize = UDim2.new(0,0,0,TargetLayout.AbsoluteContentSize.Y+5) end)

local SelectedTarget = nil

local function UpdateTargetList()
    for _, c in pairs(TargetScrolling:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1,0,0,30)
            btn.BackgroundColor3 = Color3.fromRGB(50,50,55)
            btn.Text = p.Name
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = UIConfig.FontSize
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,4)
            btn.Parent = TargetScrolling
            btn.MouseButton1Click:Connect(function()
                SelectedTarget = p
                for _, b in pairs(TargetScrolling:GetChildren()) do if b:IsA("TextButton") then TweenService:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50,50,55)}):Play() end end
                TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(120,81,255)}):Play()
                Notify("Target", "Selected: " .. p.Name, 2)
            end)
        end
    end
end

task.spawn(function() while task.wait(2) do pcall(UpdateTargetList) end end)

CreateButton(TargetTab, "🔄 Refresh", UpdateTargetList)
CreateButton(TargetTab, "👤 Teleport Behind", function()
    if SelectedTarget and SelectedTarget.Character and SelectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:PivotTo(SelectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3))
        Notify("Target", "Teleported behind "..SelectedTarget.Name, 2)
    else Notify("Error", "No target", 2) end
end)

-- Авто-аим (глобальный) – используется и кнопкой Aim
local autoAimMurderer = false
local autoAimSheriff = false
local autoAimConn
local function AutoAimLoop()
    if autoAimConn then autoAimConn:Disconnect() end
    if not (autoAimMurderer or autoAimSheriff) then return end
    autoAimConn = RunService.RenderStepped:Connect(function()
        local target = nil
        if autoAimMurderer then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then target = p break end
                end
            end
        end
        if not target and autoAimSheriff then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") then
                    if p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then target = p break end
                end
            end
        end
        if target and target.Character and target.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.lookAt(LocalPlayer.Character.Head.Position, target.Character.Head.Position)
            workspace.CurrentCamera.FieldOfView = 30  -- зум для мобильных
            -- Авто-стрельба
            if _G.AutoShoot and LocalPlayer.Character then
                local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                if gun then
                    local shootRemote = ReplicatedStorage:FindFirstChild("ShootGun") or ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("ShootGun")
                    if not shootRemote then
                        for _, v in pairs(ReplicatedStorage:GetDescendants()) do if v:IsA("RemoteEvent") and (v.Name=="ShootGun" or v.Name=="Gun") then shootRemote=v; break end end
                    end
                    if shootRemote then
                        shootRemote:FireServer(target.Character.Head.Position)
                    end
                end
            end
        else
            workspace.CurrentCamera.FieldOfView = 70
        end
    end)
end
CreateToggle(TargetTab, "Auto Aim Murderer", false, function(s) autoAimMurderer = s; AutoAimLoop() end)
CreateToggle(TargetTab, "Auto Aim Sheriff", false, function(s) autoAimSheriff = s; AutoAimLoop() end)
CreateToggle(TargetTab, "Auto Shoot (Gun)", false, function(s) _G.AutoShoot = s; if not s then workspace.CurrentCamera.FieldOfView = 70 end end)

-- Мобильные кнопки Aim и Farm
MobileAimButton.MouseButton1Click:Connect(function()
    local newState = not (autoAimMurderer or autoAimSheriff)
    autoAimMurderer = newState
    autoAimSheriff = newState
    _G.AutoShoot = newState
    AutoAimLoop()
    MobileAimButton.BackgroundColor3 = newState and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(120, 81, 255)
    Notify("Aim", newState and "Auto Aim + Shoot ON" or "OFF", 2)
end)

MobileFarmButton.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    MobileFarmButton.BackgroundColor3 = _G.AutoFarm and Color3.fromRGB(255, 200, 50) or Color3.fromRGB(60, 200, 120)
    if _G.AutoFarm then
        Notify("Farm", "Started", 2)
        if workspace:FindFirstChild("Lobby") then TeleportToMap() end
        if not FarmLoopRunning then
            FarmLoopRunning = true
            task.spawn(function()
                while _G.AutoFarm and FarmLoopRunning do
                    pcall(function()
                        if workspace:FindFirstChild("Lobby") and workspace:FindFirstChild("Normal") then TeleportToMap() end
                        FarmCoins()
                    end)
                    task.wait(0.15)
                end
                FarmLoopRunning = false
                TeleportToLobby()
            end)
        end
    else
        Notify("Farm", "Stopped", 2)
        FarmLoopRunning = false
        TeleportToLobby()
    end
end)

-- ==========================================
-- FLING TAB (компактный)
-- ==========================================
local FlingActive = false
local SelectedFlingTargets = {}
local FlingCheckboxes = {}
local OldPos, FPDH = nil, workspace.FallenPartsDestroyHeight

local function SkidFling(targetPlayer)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("Humanoid") then return end
    local humanoid = char.Humanoid
    local root = humanoid.RootPart
    local tChar = targetPlayer.Character
    if not tChar then return end
    local tHum = tChar:FindFirstChildOfClass("Humanoid")
    if not tHum or tHum.Health <= 0 then return end
    local tRoot = tHum.RootPart
    local tHead = tChar:FindFirstChild("Head")
    local accessory = tChar:FindFirstChildOfClass("Accessory")
    local handle = accessory and accessory:FindFirstChild("Handle")

    if tHum.Sit then return Notify("Fling", targetPlayer.Name.." is sitting", 2) end

    local targetPart = tRoot or tHead or handle
    if not targetPart then return end

    local targetNoclip = {}
    for _, part in pairs(tChar:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide == false then
            table.insert(targetNoclip, part)
            part.CanCollide = true
        end
    end

    workspace.CurrentCamera.CameraSubject = tHead or handle or tHum
    workspace.FallenPartsDestroyHeight = 0/0

    local bv = Instance.new("BodyVelocity")
    bv.Parent = root
    bv.Velocity = Vector3.zero
    bv.MaxForce = Vector3.new(9e9,9e9,9e9)

    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)

    local power = _G.FlingPower / 100
    local function FPos(basePart, pos, ang)
        root.CFrame = basePart.CFrame * pos * ang
        char:SetPrimaryPartCFrame(root.CFrame)
        root.Velocity = Vector3.new(9e7 * power, 9e7*10 * power, 9e7 * power)
        root.RotVelocity = Vector3.new(9e8 * power, 9e8 * power, 9e8 * power)
    end

    local start = tick()
    local angle = 0
    repeat
        if not FlingActive then break end
        if not tHum or tHum.Health <= 0 or not targetPart.Parent then break end
        if targetPart.Velocity.Magnitude < 50 then
            angle = angle + 100
            FPos(targetPart, CFrame.new(0,1.5,0) + tHum.MoveDirection * targetPart.Velocity.Magnitude/1.25, CFrame.Angles(math.rad(angle),0,0))
            task.wait()
            FPos(targetPart, CFrame.new(0,-1.5,0) + tHum.MoveDirection * targetPart.Velocity.Magnitude/1.25, CFrame.Angles(math.rad(angle),0,0))
            task.wait()
        else
            FPos(targetPart, CFrame.new(0,1.5, tHum.WalkSpeed * power), CFrame.Angles(math.rad(90),0,0))
            task.wait()
            FPos(targetPart, CFrame.new(0,-1.5,-tHum.WalkSpeed * power), CFrame.Angles(0,0,0))
            task.wait()
        end
    until tick() - start > 2

    bv:Destroy()
    humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
    workspace.CurrentCamera.CameraSubject = humanoid
    workspace.FallenPartsDestroyHeight = FPDH

    for _, part in pairs(targetNoclip) do
        part.CanCollide = false
    end

    if OldPos then
        repeat
            root.CFrame = OldPos * CFrame.new(0,0.5,0)
            char:SetPrimaryPartCFrame(OldPos * CFrame.new(0,0.5,0))
            humanoid:ChangeState("GettingUp")
            for _, p in pairs(char:GetChildren()) do if p:IsA("BasePart") then p.Velocity, p.RotVelocity = Vector3.new(), Vector3.new() end end
            task.wait()
        until (root.Position - OldPos.p).Magnitude < 25
    end
end

local FlingListFrame = Instance.new("Frame", FlingTab)
FlingListFrame.Size = UDim2.new(1, 0, 0, 150)
FlingListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
Instance.new("UICorner", FlingListFrame).CornerRadius = UDim.new(0, 6)

local FlingScroll = Instance.new("ScrollingFrame", FlingListFrame)
FlingScroll.Size = UDim2.new(1, -10, 1, -10)
FlingScroll.Position = UDim2.new(0, 5, 0, 5)
FlingScroll.BackgroundTransparency = 1
FlingScroll.ScrollBarThickness = UIConfig.ScrollThickness
FlingScroll.CanvasSize = UDim2.new(0,0,0,0)
FlingScroll.BorderSizePixel = 0

local FlingLayout = Instance.new("UIListLayout", FlingScroll)
FlingLayout.Padding = UDim.new(0, 4)
FlingLayout.SortOrder = Enum.SortOrder.LayoutOrder
FlingLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() FlingScroll.CanvasSize = UDim2.new(0,0,0,FlingLayout.AbsoluteContentSize.Y+5) end)

local function UpdateFlingList()
    for _, c in pairs(FlingScroll:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
    FlingCheckboxes = {}
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local entry = Instance.new("Frame")
            entry.Size = UDim2.new(1, 0, 0, 30)
            entry.BackgroundColor3 = Color3.fromRGB(50,50,55)
            Instance.new("UICorner", entry).CornerRadius = UDim.new(0,4)
            entry.Parent = FlingScroll

            local check = Instance.new("TextButton")
            check.Size = UDim2.new(0, 24, 0, 24)
            check.Position = UDim2.new(0, 3, 0.5, -12)
            check.BackgroundColor3 = Color3.fromRGB(70,70,70)
            check.Text = ""
            Instance.new("UICorner", check).CornerRadius = UDim.new(0,4)
            check.Parent = entry

            local mark = Instance.new("TextLabel")
            mark.Size = UDim2.new(1,0,1,0)
            mark.BackgroundTransparency = 1
            mark.Text = "✓"
            mark.TextColor3 = Color3.fromRGB(0,255,0)
            mark.TextSize = 18
            mark.Font = Enum.Font.SourceSansBold
            mark.Visible = false
            mark.Parent = check

            local nameLabel = Instance.new("TextLabel")
            nameLabel.Size = UDim2.new(1, -35, 1, 0)
            nameLabel.Position = UDim2.new(0, 30, 0, 0)
            nameLabel.BackgroundTransparency = 1
            nameLabel.Text = p.Name
            nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
            nameLabel.Font = Enum.Font.Gotham
            nameLabel.TextSize = UIConfig.FontSize
            nameLabel.TextXAlignment = Enum.TextXAlignment.Left
            nameLabel.Parent = entry

            local click = Instance.new("TextButton")
            click.Size = UDim2.new(1,0,1,0)
            click.BackgroundTransparency = 1
            click.Text = ""
            click.Parent = entry
            click.MouseButton1Click:Connect(function()
                if SelectedFlingTargets[p.Name] then
                    SelectedFlingTargets[p.Name] = nil
                    mark.Visible = false
                else
                    SelectedFlingTargets[p.Name] = p
                    mark.Visible = true
                end
            end)
            FlingCheckboxes[p.Name] = {Mark = mark}
            if SelectedFlingTargets[p.Name] then mark.Visible = true end
        end
    end
end

local function SelectAllFling(select)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local cb = FlingCheckboxes[p.Name]
            if cb then
                if select then SelectedFlingTargets[p.Name] = p; cb.Mark.Visible = true
                else SelectedFlingTargets[p.Name] = nil; cb.Mark.Visible = false end
            end
        end
    end
end

task.spawn(function() while task.wait(2) do pcall(UpdateFlingList) end end)

CreateButton(FlingTab, "🔄 Refresh", UpdateFlingList)
CreateButton(FlingTab, "✅ Select All", function() SelectAllFling(true) end)
CreateButton(FlingTab, "❌ Deselect All", function() SelectAllFling(false) end)
CreateButton(FlingTab, "▶ Start Fling", function()
    if FlingActive then return end
    if next(SelectedFlingTargets) == nil then Notify("Fling", "No targets selected", 2) return end
    FlingActive = true
    Notify("Fling", "Started", 2)
    OldPos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.CFrame
    task.spawn(function()
        while FlingActive do
            local targets = {}
            for _, p in pairs(SelectedFlingTargets) do if p and p.Parent then table.insert(targets, p) end end
            for _, p in ipairs(targets) do
                if not FlingActive then break end
                SkidFling(p)
                task.wait(0.1)
            end
            task.wait(0.5)
        end
    end)
end)
CreateButton(FlingTab, "⏹ Stop Fling", function() FlingActive = false; Notify("Fling", "Stopped", 2) end)

-- ==========================================
-- АВТОФАРМ + АВТОВИН + АВТОФЛИНГ
-- ==========================================
local RejoinConnection, FarmLoopRunning = false, nil

local function TeleportToLobby()
    local char = LocalPlayer.Character
    if not char then return end
    local lobbySpawn = workspace:FindFirstChild("Lobby") and workspace.Lobby:FindFirstChild("Spawns")
    if lobbySpawn then
        local parts = lobbySpawn:GetChildren()
        if #parts > 0 then char:PivotTo(parts[math.random(#parts)].CFrame + Vector3.new(0,3,0)); return true end
    end
    char:PivotTo(CFrame.new(-108.5, 145, 0.6))
    return true
end

local function TeleportToMap()
    local char = LocalPlayer.Character
    if not char then return end
    local mapFolder = workspace:FindFirstChild("Normal")
    local spawns = mapFolder and mapFolder:FindFirstChild("Spawns")
    if spawns then
        local pts = spawns:GetChildren()
        if #pts > 0 then char:PivotTo(pts[math.random(#pts)].CFrame + Vector3.new(0,3,0)); return true end
    end
    if mapFolder then char:PivotTo(CFrame.new(mapFolder:GetModelCFrame().Position + Vector3.new(0,5,0))); return true end
    return false
end

local function RejoinServer()
    if not _G.AutoFarm or not _G.AutoRejoin then return end
    Notify("Auto Farm", "Kicked detected! Rejoining...", 5)
    task.wait(2)
    pcall(function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
end

local function FlyToCoin(coin)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return false end
    local root = char.HumanoidRootPart
    local targetPos = coin.Position + Vector3.new(0,2,0)
    local distance = (root.Position - targetPos).Magnitude
    local flyTime = math.clamp(distance / (_G.FarmSpeed * 2), 0.5, 2.0)
    local oldNoclip = _G.Noclip
    if _G.NoclipFarm then _G.Noclip = true end
    local tween = TweenService:Create(root, TweenInfo.new(flyTime, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPos)})
    tween:Play()
    local start = tick()
    while tick() - start < flyTime + 0.5 do
        if not _G.AutoFarm or not coin or not coin.Parent then tween:Cancel(); break end
        if (root.Position - targetPos).Magnitude < 2 then break end
        task.wait()
    end
    if _G.NoclipFarm then _G.Noclip = oldNoclip end
    if coin and coin.Parent then
        root.CFrame = CFrame.new(coin.Position + Vector3.new(0,1,0))
        task.wait(0.1)
        if not coin.Parent then _G.CollectedCoins += 1 end
        return true
    end
    return false
end

local function FarmCoins()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart
    local coins = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name:find("Coin")) and obj.Transparency < 0.9 and obj.Parent then
            table.insert(coins, obj)
        end
    end
    if #coins == 0 then
        if _G.AutoFlingMurderer or _G.AutoFlingAll then TryAutoFling() end
        if _G.AutoWin then TryAutoWin() end
        return
    end
    table.sort(coins, function(a,b) return (root.Position - a.Position).Magnitude < (root.Position - b.Position).Magnitude end)
    FlyToCoin(coins[1])
end

function TryAutoWin()
    local role = nil
    if LocalPlayer.Backpack:FindFirstChild("Knife") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife")) then role = "Murderer"
    elseif LocalPlayer.Backpack:FindFirstChild("Gun") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")) then role = "Sheriff" end
    if not role then return end
    if role == "Murderer" then
        local knife = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
        if not knife then return end
        knife.Parent = LocalPlayer.Character
        task.wait(0.2)
        local myPos = LocalPlayer.Character.HumanoidRootPart.Position
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character:PivotTo(CFrame.new(myPos + Vector3.new(math.random(-2,2),0,math.random(-2,2))))
            end
        end
        for _=1,2 do knife:Activate(); task.wait(0.1) end
        Notify("Auto Win", "All eliminated!", 2)
    elseif role == "Sheriff" then
        local murderer = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then murderer = p; break end
        end
        if not murderer then return end
        local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
        if not gun then return end
        gun.Parent = LocalPlayer.Character
        task.wait(0.2)
        local murdRoot = murderer.Character.HumanoidRootPart
        LocalPlayer.Character:PivotTo(murdRoot.CFrame * CFrame.new(0,0,-3))
        task.wait(0.1)
        local shootRemote = ReplicatedStorage:FindFirstChild("ShootGun") or ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("ShootGun")
        if not shootRemote then
            for _, v in pairs(ReplicatedStorage:GetDescendants()) do if v:IsA("RemoteEvent") and (v.Name=="ShootGun" or v.Name=="Gun") then shootRemote=v; break end end
        end
        if shootRemote then
            for _=1,5 do
                workspace.CurrentCamera.CFrame = CFrame.lookAt(LocalPlayer.Character.Head.Position, murdRoot.Position)
                shootRemote:FireServer(murdRoot.Position)
                task.wait(0.2)
            end
            Notify("Auto Win", "Murderer shot!", 2)
        end
    end
    repeat task.wait(1) until not workspace:FindFirstChild("Normal") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and workspace:FindFirstChild("Lobby"))
    TeleportToLobby()
    task.wait(2)
    if _G.AutoFarm then TeleportToMap() end
end

function TryAutoFling()
    if _G.AutoFlingAll then
        local targets = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                table.insert(targets, p)
            end
        end
        if #targets > 0 then
            Notify("Auto Fling", "Flinging all "..#targets.." players!", 2)
            for _, p in ipairs(targets) do
                SkidFling(p)
                task.wait(0.3)
            end
        end
    elseif _G.AutoFlingMurderer then
        local murderer = nil
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then murderer = p; break end
        end
        if not murderer then return end
        Notify("Auto Fling", "Flinging murderer", 2)
        for _=1,5 do
            if not _G.AutoFarm then break end
            SkidFling(murderer)
            task.wait(0.3)
        end
    end
end

CreateToggle(FarmTab, "Auto Farm Coins", false, function(s) _G.AutoFarm = s; if s then if workspace:FindFirstChild("Lobby") then TeleportToMap() end; end end)
CreateToggle(FarmTab, "Auto Rejoin on Kick", true, function(s) _G.AutoRejoin = s end)
CreateToggle(FarmTab, "Noclip Farm", false, function(s) _G.NoclipFarm = s end)
CreateToggle(FarmTab, "Auto Win (after farm)", false, function(s) _G.AutoWin = s end)
CreateToggle(FarmTab, "Auto Fling Murderer", false, function(s) _G.AutoFlingMurderer = s end)
CreateToggle(FarmTab, "Auto Fling ALL (after farm)", false, function(s) _G.AutoFlingAll = s end)
CreateSlider(FarmTab, "Flight Speed", 10, 80, 25, function(v) _G.FarmSpeed = v end)
CreateSlider(FarmTab, "Fling Power", 50, 300, 100, function(v) _G.FlingPower = v end)

CreateButton(FarmTab, "🔄 Force Rejoin", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
CreateButton(FarmTab, "📍 Teleport to Map", TeleportToMap)
CreateButton(FarmTab, "🏠 Teleport to Lobby", TeleportToLobby)
CreateButton(FarmTab, "💰 Reset Coin Counter", function() _G.CollectedCoins = 0 end)

-- ESP TAB
CreateToggle(EspTab, "Enable Roles ESP", false, function(s)
    _G.ESP = s
    if not s then for _, p in pairs(Players:GetPlayers()) do if p.Character and p.Character:FindFirstChild("ArtESP") then p.Character.ArtESP:Destroy() end end end
end)
RunService.RenderStepped:Connect(function()
    if _G.ESP then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local hl = p.Character:FindFirstChild("ArtESP") or Instance.new("Highlight")
                hl.Name = "ArtESP"
                hl.Parent = p.Character
                hl.OutlineColor = Color3.new(1,1,1)
                hl.FillTransparency = 0.5
                hl.OutlineTransparency = 0
                if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then hl.FillColor = Color3.fromRGB(255,50,50)
                elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then hl.FillColor = Color3.fromRGB(50,150,255)
                else hl.FillColor = Color3.fromRGB(50,255,50) end
            end
        end
    end
end)

-- FAST WIN TAB
CreateButton(WinTab, "🎯 Sheriff: Shoot Murderer", function()
    local char = LocalPlayer.Character
    if not char then return end
    local gun = char:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
    if not gun then Notify("Error", "No gun!", 2) return end
    gun.Parent = char
    task.wait(0.1)
    local murderer = nil
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then murderer = p; break end
    end
    if not murderer then Notify("Error", "Murderer not found!", 2) return end
    local murdRoot = murderer.Character.HumanoidRootPart
    char:PivotTo(murdRoot.CFrame * CFrame.new(0,0,-3))
    task.wait(0.1)
    local shootRemote = ReplicatedStorage:FindFirstChild("ShootGun") or ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("ShootGun")
    if not shootRemote then
        for _, v in pairs(ReplicatedStorage:GetDescendants()) do if v:IsA("RemoteEvent") and (v.Name=="ShootGun" or v.Name=="Gun") then shootRemote=v; break end end
    end
    if shootRemote then
        for _=1,5 do
            workspace.CurrentCamera.CFrame = CFrame.lookAt(char.Head.Position, murdRoot.Position)
            shootRemote:FireServer(murdRoot.Position)
            task.wait(0.2)
        end
        Notify("Win", "Murderer shot 5 times!", 2)
    end
end)

CreateButton(WinTab, "🔪 Murderer: Kill All (AOE)", function()
    local char = LocalPlayer.Character
    if not char then return end
    local knife = char:FindFirstChild("Knife") or LocalPlayer.Backpack:FindFirstChild("Knife")
    if not knife then Notify("Error", "No knife!", 2) return end
    knife.Parent = char
    task.wait(0.1)
    local myPos = char.HumanoidRootPart.Position
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            p.Character:PivotTo(CFrame.new(myPos + Vector3.new(math.random(-2,2),0,math.random(-2,2))))
        end
    end
    for _=1,2 do knife:Activate(); task.wait(0.1) end
    Notify("Win", "All killed!", 2)
end)

CreateButton(WinTab, "🔫 Teleport to Gun (+ return)", function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local oldCFrame = char.HumanoidRootPart.CFrame
    local gunFound = false
    local targetPos = nil
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "GunDrop" or v.Name == "Gun" then
            local pos = v:IsA("Model") and v:GetModelCFrame() or v.CFrame
            if pos then
                targetPos = pos + Vector3.new(0,2,0)
                char:PivotTo(targetPos)
                Notify("Teleport", "Teleported to gun! Waiting for pickup...", 2)
                gunFound = true
                break
            end
        end
    end
    if not gunFound then Notify("Error", "No gun found!", 2) return end
    local startTime = tick()
    local itemGrabbed = false
    repeat
        task.wait(0.1)
        local stillThere = false
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "GunDrop" or v.Name == "Gun" then
                if (v:IsA("Model") and (v:GetModelCFrame().Position - targetPos).Magnitude < 3) or (v:IsA("BasePart") and (v.Position - targetPos).Magnitude < 3) then
                    stillThere = true
                    break
                end
            end
        end
        if not stillThere then
            itemGrabbed = true
            Notify("Teleport", "Gun picked up!", 2)
            break
        end
    until tick() - startTime > 2
    if not itemGrabbed then Notify("Teleport", "Pickup timeout, returning...", 2) end
    if char and char:FindFirstChild("HumanoidRootPart") then
        char:PivotTo(oldCFrame)
    end
end)

-- Ручной аим (E/Q) – остаётся, но на телефоне клавиш нет, всё через кнопку Aim
local aimConn
local function StartAim(target)
    if aimConn then aimConn:Disconnect() end
    aimConn = RunService.RenderStepped:Connect(function()
        if target and target.Character and target.Character:FindFirstChild("Head") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") then
            workspace.CurrentCamera.CFrame = CFrame.lookAt(LocalPlayer.Character.Head.Position, target.Character.Head.Position)
        end
    end)
end
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.E then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and (p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife")) then
                _G.AimTarget = p; _G.AimKey = "E"; StartAim(p); return
            end
        end
    elseif input.KeyCode == Enum.KeyCode.Q then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and (p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun")) then
                _G.AimTarget = p; _G.AimKey = "Q"; StartAim(p); return
            end
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if (input.KeyCode == Enum.KeyCode.E and _G.AimKey=="E") or (input.KeyCode == Enum.KeyCode.Q and _G.AimKey=="Q") then
        if aimConn then aimConn:Disconnect(); aimConn = nil end
        _G.AimKey = nil; _G.AimTarget = nil
    end
end)

-- TELEPORT TAB
CreateButton(TPTab, "🏠 Teleport to Lobby", TeleportToLobby)
CreateButton(TPTab, "📍 Teleport to Map", TeleportToMap)
CreateButton(TPTab, "🎲 Random Map Spawn", function()
    local char = LocalPlayer.Character
    if not char then return end
    local spawns = workspace:FindFirstChild("Normal"):FindFirstChild("Spawns")
    if spawns then
        local pts = spawns:GetChildren()
        if #pts > 0 then char:PivotTo(pts[math.random(#pts)].CFrame + Vector3.new(0,3,0)) end
    end
end)

-- RTX
CreateToggle(InfoTab, "RTX Graphics (Soft)", false, function(s)
    _G.RTXEnabled = s
    if s then
        Lighting.Brightness = 2.5; Lighting.Ambient = Color3.fromRGB(180,180,200); Lighting.OutdoorAmbient = Color3.fromRGB(200,200,220)
        Lighting.ExposureCompensation = 0.3
        local bloom = Instance.new("BloomEffect"); bloom.Intensity = 0.8; bloom.Size = 24; bloom.Threshold = 0.9; bloom.Parent = Lighting
        local cc = Instance.new("ColorCorrectionEffect"); cc.Brightness = 0.05; cc.Contrast = 0.1; cc.Saturation = 0.2; cc.TintColor = Color3.fromRGB(255,240,230); cc.Parent = Lighting
    else
        Lighting.Brightness = 2; Lighting.Ambient = Color3.fromRGB(127,127,127); Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127); Lighting.ExposureCompensation = 0
        for _, v in pairs(Lighting:GetChildren()) do if v:IsA("BloomEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end end
    end
end)

CreateButton(InfoTab, "⚡ FPS Unlocker (240)", function() setfpscap(240); Notify("FPS", "Cap set to 240", 2) end)

-- Запуск
pcall(function()
    if Tabs[1] then Tabs[1].Btn.MouseButton1Click:Fire() end
    Notify("ArtMM2 Hub", "Phone Version Loaded!", 5)
end)
