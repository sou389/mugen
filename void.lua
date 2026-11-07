-- ===== Viod Ultimate Part 1/6 =====
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local LANG = {
    ja = { title="Viod", p_tab="基本", t_tab="ツール", m_tab="その他", ai="AI", s_tab="コード", set="設定",
           speed="スピード:", jump="ジャンプ力:", infj="インフジャンプ:", noclip="貫通:",
           respawn="即リスポーン", anti="アンチAFK:", on="ON", off="OFF",
           wall="壁歩き:", fly="フライ:", invis="透明化:", rot="回転スピード:", hitbox="ヒットボックス:",
           tp="画面タップTP:", tp_desc="指でタップ", tpsave="テレポート保存", save="保存",
           aim="エイムボット:", aimfov="Aim FOV:", music="音楽ID:", play="再生", stop="停止",
           emote="エモート:", dance="ダンス", wave="ウェーブ",
           font="文字サイズ:", color="UIカラー:", trans="UI透明度:",
           send="送信", ph="AIと話す...", exec="実行", exec_ph="Luaコードを入力...",
           p_list="プレイヤー一覧", hitbox_size="サイズ:" },
    en = { title="Viod", p_tab="Player", t_tab="Tools", m_tab="Misc", ai="AI", s_tab="Script", set="Settings",
           speed="Speed:", jump="Jump:", infj="Inf Jump:", noclip="Noclip:",
           respawn="Respawn", anti="Anti-AFK:", on="ON", off="OFF",
           wall="Wall Walk:", fly="Fly:", invis="Invisible:", rot="Rot Speed:", hitbox="Hitbox:",
           tp="Tap TP:", tp_desc="Tap screen", tpsave="Save TP", save="Save",
           aim="Aimbot:", aimfov="Aim FOV:", music="Music ID:", play="Play", stop="Stop",
           emote="Emote:", dance="Dance", wave="Wave",
           font="Font Size:", color="UI Color:", trans="UI Trans:",
           send="Send", ph="Talk to AI...", exec="Execute", exec_ph="Enter Lua code...",
           p_list="Player List", hitbox_size="Size:" },
}

local state = {
    speed=16, jumpPower=50, wallWalk=false, noclip=false, infJump=false,
    fly=false, flySpeed=50, invis=false, spin=false, rotSpeed=180,
    hitbox=false, hitboxSize=10, aimbot=false, aimFov=150, antiAfk=true,
    tpEnabled=false, speedEnabled=false, jumpEnabled=false, lang="ja",
    savedTPs={}, currMusic=nil
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
mainFrame.Size = UDim2.new(0, 600, 0, 420)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -210)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.4
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
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = mainFrame.Position
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
    end
end)
UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
end)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0, 200, 1, 0)
title.Position = UDim2.new(0, 15, 0, 0)
title.BackgroundTransparency = 1
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 22 -- 文字を大きく
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local langBtn = Instance.new("TextButton")
langBtn.Size = UDim2.new(0, 100, 0, 26)
langBtn.Position = UDim2.new(1, -180, 0, 7)
langBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
langBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
langBtn.TextSize = 12
langBtn.Font = Enum.Font.GothamBold
langBtn.Text = "日本語 🇯🇵"
langBtn.Parent = titleBar
local lc = Instance.new("UICorner"); lc.CornerRadius = UDim.new(0, 6); lc.Parent = langBtn

local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 26, 0, 26)
minBtn.Position = UDim2.new(1, -72, 0, 7)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 110)
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.TextSize = 17
minBtn.Font = Enum.Font.GothamBold
minBtn.Text = "-"
minBtn.Parent = titleBar
local mc = Instance.new("UICorner"); mc.CornerRadius = UDim.new(0, 6); mc.Parent = minBtn

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 26, 0, 26)
closeBtn.Position = UDim2.new(1, -42, 0, 7)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 15
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
leftPanel.Size = UDim2.new(0, 120, 1, 0)
leftPanel.BackgroundTransparency = 1
leftPanel.Parent = body
local leftLayout = Instance.new("UIListLayout")
leftLayout.Padding = UDim.new(0, 6)
leftLayout.Parent = leftPanel

local function makeTab(text, order)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 34)
    b.BackgroundColor3 = Color3.fromRGB(50, 50, 75)
    b.BackgroundTransparency = 0.3
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 13
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.LayoutOrder = order
    b.Parent = leftPanel
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = b
    return b
end

local pTab = makeTab("Player", 1)
local tTab = makeTab("Tools", 2)
local mTab = makeTab("Misc", 3)
local aiTab = makeTab("AI Chat", 4)
local sTab = makeTab("Script", 5)
local setTab = makeTab("Settings", 6)

-- アイコン（左パネルの一番下）
local playerCard = Instance.new("Frame")
playerCard.Size = UDim2.new(0, 120, 0, 50)
playerCard.Position = UDim2.new(0, 0, 1, -50)
playerCard.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
playerCard.BackgroundTransparency = 0.2
playerCard.BorderSizePixel = 0
playerCard.ZIndex = 50
playerCard.Parent = leftPanel
local pcC = Instance.new("UICorner"); pcC.CornerRadius = UDim.new(0, 8); pcC.Parent = playerCard

local avatarImg = Instance.new("ImageLabel")
avatarImg.Size = UDim2.new(0, 34, 0, 34)
avatarImg.Position = UDim2.new(0, 6, 0.5, -17)
avatarImg.BackgroundColor3 = Color3.fromRGB(255,255,255)
avatarImg.BackgroundTransparency = 0.2
avatarImg.ScaleType = Enum.ScaleType.Crop
avatarImg.ZIndex = 51
avatarImg.Parent = playerCard
local avC = Instance.new("UICorner"); avC.CornerRadius = UDim.new(1, 0); avC.Parent = avatarImg

local nameLabel = Instance.new("TextLabel")
nameLabel.Size = UDim2.new(1, -46, 1, -8)
nameLabel.Position = UDim2.new(0, 42, 0, 4)
nameLabel.BackgroundTransparency = 1
nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
nameLabel.TextSize = 11
nameLabel.Font = Enum.Font.GothamBold
nameLabel.TextXAlignment = Enum.TextXAlignment.Left
nameLabel.TextYAlignment = Enum.TextYAlignment.Center
nameLabel.TextTruncate = Enum.TextTruncate.AtEnd
nameLabel.ZIndex = 51
nameLabel.Parent = playerCard

task.spawn(function()
    local ok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and thumb then avatarImg.Image = thumb end
    nameLabel.Text = player.DisplayName or player.Name
end)

local content = Instance.new("Frame")
content.Size = UDim2.new(1, -130, 1, 0)
content.Position = UDim2.new(0, 130, 0, 0)
content.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
content.BackgroundTransparency = 0.4
content.BorderSizePixel = 0
content.Parent = body
local cC = Instance.new("UICorner"); cC.CornerRadius = UDim.new(0, 8); cC.Parent = content

_G.ViodMenu = _G.ViodMenu or {}
_G.ViodMenu.p1 = { screenGui=screenGui, mainFrame=mainFrame, body=body, titleBar=titleBar, title=title,
    langBtn=langBtn, minBtn=minBtn, closeBtn=closeBtn, content=content, state=state, LANG=LANG,
    getHum=getHum, getHRP=getHRP, originalCollide=originalCollide, tabs={pTab,tTab,mTab,aiTab,sTab,setTab} }
-- ===== Viod Ultimate Part 2/6 =====
local V = _G.ViodMenu.p1
local LANG = V.LANG
local state = V.state
local content = V.content

local function row(parent, order)
    local r = Instance.new("Frame")
    r.Size = UDim2.new(1, 0, 0, 30)
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
    l.TextSize = 12
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
    b.TextSize = 12
    b.Text = default
    b.ClearTextOnFocus = false
    b.Font = Enum.Font.Gotham
    b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
    return b
end
local function makeBtn(parent, x, w, text, color)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0, w, 1, 0)
    b.Position = UDim2.new(0, x, 0, 0)
    b.BackgroundColor3 = color or Color3.fromRGB(70,70,90)
    b.TextColor3 = Color3.fromRGB(255, 255, 255)
    b.TextSize = 12
    b.Font = Enum.Font.GothamBold
    b.Text = text
    b.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 4); c.Parent = b
    return b
end
local function makePage()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = content
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 6); pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8)
    pad.Parent = p
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 4)
    l.Parent = p
    return p
end

-- ================= Player =================
local pPage = makePage()
local r = row(pPage, 1); local speedLabel = label(r, 0, 80); local speedBox = makeBox(r, 85, 60, "100"); local speedToggle = makeBtn(r, 150, 60, "OFF")
r = row(pPage, 2); local jumpLabel = label(r, 0, 80); local jumpBox = makeBox(r, 85, 60, "120"); local jumpToggle = makeBtn(r, 150, 60, "OFF")
r = row(pPage, 3); local infjLabel = label(r, 0, 80); local infjToggle = makeBtn(r, 85, 125, "OFF")
r = row(pPage, 4); local noclipLabel = label(r, 0, 80); local noclipToggle = makeBtn(r, 85, 125, "OFF")
r = row(pPage, 5); local respawnBtn = makeBtn(r, 0, 210, "Respawn", Color3.fromRGB(200,70,70))
r = row(pPage, 6); local antiLabel = label(r, 0, 80); local antiToggle = makeBtn(r, 85, 60, "ON", Color3.fromRGB(0,170,110))

-- ================= Tools =================
local tPage = makePage()
r = row(tPage, 1); local wallLabel = label(r, 0, 80); local wallToggle = makeBtn(r, 85, 125, "OFF")
r = row(tPage, 2); local flyLabel = label(r, 0, 80); local flyToggle = makeBtn(r, 85, 60, "OFF"); local flySpeedBox = makeBox(r, 150, 60, "50")
r = row(tPage, 3); local invisLabel = label(r, 0, 80); local invisToggle = makeBtn(r, 85, 125, "OFF")
r = row(tPage, 4); local rotLabel = label(r, 0, 80); local rotBox = makeBox(r, 85, 60, "180"); local rotToggle = makeBtn(r, 150, 60, "OFF")
r = row(tPage, 5); local hitboxLabel = label(r, 0, 80); local hitboxToggle = makeBtn(r, 85, 60, "OFF"); local hitboxSizeBox = makeBox(r, 150, 60, "10")
r = row(tPage, 6); local tpLabel = label(r, 0, 80); local tpToggle = makeBtn(r, 85, 60, "OFF"); local tpDesc = label(r, 150, 60); tpDesc.TextColor3 = Color3.fromRGB(150,255,150); tpDesc.TextSize = 10

-- ================= Misc =================
local mPage = makePage()
r = row(mPage, 1); local aimLabel = label(r, 0, 80); local aimToggle = makeBtn(r, 85, 60, "OFF"); local aimFovBox = makeBox(r, 150, 60, "150")
r = row(mPage, 2); local tpSaveBox = makeBox(r, 0, 100, ""); local tpSaveBtn = makeBtn(r, 105, 50, "Save"); local tpListBtn = makeBtn(r, 160, 50, "List")
r = row(mPage, 3); local tpListFrame = Instance.new("ScrollingFrame"); tpListFrame.Size = UDim2.new(1, 0, 0, 60); tpListFrame.BackgroundColor3 = Color3.fromRGB(20,20,30); tpListFrame.BorderSizePixel = 0; tpListFrame.Parent = tpListFrame.Parent or r -- Wait, parent is r
tpListFrame.Parent = r
local tlC = Instance.new("UICorner"); tlC.CornerRadius = UDim.new(0, 4); tlC.Parent = tpListFrame
local tlL = Instance.new("UIListLayout"); tlL.Padding = UDim.new(0, 2); tlL.Parent = tpListFrame
r = row(mPage, 4); local musicBox = makeBox(r, 0, 100, ""); local musicPlay = makeBtn(r, 105, 50, "Play"); local musicStop = makeBtn(r, 160, 50, "Stop")
r = row(mPage, 5); local danceBtn = makeBtn(r, 0, 100, "Dance"); local waveBtn = makeBtn(r, 105, 100, "Wave")

-- 画面切り替え
local function showPage(idx)
    pPage.Visible = (idx==1); tPage.Visible = (idx==2); mPage.Visible = (idx==3)
    for i=1,3 do
        V.tabs[i].BackgroundColor3 = (i==idx) and Color3.fromRGB(70,70,110) or Color3.fromRGB(50,50,75)
    end
end
showPage(1)
for i=1,3 do V.tabs[i].MouseButton1Click:Connect(function() showPage(i) end) end

_G.ViodMenu.p2 = {
    pPage=pPage, tPage=tPage, mPage=mPage,
    speedLabel=speedLabel, speedBox=speedBox, speedToggle=speedToggle,
    jumpLabel=jumpLabel, jumpBox=jumpBox, jumpToggle=jumpToggle,
    infjLabel=infjLabel, infjToggle=infjToggle, noclipLabel=noclipLabel, noclipToggle=noclipToggle,
    respawnBtn=respawnBtn, antiLabel=antiLabel, antiToggle=antiToggle,
    wallLabel=wallLabel, wallToggle=wallToggle, flyLabel=flyLabel, flyToggle=flyToggle, flySpeedBox=flySpeedBox,
    invisLabel=invisLabel, invisToggle=invisToggle, rotLabel=rotLabel, rotBox=rotBox, rotToggle=rotToggle,
    hitboxLabel=hitboxLabel, hitboxToggle=hitboxToggle, hitboxSizeBox=hitboxSizeBox,
    tpLabel=tpLabel, tpToggle=tpToggle, tpDesc=tpDesc,
    aimLabel=aimLabel, aimToggle=aimToggle, aimFovBox=aimFovBox,
    tpSaveBox=tpSaveBox, tpSaveBtn=tpSaveBtn, tpListFrame=tpListFrame,
    musicBox=musicBox, musicPlay=musicPlay, musicStop=musicStop, danceBtn=danceBtn, waveBtn=waveBtn
}
-- ===== Viod Ultimate Part 3/6 =====
local V = _G.ViodMenu.p1
local LANG = V.LANG
local state = V.state
local content = V.content

local function makePage()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = content
    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 6); pad.PaddingLeft = UDim.new(0, 8); pad.PaddingRight = UDim.new(0, 8); pad.PaddingBottom = UDim.new(0, 6)
    pad.Parent = p
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 4)
    l.Parent = p
    return p
end

-- ================= AI Chat =================
local aiPage = makePage()
local aiScroll = Instance.new("ScrollingFrame")
aiScroll.Size = UDim2.new(1, 0, 1, -36)
aiScroll.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
aiScroll.BorderSizePixel = 0
aiScroll.ScrollBarThickness = 4
aiScroll.Parent = aiPage
local asc = Instance.new("UICorner"); asc.CornerRadius = UDim.new(0, 6); asc.Parent = aiScroll
local asl = Instance.new("UIListLayout"); asl.Padding = UDim.new(0, 4); asl.Parent = aiScroll

local aiInputRow = Instance.new("Frame")
aiInputRow.Size = UDim2.new(1, 0, 0, 30)
aiInputRow.BackgroundTransparency = 1
aiInputRow.Parent = aiPage
local aiInput = Instance.new("TextBox")
aiInput.Size = UDim2.new(1, -70, 1, 0)
aiInput.BackgroundColor3 = Color3.fromRGB(45, 45, 65)
aiInput.TextColor3 = Color3.fromRGB(255,255,255)
aiInput.TextSize = 13
aiInput.PlaceholderText = "話しかけてください..."
aiInput.Parent = aiInputRow
local aic = Instance.new("UICorner"); aic.CornerRadius = UDim.new(0, 4); aic.Parent = aiInput
local aiSend = Instance.new("TextButton")
aiSend.Size = UDim2.new(0, 65, 1, 0)
aiSend.Position = UDim2.new(1, -65, 0, 0)
aiSend.BackgroundColor3 = Color3.fromRGB(0, 150, 200)
aiSend.TextColor3 = Color3.fromRGB(255,255,255)
aiSend.TextSize = 12
aiSend.Font = Enum.Font.GothamBold
aiSend.Text = "送信"
aiSend.Parent = aiInputRow
local aisc = Instance.new("UICorner"); aisc.CornerRadius = UDim.new(0, 4); aisc.Parent = aiSend

-- ================= Script =================
local sPage = makePage()
local codeInput = Instance.new("TextBox")
codeInput.Size = UDim2.new(1, 0, 1, -36)
codeInput.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
codeInput.TextColor3 = Color3.fromRGB(0, 255, 150)
codeInput.TextSize = 13
codeInput.TextXAlignment = Enum.TextXAlignment.Left
codeInput.TextYAlignment = Enum.TextYAlignment.Top
codeInput.MultiLine = true
codeInput.ClearTextOnFocus = false
codeInput.Font = Enum.Font.Code
codeInput.PlaceholderText = "-- ここにLuaコードを入力"
codeInput.Parent = sPage
local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0, 6); sc.Parent = codeInput
local execBtn = Instance.new("TextButton")
execBtn.Size = UDim2.new(1, 0, 0, 30)
execBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
execBtn.TextColor3 = Color3.fromRGB(255,255,255)
execBtn.TextSize = 14
execBtn.Font = Enum.Font.GothamBold
execBtn.Text = "実行 (Execute)"
execBtn.Parent = sPage
local ec = Instance.new("UICorner"); ec.CornerRadius = UDim.new(0, 6); ec.Parent = execBtn

-- ================= Settings =================
local setPage = makePage()
local function makeSetRow(text, order)
    local r = Instance.new("Frame")
    r.Size = UDim2.new(1, 0, 0, 30)
    r.BackgroundTransparency = 1
    r.LayoutOrder = order
    r.Parent = setPage
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(0, 80, 1, 0)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.fromRGB(255,255,255)
    l.TextSize = 12
    l.Text = text
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = r
    return r
end

local fRow = makeSetRow("文字サイズ", 1)
local fS = Instance.new("TextButton"); fS.Size = UDim2.new(0,40,1,0); fS.Position = UDim2.new(0,80,0,0); fS.BackgroundColor3 = Color3.fromRGB(70,70,90); fS.Text = "小"; fS.Parent = fRow
local fM = Instance.new("TextButton"); fM.Size = UDim2.new(0,40,1,0); fM.Position = UDim2.new(0,125,0,0); fM.BackgroundColor3 = Color3.fromRGB(0,150,200); fM.Text = "中"; fM.Parent = fRow
local fL = Instance.new("TextButton"); fL.Size = UDim2.new(0,40,1,0); fL.Position = UDim2.new(0,170,0,0); fL.BackgroundColor3 = Color3.fromRGB(70,70,90); fL.Text = "大"; fL.Parent = fRow

local cRow = makeSetRow("UIカラー", 2)
local cBlue = Instance.new("TextButton"); cBlue.Size = UDim2.new(0,40,1,0); cBlue.Position = UDim2.new(0,80,0,0); cBlue.BackgroundColor3 = Color3.fromRGB(40,80,200); cBlue.Parent = cRow
local cRed = Instance.new("TextButton"); cRed.Size = UDim2.new(0,40,1,0); cRed.Position = UDim2.new(0,125,0,0); cRed.BackgroundColor3 = Color3.fromRGB(200,50,50); cRed.Parent = cRow
local cGreen = Instance.new("TextButton"); cGreen.Size = UDim2.new(0,40,1,0); cGreen.Position = UDim2.new(0,170,0,0); cGreen.BackgroundColor3 = Color3.fromRGB(50,200,50); cGreen.Parent = cRow
local cPurple = Instance.new("TextButton"); cPurple.Size = UDim2.new(0,40,1,0); cPurple.Position = UDim2.new(0,215,0,0); cPurple.BackgroundColor3 = Color3.fromRGB(150,50,200); cPurple.Parent = cRow

local tRow = makeSetRow("透明度", 3)
local t1 = Instance.new("TextButton"); t1.Size = UDim2.new(0,40,1,0); t1.Position = UDim2.new(0,80,0,0); t1.BackgroundColor3 = Color3.fromRGB(70,70,90); t1.Text = "0.2"; t1.Parent = tRow
local t2 = Instance.new("TextButton"); t2.Size = UDim2.new(0,40,1,0); t2.Position = UDim2.new(0,125,0,0); t2.BackgroundColor3 = Color3.fromRGB(0,150,200); t2.Text = "0.4"; t2.Parent = tRow
local t3 = Instance.new("TextButton"); t3.Size = UDim2.new(0,40,1,0); t3.Position = UDim2.new(0,170,0,0); t3.BackgroundColor3 = Color3.fromRGB(70,70,90); t3.Text = "0.7"; t3.Parent = tRow

local function showPage(idx)
    aiPage.Visible = (idx==4); sPage.Visible = (idx==5); setPage.Visible = (idx==6)
    for i=4,6 do
        V.tabs[i].BackgroundColor3 = (i==idx) and Color3.fromRGB(70,70,110) or Color3.fromRGB(50,50,75)
    end
end
for i=4,6 do V.tabs[i].MouseButton1Click:Connect(function() showPage(i) end) end

_G.ViodMenu.p3 = { aiPage=aiPage, aiScroll=aiScroll, aiInput=aiInput, aiSend=aiSend,
    sPage=sPage, codeInput=codeInput, execBtn=execBtn,
    setPage=setPage, fS=fS, fM=fM, fL=fL, cBlue=cBlue, cRed=cRed, cGreen=cGreen, cPurple=cPurple,
    t1=t1, t2=t2, t3=t3 }
-- ===== Viod Ultimate Part 4/6 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local state = V1.state
local getHum = V1.getHum
local getHRP = V1.getHRP
local originalCollide = V1.originalCollide
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer
local baseSpeed = 16; local baseJump = 50

-- スピード
V2.speedBox.FocusLost:Connect(function() state.speed = tonumber(V2.speedBox.Text) or 16 end)
V2.speedToggle.MouseButton1Click:Connect(function()
    state.speedEnabled = not state.speedEnabled
    V2.speedToggle.Text = state.speedEnabled and "ON" or "OFF"
    V2.speedToggle.BackgroundColor3 = state.speedEnabled and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    local h = getHum(); if h then if state.speedEnabled then baseSpeed = h.WalkSpeed; h.WalkSpeed = state.speed else h.WalkSpeed = baseSpeed end end
end)

-- ジャンプ
V2.jumpBox.FocusLost:Connect(function() state.jumpPower = tonumber(V2.jumpBox.Text) or 50 end)
V2.jumpToggle.MouseButton1Click:Connect(function()
    state.jumpEnabled = not state.jumpEnabled
    V2.jumpToggle.Text = state.jumpEnabled and "ON" or "OFF"
    V2.jumpToggle.BackgroundColor3 = state.jumpEnabled and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    local h = getHum(); if h then if state.jumpEnabled then baseJump = h.JumpPower; h.UseJumpPower = true; h.JumpPower = state.jumpPower else h.JumpPower = baseJump end end
end)

-- インフジャンプ
V2.infjToggle.MouseButton1Click:Connect(function()
    state.infJump = not state.infJump
    V2.infjToggle.Text = state.infJump and "ON" or "OFF"
    V2.infjToggle.BackgroundColor3 = state.infJump and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
end)
UIS.JumpRequest:Connect(function()
    if state.infJump then local h = getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)

-- 貫通
V2.noclipToggle.MouseButton1Click:Connect(function()
    state.noclip = not state.noclip
    V2.noclipToggle.Text = state.noclip and "ON" or "OFF"
    V2.noclipToggle.BackgroundColor3 = state.noclip and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
end)
RunService.Stepped:Connect(function()
    if state.noclip then local c = player.Character; if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide = false end end end end
end)

-- リスポーン
V2.respawnBtn.MouseButton1Click:Connect(function() local h = getHum(); if h then h.Health = 0 end end)

-- アンチAFK
V2.antiToggle.MouseButton1Click:Connect(function()
    state.antiAfk = not state.antiAfk
    V2.antiToggle.Text = state.antiAfk and "ON" or "OFF"
    V2.antiToggle.BackgroundColor3 = state.antiAfk and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
end)
task.spawn(function()
    while task.wait(60) do
        if state.antiAfk then
            local v = Instance.new("VirtualUser")
            v.Parent = game:GetService("Players").LocalPlayer
            v:CaptureController()
            v:ClickButton2(Vector2.new())
            v:Destroy()
        end
    end
end)

-- 壁歩き（左右移動対応）
V2.wallToggle.MouseButton1Click:Connect(function()
    state.wallWalk = not state.wallWalk
    V2.wallToggle.Text = state.wallWalk and "ON" or "OFF"
    V2.wallToggle.BackgroundColor3 = state.wallWalk and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    local hrp = getHRP(); if not hrp then return end
    if state.wallWalk then
        if not hrp:FindFirstChild("WallWalkForce") then local bv = Instance.new("BodyVelocity"); bv.Name="WallWalkForce"; bv.MaxForce=Vector3.zero; bv.Velocity=Vector3.zero; bv.Parent=hrp end
        if not hrp:FindFirstChild("WallWalkGyro") then local bg = Instance.new("BodyGyro"); bg.Name="WallWalkGyro"; bg.MaxTorque=Vector3.zero; bg.Parent=hrp end
    else
        local bv = hrp:FindFirstChild("WallWalkForce"); if bv then bv:Destroy() end
        local bg = hrp:FindFirstChild("WallWalkGyro"); if bg then bg:Destroy() end
    end
end)
RunService.Heartbeat:Connect(function()
    if not state.wallWalk then return end
    local char = player.Character; if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart"); local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    local bv = hrp:FindFirstChild("WallWalkForce"); local bg = hrp:FindFirstChild("WallWalkGyro")
    if not bv or not bg then return end
    local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Exclude; params.FilterDescendantsInstances = {char}
    local res = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 2.5, params)
    if res and res.Normal and math.abs(res.Normal.Y) < 0.3 then
        local n = res.Normal
        local wallRight = n:Cross(Vector3.new(0,1,0)).Unit
        local moveDir = hum.MoveDirection
        local v = Vector3.zero
        if moveDir.Magnitude > 0 then
            local camCF = workspace.CurrentCamera.CFrame
            v = (wallRight * moveDir:Dot(camCF.RightVector) * hum.WalkSpeed) + (Vector3.new(0,1,0) * moveDir:Dot(camCF.LookVector) * hum.WalkSpeed)
        end
        bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        bv.Velocity = v - n * 2 -- 吸い付き
        bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
        bg.CFrame = CFrame.new(hrp.Position, hrp.Position - n)
    else
        bv.MaxForce = Vector3.zero; bg.MaxTorque = Vector3.zero
    end
end)

-- フライ
local flyBV, flyBG
V2.flySpeedBox.FocusLost:Connect(function() state.flySpeed = tonumber(V2.flySpeedBox.Text) or 50 end)
V2.flyToggle.MouseButton1Click:Connect(function()
    state.fly = not state.fly
    V2.flyToggle.Text = state.fly and "ON" or "OFF"
    V2.flyToggle.BackgroundColor3 = state.fly and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    local hrp = getHRP(); if not hrp then return end
    if state.fly then
        flyBV = Instance.new("BodyVelocity"); flyBV.MaxForce=Vector3.new(1e5,1e5,1e5); flyBV.Parent=hrp
        flyBG = Instance.new("BodyGyro"); flyBG.MaxTorque=Vector3.new(1e5,1e5,1e5); flyBG.P=1000; flyBG.Parent=hrp
    else
        if flyBV then flyBV:Destroy(); flyBV=nil end
        if flyBG then flyBG:Destroy(); flyBG=nil end
        local hum = getHum(); if hum then hum.PlatformStand = false end
    end
end)
RunService.Heartbeat:Connect(function()
    if state.fly and flyBV and flyBG then
        local hum = getHum(); local cam = workspace.CurrentCamera
        if hum then hum.PlatformStand = true end
        local move = Vector3.zero
        if UIS:IsKeyDown(Enum.KeyCode.W) then move = move + cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.S) then move = move - cam.CFrame.LookVector end
        if UIS:IsKeyDown(Enum.KeyCode.A) then move = move - cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.D) then move = move + cam.CFrame.RightVector end
        if UIS:IsKeyDown(Enum.KeyCode.Space) then move = move + Vector3.new(0,1,0) end
        if UIS:IsKeyDown(Enum.KeyCode.LeftShift) then move = move - Vector3.new(0,1,0) end
        flyBV.Velocity = move.Magnitude > 0 and move.Unit * state.flySpeed or Vector3.zero
        flyBG.CFrame = cam.CFrame
    end
end)

-- 透明化
V2.invisToggle.MouseButton1Click:Connect(function()
    state.invis = not state.invis
    V2.invisToggle.Text = state.invis and "ON" or "OFF"
    V2.invisToggle.BackgroundColor3 = state.invis and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    local c = player.Character; if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.Transparency = state.invis and 0.95 or 0 end end end
end)

-- 回転
local function applyRot()
    local hrp = getHRP(); local hum = getHum(); if not hrp or not hum then return end
    local av = hrp:FindFirstChild("ViodRotVelocity")
    if not state.spin then if av then av:Destroy() end; hum.PlatformStand = false; return end
    if not av then av = Instance.new("BodyAngularVelocity"); av.Name="ViodRotVelocity"; av.MaxTorque=Vector3.new(1e5,1e5,1e5); av.Parent=hrp end
    hum.PlatformStand = true
    av.AngularVelocity = Vector3.new(0, math.rad(state.rotSpeed), 0)
end
V2.rotBox.FocusLost:Connect(function() state.rotSpeed = tonumber(V2.rotBox.Text) or 180; if state.spin then applyRot() end end)
V2.rotToggle.MouseButton1Click:Connect(function()
    state.spin = not state.spin
    V2.rotToggle.Text = state.spin and "ON" or "OFF"
    V2.rotToggle.BackgroundColor3 = state.spin and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    applyRot()
end)

-- ヒットボックス
V2.hitboxSizeBox.FocusLost:Connect(function() state.hitboxSize = tonumber(V2.hitboxSizeBox.Text) or 10 end)
V2.hitboxToggle.MouseButton1Click:Connect(function()
    state.hitbox = not state.hitbox
    V2.hitboxToggle.Text = state.hitbox and "ON" or "OFF"
    V2.hitboxToggle.BackgroundColor3 = state.hitbox and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
end)
RunService.Heartbeat:Connect(function()
    if not state.hitbox then return end
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character then
            local hrp = p.Character:FindFirstChild("HumanoidRootPart")
            if hrp and not hrp:FindFirstChild("ViodHitbox") then
                local hb = Instance.new("Part"); hb.Name="ViodHitbox"; hb.Size=Vector3.new(state.hitboxSize, state.hitboxSize, state.hitboxSize); hb.Transparency=0.5; hb.Color=Color3.new(1,0,0); hb.CanCollide=false; hb.Anchored=true
                hb.CFrame = hrp.CFrame; hb.Parent = hrp
                task.spawn(function() while hb.Parent and state.hitbox do hb.CFrame = hrp.CFrame; task.wait() end; if hb then hb:Destroy() end end)
            end
        end
    end
end)
-- ===== Viod Ultimate Part 5/6 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local V3 = _G.ViodMenu.p3
local state = V1.state
local getHum = V1.getHum
local getHRP = V1.getHRP
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

-- エイムボット
V2.aimFovBox.FocusLost:Connect(function() state.aimFov = tonumber(V2.aimFovBox.Text) or 150 end)
V2.aimToggle.MouseButton1Click:Connect(function()
    state.aimbot = not state.aimbot
    V2.aimToggle.Text = state.aimbot and "ON" or "OFF"
    V2.aimToggle.BackgroundColor3 = state.aimbot and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
end)
RunService.RenderStepped:Connect(function()
    if not state.aimbot then return end
    local cam = workspace.CurrentCamera
    local closest, dist = nil, math.huge
    for _, p in ipairs(game.Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild("Head") then
            local pos, onScreen = cam:WorldToViewportPoint(p.Character.Head.Position)
            if onScreen then
                local d = (Vector2.new(pos.X, pos.Y) - UIS:GetMouseLocation()).Magnitude
                if d < state.aimFov and d < dist then dist = d; closest = p.Character.Head end
            end
        end
    end
    if closest then cam.CFrame = CFrame.new(cam.CFrame.Position, closest.Position) end
end)

-- 画面タップテレポート
local tpGui = nil
local function createTpUI()
    if tpGui then tpGui:Destroy() end
    tpGui = Instance.new("ScreenGui"); tpGui.Name="ViodTp"; tpGui.ResetOnSpawn=false; tpGui.DisplayOrder=1000; tpGui.Parent = player.PlayerGui
    local frame = Instance.new("Frame"); frame.Size=UDim2.new(0,200,0,30); frame.Position=UDim2.new(0.5,-100,1,-100); frame.BackgroundColor3=Color3.fromRGB(0,150,200); frame.BackgroundTransparency=0.2; frame.Parent=tpGui
    local fC = Instance.new("UICorner"); fC.CornerRadius=UDim.new(0,8); fC.Parent=frame
    local lbl = Instance.new("TextLabel"); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.new(1,1,1); lbl.TextSize=11; lbl.Text="Teleport (Tap Screen)"; lbl.Parent=frame
end
V2.tpToggle.MouseButton1Click:Connect(function()
    state.tpEnabled = not state.tpEnabled
    V2.tpToggle.Text = state.tpEnabled and "ON" or "OFF"
    V2.tpToggle.BackgroundColor3 = state.tpEnabled and Color3.fromRGB(0,170,110) or Color3.fromRGB(70,70,90)
    V2.tpDesc.Text = state.tpEnabled and "指でタップ" or ""
    if state.tpEnabled then createTpUI() else if tpGui then tpGui:Destroy(); tpGui=nil end end
end)
local tpStart = nil
UIS.InputBegan:Connect(function(i, p)
    if p or (i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1) then return end
    local guis = player.PlayerGui:GetGuiObjectsAtPosition(i.Position.X, i.Position.Y)
    for _, g in ipairs(guis) do if g:IsA("GuiObject") and g.Visible then return end end
    tpStart = {pos=i.Position, time=tick()}
end)
UIS.InputEnded:Connect(function(i, p)
    if not state.tpEnabled or not tpStart or p then return end
    if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
    local dur = tick() - tpStart.time; local dist = (i.Position - tpStart.pos).Magnitude; tpStart = nil
    if dur < 0.3 and dist < 20 then
        local ray = workspace.CurrentCamera:ScreenPointToRay(i.Position.X, i.Position.Y)
        local res = workspace:Raycast(ray.Origin, ray.Direction * 2000, RaycastParams.new())
        if res then local hrp = getHRP(); if hrp then hrp.CFrame = CFrame.new(res.Position + Vector3.new(0,3,0)) end end
    end
end)

-- テレポート保存
local function refreshTpList()
    for _,c in ipairs(V2.tpListFrame:GetChildren()) do if c:IsA("GuiObject") then c:Destroy() end end
    local y=0
    for i, e in ipairs(state.savedTPs) do
        local btn = Instance.new("TextButton"); btn.Size=UDim2.new(1,-24,0,20); btn.Position=UDim2.new(0,0,0,y); btn.BackgroundColor3=Color3.fromRGB(50,50,70); btn.TextColor3=Color3.new(1,1,1); btn.TextSize=10; btn.Text=e.name; btn.Parent=V2.tpListFrame
        btn.MouseButton1Click:Connect(function() local hrp=getHRP(); if hrp then hrp.CFrame = CFrame.new(e.pos) end end)
        local del = Instance.new("TextButton"); del.Size=UDim2.new(0,20,0,20); del.Position=UDim2.new(1,-24,0,y); del.BackgroundColor3=Color3.fromRGB(200,50,50); del.Text="×"; del.TextColor3=Color3.new(1,1,1); del.Parent=V2.tpListFrame
        del.MouseButton1Click:Connect(function() table.remove(state.savedTPs,i); refreshTpList() end)
        y = y + 22
    end
    V2.tpListFrame.CanvasSize = UDim2.new(0,0,0,y)
end
V2.tpSaveBtn.MouseButton1Click:Connect(function()
    local hrp = getHRP(); if hrp then table.insert(state.savedTPs, {name=V2.tpSaveBox.Text ~= "" and V2.tpSaveBox.Text or "TP"..(#state.savedTPs+1), pos=hrp.Position}); V2.tpSaveBox.Text=""; refreshTpList() end
end)

-- 音楽
local sound = Instance.new("Sound"); sound.Parent = workspace; sound.Name="ViodMusic"
V2.musicPlay.MouseButton1Click:Connect(function()
    local id = tonumber(V2.musicBox.Text)
    if id then sound.SoundId = "rbxassetid://"..id; sound:Play() end
end)
V2.musicStop.MouseButton1Click:Connect(function() sound:Stop() end)

-- エモート
local function playEmote(id)
    local char = player.Character; if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
    local anim = Instance.new("Animation"); anim.AnimationId = "rbxassetid://"..id
    local track = hum:LoadAnimation(anim); track:Play()
end
V2.danceBtn.MouseButton1Click:Connect(function() playEmote("507771019") end)
V2.waveBtn.MouseButton1Click:Connect(function() playEmote("507770239") end)

-- ================= AIチャット =================
local function addMsg(text, isUser)
    local m = Instance.new("TextLabel"); m.Size=UDim2.new(1,0,0,0); m.AutomaticSize=Enum.AutomaticSize.Y; m.BackgroundTransparency=1; m.TextWrapped=true; m.TextXAlignment=Enum.TextXAlignment.Left; m.Font=Enum.Font.Gotham; m.TextSize=12; m.Text=(isUser and "[あなた] " or "[AI] ")..text; m.TextColor3=isUser and Color3.fromRGB(150,200,255) or Color3.fromRGB(150,255,150); m.Parent=V3.aiScroll
    task.wait()
    local layout = V3.aiScroll:FindFirstChildOfClass("UIListLayout")
    if layout then V3.aiScroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y+10); V3.aiScroll.CanvasPosition = Vector2.new(0, V3.aiScroll.AbsoluteCanvasSize.Y) end
end

local function processAI(cmd)
    local l = string.lower(cmd)
    if string.find(l, "おはよう") or string.find(l, "こんにちは") or string.find(l, "hello") or string.find(l, "hi") then return "こんにちは！今日は何を手伝いましょうか？「ヘルプ」で機能一覧が見れますよ。" end
    if string.find(l, "ありがとう") or string.find(l, "thank") then return "どういたしまして！お役に立てて嬉しいです。" end
    if string.find(l, "バカ") or string.find(l, "うざ") or string.find(l, "死ね") then return "ひどいです...。私はあなたの役に立ちたいだけなのに。" end
    if string.find(l, "かわいい") or string.find(l, "すごい") or string.find(l, "神") then return "ありがとうございます！もっと頑張ります！" end
    if string.find(l, "暇") or string.find(l, "つまらない") then return "暇ならツールタブのフライや壁歩き、回転スピンなどを試してみてください！" end
    if string.find(l, "誰") or string.find(l, "名前") then return "私はViodの専属AIアシスタントです。" end
    
    local spd = string.match(l, "スピード%s*(%d+)") or string.match(l, "speed%s*(%d+)")
    if spd then state.speed = tonumber(spd); if not state.speedEnabled then V2.speedToggle.MouseButton1Click:Fire() end; V2.speedBox.Text = spd; return "スピードを "..spd.." にしました。" end
    local jmp = string.match(l, "ジャンプ%s*(%d+)") or string.match(l, "jump%s*(%d+)")
    if jmp then state.jumpPower = tonumber(jmp); if not state.jumpEnabled then V2.jumpToggle.MouseButton1Click:Fire() end; V2.jumpBox.Text = jmp; return "ジャンプ力を "..jmp.." にしました。" end
    if string.find(l, "壁歩き") or string.find(l, "wall") then
        if string.find(l, "on") or string.find(l, "オン") then if not state.wallWalk then V2.wallToggle.MouseButton1Click:Fire() end; return "壁歩きをONにしました。" end
        if string.find(l, "off") or string.find(l, "オフ") then if state.wallWalk then V2.wallToggle.MouseButton1Click:Fire() end; return "壁歩きをOFFにしました。" end
    end
    if string.find(l, "透明") or string.find(l, "invis") then
        if string.find(l, "on") or string.find(l, "オン") then if not state.invis then V2.invisToggle.MouseButton1Click:Fire() end; return "透明化をONにしました。" end
        if string.find(l, "off") or string.find(l, "オフ") then if state.invis then V2.invisToggle.MouseButton1Click:Fire() end; return "透明化をOFFにしました。" end
    end
    if string.find(l, "リスポーン") or string.find(l, "respawn") then local h=getHum(); if h then h.Health=0 end; return "リスポーンしました。" end
    if string.find(l, "ヘルプ") or string.find(l, "help") then return "使えるコマンド:\n・スピード 100\n・ジャンプ 120\n・壁歩き ON/OFF\n・透明化 ON/OFF\n・回転 360\n・リスポーン" end
    return "なるほど。「"..cmd.."」ですね。面白いですね！他に何か機能を使ってみますか？"
end

local function sendChat()
    if V3.aiInput.Text == "" then return end
    addMsg(V3.aiInput.Text, true); local txt = V3.aiInput.Text; V3.aiInput.Text = ""
    task.wait(0.3); addMsg(processAI(txt), false)
end
V3.aiSend.MouseButton1Click:Connect(sendChat)
V3.aiInput.FocusLost:Connect(function(e) if e then sendChat() end end)
addMsg("こんにちは！何でも話しかけてくださいね。「ヘルプ」で機能一覧が出ます。", false)

-- ================= コード実行 =================
V3.execBtn.MouseButton1Click:Connect(function()
    local code = V3.codeInput.Text
    if code == "" then return end
    local success, err = pcall(function() loadstring(code)() end)
    if not success then warn("[Viod Script Error]: " .. tostring(err)) end
end)

-- ================= 設定 =================
local function applyFont(scale)
    for _, obj in ipairs(V1.mainFrame:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
            if not obj:GetAttribute("baseSize") then obj:SetAttribute("baseSize", obj.TextSize) end
            obj.TextSize = math.floor(obj:GetAttribute("baseSize") * scale)
        end
    end
end
V3.fS.MouseButton1Click:Connect(function() applyFont(0.8); V3.fS.BackgroundColor3=Color3.fromRGB(0,150,200); V3.fM.BackgroundColor3=Color3.fromRGB(70,70,90); V3.fL.BackgroundColor3=Color3.fromRGB(70,70,90) end)
V3.fM.MouseButton1Click:Connect(function() applyFont(1.0); V3.fS.BackgroundColor3=Color3.fromRGB(70,70,90); V3.fM.BackgroundColor3=Color3.fromRGB(0,150,200); V3.fL.BackgroundColor3=Color3.fromRGB(70,70,90) end)
V3.fL.MouseButton1Click:Connect(function() applyFont(1.2); V3.fS.BackgroundColor3=Color3.fromRGB(70,70,90); V3.fM.BackgroundColor3=Color3.fromRGB(70,70,90); V3.fL.BackgroundColor3=Color3.fromRGB(0,150,200) end)

local function setColor(c)
    V1.mainFrame.BackgroundColor3 = c
    V1.content.BackgroundColor3 = Color3.new(c.R*0.6, c.G*0.6, c.B*0.6)
end
V3.cBlue.MouseButton1Click:Connect(function() setColor(Color3.fromRGB(20,40,90)) end)
V3.cRed.MouseButton1Click:Connect(function() setColor(Color3.fromRGB(90,20,20)) end)
V3.cGreen.MouseButton1Click:Connect(function() setColor(Color3.fromRGB(20,90,20)) end)
V3.cPurple.MouseButton1Click:Connect(function() setColor(Color3.fromRGB(60,20,90)) end)

V3.t1.MouseButton1Click:Connect(function() V1.mainFrame.BackgroundTransparency=0.2; V1.content.BackgroundTransparency=0.2 end)
V3.t2.MouseButton1Click:Connect(function() V1.mainFrame.BackgroundTransparency=0.4; V1.content.BackgroundTransparency=0.4 end)
V3.t3.MouseButton1Click:Connect(function() V1.mainFrame.BackgroundTransparency=0.7; V1.content.BackgroundTransparency=0.7 end)

_G.ViodMenu.p5 = { refreshTpList=refreshTpList }
-- ===== Viod Ultimate Part 6/6 =====
local V1 = _G.ViodMenu.p1
local V2 = _G.ViodMenu.p2
local V3 = _G.ViodMenu.p3
local LANG = V1.LANG
local state = V1.state
local UIS = game:GetService("UserInputService")
local player = game.Players.LocalPlayer

local function applyLang()
    local t = LANG[state.lang]
    V1.title.Text = t.title
    V1.langBtn.Text = (state.lang=="ja") and "日本語 🇯🇵" or "English 🇺🇸"
    local tabNames = {t.p_tab, t.t_tab, t.m_tab, t.ai, t.s_tab, t.set}
    for i, name in ipairs(tabNames) do V1.tabs[i].Text = name end
    
    V2.speedLabel.Text=t.speed; V2.jumpLabel.Text=t.jump; V2.infjLabel.Text=t.infj; V2.noclipLabel.Text=t.noclip
    V2.respawnBtn.Text=t.respawn; V2.antiLabel.Text=t.anti
    V2.wallLabel.Text=t.wall; V2.flyLabel.Text=t.fly; V2.invisLabel.Text=t.invis; V2.rotLabel.Text=t.rot; V2.hitboxLabel.Text=t.hitbox; V2.tpLabel.Text=t.tp
    V2.aimLabel.Text=t.aim
    V3.aiInput.PlaceholderText=t.ph; V3.execBtn.Text=t.exec; V3.codeInput.PlaceholderText=t.exec_ph
end

V1.langBtn.MouseButton1Click:Connect(function()
    state.lang = (state.lang=="ja") and "en" or "ja"
    applyLang()
end)

-- 閉じるボタン (✖) -> Vボタン
V1.closeBtn.MouseButton1Click:Connect(function()
    V1.mainFrame.Visible = false
    local old = V1.screenGui:FindFirstChild("VOnlyBtn"); if old then old:Destroy() end
    local vBtn = Instance.new("TextButton")
    vBtn.Name = "VOnlyBtn"; vBtn.Size = UDim2.new(0,44,0,44); vBtn.Position = UDim2.new(1,-60,0,15)
    vBtn.BackgroundColor3 = Color3.fromRGB(50,50,75); vBtn.TextColor3 = Color3.fromRGB(255,255,255)
    vBtn.TextSize = 22; vBtn.Font = Enum.Font.GothamBold; vBtn.Text = "V"; vBtn.ZIndex = 100; vBtn.Parent = V1.screenGui
    local vc = Instance.new("UICorner"); vc.CornerRadius = UDim.new(0,8); vc.Parent = vBtn
    local vs = Instance.new("UIStroke"); vs.Thickness = 2; vs.Parent = vBtn
    task.spawn(function() local h=0; while vBtn.Parent do h=(h+0.01)%1; vs.Color=Color3.fromHSV(h,1,1); task.wait(0.03) end end)

    local dragging, dragStart, startPos, holdTimer, moved = false, nil, nil, nil, false
    vBtn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragStart = input.Position; startPos = vBtn.Position; moved = false
            holdTimer = task.delay(0.25, function()
                if not moved then dragging = true; vBtn.BackgroundColor3 = Color3.fromRGB(0,150,200) end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not dragStart then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            local d = input.Position - dragStart
            if d.Magnitude > 8 then moved = true end
            if dragging then vBtn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y) end
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if not dragStart then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if holdTimer then task.cancel(holdTimer); holdTimer = nil end
            local wasDrag, wasMoved = dragging, moved
            dragging = false; dragStart = nil; vBtn.BackgroundColor3 = Color3.fromRGB(50,50,75)
            if not wasDrag and not wasMoved then V1.mainFrame.Visible = true; vBtn:Destroy() end
        end
    end)
end)

-- 最小化ボタン (-)
local minimized = false
V1.minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        V1.body.Visible = false
        V1.mainFrame.Size = UDim2.new(0, 600, 0, 40)
        -- Vには変えず、-のまま維持
    else
        V1.body.Visible = true
        V1.mainFrame.Size = UDim2.new(0, 600, 0, 420)
    end
end)

-- ループ再適用
task.spawn(function()
    while V1.screenGui.Parent do
        local h = V1.getHum()
        if h then
            if state.speedEnabled and h.WalkSpeed ~= state.speed then h.WalkSpeed = state.speed end
            if state.jumpEnabled then h.UseJumpPower = true; if h.JumpPower ~= state.jumpPower then h.JumpPower = state.jumpPower end end
        end
        task.wait(0.05)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid", 5); task.wait(0.3)
    local h = char:FindFirstChildOfClass("Humanoid")
    if h then
        if state.speedEnabled then h.WalkSpeed = state.speed end
        if state.jumpEnabled then h.UseJumpPower=true; h.JumpPower = state.jumpPower end
    end
end)

applyLang()
if _G.ViodMenu.p5 then _G.ViodMenu.p5.refreshTpList() end
print("[Viod Ultimate] Loaded / 20+ 機能搭載完了")
