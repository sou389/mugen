-- ============================================
-- Delta Executor 用 UIスクリプト（タブ版）
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local oldGui = playerGui:FindFirstChild("DeltaUI")
if oldGui then oldGui:Destroy() end

-- 現在のテーマカラー（設定で変更可能）
local accentColor = Color3.fromRGB(0, 170, 255)

-- ============================================
-- メインGUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 440, 0, 330)
MainFrame.Position = UDim2.new(0.5, -220, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = accentColor
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

-- ============================================
-- タイトルバー（スムーズドラッグ）
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DELTA HUB"
Title.TextColor3 = accentColor
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ============================================
-- スムーズドラッグ（補間あり）
-- ============================================
local dragging = false
local dragStart, startPos
local targetPos = MainFrame.Position
local currentPos = MainFrame.Position

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        currentPos = MainFrame.Position
        targetPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        targetPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

RunService.RenderStepped:Connect(function(dt)
    if dragging then
        currentPos = currentPos:Lerp(targetPos, math.clamp(dt * 30, 0, 1))
        MainFrame.Position = currentPos
    end
end)

-- ============================================
-- 左側サイドバー（Player / Settings）
-- ============================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 110, 1, -40)
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 12)
SidebarCorner.Parent = Sidebar

-- サイドバーの角丸を左下のみに（右側は角なし）
local SidebarCornerFix = Instance.new("Frame")
SidebarCornerFix.Size = UDim2.new(0, 10, 1, 0)
SidebarCornerFix.Position = UDim2.new(1, -10, 0, 0)
SidebarCornerFix.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
SidebarCornerFix.BorderSizePixel = 0
SidebarCornerFix.Parent = Sidebar

local tabButtons = {}
local function createTab(name, yPos, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 45)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    btn.Parent = Sidebar

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn

    local stroke = Instance.new("UIStroke")
    stroke.Color = accentColor
    stroke.Thickness = 1
    stroke.Transparency = 1
    stroke.Parent = btn

    btn.MouseButton1Click:Connect(onClick)
    table.insert(tabButtons, {button = btn, stroke = stroke})
    return btn
end

-- ============================================
-- 右側コンテンツエリア
-- ============================================
local ContentArea = Instance.new("Frame")
ContentArea.Name = "ContentArea"
ContentArea.Size = UDim2.new(1, -110, 1, -40)
ContentArea.Position = UDim2.new(0, 110, 0, 40)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

-- ============================================
-- スライダー作成（スムーズ版）
-- ============================================
local function createSlider(parent, name, yPos, minVal, maxVal, defaultVal, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -30, 0, 75)
    Container.Position = UDim2.new(0, 15, 0, yPos)
    Container.BackgroundTransparency = 1
    Container.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 25)
    ValueLabel.Position = UDim2.new(1, -60, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = string.format("%.0f", defaultVal)
    ValueLabel.TextColor3 = accentColor
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Container

    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, 0, 0, 12)
    SliderBg.Position = UDim2.new(0, 0, 0, 40)
    SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Container

    local SliderBgCorner = Instance.new("UICorner")
    SliderBgCorner.CornerRadius = UDim.new(1, 0)
    SliderBgCorner.Parent = SliderBg

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = accentColor
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBg

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 26, 0, 26)
    Knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -13, 0.5, -13)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBg

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local KnobStroke = Instance.new("UIStroke")
    KnobStroke.Color = accentColor
    KnobStroke.Thickness = 2
    KnobStroke.Parent = Knob

    local sliderDragging = false
    local targetRelX = (defaultVal - minVal) / (maxVal - minVal)
    local currentRelX = targetRelX

    local function computeRelX(absX)
        return math.clamp((absX - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
    end

    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            targetRelX = computeRelX(input.Position.X)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            targetRelX = computeRelX(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end)

    local sliderElements = {fill = Fill, knobStroke = KnobStroke, valueLabel = ValueLabel}

    RunService.RenderStepped:Connect(function(dt)
        if not sliderDragging then return end
        currentRelX = currentRelX + (targetRelX - currentRelX) * math.clamp(dt * 22, 0, 1)
        Fill.Size = UDim2.new(currentRelX, 0, 1, 0)
        Knob.Position = UDim2.new(currentRelX, -13, 0.5, -13)
        local value = minVal + (maxVal - minVal) * currentRelX
        ValueLabel.Text = string.format("%.0f", value)
        callback(value)
    end)

    return Container, sliderElements
end

-- ============================================
-- Playerページ
-- ============================================
local PlayerPage = Instance.new("Frame")
PlayerPage.Name = "PlayerPage"
PlayerPage.Size = UDim2.new(1, 0, 1, 0)
PlayerPage.BackgroundTransparency = 1
PlayerPage.Parent = ContentArea

local currentSpeed = 16
local currentJump = 50

createSlider(PlayerPage, "Speed", 15, 1, 500, 16, function(value)
    currentSpeed = value
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = value end
end)

createSlider(PlayerPage, "Jump Power", 95, 1, 500, 50, function(value)
    currentJump = value
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = value
        humanoid.UseJumpPower = true
    end
end)

-- ============================================
-- Settingsページ
-- ============================================
local SettingsPage = Instance.new("Frame")
SettingsPage.Name = "SettingsPage"
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = ContentArea

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, -30, 0, 25)
themeLabel.Position = UDim2.new(0, 15, 0, 15)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "Accent Color"
themeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
themeLabel.Font = Enum.Font.GothamMedium
themeLabel.TextSize = 14
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Parent = SettingsPage

-- カラーパレット
local colorPalette = {
    {name = "Blue", color = Color3.fromRGB(0, 170, 255)},
    {name = "Purple", color = Color3.fromRGB(160, 80, 255)},
    {name = "Red", color = Color3.fromRGB(255, 60, 60)},
    {name = "Green", color = Color3.fromRGB(0, 220, 120)},
    {name = "Orange", color = Color3.fromRGB(255, 150, 0)},
    {name = "Pink", color = Color3.fromRGB(255, 100, 180)},
}

local allThemeElements = {} -- テーマ変更で更新する要素を登録

local function registerThemeElement(element, property, originalColor)
    table.insert(allThemeElements, {element = element, property = property, color = originalColor or accentColor})
end

local swatchSize = 45
local startX = 15
local startY = 55

for i, data in ipairs(colorPalette) do
    local row = math.floor((i - 1) / 3)
    local col = (i - 1) % 3
    local swatch = Instance.new("TextButton")
    swatch.Size = UDim2.new(0, swatchSize, 0, swatchSize)
    swatch.Position = UDim2.new(0, startX + col * (swatchSize + 10), 0, startY + row * (swatchSize + 10))
    swatch.BackgroundColor3 = data.color
    swatch.Text = ""
    swatch.BorderSizePixel = 0
    swatch.Parent = SettingsPage

    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 8)
    sc.Parent = swatch

    local ss = Instance.new("UIStroke")
    ss.Color = Color3.fromRGB(255, 255, 255)
    ss.Thickness = 2
    ss.Transparency = 1
    ss.Parent = swatch

    swatch.MouseButton1Click:Connect(function()
        accentColor = data.color
        -- UI全体の色を更新
        UIStroke.Color = accentColor
        Title.TextColor3 = accentColor
        for _, tab in ipairs(tabButtons) do
            tab.stroke.Color = accentColor
        end
        for _, item in ipairs(allThemeElements) do
            if item.element and item.element.Parent then
                item.element[item.property] = accentColor
            end
        end
        -- スウォッチの選択枠
        for _, other in ipairs(SettingsPage:GetChildren()) do
            if other:IsA("TextButton") and other:FindFirstChildOfClass("UIStroke") then
                other:FindFirstChildOfClass("UIStroke").Transparency = 1
            end
        end
        ss.Transparency = 0
    end)
end

-- ============================================
-- タブ切り替え
-- ============================================
local function showPage(page, btn)
    PlayerPage.Visible = (page == PlayerPage)
    SettingsPage.Visible = (page == SettingsPage)
    for _, tab in ipairs(tabButtons) do
        if tab.button == btn then
            tab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            tab.button.TextColor3 = accentColor
            tab.stroke.Transparency = 0.3
        else
            tab.button.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
            tab.stroke.Transparency = 1
        end
    end
end

local playerTab = createTab("Player", 15, function() showPage(PlayerPage, playerTab) end)
local settingsTab = createTab("Settings", 70, function() showPage(SettingsPage, settingsTab) end)

-- 初期表示
showPage(PlayerPage, playerTab)

-- ============================================
-- 左下のアバターアイコン
-- ============================================
local AvatarContainer = Instance.new("Frame")
AvatarContainer.Name = "AvatarContainer"
AvatarContainer.Size = UDim2.new(0, 50, 0, 50)
AvatarContainer.Position = UDim2.new(0, 12, 1, -62)
AvatarContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
AvatarContainer.BorderSizePixel = 0
AvatarContainer.Parent = Sidebar

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarContainer

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = accentColor
AvatarStroke.Thickness = 2
AvatarStroke.Parent = AvatarContainer

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(1, -4, 1, -4)
AvatarImage.Position = UDim2.new(0, 2, 0, 2)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Parent = AvatarContainer

local AvatarImageCorner = Instance.new("UICorner")
AvatarImageCorner.CornerRadius = UDim.new(1, 0)
AvatarImageCorner.Parent = AvatarImage

AvatarImage.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", player.UserId)
player.Changed:Connect(function(prop)
    if prop == "UserId" then
        AvatarImage.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", player.UserId)
    end
end)

-- テーマ登録
registerThemeElement(UIStroke, "Color")
registerThemeElement(Title, "TextColor3")
registerThemeElement(AvatarStroke, "Color")

-- ============================================
-- リスポーン対応
-- ============================================
local function applyStats(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = currentSpeed
        humanoid.JumpPower = currentJump
        humanoid.UseJumpPower = true
    end
end

player.CharacterAdded:Connect(applyStats)
if player.Character then applyStats(player.Character) end

-- 右Shiftで表示/非表示
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("Delta Hub UI Loaded!")
