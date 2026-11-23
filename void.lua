-- ============================================
-- Delta Hub Part 1-B（修正版）
-- ============================================
local D = _G.DeltaUI
if not D then warn("Part 1-A を先に実行！") return end

local player = D.player
local UserInputService = D.UserInputService
local RunService = D.RunService
local accentColor = D.accentColor
local reg = D.registerThemeElement

-- スライダー関数（文字小さめ・はみ出し解消）
local function createSlider(parent, name, yPos, minVal, maxVal, defaultVal, callback)
    local Container = Instance.new("Frame")
    Container.Size = UDim2.new(1, -24, 0, 66)
    Container.Position = UDim2.new(0, 12, 0, yPos)
    Container.BackgroundTransparency = 1
    Container.Parent = parent

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -56, 0, 20)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 11
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 50, 0, 20)
    ValueLabel.Position = UDim2.new(1, -50, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = string.format("%.0f", defaultVal)
    ValueLabel.TextColor3 = accentColor
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 11
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Container
    reg(ValueLabel, "TextColor3")

    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, 0, 0, 10)
    SliderBg.Position = UDim2.new(0, 0, 0, 36)
    SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    SliderBg.BorderSizePixel = 0
    SliderBg.Parent = Container
    local SliderBgCorner = Instance.new("UICorner"); SliderBgCorner.CornerRadius = UDim.new(1, 0); SliderBgCorner.Parent = SliderBg

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = accentColor
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBg
    reg(Fill, "BackgroundColor3")
    local FillCorner = Instance.new("UICorner"); FillCorner.CornerRadius = UDim.new(1, 0); FillCorner.Parent = Fill

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 22, 0, 22)
    Knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -11, 0.5, -11)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBg
    local KnobCorner = Instance.new("UICorner"); KnobCorner.CornerRadius = UDim.new(1, 0); KnobCorner.Parent = Knob
    local KnobStroke = Instance.new("UIStroke")
    KnobStroke.Color = accentColor; KnobStroke.Thickness = 2; KnobStroke.Parent = Knob
    reg(KnobStroke, "Color")

    local sliderDragging = false
    local targetRelX = (defaultVal - minVal) / (maxVal - minVal)
    local currentRelX = targetRelX
    local function computeRelX(absX)
        return math.clamp((absX - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
    end
    SliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = true
            targetRelX = computeRelX(input.Position.X)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliderDragging and (input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch) then
            targetRelX = computeRelX(input.Position.X)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            sliderDragging = false
        end
    end)
    RunService.RenderStepped:Connect(function(dt)
        if not sliderDragging then return end
        currentRelX = currentRelX + (targetRelX - currentRelX) * math.clamp(dt * 22, 0, 1)
        Fill.Size = UDim2.new(currentRelX, 0, 1, 0)
        Knob.Position = UDim2.new(currentRelX, -11, 0.5, -11)
        local value = minVal + (maxVal - minVal) * currentRelX
        ValueLabel.Text = string.format("%.0f", value)
        callback(value)
    end)
    return Container
end

-- トグル関数（自動オフ対応）
local function createToggle(parent, name, yPos, callback, autoOffTime)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 32)
    btn.Position = UDim2.new(0, 12, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(220, 220, 220)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.BorderSizePixel = 0
    btn.Parent = parent
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = accentColor; stroke.Thickness = 1; stroke.Transparency = 0.6; stroke.Parent = btn
    reg(stroke, "Color")

    local state = false
    local busy = false
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 8, 0, 8)
    indicator.Position = UDim2.new(1, -18, 0.5, -4)
    indicator.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    indicator.BorderSizePixel = 0
    indicator.Parent = btn
    local ic = Instance.new("UICorner"); ic.CornerRadius = UDim.new(1, 0); ic.Parent = indicator

    local function setState(newState)
        state = newState
        indicator.BackgroundColor3 = state and D.accentColor or Color3.fromRGB(100, 100, 100)
        callback(state)
    end

    btn.MouseButton1Click:Connect(function()
        if autoOffTime then
            if busy then return end
            busy = true
            setState(true)
            task.wait(autoOffTime)
            setState(false)
            busy = false
        else
            setState(not state)
        end
    end)
    return btn
end

-- Playerページ
local PlayerPage = Instance.new("ScrollingFrame")
PlayerPage.Size = UDim2.new(1, 0, 1, 0)
PlayerPage.BackgroundTransparency = 1
PlayerPage.BorderSizePixel = 0
PlayerPage.ScrollBarThickness = 4
PlayerPage.ScrollBarImageColor3 = accentColor
PlayerPage.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerPage.Parent = D.ContentArea
reg(PlayerPage, "ScrollBarImageColor3")
local playerPageLayout = Instance.new("UIListLayout")
playerPageLayout.Padding = UDim.new(0, 4)
playerPageLayout.Parent = PlayerPage

createSlider(PlayerPage, "Speed", 12, 1, 500, 16, function(value)
    D.currentSpeed = value
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = value end
end)

createSlider(PlayerPage, "Jump Power", 82, 1, 500, 50, function(value)
    D.currentJump = value
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.JumpPower = value; humanoid.UseJumpPower = true end
end)

createToggle(PlayerPage, "Wall Walk", 152, function(state)
    D.wallWalkEnabled = state
    local char = player.Character
    if not char then return end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    humanoid.PlatformStand = state
    if state then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = hrp.CFrame * CFrame.Angles(math.rad(-90), 0, 0) end
    end
end)

createToggle(PlayerPage, "Wall Clip (NoClip)", 190, function(state)
    D.wallClipEnabled = state
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then part.CanCollide = not state end
    end
    if state then
        RunService.Stepped:Connect(function()
            local c = player.Character
            if not c then return end
            for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
end)

-- リスポーン（ONにした瞬間1秒後に自動OFF）
createToggle(PlayerPage, "Respawn", 228, function(state)
    if state then
        local char = player.Character
        if char then
            local humanoid = char:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.Health = 0 end
        end
    end
end, 1)

-- 退出（トグル化：ONにした瞬間に退出）
createToggle(PlayerPage, "Leave Game", 266, function(state)
    if state then
        player:Kick("Left via Delta Hub")
    end
end)

playerPageLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    PlayerPage.CanvasSize = UDim2.new(0, 0, 0, playerPageLayout.AbsoluteContentSize.Y + 12)
end)

-- Teleportページ枠
local TeleportPage = Instance.new("Frame")
TeleportPage.Size = UDim2.new(1, 0, 1, 0)
TeleportPage.BackgroundTransparency = 1
TeleportPage.Visible = false
TeleportPage.Parent = D.ContentArea

local subTabBar = Instance.new("Frame")
subTabBar.Size = UDim2.new(1, -30, 0, 30)
subTabBar.Position = UDim2.new(0, 15, 0, 8)
subTabBar.BackgroundTransparency = 1
subTabBar.Parent = TeleportPage

local subTabs = {}
local function createSubTab(name, xPos, width, onClick)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, width, 1, 0)
    btn.Position = UDim2.new(0, xPos, 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.BorderSizePixel = 0
    btn.Parent = subTabBar
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn
    local stroke = Instance.new("UIStroke")
    stroke.Color = accentColor; stroke.Thickness = 1; stroke.Transparency = 1; stroke.Parent = btn
    reg(stroke, "Color")
    btn.MouseButton1Click:Connect(onClick)
    table.insert(subTabs, {button = btn, stroke = stroke})
    return btn
end

local PlayersSubPage = Instance.new("Frame")
PlayersSubPage.Size = UDim2.new(1, 0, 1, -46)
PlayersSubPage.Position = UDim2.new(0, 0, 0, 46)
PlayersSubPage.BackgroundTransparency = 1
PlayersSubPage.Parent = TeleportPage

local playerList = Instance.new("ScrollingFrame")
playerList.Size = UDim2.new(1, -30, 1, -10)
playerList.Position = UDim2.new(0, 15, 0, 5)
playerList.BackgroundTransparency = 1
playerList.BorderSizePixel = 0
playerList.ScrollBarThickness = 4
playerList.ScrollBarImageColor3 = accentColor
playerList.CanvasSize = UDim2.new(0, 0, 0, 0)
playerList.Parent = PlayersSubPage
reg(playerList, "ScrollBarImageColor3")
local playerListLayout = Instance.new("UIListLayout")
playerListLayout.Padding = UDim.new(0, 5)
playerListLayout.Parent = playerList

local SavedSubPage = Instance.new("Frame")
SavedSubPage.Size = UDim2.new(1, 0, 1, -46)
SavedSubPage.Position = UDim2.new(0, 0, 0, 46)
SavedSubPage.BackgroundTransparency = 1
SavedSubPage.Visible = false
SavedSubPage.Parent = TeleportPage

-- Settingsページ
local SettingsPage = Instance.new("Frame")
SettingsPage.Size = UDim2.new(1, 0, 1, 0)
SettingsPage.BackgroundTransparency = 1
SettingsPage.Visible = false
SettingsPage.Parent = D.ContentArea

local themeLabel = Instance.new("TextLabel")
themeLabel.Size = UDim2.new(1, -30, 0, 22)
themeLabel.Position = UDim2.new(0, 15, 0, 12)
themeLabel.BackgroundTransparency = 1
themeLabel.Text = "Accent Color"
themeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
themeLabel.Font = Enum.Font.GothamMedium
themeLabel.TextSize = 11
themeLabel.TextXAlignment = Enum.TextXAlignment.Left
themeLabel.Parent = SettingsPage

local colorPalette = {
    {name = "Blue", color = Color3.fromRGB(0, 170, 255)},
    {name = "Purple", color = Color3.fromRGB(160, 80, 255)},
    {name = "Red", color = Color3.fromRGB(255, 60, 60)},
    {name = "Green", color = Color3.fromRGB(0, 220, 120)},
    {name = "Orange", color = Color3.fromRGB(255, 150, 0)},
    {name = "Pink", color = Color3.fromRGB(255, 100, 180)},
}

for i, data in ipairs(colorPalette) do
    local row = math.floor((i - 1) / 3)
    local col = (i - 1) % 3
    local swatch = Instance.new("TextButton")
    swatch.Size = UDim2.new(0, 42, 0, 42)
    swatch.Position = UDim2.new(0, 15 + col * 52, 0, 45 + row * 52)
    swatch.BackgroundColor3 = data.color
    swatch.Text = ""
    swatch.BorderSizePixel = 0
    swatch.Parent = SettingsPage
    local sc = Instance.new("UICorner"); sc.CornerRadius = UDim.new(0, 8); sc.Parent = swatch
    local ss = Instance.new("UIStroke"); ss.Color = Color3.fromRGB(255, 255, 255); ss.Thickness = 2; ss.Transparency = 1; ss.Parent = swatch
    swatch.MouseButton1Click:Connect(function()
        D.accentColor = data.color
        for _, item in ipairs(D.allThemeElements) do
            if item.element and item.element.Parent then item.element[item.property] = data.color end
        end
        D.UIStroke.Color = data.color
        D.Title.TextColor3 = data.color
        for _, tab in ipairs(D.tabButtons) do tab.stroke.Color = data.color end
        for _, tab in ipairs(subTabs) do tab.stroke.Color = data.color end
        if D.AvatarStroke then D.AvatarStroke.Color = data.color end
        for _, other in ipairs(SettingsPage:GetChildren()) do
            if other:IsA("TextButton") and other:FindFirstChildOfClass("UIStroke") then
                other:FindFirstChildOfClass("UIStroke").Transparency = 1
            end
        end
        ss.Transparency = 0
    end)
end

local pages = {PlayerPage, TeleportPage, SettingsPage}
local function showPage(page, btn)
    for _, p in ipairs(pages) do p.Visible = false end
    page.Visible = true
    for _, tab in ipairs(D.tabButtons) do
        if tab.button == btn then
            tab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            tab.button.TextColor3 = D.accentColor
            tab.stroke.Transparency = 0.3
        else
            tab.button.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
            tab.stroke.Transparency = 1
        end
    end
end

local playerTab = D.createTab("Player", 15, function() showPage(PlayerPage, playerTab) end)
local teleportTab = D.createTab("Teleport", 65, function() showPage(TeleportPage, teleportTab) end)
local settingsTab = D.createTab("Settings", 115, function() showPage(SettingsPage, settingsTab) end)
showPage(PlayerPage, playerTab)

-- アバター
local AvatarContainer = Instance.new("Frame")
AvatarContainer.Size = UDim2.new(0, 46, 0, 46)
AvatarContainer.Position = UDim2.new(0, 12, 1, -58)
AvatarContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
AvatarContainer.BorderSizePixel = 0
AvatarContainer.Parent = D.Sidebar
local AvatarCorner = Instance.new("UICorner"); AvatarCorner.CornerRadius = UDim.new(1, 0); AvatarCorner.Parent = AvatarContainer
local AvatarStroke = Instance.new("UIStroke"); AvatarStroke.Color = accentColor; AvatarStroke.Thickness = 2; AvatarStroke.Parent = AvatarContainer
D.AvatarStroke = AvatarStroke
local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(1, -4, 1, -4)
AvatarImage.Position = UDim2.new(0, 2, 0, 2)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Parent = AvatarContainer
local AIC = Instance.new("UICorner"); AIC.CornerRadius = UDim.new(1, 0); AIC.Parent = AvatarImage
AvatarImage.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", player.UserId)

-- サブタブ切替関数
D.showSubPage_ref = function(page, btn)
    PlayersSubPage.Visible = (page == PlayersSubPage)
    SavedSubPage.Visible = (page == SavedSubPage)
    for _, tab in ipairs(subTabs) do
        if tab.button == btn then
            tab.button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
            tab.button.TextColor3 = D.accentColor
            tab.stroke.Transparency = 0.3
        else
            tab.button.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            tab.button.TextColor3 = Color3.fromRGB(200, 200, 200)
            tab.stroke.Transparency = 1
        end
    end
end

-- 参照渡し
D.PlayersSubPage = PlayersSubPage
D.SavedSubPage = SavedSubPage
D.playerList = playerList
D.playerListLayout = playerListLayout
D.createSubTab = createSubTab
D.subTabs = subTabs

-- エンターキー
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Return then
        D.MainFrame.Visible = not D.MainFrame.Visible
    end
end)

print("Part 1-B Loaded!")
-- ============================================
-- Delta Hub Part 2
-- ============================================
local D = _G.DeltaUI
if not D then warn("Part 1-A / 1-B を先に実行！") return end

local Players = D.Players
local player = D.player

local playersSubTab = D.createSubTab("Players", 0, 100, function()
    D.showSubPage_ref(D.PlayersSubPage, playersSubTab)
end)
local savedSubTab = D.createSubTab("Saved", 108, 100, function()
    D.showSubPage_ref(D.SavedSubPage, savedSubTab)
end)
D.showSubPage_ref(D.PlayersSubPage, playersSubTab)

local function teleportTo(targetChar)
    local myChar = player.Character
    if not myChar or not targetChar then return end
    local targetHRP = targetChar:FindFirstChild("HumanoidRootPart")
    local myHRP = myChar:FindFirstChild("HumanoidRootPart")
    if targetHRP and myHRP then
        myHRP.CFrame = targetHRP.CFrame + Vector3.new(3, 0, 0)
    end
end

local function refreshPlayerList()
    for _, child in ipairs(D.playerList:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    for _, otherPlayer in ipairs(Players:GetPlayers()) do
        if otherPlayer ~= player then
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -5, 0, 34)
            btn.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
            btn.Text = "  " .. otherPlayer.Name
            btn.TextColor3 = Color3.fromRGB(220, 220, 220)
            btn.Font = Enum.Font.GothamMedium
            btn.TextSize = 12
            btn.TextXAlignment = Enum.TextXAlignment.Left
            btn.BorderSizePixel = 0
            btn.Parent = D.playerList
            local bc = Instance.new("UICorner"); bc.CornerRadius = UDim.new(0, 6); bc.Parent = btn
            local bs = Instance.new("UIStroke")
            bs.Color = D.accentColor; bs.Thickness = 1; bs.Transparency = 0.6; bs.Parent = btn
            D.registerThemeElement(bs, "Color")
            btn.MouseButton1Click:Connect(function()
                if otherPlayer.Character then teleportTo(otherPlayer.Character) end
            end)
        end
    end
    D.playerList.CanvasSize = UDim2.new(0, 0, 0, D.playerListLayout.AbsoluteContentSize.Y)
end

Players.PlayerAdded:Connect(function() task.wait(0.5) refreshPlayerList() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5) refreshPlayerList() end)
refreshPlayerList()

local saveBtn = Instance.new("TextButton")
saveBtn.Size = UDim2.new(1, -30, 0, 32)
saveBtn.Position = UDim2.new(0, 15, 0, 5)
saveBtn.BackgroundColor3 = D.accentColor
saveBtn.Text = "Save Current Location"
saveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
saveBtn.Font = Enum.Font.GothamBold
saveBtn.TextSize = 12
saveBtn.BorderSizePixel = 0
saveBtn.Parent = D.SavedSubPage
D.registerThemeElement(saveBtn, "BackgroundColor3")
local sbc = Instance.new("UICorner"); sbc.CornerRadius = UDim.new(0, 6); sbc.Parent = saveBtn

local savedList = Instance.new("ScrollingFrame")
savedList.Size = UDim2.new(1, -30, 1, -50)
savedList.Position = UDim2.new(0, 15, 0, 45)
savedList.BackgroundTransparency = 1
savedList.BorderSizePixel = 0
savedList.ScrollBarThickness = 4
savedList.ScrollBarImageColor3 = D.accentColor
savedList.CanvasSize = UDim2.new(0, 0, 0, 0)
savedList.Parent = D.SavedSubPage
D.registerThemeElement(savedList, "ScrollBarImageColor3")
local savedLayout = Instance.new("UIListLayout")
savedLayout.Padding = UDim.new(0, 5)
savedLayout.Parent = savedList

local savedLocations = {}

local function refreshSavedList()
    for _, child in ipairs(savedList:GetChildren()) do
        if child:IsA("Frame") then child:Destroy() end
    end
    for i, data in ipairs(savedLocations) do
        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -5, 0, 34)
        row.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
        row.BorderSizePixel = 0
        row.Parent = savedList
        local rc = Instance.new("UICorner"); rc.CornerRadius = UDim.new(0, 6); rc.Parent = row
        local rs = Instance.new("UIStroke")
        rs.Color = D.accentColor; rs.Thickness = 1; rs.Transparency = 0.6; rs.Parent = row
        D.registerThemeElement(rs, "Color")

        local tpBtn = Instance.new("TextButton")
        tpBtn.Size = UDim2.new(1, -60, 1, 0)
        tpBtn.BackgroundTransparency = 1
        tpBtn.Text = "  " .. data.name
        tpBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
        tpBtn.Font = Enum.Font.GothamMedium
        tpBtn.TextSize = 12
        tpBtn.TextXAlignment = Enum.TextXAlignment.Left
        tpBtn.Parent = row
        tpBtn.MouseButton1Click:Connect(function()
            local myChar = player.Character
            local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
            if myHRP then myHRP.CFrame = data.cframe end
        end)

        local delBtn = Instance.new("TextButton")
        delBtn.Size = UDim2.new(0, 50, 0, 24)
        delBtn.Position = UDim2.new(1, -55, 0.5, -12)
        delBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
        delBtn.Text = "Del"
        delBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 11
        delBtn.BorderSizePixel = 0
        delBtn.Parent = row
        local dc = Instance.new("UICorner"); dc.CornerRadius = UDim.new(0, 4); dc.Parent = delBtn
        delBtn.MouseButton1Click:Connect(function()
            table.remove(savedLocations, i)
            refreshSavedList()
        end)
    end
    savedList.CanvasSize = UDim2.new(0, 0, 0, savedLayout.AbsoluteContentSize.Y)
end

saveBtn.MouseButton1Click:Connect(function()
    local myChar = player.Character
    local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
    if myHRP then
        local locName = "Loc " .. (#savedLocations + 1)
        table.insert(savedLocations, {name = locName, cframe = myHRP.CFrame})
        refreshSavedList()
    end
end)

local function applyStats(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = D.currentSpeed
        humanoid.JumpPower = D.currentJump
        humanoid.UseJumpPower = true
    end
end
player.CharacterAdded:Connect(applyStats)
if player.Character then applyStats(player.Character) end

print("Delta Hub Part 2 Loaded!")
