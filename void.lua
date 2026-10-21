-- ========================================================
-- void UI (99日間有効スクリプト)
-- ========================================================

local CoreGui = game:GetService("CoreGui")
local old = CoreGui:FindFirstChild("VoidUI")
if old then old:Destroy() end

-- 有効期限の設定（実行した日から99日後）
local startDate = os.time()
local expireDate = startDate + (99 * 24 * 60 * 60) -- 99日

local sg = Instance.new("ScreenGui")
sg.Name = "VoidUI"
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

-- 背景画像（光る狼）
local bg = Instance.new("ImageLabel", main)
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundTransparency = 1
bg.Image = "rbxassetid://10154837654"
bg.ScaleType = Enum.ScaleType.Crop

-- 半透明オーバーレイ
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
title.Text = "void - 99 Days"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left

local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -40, 0, 10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)

-- 期限切れチェックループ
task.spawn(function()
    while sg.Parent do
        if os.time() > expireDate then
            if sg then sg:Destroy() end
            break
        end
        task.wait(60) -- 1分ごとにチェック
    end
end)

-- コンテンツ
local content = Instance.new("Frame", main)
content.Size = UDim2.new(1, -40, 1, -70)
content.Position = UDim2.new(0, 20, 0, 60)
content.BackgroundTransparency = 1

local title2 = Instance.new("TextLabel", content)
title2.Size = UDim2.new(1, 0, 0, 30)
title2.BackgroundTransparency = 1
title2.Text = "Status: Active (99 Days)"
title2.TextColor3 = Color3.fromRGB(100, 255, 100)
title2.TextSize = 20
title2.Font = Enum.Font.GothamBold

local desc = Instance.new("TextLabel", content)
desc.Size = UDim2.new(1, 0, 0, 50)
desc.Position = UDim2.new(0, 0, 0, 40)
desc.BackgroundTransparency = 1
desc.Text = "このスクリプトは99日間有効です。\n期限が切れると自動的にUIが消えます。"
desc.TextColor3 = Color3.fromRGB(220, 220, 220)
desc.TextSize = 14
desc.Font = Enum.Font.Gotham
desc.TextWrapped = true
desc.TextXAlignment = Enum.TextXAlignment.Left

-- ドラッグ
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
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement or dragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
