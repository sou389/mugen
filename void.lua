local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- 背景の円（黒）
local Circle = Instance.new("Frame")
Circle.Parent = ScreenGui
Circle.Size = UDim2.new(0, 150, 0, 150)
Circle.Position = UDim2.new(0.5, -75, 0.5, -75)
Circle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Circle.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(1, 0) -- 完全な円にする
UICorner.Parent = Circle

-- 紫の枠線（ネオンっぽく）
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = Circle
UIStroke.Color = Color3.fromRGB(170, 0, 255) -- 紫色
UIStroke.Thickness = 5
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- Vの文字
local VText = Instance.new("TextLabel")
VText.Parent = Circle
VText.BackgroundTransparency = 1
VText.Size = UDim2.new(1, 0, 1, 0)
VText.Text = "V"
VText.TextColor3 = Color3.fromRGB(230, 200, 255) -- 光る薄紫
VText.TextSize = 100
VText.Font = Enum.Font.FredokaOne -- 太めのフォント
VText.TextStrokeTransparency = 0 -- 文字の縁取り
VText.TextStrokeColor3 = Color3.fromRGB(255, 255, 255)

-- 発光エフェクト（文字を脈打たせる）
local TweenService = game:GetService("TweenService")
local pulseInfo = TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
local pulseTween = TweenService:Create(VText, pulseInfo, {TextTransparency = 0.3})
pulseTween:Play()
