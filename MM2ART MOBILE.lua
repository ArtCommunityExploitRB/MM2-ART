-- ArtMM2 Hub | MOBILE Full Version (Touch + Aim Fix)

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

if CoreGui:FindFirstChild("ArtMM2Mobile") then CoreGui.ArtMM2Mobile:Destroy() end

local _G = {
    AutoFarm = false, ESP = false, Noclip = false, InfJump = false, FarmSpeed = 25,
    AutoRejoin = true, CollectedCoins = 0, NoclipFarm = false, AutoWin = false,
    TinyMode = false, RTXEnabled = false, AimKey = nil, AimTarget = nil,
    AutoFlingMurderer = false, AutoFlingAll = false, FlingPower = 100,
    ShowRoleOnRoundStart = false, AutoShoot = false
}

local function Notify(title, text, duration)
    duration = duration or 3
    local NotifFrame = Instance.new("Frame")
    local Corner = Instance.new("UICorner")
    local TitleLabel = Instance.new("TextLabel")
    local ContentLabel = Instance.new("TextLabel")

    NotifFrame.Name = "Notification"
    NotifFrame.Parent = CoreGui:FindFirstChild("ArtMM2Mobile") or CoreGui
    NotifFrame.Size = UDim2.new(0, 200, 0, 60)
    NotifFrame.Position = UDim2.new(0.5, -100, 0, -80)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.ZIndex = 10
    Instance.new("UICorner", NotifFrame).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", NotifFrame).Color = Color3.fromRGB(120, 81, 255)

    TitleLabel.Size = UDim2.new(1, -10, 0, 25)
    TitleLabel.Position = UDim2.new(0, 5, 0, 2)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = title:upper()
    TitleLabel.TextColor3 = Color3.fromRGB(120, 81, 255)
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 12
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.ZIndex = 11
    TitleLabel.Parent = NotifFrame

    ContentLabel.Size = UDim2.new(1, -10, 0, 25)
    ContentLabel.Position = UDim2.new(0, 5, 0, 25)
    ContentLabel.BackgroundTransparency = 1
    ContentLabel.Text = text
    ContentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ContentLabel.Font = Enum.Font.Gotham
    ContentLabel.TextSize = 11
    ContentLabel.TextXAlignment = Enum.TextXAlignment.Left
    ContentLabel.TextWrapped = true
    ContentLabel.ZIndex = 11
    ContentLabel.Parent = NotifFrame

    TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        {Position = UDim2.new(0.5, -100, 0, 20)}):Play()

    task.delay(duration, function()
        TweenService:Create(NotifFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In),
            {Position = UDim2.new(0.5, -100, 0, -80)}):Play()
        task.wait(0.5)
        NotifFrame:Destroy()
    end)
end

-- ==========================================
-- КОНФИГУРАЦИЯ ДЛЯ МОБАЙЛ (Оптимизировано под экраны)
-- ==========================================
local UIConfig = {
    MainWidth = 360,
    MainHeight = 220,
    SidebarWidth = 90,
    ButtonHeight = 30,
    FontSize = 11,
    SliderHeight = 40,
    ScrollThickness = 2,
    TabBtnHeight = 30
}

local ArtMM2 = Instance.new("ScreenGui")
ArtMM2.Name = "ArtMM2Mobile"
ArtMM2.Parent = CoreGui
ArtMM2.ResetOnSpawn = false

local Main = Instance.new("Frame", ArtMM2)
Main.Name = "MainFrame"
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.Position = UDim2.new(0.5, -UIConfig.MainWidth/2, 0.5, -UIConfig.MainHeight/2)
Main.Size = UDim2.new(0, UIConfig.MainWidth, 0, UIConfig.MainHeight)
Main.ClipsDescendants = true
Main.Active = true
Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(120, 81, 255)

local TopBar = Instance.new("Frame", Main)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
TopBar.Size = UDim2.new(1, 0, 0, 30)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)

local TitleLabel = Instance.new("TextLabel", TopBar)
TitleLabel.Text = "ARTMM2 MOBILE"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 12
TitleLabel.Position = UDim2.new(0, 10, 0, 0)
TitleLabel.Size = UDim2.new(0, 150, 1, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.TextSize = 14
CloseBtn.Font = Enum.Font.GothamBold

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 30, 0, 30)
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "—"
MinBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
MinBtn.TextSize = 14
MinBtn.Font = Enum.Font.GothamBold

local Sidebar = Instance.new("ScrollingFrame", Main)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Sidebar.Position = UDim2.new(0, 5, 0, 35)
Sidebar.Size = UDim2.new(0, UIConfig.SidebarWidth, 1, -40)
Sidebar.ScrollBarThickness = 0 -- Скрываем ползунок для мобилок
Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 6)
local SidebarLayout = Instance.new("UIListLayout", Sidebar)
SidebarLayout.Padding = UDim.new(0, 3)
SidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
SidebarLayout.SortOrder = Enum.SortOrder.LayoutOrder

local Container = Instance.new("Frame", Main)
Container.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
Container.Position = UDim2.new(0, UIConfig.SidebarWidth + 10, 0, 35)
Container.Size = UDim2.new(1, -(UIConfig.SidebarWidth + 15), 1, -40)
Instance.new("UICorner", Container).CornerRadius = UDim.new(0, 6)

local isHidden = false
MinBtn.MouseButton1Click:Connect(function()
    isHidden = not isHidden
    local targetSize = isHidden and UDim2.new(0, UIConfig.MainWidth, 0, 30) or UDim2.new(0, UIConfig.MainWidth, 0, UIConfig.MainHeight)
    TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function() ArtMM2:Destroy() end)

-- Перетаскивание (Поддержка Touch)
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

-- UI Функции
local Tabs = {}
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", Sidebar)
    TabBtn.Size = UDim2.new(0.95, 0, 0, UIConfig.TabBtnHeight)
    TabBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = UIConfig.FontSize
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)

    local Page = Instance.new("ScrollingFrame", Container)
    Page.Size = UDim2.new(1, -6, 1, -6)
    Page.Position = UDim2.new(0, 3, 0, 3)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.ScrollBarThickness = UIConfig.ScrollThickness
    Page.BorderSizePixel = 0
    
    local layout = Instance.new("UIListLayout", Page)
    layout.Padding = UDim.new(0, 5)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 5)
        Sidebar.CanvasSize = UDim2.new(0, 0, 0, SidebarLayout.AbsoluteContentSize.Y + 5)
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
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    Btn.MouseButton1Click:Connect(function()
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(120, 81, 255)}):Play()
        task.wait(0.1)
        TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
        pcall(callback)
    end)
end

local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(1, 0, 0, UIConfig.ButtonHeight)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -40, 1, 0)
    Label.Position = UDim2.new(0, 8, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = UIConfig.FontSize
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Check = Instance.new("TextButton", ToggleFrame)
    Check.Size = UDim2.new(0, 20, 0, 20)
    Check.Position = UDim2.new(1, -28, 0.5, -10)
    Check.BackgroundColor3 = default and Color3.fromRGB(120, 81, 255) or Color3.fromRGB(20, 20, 25)
    Check.Text = ""
    Instance.new("UICorner", Check).CornerRadius = UDim.new(0, 4)

    local state = default
    Check.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(Check, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(120, 81, 255) or Color3.fromRGB(20, 20, 25)}):Play()
        pcall(callback, state)
    end)
end

local function CreateSlider(parent, text, min, max, default, callback)
    local SliderFrame = Instance.new("Frame", parent)
    SliderFrame.Size = UDim2.new(1, 0, 0, UIConfig.SliderHeight)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    Instance.new("UICorner", SliderFrame).CornerRadius = UDim.new(0, 4)

    local Label = Instance.new("TextLabel", SliderFrame)
    Label.Size = UDim2.new(1, -16, 0, 20)
    Label.Position = UDim2.new(0, 8, 0, 2)
    Label.BackgroundTransparency = 1
    Label.Text = text .. ": " .. tostring(default)
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = UIConfig.FontSize
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Background = Instance.new("Frame", SliderFrame)
    Background.Size = UDim2.new(1, -16, 0, 6)
    Background.Position = UDim2.new(0, 8, 0, 25)
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

    local dragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - Background.AbsolutePosition.X) / Background.AbsoluteSize.X, 0, 1)
        local value = math.floor(min + ((max - min) * pos))
        Fill.Size = UDim2.new(pos, 0, 1, 0)
        Label.Text = text .. ": " .. tostring(value)
        pcall(callback, value)
    end

    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; updateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then updateSlider(input) end
    end)
end

-- Вкладки
local InfoTab = CreateTab("Info")
local PlayerTab = CreateTab("Player")
local FarmTab = CreateTab("Farm")
local EspTab = CreateTab("ESP")
local TargetTab = CreateTab("Aim")
local TP_WinTab = CreateTab("TP/Win")

-- INFO TAB
local InfoText = Instance.new("TextLabel", InfoTab)
InfoText.Size = UDim2.new(1, 0, 0, 100)
InfoText.Position = UDim2.new(0, 0, 0, 0)
InfoText.BackgroundTransparency = 1
InfoText.TextColor3 = Color3.fromRGB(220, 220, 220)
InfoText.Font = Enum.Font.Gotham
InfoText.TextSize = UIConfig.FontSize
InfoText.TextYAlignment = Enum.TextYAlignment.Top
InfoText.TextXAlignment = Enum.TextXAlignment.Left

task.spawn(function()
    while task.wait(1) do
        local ping = "N/A"
        pcall(function() ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
        local role = "Innocent"
        if LocalPlayer.Backpack:FindFirstChild("Knife") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Knife")) then role = "Murderer"
        elseif LocalPlayer.Backpack:FindFirstChild("Gun") or (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun")) then role = "Sheriff" end
        InfoText.Text = string.format(" Role: %s\n Ping: %s ms\n Coins: %s", role, ping, _G.CollectedCoins)
    end
end)

CreateToggle(InfoTab, "Show Role On Start", false, function(s) _G.ShowRoleOnRoundStart = s end)
CreateToggle(InfoTab, "RTX Graphics", false, function(s) _G.RTXEnabled = s end)
CreateButton(InfoTab, "Unlock FPS", function() setfpscap(240) end)

-- PLAYER TAB
CreateSlider(PlayerTab, "WalkSpeed", 16, 150, 16, function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = v end end)
CreateSlider(PlayerTab, "JumpPower", 50, 200, 50, function(v) if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.JumpPower = v end end)
CreateToggle(PlayerTab, "Noclip", false, function(s) _G.Noclip = s end)
CreateToggle(PlayerTab, "Infinite Jump", false, function(s) _G.InfJump = s end)

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

-- AIM TAB (Плавный Аимбот + Доводка до HumanoidRootPart)
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
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then target = p break end
                end
            end
        end
        if not target and autoAimSheriff then
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    if p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then target = p break end
                end
            end
        end
        
        local cam = workspace.CurrentCamera
        if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
            local targetCFrame = CFrame.lookAt(cam.CFrame.Position, target.Character.HumanoidRootPart.Position)
            cam.CFrame = cam.CFrame:Lerp(targetCFrame, 0.15) -- Плавность (Lerp)
            
            cam.FieldOfView = _G.AutoShoot and 30 or 70
            if _G.AutoShoot and LocalPlayer.Character then
                local gun = LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
                if gun then
                    local shootRemote = ReplicatedStorage:FindFirstChild("ShootGun") or ReplicatedStorage:FindFirstChild("Remotes"):FindFirstChild("ShootGun")
                    if not shootRemote then
                        for _, v in pairs(ReplicatedStorage:GetDescendants()) do if v:IsA("RemoteEvent") and (v.Name=="ShootGun" or v.Name=="Gun") then shootRemote=v; break end end
                    end
                    if shootRemote then shootRemote:FireServer(target.Character.HumanoidRootPart.Position) end
                end
            end
        else
            cam.FieldOfView = 70
        end
    end)
end

CreateToggle(TargetTab, "Aim Murderer", false, function(s) autoAimMurderer = s; AutoAimLoop() end)
CreateToggle(TargetTab, "Aim Sheriff", false, function(s) autoAimSheriff = s; AutoAimLoop() end)
CreateToggle(TargetTab, "Auto Shoot (Gun)", false, function(s) _G.AutoShoot = s; if not s then workspace.CurrentCamera.FieldOfView = 70 end end)

-- FARM TAB (Оптимизировано, без лишнего мусора)
local FarmLoopRunning = false
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

CreateToggle(FarmTab, "Auto Farm Coins", false, function(state)
    _G.AutoFarm = state
    if state then
        Notify("Auto Farm", "Started!", 3)
        if not FarmLoopRunning then
            FarmLoopRunning = true
            task.spawn(function()
                while _G.AutoFarm and FarmLoopRunning do
                    pcall(function()
                        local char = LocalPlayer.Character
                        if not char then return end
                        local coins = {}
                        for _, obj in pairs(workspace:GetDescendants()) do
                            if obj:IsA("BasePart") and (obj.Name == "Coin" or obj.Name:find("Coin")) and obj.Transparency < 0.9 and obj.Parent then
                                table.insert(coins, obj)
                            end
                        end
                        if #coins > 0 then
                            table.sort(coins, function(a,b) return (char.HumanoidRootPart.Position - a.Position).Magnitude < (char.HumanoidRootPart.Position - b.Position).Magnitude end)
                            FlyToCoin(coins[1])
                        end
                    end)
                    task.wait(0.2)
                end
                FarmLoopRunning = false
            end)
        end
    else
        FarmLoopRunning = false
    end
end)
CreateToggle(FarmTab, "Noclip Farm", false, function(s) _G.NoclipFarm = s end)
CreateSlider(FarmTab, "Flight Speed", 10, 80, 25, function(v) _G.FarmSpeed = v end)

-- ESP TAB
CreateToggle(EspTab, "Enable ESP", false, function(s)
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
                hl.OutlineColor = Color3.new(1,1,1); hl.FillTransparency = 0.5; hl.OutlineTransparency = 0
                if p.Backpack:FindFirstChild("Knife") or p.Character:FindFirstChild("Knife") then hl.FillColor = Color3.fromRGB(255,50,50)
                elseif p.Backpack:FindFirstChild("Gun") or p.Character:FindFirstChild("Gun") then hl.FillColor = Color3.fromRGB(50,150,255)
                else hl.FillColor = Color3.fromRGB(50,255,50) end
            end
        end
    end
end)

-- TP / WIN TAB
CreateButton(TP_WinTab, "Teleport to Lobby", function()
    local char = LocalPlayer.Character
    if char then char:PivotTo(CFrame.new(-108.5, 145, 0.6)) end
end)
CreateButton(TP_WinTab, "Teleport to Map", function()
    local char = LocalPlayer.Character
    local mapFolder = workspace:FindFirstChild("Normal")
    if char and mapFolder then char:PivotTo(CFrame.new(mapFolder:GetModelCFrame().Position + Vector3.new(0,5,0))) end
end)
CreateButton(TP_WinTab, "Grab Gun", function()
    local char = LocalPlayer.Character
    if not char then return end
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "GunDrop" or v.Name == "Gun" then
            local pos = v:IsA("Model") and v:GetModelCFrame() or v.CFrame
            if pos then char:PivotTo(pos + Vector3.new(0,1,0)); break end
        end
    end
end)

pcall(function()
    if Tabs[1] then Tabs[1].Btn.MouseButton1Click:Fire() end
    Notify("ArtMM2 Mobile", "Loaded Successfully!", 3)
end)
