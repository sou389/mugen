-- 既存のUIがあれば削除
local oldGui = game.CoreGui:FindFirstChild("VoidUI")
if oldGui then oldGui:Destroy() end

-- ScreenGuiの作成
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "VoidUI"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

--------------------------------------------------
-- 1. 最初に表示される「実行」ボタン
--------------------------------------------------
local StartButton = Instance.new("TextButton")
StartButton.Parent = ScreenGui
StartButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StartButton.BackgroundTransparency = 0.3
StartButton.Position = UDim2.new(0, 20, 0, 20)
StartButton.Size = UDim2.new(0, 100, 0, 40)
StartButton.Font = Enum.Font.GothamBold
StartButton.Text = "実行"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.TextSize = 20
StartButton.BorderSizePixel = 0

-- ボタンに角丸をつける
local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0, 8)
BtnCorner.Parent = StartButton

--------------------------------------------------
-- 2. メインのUI（大きくして長押しで動かせる）
--------------------------------------------------
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.BackgroundTransparency = 0.4 -- 薄い透明な黒
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -60) -- 画面中央に配置
MainFrame.Size = UDim2.new(0, 300, 0, 120) -- 大きくサイズアップ
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false -- 最初は非表示

-- UIに角丸をつける
local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 12)
FrameCorner.Parent = MainFrame

-- 枠線（紫）
local UIStroke = Instance.new("UIStroke")
UIStroke.Parent = MainFrame
UIStroke.Color = Color3.fromRGB(150, 0, 255)
UIStroke.Thickness = 2
UIStroke.Transparency = 0.2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

-- 左上の「void」テキスト
local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = MainFrame
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(1, -20, 0, 40)
TextLabel.Position = UDim2.new(0, 15, 0, 10)
TextLabel.Text = "void"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 32
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.TextYAlignment = Enum.TextYAlignment.Top

-- UIの中身（例：装飾や機能用の枠）
local InnerFrame = Instance.new("Frame")
InnerFrame.Parent = MainFrame
InnerFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InnerFrame.BackgroundTransparency = 0.5
InnerFrame.Position = UDim2.new(0, 15, 0, 60)
InnerFrame.Size = UDim2.new(1, -30, 0, 40)
InnerFrame.BorderSizePixel = 0

local InnerCorner = Instance.new("UICorner")
InnerCorner.CornerRadius = UDim.new(0, 6)
InnerCorner.Parent = InnerFrame

local InnerText = Instance.new("TextLabel")
InnerText.Parent = InnerFrame
InnerText.BackgroundTransparency = 1
InnerText.Size = UDim2.new(1, 0, 1, 0)
InnerText.Text = "フライドポテトを売る異変 用スクリプト"
InnerText.TextColor3 = Color3.fromRGB(200, 200, 200)
InnerText.TextSize = 14
InnerText.Font = Enum.Font.Gotham

--------------------------------------------------
-- 3. 長押し（ドラッグ）でUIを動かす機能
--------------------------------------------------
local UserInputService = game:GetService("UserInputService")
local dragging = false
local dragInput, dragStart, startPos

local function updateDrag(input)
	local delta = input.Position - dragStart
	MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

MainFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
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

MainFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

--------------------------------------------------
-- 4. ボタンを押した時の処理（Roblox側の確認ポップアップ）
--------------------------------------------------
StartButton.MouseButton1Click:Connect(function()
	-- ボタンの連打を防ぐ
	StartButton.Text = "確認中..."
	StartButton.Active = false
	
	-- Roblox標準の確認ダイアログ（非同期処理）
	task.spawn(function()
		local success, result = pcall(function()
			-- ダイアログを表示
			return game.StarterGui:SetCore("SendNotification", {
				Title = "Void",
				Text = "スクリプトを実行しますか？",
				Duration = 3,
			})
		end)
		
		-- ちょっと待機してからUIを表示（演出用）
		task.wait(0.5)
		
		-- メインUIを表示し、実行ボタンを消す
		MainFrame.Visible = true
		StartButton.Visible = false
		
		-- 実際の「実行しますか？」のポップアップ
		-- Robloxの仕様上、本物のOSダイアログ（はい/いいえ）をスクリプトから出すことはできません。
		-- 代わりに画面中央にカスタムの確認ウィンドウを出します。
		local ConfirmGui = Instance.new("ScreenGui")
		ConfirmGui.Name = "ConfirmPopup"
		ConfirmGui.Parent = game.CoreGui
		
		local ConfirmFrame = Instance.new("Frame")
		ConfirmFrame.Parent = ConfirmGui
		ConfirmFrame.Size = UDim2.new(0, 300, 0, 150)
		ConfirmFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
		ConfirmFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		ConfirmFrame.BorderSizePixel = 0
		
		local ConfirmCorner = Instance.new("UICorner")
		ConfirmCorner.CornerRadius = UDim.new(0, 10)
		ConfirmCorner.Parent = ConfirmFrame
		
		local ConfirmText = Instance.new("TextLabel")
		ConfirmText.Parent = ConfirmFrame
		ConfirmText.Size = UDim2.new(1, 0, 0.5, 0)
		ConfirmText.Position = UDim2.new(0, 0, 0.1, 0)
		ConfirmText.BackgroundTransparency = 1
		ConfirmText.Text = "Robloxから確認:\n実行しますか？"
		ConfirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
		ConfirmText.TextSize = 18
		ConfirmText.Font = Enum.Font.GothamBold
		
		-- 「はい」ボタン
		local YesBtn = Instance.new("TextButton")
		YesBtn.Parent = ConfirmFrame
		YesBtn.Size = UDim2.new(0.4, 0, 0.25, 0)
		YesBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
		YesBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
		YesBtn.Text = "はい"
		YesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		YesBtn.Font = Enum.Font.GothamBold
		YesBtn.TextSize = 18
		YesBtn.BorderSizePixel = 0
		
		local YesCorner = Instance.new("UICorner")
		YesCorner.CornerRadius = UDim.new(0, 5)
		YesCorner.Parent = YesBtn
		
		-- 「いいえ」ボタン
		local NoBtn = Instance.new("TextButton")
		NoBtn.Parent = ConfirmFrame
		NoBtn.Size = UDim2.new(0.4, 0, 0.25, 0)
		NoBtn.Position = UDim2.new(0.55, 0, 0.65, 0)
		NoBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
		NoBtn.Text = "いいえ"
		NoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
		NoBtn.Font = Enum.Font.GothamBold
		NoBtn.TextSize = 18
		NoBtn.BorderSizePixel = 0
		
		local NoCorner = Instance.new("UICorner")
		NoCorner.CornerRadius = UDim.new(0, 5)
		NoCorner.Parent = NoBtn
		
		-- はいを押した時
		YesBtn.MouseButton1Click:Connect(function()
			ConfirmGui:Destroy()
			-- ここに実際のスクリプトの処理を書く
			print("スクリプトが実行されました")
		end)
		
		-- いいえを押した時
		NoBtn.MouseButton1Click:Connect(function()
			ConfirmGui:Destroy()
			-- UIを元に戻す
			MainFrame.Visible = false
			StartButton.Visible = true
			StartButton.Text = "実行"
			StartButton.Active = true
		end)
	end)
end)
