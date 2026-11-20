-- 画面をリセット
local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
for _, v in pairs(pg:GetChildren()) do
    if v:IsA("ScreenGui") then v:Destroy() end
end

local PlayerGui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

-- ==========================================
-- 1. ポップアップ（確認画面）を作る関数
-- ==========================================
local function showPopup()
    -- すでに出ていたら消す
    local old = PlayerGui:FindFirstChild("VoidPopup")
    if old then old:Destroy() end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "VoidPopup"
    ScreenGui.Parent = PlayerGui
    ScreenGui.ResetOnSpawn = false

    -- 背景を暗くする
    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Parent = ScreenGui
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.BackgroundTransparency = 0.4
    DarkOverlay.BorderSizePixel = 0

    -- 中央のポップアップ枠（紺色）
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ScreenGui
    MainFrame.Size = UDim2.new(0, 450, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -225, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(17, 44, 59) 
    MainFrame.BorderSizePixel = 0
    
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 8)
    UICorner.Parent = MainFrame

    -- 真ん中の線
    local Divider = Instance.new("Frame")
    Divider.Parent = MainFrame
    Divider.Size = UDim2.new(1, 0, 0, 2)
    Divider.Position = UDim2.new(0, 0, 0.6, 0)
    Divider.BackgroundColor3 = Color3.fromRGB(34, 68, 85)
    Divider.BorderSizePixel = 0

    -- 「実行しますか？」の文字
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

    -- 「実行」ボタン
    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Parent = MainFrame
    ExecBtn.Size = UDim2.new(0.5, 0, 0.4, 0)
    ExecBtn.Position = UDim2.new(0, 0, 0.6, 0)
    ExecBtn.BackgroundTransparency = 1
    ExecBtn.Text = "実行"
    ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecBtn.TextSize = 26
    ExecBtn.Font = Enum.Font.GothamBold

    -- 「閉じる」ボタン
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = MainFrame
    CloseBtn.Size = UDim2.new(0.5, 0, 0.4, 0)
    CloseBtn.Position = UDim2.new(0.5, 0, 0.6, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "閉じる"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 26
    CloseBtn.Font = Enum.Font.GothamBold

    -- ==========================================
    -- 2. 実行後に出る「void」UI
    -- ==========================================
    local VoidUI = Instance.new("Frame")
    VoidUI.Name = "MainVoidUI"
    VoidUI.Parent = ScreenGui
    VoidUI.Size = UDim2.new(0, 300, 0, 100)
    VoidUI.Position = UDim2.new(0.5, -150, 0.5, -50)
    VoidUI.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    VoidUI.BackgroundTransparency = 0.5
    VoidUI.BorderSizePixel = 0
    VoidUI.Visible = false 
    
    local VoidCorner = Instance.new("UICorner")
    VoidCorner.CornerRadius = UDim.new(0, 10)
    VoidCorner.Parent = VoidUI
    
    local VoidStroke = Instance.new("UIStroke")
    VoidStroke.Parent = VoidUI
    VoidStroke.Color = Color3.fromRGB(150, 0, 255)
    VoidStroke.Thickness = 2

    local VoidText = Instance.new("TextLabel")
    VoidText.Parent = VoidUI
    VoidText.BackgroundTransparency = 1
    VoidText.Size = UDim2.new(1, -20, 1, 0)
    VoidText.Position = UDim2.new(0, 20, 0, 0)
    VoidText.Text = "void"
    VoidText.TextColor3 = Color3.fromRGB(255, 255, 255)
    VoidText.TextSize = 40
    VoidText.Font = Enum.Font.GothamBold
    VoidText.TextXAlignment = Enum.TextXAlignment.Left

    -- ドラッグで動かせるようにする
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

    -- ボタンが押された時の処理
    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy() -- 閉じるを押したら全部消す
    end)
    
    ExecBtn.MouseButton1Click:Connect(function()
        MainFrame.Visible = false
        DarkOverlay.Visible = false
        VoidUI.Visible = true
        print("実行が押されました！void UI起動！")
    end)
end

-- ==========================================
-- 3. キー入力（Zキー）の設定
-- ==========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    -- チャット中などは反応しないようにする
    if gameProcessed then return end
    
    -- Zキーが押されたらポップアップを出す
    if input.KeyCode == Enum.KeyCode.Z then
        showPopup()
    end
end)

print("準備完了！Zキーを押してください。")
