-- ===== Viod Menu Part 1/7 =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local LANG = {
    ja = { title="Viod", player="プレイヤー", tools="ツール", settings="設定",
           speed="スピード:", jump="ジャンプ力:", wall="壁歩き:", noclip="貫通:",
           respawn="即リスポーン", on="ON", off="OFF",
           tp="テレポート", invis="透明化", rot="回転スピード:",
           fontSize="文字サイズ:", bg="背景色:", tpsave="テレポート保存",
           pose="ポーズ歩き:", poseNormal="通常", poseRagdoll="ラグドール",
           poseT="Tポーズ", poseSit="座り",
           saveBtn="保存",
           small="小", medium="中", large="大",
           blue="青", yellow="黄", red="赤", rainbow="虹", black="黒", white="白" },
    en = { title="Viod", player="Player", tools="Tools", settings="Settings",
           speed="Speed:", jump="Jump:", wall="Wall Walk:", noclip="Noclip:",
           respawn="Respawn", on="ON", off="OFF",
           tp="Teleport", invis="Invisible", rot="Rot Speed:",
           fontSize="Font Size:", bg="Background:", tpsave="Save TP",
           pose="Pose Walk:", poseNormal="Normal", poseRagdoll="Ragdoll",
           poseT="T-Pose", poseSit="Sit",
           saveBtn="Save",
           small="S", medium="M", large="L",
           blue="Blue", yellow="Yellow", red="Red", rainbow="Rainbow", black="Black", white="White" },
}

local state = {
    speed=16, jumpPower=50, wallWalk=false, noclip=false,
    speedEnabled=false, jumpEnabled=false, lang="en",
    tpEnabled=false, invisEnabled=false, rotEnabled=false, rotSpeed=180,
    fontSize="medium", bgColor="black", pose="normal",
    savedTPs = {},
}
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
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 560, 0, 360)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -180)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.55
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
titleBar.Size = UDim2.new(1, 0, 0, 36)
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
title.Size = UDim2.new(0, 180, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 105, 0, 26)
langBtn.Position = UDim2.new(1, -192, 0, 5)
langBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.TextSize = 12
langBtn.Font = Enum.Font.GothamBold
langBtn.Text = "English 🇺🇸"
langBtn.Parent = titleBar
local lc = Instance.new("UICorner"); lc.CornerRadius = UDim.new(0, 6); lc.Parent = langBtn

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -82, 0, 5)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 17
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "−"
minBtn.Parent = titleBar
local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, 6); mc.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -52, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 15
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Text = "✖"
closeBtn.Parent = titleBar
local cc = Instance.new("UICorner"); cc.CornerRadius = UDim.new(0, 6); cc.Parent = closeBtn

local body = Instance.new("Frame")
body.Size = UDim2.new(1, -16, 1, -44)
body.Position = UDim2.new(0, 8, 0, 40)
body.BackgroundTransparency = 1
body.Parent = mainFrame

local leftPanel = Instance.new("Frame")
leftPanel.Size = UDim2.new(0, 110, 1, 0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = body
local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 6)
leftLayout.Parent = leftPanel

local function makeTab(text, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 40)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    b.BackgroundTransparency = 0.3
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 14
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
content.Size = UDim2.new(1, -120, 1, 0)
content.Position = UDim2.new(0, 120, 0, 0)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
content.BackgroundTransparency = 0.45
content.BorderSizePixel = 0
content.Parent = body
local cC = Instance.new("UICorner"); cC.CornerRadius = UDim.new(0, 8); cC.Parent = content

-- 左下 プレイヤーカード
local playerCard = Instance.new("Frame")
playerCard.Size = UDim2.new(0, 180, 0, 56)
playerCard.Position = UDim2.new(0, 10, 1, -66)
playerCard.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
playerCard.BackgroundTransparency = 0.25
playerCard.BorderSizePixel = 0
playerCard.ZIndex = 50
playerCard.Parent = screenGui
local pcC = Instance.new("UICorner"); pcC.CornerRadius = UDim.new(0, 8); pcC.Parent = playerCard

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 44, 0, 44)
avatarImg.Position = UDim2.new(0, 6, 0.5, -22)
avatarImg.BackgroundColor3 = Color3.fromRGB(255,255,255)
avatarImg.BackgroundTransparency = 0.2
avatarImg.ScaleType = Enum.ScaleType.Crop
avatarImg.ZIndex = 51
avatarImg.Parent = playerCard
local avC = Instance.new("UICorner"); avC.CornerRadius = UDim.new(1, 0); avC.Parent = avatarImg
local avAR = Instance.new("UIAspectRatioConstraint")
avAR.AspectRatio = 1
avAR.Parent = avatarImg

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -60, 1, -12)
nameLabel.Position = UDim2.new(0, 54, 0, 6)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 12
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.TextYAlignment = Enum.TextYAlignment.Center
nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
nameLabel.TextWrapped = false
nameLabel.ClipsDescendants = true
nameLabel.ZIndex = 51
nameLabel.Parent = playerCard

task.spawn(function()
    local ok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId,
            Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and thumb then avatarImg.Image = thumb end
    nameLabel.Text = player.DisplayName or player.Name
end)
player.CharacterAdded:Connect(function()
    task.wait(0.5)
    nameLabel.Text = player.DisplayName or player.Name
end)

_G.ViodMenu = _G.ViodMenu or {}
_G.ViodMenu.p1 = { screenGui=screenGui, mainFrame=mainFrame, body=body,
    titleBar=titleBar, title=title, langBtn=langBtn, minBtn=minBtn, closeBtn=closeBtn,
    playerTab=playerTab, toolsTab=toolsTab, settingsTab=settingsTab,
    content=content, state=state, LANG=LANG, getHum=getHum, getHRP=getHRP,
    originalCollide=originalCollide }
-- ===== Viod Menu Part 2/7 =====
local V = _G.ViodMenu.p1
local LANG = V.LANG
local state = V.state
local content = V.content

local pagePlayer = Instance.new("Frame")
pagePlayer.Size = UDim2.new(1, 0, 1, 0)
pagePlayer.BackgroundTransparency = 1
pagePlayer.Parent = content
local ppPad = Instance.new("UIPadding")
ppPad.PaddingTop = UDim.new(0, 6)
ppPad.PaddingLeft = UDim.new(0, 8)
ppPad.PaddingRight = UDim.new(0, 8)
ppPad.Parent = pagePlayer
local ppL = Instance.new("UIListLayout")
ppL.Padding = UDim.new(0, 6)
ppL.Parent = pagePlayer

local function row(parent, order)
    local r = Instance.new("Frame")
    r.Size = UDim2.new(1, 0, 0, 34)
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
    l.TextSize = 13
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
    b.BackgroundTransparency = 0.3
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 13
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
    b.BackgroundColor3 = color or Color3.fromRGB(70,70,90)
    b.BackgroundTransparency = 0.2
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = b
    return b
end

-- スピード
local speedRow = row(pagePlayer, 1)
local speedLabel = label(speedRow, 0, 85)
local speedBox = makeBox(speedRow, 90, 70, "100")
local speedToggle = makeBtn(speedRow, 165, 80, "OFF")

-- ジャンプ
local jumpRow = row(pagePlayer, 2)
local jumpLabel = label(jumpRow, 0, 85)
local jumpBox = makeBox(jumpRow, 90, 70, "120")
local jumpToggle = makeBtn(jumpRow, 165, 80, "OFF")

-- 壁歩き
local wallRow = row(pagePlayer, 3)
local wallLabel = label(wallRow, 0, 85)
local wallToggle = makeBtn(wallRow, 90, 155, "OFF")

-- 貫通
local noclipRow = row(pagePlayer, 4)
local noclipLabel = label(noclipRow, 0, 85)
local noclipToggle = makeBtn(noclipRow, 90, 155, "OFF")

-- リスポーン
local respawnRow = row(pagePlayer, 5)
local respawnBtn = makeBtn(respawnRow, 0, 245, "Respawn", Color3.fromRGB(200,70,70))

-- ツール画面
local pageTools = Instance.new("Frame")
pageTools.Size = UDim2.new(1, 0, 1, 0)
pageTools.BackgroundTransparency = 1
pageTools.Visible = false
pageTools.Parent = content
local ptPad = Instance.new("UIPadding")
ptPad.PaddingTop = UDim.new(0, 6)
ptPad.PaddingLeft = UDim.new(0, 8)
ptPad.PaddingRight = UDim.new(0, 8)
ptPad.Parent = pageTools
local ptL = Instance.new("UIListLayout")
ptL.Padding = UDim.new(0, 6)
ptL.Parent = pageTools

-- テレポート
local tpRow = row(pageTools, 1)
local tpLabel = label(tpRow, 0, 85)
local tpToggle = makeBtn(tpRow, 90, 155, "OFF")

-- テレポート保存
local tpSaveRow = row(pageTools, 2)
local tpSaveLabel = label(tpSaveRow, 0, 85)
local tpSaveBox = makeBox(tpSaveRow, 90, 100, "")
local tpSaveBtn = makeBtn(tpSaveRow, 195, 50, "Save")

-- 保存リスト
local tpListRow = row(pageTools, 3)
tpListRow.Size = UDim2.new(1, 0, 0, 90)
local tpListFrame = Instance.new("ScrollingFrame")
tpListFrame.Size = UDim2.new(1, 0, 1, 0)
tpListFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
tpListFrame.BackgroundTransparency = 0.4
tpListFrame.BorderSizePixel = 0
tpListFrame.ScrollBarThickness = 4
tpListFrame.Parent = tpListRow
local tlC = Instance.new("UICorner"); tlC.CornerRadius = UDim.new(0, 6); tlC.Parent = tpListFrame
local tlLayout = Instance.new("UIListLayout")
tlLayout.Padding = UDim.new(0, 4)
tlLayout.Parent = tpListFrame

-- 透明化
local invisRow = row(pageTools, 4)
local invisLabel = label(invisRow, 0, 85)
local invisToggle = makeBtn(invisRow, 90, 155, "OFF")

-- 回転
local rotRow = row(pageTools, 5)
local rotLabel = label(rotRow, 0, 85)
local rotBox = makeBox(rotRow, 90, 70, "180")
local rotToggle = makeBtn(rotRow, 165, 80, "OFF")

-- ポーズ歩き
local poseRow = row(pageTools, 6)
local poseLabel = label(poseRow, 0, 85)
local poseNormal = makeBtn(poseRow, 90, 50, "Normal", Color3.fromRGB(0,150,200))
local poseRagdoll = makeBtn(poseRow, 145, 50, "Rag")
local poseT = makeBtn(poseRow, 200, 45, "T")

local poseRow2 = row(pageTools, 7)
local poseSit = makeBtn(poseRow2, 0, 60, "Sit")

-- 設定画面
local pageSettings = Instance.new("Frame")
pageSettings.Size = UDim2.new(1, 0, 1, 0)
pageSettings.BackgroundTransparency = 1
pageSettings.Visible = false
pageSettings.Parent = content
local psPad = Instance.new("UIPadding")
psPad.PaddingTop = UDim.new(0, 6)
psPad.PaddingLeft = UDim.new(0, 8)
psPad.PaddingRight = UDim.new(0, 8)
psPad.Parent = pageSettings
local psL = Instance.new("UIListLayout")
psL.Padding = UDim.new(0, 6)
psL.Parent = pageSettings

local fontRow = row(pageSettings, 1)
local fontLabel = label(fontRow, 0, 85)
local fontSmall = makeBtn(fontRow, 90, 50, "S")
local fontMedium = makeBtn(fontRow, 145, 50, "M", Color3.fromRGB(0,150,200))
local fontLarge = makeBtn(fontRow, 200, 50, "L")

local bgRow = row(pageSettings, 2)
local bgLabel = label(bgRow, 0, 85)
local bgBlue = makeBtn(bgRow, 90, 55, "Blue", Color3.fromRGB(40,80,200))
local bgYellow = makeBtn(bgRow, 150, 60, "Yellow", Color3.fromRGB(200,180,0))
local bgRed = makeBtn(bgRow, 215, 40, "Red", Color3.fromRGB(200,50,50))

local bgRow2 = row(pageSettings, 3)
local bgRainbow = makeBtn(bgRow2, 0, 65, "Rainbow", Color3.fromRGB(120,50,200))
local bgBlack = makeBtn(bgRow2, 70, 60, "Black", Color3.fromRGB(20,20,30))
local bgWhite = makeBtn(bgRow2, 135, 60, "White", Color3.fromRGB(230,230,230))

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
    speedLabel=speedLabel, speedBox=speedBox, speedToggle=speedToggle,
    jumpLabel=jumpLabel, jumpBox=jumpBox, jumpToggle=jumpToggle,
    wallLabel=wallLabel, wallToggle=wallToggle,
    noclipLabel=noclipLabel, noclipToggle=noclipToggle,
    respawnBtn=respawnBtn,
    tpLabel=tpLabel, tpToggle=tpToggle,
    tpSaveLabel=tpSaveLabel, tpSaveBox=tpSaveBox, tpSaveBtn=tpSaveBtn, tpListFrame=tpListFrame,
    invisLabel=invisLabel, invisToggle=invisToggle,
    rotLabel=rotLabel, rotBox=rotBox, rotToggle=rotToggle,
    poseLabel=poseLabel, poseNormal=poseNormal, poseRagdoll=poseRagdoll,
    poseT=poseT, poseSit=poseSit,
    fontLabel=fontLabel, fontSmall=fontSmall, fontMedium=fontMedium, fontLarge=fontLarge,
    bgLabel=bgLabel, bgBlue=bgBlue, bgYellow=bgYellow, bgRed=bgRed,
    bgRainbow=bgRainbow, bgBlack=bgBlack, bgWhite=bgWhite,
    showPage=showPage }
-- ===== Viod Menu Part 3/7 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local LANG = V1.LANG
local state = V1.state
local getHum = V1.getHum
local getHRP = V1.getHRP
local originalCollide = V1.originalCollide
local RunService = game:GetService("RunService")
local player = game.Players.LocalPlayer

local baseSpeed = 16
local baseJump = 50

-- スピード
V2.speedBox.FocusLost:Connect(function()
    local v = tonumber(V2.speedBox.Text)
    if not v or v <= 0 then V2.speedBox.Text = tostring(state.speed); return end
    state.speed = v
    if state.speedEnabled then local h=getHum(); if h then h.WalkSpeed=v end end
end)
V2.speedToggle.MouseButton1Click:Connect(function()
    state.speedEnabled = not state.speedEnabled
    V2.speedToggle.BackgroundColor3 = state.speedEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.speedToggle.Text = state.speedEnabled and LANG[state.lang].on or LANG[state.lang].off
    local h = getHum()
    if h then
        if state.speedEnabled then baseSpeed = h.WalkSpeed; h.WalkSpeed = state.speed
        else h.WalkSpeed = baseSpeed end
    end
end)

-- ジャンプ
V2.jumpBox.FocusLost:Connect(function()
    local v = tonumber(V2.jumpBox.Text)
    if not v or v <= 0 then V2.jumpBox.Text = tostring(state.jumpPower); return end
    state.jumpPower = v
    if state.jumpEnabled then local h=getHum(); if h then h.UseJumpPower=true; h.JumpPower=v end end
end)
V2.jumpToggle.MouseButton1Click:Connect(function()
    state.jumpEnabled = not state.jumpEnabled
    V2.jumpToggle.BackgroundColor3 = state.jumpEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.jumpToggle.Text = state.jumpEnabled and LANG[state.lang].on or LANG[state.lang].off
    local h = getHum()
    if h then
        if state.jumpEnabled then baseJump = h.JumpPower; h.UseJumpPower=true; h.JumpPower = state.jumpPower
        else h.JumpPower = baseJump end
    end
end)

-- 壁歩き
V2.wallToggle.MouseButton1Click:Connect(function()
    state.wallWalk = not state.wallWalk
    V2.wallToggle.BackgroundColor3 = state.wallWalk
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.wallToggle.Text = state.wallWalk and LANG[state.lang].on or LANG[state.lang].off
    local hrp = getHRP(); if not hrp then return end
    if state.wallWalk then
        if not hrp:FindFirstChild("WallWalkForce") then
            local bv = Instance.new("BodyVelocity")
            bv.Name="WallWalkForce"; bv.MaxForce=Vector3.zero; bv.Velocity=Vector3.zero; bv.Parent=hrp
        end
        if not hrp:FindFirstChild("WallWalkGyro") then
            local bg = Instance.new("BodyGyro")
            bg.Name="WallWalkGyro"; bg.MaxTorque=Vector3.zero; bg.Parent=hrp
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
    local res = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 2.5, params)
    if res and res.Normal and math.abs(res.Normal.Y) < 0.3 then
        local n = res.Normal
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = Vector3.new(0, hum.WalkSpeed * 0.5, 0) + (-n * 3)
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position - n)
    else
        bv.MaxForce = Vector3.zero; bg.MaxTorque = Vector3.zero
    end
end)

-- 貫通
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

-- リスポーン
V2.respawnBtn.MouseButton1Click:Connect(function()
    local h = getHum()
    if h then h.Health = 0
    else local c = player.Character; if c then c:BreakJoints() end end
end)

-- 透明化
V2.invisToggle.MouseButton1Click:Connect(function()
    state.invisEnabled = not state.invisEnabled
    V2.invisToggle.BackgroundColor3 = state.invisEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.invisToggle.Text = state.invisEnabled and LANG[state.lang].on or LANG[state.lang].off
    local char = player.Character; if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.Transparency = state.invisEnabled and 0.95 or 0
        end
    end
end)

-- 回転
local function applyRot()
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
    local av = hrp:FindFirstChild("RotVelocity")
    if not state.rotEnabled then if av then av:Destroy() end return end
    if not av then
        av = Instance.new("AngularVelocity")
        av.Name="RotVelocity"; av.AffectsGroundOnly=false; av.AffectsTorque=true
        av.RelativeTo=Enum.ActuatorRelativeTo.World; av.Parent=hrp
    end
    av.MaxTorque = Vector3.new(1e5,1e5,1e5)
    av.AngularVelocity = Vector3.new(0, state.rotSpeed, 0)
end
V2.rotBox.FocusLost:Connect(function()
    local v = tonumber(V2.rotBox.Text)
    if not v then V2.rotBox.Text = tostring(state.rotSpeed); return end
    state.rotSpeed = v
    if state.rotEnabled then applyRot() end
end)
V2.rotToggle.MouseButton1Click:Connect(function()
    state.rotEnabled = not state.rotEnabled
    V2.rotToggle.BackgroundColor3 = state.rotEnabled
        and Color3.fromRGB(0, 170, 110) or Color3.fromRGB(70,70,90)
    V2.rotToggle.Text = state.rotEnabled and LANG[state.lang].on or LANG[state.lang].off
    applyRot()
end)

-- 定期再適用
task.spawn(function()
    while V1.screenGui.Parent do
        local h = getHum()
        if h then
            if state.speedEnabled and h.WalkSpeed ~= state.speed then h.WalkSpeed = state.speed end
            if state.jumpEnabled then
                h.UseJumpPower = true
                if h.JumpPower ~= state.jumpPower then h.JumpPower = state.jumpPower end
            end
        end
        task.wait(0.05)
    end
end)
-- ===== Viod Menu Part 4/7 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local LANG = V1.LANG
local state = V1.state
local getHRP = V1.getHRP
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- ===== テレポート小UI =====
local tpGui = nil
local function createTpUI()
    if tpGui then tpGui:Destroy() end
    tpGui = Instance.new("ScreenGui")
    tpGui.Name = "ViodTp"
    tpGui.ResetOnSpawn = false
    tpGui.IgnoreGuiInset = true
    tpGui.DisplayOrder = 1000
    tpGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 150, 0, 30)
    frame.Position = UDim2.new(0.5, -75, 1, -100)
    frame.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0
    frame.Parent = tpGui
    local fC = Instance.new("UICorner"); fC.CornerRadius = UDim.new(0, 8); fC.Parent = frame

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 110, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3 = Color3.fromRGB(255,255,255)
    lbl.TextSize = 10
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "Teleport"
    lbl.Parent = frame

    local tg = Instance.new("TextButton")
    tg.Size = UDim2.new(0, 34, 1, 0)
    tg.Position = UDim2.new(1, -34, 0, 0)
    tg.BackgroundColor3 = state.tpEnabled and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    tg.TextColor3 = Color3.fromRGB(255,255,255)
    tg.TextSize = 9
    tg.Font = Enum.Font.GothamBold
    tg.Text = state.tpEnabled and "ON" or "OFF"
    tg.Parent = frame
    local tC = Instance.new("UICorner"); tC.CornerRadius = UDim.new(0, 8); tC.Parent = tg
    tg.MouseButton1Click:Connect(function()
        state.tpEnabled = not state.tpEnabled
        tg.Text = state.tpEnabled and "ON" or "OFF"
        tg.BackgroundColor3 = state.tpEnabled and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
        V2.tpToggle.Text = state.tpEnabled and LANG[state.lang].on or LANG[state.lang].off
        V2.tpToggle.BackgroundColor3 = state.tpEnabled and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    end)
end

-- タップで移動（快適版）
local touchStart = nil
UIS.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    local pos = input.Position
    local vp = workspace.CurrentCamera.ViewportSize
    if pos.X > vp.X * 0.5 then return end
    touchStart = { pos = pos, time = tick() }
end)
UIS.InputEnded:Connect(function(input, processed)
    if processed then return end
    if not state.tpEnabled then touchStart=nil; return end
    if not touchStart then return end
    if input.UserInputType ~= Enum.UserInputType.Touch
        and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    local dur = tick() - touchStart.time
    local dist = (input.Position - touchStart.pos).Magnitude
    touchStart = nil
    if dur > 0.3 or dist > 20 then return end
    local guis = player.PlayerGui:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
    for _, g in ipairs(guis) do
        if g:IsDescendantOf(tpGui) or g:IsDescendantOf(V1.screenGui)
            or (g:IsDescendantOf(player.PlayerGui) and g.Name:match("^Viod")) then return end
    end
    local cam = workspace.CurrentCamera
    local ray = cam:ScreenPointToRay(input.Position.X, input.Position.Y)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {player.Character}
    local result = workspace:Raycast(ray.Origin, ray.Direction * 2000, params)
    if result then
        local hrp = getHRP()
        if hrp then hrp.CFrame = CFrame.new(result.Position + Vector3.new(0,3,0)) end
    end
end)

V2.tpToggle.MouseButton1Click:Connect(function()
    state.tpEnabled = not state.tpEnabled
    V2.tpToggle.BackgroundColor3 = state.tpEnabled
        and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    V2.tpToggle.Text = state.tpEnabled and LANG[state.lang].on or LANG[state.lang].off
    if state.tpEnabled then createTpUI() else if tpGui then tpGui:Destroy(); tpGui=nil end end
end)

-- ===== テレポート保存 =====
local function refreshTpList()
    for _, c in ipairs(V2.tpListFrame:GetChildren()) do
        if c:IsA("TextButton") or c:IsA("Frame") then c:Destroy() end
    end
    local y = 0
    for i, entry in ipairs(state.savedTPs) do
        local item = Instance.new("Frame")
        item.Size = UDim2.new(1, -6, 0, 24)
        item.Position = UDim2.new(0, 3, 0, y)
        item.BackgroundColor3 = Color3.fromRGB(55, 55, 80)
        item.BackgroundTransparency = 0.3
        item.BorderSizePixel = 0
        item.Parent = V2.tpListFrame
        local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(0, 4); ic.Parent = item

        local goBtn = Instance.new("TextButton")
        goBtn.Size = UDim2.new(1, -30, 1, 0)
        goBtn.BackgroundTransparency = 1
        goBtn.TextColor3 = Color3.fromRGB(255,255,255)
        goBtn.TextSize = 11
        goBtn.Font = Enum.Font.Gotham
        goBtn.TextXAlignment = Enum.TextXAlignment.Left
        goBtn.Text = " " .. entry.name
        goBtn.Parent = item
        goBtn.MouseButton1Click:Connect(function()
            local hrp = getHRP()
            if hrp then hrp.CFrame = CFrame.new(entry.pos) end
        end)

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 24, 1, 0)
        delBtn.Position = UDim2.new(1, -28, 0, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(180,50,50)
        delBtn.TextColor3 = Color3.fromRGB(255,255,255)
        delBtn.TextSize = 10
        delBtn.Font = Enum.Font.GothamBold
        delBtn.Text = "×"
        delBtn.Parent = item
        local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(0, 4); dc.Parent = delBtn
        delBtn.MouseButton1Click:Connect(function()
            table.remove(state.savedTPs, i)
            refreshTpList()
        end)
        y = y + 27
    end
    V2.tpListFrame.CanvasSize = UDim2.new(0, 0, 0, y)
end

V2.tpSaveBtn.MouseButton1Click:Connect(function()
    local name = V2.tpSaveBox.Text
    if name == "" then name = "TP" .. (#state.savedTPs + 1) end
    local hrp = getHRP(); if not hrp then return end
    table.insert(state.savedTPs, { name=name, pos=hrp.Position })
    V2.tpSaveBox.Text = ""
    refreshTpList()
end)

_G.ViodMenu.p4 = { createTpUI=createTpUI, refreshTpList=refreshTpList }
-- ===== Viod Menu Part 5/7 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local state = V1.state
local player = game.Players.LocalPlayer

local function setPose(pose)
    state.pose = pose
    V2.poseNormal.BackgroundColor3 = (pose=="normal") and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
    V2.poseRagdoll.BackgroundColor3 = (pose=="ragdoll") and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
    V2.poseT.BackgroundColor3 = (pose=="tpose") and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
    V2.poseSit.BackgroundColor3 = (pose=="sit") and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
    local char = player.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    if pose == "normal" then
        hum.PlatformStand = false
        for _, m in ipairs(char:GetDescendants()) do
            if m:IsA("Motor6D") then m.Enabled = true end
        end
    elseif pose == "ragdoll" then
        hum.PlatformStand = true
        for _, m in ipairs(char:GetDescendants()) do
            if m:IsA("Motor6D") then m.Enabled = false end
        end
    elseif pose == "tpose" then
        hum.PlatformStand = false
        local ra = char:FindFirstChild("Right Arm")
        local la = char:FindFirstChild("Left Arm")
        if ra then ra.CFrame = ra.CFrame * CFrame.Angles(0,0,math.rad(90)) end
        if la then la.CFrame = la.CFrame * CFrame.Angles(0,0,math.rad(-90)) end
    elseif pose == "sit" then
        hum.Sit = true
    end
end
V2.poseNormal.MouseButton1Click:Connect(function() setPose("normal") end)
V2.poseRagdoll.MouseButton1Click:Connect(function() setPose("ragdoll") end)
V2.poseT.MouseButton1Click:Connect(function() setPose("tpose") end)
V2.poseSit.MouseButton1Click:Connect(function() setPose("sit") end)

_G.ViodMenu.p5 = { setPose=setPose }
-- ===== Viod Menu Part 6/7 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local state = V1.state
local RunService = game:GetService("RunService")

local fontScale = { small=0.8, medium=1.0, large=1.25 }
local function applyFontSize()
    local s = fontScale[state.fontSize] or 1.0
    for _, obj in ipairs(V1.mainFrame:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            if not obj:GetAttribute("baseSize") then
                obj:SetAttribute("baseSize", obj.TextSize)
            end
            local base = obj:GetAttribute("baseSize") or obj.TextSize
            obj.TextSize = math.floor(base * s)
        end
    end
    V2.fontSmall.BackgroundColor3 = (state.fontSize=="small") and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
    V2.fontMedium.BackgroundColor3 = (state.fontSize=="medium") and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
    V2.fontLarge.BackgroundColor3 = (state.fontSize=="large") and Color3.fromRGB(0,150,200) or Color3.fromRGB(70,70,90)
end
V2.fontSmall.MouseButton1Click:Connect(function() state.fontSize="small"; applyFontSize() end)
V2.fontMedium.MouseButton1Click:Connect(function() state.fontSize="medium"; applyFontSize() end)
V2.fontLarge.MouseButton1Click:Connect(function() state.fontSize="large"; applyFontSize() end)

local rainbowActive = false
local rainbowConn = nil
local BG_TRANSPARENCY = 0.55
local CONTENT_TRANSPARENCY = 0.45

local function stopRainbow()
    rainbowActive = false
    if rainbowConn then rainbowConn:Disconnect(); rainbowConn = nil end
end

local function setBg(color)
    stopRainbow()
    V1.mainFrame.BackgroundColor3 = color
    V1.mainFrame.BackgroundTransparency = BG_TRANSPARENCY
    V1.content.BackgroundColor3 = Color3.new(
        math.clamp(color.R*0.6, 0, 1),
        math.clamp(color.G*0.6, 0, 1),
        math.clamp(color.B*0.6, 0, 1))
    V1.content.BackgroundTransparency = CONTENT_TRANSPARENCY
    local colors = {
        blue=Color3.fromRGB(20,50,120), yellow=Color3.fromRGB(120,110,0),
        red=Color3.fromRGB(120,30,30), black=Color3.fromRGB(20,20,30),
        white=Color3.fromRGB(230,230,230), rainbow=Color3.fromRGB(120,50,200),
    }
    for k, btn in pairs({blue=V2.bgBlue, yellow=V2.bgYellow, red=V2.bgRed,
        black=V2.bgBlack, white=V2.bgWhite, rainbow=V2.bgRainbow}) do
        btn.BackgroundColor3 = (state.bgColor==k) and colors[k] or Color3.fromRGB(70,70,90)
    end
end

V2.bgBlue.MouseButton1Click:Connect(function() state.bgColor="blue"; setBg(Color3.fromRGB(20,50,120)) end)
V2.bgYellow.MouseButton1Click:Connect(function() state.bgColor="yellow"; setBg(Color3.fromRGB(120,110,0)) end)
V2.bgRed.MouseButton1Click:Connect(function() state.bgColor="red"; setBg(Color3.fromRGB(120,30,30)) end)
V2.bgBlack.MouseButton1Click:Connect(function() state.bgColor="black"; setBg(Color3.fromRGB(20,20,30)) end)
V2.bgWhite.MouseButton1Click:Connect(function() state.bgColor="white"; setBg(Color3.fromRGB(230,230,230)) end)

V2.bgRainbow.MouseButton1Click:Connect(function()
    state.bgColor = "rainbow"
    stopRainbow()
    rainbowActive = true
    local hue = 0
    rainbowConn = RunService.RenderStepped:Connect(function()
        if not rainbowActive then return end
        hue = (hue + 0.008) % 1
        V1.mainFrame.BackgroundColor3 = Color3.fromHSV(hue, 0.9, 0.6)
        V1.mainFrame.BackgroundTransparency = BG_TRANSPARENCY
        V1.content.BackgroundColor3 = Color3.fromHSV(hue, 0.9, 0.35)
        V1.content.BackgroundTransparency = CONTENT_TRANSPARENCY
    end)
    for k, btn in pairs({blue=V2.bgBlue, yellow=V2.bgYellow, red=V2.bgRed,
        black=V2.bgBlack, white=V2.bgWhite}) do
        btn.BackgroundColor3 = Color3.fromRGB(70,70,90)
    end
    V2.bgRainbow.BackgroundColor3 = Color3.fromRGB(120,50,200)
end)

_G.ViodMenu.p6 = { applyFontSize=applyFontSize, setBg=setBg }
-- ===== Viod Menu Part 7/7 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local LANG = V1.LANG
local state = V1.state
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

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
    V2.speedToggle.Text = state.speedEnabled and t.on or t.off
    V2.jumpToggle.Text = state.jumpEnabled and t.on or t.off
    V2.wallToggle.Text = state.wallWalk and t.on or t.off
    V2.noclipToggle.Text = state.noclip and t.on or t.off
    V2.tpLabel.Text = t.tp
    V2.tpSaveLabel.Text = t.tpsave
    V2.tpSaveBtn.Text = t.saveBtn
    V2.tpToggle.Text = state.tpEnabled and t.on or t.off
    V2.invisLabel.Text = t.invis
    V2.invisToggle.Text = state.invisEnabled and t.on or t.off
    V2.rotLabel.Text = t.rot
    V2.rotToggle.Text = state.rotEnabled and t.on or t.off
    V2.poseLabel.Text = t.pose
    V2.poseNormal.Text = t.poseNormal
    V2.poseRagdoll.Text = t.poseRagdoll
    V2.poseT.Text = t.poseT
    V2.poseSit.Text = t.poseSit
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

-- ✖ : 右上にV（長押しでドラッグ可能）
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

    local vDragging, vDragStart, vStartPos = false, nil, nil
    local vLongPress = false
    local vHoldTimer = nil
    local vMoved = false

    vBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            vDragStart = input.Position
            vStartPos = vBtn.Position
            vMoved = false
            vHoldTimer = task.delay(0.25, function()
                if not vMoved then
                    vDragging = true
                    vBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
                end
            end)
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not vDragStart then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - vDragStart
            if d.Magnitude > 8 then vMoved = true end
            if vDragging then
                vBtn.Position = UDim2.new(
                    vStartPos.X.Scale, vStartPos.X.Offset + d.X,
                    vStartPos.Y.Scale, vStartPos.Y.Offset + d.Y)
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if not vDragStart then return end
        if input.UserInputType ~= Enum.UserInputType.MouseButton1
            and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if vHoldTimer then task.cancel(vHoldTimer); vHoldTimer = nil end
        local wasDrag = vDragging
        local wasMoved = vMoved
        vDragging = false
        vDragStart = nil
        vBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
        if not wasDrag and not wasMoved then
            V1.mainFrame.Visible = true
            vBtn:Destroy()
        end
    end)
end)

-- − : Vに変化
local minimized = false
V1.minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        V1.body.Visible = false
        V1.minBtn.Text = "V"
        V1.minBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
        V1.mainFrame.Size = UDim2.new(0, 560, 0, 36)
    else
        V1.body.Visible = true
        V1.minBtn.Text = "−"
        V1.minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
        V1.mainFrame.Size = UDim2.new(0, 560, 0, 360)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 5)
    task.wait(0.3)
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        if state.speedEnabled then h.WalkSpeed = state.speed end
        if state.jumpEnabled then h.UseJumpPower=true; h.JumpPower = state.jumpPower end
    end
end)

-- 初期反映
applyLang()
if _G.ViodMenu.p6 then _G.ViodMenu.p6.applyFontSize() end
if _G.ViodMenu.p4 then _G.ViodMenu.p4.refreshTpList() end
print("[Viod Menu] Loaded / 読み込み完了")
