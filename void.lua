-- ============================================
-- Delta Executor 用 UIスクリプト（改良版）
-- ============================================

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 既存UI削除
local oldGui = playerGui:FindFirstChild("DeltaUI")
if oldGui then oldGui:Destroy() end

-- ============================================
-- メインGUI
-- ============================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "DeltaUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = playerGui

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 300, 0, 330)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -165)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

local UIGradient = Instance.new("UIGradient")
UIGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 25, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 25))
}
UIGradient.Rotation = 45
UIGradient.Parent = MainFrame

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.3
UIStroke.Parent = MainFrame

-- ============================================
-- タイトルバー（長押し移動）
-- ============================================
local TitleBar = Instance.new("Frame")
TitleBar.Name = "TitleBar"
TitleBar.Size = UDim2.new(1, 0, 0, 40)
TitleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = TitleBar

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "DELTA HUB"
Title.TextColor3 = Color3.fromRGB(0, 200, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -38, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = TitleBar

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- ============================================
-- スムーズな長押しドラッグ
-- ============================================
local dragging = false
local dragStart, startPos
local targetPos = MainFrame.Position

TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
    or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
    or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        targetPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- 毎フレーム補間でスムーズに
RunService.RenderStepped:Connect(function(dt)
    if not dragging then return end
    MainFrame.Position = MainFrame.Position:Lerp(targetPos, math.clamp(dt * 25, 0, 1))
end)

-- ============================================
-- スライダー作成（スムーズ版）
-- ============================================
local function createSlider(name, yPos, minVal, maxVal, defaultVal, callback)
    local Container = Instance.new("Frame")
    Container.Name = name .. "Container"
    Container.Size = UDim2.new(1, -30, 0, 75)
    Container.Position = UDim2.new(0, 15, 0, yPos)
    Container.BackgroundTransparency = 1
    Container.Parent = MainFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -70, 0, 25)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Container

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Size = UDim2.new(0, 60, 0, 25)
    ValueLabel.Position = UDim2.new(1, -60, 0, 0)
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Text = string.format("%.0f", defaultVal)
    ValueLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.TextSize = 14
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValueLabel.Parent = Container

    -- スライダー背景（縦を太めに）
    local SliderBg = Instance.new("Frame")
    SliderBg.Size = UDim2.new(1, 0, 0, 12)
    SliderBg.Position = UDim2.new(0, 0, 0, 40)
    SliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    SliderBg.BorderSizePixel = 0
    SliderBg.ClipsDescendants = false
    SliderBg.Parent = Container

    local SliderBgCorner = Instance.new("UICorner")
    SliderBgCorner.CornerRadius = UDim.new(1, 0)
    SliderBgCorner.Parent = SliderBg

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((defaultVal - minVal) / (maxVal - minVal), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBg

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = Fill

    -- つまみ（大きめ）
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 28, 0, 28)
    Knob.Position = UDim2.new((defaultVal - minVal) / (maxVal - minVal), -14, 0.5, -14)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = SliderBg

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local KnobStroke = Instance.new("UIStroke")
    KnobStroke.Color = Color3.fromRGB(0, 170, 255)
    KnobStroke.Thickness = 2
    KnobStroke.Parent = Knob

    -- 操作（タッチ/マウス追従・スムーズ）
    local sliderDragging = false
    local targetRelX = (defaultVal - minVal) / (maxVal - minVal)

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

    -- 毎フレーム補間（丸がスッと追従）
    local currentRelX = (defaultVal - minVal) / (maxVal - minVal)
    RunService.RenderStepped:Connect(function(dt)
        if not sliderDragging then return end
        currentRelX = currentRelX + (targetRelX - currentRelX) * math.clamp(dt * 20, 0, 1)
        Fill.Size = UDim2.new(currentRelX, 0, 1, 0)
        Knob.Position = UDim2.new(currentRelX, -14, 0.5, -14)
        local value = minVal + (maxVal - minVal) * currentRelX
        ValueLabel.Text = string.format("%.0f", value)
        callback(value)
    end)

    return Container
end

-- ============================================
-- スピード
-- ============================================
local currentSpeed = 16
createSlider("Speed", 50, 1, 500, 16, function(value)
    currentSpeed = value
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.WalkSpeed = value end
end)

-- ============================================
-- ジャンプ
-- ============================================
local currentJump = 50
createSlider("Jump Power", 130, 1, 500, 50, function(value)
    currentJump = value
    local char = player.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    if humanoid then
        humanoid.JumpPower = value
        humanoid.UseJumpPower = true
    end
end)

-- ============================================
-- 左下の自分のアイコン（検知して自動表示）
-- ============================================
local AvatarContainer = Instance.new("Frame")
AvatarContainer.Name = "AvatarContainer"
AvatarContainer.Size = UDim2.new(0, 60, 0, 60)
AvatarContainer.Position = UDim2.new(0, 12, 1, -72)
AvatarContainer.BackgroundColor3 = Color3.fromRGB(30, 30, 50)
AvatarContainer.BorderSizePixel = 0
AvatarContainer.Parent = MainFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarContainer

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = Color3.fromRGB(0, 170, 255)
AvatarStroke.Thickness = 2
AvatarStroke.Parent = AvatarContainer

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(1, -4, 1, -4)
AvatarImage.Position = UDim2.new(0, 2, 0, 2)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = ""
AvatarImage.Parent = AvatarContainer

local AvatarImageCorner = Instance.new("UICorner")
AvatarImageCorner.CornerRadius = UDim.new(1, 0)
AvatarImageCorner.Parent = AvatarImage

-- ユーザーID検知→サムネイル取得
local function updateAvatar()
    local userId = player.UserId
    AvatarImage.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150", userId)
end

updateAvatar()
player.Changed:Connect(function(prop)
    if prop == "UserId" then updateAvatar() end
end)

-- ============================================
-- キャラクター再スポーン時適用
-- ============================================
local function applyStats(char)
    local humanoid = char:WaitForChild("Humanoid", 5)
    if humanoid then
        humanoid.WalkSpeed = currentSpeed
        humanoid.JumpPower = currentJump
        humanoid.UseJumpPower = true
    end
end

player.CharacterAdded:Connect(applyStats)
if player.Character then applyStats(player.Character) end

-- ============================================
-- 右Shiftで表示/非表示
-- ============================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        MainFrame.Visible = not MainFrame.Visible
    end
end)

print("Delta Hub UI Loaded!")
