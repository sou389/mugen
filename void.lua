-- ========================================================
-- 文字なしUI + Viod最小化ボタン
-- ========================================================

local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

local oldUI = CoreGui:FindFirstChild("FoxnameUI")
if oldUI then oldUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "FoxnameUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- ==========================================
-- メインUI (文字をすべて消した状態)
-- ==========================================
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 600, 0, 350)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(68, 51, 119) -- 画像の紫色
MainFrame.BackgroundTransparency = 0.4
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- 背景イラスト
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = "rbxassetid://17384785064" 
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = MainFrame

-- 半透明のオーバーレイ
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
Overlay.BackgroundTransparency = 0.3
Overlay.Parent = MainFrame

-- ヘッダー（中身は空っぽ）
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

-- アイコン（文字はなし）
local TopIcon = Instance.new("Frame")
TopIcon.Size = UDim2.new(0, 30, 0, 30)
TopIcon.Position = UDim2.new(0, 15, 0, 10)
TopIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TopIcon.BackgroundTransparency = 0.5
TopIcon.Parent = Header
Instance.new("UICorner", TopIcon).CornerRadius = UDim.new(1, 0)

-- Keylessバッジ（文字はなし）
local KeylessBadge = Instance.new("Frame")
KeylessBadge.Size = UDim2.new(0, 70, 0, 25)
KeylessBadge.Position = UDim2.new(0, 55, 0, 12)
KeylessBadge.BackgroundColor3 = Color3.fromRGB(50, 120, 255)
KeylessBadge.BackgroundTransparency = 0.2
KeylessBadge.Parent = Header
Instance.new("UICorner", KeylessBadge).CornerRadius = UDim.new(0, 5)

-- 右上のウィンドウ操作ボタン（記号のみ）
local function createWindowButton(text, posX, color)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 30, 0, 30)
    btn.Position = UDim2.new(1, posX, 0, 10)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = color
    btn.TextSize = 18
    btn.Font = Enum.Font.GothamBold
    btn.Parent = Header
    
    btn.MouseButton1Click:Connect(function()
        if text == "X" then
            MainFrame.Visible = false
            VoidToggleButton.Visible = true
        end
    end)
end
createWindowButton("-", -100, Color3.fromRGB(200, 200, 200))
createWindowButton("[]", -60, Color3.fromRGB(200, 200, 200))
createWindowButton("X", -20, Color3.fromRGB(200, 100, 255))

-- サイドバー（文字はなし、アイコンの四角のみ）
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 150, 1, -50)
Sidebar.Position = UDim2.new(0, 0, 0, 50)
Sidebar.BackgroundTransparency = 1
Sidebar.Parent = MainFrame

for i = 1, 7 do
    local icon = Instance.new("Frame")
    icon.Size = UDim2.new(0, 15, 0, 15)
    icon.Position = UDim2.new(0, 20, 0, i * 35)
    icon.BackgroundColor3 = Color3.fromRGB(200, 150, 255)
    icon.BackgroundTransparency = 0.5
    icon.Parent = Sidebar
    Instance.new("UICorner", icon).CornerRadius = UDim.new(0, 4)
end

-- 中央コンテンツ（文字はなし、丸いアイコンだけ）
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -170, 1, -60)
Content.Position = UDim2.new(0, 160, 0, 50)
Content.BackgroundTransparency = 1
Content.Parent = MainFrame

local CaoModIcon = Instance.new("Frame")
CaoModIcon.Size = UDim2.new(0, 40, 0, 40)
CaoModIcon.Position = UDim2.new(0, 50, 0, 60)
CaoModIcon.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
CaoModIcon.BackgroundTransparency = 0.5
CaoModIcon.Parent = Content
Instance.new("UICorner", CaoModIcon).CornerRadius = UDim.new(1, 0)

-- ==========================================
-- 「Viod」ボタン（閉じた時に表示されるUI）
-- ==========================================
local VoidToggleButton = Instance.new("TextButton")
VoidToggleButton.Size = UDim2.new(0, 80, 0, 30)
VoidToggleButton.Position = UDim2.new(0.5, 0, 0, 10) 
VoidToggleButton.AnchorPoint = Vector2.new(0.5, 0)
VoidToggleButton.BackgroundColor3 = Color3.fromRGB(60, 40, 120)
VoidToggleButton.Text = "Viod"
VoidToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VoidToggleButton.Font = Enum.Font.GothamBold
VoidToggleButton.TextSize = 16
VoidToggleButton.Visible = false
VoidToggleButton.Parent = ScreenGui

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 6)
ToggleCorner.Parent = VoidToggleButton

local ToggleStroke = Instance.new("UIStroke")
ToggleStroke.Color = Color3.fromRGB(150, 100, 255)
ToggleStroke.Thickness = 1.5
ToggleStroke.Parent = VoidToggleButton

-- 「Viod」ボタンを押した時の処理
VoidToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    VoidToggleButton.Visible = false
end)

-- ドラッグ移動
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
