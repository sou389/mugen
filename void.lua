-- ========================================================
-- void UI (Steal An Egg Clone / 背景画像対応版)
-- ========================================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local oldUI = CoreGui:FindFirstChild("voidUI")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "voidUI"
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

-- ★★★ 背景イラスト（画像IDを変更可能） ★★★
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://13185982376" -- アニメ風の仮画像
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = MainFrame

-- 紫のグラデーションオーバーレイ
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
Overlay.BackgroundTransparency = 0.4
Overlay.BorderSizePixel = 0
Overlay.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 60, 200)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 80))
}
UIGradient.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 0.2),
    NumberSequenceKeypoint.new(1, 0.6)
}
UIGradient.Rotation = 45
UIGradient.Parent = Overlay

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(200, 150, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.4
UIStroke.Parent = MainFrame

-- ヘッダー
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 250, 1, 0)
Title.Position = UDim2.new(0, 70, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "void - Steal An Egg"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 200, 1, 0)
SubTitle.Position = UDim2.new(0, 70, 0, 15)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "void.top"
SubTitle.TextColor3 = Color3.fromRGB(200, 200, 200)
SubTitle.TextSize = 12
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local KeylessBadge = Instance.new("TextLabel")
KeylessBadge.Size = UDim2.new(0, 80, 0, 25)
KeylessBadge.Position = UDim2.new(0, 280, 0, 12)
KeylessBadge.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
KeylessBadge.Text = "Keyless"
KeylessBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
KeylessBadge.TextSize = 14
KeylessBadge.Font = Enum.Font.GothamBold
KeylessBadge.Parent = Header

local BadgeCorner = Instance.new("UICorner")
BadgeCorner.CornerRadius = UDim.new(0, 5)
BadgeCorner.Parent = KeylessBadge

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
    btn.MouseButton1Click:Connect(function()
        if text == "X" then ScreenGui:Destroy() end
    end)
end
createWindowButton("-", -100, Color3.fromRGB(200, 200, 200))
createWindowButton("[ ]", -60, Color3.fromRGB(200, 200, 200))
createWindowButton("X", -20, Color3.fromRGB(255, 100, 100))

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
    
    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 15, 0, 15)
    icon.Position = UDim2.new(0, 0, 0.5, -7.5)
    icon.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
    icon.BackgroundTransparency = 0.5
    icon.Parent = btn
    local c = Instance.new("UICorner", icon)
    c.CornerRadius = UDim.new(0, 3)

    btn.MouseEnter:Connect(function() btn.TextColor3 = Color3.fromRGB(255, 255, 255) end)
    btn.MouseLeave:Connect(function() btn.TextColor3 = Color3.fromRGB(200, 200, 220) end)
end

-- 中央コンテンツ
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

local VoidFrame = Instance.new("Frame")
VoidFrame.Size = UDim2.new(1, -20, 0, 60)
VoidFrame.Position = UDim2.new(0, 10, 0, 60)
VoidFrame.BackgroundTransparency = 1
VoidFrame.Parent = Content

local VoidTitle = Instance.new("TextLabel")
VoidTitle.Size = UDim2.new(1, -50, 0, 20)
VoidTitle.Position = UDim2.new(0, 0, 0, 5)
VoidTitle.BackgroundTransparency = 1
VoidTitle.Text = "void"
VoidTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
VoidTitle.TextSize = 18
VoidTitle.Font = Enum.Font.GothamBold
VoidTitle.TextXAlignment = Enum.TextXAlignment.Left
VoidTitle.Parent = VoidFrame

local VoidDesc = Instance.new("TextLabel")
VoidDesc.Size = UDim2.new(1, -50, 0, 20)
VoidDesc.Position = UDim2.new(0, 0, 0, 30)
VoidDesc.BackgroundTransparency = 1
VoidDesc.Text = "Script Developer & Owner"
VoidDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
VoidDesc.TextSize = 14
VoidDesc.Font = Enum.Font.Gotham
VoidDesc.TextXAlignment = Enum.TextXAlignment.Left
VoidDesc.Parent = VoidFrame

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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
