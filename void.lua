-- ============================================
-- Delta Menu 完全版 + 言語切替
-- ============================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ===== 言語辞書 =====
local LANG = {
    ja = {
        title = "Delta メニュー",
        player = "プレイヤー",
        speed = "スピード:",
        jump = "ジャンプ力:",
        wall = "壁歩き:",
        noclip = "貫通:",
        respawn = "即リスポーン",
        exec = "実行",
        on = "ON",
        off = "OFF",
        err = "数値エラー",
    },
    en = {
        title = "Delta Menu",
        player = "Player",
        speed = "Speed:",
        jump = "Jump:",
        wall = "Wall Walk:",
        noclip = "Noclip:",
        respawn = "Respawn",
        exec = "Apply",
        on = "ON",
        off = "OFF",
        err = "Invalid",
    },
}

local state = {
    speed = 16,
    jumpPower = 50,
    wallWalk = false,
    noclip = false,
    speedEnabled = false,
    jumpEnabled = false,
    lang = "ja",
}

local originalCollide = {}

-- ===== Humanoid ヘルパー =====
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

-- タイトルバー（ドラッグ用）
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1
titleBar.Active = true
titleBar.Parent = mainFrame

local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- タイトルテキスト
local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 300, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- ===== 右上 言語切替ボタン =====
local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 130, 0, 30)
langBtn.Position = UDim2.new(1, -140, 0, 5)
langBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.TextScaled = true
langBtn.Font = Enum.Font.GothamBold
langBtn.Text = "日本語 🇯🇵"
langBtn.Parent = titleBar
local langC = Instance.new("UICorner")
langC.CornerRadius = UDim.new(0, 6)
langC.Parent = langBtn

-- 左側タブ
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 160, 1, -50)
leftPanel.Position = UDim2.new(0, 10, 0, 45)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = mainFrame

local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 8)
leftLayout.Parent = leftPanel

local playerTab = Instance.new("TextButton")
playerTab.Size = UDim2.new(1, 0, 0, 50)
playerTab.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
playerTab.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTab.TextScaled = true
playerTab.Font = Enum.Font.GothamBold
playerTab.Parent = leftPanel
local ptC = Instance.new("UICorner"); ptC.CornerRadius = UDim.new(0, 8); ptC.Parent = playerTab

-- 右側コンテンツ
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -190, 1, -50)
content.Position = UDim2.new(0, 180, 0, 45)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
content.BackgroundTransparency = 0.3
content.BorderSizePixel = 0
content.Visible = false
content.Parent = mainFrame
local contentC = Instance.new("UICorner"); contentC.CornerRadius = UDim.new(0, 8); contentC.Parent = content
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

local function makeLabel(parent, x, w)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, w, 1, 0)
    l.Position = UDim2.new(0, x, 0, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextScaled = true
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

-- スピード行
local speedRow = makeRow(1)
local speedLabel = makeLabel(speedRow, 0, 100)
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
speedApply.Font = Enum.Font.GothamBold
speedApply.TextScaled = true
speedApply.Parent = speedRow
local saC = Instance.new("UICorner"); saC.CornerRadius = UDim.new(0, 6); saC.Parent = speedApply

-- ジャンプ力行
local jumpRow = makeRow(2)
local jumpLabel = makeLabel(jumpRow, 0, 100)
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
jumpApply.Font = Enum.Font.GothamBold
jumpApply.TextScaled = true
jumpApply.Parent = jumpRow
local jaC = Instance.new("UICorner"); jaC.CornerRadius = UDim.new(0, 6); jaC.Parent = jumpApply

-- 壁歩き行
local wallRow = makeRow(3)
local wallLabel = makeLabel(wallRow, 0, 100)
local wallToggle = Instance.new("TextButton")
wallToggle.Size = UDim2.new(0, 180, 1, 0)
wallToggle.Position = UDim2.new(0, 105, 0, 0)
wallToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
wallToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
wallToggle.Font = Enum.Font.GothamBold
wallToggle.TextScaled = true
wallToggle.Parent = wallRow
local wC = Instance.new("UICorner"); wC.CornerRadius = UDim.new(0, 6); wC.Parent = wallToggle

-- 貫通行
local noclipRow = makeRow(4)
local noclipLabel = makeLabel(noclipRow, 0, 100)
local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, 180, 1, 0)
noclipToggle.Position = UDim2.new(0, 105, 0, 0)
noclipToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
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
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.TextScaled = true
respawnBtn.Parent = respawnRow
local rC = Instance.new("UICorner"); rC.CornerRadius = UDim.new(0, 6); rC.Parent = respawnBtn

-- ===== 言語反映 =====
local function applyLang()
    local t = LANG[state.lang]
    title.Text = t.title
    langBtn.Text = (state.lang == "ja") and "日本語 🇯🇵" or "English 🇺🇸"
    playerTab.Text = t.player
    speedLabel.Text = t.speed
    jumpLabel.Text = t.jump
    wallLabel.Text = t.wall
    noclipLabel.Text = t.noclip
    respawnBtn.Text = t.respawn
    speedApply.Text = t.exec
    jumpApply.Text = t.exec
    wallToggle.Text = state.wallWalk and t.on or t.off
    noclipToggle.Text = state.noclip and t.on or t.off
end

langBtn.MouseButton1Click:Connect(function()
    state.lang = (state.lang == "ja") and "en" or "ja"
    applyLang()
end)

-- ===== 機能 =====
speedApply.MouseButton1Click:Connect(function()
    local v = tonumber(speedBox.Text)
    if not v or v <= 0 then
        speedBox.Text = LANG[state.lang].err
        task.wait(1)
        speedBox.Text = tostring(state.speed)
        return
    end
    state.speed = v
    state.speedEnabled = true
    local hum = getHum()
    if hum then hum.WalkSpeed = v end
end)

jumpApply.MouseButton1Click:Connect(function()
    local v = tonumber(jumpBox.Text)
    if not v or v <= 0 then
        jumpBox.Text = LANG[state.lang].err
        task.wait(1)
        jumpBox.Text = tostring(state.jumpPower)
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

wallToggle.MouseButton1Click:Connect(function()
    state.wallWalk = not state.wallWalk
    applyLang()
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

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {char}
    params.IgnoreWater = true
    local result = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 5, params)

    if result and result.Normal then
        local n = result.Normal
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, hum.WalkSpeed * 0.6, 0) + (-n * 4)
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position - n)
    else
        bv.MaxForce = Vector3.zero
        bg.MaxTorque = Vector3.zero
    end
end)

noclipToggle.MouseButton1Click:Connect(function()
    state.noclip = not state.noclip
    applyLang()
    noclipToggle.BackgroundColor3 = state.noclip
        and Color3.fromRGB(0, 170, 110)
        or Color3.fromRGB(70, 70, 90)
    if not state.noclip then
        for part in pairs(originalCollide) do
            if part and part.Parent then part.CanCollide = true end
        end
        originalCollide = {}
    end
end)

RunService.Stepped:Connect(function()
    if not state.noclip then return end
    local char = player.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then
            originalCollide[p] = true
            p.CanCollide = false
        end
    end
end)

respawnBtn.MouseButton1Click:Connect(function()
    local hum = getHum()
    if hum then
        hum.Health = 0
    else
        local char = player.Character
        if char then char:BreakJoints() end
    end
end)

-- 定期再適用
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

-- 初期言語適用
applyLang()
print("[Delta Menu] Loaded / 読み込み完了")
