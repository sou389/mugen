-- ===== Viod Menu Part 1/5 =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local LANG = {
    ja = { title="Viod", player="プレイヤー", tools="ツール", settings="設定",
           speed="スピード:", jump="ジャンプ力:", wall="壁歩き:", noclip="貫通:",
           respawn="即リスポーン", exec="実行", on="ON", off="OFF", err="数値エラー",
           tp="テレポート", invis="透明化", rot="回転スピード:",
           fontSize="文字サイズ:", bg="背景色:",
           small="小", medium="中", large="大",
           blue="青", yellow="黄", red="赤", rainbow="虹", black="黒", white="白" },
    en = { title="Viod", player="Player", tools="Tools", settings="Settings",
           speed="Speed:", jump="Jump:", wall="Wall Walk:", noclip="Noclip:",
           respawn="Respawn", exec="Apply", on="ON", off="OFF", err="Invalid",
           tp="Teleport", invis="Invisible", rot="Rot Speed:",
           fontSize="Font Size:", bg="Background:",
           small="S", medium="M", large="L",
           blue="Blue", yellow="Yellow", red="Red", rainbow="Rainbow", black="Black", white="White" },
}

local state = {
    speed=16, jumpPower=50, wallWalk=false, noclip=false,
    speedEnabled=false, jumpEnabled=false, lang="en",
    tpEnabled=false, invisEnabled=false, rotSpeed=0,
    fontSize="medium", bgColor="black",
}
local originalCollide = {}
local originalTransparency = {}
local originalRot = {}

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
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 650, 0, 380)
mainFrame.Position = UDim2.new(0.5, -325, 0.5, -190)
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
langBtn.Text = "English 🇺🇸"
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

-- 左タブ（プレイヤー / ツール / 設定）
local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 130, 1, 0)
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
    b.TextSize = 16
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.LayoutOrder = order
    b.Parent = leftPanel
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = b
    return b
end

local playerTab = makeTab("Player", 1)
local toolsTab = makeTab("Tools", 2)
local settingsTab = makeTab("Settings", 3)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -140, 1, 0)
content.Position = UDim2.new(0, 140, 0, 0)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
content.BackgroundTransparency = 0.3
content.BorderSizePixel = 0
content.Parent = body
local cC = Instance.new("UICorner"); cC.CornerRadius = UDim.new(0, 8); cC.Parent = content

_G.ViodMenu = _G.ViodMenu or {}
_G.ViodMenu.p1 = { screenGui=screenGui, mainFrame=mainFrame, body=body,
    titleBar=titleBar, title=title, langBtn=langBtn, minBtn=minBtn, closeBtn=closeBtn,
    playerTab=playerTab, toolsTab=toolsTab, settingsTab=settingsTab,
    content=content, state=state, LANG=LANG, getHum=getHum, getHRP=getHRP,
    originalCollide=originalCollide, originalTransparency=originalTransparency,
    originalRot=originalRot }
-- ===== Viod Menu Part 2/5 =====
local V = _G.ViodMenu.p1
local LANG = V.LANG
local state = V.state
local content = V.content

local pagePlayer = Instance.new("Frame")
pagePlayer.Size = UDim2.new(1, 0, 1, 0)
pagePlayer.BackgroundTransparency = 1
pagePlayer.Parent = content
local ppPad = Instance.new("UIPadding")
ppPad.PaddingTop = UDim.new(0, 8)
ppPad.PaddingLeft = UDim.new(0, 10)
ppPad.PaddingRight = UDim.new(0, 10)
ppPad.Parent = pagePlayer
local ppL = Instance.new("UIListLayout")
ppL.Padding = UDim.new(0, 8)
ppL.Parent = pagePlayer

local function row(parent, order)
    local r = Instance.new("Frame")
    r.Size = UDim2.new(1, 0, 0, 38)
    r.BackgroundTransparency = 1
    r.LayoutOrder = order
    r.Parent = parent
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
local function makeBox(parent, x, w, default)
    local b = Instance.new("TextBox")
    b.Size = UDim2.new(0, w, 1, 0)
    b.Position = UDim2.new(0, x, 0, 0)
    b.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    b.Text = default
    b.ClearTextOnFocus = false
    b.Font = Enum.Font.Gotham
    b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = b
    return b
end
local function makeBtn(parent, x, w, text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, w, 1, 0)
    b.Position = UDim2.new(0, x, 0, 0)
    b.BackgroundColor3 = color or Color3.fromRGB(0, 170, 110)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = b
    return b
end

-- スピード
local speedRow = row(pagePlayer, 1)
local speedLabel = label(speedRow, 0, 95)
local speedBox = makeBox(speedRow, 100, 70, "100")
local speedApply = makeBtn(speedRow, 175, 70, "Apply")
local speedToggle = makeBtn(speedRow, 250, 90, "OFF", Color3.fromRGB(70,70,90))

-- ジャンプ
local jumpRow = row(pagePlayer, 2)
local jumpLabel = label(jumpRow, 0, 95)
local jumpBox = makeBox(jumpRow, 100, 70, "120")
local jumpApply = makeBtn(jumpRow, 175, 70, "Apply")
local jumpToggle = makeBtn(jumpRow, 250, 90, "OFF", Color3.fromRGB(70,70,90))

-- 壁歩き
local wallRow = row(pagePlayer, 3)
local wallLabel = label(wallRow, 0, 95)
local wallToggle = makeBtn(wallRow, 100, 245, "OFF", Color3.fromRGB(70,70,90))

-- 貫通
local noclipRow = row(pagePlayer, 4)
local noclipLabel = label(noclipRow, 0, 95)
local noclipToggle = makeBtn(noclipRow, 100, 245, "OFF", Color3.fromRGB(70,70,90))

-- リスポーン
local respawnRow = row(pagePlayer, 5)
local respawnBtn = makeBtn(respawnRow, 0, 340, "Respawn", Color3.fromRGB(200,70,70))

-- ツール画面
local pageTools = Instance.new("Frame")
pageTools.Size = UDim2.new(1, 0, 1, 0)
pageTools.BackgroundTransparency = 1
pageTools.Visible = false
pageTools.Parent = content
local ptPad = Instance.new("UIPadding")
ptPad.PaddingTop = UDim.new(0, 8)
ptPad.PaddingLeft = UDim.new(0, 10)
ptPad.PaddingRight = UDim.new(0, 10)
ptPad.Parent = pageTools
local ptL = Instance.new("UIListLayout")
ptL.Padding = UDim.new(0, 8)
ptL.Parent = pageTools

-- テレポート
local tpRow = row(pageTools, 1)
local tpLabel = label(tpRow, 0, 95)
local tpToggle = makeBtn(tpRow, 100, 245, "OFF", Color3.fromRGB(70,70,90))

-- 透明化
local invisRow = row(pageTools, 2)
local invisLabel = label(invisRow, 0, 95)
local invisToggle = makeBtn(invisRow, 100, 245, "OFF", Color3.fromRGB(70,70,90))

-- 回転スピード
local rotRow = row(pageTools, 3)
local rotLabel = label(rotRow, 0, 95)
local rotBox = makeBox(rotRow, 100, 70, "0")
local rotApply = makeBtn(rotRow, 175, 70, "Apply")

-- 設定画面
local pageSettings = Instance.new("Frame")
pageSettings.Size = UDim2.new(1, 0, 1, 0)
pageSettings.BackgroundTransparency = 1
pageSettings.Visible = false
pageSettings.Parent = content
local psPad = Instance.new("UIPadding")
psPad.PaddingTop = UDim.new(0, 8)
psPad.PaddingLeft = UDim.new(0, 10)
psPad.PaddingRight = UDim.new(0, 10)
psPad.Parent = pageSettings
local psL = Instance.new("UIListLayout")
psL.Padding = UDim.new(0, 8)
psL.Parent = pageSettings

-- 文字サイズ
local fontRow = row(pageSettings, 1)
local fontLabel = label(fontRow, 0, 95)
local fontSmall = makeBtn(fontRow, 100, 70, "S", Color3.fromRGB(70,70,90))
local fontMedium = makeBtn(fontRow, 175, 70, "M", Color3.fromRGB(0,150,200))
local fontLarge = makeBtn(fontRow, 250, 70, "L", Color3.fromRGB(70,70,90))

-- 背景色
local bgRow = row(pageSettings, 2)
local bgLabel = label(bgRow, 0, 95)
local bgBlue = makeBtn(bgRow, 100, 70, "Blue", Color3.fromRGB(40,80,200))
local bgYellow = makeBtn(bgRow, 175, 70, "Yellow", Color3.fromRGB(200,180,0))
local bgRed = makeBtn(bgRow, 250, 70, "Red", Color3.fromRGB(200,50,50))

local bgRow2 = row(pageSettings, 3)
local bgRainbow = makeBtn(bgRow2, 0, 70, "Rainbow", Color3.fromRGB(120,50,200))
local bgBlack = makeBtn(bgRow2, 75, 70, "Black", Color3.fromRGB(20,20,30))
local bgWhite = makeBtn(bgRow2, 150, 70, "White", Color3.fromRGB(230,230,230))

-- タブ切替
local function showPage(which)
    pagePlayer.Visible = (which == "player")
    pageTools.Visible = (which == "tools")
    pageSettings.Visible = (which == "settings")
    V.playerTab.BackgroundColor3 = (which=="player") and Color3.fromRGB(70,70,110) or Color3.fromRGB(50,50,75)
    V.toolsTab.BackgroundColor3 = (which=="tools") and Color3.fromRGB(70,70,110) or Color3.fromRGB(50,50,75)
    V.settingsTab.BackgroundColor3 = (which=="settings") and Color3.fromRGB(70,70,110) or Color3.fromRGB(50,50,75)
end
showPage("player")

V.playerTab.MouseButton1Click:Connect(function() showPage("player") end)
V.toolsTab.MouseButton1Click:Connect(function() showPage("tools") end)
V.settingsTab.MouseButton1Click:Connect(function() showPage("settings") end)

_G.ViodMenu.p2 = { pagePlayer=pagePlayer, pageTools=pageTools, pageSettings=pageSettings,
    speedLabel=speedLabel, speedBox=speedBox, speedApply=speedApply, speedToggle=speedToggle,
    jumpLabel=jumpLabel, jumpBox=jumpBox, jumpApply=jumpApply, jumpToggle=jumpToggle,
    wallLabel=wallLabel, wallToggle=wallToggle,
    noclipLabel=noclipLabel, noclipToggle=noclipToggle,
    respawnBtn=respawnBtn,
    tpLabel=tpLabel, tpToggle=tpToggle,
    invisLabel=invisLabel, invisToggle=invisToggle,
    rotLabel=rotLabel, rotBox=rotBox, rotApply=rotApply,
    fontLabel=fontLabel, fontSmall=fontSmall, fontMedium=fontMedium, fontLarge=fontLarge,
    bgLabel=bgLabel, bgBlue=bgBlue, bgYellow=bgYellow, bgRed=bgRed,
    bgRainbow=bgRainbow, bgBlack=bgBlack, bgWhite=bgWhite,
    showPage=showPage }
-- ===== Viod Menu Part 3/5 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local LANG = V1.LANG
local state = V1.state
local getHum = V1.getHum
local getHRP = V1.getHRP
local originalCollide = V1.originalCollide
local originalTransparency = V1.originalTransparency
local originalRot = V1.originalRot
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local baseSpeed = 16
local baseJump = 50

-- ===== スピード（即反映・高頻度再適用） =====
V2.speedApply.MouseButton1Click:Connect(function()
    local v = tonumber(V2.speedBox.Text)
    if not v or v <= 0 then V2.speedBox.Text = "0"; return end
    state.speed = v
    if state.speedEnabled then
        local h = getHum(); if h then h.WalkSpeed = v end
    end
end)
V2.speedToggle.MouseButton1Click:Connect(function()
    state.speedEnabled = not state.speedEnabled
    V2.speedToggle.BackgroundColor3 = state.speedEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.speedToggle.Text = state.speedEnabled and LANG[state.lang].on or LANG[state.lang].off
    local h = getHum()
    if h then
        if state.speedEnabled then
            baseSpeed = h.WalkSpeed
            h.WalkSpeed = state.speed
        else
            h.WalkSpeed = baseSpeed
        end
    end
end)

-- ===== ジャンプ =====
V2.jumpApply.MouseButton1Click:Connect(function()
    local v = tonumber(V2.jumpBox.Text)
    if not v or v <= 0 then V2.jumpBox.Text = "0"; return end
    state.jumpPower = v
    if state.jumpEnabled then
        local h = getHum(); if h then h.UseJumpPower=true; h.JumpPower = v end
    end
end)
V2.jumpToggle.MouseButton1Click:Connect(function()
    state.jumpEnabled = not state.jumpEnabled
    V2.jumpToggle.BackgroundColor3 = state.jumpEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.jumpToggle.Text = state.jumpEnabled and LANG[state.lang].on or LANG[state.lang].off
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
end)

-- ===== 壁歩き（接触時のみ発動） =====
V2.wallToggle.MouseButton1Click:Connect(function()
    state.wallWalk = not state.wallWalk
    V2.wallToggle.BackgroundColor3 = state.wallWalk
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.wallToggle.Text = state.wallWalk and LANG[state.lang].on or LANG[state.lang].off
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
    -- 前方向に短いレイ（接触判定）
    local res = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 2.5, params)
    if res and res.Normal and math.abs(res.Normal.Y) < 0.3 then
        -- 壁に接触している時だけ吸着
        local n = res.Normal
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, hum.WalkSpeed * 0.5, 0) + (-n * 3)
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position - n)
    else
        -- 接触していない時は無効
        bv.MaxForce = Vector3.zero
        bg.MaxTorque = Vector3.zero
    end
end)

-- ===== 貫通 =====
V2.noclipToggle.MouseButton1Click:Connect(function()
    state.noclip = not state.noclip
    V2.noclipToggle.BackgroundColor3 = state.noclip
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.noclipToggle.Text = state.noclip and LANG[state.lang].on or LANG[state.lang].off
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

-- ===== テレポート =====
local tpGui = nil
local function createTpButton()
    if tpGui then tpGui:Destroy() end
    tpGui = Instance.new("ScreenGui")
    tpGui.Name = "ViodTp"
    tpGui.ResetOnSpawn = false
    tpGui.IgnoreGuiInset = true
    tpGui.DisplayOrder = 1000
    tpGui.Parent = player:WaitForChild("PlayerGui")

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 30)
    btn.Position = UDim2.new(0.5, -45, 1, -50)
    btn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    btn.BackgroundTransparency = 0.3
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamBold
    btn.Text = "Teleport"
    btn.Parent = tpGui
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn

    -- 画面タップ判定（UI以外の場所）
    UIS.InputBegan:Connect(function(input)
        if not state.tpEnabled then return end
        if input.UserInputType == Enum.UserInputType.Touch
            or input.UserInputType == Enum.UserInputType.MouseButton1 then
            local guiObjects = player.PlayerGui:GetGuiObjectsAtPosition(
                input.Position.X, input.Position.Y)
            for _, g in ipairs(guiObjects) do
                if g:IsDescendantOf(tpGui) or g:IsDescendantOf(V1.screenGui) then
                    return -- UI上は無視
                end
            end
            -- タップ位置からレイを飛ばして移動
            local cam = workspace.CurrentCamera
            local ray = cam:ScreenPointToRay(input.Position.X, input.Position.Y)
            local params = RaycastParams.new()
            params.FilterType = Enum.RaycastFilterType.Exclude
            params.FilterDescendantsInstances = {player.Character}
            local result = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)
            if result then
                local hrp = getHRP()
                if hrp then
                    hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 3, 0))
                end
            end
        end
    end)
end

V2.tpToggle.MouseButton1Click:Connect(function()
    state.tpEnabled = not state.tpEnabled
    V2.tpToggle.BackgroundColor3 = state.tpEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.tpToggle.Text = state.tpEnabled and LANG[state.lang].on or LANG[state.lang].off
    if state.tpEnabled then createTpButton() else if tpGui then tpGui:Destroy(); tpGui = nil end end
end)

-- ===== 透明化 =====
V2.invisToggle.MouseButton1Click:Connect(function()
    state.invisEnabled = not state.invisEnabled
    V2.invisToggle.BackgroundColor3 = state.invisEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.invisToggle.Text = state.invisEnabled and LANG[state.lang].on or LANG[state.lang].off
    local char = player.Character; if not char then return end
    if state.invisEnabled then
        for _, p in ipairs(char:GetDescendants()) do
            if p:IsA("BasePart") then
                originalTransparency[p] = p.Transparency
                p.Transparency = 0.95
            end
        end
    else
        for p, t in pairs(originalTransparency) do
            if p and p.Parent then p.Transparency = t end
        end
        for k in pairs(originalTransparency) do originalTransparency[k] = nil end
    end
end)

-- ===== 回転スピード =====
V2.rotApply.MouseButton1Click:Connect(function()
    local v = tonumber(V2.rotBox.Text)
    if not v then V2.rotBox.Text = "0"; return end
    state.rotSpeed = v
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local av = hrp:FindFirstChild("RotVelocity")
    if v == 0 then
        if av then av:Destroy() end
    else
        if not av then
            av = Instance.new("AngularVelocity")
            av.Name = "RotVelocity"
            av.AffectsGroundOnly = false
            av.AffectsTorque = true
            av.RelativeTo = Enum.ActuatorRelativeTo.World
            av.Parent = hrp
        end
        av.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        av.AngularVelocity = Vector3.new(0, v, 0)
    end
end)
-- ===== Viod Menu Part 4/5 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local LANG = V1.LANG
local state = V1.state

-- ===== 文字サイズ =====
local fontScale = { small=0.75, medium=1.0, large=1.3 }
local function applyFontSize()
    local s = fontScale[state.fontSize] or 1.0
    -- メイン内の全TextLabel/TextButton/TextBoxをスケール
    for _, obj in ipairs(V1.mainFrame:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            if not obj:GetAttribute("baseSize") then
                obj:SetAttribute("baseSize", obj.TextSize)
            end
            local base = obj:GetAttribute("baseSize") or obj.TextSize
            obj.TextSize = math.floor(base * s)
        end
    end
    -- ボタン色の更新
    V2.fontSmall.BackgroundColor3 = (state.fontSize=="small")
        and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
    V2.fontMedium.BackgroundColor3 = (state.fontSize=="medium")
        and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
    V2.fontLarge.BackgroundColor3 = (state.fontSize=="large")
        and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
end

V2.fontSmall.MouseButton1Click:Connect(function() state.fontSize="small"; applyFontSize() end)
V2.fontMedium.MouseButton1Click:Connect(function() state.fontSize="medium"; applyFontSize() end)
V2.fontLarge.MouseButton1Click:Connect(function() state.fontSize="large"; applyFontSize() end)

-- ===== 背景色 =====
local bgRainbowLoop = nil
local function stopRainbow()
    if bgRainbowLoop then bgRainbowLoop = nil end
end

local function applyBgColor(color)
    stopRainbow()
    V1.mainFrame.BackgroundColor3 = color
    V1.content.BackgroundColor3 = Color3.fromRGB(
        math.max(0, color.R*255*0.6),
        math.max(0, color.G*255*0.6),
        math.max(0, color.B*255*0.6))
    -- ボタン色の更新
    V2.bgBlue.BackgroundColor3 = Color3.fromRGB(40,80,200)
    V2.bgYellow.BackgroundColor3 = Color3.fromRGB(200,180,0)
    V2.bgRed.BackgroundColor3 = Color3.fromRGB(200,50,50)
    V2.bgRainbow.BackgroundColor3 = Color3.fromRGB(120,50,200)
    V2.bgBlack.BackgroundColor3 = Color3.fromRGB(20,20,30)
    V2.bgWhite.BackgroundColor3 = Color3.fromRGB(230,230,230)
end

V2.bgBlue.MouseButton1Click:Connect(function()
    state.bgColor="blue"; applyBgColor(Color3.fromRGB(20,50,120))
end)
V2.bgYellow.MouseButton1Click:Connect(function()
    state.bgColor="yellow"; applyBgColor(Color3.fromRGB(120,110,0))
end)
V2.bgRed.MouseButton1Click:Connect(function()
    state.bgColor="red"; applyBgColor(Color3.fromRGB(120,30,30))
end)
V2.bgBlack.MouseButton1Click:Connect(function()
    state.bgColor="black"; applyBgColor(Color3.fromRGB(20,20,30))
end)
V2.bgWhite.MouseButton1Click:Connect(function()
    state.bgColor="white"; applyBgColor(Color3.fromRGB(230,230,230))
end)

V2.bgRainbow.MouseButton1Click:Connect(function()
    state.bgColor="rainbow"
    stopRainbow()
    local hue = 0
    local function loop()
        if not bgRainbowLoop then return end
        hue = (hue + 0.01) % 1
        local c = Color3.fromHSV(hue, 0.9, 0.6)
        V1.mainFrame.BackgroundColor3 = c
        V1.content.BackgroundColor3 = Color3.fromHSV(hue, 0.9, 0.35)
        task.wait(0.05)
        loop()
    end
    bgRainbowLoop = true
    task.spawn(loop)
end)

_G.ViodMenu.p4 = { applyFontSize=applyFontSize, applyBgColor=applyBgColor }
-- ===== Viod Menu Part 5/5 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local LANG = V1.LANG
local state = V1.state
local getHum = V1.getHum
local originalCollide = V1.originalCollide

local function applyLang()
    local t = LANG[state.lang]
    V1.title.Text = t.title
    V1.langBtn.Text = (state.lang == "ja") and "日本語 🇯🇵" or "English 🇺🇸"
    V1.playerTab.Text = t.player
    V1.toolsTab.Text = t.tools
    V1.settingsTab.Text = t.settings
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
    -- tools
    V2.tpLabel.Text = t.tp
    V2.invisLabel.Text = t.invis
    V2.rotLabel.Text = t.rot
    V2.rotApply.Text = t.exec
    V2.tpToggle.Text = state.tpEnabled and t.on or t.off
    V2.invisToggle.Text = state.invisEnabled and t.on or t.off
    -- settings
    V2.fontLabel.Text = t.fontSize
    V2.fontSmall.Text = t.small
    V2.fontMedium.Text = t.medium
    V2.fontLarge.Text = t.large
    V2.bgLabel.Text = t.bg
    V2.bgBlue.Text = t.blue
    V2.bgYellow.Text = t.yellow
    V2.bgRed.Text = t.red
    V2.bgRainbow.Text = t.rainbow
    V2.bgBlack.Text = t.black
    V2.bgWhite.Text = t.white
end

V1.langBtn.MouseButton1Click:Connect(function()
    state.lang = (state.lang == "ja") and "en" or "ja"
    applyLang()
end)

-- ===== 定期再適用（0.05秒） =====
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
        task.wait(0.05)
    end
end)

-- ===== ✖ : ウィンドウ非表示 → 右上に V =====
V1.closeBtn.MouseButton1Click:Connect(function()
    V1.mainFrame.Visible = false
    local old = V1.screenGui:FindFirstChild("VOnlyButton")
    if old then old:Destroy() end
    local vBtn = Instance.new("TextButton")
    vBtn.Name = "VOnlyButton"
    vBtn.Size = UDim2.new(0, 44, 0, 44)
    vBtn.Position = UDim2.new(1, -60, 0, 15)
    vBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    vBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    vBtn.TextSize = 22
    vBtn.Font = Enum.Font.GothamBold
    vBtn.Text = "V"
    vBtn.ZIndex = 100
    vBtn.Parent = V1.screenGui
    local vc = Instance.new("UICorner"); vc.CornerRadius = UDim.new(0, 8); vc.Parent = vBtn
    local vs = Instance.new("UIStroke")
    vs.Thickness = 2; vs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    vs.Parent = vBtn
    task.spawn(function()
        local hue = 0
        while vBtn.Parent do
            hue = (hue + 0.01) % 1
            vs.Color = Color3.fromHSV(hue, 1, 1)
            task.wait(0.03)
        end
    end)
    vBtn.MouseButton1Click:Connect(function()
        V1.mainFrame.Visible = true
        vBtn:Destroy()
    end)
end)

-- ===== − : V に変化 → もう一度で戻る =====
local minimized = false
V1.minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        V1.body.Visible = false
        V1.minBtn.Text = "V"
        V1.minBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
        V1.mainFrame.Size = UDim2.new(0, 650, 0, 40)
    else
        V1.body.Visible = true
        V1.minBtn.Text = "−"
        V1.minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
        V1.mainFrame.Size = UDim2.new(0, 650, 0, 380)
    end
end)

-- 初期反映
applyLang()
if _G.ViodMenu.p4 then
    _G.ViodMenu.p4.applyFontSize()
    _G.ViodMenu.p4.applyBgColor(Color3.fromRGB(20,20,30))
end
print("[Viod Menu] Loaded / 読み込み完了")
