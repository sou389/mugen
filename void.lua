local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 既存の古いUIを確実に削除
for _, v in pairs(playerGui:GetChildren()) do
    if v:IsA("ScreenGui") and v.Name == "PhotoReplicaGui" then
        v:Destroy()
    end
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PhotoReplicaGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

-- ★画像のみを表示
local background = Instance.new("ImageLabel")
background.Size = UDim2.new(1, 0, 1, 0) -- 画面いっぱい
background.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
background.Image = "rbxassetid://140280744855473" 
background.ScaleType = Enum.ScaleType.Fit -- またはCrop。Fitだと全体が見える
background.Parent = screenGui

-- 画面右上の「✕」閉じるボタン（これだけはないと困るので）
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 40, 0, 40)
closeBtn.Position = UDim2.new(1, -50, 0, 50)
closeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = screenGui
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(1, 0)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)
