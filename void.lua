-- ==========================================
-- 準備とお掃除
-- ==========================================
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

for _, v in pairs(PlayerGui:GetChildren()) do
    if v.Name == "VoidUniversalUI" then v:Destroy() end
end

-- ==========================================
-- 1. 起動用のボタン（画面右上）
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidUniversalUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 80, 0, 40)
OpenBtn.Position = UDim2.new(1, -90, 0, 10) 
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.Text = "Void"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 20
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.BorderSizePixel = 0

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = OpenBtn

-- ==========================================
-- 2. 画像そっくりのポップアップ（確認画面）
-- ==========================================
local PopupFrame = Instance.new("Frame")
PopupFrame.Parent = ScreenGui
PopupFrame.Size = UDim2.new(0, 500, 0, 220) -- 画像と同じ比率
PopupFrame.Position = UDim2.new(0.5, -250, 0.5, -110)
PopupFrame.BackgroundColor3 = Color3.fromRGB(20, 45, 60) -- 画像の紺色
PopupFrame.BackgroundTransparency = 0.15
PopupFrame.BorderSizePixel = 0
PopupFrame.Visible = false

local PopupCorner = Instance.new("UICorner")
PopupCorner.CornerRadius = UDim.new(0, 4) -- 画像は角がほぼ直角
PopupCorner.Parent = PopupFrame

-- 真ん中の仕切り線
local Divider = Instance.new("Frame")
Divider.Parent = PopupFrame
Divider.Size = UDim2.new(1, 0, 0, 2)
Divider.Position = UDim2.new(0, 0, 0.6, 0)
Divider.BackgroundColor3 = Color3.fromRGB(35, 65, 80)
Divider.BorderSizePixel = 0

-- 上部のテキスト「実行しますか？」
local PopupText = Instance.new("TextLabel")
PopupText.Parent = PopupFrame
PopupText.Size = UDim2.new(1, -40, 0.6, 0)
PopupText.Position = UDim2.new(0, 20, 0, 0)
PopupText.BackgroundTransparency = 1
PopupText.Text = "実行しますか？"
PopupText.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupText.TextSize = 28
PopupText.Font = Enum.Font.GothamBold
PopupText.TextXAlignment = Enum.TextXAlignment.Left
PopupText.TextYAlignment = Enum.TextYAlignment.Center

-- 「実行」ボタンエリア
local ExecBtn = Instance.new("TextButton")
ExecBtn.Parent = PopupFrame
ExecBtn.Size = UDim2.new(0.5, 0, 0.4, 0)
ExecBtn.Position = UDim2.new(0, 0, 0.6, 0)
ExecBtn.BackgroundTransparency = 1
ExecBtn.Text = ""

-- 実行の丸い背景
local ExecCircle = Instance.new("Frame")
ExecCircle.Parent = ExecBtn
ExecCircle.Size = UDim2.new(0, 100, 0, 100) -- 画像のような大きな丸
ExecCircle.Position = UDim2.new(0.5, -50, 0.5, -50)
ExecCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ExecCircle.BackgroundTransparency = 0.7
ExecCircle.BorderSizePixel = 0
local ExecCircleCorner = Instance.new("UICorner")
ExecCircleCorner.CornerRadius = UDim.new(1, 0)
ExecCircleCorner.Parent = ExecCircle

-- 実行の文字
local ExecText = Instance.new("TextLabel")
ExecText.Parent = ExecBtn
ExecText.Size = UDim2.new(1, 0, 1, 0)
ExecText.BackgroundTransparency = 1
ExecText.Text = "実行"
ExecText.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecText.TextSize = 24
ExecText.Font = Enum.Font.GothamBold
ExecText.ZIndex = 2

-- 「閉じる」ボタンエリア
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = PopupFrame
CloseBtn.Size = UDim2.new(0.5, 0, 0.4, 0)
CloseBtn.Position = UDim2.new(0.5, 0, 0.6, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = ""

-- 閉じるの丸い背景
local CloseCircle = Instance.new("Frame")
CloseCircle.Parent = CloseBtn
CloseCircle.Size = UDim2.new(0, 100, 0, 100)
CloseCircle.Position = UDim2.new(0.5, -50, 0.5, -50)
CloseCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseCircle.BackgroundTransparency = 0.7
CloseCircle.BorderSizePixel = 0
local CloseCircleCorner = Instance.new("UICorner")
CloseCircleCorner.CornerRadius = UDim.new(1, 0)
CloseCircleCorner.Parent = CloseCircle

-- 閉じるの文字
local CloseText = Instance.new("TextLabel")
CloseText.Parent = CloseBtn
CloseText.Size = UDim2.new(1, 0, 1, 0)
CloseText.BackgroundTransparency = 1
CloseText.Text = "閉じる"
CloseText.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseText.TextSize = 24
CloseText.Font = Enum.Font.GothamBold
CloseText.ZIndex = 2

-- ==========================================
-- 3. 実行後の大きな「void」UI
-- ==========================================
local MainUI = Instance.new("Frame")
MainUI.Parent = ScreenGui
MainUI.Size = UDim2.new(0, 450, 0, 220) -- ご要望通りデカくしました
MainUI.Position = UDim2.new(0.5, -225, 0.5, -110)
MainUI.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainUI.BackgroundTransparency = 0.4 -- 薄い透明
MainUI.BorderSizePixel = 0
MainUI.Visible = false 

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 12)
MainUICorner.Parent = MainUI

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainUI
MainStroke.Color = Color3.fromRGB(150, 0, 255)
MainStroke.Thickness = 2

-- 左に「void」
local MainText = Instance.new("TextLabel")
MainText.Parent = MainUI
MainText.BackgroundTransparency = 1
MainText.Size = UDim2.new(1, -30, 0, 60)
MainText.Position = UDim2.new(0, 30, 0, 20)
MainText.Text = "void"
MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
MainText.TextSize = 50
MainText.Font = Enum.Font.GothamBold
MainText.TextXAlignment = Enum.TextXAlignment.Left

-- ドラッグ機能（スマホ対応）
local dragging, dragInput, dragStart, startPos
MainUI.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainUI.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
MainUI.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ==========================================
-- 4. 動作設定
-- ==========================================
OpenBtn.MouseButton1Click:Connect(function()
    PopupFrame.Visible = true
    OpenBtn.Visible = false
end)

CloseBtn.MouseButton1Click:Connect(function()
    PopupFrame.Visible = false
    OpenBtn.Visible = true
end)

ExecBtn.MouseButton1Click:Connect(function()
    PopupFrame.Visible = false
    MainUI.Visible = true
end)
