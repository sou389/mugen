-- ==========================================
-- ゲーム判定（フライドポテトを売る異変 限定）
-- Place ID: 10767380385
-- ==========================================
local TARGET_GAME_ID = 10767380385

local Players = game:GetService("Players")
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- お掃除
for _, v in pairs(PlayerGui:GetChildren()) do
    if v.Name == "VoidUniversalUI" then v:Destroy() end
end

-- ==========================================
-- ゲーム判定処理
-- ==========================================
if game.PlaceId ~= TARGET_GAME_ID then
    -- 対象外のゲームの場合：警告UIを表示してスクリプトを終了
    local ErrorGui = Instance.new("ScreenGui")
    ErrorGui.Name = "VoidUniversalUI"
    ErrorGui.Parent = PlayerGui
    ErrorGui.ResetOnSpawn = false

    local ErrorFrame = Instance.new("Frame")
    ErrorFrame.Parent = ErrorGui
    ErrorFrame.Size = UDim2.new(0, 400, 0, 120)
    ErrorFrame.Position = UDim2.new(0.5, -200, 0.5, -60)
    ErrorFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ErrorFrame.BorderSizePixel = 0

    local ErrCorner = Instance.new("UICorner")
    ErrCorner.CornerRadius = UDim.new(0, 8)
    ErrCorner.Parent = ErrorFrame

    local ErrStroke = Instance.new("UIStroke")
    ErrStroke.Parent = ErrorFrame
    ErrStroke.Color = Color3.fromRGB(255, 50, 50)
    ErrStroke.Thickness = 2

    local ErrText = Instance.new("TextLabel")
    ErrText.Parent = ErrorFrame
    ErrText.Size = UDim2.new(1, -20, 1, 0)
    ErrText.Position = UDim2.new(0, 10, 0, 0)
    ErrText.BackgroundTransparency = 1
    ErrText.Text = "このゲームでは使えません"
    ErrText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ErrText.TextSize = 24
    ErrText.Font = Enum.Font.GothamBold
    ErrText.TextXAlignment = Enum.TextXAlignment.Center

    -- 5秒後に自動で消す
    task.wait(5)
    ErrorGui:Destroy()
    return
end

-- ==========================================
-- 以下、対象ゲームの場合のみ実行される
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidUniversalUI"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- ==========================================
-- 画像そっくりのポップアップ（確認画面）
-- ==========================================
local PopupFrame = Instance.new("Frame")
PopupFrame.Parent = ScreenGui
PopupFrame.Size = UDim2.new(0, 550, 0, 250)
PopupFrame.Position = UDim2.new(0.5, -275, 0.5, -125)
PopupFrame.BackgroundColor3 = Color3.fromRGB(20, 45, 60)
PopupFrame.BackgroundTransparency = 0.1
PopupFrame.BorderSizePixel = 0
PopupFrame.Visible = true -- 最初から表示

local PopupCorner = Instance.new("UICorner")
PopupCorner.CornerRadius = UDim.new(0, 4)
PopupCorner.Parent = PopupFrame

local Divider = Instance.new("Frame")
Divider.Parent = PopupFrame
Divider.Size = UDim2.new(1, 0, 0, 2)
Divider.Position = UDim2.new(0, 0, 0.55, 0)
Divider.BackgroundColor3 = Color3.fromRGB(35, 65, 80)
Divider.BorderSizePixel = 0

local PopupText = Instance.new("TextLabel")
PopupText.Parent = PopupFrame
PopupText.Size = UDim2.new(1, -40, 0.55, 0)
PopupText.Position = UDim2.new(0, 20, 0, 0)
PopupText.BackgroundTransparency = 1
PopupText.Text = "実行しますか？"
PopupText.TextColor3 = Color3.fromRGB(255, 255, 255)
PopupText.TextSize = 36
PopupText.Font = Enum.Font.GothamBold
PopupText.TextXAlignment = Enum.TextXAlignment.Left
PopupText.TextYAlignment = Enum.TextYAlignment.Center

-- 実行ボタン
local ExecBtn = Instance.new("TextButton")
ExecBtn.Parent = PopupFrame
ExecBtn.Size = UDim2.new(0.5, 0, 0.45, 0)
ExecBtn.Position = UDim2.new(0, 0, 0.55, 0)
ExecBtn.BackgroundTransparency = 1
ExecBtn.Text = ""

local ExecCircle = Instance.new("Frame")
ExecCircle.Parent = ExecBtn
ExecCircle.Size = UDim2.new(0, 130, 0, 130)
ExecCircle.Position = UDim2.new(0.5, -65, 0.5, -65)
ExecCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ExecCircle.BackgroundTransparency = 0.6
ExecCircle.BorderSizePixel = 0
local ExecCircleCorner = Instance.new("UICorner")
ExecCircleCorner.CornerRadius = UDim.new(1, 0)
ExecCircleCorner.Parent = ExecCircle

local ExecText = Instance.new("TextLabel")
ExecText.Parent = ExecBtn
ExecText.Size = UDim2.new(1, 0, 1, 0)
ExecText.BackgroundTransparency = 1
ExecText.Text = "実行"
ExecText.TextColor3 = Color3.fromRGB(255, 255, 255)
ExecText.TextSize = 32
ExecText.Font = Enum.Font.GothamBold
ExecText.ZIndex = 2

-- 閉じるボタン
local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = PopupFrame
CloseBtn.Size = UDim2.new(0.5, 0, 0.45, 0)
CloseBtn.Position = UDim2.new(0.5, 0, 0.55, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = ""

local CloseCircle = Instance.new("Frame")
CloseCircle.Parent = CloseBtn
CloseCircle.Size = UDim2.new(0, 130, 0, 130)
CloseCircle.Position = UDim2.new(0.5, -65, 0.5, -65)
CloseCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CloseCircle.BackgroundTransparency = 0.6
CloseCircle.BorderSizePixel = 0
local CloseCircleCorner = Instance.new("UICorner")
CloseCircleCorner.CornerRadius = UDim.new(1, 0)
CloseCircleCorner.Parent = CloseCircle

local CloseText = Instance.new("TextLabel")
CloseText.Parent = CloseBtn
CloseText.Size = UDim2.new(1, 0, 1, 0)
CloseText.BackgroundTransparency = 1
CloseText.Text = "閉じる"
CloseText.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseText.TextSize = 32
CloseText.Font = Enum.Font.GothamBold
CloseText.ZIndex = 2

-- ==========================================
-- 実行後の巨大な「void」UI
-- ==========================================
local MainUI = Instance.new("Frame")
MainUI.Parent = ScreenGui
MainUI.Size = UDim2.new(0, 600, 0, 300)
MainUI.Position = UDim2.new(0.5, -300, 0.5, -150)
MainUI.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainUI.BackgroundTransparency = 0.4
MainUI.BorderSizePixel = 0
MainUI.Visible = false

local MainUICorner = Instance.new("UICorner")
MainUICorner.CornerRadius = UDim.new(0, 15)
MainUICorner.Parent = MainUI

local MainStroke = Instance.new("UIStroke")
MainStroke.Parent = MainUI
MainStroke.Color = Color3.fromRGB(150, 0, 255)
MainStroke.Thickness = 3

local MainText = Instance.new("TextLabel")
MainText.Parent = MainUI
MainText.BackgroundTransparency = 1
MainText.Size = UDim2.new(1, -40, 0, 80)
MainText.Position = UDim2.new(0, 40, 0, 30)
MainText.Text = "void"
MainText.TextColor3 = Color3.fromRGB(255, 255, 255)
MainText.TextSize = 70
MainText.Font = Enum.Font.GothamBold
MainText.TextXAlignment = Enum.TextXAlignment.Left

-- ドラッグ機能
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
-- ボタン動作
-- ==========================================
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy() -- 閉じるを押したらUIを全部消す
end)

ExecBtn.MouseButton1Click:Connect(function()
    PopupFrame.Visible = false
    MainUI.Visible = true
end)
