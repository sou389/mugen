-- ========================================================
-- 完全再現版 (Foxname UI Clone - 背景画像対応)
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
MainFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- ★背景イラスト (ロリ系アニメ画像)★
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
-- Roblox内のアニメ調女の子イラストID
BackgroundImage.Image = "rbxassetid://17384785064" 
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = MainFrame

-- 画像を暗く・紫にするオーバーレイ（文字を見やすくする）
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
Overlay.BackgroundTransparency = 0.5
Overlay.BorderSizePixel = 0
Overlay.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 60, 160)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 80))
}
UIGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 0.6)
}
UIGradient.Rotation = 45
UIGradient.Parent = Overlay

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(150, 100, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2
UIStroke.Parent = MainFrame

-- ヘッダー
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 55, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Foxname - Steal An Egg"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 1, 0)
SubTitle.Position = UDim2.new(0, 55, 0, 15)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "foxname.top"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- ヘッダー左のアイコン
local HeaderIcon = Instance.new("ImageLabel")
HeaderIcon.Size = UDim2.new(0, 35, 0, 35)
HeaderIcon.Position = UDim2.new(0, 15, 0, 8)
HeaderIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
HeaderIcon.Parent = Header
Instance.new("UICorner", HeaderIcon).CornerRadius = UDim.new(1, 0)
HeaderIcon.Image = "rbxassetid://17384785064" -- 仮のアイコン

-- Keyless バッジ
local KeylessBadge = Instance.new("TextLabel")
KeylessBadge.Size = UDim2.new(0, 80, 0, 25)
KeylessBadge.Position = UDim2.new(0, 230, 0, 12)
KeylessBadge.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
KeylessBadge.Text = "Keyless"
KeylessBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
KeylessBadge.TextSize = 14
KeylessBadge.Font = Enum.Font.GothamBold
KeylessBadge.Parent = Header
Instance.new("UICorner", KeylessBadge).CornerRadius = UDim.new(0, 5)

-- ウィンドウ操作ボタン
local function createWindowButton(text, posX, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, posX, 0, 10)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = color
    btn.TextSize = 20
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Header
    btn.MouseButton1Click:Connect(function() if text == "X" then ScreenGui:Destroy() end end)
end
createWindowButton("-", -100, Color3.fromRGB(200, 200, 200))
createWindowButton("[ ]", -60, Color3.fromRGB(200, 200, 200))
createWindowButton("X", -20, Color3.fromRGB(200, 100, 255))

-- サイドバー
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

local menuItems = {"Home", "Discord", "New Update", "Donate", "Features", "Main", "Misc"}
for i, itemName in ipairs(menuItems) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 20, 0, i * 35)
    btn.BackgroundTransparency = 1
    btn.Text = "  " .. itemName 
    btn.TextColor3 = Color3.fromRGB(200, 200, 220)
    btn.TextSize = 16
    btn.Font = Enum.Font.Gotham
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Parent = Sidebar
    
    -- 小さなアイコン風の点
    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 12, 0, 12)
    icon.Position = UDim2.new(0, 0, 0.5, -6)
    icon.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
    icon.BackgroundTransparency = 0.3
    icon.Parent = btn
    Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 3)

    btn.MouseEnter:Connect(function() btn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
    btn.MouseLeave:Connect(function() btn.TextColor3 = Color3.fromRGB(200, 200, 220) end)
end

-- 中央コンテンツ (Developer など)
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
DevTitle.TextSize = 24
DevTitle.Font = Enum.Font.GothamBold
DevTitle.Parent = Content

local CaoModFrame = Instance.new("Frame")
CaoModFrame.Size = UDim2.new(1, -20, 0, 60)
CaoModFrame.Position = UDim2.new(0, 10, 0, 60)
CaoModFrame.BackgroundTransparency = 1
CaoModFrame.Parent = Content

local CaoModIcon = Instance.new("ImageLabel")
CaoModIcon.Size = UDim2.new(0, 40, 0, 40)
CaoModIcon.Position = UDim2.new(0, 0, 0.5, -20)
CaoModIcon.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
CaoModIcon.Parent = CaoModFrame
Instance.new("UICorner", CaoModIcon).CornerRadius = UDim.new(1, 0)
CaoModIcon.Image = "rbxassetid://17384785064" -- 仮のアイコン

local CaoModTitle = Instance.new("TextLabel")
CaoModTitle.Size = UDim2.new(1, -50, 0, 20)
CaoModTitle.Position = UDim2.new(0, 50, 0, 5)
CaoModTitle.BackgroundTransparency = 1
CaoModTitle.Text = "Cao Mod"
CaoModTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
CaoModTitle.TextSize = 18
CaoModTitle.Font = Enum.Font.GothamBold
CaoModTitle.TextXAlignment = Enum.TextXAlignment.Left
CaoModTitle.Parent = CaoModFrame

local CaoModDesc = Instance.new("TextLabel")
CaoModDesc.Size = UDim2.new(1, -50, 0, 20)
CaoModDesc.Position = UDim2.new(0, 50, 0, 30)
CaoModDesc.BackgroundTransparency = 1
CaoModDesc.Text = "Script Developer & Owner"
CaoModDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
CaoModDesc.TextSize = 14
CaoModDesc.Font = Enum.Font.Gotham
CaoModDesc.TextXAlignment = Enum.TextXAlignment.Left
CaoModDesc.Parent = CaoModFrame

-- 下部のテキスト
local Footer = Instance.new("Frame")
Footer.Size = UDim2.new(1, -20, 0, 60)
Footer.Position = UDim2.new(0, 10, 1, -80)
Footer.BackgroundTransparency = 1
Footer.Parent = Content

local FooterTitle = Instance.new("TextLabel")
FooterTitle.Size = UDim2.new(1, 0, 0, 20)
FooterTitle.BackgroundTransparency = 1
FooterTitle.Text = "Community unavailable"
FooterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
FooterTitle.TextSize = 16
FooterTitle.Font = Enum.Font.GothamBold
FooterTitle.TextXAlignment = Enum.TextXAlignment.Left
FooterTitle.Parent = Footer

local FooterDesc = Instance.new("TextLabel")
FooterDesc.Size = UDim2.new(1, 0, 0, 40)
FooterDesc.Position = UDim2.new(0, 0, 0, 20)
FooterDesc.BackgroundTransparency = 1
FooterDesc.Text = "Discord did not return server information.\nUse Refresh stats to try again."
FooterDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
FooterDesc.TextSize = 13
FooterDesc.Font = Enum.Font.Gotham
FooterDesc.TextWrapped = true
FooterDesc.TextXAlignment = Enum.TextXAlignment.Left
FooterDesc.TextYAlignment = Enum.TextYAlignment.Top
FooterDesc.Parent = Footer

-- ドラッグ移動
local dragging = false
local dragInput, dragStart, startPos
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
