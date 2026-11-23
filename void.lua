local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "PotatoHub"
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(260, 190)
main.Position = UDim2.new(0.5, -130, 0.4, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
title.Text = "POTATO HUB"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 21
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(40, 45)
close.Position = UDim2.new(1, -40, 0, 0)
close.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.TextSize = 20
close.Parent = main

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, -20, 0, 40)
status.Position = UDim2.fromOffset(10, 55)
status.BackgroundTransparency = 1
status.Text = "状態：待機中"
status.TextColor3 = Color3.new(1, 1, 1)
status.TextSize = 16
status.Parent = main

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -30, 0, 45)
button.Position = UDim2.fromOffset(15, 115)
button.BackgroundColor3 = Color3.fromRGB(45, 100, 65)
button.Text = "自動販売 ON / OFF"
button.TextColor3 = Color3.new(1, 1, 1)
button.TextSize = 16
button.Parent = main

local enabled = false

button.Activated:Connect(function()
    enabled = not enabled
    status.Text = enabled and "状態：ON" or "状態：OFF"
end)

close.Activated:Connect(function()
    gui:Destroy()
end)

-- タイトルをドラッグして移動
local dragging = false
local dragStart, startPos

title.Active = true

title.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = main.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if dragging and (
        input.UserInputType == Enum.UserInputType.Touch
        or input.UserInputType == Enum.UserInputType.MouseMovement
    ) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

gui.Parent = player:WaitForChild("PlayerGui")
