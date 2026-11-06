-- ===== Viod Menu Part 1/3 =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local LANG = {
    ja = { title="Viod", player="プレイヤー", speed="スピード:", jump="ジャンプ力:",
           wall="壁歩き:", noclip="貫通:", respawn="即リスポーン", exec="実行",
           on="ON", off="OFF", err="数値エラー" },
    en = { title="Viod", player="Player", speed="Speed:", jump="Jump:",
           wall="Wall Walk:", noclip="Noclip:", respawn="Respawn", exec="Apply",
           on="ON", off="OFF", err="Invalid" },
}

local state = { speed=16, jumpPower=50, wallWalk=false, noclip=false,
    speedEnabled=false, jumpEnabled=false, lang="ja", minimized=false }
local originalCollide = {}

local function getHum()
    local c = player.Character; if not c then return nil end
    return c:FindFirstChildOfClass("Humanoid")
end
local function getHRP()
    local c = player.Character; if not c then return nil end
    return c:FindFirstChild("HumanoidRootPart")
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ViodMenu"
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

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundTransparency = 1
titleBar.Active = true
titleBar.Parent = mainFrame

local dragging, dragStart, startPos = false, nil, nil
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X,
            startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 18
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 110, 0, 28)
langBtn.Position = UDim2.new(1, -200, 0, 6)
langBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.TextSize = 13
langBtn.Font = Enum.Font.GothamBold
langBtn.Text = "日本語 🇯🇵"
langBtn.Parent = titleBar
local lc = Instance.new("UICorner"); lc.CornerRadius = UDim.new(0, 6); lc.Parent = langBtn

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 28, 0, 28)
minBtn.Position = UDim2.new(1, -85, 0, 6)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 18
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "−"
minBtn.Parent = titleBar
local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, 6); mc.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -52, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✖"
closeBtn.Parent = titleBar
local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = closeBtn

-- 「V」だけ表示する復元ボタン（普段は非表示）
local vBtn = Instance.new("TextButton")
vBtn.Size = UDim2.new(0, 40, 0, 40)
vBtn.Position = UDim2.new(1, -50, 0, 10)
vBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
vBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
vBtn.TextSize = 20
vBtn.Font = Enum.Font.GothamBold
vBtn.Text = "V"
vBtn.Visible = false
vBtn.Parent = screenGui
local vC = Instance.new("UICorner"); vC.CornerRadius = UDim.new(0, 8); vC.Parent = vBtn
local vStroke = Instance.new("UIStroke")
vStroke.Thickness = 2
vStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
vStroke.Parent = vBtn
task.spawn(function()
    local hue = 0
    while vBtn.Parent do
        hue = (hue + 0.01) % 1
        vStroke.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.03)
    end
end)

local body = Instance.new("Frame")
body.Size = UDim2.new(1, -20, 1, -50)
body.Position = UDim2.new(0, 10, 0, 45)
body.BackgroundTransparency = 1
body.Parent = mainFrame

-- 左タブ（プレイヤー1つだけ）
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 130, 1, 0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = body
local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 8)
leftLayout.Parent = leftPanel

local playerTab = Instance.new("TextButton")
playerTab.Size = UDim2.new(1, 0, 0, 46)
playerTab.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
playerTab.TextColor3 = Color3.fromRGB(255, 255, 255)
playerTab.TextSize = 16
playerTab.Font = Enum.Font.GothamBold
playerTab.Text = "プレイヤー"
playerTab.Parent = leftPanel
local ptC = Instance.new("UICorner"); ptC.CornerRadius = UDim.new(0, 8); ptC.Parent = playerTab

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -140, 1, 0)
content.Position = UDim2.new(0, 140, 0, 0)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
content.BackgroundTransparency = 0.3
content.BorderSizePixel = 0
content.Parent = body
local cC = Instance.new("UICorner"); cC.CornerRadius = UDim.new(0, 8); cC.Parent = content
local cP = Instance.new("UIPadding")
cP.PaddingTop = UDim.new(0, 8)
cP.PaddingLeft = UDim.new(0, 10)
cP.PaddingRight = UDim.new(0, 10)
cP.Parent = content

_G.ViodMenu = _G.ViodMenu or {}
_G.ViodMenu.p1 = { screenGui=screenGui, mainFrame=mainFrame, body=body,
    titleBar=titleBar, title=title, langBtn=langBtn, minBtn=minBtn, closeBtn=closeBtn,
    vBtn=vBtn, playerTab=playerTab, content=content, state=state, LANG=LANG,
    getHum=getHum, getHRP=getHRP, originalCollide=originalCollide }
-- ===== Viod Menu Part 2/3 =====
local V = _G.ViodMenu.p1
local content = V.content
local LANG = V.LANG
local state = V.state

-- プレイヤータブを押すと全機能が出る
V.playerTab.MouseButton1Click:Connect(function()
    content.Visible = not content.Visible
end)
content.Visible = true -- 最初から表示

local page = Instance.new("Frame")
page.Size = UDim2.new(1, 0, 1, 0)
page.BackgroundTransparency = 1
page.Parent = content
local pL = Instance.new("UIListLayout")
pL.Padding = UDim.new(0, 8)
pL.Parent = page

local function row(order)
    local r = Instance.new("Frame")
    r.Size = UDim2.new(1, 0, 0, 38)
    r.BackgroundTransparency = 1
    r.LayoutOrder = order
    r.Parent = page
    return r
end
local function label(parent, x, w)
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, w, 1, 0)
    l.Position = UDim2.new(0, x, 0, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(255, 255, 255)
    l.TextSize = 14
    l.Font = Enum.Font.Gotham
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = parent
    return l
end

-- スピード（数値 + 実行 + ON/OFF）
local speedRow = row(1)
local speedLabel = label(speedRow, 0, 95)
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 70, 1, 0)
speedBox.Position = UDim2.new(0, 100, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 14
speedBox.Text = "100"
speedBox.ClearTextOnFocus = false
speedBox.Parent = speedRow
local sbC = Instance.new("UICorner"); sbC.CornerRadius = UDim.new(0, 6); sbC.Parent = speedBox

local speedApply = Instance.new("TextButton")
speedApply.Size = UDim2.new(0, 70, 1, 0)
speedApply.Position = UDim2.new(0, 175, 0, 0)
speedApply.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
speedApply.TextColor3 = Color3.fromRGB(255, 255, 255)
speedApply.TextSize = 14
speedApply.Font = Enum.Font.GothamBold
speedApply.Parent = speedRow
local saC = Instance.new("UICorner"); saC.CornerRadius = UDim.new(0, 6); saC.Parent = speedApply

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0, 90, 1, 0)
speedToggle.Position = UDim2.new(0, 250, 0, 0)
speedToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
speedToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
speedToggle.TextSize = 14
speedToggle.Font = Enum.Font.GothamBold
speedToggle.Parent = speedRow
local stC = Instance.new("UICorner"); stC.CornerRadius = UDim.new(0, 6); stC.Parent = speedToggle

-- ジャンプ力（数値 + 実行 + ON/OFF）
local jumpRow = row(2)
local jumpLabel = label(jumpRow, 0, 95)
local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0, 70, 1, 0)
jumpBox.Position = UDim2.new(0, 100, 0, 0)
jumpBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBox.TextSize = 14
jumpBox.Text = "120"
jumpBox.ClearTextOnFocus = false
jumpBox.Parent = jumpRow
local jbC = Instance.new("UICorner"); jbC.CornerRadius = UDim.new(0, 6); jbC.Parent = jumpBox

local jumpApply = Instance.new("TextButton")
jumpApply.Size = UDim2.new(0, 70, 1, 0)
jumpApply.Position = UDim2.new(0, 175, 0, 0)
jumpApply.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
jumpApply.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpApply.TextSize = 14
jumpApply.Font = Enum.Font.GothamBold
jumpApply.Parent = jumpRow
local jaC = Instance.new("UICorner"); jaC.CornerRadius = UDim.new(0, 6); jaC.Parent = jumpApply

local jumpToggle = Instance.new("TextButton")
jumpToggle.Size = UDim2.new(0, 90, 1, 0)
jumpToggle.Position = UDim2.new(0, 250, 0, 0)
jumpToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
jumpToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpToggle.TextSize = 14
jumpToggle.Font = Enum.Font.GothamBold
jumpToggle.Parent = jumpRow
local jtC = Instance.new("UICorner"); jtC.CornerRadius = UDim.new(0, 6); jtC.Parent = jumpToggle

-- 壁歩き
local wallRow = row(3)
local wallLabel = label(wallRow, 0, 95)
local wallToggle = Instance.new("TextButton")
wallToggle.Size = UDim2.new(0, 245, 1, 0)
wallToggle.Position = UDim2.new(0, 100, 0, 0)
wallToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
wallToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
wallToggle.TextSize = 14
wallToggle.Font = Enum.Font.GothamBold
wallToggle.Parent = wallRow
local wC = Instance.new("UICorner"); wC.CornerRadius = UDim.new(0, 6); wC.Parent = wallToggle

-- 貫通
local noclipRow = row(4)
local noclipLabel = label(noclipRow, 0, 95)
local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, 245, 1, 0)
noclipToggle.Position = UDim2.new(0, 100, 0, 0)
noclipToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggle.TextSize = 14
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.Parent = noclipRow
local nC = Instance.new("UICorner"); nC.CornerRadius = UDim.new(0, 6); nC.Parent = noclipToggle

-- リスポーン
local respawnRow = row(5)
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(1, 0, 1, 0)
respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 70, 70)
respawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
respawnBtn.TextSize = 14
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.Parent = respawnRow
local rC = Instance.new("UICorner"); rC.CornerRadius = UDim.new(0, 6); rC.Parent = respawnBtn

_G.ViodMenu.p2 = { page=page,
    speedLabel=speedLabel, speedBox=speedBox, speedApply=speedApply, speedToggle=speedToggle,
    jumpLabel=jumpLabel, jumpBox=jumpBox, jumpApply=jumpApply, jumpToggle=jumpToggle,
    wallLabel=wallLabel, wallToggle=wallToggle,
    noclipLabel=noclipLabel, noclipToggle=noclipToggle,
    respawnBtn=respawnBtn }
-- ===== Viod Menu Part 3/3 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local LANG = V1.LANG
local state = V1.state
local getHum = V1.getHum
local getHRP = V1.getHRP
local originalCollide = V1.originalCollide
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

-- 元の値を記録（OFF時に戻す）
local baseSpeed = 16
local baseJump = 50

local function applyLang()
    local t = LANG[state.lang]
    V1.title.Text = t.title
    V1.langBtn.Text = (state.lang == "ja") and "日本語 🇯🇵" or "English 🇺🇸"
    V1.playerTab.Text = t.player
    V2.speedLabel.Text = t.speed
    V2.jumpLabel.Text = t.jump
    V2.wallLabel.Text = t.wall
    V2.noclipLabel.Text = t.noclip
    V2.respawnBtn.Text = t.respawn
    V2.speedApply.Text = t.exec
    V2.jumpApply.Text = t.exec
    V2.speedToggle.Text = state.speedEnabled and t.on or t.off
    V2.jumpToggle.Text = state.jumpEnabled and t.on or t.off
    V2.wallToggle.Text = state.wallWalk and t.on or t.off
    V2.noclipToggle.Text = state.noclip and t.on or t.off
end

V1.langBtn.MouseButton1Click:Connect(function()
    state.lang = (state.lang == "ja") and "en" or "ja"
    applyLang()
end)

-- ===== スピード =====
V2.speedApply.MouseButton1Click:Connect(function()
    local v = tonumber(V2.speedBox.Text)
    if not v or v <= 0 then
        V2.speedBox.Text = LANG[state.lang].err
        task.wait(1); V2.speedBox.Text = tostring(state.speed); return
    end
    state.speed = v
    if state.speedEnabled then
        local h = getHum(); if h then h.WalkSpeed = v end
    end
end)

V2.speedToggle.MouseButton1Click:Connect(function()
    state.speedEnabled = not state.speedEnabled
    V2.speedToggle.BackgroundColor3 = state.speedEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70, 70, 90)
    local h = getHum()
    if h then
        if state.speedEnabled then
            baseSpeed = h.WalkSpeed
            h.WalkSpeed = state.speed
        else
            h.WalkSpeed = baseSpeed
        end
    end
    applyLang()
end)

-- ===== ジャンプ力 =====
V2.jumpApply.MouseButton1Click:Connect(function()
    local v = tonumber(V2.jumpBox.Text)
    if not v or v <= 0 then
        V2.jumpBox.Text = LANG[state.lang].err
        task.wait(1); V2.jumpBox.Text = tostring(state.jumpPower); return
    end
    state.jumpPower = v
    if state.jumpEnabled then
        local h = getHum()
        if h then h.UseJumpPower = true; h.JumpPower = v end
    end
end)

V2.jumpToggle.MouseButton1Click:Connect(function()
    state.jumpEnabled = not state.jumpEnabled
    V2.jumpToggle.BackgroundColor3 = state.jumpEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70, 70, 90)
    local h = getHum()
    if h then
        if state.jumpEnabled then
            baseJump = h.JumpPower
            h.UseJumpPower = true
            h.JumpPower = state.jumpPower
        else
            h.JumpPower = baseJump
        end
    end
    applyLang()
end)

-- ===== 壁歩き =====
V2.wallToggle.MouseButton1Click:Connect(function()
    state.wallWalk = not state.wallWalk
    applyLang()
    V2.wallToggle.BackgroundColor3 = state.wallWalk
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70, 70, 90)
    local hrp = getHRP(); if not hrp then return end
    if state.wallWalk then
        if not hrp:FindFirstChild("WallWalkForce") then
            local bv = Instance.new("BodyVelocity")
            bv.Name = "WallWalkForce"; bv.MaxForce = Vector3.zero
            bv.Velocity = Vector3.zero; bv.Parent = hrp
        end
        if not hrp:FindFirstChild("WallWalkGyro") then
            local bg = Instance.new("BodyGyro")
            bg.Name = "WallWalkGyro"; bg.MaxTorque = Vector3.zero; bg.Parent = hrp
        end
    else
        local bv = hrp:FindFirstChild("WallWalkForce"); if bv then bv:Destroy() end
        local bg = hrp:FindFirstChild("WallWalkGyro"); if bg then bg:Destroy() end
    end
end)

RunService.Heartbeat:Connect(function()
    if not state.wallWalk then return end
    local char = player.Character; if not char then return end
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
    local res = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 5, params)
    if res and res.Normal then
        local n = res.Normal
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, hum.WalkSpeed * 0.6, 0) + (-n * 4)
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position - n)
    else
        bv.MaxForce = Vector3.zero; bg.MaxTorque = Vector3.zero
    end
end)

-- ===== 貫通 =====
V2.noclipToggle.MouseButton1Click:Connect(function()
    state.noclip = not state.noclip
    applyLang()
    V2.noclipToggle.BackgroundColor3 = state.noclip
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70, 70, 90)
    if not state.noclip then
        for part in pairs(originalCollide) do
            if part and part.Parent then part.CanCollide = true end
        end
        for k in pairs(originalCollide) do originalCollide[k] = nil end
    end
end)

RunService.Stepped:Connect(function()
    if not state.noclip then return end
    local char = player.Character; if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then
            originalCollide[p] = true; p.CanCollide = false
        end
    end
end)

-- ===== リスポーン =====
V2.respawnBtn.MouseButton1Click:Connect(function()
    local h = getHum()
    if h then h.Health = 0
    else local c = player.Character; if c then c:BreakJoints() end end
end)

-- ===== 定期再適用 =====
task.spawn(function()
    while V1.screenGui.Parent do
        local h = getHum()
        if h then
            if state.speedEnabled and h.WalkSpeed ~= state.speed then
                h.WalkSpeed = state.speed
            end
            if state.jumpEnabled then
                h.UseJumpPower = true
                if h.JumpPower ~= state.jumpPower then h.JumpPower = state.jumpPower end
            end
        end
        task.wait(0.15)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 5)
    task.wait(0.3)
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        if state.speedEnabled then h.WalkSpeed = state.speed end
        if state.jumpEnabled then h.UseJumpPower = true; h.JumpPower = state.jumpPower end
    end
end)

-- ===== ✖ を押すと「V」だけ表示 =====
V1.closeBtn.MouseButton1Click:Connect(function()
    V1.mainFrame.Visible = false
    V1.vBtn.Visible = true
    V1.vBtn.Position = UDim2.new(1, -50, 0, 10)
end)

-- Vを押すと元に戻る
V1.vBtn.MouseButton1Click:Connect(function()
    V1.mainFrame.Visible = true
    V1.vBtn.Visible = false
end)

-- ===== − を押すと通常サイズに戻る（最小化トグル） =====
local isMin = false
V1.minBtn.MouseButton1Click:Connect(function()
    isMin = not isMin
    if isMin then
        V1.body.Visible = false
        V1.minBtn.Text = "V"
        V1.minBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
        V1.mainFrame.Size = UDim2.new(0, 600, 0, 40)
    else
        V1.body.Visible = true
        V1.minBtn.Text = "−"
        V1.minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
        V1.mainFrame.Size = UDim2.new(0, 600, 0, 320)
    end
end)

applyLang()
print("[Viod Menu] Loaded / 読み込み完了")
