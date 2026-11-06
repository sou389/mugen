-- Delta Executor 用 拡大UI & スピードチェンジャー
-- 特徴: 大きなUI、ドラッグ移動可能、4段階のスピード調整

local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- スピードの段階設定 (通常, 2倍, 4倍, 8倍)
local speedStages = {16, 32, 64, 128}
local currentSpeedIndex = 1
local speedNames = {"通常", "2倍", "4倍", "8倍"}

-- UIの作成
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaSpeedUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = player:WaitForChild("PlayerGui")

-- メインフレーム (大きく設定)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 380) -- 大きくしました
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -190)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true -- ドラッグで移動可能
mainFrame.Parent = screenGui

-- 角を丸くする
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

-- タイトル
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "スピードチェンジャー"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

-- 現在の速度表示
local speedDisplay = Instance.new("TextLabel")
speedDisplay.Size = UDim2.new(0.8, 0, 0, 80)
speedDisplay.Position = UDim2.new(0.1, 0, 0, 70)
speedDisplay.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
speedDisplay.TextColor3 = Color3.fromRGB(0, 255, 150)
speedDisplay.TextScaled = true
speedDisplay.Font = Enum.Font.GothamBold
speedDisplay.Text = "現在: 通常 (16)"
speedDisplay.Parent = mainFrame

local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 8)
speedCorner.Parent = speedDisplay

-- プラスボタン (速度アップ)
local increaseBtn = Instance.new("TextButton")
increaseBtn.Size = UDim2.new(0.35, 0, 0, 80)
increaseBtn.Position = UDim2.new(0.1, 0, 0, 180)
increaseBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
increaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
increaseBtn.TextScaled = true
increaseBtn.Font = Enum.Font.GothamBold
increaseBtn.Text = "+ 速度アップ"
increaseBtn.Parent = mainFrame

local incCorner = Instance.new("UICorner")
incCorner.CornerRadius = UDim.new(0, 8)
incCorner.Parent = increaseBtn

-- マイナスボタン (速度ダウン)
local decreaseBtn = Instance.new("TextButton")
decreaseBtn.Size = UDim2.new(0.35, 0, 0, 80)
decreaseBtn.Position = UDim2.new(0.55, 0, 0, 180)
decreaseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
decreaseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
decreaseBtn.TextScaled = true
decreaseBtn.Font = Enum.Font.GothamBold
decreaseBtn.Text = "- 速度ダウン"
decreaseBtn.Parent = mainFrame

local decCorner = Instance.new("UICorner")
decCorner.CornerRadius = UDim.new(0, 8)
decCorner.Parent = decreaseBtn

-- 閉じるボタン
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0.8, 0, 0, 50)
closeBtn.Position = UDim2.new(0.1, 0, 0, 300)
closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextScaled = true
closeBtn.Font = Enum.Font.Gotham
closeBtn.Text = "UIを閉じる"
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 8)
closeCorner.Parent = closeBtn

-- 速度更新関数
local function updateSpeed()
    if humanoid and humanoid.Parent then
        humanoid.WalkSpeed = speedStages[currentSpeedIndex]
        speedDisplay.Text = "現在: " .. speedNames[currentSpeedIndex] .. " (" .. speedStages[currentSpeedIndex] .. ")"
    end
end

-- ボタンイベント
increaseBtn.MouseButton1Click:Connect(function()
    if currentSpeedIndex < #speedStages then
        currentSpeedIndex = currentSpeedIndex + 1
        updateSpeed()
    end
end)

decreaseBtn.MouseButton1Click:Connect(function()
    if currentSpeedIndex > 1 then
        currentSpeedIndex = currentSpeedIndex - 1
        updateSpeed()
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- 初期化
updateSpeed()
