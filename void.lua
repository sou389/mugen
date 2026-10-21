-- ========================================================
-- [void] Ultimate Hub - Main Loader
-- ========================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local old = CoreGui:FindFirstChild("VoidUltimateHub")
if old then old:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidUltimateHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- メインフレーム（グラスモーフィズム）
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 380)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
MainFrame.BackgroundTransparency = 0.2
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Color3.fromRGB(150, 100, 255)
MainStroke.Thickness = 2
MainStroke.Transparency = 0.2

-- 背景画像（少し暗めに）
local BackgroundImage = Instance.new("ImageLabel", MainFrame)
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://10154837654" 
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.ImageTransparency = 0.6

-- グラデーションオーバーレイ
local GradientOverlay = Instance.new("Frame", MainFrame)
GradientOverlay.Size = UDim2.new(1, 0, 1, 0)
GradientOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
GradientOverlay.BackgroundTransparency = 1
local UIGradient = Instance.new("UIGradient", GradientOverlay)
UIGradient.Color = ColorSequence.new(Color3.fromRGB(60, 30, 120), Color3.fromRGB(10, 5, 20))
UIGradient.Rotation = 45

-- ヘッダー
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 55)
Header.BackgroundTransparency = 1

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 25, 0, -2)
Title.BackgroundTransparency = 1
Title.Text = "void | ULTIMATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 20
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.TextStrokeTransparency = 1

local SubTitle = Instance.new("TextLabel", Header)
SubTitle.Size = UDim2.new(0, 200, 1, 0)
SubTitle.Position = UDim2.new(0, 25, 0, 18)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Premium Script Hub"
SubTitle.TextColor3 = Color3.fromRGB(180, 160, 220)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.TextStrokeTransparency = 1

-- 閉じるボタン
local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -45, 0, 10)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
CloseBtn.TextSize = 22
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextStrokeTransparency = 1
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- 左側サイドバー
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 160, 1, -55)
Sidebar.Position = UDim2.new(0, 0, 0, 55)
Sidebar.BackgroundTransparency = 1

-- ========================================================
-- タブ切り替えシステム
-- ========================================================
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -160, 1, -55)
ContentContainer.Position = UDim2.new(0, 160, 0, 55)
ContentContainer.BackgroundTransparency = 1

local CurrentTab = nil
local TabButtons = {}

local function CreateTab(name, displayName)
    -- タブボタン作成
    local btn = Instance.new("TextButton", Sidebar)
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, (#TabButtons * 45) + 10)
    btn.BackgroundColor3 = Color3.fromRGB(40, 30, 60)
    btn.BackgroundTransparency = 0.5
    btn.Text = "  " .. displayName
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.TextSize = 15
    btn.Font = Enum.Font.GothamBold
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.TextStrokeTransparency = 1
    btn.AutoButtonColor = false

    local corner = Instance.new("UICorner", btn)
    corner.CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(100, 80, 150)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.5

    -- タブの中身を入れるフレーム
    local page = Instance.new("Frame", ContentContainer)
    page.Size = UDim2.new(1, -20, 1, -20)
    page.Position = UDim2.new(0, 10, 0, 10)
    page.BackgroundTransparency = 1
    page.Visible = false

    -- ボタンクリック時の処理
    btn.MouseButton1Click:Connect(function()
        for _, p in ipairs(ContentContainer:GetChildren()) do
            if p:IsA("Frame") then p.Visible = false end
        end
        for _, b in ipairs(Sidebar:GetChildren()) do
            if b:IsA("TextButton") then
                TweenService:Create(b, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(200, 200, 200)}):Play()
            end
        end
        page.Visible = true
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        CurrentTab = name
    end)

    table.insert(TabButtons, btn)
    return page
end

-- タブの生成
local HomeTab = CreateTab("Home", "🏠 Home")
local PlayerTab = CreateTab("Player", "👤 Player")
local VisualTab = CreateTab("Visuals", "👁️ Visuals")
local MiscTab = CreateTab("Misc", "⚙️ Misc")

-- 初期タブを開く
TabButtons[1].MouseButton1Click:Fire()

-- 左下プロフィールアイコン
local PlayerIcon = Instance.new("ImageLabel", MainFrame)
PlayerIcon.Size = UDim2.new(0, 45, 0, 45)
PlayerIcon.Position = UDim2.new(0, 15, 1, -60)
PlayerIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
PlayerIcon.BorderSizePixel = 0
Instance.new("UICorner", PlayerIcon).CornerRadius = UDim.new(1, 0)

local iconStroke = Instance.new("UIStroke", PlayerIcon)
iconStroke.Color = Color3.fromRGB(150, 100, 255)
iconStroke.Thickness = 2

local player = Players.LocalPlayer
local function updateIcon()
    if player then
        local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        if content then PlayerIcon.Image = content end
    end
end
updateIcon()
player.CharacterAdded:Connect(function() task.wait(1) updateIcon() end)

-- ドラッグ機能
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- UIの登場アニメーション
MainFrame.Size = UDim2.new(0, 0, 0, 0)
TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 600, 0, 380)}):Play()

-- ここから下に各タブの機能を追加していく
-- (※実際の機能は「パート2」のスクリプトで追加します)
-- ========================================================
-- [void] Ultimate Hub - Part 2 (Functions & Interactions)
-- ========================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local plr = Players.LocalPlayer

-----------------------------------------------------------
-- 1. 機能パーツ作成用の便利関数
-----------------------------------------------------------
local function CreateToggle(parent, text, default, callback)
    local ToggleFrame = Instance.new("Frame", parent)
    ToggleFrame.Size = UDim2.new(1, 0, 0, 35)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 50)
    ToggleFrame.BackgroundTransparency = 0.5
    Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", ToggleFrame)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 14
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.TextStrokeTransparency = 1

    local ToggleBtn = Instance.new("TextButton", ToggleFrame)
    ToggleBtn.Size = UDim2.new(0, 40, 0, 20)
    ToggleBtn.Position = UDim2.new(1, -50, 0.5, -10)
    ToggleBtn.BackgroundColor3 = default and Color3.fromRGB(100, 50, 200) or Color3.fromRGB(50, 50, 50)
    ToggleBtn.Text = ""
    Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(1, 0)
    
    local Circle = Instance.new("Frame", ToggleBtn)
    Circle.Size = UDim2.new(0, 16, 0, 16)
    Circle.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local isActive = default

    ToggleBtn.MouseButton1Click:Connect(function()
        isActive = not isActive
        game:GetService("TweenService"):Create(ToggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = isActive and Color3.fromRGB(100, 50, 200) or Color3.fromRGB(50, 50, 50)}):Play()
        game:GetService("TweenService"):Create(Circle, TweenInfo.new(0.2), {Position = isActive and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        if callback then callback(isActive) end
    end)
    return ToggleFrame
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, 0, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
    Btn.BackgroundTransparency = 0.4
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.TextSize = 14
    Btn.Font = Enum.Font.GothamBold
    Btn.TextStrokeTransparency = 1
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", Btn)
    stroke.Color = Color3.fromRGB(100, 80, 150)
    
    Btn.MouseEnter:Connect(function() game:GetService("TweenService"):Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play() end)
    Btn.MouseLeave:Connect(function() game:GetService("TweenService"):Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play() end)
    
    Btn.MouseButton1Click:Connect(function()
        Btn.BackgroundColor3 = Color3.fromRGB(150, 100, 250)
        task.wait(0.1)
        Btn.BackgroundColor3 = Color3.fromRGB(40, 30, 70)
        if callback then callback() end
    end)
    return Btn
end

-- レイアウト用のリストレイアウト
local function ApplyListLayout(parent)
    local layout = Instance.new("UIListLayout", parent)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
end

ApplyListLayout(HomeTab)
ApplyListLayout(PlayerTab)
ApplyListLayout(VisualTab)
ApplyListLayout(MiscTab)

-----------------------------------------------------------
-- 2. Homeタブ（ウェルカム画面）
-----------------------------------------------------------
local welcomeText = Instance.new("TextLabel", HomeTab)
welcomeText.Size = UDim2.new(1, 0, 0, 50)
welcomeText.BackgroundTransparency = 1
welcomeText.Text = "Welcome to void Hub, " .. plr.Name .. "!"
welcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeText.TextSize = 20
welcomeText.Font = Enum.Font.GothamBold
welcomeText.TextXAlignment = Enum.TextXAlignment.Left
welcomeText.TextStrokeTransparency = 1

local updateText = Instance.new("TextLabel", HomeTab)
updateText.Size = UDim2.new(1, 0, 0, 40)
updateText.BackgroundTransparency = 1
updateText.Text = "Status: Undetected | Version: 4.0 Ultimate"
updateText.TextColor3 = Color3.fromRGB(180, 255, 180)
updateText.TextSize = 14
updateText.Font = Enum.Font.Gotham
updateText.TextXAlignment = Enum.TextXAlignment.Left
updateText.TextStrokeTransparency = 1

-----------------------------------------------------------
-- 3. Playerタブ（キャラクター強化）
-----------------------------------------------------------
local walkSpeedToggle = CreateToggle(PlayerTab, "Speed Hack (WalkSpeed 100)", false, function(state)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = state and 100 or 16
end)
plr.CharacterAdded:Connect(function(char) -- リスポーン時に適用
    local hum = char:WaitForChild("Humanoid")
    if walkSpeedToggle:FindFirstChild("TextButton").BackgroundColor3 == Color3.fromRGB(100, 50, 200) then
        hum.WalkSpeed = 100
    end
end)

local jumpPowerToggle = CreateToggle(PlayerTab, "Jump Hack (JumpPower 150)", false, function(state)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    if state then
        hum.UseJumpPower = true
        hum.JumpPower = 150
    else
        hum.JumpPower = 50
    end
end)

local infJumpToggle = CreateToggle(PlayerTab, "Infinite Jump", false)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpToggle:FindFirstChild("TextButton").BackgroundColor3 == Color3.fromRGB(100, 50, 200) then
        local char = plr.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:ChangeState("Jumping")
        end
    end
end)

-----------------------------------------------------------
-- 4. Visualsタブ（視覚エフェクト）
-----------------------------------------------------------
local fullbrightToggle = CreateToggle(VisualTab, "Fullbright (Clear Fog)", false, function(state)
    local lighting = game:GetService("Lighting")
    if state then
        lighting.Brightness = 5
        lighting.FogEnd = 100000
    else
        lighting.Brightness = 2
        lighting.FogEnd = 1000
    end
end)

local espToggle = CreateToggle(VisualTab, "Player ESP (Highlight)", false, function(state)
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr and p.Character then
            if state then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "VoidESP"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            else
                local hl = p.Character:FindFirstChild("VoidESP")
                if hl then hl:Destroy() end
            end
        end
    end
end)

-----------------------------------------------------------
-- 5. Miscタブ（その他のヤバい機能）
-----------------------------------------------------------
local flyToggle = CreateToggle(MiscTab, "Fly Hack (E to Fly)", false)
local flying = false
local bv, bg

flyToggle:FindFirstChild("TextButton").MouseButton1Click:Connect(function()
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    flying = flyToggle:FindFirstChild("TextButton").BackgroundColor3 == Color3.fromRGB(100, 50, 200)
    
    if flying then
        bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "VoidFly"
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0,0,0)
        
        bg = Instance.new("BodyGyro", hrp)
        bg.Name = "VoidFlyGyro"
        bg.P = 1000
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = hrp.CFrame
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and bv and bg then
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local moveDir = game:GetService("UserInputService"):GetMoveVector()
        local camCFrame = workspace.CurrentCamera.CFrame
        
        if moveDir.Magnitude > 0 then
            bv.Velocity = (camCFrame.LookVector * -moveDir.Z + camCFrame.RightVector * moveDir.X) * 100
        else
            bv.Velocity = Vector3.new(0,0,0)
        end
        
        bg.CFrame = camCFrame
    end
end)

local antiAfkBtn = CreateButton(MiscTab, "Anti-AFK (Prevent Kick)", function()
    local VirtualUser = game:GetService("VirtualUser")
    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    antiAfkBtn.Text = "Anti-AFK Activated!"
    task.wait(2)
    antiAfkBtn.Text = "Anti-AFK (Prevent Kick)"
end)
-- ========================================================
-- [void] Ultimate Hub - Part 3: The Cheats
-- ========================================================

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local VirtualUser = game:GetService("VirtualUser")
local plr = game:GetService("Players").LocalPlayer

-- Homeタブ
local welcomeText = Instance.new("TextLabel", _G.HomeTab)
welcomeText.Size = UDim2.new(1, 0, 0, 50)
welcomeText.BackgroundTransparency = 1
welcomeText.Text = "Welcome to void Hub, " .. plr.Name .. "!"
welcomeText.TextColor3 = Color3.fromRGB(255, 255, 255)
welcomeText.TextSize = 20
welcomeText.Font = Enum.Font.GothamBold
welcomeText.TextXAlignment = Enum.TextXAlignment.Left
welcomeText.TextStrokeTransparency = 1

local updateText = Instance.new("TextLabel", _G.HomeTab)
updateText.Size = UDim2.new(1, 0, 0, 40)
updateText.BackgroundTransparency = 1
updateText.Text = "Status: Undetected | Version: 4.0 Ultimate"
updateText.TextColor3 = Color3.fromRGB(180, 255, 180)
updateText.TextSize = 14
updateText.Font = Enum.Font.Gotham
updateText.TextXAlignment = Enum.TextXAlignment.Left
updateText.TextStrokeTransparency = 1

-- Playerタブ
local walkSpeedToggle = CreateToggle(_G.PlayerTab, "Speed Hack (WalkSpeed 100)", false, function(state)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    hum.WalkSpeed = state and 100 or 16
end)

local jumpPowerToggle = CreateToggle(_G.PlayerTab, "Jump Hack (JumpPower 150)", false, function(state)
    local char = plr.Character or plr.CharacterAdded:Wait()
    local hum = char:WaitForChild("Humanoid")
    if state then
        hum.UseJumpPower = true
        hum.JumpPower = 150
    else
        hum.JumpPower = 50
    end
end)

local infJumpToggle = CreateToggle(_G.PlayerTab, "Infinite Jump", false)
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJumpToggle:FindFirstChild("TextButton").BackgroundColor3 == Color3.fromRGB(100, 50, 200) then
        local char = plr.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            char.Humanoid:ChangeState("Jumping")
        end
    end
end)

-- Visualsタブ
local fullbrightToggle = CreateToggle(_G.VisualTab, "Fullbright (Clear Fog)", false, function(state)
    if state then
        Lighting.Brightness = 5
        Lighting.FogEnd = 100000
    else
        Lighting.Brightness = 2
        Lighting.FogEnd = 1000
    end
end)

local espToggle = CreateToggle(_G.VisualTab, "Player ESP (Highlight)", false, function(state)
    for _, p in pairs(game:GetService("Players"):GetPlayers()) do
        if p ~= plr and p.Character then
            if state then
                local hl = Instance.new("Highlight", p.Character)
                hl.Name = "VoidESP"
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
            else
                local hl = p.Character:FindFirstChild("VoidESP")
                if hl then hl:Destroy() end
            end
        end
    end
end)

-- Miscタブ
local flying = false
local bv, bg
local flyToggle = CreateToggle(_G.MiscTab, "Fly Hack (Camera Direction)", false, function(state)
    flying = state
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    if flying then
        bv = Instance.new("BodyVelocity", hrp)
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0,0,0)
        bg = Instance.new("BodyGyro", hrp)
        bg.P = 1000
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = hrp.CFrame
    else
        if bv then bv:Destroy() end
        if bg then bg:Destroy() end
    end
end)

RunService.RenderStepped:Connect(function()
    if flying and bv and bg then
        local char = plr.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        
        local moveDir = game:GetService("UserInputService"):GetMoveVector()
        local camCFrame = workspace.CurrentCamera.CFrame
        
        if moveDir.Magnitude > 0 then
            bv.Velocity = (camCFrame.LookVector * -moveDir.Z + camCFrame.RightVector * moveDir.X) * 100
        else
            bv.Velocity = Vector3.new(0,0,0)
        end
        bg.CFrame = camCFrame
    end
end)

local antiAfkBtn = CreateButton(_G.MiscTab, "Anti-AFK (Prevent Kick)", function()
    plr.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
    antiAfkBtn.Text = "Anti-AFK Activated!"
    task.wait(2)
    antiAfkBtn.Text = "Anti-AFK (Prevent Kick)"
end)
