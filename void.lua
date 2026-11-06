-- Delta Executor 用 横長UI & 虹色枠 & プレイヤーメニュー
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- 状態管理
local state = {
    wallWalk = false,
    noclip = false,
    speed = 16,
    jumpPower = 50,
}

-- ===== UI 作成 =====
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DeltaMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

-- メインフレーム（横長・半透明）
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 560, 0, 300)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
mainFrame.BackgroundTransparency = 0.25
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = mainFrame

-- 虹色に光る枠
local stroke = Instance.new("UIStroke")
stroke.Thickness = 3
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.Parent = mainFrame

-- 虹色アニメーション
local hue = 0
task.spawn(function()
    while screenGui.Parent do
        hue = (hue + 0.01) % 1
        stroke.Color = Color3.fromHSV(hue, 1, 1)
        task.wait(0.03)
    end
end)

-- タイトル
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -20, 0, 40)
title.Position = UDim2.new(0, 10, 0, 8)
title.BackgroundTransparency = 1
title.Text = "Delta Menu"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextScaled = true
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = mainFrame

-- 左側のボタンエリア（横並び）
local buttonContainer = Instance.new("Frame")
buttonContainer.Size = UDim2.new(0, 150, 1, -60)
buttonContainer.Position = UDim2.new(0, 10, 0, 50)
buttonContainer.BackgroundTransparency = 1
buttonContainer.Parent = mainFrame

local buttonLayout = Instance.new("UIListLayout")
buttonLayout.Padding = UDim.new(0, 8)
buttonLayout.SortOrder = Enum.SortOrder.LayoutOrder
buttonLayout.Parent = buttonContainer

-- プレイヤーボタン
local playerBtn = Instance.new("TextButton")
playerBtn.Size = UDim2.new(1, 0, 0, 50)
playerBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 90)
playerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
playerBtn.TextScaled = true
playerBtn.Font = Enum.Font.GothamBold
playerBtn.Text = "プレイヤー"
playerBtn.LayoutOrder = 1
playerBtn.Parent = buttonContainer

local pbCorner = Instance.new("UICorner")
pbCorner.CornerRadius = UDim.new(0, 8)
pbCorner.Parent = playerBtn

-- 右側のコンテンツエリア
local contentArea = Instance.new("Frame")
contentArea.Size = UDim2.new(1, -180, 1, -60)
contentArea.Position = UDim2.new(0, 170, 0, 50)
contentArea.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
contentArea.BackgroundTransparency = 0.3
contentArea.BorderSizePixel = 0
contentArea.Visible = false
contentArea.Parent = mainFrame

local caCorner = Instance.new("UICorner")
caCorner.CornerRadius = UDim.new(0, 8)
caCorner.Parent = contentArea

local contentLayout = Instance.new("UIListLayout")
contentLayout.Padding = UDim.new(0, 8)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
contentLayout.Parent = contentArea

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingTop = UDim.new(0, 8)
contentPadding.PaddingLeft = UDim.new(0, 8)
contentPadding.PaddingRight = UDim.new(0, 8)
contentPadding.Parent = contentArea

-- プレイヤーボタンでコンテンツ表示切替
playerBtn.MouseButton1Click:Connect(function()
    contentArea.Visible = not contentArea.Visible
end)

-- ===== プレイヤーメニュー内の項目 =====

-- ヘルパー: 行フレーム
local function createRow(order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 40)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = contentArea
    return row
end

-- ラベル作成ヘルパー
local function createLabel(parent, text, x, width)
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, width, 1, 0)
    lbl.Position = UDim2.new(0, x, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.TextScaled = true
    lbl.Font = Enum.Font.Gotham
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = parent
    return lbl
end

-- スピード行
local speedRow = createRow(1)
createLabel(speedRow, "スピード:", 0, 90)
local speedBox = Instance.new("TextBox")
speedBox.Size = UDim2.new(0, 70, 1, 0)
speedBox.Position = UDim2.new(0, 95, 0, 0)
speedBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
speedBox.TextColor3 = Color3.fromRGB(255, 255, 255)
speedBox.Text = "16"
speedBox.Font = Enum.Font.Gotham
speedBox.TextScaled = true
speedBox.Parent = speedRow
local sbCorner = Instance.new("UICorner")
sbCorner.CornerRadius = UDim.new(0, 6)
sbCorner.Parent = speedBox

local speedApply = Instance.new("TextButton")
speedApply.Size = UDim2.new(0, 80, 1, 0)
speedApply.Position = UDim2.new(0, 175, 0, 0)
speedApply.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
speedApply.TextColor3 = Color3.fromRGB(255, 255, 255)
speedApply.Text = "実行"
speedApply.Font = Enum.Font.GothamBold
speedApply.TextScaled = true
speedApply.Parent = speedRow
local saCorner = Instance.new("UICorner")
saCorner.CornerRadius = UDim.new(0, 6)
saCorner.Parent = speedApply

-- ジャンプ力行
local jumpRow = createRow(2)
createLabel(jumpRow, "ジャンプ力:", 0, 90)
local jumpBox = Instance.new("TextBox")
jumpBox.Size = UDim2.new(0, 70, 1, 0)
jumpBox.Position = UDim2.new(0, 95, 0, 0)
jumpBox.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
jumpBox.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpBox.Text = "50"
jumpBox.Font = Enum.Font.Gotham
jumpBox.TextScaled = true
jumpBox.Parent = jumpRow
local jbCorner = Instance.new("UICorner")
jbCorner.CornerRadius = UDim.new(0, 6)
jbCorner.Parent = jumpBox

local jumpApply = Instance.new("TextButton")
jumpApply.Size = UDim2.new(0, 80, 1, 0)
jumpApply.Position = UDim2.new(0, 175, 0, 0)
jumpApply.BackgroundColor3 = Color3.fromRGB(0, 180, 120)
jumpApply.TextColor3 = Color3.fromRGB(255, 255, 255)
jumpApply.Text = "実行"
jumpApply.Font = Enum.Font.GothamBold
jumpApply.TextScaled = true
jumpApply.Parent = jumpRow
local jaCorner = Instance.new("UICorner")
jaCorner.CornerRadius = UDim.new(0, 6)
jaCorner.Parent = jumpApply

-- 壁歩き行
local wallRow = createRow(3)
createLabel(wallRow, "壁歩き:", 0, 90)
local wallToggle = Instance.new("TextButton")
wallToggle.Size = UDim2.new(0, 150, 1, 0)
wallToggle.Position = UDim2.new(0, 95, 0, 0)
wallToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
wallToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
wallToggle.Text = "OFF"
wallToggle.Font = Enum.Font.GothamBold
wallToggle.TextScaled = true
wallToggle.Parent = wallRow
local wCorner = Instance.new("UICorner")
wCorner.CornerRadius = UDim.new(0, 6)
wCorner.Parent = wallToggle

-- 貫通行
local noclipRow = createRow(4)
createLabel(noclipRow, "貫通:", 0, 90)
local noclipToggle = Instance.new("TextButton")
noclipToggle.Size = UDim2.new(0, 150, 1, 0)
noclipToggle.Position = UDim2.new(0, 95, 0, 0)
noclipToggle.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
noclipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
noclipToggle.Text = "OFF"
noclipToggle.Font = Enum.Font.GothamBold
noclipToggle.TextScaled = true
noclipToggle.Parent = noclipRow
local nCorner = Instance.new("UICorner")
nCorner.CornerRadius = UDim.new(0, 6)
nCorner.Parent = noclipToggle

-- リスポーン行
local respawnRow = createRow(5)
local respawnBtn = Instance.new("TextButton")
respawnBtn.Size = UDim2.new(1, 0, 1, 0)
respawnBtn.BackgroundColor3 = Color3.fromRGB(200, 80, 80)
respawnBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
respawnBtn.Text = "即リスポーン"
respawnBtn.Font = Enum.Font.GothamBold
respawnBtn.TextScaled = true
respawnBtn.Parent = respawnRow
local rCorner = Instance.new("UICorner")
rCorner.CornerRadius = UDim.new(0, 6)
rCorner.Parent = respawnBtn

-- ===== 機能実装 =====

local function getHumanoid()
    local char = player.Character
    if char then
        return char:FindFirstChildOfClass("Humanoid")
    end
    return nil
end

-- スピード実行
speedApply.MouseButton1Click:Connect(function()
    local val = tonumber(speedBox.Text)
    if val then
        local hum = getHumanoid()
        if hum then
            hum.WalkSpeed = val
            state.speed = val
        end
    end
end)

-- ジャンプ力実行
jumpApply.MouseButton1Click:Connect(function()
    local val = tonumber(jumpBox.Text)
    if val then
        local hum = getHumanoid()
        if hum then
            hum.UseJumpPower = true
            hum.JumpPower = val
            state.jumpPower = val
        end
    end
end)

-- 壁歩きトグル
wallToggle.MouseButton1Click:Connect(function()
    state.wallWalk = not state.wallWalk
    wallToggle.Text = state.wallWalk and "ON" or "OFF"
    wallToggle.BackgroundColor3 = state.wallWalk and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(80, 80, 100)

    local char = player.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bodyVelocity = hrp:FindFirstChild("WallWalkVelocity")
            local bodyGyro = hrp:FindFirstChild("WallWalkGyro")
            if state.wallWalk then
                if not bodyVelocity then
                    bodyVelocity = Instance.new("BodyVelocity")
                    bodyVelocity.Name = "WallWalkVelocity"
                    bodyVelocity.MaxForce = Vector3.new(0, 0, 0)
                    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                    bodyVelocity.Parent = hrp
                end
                if not bodyGyro then
                    bodyGyro = Instance.new("BodyGyro")
                    bodyGyro.Name = "WallWalkGyro"
                    bodyGyro.MaxTorque = Vector3.new(0, 0, 0)
                    bodyGyro.Parent = hrp
                end
            else
                if bodyVelocity then bodyVelocity:Destroy() end
                if bodyGyro then bodyGyro:Destroy() end
            end
        end
    end
end)

-- 壁歩きの簡易実装（キャラクターに追従）
task.spawn(function()
    while screenGui.Parent do
        if state.wallWalk then
            local char = player.Character
            if char then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local bv = hrp:FindFirstChild("WallWalkVelocity")
                    local bg = hrp:FindFirstChild("WallWalkGyro")
                    if bv then
                        local ray = Ray.new(hrp.Position, hrp.CFrame.LookVector * 5)
                        local hit, pos, normal = workspace:FindPartOnRay(ray, char)
                        if hit and normal then
                            bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
                            bv.Velocity = Vector3.new(0, 0, 0)
                            bg.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
                            bg.CFrame = CFrame.new(hrp.Position, hrp.Position + normal)
                        else
                            bv.MaxForce = Vector3.new(0, 0, 0)
                            bg.MaxTorque = Vector3.new(0, 0, 0)
                        end
                    end
                end
            end
        end
        task.wait(0.05)
    end
end)

-- 貫通トグル
noclipToggle.MouseButton1Click:Connect(function()
    state.noclip = not state.noclip
    noclipToggle.Text = state.noclip and "ON" or "OFF"
    noclipToggle.BackgroundColor3 = state.noclip and Color3.fromRGB(0, 180, 120) or Color3.fromRGB(80, 80, 100)
end)

-- 貫通の実装
task.spawn(function()
    while screenGui.Parent do
        if state.noclip then
            local char = player.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

-- 即リスポーン
respawnBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
        end
    end
end)

-- リスポーン時の再適用
player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    task.wait(0.5)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = state.speed
        hum.UseJumpPower = true
        hum.JumpPower = state.jumpPower
    end
end)
