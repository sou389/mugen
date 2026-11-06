-- ===== Viod Menu Part 1/3 =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local LANG = {
    ja = { title="Viod", speed="スピード:", jump="ジャンプ力:", wall="壁歩き:",
           noclip="貫通:", respawn="即リスポーン", exec="実行",
           on="ON", off="OFF", err="数値エラー", info="設定はこちらから" },
    en = { title="Viod", speed="Speed:", jump="Jump:", wall="Wall Walk:",
           noclip="Noclip:", respawn="Respawn", exec="Apply",
           on="ON", off="OFF", err="Invalid", info="Settings here" },
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

local body = Instance.new("Frame")
body.Size = UDim2.new(1, -20, 1, -50)
body.Position = UDim2.new(0, 10, 0, 45)
body.BackgroundTransparency = 1
body.Parent = mainFrame

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 70, 1, 0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = body
local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 8)
leftLayout.Parent = leftPanel

local function makeTab(text, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 46)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 18
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.LayoutOrder = order
    b.Parent = leftPanel
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = b
    return b
end
local tab1 = makeTab("1", 1)
local tab2 = makeTab("2", 2)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -80, 1, 0)
content.Position = UDim2.new(0, 80, 0, 0)
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
local cL = Instance.new("UIListLayout")
cL.Padding = UDim.new(0, 8)
cL.Parent = content

-- パート1 ここまで（次はパート2を貼ってください）
_G.ViodMenu = _G.ViodMenu or {}
_G.ViodMenu.p1 = { screenGui=screenGui, mainFrame=mainFrame, body=body,
    titleBar=titleBar, title=title, langBtn=langBtn, minBtn=minBtn, closeBtn=closeBtn,
    tab1=tab1, tab2=tab2, content=content, state=state, LANG=LANG,
    getHum=getHum, getHRP=getHRP, originalCollide=originalCollide }
-- ===== Viod Menu Part 2/3 =====
local V = _G.ViodMenu.p1
local content = V.content
local LANG = V.LANG
local state = V.state

local page1 = Instance.new("Frame")
page1.Size = UDim2.new(1, 0, 1, 0)
page1.BackgroundTransparency = 1
page1.Parent = content
local p1L = Instance.new("UIListLayout")
p1L.Padding = UDim.new(0, 8)
p1L.Parent = page1

local function row(order)
    local r = Instance.new("Frame")
    r.Size = UDim2.new(1, 0, 0, 38)
    r.BackgroundTransparency = 1
    r.LayoutOrder = order
    r.Parent = page1
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

-- スピード
local speedRow = row(1)
local speedLabel = label(speedRow, 0, 110)
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 80, 1, 0)
speedBox.Position = UDim2.new(0, 115, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.TextSize = 14
speedBox.Text = "100"
speedBox.ClearTextOnFocus = false
speedBox.Parent = speedRow
local sbC = Instance.new("UICorner"); sbC.CornerRadius = UDim.new(0, 6); sbC.Parent = speedBox

local speedApply = Instance.new("TextButton")
speedApply.Size = UDim2.new(0, 80, 1, 0)
speedApply.Position = UDim2.new(0, 205, 0, 0)
speedApply.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
speedApply.TextColor3 = Color3.fromRGB(255, 255, 255)
speedApply.TextSize = 14
speedApply.Font = Enum.Font.GothamBold
speedApply.Parent = speedRow
local saC = Instance.new("UICorner"); saC.CornerRadius = UDim.new(0, 6); saC.Parent = speedApply

-- ジャンプ
local jumpRow = row(2)
local jumpLabel = label(jumpRow, 0, 110)
local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0, 80, 1, 0)
jumpBox.Position = UDim2.new(0, 115, 0, 0)
jumpBox.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBox.TextSize = 14
jumpBox.Text = "120"
jumpBox.ClearTextOnFocus = false
jumpBox.Parent = jumpRow
local jbC = Instance.new("UICorner"); jbC.CornerRadius = UDim.new(0, 6); jbC.Parent = jumpBox

local jumpApply = Instance.new("TextButton")
jumpApply.Size = UDim2.new(0, 80, 1, 0)
jumpApply.Position = UDim2.new(0, 205, 0, 0)
jumpApply.BackgroundColor3 = Color3.fromRGB(0, 170, 110)
jumpApply.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpApply.TextSize = 14
jumpApply.Font = Enum.Font.GothamBold
jumpApply.Parent = jumpRow
local jaC = Instance.new("UICorner"); jaC.CornerRadius = UDim.new(0, 6); jaC.Parent = jumpApply

-- 壁歩き
local wallRow = row(3)
local wallLabel = label(wallRow, 0, 110)
local wallToggle = Instance.new("TextButton")
wallToggle.Size = UDim2.new(0, 170, 1, 0)
wallToggle.Position = UDim2.new(0, 115, 0, 0)
wallToggle.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
wallToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
wallToggle.TextSize = 14
wallToggle.Font = Enum.Font.GothamBold
wallToggle.Parent = wallRow
local wC = Instance.new("UICorner"); wC.CornerRadius = UDim.new(0, 6); wC.Parent = wallToggle

-- 貫通
local noclipRow = row(4)
local noclipLabel = label(noclipRow, 0, 110)
local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, 170, 1, 0)
noclipToggle.Position = UDim2.new(0, 115, 0, 0)
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

-- タブ2 中身
local page2 = Instance.new("Frame")
page2.Size = UDim2.new(1, 0, 1, 0)
page2.BackgroundTransparency = 1
page2.Visible = false
page2.Parent = content
local page2Label = Instance.new("TextLabel")
page2Label.Size = UDim2.new(1, 0, 0, 40)
page2Label.BackgroundTransparency = 1
page2Label.TextColor3 = Color3.fromRGB(180, 180, 200)
page2Label.TextSize = 14
page2Label.Font = Enum.Font.Gotham
page2Label.TextXAlignment = Enum.TextXAlignment.Left
page2Label.Parent = page2

V.tab1.MouseButton1Click:Connect(function()
    page1.Visible = true; page2.Visible = false
    V.tab1.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
    V.tab2.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
end)
V.tab2.MouseButton1Click:Connect(function()
    page1.Visible = false; page2.Visible = true
    V.tab2.BackgroundColor3 = Color3.fromRGB(70, 70, 110)
    V.tab1.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
end)
V.tab1.BackgroundColor3 = Color3.fromRGB(70, 70, 110)

_G.ViodMenu.p2 = { page1=page1, page2=page2, page2Label=page2Label,
    speedLabel=speedLabel, speedBox=speedBox, speedApply=speedApply,
    jumpLabel=jumpLabel, jumpBox=jumpBox, jumpApply=jumpApply,
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

local function applyLang()
    local t = LANG[state.lang]
    V1.title.Text = t.title
    V1.langBtn.Text = (state.lang == "ja") and "日本語 🇯🇵" or "English 🇺🇸"
    V2.speedLabel.Text = t.speed
    V2.jumpLabel.Text = t.jump
    V2.wallLabel.Text = t.wall
    V2.noclipLabel.Text = t.noclip
    V2.respawnBtn.Text = t.respawn
    V2.speedApply.Text = t.exec
    V2.jumpApply.Text = t.exec
    V2.wallToggle.Text = state.wallWalk and t.on or t.off
    V2.noclipToggle.Text = state.noclip and t.on or t.off
    V2.page2Label.Text = t.info
end

V1.langBtn.MouseButton1Click:Connect(function()
    state.lang = (state.lang == "ja") and "en" or "ja"
    applyLang()
end)

-- 最小化
local function setMinimized(min)
    state.minimized = min
    if min then
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
end
V1.minBtn.MouseButton1Click:Connect(function() setMinimized(not state.minimized) end)
V1.closeBtn.MouseButton1Click:Connect(function() V1.screenGui:Destroy() end)

-- 機能
V2.speedApply.MouseButton1Click:Connect(function()
    local v = tonumber(V2.speedBox.Text)
    if not v or v <= 0 then
        V2.speedBox.Text = LANG[state.lang].err
        task.wait(1); V2.speedBox.Text = tostring(state.speed); return
    end
    state.speed = v; state.speedEnabled = true
    local h = getHum(); if h then h.WalkSpeed = v end
end)

V2.jumpApply.MouseButton1Click:Connect(function()
    local v = tonumber(V2.jumpBox.Text)
    if not v or v <= 0 then
        V2.jumpBox.Text = LANG[state.lang].err
        task.wait(1); V2.jumpBox.Text = tostring(state.jumpPower); return
    end
    state.jumpPower = v; state.jumpEnabled = true
    local h = getHum()
    if h then h.UseJumpPower = true; h.JumpPower = v end
end)

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

V2.respawnBtn.MouseButton1Click:Connect(function()
    local h = getHum()
    if h then h.Health = 0
    else local c = player.Character; if c then c:BreakJoints() end end
end)

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

applyLang()
print("[Viod Menu] Loaded / 読み込み完了")
