-- ========================================================
-- Foxname UI (画像のUI部分のみ完全コピー)
-- ========================================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local oldUI = CoreGui:FindFirstChild("FoxnameUI")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FoxnameUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- メインフレーム
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 350)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(68, 51, 119) -- 画像の紫色
MainFrame.BackgroundTransparency = 0.2 -- 半透明
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(139, 96, 247) -- 枠線
UIStroke.Thickness = 2
UIStroke.Transparency = 0.1
UIStroke.Parent = MainFrame

-- ==========================================
-- ヘッダー (上の部分)
-- ==========================================
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

-- 左上アイコン (赤い丸)
local TopIcon = Instance.new("Frame")
TopIcon.Size = UDim2.new(0, 30, 0, 30)
TopIcon.Position = UDim2.new(0, 15, 0, 10)
TopIcon.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
TopIcon.Parent = Header
Instance.new("UICorner", TopIcon).CornerRadius = UDim.new(1, 0)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 50, 0, -5)
Title.BackgroundTransparency = 1
Title.Text = "Foxname - Steal An Egg"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 1, 0)
SubTitle.Position = UDim2.new(0, 50, 0, 15)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "foxname.top"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- Keyless バッジ (青い四角)
local KeylessBadge = Instance.new("TextLabel")
KeylessBadge.Size = UDim2.new(0, 75, 0, 25)
KeylessBadge.Position = UDim2.new(0, 250, 0, 12)
KeylessBadge.BackgroundColor3 = Color3.fromRGB(59, 130, 246)
KeylessBadge.Text = "Keyless"
KeylessBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
KeylessBadge.TextSize = 13
KeylessBadge.Font = Enum.Font.GothamBold
KeylessBadge.Parent = Header
Instance.new("UICorner", KeylessBadge).CornerRadius = UDim.new(0, 4)

-- 右上のウィンドウ操作ボタン (-, [], X)
local function createWindowButton(text, posX, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 25, 0, 25)
    btn.Position = UDim2.new(1, posX, 0, 12)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = color
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Header
    btn.MouseButton1Click:Connect(function() if text == "X" then ScreenGui:Destroy() end end)
end
createWindowButton("-", -100, Color3.fromRGB(200, 200, 200))
createWindowButton("[]", -60, Color3.fromRGB(200, 200, 200))
createWindowButton("X", -20, Color3.fromRGB(200, 100, 255))

-- ==========================================
-- サイドバー (左側のメニュー)
-- ==========================================
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

-- メニュー項目
local menuItems = {
    {"Home", "☆"},
    {"Discord", "💬"},
    {"New Update", "⚡"},
    {"Donate", "❤️"},
    {"Features", "🔲"},
    {"Main", "⚙️"},
    {"Misc", "🔮"}
}

for i, item in ipairs(menuItems) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, i * 35)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = Sidebar
    
    -- アイコン
    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.new(0, 20, 0, 20)
    iconLabel.Position = UDim2.new(0, 0, 0.5, -10)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Text = item[2]
    iconLabel.TextColor3 = Color3.fromRGB(180, 130, 255)
    iconLabel.TextSize = 16
    iconLabel.Parent = btn

    -- 文字
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -30, 1, 0)
    textLabel.Position = UDim2.new(0, 30, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = item[1]
    textLabel.TextColor3 = Color3.fromRGB(220, 220, 240)
    textLabel.TextSize = 15
    textLabel.Font = Enum.Font.Gotham
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = btn

    btn.MouseEnter:Connect(function() textLabel.TextColor3 = Color3.fromRGB(255, 255, 255) end)
    btn.MouseLeave:Connect(function() textLabel.TextColor3 = Color3.fromRGB(220, 220, 240) end)
end

-- ==========================================
-- 中央コンテンツ (Developer)
-- ==========================================
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -170, 1, -60)
Content.Position = UDim2.new(0, 160, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local DevTitle = Instance.new("TextLabel")
DevTitle.Size = UDim2.new(1, 0, 0, 40)
DevTitle.Position = UDim2.new(0, 0, 0, 10)
DevTitle.BackgroundTransparency = 1
DevTitle.Text = "Developer"
DevTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
DevTitle.TextSize = 22
DevTitle.Font = Enum.Font.GothamBold
DevTitle.TextXAlignment = Enum.TextXAlignment.Center
DevTitle.Parent = Content

-- Cao Mod
local CaoModFrame = Instance.new("Frame")
CaoModFrame.Size = UDim2.new(1, -20, 0, 50)
CaoModFrame.Position = UDim2.new(0, 10, 0, 70)
CaoModFrame.BackgroundTransparency = 1
CaoModFrame.Parent = Content

local CaoModIcon = Instance.new("Frame")
CaoModIcon.Size = UDim2.new(0, 35, 0, 35)
CaoModIcon.Position = UDim2.new(0, 10, 0.5, -17.5)
CaoModIcon.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
CaoModIcon.Parent = CaoModFrame
Instance.new("UICorner", CaoModIcon).CornerRadius = UDim.new(1, 0)

local CaoModTitle = Instance.new("TextLabel")
CaoModTitle.Size = UDim2.new(1, -60, 0, 20)
CaoModTitle.Position = UDim2.new(0, 55, 0, 5)
CaoModTitle.BackgroundTransparency = 1
CaoModTitle.Text = "Cao Mod"
CaoModTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CaoModTitle.TextSize = 16
CaoModTitle.Font = Enum.Font.GothamBold
CaoModTitle.TextXAlignment = Enum.TextXAlignment.Left
CaoModTitle.Parent = CaoModFrame

local CaoModDesc = Instance.new("TextLabel")
CaoModDesc.Size = UDim2.new(1, -60, 0, 20)
CaoModDesc.Position = UDim2.new(0, 55, 0, 25)
CaoModDesc.BackgroundTransparency = 1
CaoModDesc.Text = "Script Developer & Owner"
CaoModDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
CaoModDesc.TextSize = 13
CaoModDesc.Font = Enum.Font.Gotham
CaoModDesc.TextXAlignment = Enum.TextXAlignment.Left
CaoModDesc.Parent = CaoModFrame

-- Foxname
local FoxnameFrame = Instance.new("Frame")
FoxnameFrame.Size = UDim2.new(1, -20, 0, 40)
FoxnameFrame.Position = UDim2.new(0, 10, 0, 140)
FoxnameFrame.BackgroundTransparency = 1
FoxnameFrame.Parent = Content

local FoxnameIcon = Instance.new("Frame")
FoxnameIcon.Size = UDim2.new(0, 25, 0, 25)
FoxnameIcon.Position = UDim2.new(0, 10, 0.5, -12.5)
FoxnameIcon.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
FoxnameIcon.Parent = FoxnameFrame
Instance.new("UICorner", FoxnameIcon).CornerRadius = UDim.new(1, 0)

local FoxnameTitle = Instance.new("TextLabel")
FoxnameTitle.Size = UDim2.new(1, -50, 1, 0)
FoxnameTitle.Position = UDim2.new(0, 45, 0, 0)
FoxnameTitle.BackgroundTransparency = 1
FoxnameTitle.Text = "Foxname"
FoxnameTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FoxnameTitle.TextSize = 18
FoxnameTitle.Font = Enum.Font.GothamBold
FoxnameTitle.TextXAlignment = Enum.TextXAlignment.Left
FoxnameTitle.Parent = FoxnameFrame

-- 下部テキスト
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, -20, 0, 50)
Footer.Position = UDim2.new(0, 10, 1, -60)
Footer.BackgroundTransparency = 1
Footer.Parent = Content

local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 20)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "Community unavailable"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 15
FooterTitle.Font = Enum.Font.GothamBold
FooterTitle.TextXAlignment = Enum.TextXAlignment.Left
FooterTitle.Parent = Footer

local FooterDesc = Instance.new("TextLabel")
FooterDesc.Size = UDim2.new(1, 0, 0, 30)
FooterDesc.Position = UDim2.new(0, 0, 0, 20)
FooterDesc.BackgroundTransparency = 1
FooterDesc.Text = "Discord did not return server information.\nUse Refresh stats to try again."
FooterDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
FooterDesc.TextSize = 12
FooterDesc.Font = Enum.Font.Gotham
FooterDesc.TextWrapped = true
FooterDesc.TextXAlignment = Enum.TextXAlignment.Left
FooterDesc.TextYAlignment = Enum.TextYAlignment.Top
FooterDesc.Parent = Footer

-- ==========================================
-- ドラッグ移動機能
-- ==========================================
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
