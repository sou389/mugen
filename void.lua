
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "ComboPractice"
gui.ResetOnSpawn = false

local main = Instance.new("Frame")
main.Size = UDim2.fromOffset(280, 300)
main.Position = UDim2.new(0.5, -140, 0.35, 0)
main.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
main.BorderSizePixel = 0
main.Active = true
main.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -45, 0, 45)
title.BackgroundColor3 = Color3.fromRGB(120, 20, 30)
title.Text = "COMBO PRACTICE"
title.TextColor3 = Color3.new(1, 1, 1)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.Parent = main

local close = Instance.new("TextButton")
close.Size = UDim2.fromOffset(40, 40)
close.Position = UDim2.new(1, -43, 0, 2)
close.Text = "X"
close.TextColor3 = Color3.new(1, 1, 1)
close.BackgroundColor3 = Color3.fromRGB(65, 20, 25)
close.Parent = main

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 45)
info.Position = UDim2.fromOffset(10, 50)
info.BackgroundTransparency = 1
info.Text = "練習するコンボを選ぼう"
info.TextColor3 = Color3.new(1, 1, 1)
info.TextSize = 15
info.Parent = main

local combos = {
    {
        name = "基本コンボ",
        steps = "通常攻撃 × 3 → 追撃"
    },
    {
        name = "アッパー練習",
        steps = "通常攻撃 → アッパー"
    },
    {
        name = "吹き飛ばし練習",
        steps = "通常攻撃 → 吹き飛ばし"
    },
    {
        name = "自分のコンボ",
        steps = "順番を決めて練習しよう"
    }
}

for i, combo in ipairs(combos) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 42)
    btn.Position = UDim2.fromOffset(12, 100 + (i - 1) * 47)
    btn.BackgroundColor3 = Color3.fromRGB(45, 25, 30)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 15
    btn.Text = combo.name
    btn.Parent = main

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn

    btn.Activated:Connect(function()
        info.Text = combo.steps
    end)
end

close.Activated:Connect(function()
    gui:Destroy()
end)

gui.Parent = player:WaitForChild("PlayerGui")
