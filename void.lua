
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ComboPractice"
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(290, 365)
main.Position = UDim2.new(0.5, -145, 0.3, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 19)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = obj
end
corner(main, 10)

local title = Instance.new("TextButton")
title.Size = UDim2.new(1, -42, 0, 42)
title.BackgroundColor3 = Color3.fromRGB(135, 25, 35)
title.Text = "COMBO PRACTICE  |  長押し移動"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 13
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(42, 42)
close.Position = UDim2.new(1, -42, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(75, 20, 25)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.Parent = main

local targetLabel = Instance.new("TextLabel")
targetLabel.Size = UDim2.new(1, -20, 0, 28)
targetLabel.Position = UDim2.fromOffset(10, 48)
targetLabel.BackgroundTransparency = 1
targetLabel.Text = "練習相手：未選択"
targetLabel.TextColor3 = Color3.new(1, 1, 1)
targetLabel.TextSize = 14
targetLabel.Parent = main

local distanceLabel = Instance.new("TextLabel")
distanceLabel.Size = UDim2.new(1, -20, 0, 25)
distanceLabel.Position = UDim2.fromOffset(10, 76)
distanceLabel.BackgroundTransparency = 1
distanceLabel.Text = "距離：--"
distanceLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
distanceLabel.TextSize = 14
distanceLabel.Parent = main

local list = Instance.new("ScrollingFrame")
list.Size = UDim2.new(1, -20, 0, 105)
list.Position = UDim2.fromOffset(10, 105)
list.BackgroundColor3 = Color3.fromRGB(27, 27, 33)
list.BorderSizePixel = 0
list.ScrollBarThickness = 5
list.AutomaticCanvasSize = Enum.AutomaticSize.Y
list.CanvasSize = UDim2.new(0, 0, 0, 0)
list.Parent = main
corner(list, 6)

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.Parent = list

local comboLabel = Instance.new("TextLabel")
comboLabel.Size = UDim2.new(1, -20, 0, 48)
comboLabel.Position = UDim2.fromOffset(10, 220)
comboLabel.BackgroundColor3 = Color3.fromRGB(40, 22, 27)
comboLabel.TextColor3 = Color3.new(1, 1, 1)
comboLabel.TextWrapped = true
comboLabel.Text = "コンボ：通常攻撃 × 3 → 追撃"
comboLabel.TextSize = 14
comboLabel.Parent = main
corner(comboLabel, 6)

local nextButton = Instance.new("TextButton")
nextButton.Size = UDim2.new(1, -20, 0, 38)
nextButton.Position = UDim2.fromOffset(10, 278)
nextButton.BackgroundColor3 = Color3.fromRGB(135, 25, 35)
nextButton.TextColor3 = Color3.new(1, 1, 1)
nextButton.Text = "次のコンボ"
nextButton.Parent = main
corner(nextButton, 6)

local refresh = Instance.new("TextButton")
refresh.Size = UDim2.new(1, -20, 0, 32)
refresh.Position = UDim2.fromOffset(10, 323)
refresh.BackgroundColor3 = Color3.fromRGB(45, 45, 52)
refresh.TextColor3 = Color3.new(1, 1, 1)
refresh.Text = "相手一覧を更新"
refresh.Parent = main
corner(refresh, 6)

local selected
local combos = {
    "通常攻撃 × 3 → 追撃",
    "通常攻撃 → アッパー",
    "通常攻撃 → 吹き飛ばし",
    "相手の隙を見てコンボ開始"
}
local comboIndex = 1

local function getRoot(plr)
    local char = plr.Character
    return char and char:FindFirstChild("HumanoidRootPart")
end

local function updateDistance()
    local a = getRoot(player)
    local b = selected and getRoot(selected)

    if a and b then
        distanceLabel.Text = "距離：" ..
            math.floor((a.Position - b.Position).Magnitude) .. " studs"
    else
        distanceLabel.Text = "距離：--"
    end
end

local function rebuildList()
    for _, child in ipairs(list:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -8, 0, 30)
            btn.BackgroundColor3 = Color3.fromRGB(65, 25, 30)
            btn.TextColor3 = Color3.new(1, 1, 1)
            btn.Text = plr.DisplayName
            btn.TextSize = 13
            btn.Parent = list

            btn.Activated:Connect(function()
                selected = plr
                targetLabel.Text = "練習相手：" .. plr.DisplayName
                updateDistance()
            end)
        end
    end
end

nextButton.Activated:Connect(function()
    comboIndex = comboIndex % #combos + 1
    comboLabel.Text = "コンボ：" .. combos[comboIndex]
end)

refresh.Activated:Connect(rebuildList)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- タイトルを長押しして移動
local dragging = false
local dragStart
local startPosition
local activeTouch

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPosition = main.Position
        if input.UserInputType == Enum.UserInputType.Touch then
            activeTouch = input
        end
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end

    if input.UserInputType == Enum.UserInputType.MouseMovement
    or input == activeTouch then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale,
            startPosition.X.Offset + delta.X,
            startPosition.Y.Scale,
            startPosition.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
        activeTouch = nil
    end
end)

local distanceConnection = RunService.Heartbeat:Connect(updateDistance)
gui.Destroying:Connect(function()
    distanceConnection:Disconnect()
end)

rebuildList()
gui.Parent = player:WaitForChild("PlayerGui")
