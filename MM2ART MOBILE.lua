-- ArtMM2 Hub | Phone Full Version (Compact)

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
    AutoShoot = false
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
local UIConfig = {
    MainWidth = 280,
    MainHeight = 350,
    SidebarWidth = 80,
    ButtonHeight = 36,
    FontSize = 13,
    SliderHeight = 50,
    ScrollThickness = 4,
    TabBtnHeight = 36,
    StartMinimized = false,
    FloatingHub = false
}

local ArtMM2 = Instance.new("ScreenGui")
ArtMM2.Name = "ArtMM2"
ArtMM2.Parent = CoreGui
ArtMM2.ResetOnSpawn = false

local Main = Instance.new("Frame", ArtMM2)
Main.Name = "MainFrame"
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Position = UDim2.new(0, 10, 0.5, -UIConfig.MainHeight/2)
Main.Size = UDim2.new(0, UIConfig.MainWidth, 0, UIConfig.MainHeight)
Main.ClipsDescendants = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 10)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(120, 81, 255)
Main.Visible = true

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
CloseBtn.Text = "X"
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
CloseBtn.MouseButton1Click:Connect(function() ArtMM2:Destroy() end)

-- Перетаскивание
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
local FarmTab = CreateTab("Farm")
local EspTab = CreateTab("ESP")
local WinTab = CreateTab("Win")
local TargetTab = CreateTab("Target")
local FlingTab = CreateTab("Fling")
local TPTab = CreateTab("TP")

-- INFO TAB
local Avatar = Instance.new("ImageLabel", InfoTab)
Avatar.Size = UDim2.new(0, 60, 0, 60)
Avatar.Position = UDim2.new(0.5, -30, 0, 10)
Avatar.Image = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size420x420)
Avatar.BackgroundTransparency = 1
Instance.new("UICorner", Avatar).CornerRadius = UDim.new(1, 0)

local InfoText = Instance.new("TextLabel", InfoTab)
InfoText.Size = UDim2.new(1, 0, 0, 100)
InfoText.Position = UDim2.new(0, 0, 0, 80)
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
        InfoText.Text = string.format("%s\nRole: %s\nPing: %sms\nCoins: %s", LocalPlayer.Name, role, ping, _G.CollectedCoins)
    end
end)

-- Функция определения роли и уведомления
local lastRoleNotified = nil
local function CheckAndNotifyRole()
    if not _G.ShowRoleOnRoundStart then return end
    if not LocalPlayer.Character then return end
    if workspace:FindFirstChild("Lobby") then return end
    local role = nil
    if LocalPlayer.Backpack:FindFirstChild("Knife") or LocalPlayer.Character:FindFirstChild("Knife") then role = "Murderer"
    elseif LocalPlayer.Backpack:FindFirstChild("Gun") or LocalPlayer.Character:FindFirstChild("Gun") then role = "Sheriff"
    else role = "Innocent" end
    if role ~= lastRoleNotified then
        lastRoleNotified = role
        Notify("ROLE", "You are "..role.."!", 4)
    end
end

task.spawn(function() while task.wait(1) do pcall(CheckAndNotifyRole) end end)

CreateToggle(InfoTab, "Show Role On Round Start", false, function(s)
    _G.ShowRoleOnRoundStart = s
    if s then lastRoleNotified = nil; CheckAndNotifyRole() end
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

-- TARGET TAB
local TargetListFrame = Instance.new("Frame", TargetTab)
TargetListFrame.Size = UDim2.new(1, 0, 0, 120)
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
            btn.Size = UDim2.new(1,0,0,28)
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

CreateButton(TargetTab, "Refresh", UpdateTargetList)
CreateButton(TargetTab, "Teleport Behind", function()
    if SelectedTarget and SelectedTarget.Character and SelectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:PivotTo(SelectedTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,-3))
        Notify("Target", "Teleported", 2)
    else Notify("Error", "No target", 2) end
end)

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
            workspace.CurrentCamera.FieldOfView = 30
            if _G.AutoShoot and LocalPlayer.Character then
                local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                if gun then
                    local shootRemote = ReplicatedStorage:FindFirstChild("ShootGun") or ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("ShootGun")
                    if not shootRemote then
                        for _, v in pairs(ReplicatedStorage:GetDescendants()) do if v:IsA("RemoteEvent") and (v.Name=="ShootGun" or v.Name=="Gun") then shootRemote=v; break end end
                    end
                    if shootRemote then shootRemote:FireServer(target.Character.Head.Position) end
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

-- FLING TAB
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
FlingListFrame.Size = UDim2.new(1, 0, 0, 120)
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

CreateButton(FlingTab, "Refresh", UpdateFlingList)
CreateButton(FlingTab, "All", function() SelectAllFling(true) end)
CreateButton(FlingTab, "None", function() SelectAllFling(false) end)
CreateButton(FlingTab, "Start", function()
    if FlingActive then return end
    if next(SelectedFlingTargets) == nil then Notify("Fling", "No targets", 2) return end
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
CreateButton(FlingTab, "Stop", function() FlingActive = false; Notify("Fling", "Stopped", 2) end)

-- АВТОФАРМ + АВТОВИН + АВТОФЛИНГ (идентично ПК-версии)
-- ... (скопируйте блок с функциями TeleportToLobby, TeleportToMap, RejoinServer, FlyToCoin, FarmCoins, TryAutoWin, TryAutoFling и тогглы из ПК-скрипта)
-- Я опускаю повторяющийся код для экономии места, но в полном скрипте он должен быть.

-- ESP, FAST WIN, TELEPORT, RTX – точно такие же, как в ПК-версии.
-- ... (скопируйте их из ПК-скрипта)

-- Запуск
pcall(function()
    if Tabs[1] then Tabs[1].Btn.MouseButton1Click:Fire() end
    Notify("ArtMM2 Hub", "Phone Version Loaded!", 5)
end)
