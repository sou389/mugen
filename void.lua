-- ==========================================
-- 1. 準備とお掃除（どのゲームでも安全に動くように）
-- ==========================================
local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- 過去のUIを完全に消去
for _, v in pairs(PlayerGui:GetChildren()) do
    if v.Name == "VoidUniversalUI" then
        v:Destroy()
    end
end

-- UIの土台を作成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidUniversalUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- ==========================================
-- 2. 起動用の「見えるボタン」（右上に配置）
-- ==========================================
local OpenBtn = Instance.new("TextButton")
OpenBtn.Parent = ScreenGui
OpenBtn.Size = UDim2.new(0, 80, 0, 40)
OpenBtn.Position = UDim2.new(1, -90, 0, 10) -- 画面右上
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
OpenBtn.Text = "Void"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.TextSize = 20
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.BorderSizePixel = 0

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = OpenBtn

local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = OpenBtn
UIStroke.Color = Color3.fromRGB(150, 0, 255) -- 紫の枠線
UIStroke.Thickness = 2

-- ==========================================
-- 3. ポップアップ（確認画面）
-- ==========================================
local PopupFrame = Instance.new("Frame")
PopupFrame.Parent = ScreenGui
PopupFrame.Size = UDim2.new(0, 300, 0, 150)
PopupFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
PopupFrame.BackgroundColor3 = Color3.fromRGB(17, 44, 59)
PopupFrame.BorderSizePixel = 0
PopupFrame.Visible = false -- 最初は隠しておく

local PopupCorner = Instance.new("UICorner")
PopupCorner.CornerRadius = UDim.new(0, 8)
PopupCorner.Parent = PopupFrame

local PopupDivider = Instance.new("Frame")
PopupDivider.Parent = PopupFrame
PopupDivider.Size = UDim2.new(1, 0, 0, 2)
PopupDivider.Position = UDim2.new(0, 0, 0.6, 0)
PopupDivider.BackgroundColor3 = Color3.fromRGB(34, 68, 85)
PopupDivider.BorderSizePixel = 0

local PopupText = Instance.new("TextLabel")
PopupText.Parent = PopupFrame
PopupText.Size = UDim2.new(1, -20, 0.6, 0)
PopupText.Position = UDim2.new(0, 15, 0, 0)
PopupText.BackgroundTransparency = 1
PopupText.Text = "実行しますか？"
PopupText.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupText.TextSize = 22
PopupText.Font = Enum.Font.GothamBold
PopupText.TextXAlignment = Enum.TextXAlignment.Left

-- 「実行」ボタン
local ExecBtn = Instance.new("TextButton")
ExecBtn.Parent = PopupFrame
ExecBtn.Size = UDim2.new(0.5, 0, 0.4, 0)
ExecBtn.Position = UDim2.new(0, 0, 0.6, 0)
ExecBtn.BackgroundTransparency = 1
ExecBtn.Text = "実行"
ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecBtn.TextSize = 20
ExecBtn.Font = Enum.Font.GothamBold

-- 「閉じる」ボタン
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = PopupFrame
CloseBtn.Size = UDim2.new(0.5, 0, 0.4, 0)
CloseBtn.Position = UDim2.new(0.5, 0, 0.6, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "閉じる"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold

-- ==========================================
-- 4. メインの「void」UI（実行後に出る）
-- ==========================================
local MainUI = Instance.new("Frame")
MainUI.Parent = ScreenGui
MainUI.Size = UDim2.new(0, 250, 0, 80)
MainUI.Position = UDim2.new(0.5, -125, 0.5, -40)
MainUI.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainUI.BackgroundTransparency = 0.5 -- 半透明
MainUI.BorderSizePixel = 0
MainUI.Visible = false -- 最初は隠しておく

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 10)
MainUICorner.Parent = MainUI

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainUI
MainStroke.Color = Color3.fromRGB(150, 0, 255)
MainStroke.Thickness = 2

local MainText = Instance.new("TextLabel")
MainText.Parent = MainUI
MainText.BackgroundTransparency = 1
MainText.Size = UDim2.new(1, -15, 1, 0)
MainText.Position = UDim2.new(0, 15, 0, 0)
MainText.Text = "void"
MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
MainText.TextSize = 32
MainText.Font = Enum.Font.GothamBold
MainText.TextXAlignment = Enum.TextXAlignment.Left

-- メインUIを指でドラッグできるようにする
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
-- 5. ボタンの動作設定
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

print("設定完了！画面右上の「Void」ボタンをタップしてください。")
