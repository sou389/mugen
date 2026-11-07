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

-- ★背景：あなたが取得した青い狼の画像のみを表示
local background = Instance.new("ImageLabel")
background.Size = UDim2.new(1, 0, 0.85, 0) -- 下のテキスト部分を空けるため少し高さを調整
background.Position = UDim2.new(0, 0, 0, 0)
background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
background.Image = "rbxassetid://140280744855473" -- あなたのID
background.ScaleType = Enum.ScaleType.Crop
background.Parent = screenGui

-- 画面右上の「✕」閉じるボタン
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 50) -- 右上に配置
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = screenGui
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

-- 下部のテキスト（大人かっこいい壁紙...）
local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(0.65, 0, 0.1, 0)
titleText.Position = UDim2.new(0.05, 0, 0.87, 0) -- 画面下部に配置
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
moveBtn.Position = UDim2.new(0.73, 0, 0.86, 0)
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
shareBtn.Position = UDim2.new(0.05, 0, 0.94, 0)
shareBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
shareBtn.Text = "共有"
shareBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
shareBtn.Font = Enum.Font.Gotham
shareBtn.Parent = screenGui
Instance.new("UICorner", shareBtn).CornerRadius = UDim.new(1, 0)

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(0.42, 0, 0.06, 0)
saveBtn.Position = UDim2.new(0.53, 0, 0.94, 0)
saveBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
saveBtn.Text = "保存"
saveBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
saveBtn.Font = Enum.Font.Gotham
saveBtn.Parent = screenGui
Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(1, 0)

-- 左端のカメラアイコン（Googleレンズ風）
local cameraBtn = Instance.new("TextButton")
cameraBtn.Size = UDim2.new(0, 50, 0, 50)
cameraBtn.Position = UDim2.new(0.05, 0, 0.75, 0)
cameraBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
cameraBtn.Text = "📷"
cameraBtn.TextSize = 24
cameraBtn.Parent = screenGui
Instance.new("UICorner", cameraBtn).CornerRadius = UDim.new(1, 0)

-- 閉じる処理
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
