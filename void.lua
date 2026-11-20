-- 既存のUIがあれば削除
local oldGui = game.CoreGui:FindFirstChild("VoidTrigger")
if oldGui then oldGui:Destroy() end
local oldConfirm = game.CoreGui:FindFirstChild("RobloxStyleConfirm")
if oldConfirm then oldConfirm:Destroy() end

--------------------------------------------------
-- 1. 呼び出し用の隠しトリガー（Zキー、または画面タップ）
--------------------------------------------------
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidTrigger"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local UserInputService = game:GetService("UserInputService")

-- ポップアップを表示する関数
local function showPopup()
    -- すでに表示されているなら何もしない
    if game.CoreGui:FindFirstChild("RobloxStyleConfirm") then return end
    
    --------------------------------------------------
    -- 2. 画像と同じスタイルの確認UI（ダイアログ）の作成
    --------------------------------------------------
    local ConfirmGui = Instance.new("ScreenGui")
    ConfirmGui.Name = "RobloxStyleConfirm"
    ConfirmGui.Parent = game.CoreGui
    ConfirmGui.ResetOnSpawn = false
    
    -- 背景を少し暗くする（画像のような暗さを再現）
    local DarkOverlay = Instance.new("Frame")
    DarkOverlay.Parent = ConfirmGui
    DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
    DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    DarkOverlay.BackgroundTransparency = 0.3
    DarkOverlay.BorderSizePixel = 0
    DarkOverlay.ZIndex = 1
    
    -- メインのポップアップ枠（半透明の紺色）
    local MainFrame = Instance.new("Frame")
    MainFrame.Parent = ConfirmGui
    MainFrame.Size = UDim2.new(0, 500, 0, 220)
    MainFrame.Position = UDim2.new(0.5, -250, 0.5, -110)
    MainFrame.BackgroundColor3 = Color3.fromRGB(15, 35, 50) -- 画像のような濃い紺
    MainFrame.BackgroundTransparency = 0.1
    MainFrame.BorderSizePixel = 0
    MainFrame.ZIndex = 2
    
    -- 角丸
    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 6)
    UICorner.Parent = MainFrame
    
    -- 枠線
    local UIStroke = Instance.new("UIStroke")
    UIStroke.Parent = MainFrame
    UIStroke.Color = Color3.fromRGB(100, 100, 100)
    UIStroke.Thickness = 1
    UIStroke.Transparency = 0.5
    
    -- 中央の区切り線
    local Divider = Instance.new("Frame")
    Divider.Parent = MainFrame
    Divider.Size = UDim2.new(1, 0, 0, 2)
    Divider.Position = UDim2.new(0, 0, 0.6, 0)
    Divider.BackgroundColor3 = Color3.fromRGB(40, 70, 90)
    Divider.BorderSizePixel = 0
    Divider.ZIndex = 3
    
    -- 「実行しますか？」のテキスト
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = MainFrame
    TextLabel.Size = UDim2.new(1, -40, 0.6, 0)
    TextLabel.Position = UDim2.new(0, 20, 0, 10)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = "実行しますか？"
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 26
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.ZIndex = 3
    
    -- 左下の「実行」ボタン
    local ExecBtn = Instance.new("TextButton")
    ExecBtn.Parent = MainFrame
    ExecBtn.Size = UDim2.new(0.45, 0, 0.35, 0)
    ExecBtn.Position = UDim2.new(0.025, 0, 0.62, 0)
    ExecBtn.BackgroundTransparency = 1 -- 背景を透明にする
    ExecBtn.Text = "実行"
    ExecBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ExecBtn.TextSize = 24
    ExecBtn.Font = Enum.Font.GothamBold
    ExecBtn.ZIndex = 3
    
    -- 実行ボタンの丸いアイコン背景
    local ExecCircle = Instance.new("Frame")
    ExecCircle.Parent = ExecBtn
    ExecCircle.Size = UDim2.new(0, 80, 0, 80)
    ExecCircle.Position = UDim2.new(0.5, -40, 0.5, -10)
    ExecCircle.BackgroundTransparency = 0.8
    ExecCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    ExecCircle.BorderSizePixel = 0
    ExecCircle.ZIndex = 2
    local ExecCircleCorner = Instance.new("UICorner")
    ExecCircleCorner.CornerRadius = UDim.new(1, 0)
    ExecCircleCorner.Parent = ExecCircle

    -- 右下の「閉じる」ボタン
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Parent = MainFrame
    CloseBtn.Size = UDim2.new(0.45, 0, 0.35, 0)
    CloseBtn.Position = UDim2.new(0.525, 0, 0.62, 0)
    CloseBtn.BackgroundTransparency = 1
    CloseBtn.Text = "閉じる"
    CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseBtn.TextSize = 24
    CloseBtn.Font = Enum.Font.GothamBold
    CloseBtn.ZIndex = 3
    
    -- 閉じるボタンの丸いアイコン背景
    local CloseCircle = Instance.new("Frame")
    CloseCircle.Parent = CloseBtn
    CloseCircle.Size = UDim2.new(0, 80, 0, 80)
    CloseCircle.Position = UDim2.new(0.5, -40, 0.5, -10)
    CloseCircle.BackgroundTransparency = 0.8
    CloseCircle.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    CloseCircle.BorderSizePixel = 0
    CloseCircle.ZIndex = 2
    local CloseCircleCorner = Instance.new("UICorner")
    CloseCircleCorner.CornerRadius = UDim.new(1, 0)
    CloseCircleCorner.Parent = CloseCircle

    --------------------------------------------------
    -- 3. メインUI（実行を押した後に出てくるUI）
    --------------------------------------------------
    local VoidUI = Instance.new("Frame")
    VoidUI.Name = "MainVoidUI"
    VoidUI.Parent = ConfirmGui
    VoidUI.Size = UDim2.new(0, 350, 0, 150)
    VoidUI.Position = UDim2.new(0.5, -175, 0.5, -75)
    VoidUI.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    VoidUI.BackgroundTransparency = 0.4
    VoidUI.BorderSizePixel = 0
    VoidUI.Visible = false -- 最初は非表示
    VoidUI.ZIndex = 5
    
    local VoidUICorner = Instance.new("UICorner")
    VoidUICorner.CornerRadius = UDim.new(0, 12)
    VoidUICorner.Parent = VoidUI
    
    local VoidStroke = Instance.new("UIStroke")
    VoidStroke.Parent = VoidUI
    VoidStroke.Color = Color3.fromRGB(150, 0, 255)
    VoidStroke.Thickness = 2
    
    -- 左に「void」と表示
    local VoidText = Instance.new("TextLabel")
    VoidText.Parent = VoidUI
    VoidText.BackgroundTransparency = 1
    VoidText.Size = UDim2.new(1, -20, 0, 40)
    VoidText.Position = UDim2.new(0, 15, 0, 10)
    VoidText.Text = "void"
    VoidText.TextColor3 = Color3.fromRGB(255, 255, 255)
    VoidText.TextSize = 36
    VoidText.Font = Enum.Font.GothamBold
    VoidText.TextXAlignment = Enum.TextXAlignment.Left
    VoidText.ZIndex = 6

    -- メインUIをドラッグできるようにする
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

    --------------------------------------------------
    -- 4. ボタンの動作設定
    --------------------------------------------------
    -- 「閉じる」を押した時
    CloseBtn.MouseButton1Click:Connect(function()
        ConfirmGui:Destroy()
    end)
    
    -- 「実行」を押した時
    ExecBtn.MouseButton1Click:Connect(function()
        -- 確認画面を消す
        MainFrame.Visible = false
        DarkOverlay.Visible = false
        -- メインのUIを表示
        VoidUI.Visible = true
    end)
end

--------------------------------------------------
-- 5. 呼び出しトリガーの設定
--------------------------------------------------
-- PCの場合: Zキーを押すと出る
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Z then
        showPopup()
    end
end)

-- スマホ/タブレットの場合: 画面のどこかを素早く2回タップすると出る
local lastTap = 0
UserInputService.TouchTap:Connect(function(touchPositions, gameProcessed)
    if gameProcessed then return end
    local currentTime = tick()
    if currentTime - lastTap < 0.3 then
        showPopup()
    end
    lastTap = currentTime
end)
