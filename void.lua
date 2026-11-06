-- ============================================
-- Delta Menu 完全版
-- 横長UI / 半透明 / 虹色枠 / プレイヤーメニュー
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== 状態管理 =====
local state = {
    speed = 16,
    jumpPower = 50,
    wallWalk = false,
    noclip = false,
    speedEnabled = false,
    jumpEnabled = false,
}

local originalCollide = {} -- 貫通OFF時に戻す用

-- ===== Humanoid 確実取得 =====
local function getChar()
    return player.Character or player.CharacterAdded:Wait()
end

local function getHum()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChildOfClass("Humanoid")
end

local function getHRP()
    local char = player.Character
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart")
end

-- ===== UI =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaMenu"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 600, 0, 320)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- 虹色枠
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainFrame

task.spawn(function()
    local hue = 0
    while screenGui.Parent do
        hue = (hue + 0.008) % 1
        stroke.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.03)
    end
end)

-- タイトルバー（ドラッグ専用）
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1
titleBar.Parent = mainFrame
titleBar.Active = true

local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
game:GetService("UserInputService").InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Delta Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- 左側ボタン列
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 160, 1, -50)
leftPanel.Position = UDim2.new(0, 10, 0, 45)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = mainFrame

local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 8)
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.Parent = leftPanel

local function makeTabButton(text, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 50)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.TextScaled = true
    btn.Font = Enum.Font.GothamBold
    btn.LayoutOrder = order
    btn.AutoButtonColor = true
    btn.Parent = leftPanel
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = btn
    return btn
end

local playerTab = makeTabButton("プレイヤー", 1)

-- 右側コンテンツ
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -190, 1, -50)
content.Position = UDim2.new(0, 180, 0, 45)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
content.BackgroundTransparency = 0.3
content.BorderSizePixel = 0
content.Visible = false
content.Parent = mainFrame
local contentCorner = Instance.new("UICorner")
contentCorner.CornerRadius = UDim.new(0, 8)
contentCorner.Parent = content
local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 10)
contentLayout.Parent = content
local contentPad = Instance.new("UIPadding")
contentPad.PaddingTop = UDim.new(0, 10)
contentPad.PaddingLeft = UDim.new(0, 10)
contentPad.PaddingRight = UDim.new(0, 10)
contentPad.Parent = content

playerTab.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
end)

-- 行ヘルパー
local function makeRow(order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 42)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = content
    return row
end

local function makeLabel(parent, text, x, w)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, w, 1, 0)
    l.Position = UDim2.new(0, x, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextScaled = true
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

-- スピード行
local speedRow = makeRow(1)
makeLabel(speedRow, "スピード:", 0, 100)
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 80, 1, 0)
speedBox.Position = UDim2.new(0, 105, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Text = "100"
speedBox.Font = Enum.Font.Gotham
speedBox.TextScaled = true
speedBox.ClearTextOnFocus = false
speedBox.Parent = speedRow
local sbC = Instance.new("UICorner"); sbC.CornerRadius = UDim.new(0, 6); sbC.Parent = speedBox

local speedApply = Instance.new("TextButton")
speedApply.Size = UDim2.new(0, 90, 1, 0)
speedApply.Position = UDim2.new(0, 195, 0, 0)
speedApply.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
speedApply.TextColor3 = Color3.fromRGB(255, 255, 255)
speedApply.Text = "実行"
speedApply.Font = Enum.Font.GothamBold
speedApply.TextScaled = true
speedApply.Parent = speedRow
local saC = Instance.new("UICorner"); saC.CornerRadius = UDim.new(0, 6); saC.Parent = speedApply

-- ジャンプ力行
local jumpRow = makeRow(2)
makeLabel(jumpRow, "ジャンプ力:", 0, 100)
local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0, 80, 1, 0)
jumpBox.Position = UDim2.new(0, 105, 0, 0)
jumpBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBox.Text = "120"
jumpBox.Font = Enum.Font.Gotham
jumpBox.TextScaled = true
jumpBox.ClearTextOnFocus = false
jumpBox.Parent = jumpRow
local jbC = Instance.new("UICorner"); jbC.CornerRadius = UDim.new(0, 6); jbC.Parent = jumpBox

local jumpApply = Instance.new("TextButton")
jumpApply.Size = UDim2.new(0, 90, 1, 0)
jumpApply.Position = UDim2.new(0, 195, 0, 0)
jumpApply.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
jumpApply.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpApply.Text = "実行"
jumpApply.Font = Enum.Font.GothamBold
jumpApply.TextScaled = true
jumpApply.Parent = jumpRow
local jaC = Instance.new("UICorner"); jaC.CornerRadius = UDim.new(0, 6); jaC.Parent = jumpApply

-- 壁歩き行
local wallRow = makeRow(3)
makeLabel(wallRow, "壁歩き:", 0, 100)
local wallToggle = Instance.new("TextButton")
wallToggle.Size = UDim2.new(0, 180, 1, 0)
wallToggle.Position = UDim2.new(0, 105, 0, 0)
wallToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
wallToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
wallToggle.Text = "OFF"
wallToggle.Font = Enum.Font.GothamBold
wallToggle.TextScaled = true
wallToggle.Parent = wallRow
local wC = Instance.new("UICorner"); wC.CornerRadius = UDim.new(0, 6); wC.Parent = wallToggle

-- 貫通行
local noclipRow = makeRow(4)
makeLabel(noclipRow, "貫通:", 0, 100)
local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, 180, 1, 0)
noclipToggle.Position = UDim2.new(0, 105, 0, 0)
noclipToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggle.Text = "OFF"
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.TextScaled = true
noclipToggle.Parent = noclipRow
local nC = Instance.new("UICorner"); nC.CornerRadius = UDim.new(0, 6); nC.Parent = noclipToggle

-- リスポーン行
local respawnRow = makeRow(5)
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(1, 0, 1, 0)
respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
respawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
respawnBtn.Text = "即リスポーン"
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.TextScaled = true
respawnBtn.Parent = respawnRow
local rC = Instance.new("UICorner"); rC.CornerRadius = UDim.new(0, 6); rC.Parent = respawnBtn

-- ===== 機能実装 =====

-- スピード適用
speedApply.MouseButton1Click:Connect(function()
    local v = tonumber(speedBox.Text)
    if not v or v <= 0 then
        speedBox.Text = "数値エラー"
        return
    end
    state.speed = v
    state.speedEnabled = true
    local hum = getHum()
    if hum then hum.WalkSpeed = v end
end)

-- ジャンプ適用
jumpApply.MouseButton1Click:Connect(function()
    local v = tonumber(jumpBox.Text)
    if not v or v <= 0 then
        jumpBox.Text = "数値エラー"
        return
    end
    state.jumpPower = v
    state.jumpEnabled = true
    local hum = getHum()
    if hum then
        hum.UseJumpPower = true
        hum.JumpPower = v
    end
end)

-- 壁歩きトグル
wallToggle.MouseButton1Click:Connect(function()
    state.wallWalk = not state.wallWalk
    wallToggle.Text = state.wallWalk and "ON" or "OFF"
    wallToggle.BackgroundColor3 = state.wallWalk
        and Color3.fromRGB(0, 170, 110)
        or Color3.fromRGB(70, 70, 90)

    local hrp = getHRP()
    if not hrp then return end

    if state.wallWalk then
        if not hrp:FindFirstChild("WallWalkForce") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "WallWalkForce"
            bv.MaxForce = Vector3.zero
            bv.Velocity = Vector3.zero
            bv.Parent = hrp
        end
        if not hrp:FindFirstChild("WallWalkGyro") then
            local bg = Instance.new("BodyGyro")
            bg.Name = "WallWalkGyro"
            bg.MaxTorque = Vector3.zero
            bg.Parent = hrp
        end
    else
        local bv = hrp:FindFirstChild("WallWalkForce")
        if bv then bv:Destroy() end
        local bg = hrp:FindFirstChild("WallWalkGyro")
        if bg then bg:Destroy() end
    end
end)

-- 壁歩き更新ループ（Raycast正しい版）
RunService.Heartbeat:Connect(function()
    if not state.wallWalk then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    local bv = hrp:FindFirstChild("WallWalkForce")
    local bg = hrp:FindFirstChild("WallWalkGyro")
    if not bv or not bg then return end

    -- キャラクター自身を除いて前方にレイキャスト
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char}
    params.IgnoreWater = true

    local dir = hrp.CFrame.LookVector * 5 + Vector3.new(0, -1, 0) * 0
    local result = workspace:Raycast(hrp.Position, dir, params)

    if result and result.Normal then
        local n = result.Normal
        -- 壁に密着して上方向に進む
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, hum.WalkSpeed * 0.6, 0) + (-n * 4)
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position - n)
    else
        bv.MaxForce = Vector3.zero
        bg.MaxTorque = Vector3.zero
    end
end)

-- 貫通トグル
noclipToggle.MouseButton1Click:Connect(function()
    state.noclip = not state.noclip
    noclipToggle.Text = state.noclip and "ON" or "OFF"
    noclipToggle.BackgroundColor3 = state.noclip
        and Color3.fromRGB(0, 170, 110)
        or Color3.fromRGB(70, 70, 90)
end)

-- 貫通ループ
RunService.Stepped:Connect(function()
    if not state.noclip then return end
    local char = player.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then
            if originalCollide[p] == nil then
                originalCollide[p] = true
            end
            p.CanCollide = false
        end
    end
end)

-- 貫通OFF時の復元
local function restoreCollide()
    for part in pairs(originalCollide) do
        if part and part.Parent then
            part.CanCollide = true
        end
    end
    originalCollide = {}
end

-- 貫通をOFFにした瞬間に戻す（トグルを書き換え）
local oldNoclipClick
oldNoclipClick = noclipToggle.MouseButton1Click:Connect(function()
    if not state.noclip then
        restoreCollide()
    end
end)

-- 即リスポーン
respawnBtn.MouseButton1Click:Connect(function()
    local hum = getHum()
    if hum then
        hum.Health = 0
    else
        -- フォールバック
        local char = player.Character
        if char then char:BreakJoints() end
    end
end)

-- ===== 定期再適用（サーバーに戻される対策） =====
task.spawn(function()
    while screenGui.Parent do
        local hum = getHum()
        if hum then
            if state.speedEnabled and hum.WalkSpeed ~= state.speed then
                hum.WalkSpeed = state.speed
            end
            if state.jumpEnabled then
                hum.UseJumpPower = true
                if hum.JumpPower ~= state.jumpPower then
                    hum.JumpPower = state.jumpPower
                end
            end
        end
        task.wait(0.15)
    end
end)

-- キャラクター再生成時の再適用
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 5)
    task.wait(0.3)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        if state.speedEnabled then hum.WalkSpeed = state.speed end
        if state.jumpEnabled then
            hum.UseJumpPower = true
            hum.JumpPower = state.jumpPower
        end
    end
end)

print("[Delta Menu] 読み込み完了")
