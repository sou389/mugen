local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local plr = Players.LocalPlayer
local pg = plr:WaitForChild("PlayerGui")
if pg:FindFirstChild("DeltaUI") then pg.DeltaUI:Destroy() end

local accent = Color3.fromRGB(0,170,255)
local themeEls = {}
local function reg(e,p) table.insert(themeEls,{element=e,property=p}) end
_G.D = {accent=accent, themeEls=themeEls, reg=reg, speed=16, jump=50, plr=plr}

_G.D.lang = "EN"
_G.D.texts = {
    EN = { player="Player", item="Item", other="Other", teleport="Teleport", settings="Settings",
           speed="Speed", jump="Jump", infjump="Infinite Jump", wallwalk="Wall Walk",
           wallclip="Wall Clip", fly="Fly", respawn="Respawn", leave="Leave Game",
           spin="Spin", transparent="Transparent", target_id="Target ID", stick="Stick to Player",
           tp_to_id="Teleport to ID", accentcolor="Accent Color", language="Language",
           fly_menu="FLY MENU", fly_speed="Fly Speed", open_ui="OPEN UI",
           save_loc="Save Location", players="Players", saved="Saved" },
    JA = { player="プレイヤー", item="アイテム", other="その他", teleport="テレポート", settings="設定",
           speed="スピード", jump="ジャンプ", infjump="無限ジャンプ", wallwalk="壁歩き",
           wallclip="壁抜け", fly="飛ぶ", respawn="リスポーン", leave="退出",
           spin="スピン", transparent="透明化", target_id="相手のID", stick="くっつく",
           tp_to_id="IDにテレポート", accentcolor="テーマカラー", language="言語",
           fly_menu="フライメニュー", fly_speed="飛ぶ速度", open_ui="UIを開く",
           save_loc="場所を保存", players="プレイヤー", saved="保存場所" }
}
function _G.D.T(key) return _G.D.texts[_G.D.lang][key] or key end

local gui = Instance.new("ScreenGui")
gui.Name="DeltaUI" gui.ResetOnSpawn=false gui.Parent=pg

-- ============================================
-- Key認証システム (最初に出てくる)
-- ============================================
local correctKey = "DELTA-HUB-PREMIUM-KEY-2024-ENGLISH"
local keyFrame = Instance.new("Frame")
keyFrame.Size=UDim2.new(0,350,0,180) keyFrame.Position=UDim2.new(0.5,-175,0.5,-90)
keyFrame.BackgroundColor3=Color3.fromRGB(20,20,30) keyFrame.BorderSizePixel=0 keyFrame.Parent=gui
local kfc=Instance.new("UICorner") kfc.CornerRadius=UDim.new(0,12) kfc.Parent=keyFrame
local kfs=Instance.new("UIStroke") kfs.Color=accent kfs.Thickness=2 kfs.Parent=keyFrame

local kTitle=Instance.new("TextLabel")
kTitle.Size=UDim2.new(1,0,0,40) kTitle.BackgroundTransparency=1 kTitle.Text="KEY AUTHENTICATION"
kTitle.TextColor3=accent kTitle.Font=Enum.Font.GothamBold kTitle.TextSize=16 kTitle.Parent=keyFrame

local kDesc=Instance.new("TextLabel")
kDesc.Size=UDim2.new(1,-20,0,20) kDesc.Position=UDim2.new(0,10,0,45) kDesc.BackgroundTransparency=1
kDesc.Text="Copy the Key below and paste it:" kDesc.TextColor3=Color3.fromRGB(200,200,200)
kDesc.Font=Enum.Font.GothamMedium kDesc.TextSize=12 kDesc.Parent=keyFrame

local kDisplay=Instance.new("TextLabel")
kDisplay.Size=UDim2.new(1,-20,0,24) kDisplay.Position=UDim2.new(0,10,0,65) kDisplay.BackgroundColor3=Color3.fromRGB(30,30,45)
kDisplay.Text=correctKey kDisplay.TextColor3=Color3.fromRGB(0,255,100) kDisplay.Font=Enum.Font.GothamBold
kDisplay.TextSize=12 kDisplay.Parent=keyFrame
local kdc=Instance.new("UICorner") kdc.CornerRadius=UDim.new(0,4) kdc.Parent=kDisplay

local kInput=Instance.new("TextBox")
kInput.Size=UDim2.new(1,-20,0,28) kInput.Position=UDim2.new(0,10,0,100) kInput.BackgroundColor3=Color3.fromRGB(40,40,60)
kInput.PlaceholderText="Enter Key Here..." kInput.Text="" kInput.TextColor3=Color3.fromRGB(255,255,255)
kInput.Font=Enum.Font.GothamMedium kInput.TextSize=12 kInput.BorderSizePixel=0 kInput.Parent=keyFrame
local kic=Instance.new("UICorner") kic.CornerRadius=UDim.new(0,4) kic.Parent=kInput

local kBtn=Instance.new("TextButton")
kBtn.Size=UDim2.new(1,-20,0,32) kBtn.Position=UDim2.new(0,10,0,140) kBtn.BackgroundColor3=accent
kBtn.Text="VERIFY & OPEN UI" kBtn.TextColor3=Color3.fromRGB(255,255,255)
kBtn.Font=Enum.Font.GothamBold kBtn.TextSize=12 kBtn.BorderSizePixel=0 kBtn.Parent=keyFrame
local kbc=Instance.new("UICorner") kbc.CornerRadius=UDim.new(0,6) kbc.Parent=kBtn

-- ============================================
-- メインUI (最初は非表示)
-- ============================================
local main = Instance.new("Frame")
main.Size=UDim2.new(0,520,0,340) main.Position=UDim2.new(0.5,-260,0.5,-170)
main.BackgroundColor3=Color3.fromRGB(20,20,30) main.BackgroundTransparency=0.3
main.BorderSizePixel=0 main.Visible=false main.Parent=gui
local mc=Instance.new("UICorner") mc.CornerRadius=UDim.new(0,12) mc.Parent=main
local ms=Instance.new("UIStroke") ms.Color=accent ms.Thickness=2 ms.Transparency=0.3 ms.Parent=main

local tb=Instance.new("Frame")
tb.Size=UDim2.new(1,0,0,38) tb.BackgroundColor3=Color3.fromRGB(30,30,50)
tb.BackgroundTransparency=0.5 tb.BorderSizePixel=0 tb.Parent=main
local tbc=Instance.new("UICorner") tbc.CornerRadius=UDim.new(0,12) tbc.Parent=tb

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-90,1,0) title.Position=UDim2.new(0,14,0,0)
title.BackgroundTransparency=1 title.Text="DELTA HUB" title.TextColor3=accent
title.Font=Enum.Font.GothamBold title.TextSize=15 title.TextXAlignment=Enum.TextXAlignment.Left title.Parent=tb

local minBtn=Instance.new("TextButton")
minBtn.Size=UDim2.new(0,26,0,26) minBtn.Position=UDim2.new(1,-64,0,6)
minBtn.BackgroundColor3=Color3.fromRGB(200,150,50) minBtn.Text="-"
minBtn.TextColor3=Color3.fromRGB(255,255,255) minBtn.Font=Enum.Font.GothamBold
minBtn.TextSize=18 minBtn.BorderSizePixel=0 minBtn.Parent=tb
local mbc=Instance.new("UICorner") mbc.CornerRadius=UDim.new(0,8) mbc.Parent=minBtn

local close=Instance.new("TextButton")
close.Size=UDim2.new(0,26,0,26) close.Position=UDim2.new(1,-34,0,6)
close.BackgroundColor3=Color3.fromRGB(200,50,50) close.Text="X"
close.TextColor3=Color3.fromRGB(255,255,255) close.Font=Enum.Font.GothamBold
close.TextSize=12 close.BorderSizePixel=0 close.Parent=tb
local cc=Instance.new("UICorner") cc.CornerRadius=UDim.new(0,8) cc.Parent=close
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local openBtn=Instance.new("TextButton")
openBtn.Size=UDim2.new(0,80,0,30) openBtn.Position=UDim2.new(0,10,0,10)
openBtn.BackgroundColor3=accent openBtn.Text="OPEN UI" openBtn.TextColor3=Color3.fromRGB(255,255,255)
openBtn.Font=Enum.Font.GothamBold openBtn.TextSize=12 openBtn.BorderSizePixel=0 openBtn.Visible=false openBtn.Parent=gui
local obc=Instance.new("UICorner") obc.CornerRadius=UDim.new(0,6) obc.Parent=openBtn
openBtn.MouseButton1Click:Connect(function() main.Visible=true openBtn.Visible=false end)
minBtn.MouseButton1Click:Connect(function() main.Visible=false openBtn.Visible=true end)
reg(openBtn, "BackgroundColor3")

-- Key認証成功時の処理
kBtn.MouseButton1Click:Connect(function()
 if kInput.Text == correctKey then
  keyFrame:Destroy()
  main.Visible = true
 else
  kInput.Text = ""
  kInput.PlaceholderText = "WRONG KEY!"
 end
end)

-- ドラッグ処理
local dragging=false dragStart=nil startPos=nil tPos=main.Position cPos=main.Position
tb.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
  dragging=true dragStart=i.Position startPos=main.Position cPos=main.Position tPos=main.Position
  i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
 end
end)
UIS.InputChanged:Connect(function(i)
 if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
  local d=i.Position-dragStart
  tPos=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)
RS.RenderStepped:Connect(function(dt)
 if dragging then cPos=cPos:Lerp(tPos,math.clamp(dt*30,0,1)) main.Position=cPos end
end)

local side=Instance.new("Frame")
side.Size=UDim2.new(0,110,1,-38) side.Position=UDim2.new(0,0,0,38)
side.BackgroundTransparency=0.8 side.BorderSizePixel=0 side.Parent=main
local sc=Instance.new("UICorner") sc.CornerRadius=UDim.new(0,12) sc.Parent=side
local content=Instance.new("Frame")
content.Size=UDim2.new(1,-110,1,-38) content.Position=UDim2.new(0,110,0,38)
content.BackgroundTransparency=1 content.Parent=main

_G.D.gui=gui _G.D.main=main _G.D.side=side _G.D.content=content
_G.D.title=title _G.D.ms=ms _G.D.openBtn=openBtn
print("Part 1 OK")
local D=_G.D
if not D then warn("Part 1 を先に！") return end
local plr=D.plr local UIS=game:GetService("UserInputService") local RS=game:GetService("RunService")
local accent=D.accent local reg=D.reg local T=D.T

local uiRefs = { tabs = {}, labels = {} }

local function createSlider(parent,nameKey,y,mn,mx,dv,cb)
 local cont=Instance.new("Frame")
 cont.Size=UDim2.new(1,-24,0,60) cont.Position=UDim2.new(0,12,0,y)
 cont.BackgroundTransparency=1 cont.Parent=parent
 local lbl=Instance.new("TextLabel")
 lbl.Size=UDim2.new(1,-56,0,20) lbl.BackgroundTransparency=1
 lbl.Text=T(nameKey) lbl.TextColor3=Color3.fromRGB(220,220,220)
 lbl.Font=Enum.Font.GothamMedium lbl.TextSize=11 lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Parent=cont
 table.insert(uiRefs.labels, {obj=lbl, key=nameKey})
 local vl=Instance.new("TextLabel")
 vl.Size=UDim2.new(0,50,0,20) vl.Position=UDim2.new(1,-50,0,0)
 vl.BackgroundTransparency=1 vl.Text=string.format("%.0f",dv)
 vl.TextColor3=accent vl.Font=Enum.Font.GothamBold vl.TextSize=11 vl.TextXAlignment=Enum.TextXAlignment.Right vl.Parent=cont
 reg(vl,"TextColor3")
 local bg=Instance.new("Frame")
 bg.Size=UDim2.new(1,0,0,6) bg.Position=UDim2.new(0,0,0,30)
 bg.BackgroundColor3=Color3.fromRGB(50,50,70) bg.BorderSizePixel=0 bg.Parent=cont
 local bgc=Instance.new("UICorner") bgc.CornerRadius=UDim.new(1,0) bgc.Parent=bg
 local fill=Instance.new("Frame")
 fill.Size=UDim2.new((dv-mn)/(mx-mn),0,1,0) fill.BackgroundColor3=accent fill.BorderSizePixel=0 fill.Parent=bg
 reg(fill,"BackgroundColor3")
 local fc=Instance.new("UICorner") fc.CornerRadius=UDim.new(1,0) fc.Parent=fill
 local knob=Instance.new("Frame")
 knob.Size=UDim2.new(0,14,0,14) knob.Position=UDim2.new((dv-mn)/(mx-mn),-7,0.5,-7)
 knob.BackgroundColor3=Color3.fromRGB(255,255,255) knob.BorderSizePixel=0 knob.Parent=bg
 local kc=Instance.new("UICorner") kc.CornerRadius=UDim.new(1,0) kc.Parent=knob
 local sd=false trx=(dv-mn)/(mx-mn) crx=trx
 bg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sd=true trx=math.clamp((i.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1) end end)
 UIS.InputChanged:Connect(function(i) if sd and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then trx=math.clamp((i.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1) end end)
 UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sd=false end end)
 RS.RenderStepped:Connect(function(dt)
  if not sd then return end
  crx=crx+(trx-crx)*math.clamp(dt*22,0,1)
  fill.Size=UDim2.new(crx,0,1,0) knob.Position=UDim2.new(crx,-7,0.5,-7)
  local v=mn+(mx-mn)*crx vl.Text=string.format("%.0f",v) cb(v)
 end)
 return cont
end

local function createToggle(parent,nameKey,y,cb,autoOff)
 local cont=Instance.new("Frame")
 cont.Size=UDim2.new(1,-24,0,36) cont.Position=UDim2.new(0,12,0,y)
 cont.BackgroundColor3=Color3.fromRGB(30,30,45) cont.BackgroundTransparency=0.5 cont.BorderSizePixel=0 cont.Parent=parent
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=cont
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=0.6 s.Parent=cont
 reg(s,"Color")
 local lbl=Instance.new("TextLabel")
 lbl.Size=UDim2.new(1,-60,1,0) lbl.Position=UDim2.new(0,12,0,0)
 lbl.BackgroundTransparency=1 lbl.Text=T(nameKey) lbl.TextColor3=Color3.fromRGB(220,220,220)
 lbl.Font=Enum.Font.GothamMedium lbl.TextSize=11 lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Parent=cont
 table.insert(uiRefs.labels, {obj=lbl, key=nameKey})
 local sBg=Instance.new("Frame")
 sBg.Size=UDim2.new(0,34,0,18) sBg.Position=UDim2.new(1,-46,0.5,-9)
 sBg.BackgroundColor3=Color3.fromRGB(80,80,90) sBg.BorderSizePixel=0 sBg.Parent=cont
 local sbc=Instance.new("UICorner") sbc.CornerRadius=UDim.new(1,0) sbc.Parent=sBg
 local kn=Instance.new("Frame")
 kn.Size=UDim2.new(0,14,0,14) kn.Position=UDim2.new(0,2,0.5,-7)
 kn.BackgroundColor3=Color3.fromRGB(255,255,255) kn.BorderSizePixel=0 kn.Parent=sBg
 local kc=Instance.new("UICorner") kc.CornerRadius=UDim.new(1,0) kc.Parent=kn
 local st=false busy=false
 local function set(v)
  st=v
  if st then sBg.BackgroundColor3=D.accent kn.Position=UDim2.new(1,-16,0.5,-7)
  else sBg.BackgroundColor3=Color3.fromRGB(80,80,90) kn.Position=UDim2.new(0,2,0.5,-7) end
  cb(st)
 end
 local btn=Instance.new("TextButton")
 btn.Size=UDim2.new(0,34,0,18) btn.Position=UDim2.new(1,-46,0.5,-9) btn.BackgroundTransparency=1 btn.Text="" btn.Parent=cont
 btn.MouseButton1Click:Connect(function()
  if autoOff then
   if busy then return end
   busy=true set(true) task.wait(autoOff) set(false) busy=false
  else set(not st) end
 end)
 cont.SetState = set
 return cont
end

local tabBtns={}
local function createTab(key,y,fn)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(1,-20,0,34) b.Position=UDim2.new(0,10,0,y)
 b.BackgroundTransparency=0.8 b.Text=T(key) b.TextColor3=Color3.fromRGB(200,200,200)
 b.Font=Enum.Font.GothamMedium b.TextSize=11 b.BorderSizePixel=0 b.Parent=D.side
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=b
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=1 s.Parent=b
 b.MouseButton1Click:Connect(fn)
 table.insert(tabBtns,{button=b,stroke=s})
 table.insert(uiRefs.tabs, {obj=b, key=key})
 return b
end

local playerPage=Instance.new("ScrollingFrame")
playerPage.Size=UDim2.new(1,0,1,0) playerPage.BackgroundTransparency=1
playerPage.BorderSizePixel=0 playerPage.ScrollBarThickness=4
playerPage.ScrollBarImageColor3=accent playerPage.CanvasSize=UDim2.new(0,0,0,0) playerPage.Parent=D.content
reg(playerPage,"ScrollBarImageColor3")
local pl=Instance.new("UIListLayout") pl.Padding=UDim.new(0,4) pl.Parent=playerPage

createSlider(playerPage,"speed",12,1,500,16,function(v) D.speed=v local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=v end end)
createSlider(playerPage,"jump",82,1,500,50,function(v) D.jump=v local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if h then h.JumpPower=v h.UseJumpPower=true end end)

local infJump=false
createToggle(playerPage,"infjump",152,function(st) infJump=st end)
UIS.JumpRequest:Connect(function() if infJump then local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

createToggle(playerPage,"wallwalk",190,function(st)
 local ch=plr.Character if not ch then return end local h=ch:FindFirstChildOfClass("Humanoid") if not h then return end
 if st then h.PlatformStand=true local r=ch:FindFirstChild("HumanoidRootPart") if r then r.CFrame=r.CFrame*CFrame.Angles(math.rad(-90),0,0) end
 else h.PlatformStand=false end
end)

local wallClipActive=false
createToggle(playerPage,"wallclip",228,function(st)
 wallClipActive=st local ch=plr.Character if not ch then return end
 if not st then for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end
 else for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end
  RS.Stepped:Connect(function() if not wallClipActive then return end local c=plr.Character if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end)
 end
end)

local flyToggle = createToggle(playerPage,"fly",266,function(st)
 if D.flyFunc then D.flyFunc(st) end
end)

createToggle(playerPage,"respawn",304,function(st) if st then local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end end,1)
createToggle(playerPage,"leave",342,function(st) if st then plr:Kick("Left") end end)

pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() playerPage.CanvasSize=UDim2.new(0,0,0,pl.AbsoluteContentSize.Y+12) end)

_G.D.ui = { createSlider=createSlider, createToggle=createToggle, createTab=createTab, tabBtns=tabBtns, playerPage=playerPage, uiRefs=uiRefs, flyToggle=flyToggle }
print("Part 2 OK")
local D=_G.D
if not D then warn("Part 1,2 を先に！") return end
local plr=D.plr local accent=D.accent local reg=D.reg local RS=game:GetService("RunService") local T=D.T
local UI=D.ui local createToggle=UI.createToggle local tabBtns=UI.tabBtns

local itemPage=Instance.new("ScrollingFrame")
itemPage.Size=UDim2.new(1,0,1,0) itemPage.BackgroundTransparency=1
itemPage.BorderSizePixel=0 itemPage.ScrollBarThickness=4
itemPage.ScrollBarImageColor3=accent itemPage.CanvasSize=UDim2.new(0,0,0,0) itemPage.Visible=false itemPage.Parent=D.content
reg(itemPage,"ScrollBarImageColor3")

local spinCont=Instance.new("Frame")
spinCont.Size=UDim2.new(1,-24,0,36) spinCont.Position=UDim2.new(0,12,0,12)
spinCont.BackgroundColor3=Color3.fromRGB(30,30,45) spinCont.BackgroundTransparency=0.5 spinCont.BorderSizePixel=0 spinCont.Parent=itemPage
local scC=Instance.new("UICorner") scC.CornerRadius=UDim.new(0,6) scC.Parent=spinCont
local sStroke=Instance.new("UIStroke") sStroke.Color=accent sStroke.Thickness=1 sStroke.Transparency=0.6 sStroke.Parent=spinCont
reg(sStroke,"Color")

local spinLbl=Instance.new("TextLabel")
spinLbl.Size=UDim2.new(1,-120,1,0) spinLbl.Position=UDim2.new(0,12,0,0)
spinLbl.BackgroundTransparency=1 spinLbl.Text=T("spin") spinLbl.TextColor3=Color3.fromRGB(220,220,220)
spinLbl.Font=Enum.Font.GothamMedium spinLbl.TextSize=11 spinLbl.TextXAlignment=Enum.TextXAlignment.Left spinLbl.Parent=spinCont

local spinBox=Instance.new("TextBox")
spinBox.Size=UDim2.new(0,40,0,22) spinBox.Position=UDim2.new(1,-90,0.5,-11)
spinBox.BackgroundColor3=Color3.fromRGB(50,50,70) spinBox.PlaceholderText="0"
spinBox.Text="" spinBox.TextColor3=Color3.fromRGB(220,220,220) spinBox.Font=Enum.Font.GothamBold
spinBox.TextSize=11 spinBox.BorderSizePixel=0 spinBox.Parent=spinCont
local sbc=Instance.new("UICorner") sbc.CornerRadius=UDim.new(0,4) sbc.Parent=spinBox

local switchBg=Instance.new("Frame")
switchBg.Size=UDim2.new(0,34,0,18) switchBg.Position=UDim2.new(1,-46,0.5,-9)
switchBg.BackgroundColor3=Color3.fromRGB(80,80,90) switchBg.BorderSizePixel=0 switchBg.Parent=spinCont
local sbc2=Instance.new("UICorner") sbc2.CornerRadius=UDim.new(1,0) sbc2.Parent=switchBg
local knob=Instance.new("Frame")
knob.Size=UDim2.new(0,14,0,14) knob.Position=UDim2.new(0,2,0.5,-7)
knob.BackgroundColor3=Color3.fromRGB(255,255,255) knob.BorderSizePixel=0 knob.Parent=switchBg
local kc=Instance.new("UICorner") kc.CornerRadius=UDim.new(1,0) kc.Parent=knob

local spinActive=false local currentBgv=nil
local function toggleSpin(st)
 spinActive=st local ch=plr.Character if not ch then return end local r=ch:FindFirstChild("HumanoidRootPart") if not r then return end
 if st then
  switchBg.BackgroundColor3=D.accent knob.Position=UDim2.new(1,-16,0.5,-7)
  local n=tonumber(spinBox.Text) or 50
  currentBgv=Instance.new("BodyAngularVelocity") currentBgv.AngularVelocity=Vector3.new(0,n,0)
  currentBgv.MaxTorque=Vector3.new(1e5,1e5,1e5) currentBgv.Parent=r
 else
  switchBg.BackgroundColor3=Color3.fromRGB(80,80,90) knob.Position=UDim2.new(0,2,0.5,-7)
  if currentBgv then currentBgv:Destroy() currentBgv=nil end
 end
end
local spinBtn=Instance.new("TextButton")
spinBtn.Size=UDim2.new(0,34,0,18) spinBtn.Position=UDim2.new(1,-46,0.5,-9) spinBtn.BackgroundTransparency=1 spinBtn.Text="" spinBtn.Parent=spinCont
spinBtn.MouseButton1Click:Connect(function() toggleSpin(not spinActive) end)

createToggle(itemPage,"transparent",60,function(st)
 local ch=plr.Character if not ch then return end
 for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=st and 1 or 0 end end
end)

local otherPage=Instance.new("ScrollingFrame")
otherPage.Size=UDim2.new(1,0,1,0) otherPage.BackgroundTransparency=1
otherPage.BorderSizePixel=0 otherPage.ScrollBarThickness=4
otherPage.ScrollBarImageColor3=accent otherPage.CanvasSize=UDim2.new(0,0,0,0) otherPage.Visible=false otherPage.Parent=D.content
reg(otherPage,"ScrollBarImageColor3")

local idBox=Instance.new("TextBox")
idBox.Size=UDim2.new(1,-24,0,32) idBox.Position=UDim2.new(0,12,0,12)
idBox.BackgroundColor3=Color3.fromRGB(30,30,45) idBox.BackgroundTransparency=0.5 idBox.PlaceholderText="Target ID or Name..."
idBox.Text="" idBox.TextColor3=Color3.fromRGB(220,220,220) idBox.Font=Enum.Font.GothamMedium
idBox.TextSize=11 idBox.BorderSizePixel=0 idBox.Parent=otherPage
local idbc=Instance.new("UICorner") idbc.CornerRadius=UDim.new(0,6) idbc.Parent=idBox

local function getTarget()
 local txt=idBox.Text
 if txt=="" then return nil end
 for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
  if tostring(p.UserId)==txt or p.Name:lower():match(txt:lower()) then return p end
 end
 return nil
end

local tpBtn=Instance.new("TextButton")
tpBtn.Size=UDim2.new(1,-24,0,32) tpBtn.Position=UDim2.new(0,12,0,50) tpBtn.BackgroundTransparency=0.5
tpBtn.BackgroundColor3=D.accent tpBtn.Text=T("tp_to_id") tpBtn.TextColor3=Color3.fromRGB(255,255,255)
tpBtn.Font=Enum.Font.GothamBold tpBtn.TextSize=11 tpBtn.BorderSizePixel=0 tpBtn.Parent=otherPage
D.reg(tpBtn,"BackgroundColor3")
local tpc=Instance.new("UICorner") tpc.CornerRadius=UDim.new(0,6) tpc.Parent=tpBtn
tpBtn.MouseButton1Click:Connect(function()
 local target=getTarget() if not target or not target.Character then return end
 local mh=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
 local th=target.Character:FindFirstChild("HumanoidRootPart")
 if mh and th then mh.CFrame=th.CFrame+Vector3.new(3,0,0) end
end)

local stickBtn=Instance.new("TextButton")
stickBtn.Size=UDim2.new(1,-24,0,32) stickBtn.Position=UDim2.new(0,12,0,88) stickBtn.BackgroundTransparency=0.5
stickBtn.BackgroundColor3=D.accent stickBtn.Text=T("stick") stickBtn.TextColor3=Color3.fromRGB(255,255,255)
stickBtn.Font=Enum.Font.GothamBold stickBtn.TextSize=11 stickBtn.BorderSizePixel=0 stickBtn.Parent=otherPage
D.reg(stickBtn,"BackgroundColor3")
local stc=Instance.new("UICorner") stc.CornerRadius=UDim.new(0,6) stc.Parent=stickBtn
stickBtn.MouseButton1Click:Connect(function()
 local target=getTarget() if not target or not target.Character then return end
 local mh=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
 local th=target.Character:FindFirstChild("HumanoidRootPart")
 if mh and th then
  local bv=Instance.new("BodyPosition") bv.MaxForce=Vector3.new(1e5,1e5,1e5) bv.Parent=mh
  task.spawn(function() while bv.Parent do bv.Position=th.Position task.wait() end end)
  task.delay(3, function() if bv then bv:Destroy() end end)
 end
end)

local tpPage=Instance.new("Frame")
tpPage.Size=UDim2.new(1,0,1,0) tpPage.BackgroundTransparency=1 tpPage.Visible=false tpPage.Parent=D.content
local subBar=Instance.new("Frame")
subBar.Size=UDim2.new(1,-30,0,30) subBar.Position=UDim2.new(0,15,0,8) subBar.BackgroundTransparency=1 subBar.Parent=tpPage
local subTabs={}
local function createSub(name,x,w,fn)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(0,w,1,0) b.Position=UDim2.new(0,x,0,0)
 b.BackgroundTransparency=1 b.Text=name b.TextColor3=Color3.fromRGB(200,200,200) b.Font=Enum.Font.GothamMedium
 b.TextSize=11 b.BorderSizePixel=0 b.Parent=subBar
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=1 s.Parent=b
 reg(s,"Color") b.MouseButton1Click:Connect(fn)
 table.insert(subTabs,{button=b,stroke=s}) return b
end
local playersSub=Instance.new("Frame")
playersSub.Size=UDim2.new(1,0,1,-46) playersSub.Position=UDim2.new(0,0,0,46) playersSub.BackgroundTransparency=1 playersSub.Parent=tpPage
local plist=Instance.new("ScrollingFrame")
plist.Size=UDim2.new(1,-30,1,-10) plist.Position=UDim2.new(0,15,0,5)
plist.BackgroundTransparency=1 plist.BorderSizePixel=0 plist.ScrollBarThickness=4
plist.ScrollBarImageColor3=accent plist.CanvasSize=UDim2.new(0,0,0,0) plist.Parent=playersSub
reg(plist,"ScrollBarImageColor3")
local pll=Instance.new("UIListLayout") pll.Padding=UDim.new(0,5) pll.Parent=plist
local savedSub=Instance.new("Frame")
savedSub.Size=UDim2.new(1,0,1,-46) savedSub.Position=UDim2.new(0,0,0,46) savedSub.BackgroundTransparency=1 savedSub.Visible=false savedSub.Parent=tpPage

_G.D.pt3 = { itemPage=itemPage, otherPage=otherPage, tpPage=tpPage, playersSub=playersSub, savedSub=savedSub, plist=plist, pll=pll, createSub=createSub, subTabs=subTabs }
print("Part 3 OK")
local D=_G.D
if not D then warn("Part 1,2,3 を先に！") return end
local plr=D.plr local accent=D.accent local reg=D.reg local T=D.T local RS=game:GetService("RunService") local UIS=game:GetService("UserInputService")
local UI=D.ui local P3=D.pt3 local createTab=UI.createTab local tabBtns=UI.tabBtns local uiRefs=UI.uiRefs

local setPage=Instance.new("Frame")
setPage.Size=UDim2.new(1,0,1,0) setPage.BackgroundTransparency=1 setPage.Visible=false setPage.Parent=D.content
local tlab=Instance.new("TextLabel")
tlab.Size=UDim2.new(1,-30,0,22) tlab.Position=UDim2.new(0,15,0,12) tlab.BackgroundTransparency=1 tlab.Text=T("accentcolor")
tlab.TextColor3=Color3.fromRGB(220,220,220) tlab.Font=Enum.Font.GothamMedium
tlab.TextSize=11 tlab.TextXAlignment=Enum.TextXAlignment.Left tlab.Parent=setPage
table.insert(uiRefs.labels, {obj=tlab, key="accentcolor"})

local pal={
 {n="Blue",c=Color3.fromRGB(0,170,255)},{n="Purple",c=Color3.fromRGB(160,80,255)},
 {n="Red",c=Color3.fromRGB(255,60,60)},{n="Green",c=Color3.fromRGB(0,220,120)},
 {n="Orange",c=Color3.fromRGB(255,150,0)},{n="Pink",c=Color3.fromRGB(255,100,180)},
}
for i,d in ipairs(pal) do
 local r=math.floor((i-1)/3) local col=(i-1)%3
 local sw=Instance.new("TextButton")
 sw.Size=UDim2.new(0,42,0,42) sw.Position=UDim2.new(0,15+col*52,0,45+r*52)
 sw.BackgroundColor3=d.c sw.Text="" sw.BorderSizePixel=0 sw.Parent=setPage
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=sw
 local s=Instance.new("UIStroke") s.Color=Color3.fromRGB(255,255,255) s.Thickness=2 s.Transparency=1 s.Parent=sw
 sw.MouseButton1Click:Connect(function()
  D.accent=d.c
  for _,it in ipairs(D.themeEls) do if it.element and it.element.Parent then it.element[it.property]=d.c end end
  D.ms.Color=d.c D.title.TextColor3=d.c
  for _,t in ipairs(tabBtns) do t.stroke.Color=d.c end
  for _,t in ipairs(P3.subTabs) do t.stroke.Color=d.c end
  if D.avatarStroke then D.avatarStroke.Color=d.c end
  for _,o in ipairs(setPage:GetChildren()) do if o:IsA("TextButton") and o:FindFirstChildOfClass("UIStroke") then o:FindFirstChildOfClass("UIStroke").Transparency=1 end end
  s.Transparency=0
 end)
end

local langLabel=Instance.new("TextLabel")
langLabel.Size=UDim2.new(1,-30,0,22) langLabel.Position=UDim2.new(0,15,0,165) langLabel.BackgroundTransparency=1 langLabel.Text=T("language")
langLabel.TextColor3=Color3.fromRGB(220,220,220) langLabel.Font=Enum.Font.GothamMedium
langLabel.TextSize=11 langLabel.TextXAlignment=Enum.TextXAlignment.Left langLabel.Parent=setPage
table.insert(uiRefs.labels, {obj=langLabel, key="language"})

local function createLangBtn(txt,x)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(0,80,0,32) b.Position=UDim2.new(0,x,0,195) b.BackgroundTransparency=0.5
 b.BackgroundColor3=Color3.fromRGB(30,30,45) b.Text=txt b.TextColor3=Color3.fromRGB(200,200,200)
 b.Font=Enum.Font.GothamBold b.TextSize=12 b.BorderSizePixel=0 b.Parent=setPage
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=0.6 s.Parent=b
 reg(s,"Color") return b
end
local enBtn=createLangBtn("English",15)
local jaBtn=createLangBtn("Japanese",105)

local function updateLang(newLang)
 D.lang=newLang
 for _,t in ipairs(uiRefs.tabs) do t.obj.Text=T(t.key) end
 for _,t in ipairs(uiRefs.labels) do t.obj.Text=T(t.key) end
 if D.lang=="EN" then
  enBtn.BackgroundColor3=accent enBtn.TextColor3=Color3.fromRGB(255,255,255)
  jaBtn.BackgroundColor3=Color3.fromRGB(30,30,45) jaBtn.TextColor3=Color3.fromRGB(200,200,200)
 else
  jaBtn.BackgroundColor3=accent jaBtn.TextColor3=Color3.fromRGB(255,255,255)
  enBtn.BackgroundColor3=Color3.fromRGB(30,30,45) enBtn.TextColor3=Color3.fromRGB(200,200,200)
 end
 if D.flyMini then
  D.flyMini.title.Text = T("fly_menu")
  D.flyMini.speedLbl.Text = T("fly_speed")..": "..flySpeed
 end
 D.openBtn.Text = T("open_ui")
end
enBtn.MouseButton1Click:Connect(function() updateLang("EN") end)
jaBtn.MouseButton1Click:Connect(function() updateLang("JA") end)

local pages={UI.playerPage,P3.itemPage,P3.otherPage,P3.tpPage,setPage}
local function showPage(page,btn)
 for _,p in ipairs(pages) do p.Visible=false end
 page.Visible=true
 for _,t in ipairs(tabBtns) do
  if t.button==btn then t.button.BackgroundTransparency=0.8 t.button.TextColor3=D.accent t.stroke.Transparency=0.3
  else t.button.BackgroundTransparency=1 t.button.TextColor3=Color3.fromRGB(200,200,200) t.stroke.Transparency=1 end
 end
end

local pTab=createTab("player",5,function() showPage(UI.playerPage,pTab) end)
local iTab=createTab("item",45,function() showPage(P3.itemPage,iTab) end)
local oTab=createTab("other",85,function() showPage(P3.otherPage,oTab) end)
local tTab=createTab("teleport",125,function() showPage(P3.tpPage,tTab) end)
local sTab=createTab("settings",165,function() showPage(setPage,sTab) end)
showPage(UI.playerPage,pTab)

local av=Instance.new("Frame")
av.Size=UDim2.new(0,46,0,46) av.Position=UDim2.new(0,12,1,-58) av.BackgroundTransparency=0.5 av.BorderSizePixel=0 av.Parent=D.side
local avc=Instance.new("UICorner") avc.CornerRadius=UDim.new(1,0) avc.Parent=av
local avs=Instance.new("UIStroke") avs.Color=accent avs.Thickness=2 avs.Parent=av
D.avatarStroke=avs
local avi=Instance.new("ImageLabel")
avi.Size=UDim2.new(1,-4,1,-4) avi.Position=UDim2.new(0,2,0,2) avi.BackgroundTransparency=1 avi.Parent=av
local avic=Instance.new("UICorner") avic.CornerRadius=UDim.new(1,0) avic.Parent=avi
avi.Image=string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150",plr.UserId)

D.showSub=function(page,btn)
 P3.playersSub.Visible=(page==P3.playersSub) P3.savedSub.Visible=(page==P3.savedSub)
 for _,t in ipairs(P3.subTabs) do
  if t.button==btn then t.button.BackgroundTransparency=0.8 t.button.TextColor3=D.accent t.stroke.Transparency=0.3
  else t.button.BackgroundTransparency=1 t.button.TextColor3=Color3.fromRGB(200,200,200) t.stroke.Transparency=1 end
 end
end

local pSub=P3.createSub(T("players"),0,100,function() D.showSub(P3.playersSub,pSub) end)
local sSub=P3.createSub(T("saved"),108,100,function() D.showSub(P3.savedSub,sSub) end)
table.insert(uiRefs.labels, {obj=pSub, key="players"})
table.insert(uiRefs.labels, {obj=sSub, key="saved"})
D.showSub(P3.playersSub,pSub)

local function tpTo(ch)
 local mc=plr.Character if not mc or not ch then return end
 local th=ch:FindFirstChild("HumanoidRootPart") local mh=mc:FindFirstChild("HumanoidRootPart")
 if th and mh then mh.CFrame=th.CFrame+Vector3.new(3,0,0) end
end

local function refresh()
 for _,c in ipairs(P3.plist:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
 for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
  if p~=plr then
   local b=Instance.new("TextButton")
   b.Size=UDim2.new(1,-5,0,34) b.BackgroundTransparency=0.8 b.Text="  "..p.Name b.TextColor3=Color3.fromRGB(220,220,220)
   b.Font=Enum.Font.GothamMedium b.TextSize=12 b.TextXAlignment=Enum.TextXAlignment.Left b.BorderSizePixel=0 b.Parent=P3.plist
   local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
   local s=Instance.new("UIStroke") s.Color=D.accent s.Thickness=1 s.Transparency=0.6 s.Parent=b
   D.reg(s,"Color") b.MouseButton1Click:Connect(function() if p.Character then tpTo(p.Character) end end)
  end
 end
 P3.plist.CanvasSize=UDim2.new(0,0,0,P3.pll.AbsoluteContentSize.Y)
end
game:GetService("Players").PlayerAdded:Connect(function() task.wait(0.5) refresh() end)
game:GetService("Players").PlayerRemoving:Connect(function() task.wait(0.5) refresh() end)
refresh()

local saveBtn=Instance.new("TextButton")
saveBtn.Size=UDim2.new(1,-30,0,32) saveBtn.Position=UDim2.new(0,15,0,5) saveBtn.BackgroundTransparency=0.5
saveBtn.BackgroundColor3=D.accent saveBtn.Text=T("save_loc") saveBtn.TextColor3=Color3.fromRGB(255,255,255)
saveBtn.Font=Enum.Font.GothamBold saveBtn.TextSize=12 saveBtn.BorderSizePixel=0 saveBtn.Parent=P3.savedSub
D.reg(saveBtn,"BackgroundColor3")
table.insert(uiRefs.labels, {obj=saveBtn, key="save_loc"})
local sbc=Instance.new("UICorner") sbc.CornerRadius=UDim.new(0,6) sbc.Parent=saveBtn

local savedList=Instance.new("ScrollingFrame")
savedList.Size=UDim2.new(1,-30,1,-50) savedList.Position=UDim2.new(0,15,0,45) savedList.BackgroundTransparency=1
savedList.BorderSizePixel=0 savedList.ScrollBarThickness=4 savedList.ScrollBarImageColor3=D.accent
savedList.CanvasSize=UDim2.new(0,0,0,0) savedList.Parent=P3.savedSub
D.reg(savedList,"ScrollBarImageColor3")
local sl=Instance.new("UIListLayout") sl.Padding=UDim.new(0,5) sl.Parent=savedList
local locs={}

local function refreshSaved()
 for _,c in ipairs(savedList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
 for i,d in ipairs(locs) do
  local r=Instance.new("Frame")
  r.Size=UDim2.new(1,-5,0,34) r.BackgroundTransparency=0.8 r.BorderSizePixel=0 r.Parent=savedList
  local rc=Instance.new("UICorner") rc.CornerRadius=UDim.new(0,6) rc.Parent=r
  local rs=Instance.new("UIStroke") rs.Color=D.accent rs.Thickness=1 rs.Transparency=0.6 rs.Parent=r
  D.reg(rs,"Color")
  local tb=Instance.new("TextButton")
  tb.Size=UDim2.new(1,-60,1,0) tb.BackgroundTransparency=1 tb.Text="  "..d.name tb.TextColor3=Color3.fromRGB(220,220,220)
  tb.Font=Enum.Font.GothamMedium tb.TextSize=12 tb.TextXAlignment=Enum.TextXAlignment.Left tb.Parent=r
  tb.MouseButton1Click:Connect(function() local h=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=d.cframe end end)
  local db=Instance.new("TextButton")
  db.Size=UDim2.new(0,50,0,24) db.Position=UDim2.new(1,-55,0.5,-12) db.BackgroundColor3=Color3.fromRGB(180,50,50)
  db.Text="Del" db.TextColor3=Color3.fromRGB(255,255,255) db.Font=Enum.Font.GothamBold db.TextSize=11 db.BorderSizePixel=0 db.Parent=r
  local dc=Instance.new("UICorner") dc.CornerRadius=UDim.new(0,4) dc.Parent=db
  db.MouseButton1Click:Connect(function() table.remove(locs,i) refreshSaved() end)
 end
 savedList.CanvasSize=UDim2.new(0,0,0,sl.AbsoluteContentSize.Y)
end

saveBtn.MouseButton1Click:Connect(function()
 local h=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
 if h then table.insert(locs,{name="Loc "..(#locs+1),cframe=h.CFrame}) refreshSaved() end
end)

-- ============================================
-- Fly専用の小さなUI
-- ============================================
local flyActive=false local flySpeed=50 local bv,bg

local flyMini=Instance.new("Frame")
flyMini.Size=UDim2.new(0,200,0,110) flyMini.Position=UDim2.new(0.5,-100,0.8,0)
flyMini.BackgroundColor3=Color3.fromRGB(20,20,30) flyMini.BackgroundTransparency=0.2
flyMini.BorderSizePixel=0 flyMini.Visible=false flyMini.Parent=D.gui
local fmc=Instance.new("UICorner") fmc.CornerRadius=UDim.new(0,8) fmc.Parent=flyMini
local fms=Instance.new("UIStroke") fms.Color=D.accent fms.Thickness=2 fms.Parent=flyMini
D.reg(fms,"Color")

local fmTitle=Instance.new("TextLabel")
fmTitle.Size=UDim2.new(1,-40,0,24) fmTitle.Position=UDim2.new(0,10,0,0)
fmTitle.BackgroundTransparency=1 fmTitle.Text=T("fly_menu") fmTitle.TextColor3=D.accent
fmTitle.Font=Enum.Font.GothamBold fmTitle.TextSize=12 fmTitle.TextXAlignment=Enum.TextXAlignment.Left fmTitle.Parent=flyMini
D.reg(fmTitle,"TextColor3")

local fmClose=Instance.new("TextButton")
fmClose.Size=UDim2.new(0,20,0,20) fmClose.Position=UDim2.new(1,-26,0,2)
fmClose.BackgroundColor3=Color3.fromRGB(200,50,50) fmClose.Text="X" fmClose.TextColor3=Color3.fromRGB(255,255,255)
fmClose.Font=Enum.Font.GothamBold fmClose.TextSize=10 fmClose.BorderSizePixel=0 fmClose.Parent=flyMini
local fmc2=Instance.new("UICorner") fmc2.CornerRadius=UDim.new(0,4) fmc2.Parent=fmClose

local fmSpeedLbl=Instance.new("TextLabel")
fmSpeedLbl.Size=UDim2.new(1,-20,0,20) fmSpeedLbl.Position=UDim2.new(0,10,0,30)
fmSpeedLbl.BackgroundTransparency=1 fmSpeedLbl.Text=T("fly_speed")..": 50"
fmSpeedLbl.TextColor3=Color3.fromRGB(220,220,220) fmSpeedLbl.Font=Enum.Font.GothamMedium fmSpeedLbl.TextSize=11 fmSpeedLbl.TextXAlignment=Enum.TextXAlignment.Left fmSpeedLbl.Parent=flyMini

local fmSliderBg=Instance.new("Frame")
fmSliderBg.Size=UDim2.new(1,-20,0,6) fmSliderBg.Position=UDim2.new(0,10,0,55)
fmSliderBg.BackgroundColor3=Color3.fromRGB(50,50,70) fmSliderBg.BorderSizePixel=0 fmSliderBg.Parent=flyMini
local fmsb=Instance.new("UICorner") fmsb.CornerRadius=UDim.new(1,0) fmsb.Parent=fmSliderBg
local fmFill=Instance.new("Frame")
fmFill.Size=UDim2.new(0.5,0,1,0) fmFill.BackgroundColor3=D.accent fmFill.BorderSizePixel=0 fmFill.Parent=fmSliderBg
D.reg(fmFill,"BackgroundColor3")
local fmfc=Instance.new("UICorner") fmfc.CornerRadius=UDim.new(1,0) fmfc.Parent=fmFill
local fmKnob=Instance.new("Frame")
fmKnob.Size=UDim2.new(0,14,0,14) fmKnob.Position=UDim2.new(0.5,-7,0.5,-7) fmKnob.BackgroundColor3=Color3.fromRGB(255,255,255)
fmKnob.BorderSizePixel=0 fmKnob.Parent=fmSliderBg
local fmkc=Instance.new("UICorner") fmkc.CornerRadius=UDim.new(1,0) fmkc.Parent=fmKnob

D.flyMini = {title=fmTitle, speedLbl=fmSpeedLbl}

local fmDragging=false
local function updateFMSlider(inputX)
 local relX=math.clamp((inputX-fmSliderBg.AbsolutePosition.X)/fmSliderBg.AbsoluteSize.X,0,1)
 fmFill.Size=UDim2.new(relX,0,1,0) fmKnob.Position=UDim2.new(relX,-7,0.5,-7)
 flySpeed=math.floor(10+relX*290)
 fmSpeedLbl.Text=T("fly_speed")..": "..flySpeed
end
fmSliderBg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fmDragging=true updateFMSlider(i.Position.X) end end)
UIS.InputChanged:Connect(function(i) if fmDragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then updateFMSlider(i.Position.X) end end)
UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then fmDragging=false end end)

local fmDrag=false fmStart=nil fmStartPos=nil
fmTitle.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
  fmDrag=true fmStart=i.Position fmStartPos=flyMini.Position
  i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then fmDrag=false end end)
 end
end)
UIS.InputChanged:Connect(function(i)
 if fmDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
  local d=i.Position-fmStart
  flyMini.Position=UDim2.new(fmStartPos.X.Scale,fmStartPos.X.Offset+d.X,fmStartPos.Y.Scale,fmStartPos.Y.Offset+d.Y)
 end
end)

local function toggleFly(st)
 flyActive=st
 local ch=plr.Character if not ch then return end
 local r=ch:FindFirstChild("HumanoidRootPart") if not r then return end
 if st then
  flyMini.Visible=true
  if bv then bv:Destroy() end
  if bg then bg:Destroy() end
  bv=Instance.new("BodyVelocity") bv.MaxForce=Vector3.new(1e5,1e5,1e5) bv.Parent=r
  bg=Instance.new("BodyGyro") bg.MaxTorque=Vector3.new(1e5,1e5,1e5) bg.P=1e4 bg.Parent=r
  if UI.flyToggle and UI.flyToggle.SetState then UI.flyToggle.SetState(true) end
 else
  flyMini.Visible=false
  if bv then bv:Destroy() bv=nil end
  if bg then bg:Destroy() bg=nil end
  if UI.flyToggle and UI.flyToggle.SetState then UI.flyToggle.SetState(false) end
 end
end
D.flyFunc = toggleFly

fmClose.MouseButton1Click:Connect(function() toggleFly(false) end)

RS.RenderStepped:Connect(function()
 if not flyActive or not bv or not bg then return end
 local cam=workspace.CurrentCamera local move=Vector3.new(0,0,0)
 if UIS:IsKeyDown(Enum.KeyCode.W) then move=move+cam.CFrame.LookVector end
 if UIS:IsKeyDown(Enum.KeyCode.S) then move=move-cam.CFrame.LookVector end
 if UIS:IsKeyDown(Enum.KeyCode.A) then move=move-cam.CFrame.RightVector end
 if UIS:IsKeyDown(Enum.KeyCode.D) then move=move+cam.CFrame.RightVector end
 if UIS:IsKeyDown(Enum.KeyCode.Space) then move=move+Vector3.new(0,1,0) end
 bv.Velocity=move*flySpeed bg.CFrame=cam.CFrame
end)

local function apply(ch)
 local h=ch:WaitForChild("Humanoid",5)
 if h then h.WalkSpeed=D.speed h.JumpPower=D.jump h.UseJumpPower=true end
end
plr.CharacterAdded:Connect(apply)
if plr.Character then apply(plr.Character) end

UIS.InputBegan:Connect(function(i,gp)
 if gp then return end
 if i.KeyCode==Enum.KeyCode.Return then 
  D.main.Visible=not D.main.Visible 
  D.openBtn.Visible = not D.main.Visible
 end
end)

updateLang("EN")
print("Part 4 OK")
