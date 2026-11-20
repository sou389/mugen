-- ==========================================
-- 1. 過去の残骸を削除＆配置先の設定
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- 過去のスクリプトのUIを完全に削除（PlayerGuiから）
for _, v in pairs(PlayerGui:GetChildren()) do
    if v.Name == "VoidTrigger" or v.Name == "RobloxStyleConfirm" then
        v:Destroy()
    end
end

-- 隠しトリガー用のScreenGui（最初は何も表示しない）
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidTrigger"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- ==========================================
-- 2. ポップアップを表示する処理
-- ==========================================
local function showPopup()
    -- すでに出ているなら消す
    local existing = PlayerGui:FindFirstChild("RobloxStyleConfirm")
    if existing then existing:Destroy() end

    local ConfirmGui = Instance.new("ScreenGui")
    ConfirmGui.Name = "RobloxStyleConfirm"
    ConfirmGui.Parent = PlayerGui
    ConfirmGui.ResetOnSpawn = false
    ConfirmGui.DisplayOrder = 999

    -- 黒い背景（後ろを暗くする）
    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Parent = ConfirmGui
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.BackgroundTransparency = 0.4
    DarkOverlay.BorderSizePixel = 0

    -- メインのポップアップ枠
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ConfirmGui
    MainFrame.Size = UDim2.new(0, 500, 0, 220)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -110)
    MainFrame.BackgroundColor3 = Color3.fromRGB(17, 44, 59) 
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- 区切り線
    local Divider = Instance.new("Frame")
    Divider.Parent = MainFrame
    Divider.Size = UDim2.new(1, 0, 0, 2)
    Divider.Position = UDim2.new(0, 0, 0.6, 0)
    Divider.BackgroundColor3 = Color3.fromRGB(34, 68, 85)
    Divider.BorderSizePixel = 0

    -- 「実行しますか？」のテキスト
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = MainFrame
    TextLabel.Size = UDim2.new(1, -40, 0.6, 0)
    TextLabel.Position = UDim2.new(0, 20, 0, 0)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "実行しますか？"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 32
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextYAlignment = Enum.TextYAlignment.Center

    -- 「実行」ボタン
    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Parent = MainFrame
    ExecBtn.Size = UDim2.new(0.5, 0, 0.4, 0)
    ExecBtn.Position = UDim2.new(0, 0, 0.6, 0)
    ExecBtn.BackgroundTransparency = 1
    ExecBtn.Text = ""
    
    local ExecCircle = Instance.new("Frame")
    ExecCircle.Parent = ExecBtn
    ExecCircle.Size = UDim2.new(0, 60, 0, 60)
    ExecCircle.Position = UDim2.new(0.5, -30, 0.3, 0)
    ExecCircle.BackgroundTransparency = 0.8
    ExecCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ExecCircle.BorderSizePixel = 0
    local ExecCorner = Instance.new("UICorner")
    ExecCorner.CornerRadius = UDim.new(1, 0)
    ExecCorner.Parent = ExecCircle
    
    local ExecText = Instance.new("TextLabel")
    ExecText.Parent = ExecBtn
    ExecText.Size = UDim2.new(1, 0, 0.4, 0)
    ExecText.Position = UDim2.new(0, 0, 0.6, 0)
    ExecText.BackgroundTransparency = 1
    ExecText.Text = "実行"
    ExecText.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecText.TextSize = 24
    ExecText.Font = Enum.Font.GothamBold

    -- 「閉じる」ボタン
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = MainFrame
    CloseBtn.Size = UDim2.new(0.5, 0, 0.4, 0)
    CloseBtn.Position = UDim2.new(0.5, 0, 0.6, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = ""
    
    local CloseCircle = Instance.new("Frame")
    CloseCircle.Parent = CloseBtn
    CloseCircle.Size = UDim2.new(0, 60, 0, 60)
    CloseCircle.Position = UDim2.new(0.5, -30, 0.3, 0)
    CloseCircle.BackgroundTransparency = 0.8
    CloseCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CloseCircle.BorderSizePixel = 0
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(1, 0)
    CloseCorner.Parent = CloseCircle

    local CloseText = Instance.new("TextLabel")
    CloseText.Parent = CloseBtn
    CloseText.Size = UDim2.new(1, 0, 0.4, 0)
    CloseText.Position = UDim2.new(0, 0, 0.6, 0)
    CloseText.BackgroundTransparency = 1
    CloseText.Text = "閉じる"
    CloseText.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseText.TextSize = 24
    CloseText.Font = Enum.Font.GothamBold

    -- ==========================================
    -- 3. メインの「void」UI（実行後に出てくる）
    -- ==========================================
    local VoidUI = Instance.new("Frame")
    VoidUI.Name = "MainVoidUI"
    VoidUI.Parent = ConfirmGui
    VoidUI.Size = UDim2.new(0, 350, 0, 150)
    VoidUI.Position = UDim2.new(0.5, -175, 0.5, -75)
    VoidUI.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    VoidUI.BackgroundTransparency = 0.5
    VoidUI.BorderSizePixel = 0
    VoidUI.Visible = false 
    
    local VoidCorner = Instance.new("UICorner")
    VoidCorner.CornerRadius = UDim.new(0, 12)
    VoidCorner.Parent = VoidUI
    
    local VoidStroke = Instance.new("UIStroke")
    VoidStroke.Parent = VoidUI
    VoidStroke.Color = Color3.fromRGB(150, 0, 255)
    VoidStroke.Thickness = 2

    local VoidText = Instance.new("TextLabel")
    VoidText.Parent = VoidUI
    VoidText.BackgroundTransparency = 1
    VoidText.Size = UDim2.new(1, -20, 0, 50)
    VoidText.Position = UDim2.new(0, 20, 0, 20)
    VoidText.Text = "void"
    VoidText.TextColor3 = Color3.fromRGB(255, 255, 255)
    VoidText.TextSize = 40
    VoidText.Font = Enum.Font.GothamBold
    VoidText.TextXAlignment = Enum.TextXAlignment.Left

    -- ドラッグ機能の実装
    local dragging, dragInput, dragStart, startPos
    VoidUI.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = VoidUI.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    VoidUI.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            VoidUI.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- ==========================================
    -- 4. ボタンの動作設定
    -- ==========================================
    CloseBtn.MouseButton1Click:Connect(function()
        ConfirmGui:Destroy()
    end)
    
    ExecBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        DarkOverlay.Visible = false
        VoidUI.Visible = true
        print("UIが起動しました！")
    end)
end

-- ==========================================
-- 5. 呼び出し設定（Zキー / 画面ダブルタップ）
-- ==========================================
-- PC: Zキー
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        showPopup()
    end
end)

-- スマホ: 画面を素早く2回タップ
local lastTap = 0
UserInputService.TouchTap:Connect(function(touchPositions, gameProcessed)
    if gameProcessed then return end
    local currentTime = tick()
    if currentTime - lastTap < 0.3 then
        showPopup()
    end
    lastTap = currentTime
end)

print("準備完了！『Zキー』または『画面ダブルタップ』でポップアップが出ます。")
