local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 既存のGUIを削除
local old = playerGui:FindFirstChild("PhotoReplicaGui")
if old then old:Destroy() end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PhotoReplicaGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

-- ★あなたが取得したIDを背景に設定
local background = Instance.new("ImageLabel")
background.Size = UDim2.new(1, 0, 1, 0)
background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
background.Image = "rbxassetid://140280744855473" -- ←ここに反映済み！
background.ScaleType = Enum.ScaleType.Crop
background.Parent = screenGui

-- 上部のウィンドウ（ジョンポーク）※まだ画像がなければ緑色の枠になります
local topWindow = Instance.new("Frame")
topWindow.Size = UDim2.new(0.5, 0, 0.12, 0)
topWindow.Position = UDim2.new(0.05, 0, 0.02, 0)
topWindow.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
topWindow.BorderSizePixel = 0
topWindow.Parent = screenGui
Instance.new("UICorner", topWindow).CornerRadius = UDim.new(0, 8)

-- ※ジョンポークの画像も表示したい場合は、ここを書き換えます
local johnPorkImage = Instance.new("ImageLabel")
johnPorkImage.Size = UDim2.new(1, 0, 1, 0)
johnPorkImage.BackgroundTransparency = 1
johnPorkImage.Image = "" -- ★ジョンポークのIDを入れる場所
johnPorkImage.ScaleType = Enum.ScaleType.Crop
johnPorkImage.Parent = topWindow

-- 閉じるボタン
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = topWindow
closeBtn.ZIndex = 3

-- 下部のテキスト
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.65, 0, 0.08, 0)
titleText.Position = UDim2.new(0.05, 0, 0.68, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "大人かっこいい壁紙・光の狼のシルエット | AI百科「シンテリ」で調べる..."
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 14
titleText.TextWrapped = true
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.Font = Enum.Font.GothamMedium
titleText.Parent = screenGui

-- 「移動 >」ボタン
local moveBtn = Instance.new("TextButton")
moveBtn.Size = UDim2.new(0.2, 0, 0.06, 0)
moveBtn.Position = UDim2.new(0.73, 0, 0.67, 0)
moveBtn.BackgroundColor3 = Color3.fromRGB(210, 225, 250)
moveBtn.Text = "移動 >"
moveBtn.TextColor3 = Color3.fromRGB(30, 30, 30)
moveBtn.TextSize = 14
moveBtn.Font = Enum.Font.GothamBold
moveBtn.Parent = screenGui
Instance.new("UICorner", moveBtn).CornerRadius = UDim.new(1, 0)

-- 共有・保存ボタン
local shareBtn = Instance.new("TextButton")
shareBtn.Size = UDim2.new(0.42, 0, 0.06, 0)
shareBtn.Position = UDim2.new(0.05, 0, 0.77, 0)
shareBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
shareBtn.Text = "共有"
shareBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
shareBtn.Font = Enum.Font.Gotham
shareBtn.Parent = screenGui
Instance.new("UICorner", shareBtn).CornerRadius = UDim.new(1, 0)

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.42, 0, 0.06, 0)
saveBtn.Position = UDim2.new(0.53, 0, 0.77, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
saveBtn.Text = "保存"
saveBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
saveBtn.Font = Enum.Font.Gotham
saveBtn.Parent = screenGui
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(1, 0)

-- 下部のサムネイル（仮枠）
local thumb1 = Instance.new("Frame")
thumb1.Size = UDim2.new(0.45, 0, 0.12, 0)
thumb1.Position = UDim2.new(0.05, 0, 0.86, 0)
thumb1.BackgroundColor3 = Color3.fromRGB(0, 100, 100)
thumb1.Parent = screenGui
Instance.new("UICorner", thumb1).CornerRadius = UDim.new(0, 10)

local thumb2 = Instance.new("Frame")
thumb2.Size = UDim2.new(0.45, 0, 0.12, 0)
thumb2.Position = UDim2.new(0.52, 0, 0.86, 0)
thumb2.BackgroundColor3 = Color3.fromRGB(100, 50, 0)
thumb2.Parent = screenGui
Instance.new("UICorner", thumb2).CornerRadius = UDim.new(0, 10)

-- ドラッグ機能
local dragging, dragInput, dragStart, startPos
local function update(input)
    local delta = input.Position - dragStart
    topWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
topWindow.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = topWindow.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
topWindow.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then update(input) end
end)

-- 閉じる処理
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
