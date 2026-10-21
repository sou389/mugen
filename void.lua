-- ========================================================
-- void UI (文字・色・枠 完全修正版)
-- ========================================================

local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local old = CoreGui:FindFirstChild("VoidUI")
if old then old:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "VoidUI"
sg.ResetOnSpawn = false
sg.Parent = CoreGui

-- メインフレーム
local main = Instance.new("Frame", sg)
main.Size = UDim2.new(0, 550, 0, 320)
main.Position = UDim2.new(0.5, 0, 0.5, 0)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
main.BorderSizePixel = 0
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 10)

-- 背景画像
local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://10154837654" 
bg.ScaleType = Enum.ScaleType.Crop

-- 紫の半透明オーバーレイ
local ov = Instance.new("Frame", main)
ov.Size = UDim2.new(1, 0, 1, 0)
ov.BackgroundColor3 = Color3.fromRGB(70, 40, 150)
ov.BackgroundTransparency = 0.5
ov.BorderSizePixel = 0

local grad = Instance.new("UIGradient", ov)
grad.Color = ColorSequence.new(Color3.fromRGB(100, 50, 200), Color3.fromRGB(30, 10, 60))
grad.Rotation = 45

local stroke = Instance.new("UIStroke", main)
stroke.Color = Color3.fromRGB(180, 130, 255)
stroke.Thickness = 2
stroke.Transparency = 0.3

-- ヘッダー
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 50)
header.BackgroundTransparency = 1

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(0, 250, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "void"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local keyless = Instance.new("TextLabel", header)
keyless.Size = UDim2.new(0, 70, 0, 25)
keyless.Position = UDim2.new(0, 120, 0, 12)
keyless.BackgroundColor3 = Color3.fromRGB(60, 130, 255)
keyless.Text = "Keyless"
keyless.TextColor3 = Color3.fromRGB(255, 255, 255)
keyless.TextSize = 13
keyless.Font = Enum.Font.GothamBold
Instance.new("UICorner", keyless).CornerRadius = UDim.new(0, 5)

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- ========================================================
-- サイドバー（文字の違和感をなくし、枠をハッキリさせる）
-- ========================================================
local side = Instance.new("Frame", main)
side.Size = UDim2.new(0, 140, 1, -50)
side.Position = UDim2.new(0, 0, 0, 50)
side.BackgroundTransparency = 1

local items = {"Home", "Player"}
for i, name in ipairs(items) do
    -- ボタン本体
    local btn = Instance.new("TextButton", side)
    btn.Size = UDim2.new(1, -20, 0, 40) 
    btn.Position = UDim2.new(0, 10, 0, (i * 50) - 10) 
    
    -- さっきの綺麗な半透明の色に戻す（少し明るめの紫）
    btn.BackgroundColor3 = Color3.fromRGB(80, 50, 140) 
    btn.BackgroundTransparency = 0.3
    
    btn.Text = name
    -- 文字の影（縁取り）を完全にオフにしてスッキリさせる
    btn.TextStrokeTransparency = 1 
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false 

    local btnCorner = Instance.new("UICorner", btn)
    btnCorner.CornerRadius = UDim.new(0, 6)

    -- 白い枠線をハッキリと太めにつける
    local btnStroke = Instance.new("UIStroke", btn)
    btnStroke.Color = Color3.fromRGB(255, 255, 255)
    btnStroke.Thickness = 2
    btnStroke.Transparency = 0 -- 完全に不透明にする

    -- ホバー・クリックエフェクト
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.1}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
    end)
    btn.MouseButton1Click:Connect(function()
        -- 押した時のアニメーション（一瞬明るくする）
        btn.BackgroundColor3 = Color3.fromRGB(150, 100, 220)
        task.wait(0.1)
        btn.BackgroundColor3 = Color3.fromRGB(80, 50, 140)
        
        print(name .. " が押されました")
    end)
end

-- 中央コンテンツ
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -160, 1, -60)
content.Position = UDim2.new(0, 150, 0, 50)
content.BackgroundTransparency = 1

local devTitle = Instance.new("TextLabel", content)
devTitle.Size = UDim2.new(1, 0, 0, 30)
devTitle.Position = UDim2.new(0, 0, 0, 10)
devTitle.BackgroundTransparency = 1
devTitle.Text = "Developer"
devTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
devTitle.TextSize = 22
devTitle.Font = Enum.Font.GothamBold
devTitle.TextXAlignment = Enum.TextXAlignment.Left

local voidName = Instance.new("TextLabel", content)
voidName.Size = UDim2.new(1, 0, 0, 20)
voidName.Position = UDim2.new(0, 0, 0, 50)
voidName.BackgroundTransparency = 1
voidName.Text = "void"
voidName.TextColor3 = Color3.fromRGB(255, 255, 255)
voidName.TextSize = 18
voidName.Font = Enum.Font.GothamBold
voidName.TextXAlignment = Enum.TextXAlignment.Left

local voidDesc = Instance.new("TextLabel", content)
voidDesc.Size = UDim2.new(1, 0, 0, 20)
voidDesc.Position = UDim2.new(0, 0, 0, 75)
voidDesc.BackgroundTransparency = 1
voidDesc.Text = "Script Developer & Owner"
voidDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
voidDesc.TextSize = 14
voidDesc.Font = Enum.Font.Gotham
voidDesc.TextXAlignment = Enum.TextXAlignment.Left

-- 左下の自分のアイコン
local player = Players.LocalPlayer
local profileIcon = Instance.new("ImageLabel", main)
profileIcon.Size = UDim2.new(0, 50, 0, 50)
profileIcon.Position = UDim2.new(0, 15, 1, -65) 
profileIcon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
profileIcon.BorderSizePixel = 0

local iconCorner = Instance.new("UICorner", profileIcon)
iconCorner.CornerRadius = UDim.new(1, 0)

local iconStroke = Instance.new("UIStroke", profileIcon)
iconStroke.Color = Color3.fromRGB(200, 150, 255)
iconStroke.Thickness = 2
iconStroke.Transparency = 0.2

local function updateIcon()
    if player then
        local content, isReady = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        if content then profileIcon.Image = content end
    end
end
updateIcon()
player.CharacterAdded:Connect(function() task.wait(1) updateIcon() end)

-- ドラッグ機能
local dragging = false
local dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)
header.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
