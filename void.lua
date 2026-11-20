-- 既存のUIがあれば削除（連続実行時のエラー防止）
local oldGui = game.CoreGui:FindFirstChild("VoidUI")
if oldGui then oldGui:Destroy() end

-- ScreenGuiの作成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true -- 画面の一番上に配置するため

-- メインのUI（薄い透明な黒）
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- 黒
MainFrame.BackgroundTransparency = 0.5 -- 透明度（0が不透明、1が完全透明。0.5で半透明）
MainFrame.Position = UDim2.new(0, 20, 0, 20) -- 画面左上から少しずらす
MainFrame.Size = UDim2.new(0, 200, 0, 40) -- 横長のUI
MainFrame.BorderSizePixel = 0

-- UIに角丸をつける（オシャレに見せる）
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = MainFrame

-- 枠線をつける（任意。不要なら削除）
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(80, 0, 150) -- 暗い紫
UIStroke.Thickness = 1.5
UIStroke.Transparency = 0.3
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 「void」という文字（左寄せ）
local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = MainFrame
TextLabel.BackgroundTransparency = 1 -- 文字の背景は透明
TextLabel.Size = UDim2.new(1, -10, 1, 0) -- 少し右に余白
TextLabel.Position = UDim2.new(0, 10, 0, 0) -- 左から10ピクセルずらす
TextLabel.Text = "void"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255) -- 白文字
TextLabel.TextSize = 20
TextLabel.Font = Enum.Font.GothamBold -- 太めのスタイリッシュなフォント
TextLabel.TextXAlignment = Enum.TextXAlignment.Left -- 左揃え
