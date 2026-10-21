-- ========================================================
-- 光る狼の背景 + 半透明の紫板
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

-- ★背景イラスト（光る狼）★
local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "BackgroundImage"
BackgroundImage.Size = UDim2.new(1, 0, 1, 0)
BackgroundImage.BackgroundTransparency = 1
-- 光る狼・ネオン系の背景画像ID
BackgroundImage.Image = "rbxassetid://15519020860" 
BackgroundImage.ScaleType = Enum.ScaleType.Crop
BackgroundImage.Parent = MainFrame

-- 紫色の半透明フィルター
local Overlay = Instance.new("Frame")
Overlay.Size = UDim2.new(1, 0, 1, 0)
Overlay.BackgroundColor3 = Color3.fromRGB(68, 51, 119)
Overlay.BackgroundTransparency = 0.4
Overlay.BorderSizePixel = 0
Overlay.Parent = MainFrame

-- ドラッグ移動用の透明なヘッダー
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 50)
Header.BackgroundTransparency = 1
Header.Parent = MainFrame

-- ドラッグ移動機能
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
