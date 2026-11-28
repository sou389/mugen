local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local plr = Players.LocalPlayer
local pg = plr:WaitForChild("PlayerGui")
if pg:FindFirstChild("DeltaUI") then pg.DeltaUI:Destroy() end

local accent = Color3.fromRGB(0,170,255)
_G.D = {accent=accent, speed=16, jump=50, plr=plr, themeEls={}}
local function reg(e,p) table.insert(_G.D.themeEls,{element=e,property=p}) end

local lang = "EN"
local texts = {
    EN = { player="Player", item="Item", other="Other", teleport="Teleport", settings="Settings",
           speed="Speed", jump="Jump", infjump="Infinite Jump", wallwalk="Wall Walk",
           wallclip="Wall Clip", fly="Fly", respawn="Respawn", leave="Leave Game",
           spin="Spin", transparent="Transparent", target_id="Target ID", stick="Stick to Player",
           tp_to_id="Teleport to ID", accentcolor="Accent Color", language="Language",
           save_loc="Save Location", players="Players", saved="Saved", open_ui="OPEN UI",
           confirm_close="Close UI?", yes="YES", no="NO" },
    JA = { player="プレイヤー", item="アイテム", other="その他", teleport="テレポート", settings="設定",
           speed="スピード", jump="ジャンプ", infjump="無限ジャンプ", wallwalk="壁歩き",
           wallclip="壁抜け", fly="飛ぶ", respawn="リスポーン", leave="退出",
           spin="スピン", transparent="透明化", target_id="相手のID", stick="くっつく",
           tp_to_id="IDにテレポート", accentcolor="テーマカラー", language="言語",
           save_loc="場所を保存", players="プレイヤー", saved="保存場所", open_ui="UIを開く",
           confirm_close="UIを閉じますか？", yes="はい", no="いいえ" }
}
local function T(k) return texts[lang][k] or k end

local gui = Instance.new("ScreenGui")
gui.Name="DeltaUI" gui.ResetOnSpawn=false gui.Parent=pg

local main = Instance.new("Frame")
main.Size=UDim2.new(0,520,0,340) main.Position=UDim2.new(0.5,-260,0.5,-170)
main.BackgroundColor3=Color3.fromRGB(20,20,30) main.BackgroundTransparency=0.3
main.BorderSizePixel=0 main.Parent=gui
local mc=Instance.new("UICorner") mc.CornerRadius=UDim.new(0,12) mc.Parent=main
local ms=Instance.new("UIStroke") ms.Color=accent ms.Thickness=2 ms.Transparency=0.3 ms.Parent=main

local tb=Instance.new("Frame")
tb.Size=UDim2.new(1,0,0,38) tb.BackgroundColor3=Color3.fromRGB(30,30,50)
tb.BackgroundTransparency=0.5 tb.BorderSizePixel=0 tb.Parent=main
local tbc=Instance.new("UICorner") tbc.CornerRadius=UDim.new(0,12) tbc.Parent=tb

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-100,1,0) title.Position=UDim2.new(0,14,0,0)
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

local openBtn=Instance.new("TextButton")
openBtn.Size=UDim2.new(0,80,0,30) openBtn.Position=UDim2.new(0,10,0,10)
openBtn.BackgroundColor3=accent openBtn.Text="OPEN UI" openBtn.TextColor3=Color3.fromRGB(255,255,255)
openBtn.Font=Enum.Font.GothamBold openBtn.TextSize=12 openBtn.BorderSizePixel=0 openBtn.Visible=false openBtn.Parent=gui
local obc=Instance.new("UICorner") obc.CornerRadius=UDim.new(0,6) obc.Parent=openBtn
openBtn.MouseButton1Click:Connect(function() main.Visible=true openBtn.Visible=false end)
minBtn.MouseButton1Click:Connect(function() main.Visible=false openBtn.Visible=true end)
reg(openBtn, "BackgroundColor3")

local confirmGui = Instance.new("Frame")
confirmGui.Size=UDim2.new(0,200,0,100) confirmGui.Position=UDim2.new(0.5,-100,0.5,-50)
confirmGui.BackgroundColor3=Color3.fromRGB(20,20,30) confirmGui.BorderSizePixel=0 confirmGui.Visible=false confirmGui.Parent=gui
local cgc=Instance.new("UICorner") cgc.CornerRadius=UDim.new(0,12) cgc.Parent=confirmGui
local cgs=Instance.new("UIStroke") cgs.Color=Color3.fromRGB(255,60,60) cgs.Thickness=2 cgs.Parent=confirmGui

local cLabel=Instance.new("TextLabel")
cLabel.Size=UDim2.new(1,-20,0,30) cLabel.Position=UDim2.new(0,10,0,10) cLabel.BackgroundTransparency=1
cLabel.Text="Close UI?" cLabel.TextColor3=Color3.fromRGB(255,255,255) cLabel.Font=Enum.Font.GothamBold cLabel.TextSize=14 cLabel.Parent=confirmGui

local yesBtn=Instance.new("TextButton")
yesBtn.Size=UDim2.new(0,80,0,30) yesBtn.Position=UDim2.new(0,15,0,60) yesBtn.BackgroundColor3=Color3.fromRGB(200,50,50)
yesBtn.Text="YES" yesBtn.TextColor3=Color3.fromRGB(255,255,255) yesBtn.Font=Enum.Font.GothamBold yesBtn.TextSize=12 yesBtn.BorderSizePixel=0 yesBtn.Parent=confirmGui
local ybc=Instance.new("UICorner") ybc.CornerRadius=UDim.new(0,6) ybc.Parent=yesBtn

local noBtn=Instance.new("TextButton")
noBtn.Size=UDim2.new(0,80,0,30) noBtn.Position=UDim2.new(1,-95,0,60) noBtn.BackgroundColor3=Color3.fromRGB(50,50,70)
noBtn.Text="NO" noBtn.TextColor3=Color3.fromRGB(255,255,255) noBtn.Font=Enum.Font.GothamBold noBtn.TextSize=12 noBtn.BorderSizePixel=0 noBtn.Parent=confirmGui
local nbc=Instance.new("UICorner") nbc.CornerRadius=UDim.new(0,6) nbc.Parent=noBtn

close.MouseButton1Click:Connect(function() confirmGui.Visible = true end)
yesBtn.MouseButton1Click:Connect(function() gui:Destroy() end)
noBtn.MouseButton1Click:Connect(function() confirmGui.Visible = false end)

local dragging=false dragStart=nil startPos=nil
tb.InputBegan:Connect(function(i)
 if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
  dragging=true dragStart=i.Position startPos=main.Position
  i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
 end
end)
UIS.InputChanged:Connect(function(i)
 if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
  local d=i.Position-dragStart
  main.Position=UDim2.new(startPos.X.Scale,startPos.X.Offset+d.X,startPos.Y.Scale,startPos.Y.Offset+d.Y)
 end
end)

local side=Instance.new("Frame")
side.Size=UDim2.new(0,110,1,-38) side.Position=UDim2.new(0,0,0,38)
side.BackgroundTransparency=0.8 side.BorderSizePixel=0 side.Parent=main
local sc=Instance.new("UICorner") sc.CornerRadius=UDim.new(0,12) sc.Parent=side

local content=Instance.new("Frame")
content.Size=UDim2.new(1,-110,1,-38) content.Position=UDim2.new(0,110,0,38)
content.BackgroundTransparency=1 content.Parent=main

local uiRefs = { tabs = {}, labels = {} }
local function createSlider(parent,nameKey,y,mn,mx,dv,cb)
 local cont=Instance.new("Frame")
 cont.Size=UDim2.new(1,-24,0,60) cont.Position=UDim2.new(0,12,0,y) cont.BackgroundTransparency=1 cont.Parent=parent
 local lbl=Instance.new("TextLabel")
 lbl.Size=UDim2.new(1,-56,0,20) lbl.BackgroundTransparency=1 lbl.Text=T(nameKey) lbl.TextColor3=Color3.fromRGB(220,220,220) lbl.Font=Enum.Font.GothamMedium lbl.TextSize=11 lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Parent=cont
 table.insert(uiRefs.labels, {obj=lbl, key=nameKey})
 local vl=Instance.new("TextLabel")
 vl.Size=UDim2.new(0,50,0,20) vl.Position=UDim2.new(1,-50,0,0) vl.BackgroundTransparency=1 vl.Text=string.format("%.0f",dv) vl.TextColor3=accent vl.Font=Enum.Font.GothamBold vl.TextSize=11 vl.TextXAlignment=Enum.TextXAlignment.Right vl.Parent=cont
 reg(vl,"TextColor3")
 local bg=Instance.new("Frame")
 bg.Size=UDim2.new(1,0,0,6) bg.Position=UDim2.new(0,0,0,30) bg.BackgroundColor3=Color3.fromRGB(50,50,70) bg.BorderSizePixel=0 bg.Parent=cont
 local bgc=Instance.new("UICorner") bgc.CornerRadius=UDim.new(1,0) bgc.Parent=bg
 local fill=Instance.new("Frame")
 fill.Size=UDim2.new((dv-mn)/(mx-mn),0,1,0) fill.BackgroundColor3=accent fill.BorderSizePixel=0 fill.Parent=bg
 reg(fill,"BackgroundColor3")
 local fc=Instance.new("UICorner") fc.CornerRadius=UDim.new(1,0) fc.Parent=fill
 local knob=Instance.new("Frame")
 knob.Size=UDim2.new(0,16,0,16) knob.Position=UDim2.new((dv-mn)/(mx-mn),-8,0.5,-8) knob.BackgroundColor3=Color3.fromRGB(255,255,255) knob.BorderSizePixel=0 knob.Parent=bg
 local kc=Instance.new("UICorner") kc.CornerRadius=UDim.new(1,0) kc.Parent=knob
 local sd=false trx=(dv-mn)/(mx-mn) crx=trx
 bg.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sd=true trx=math.clamp((i.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1) end end)
 UIS.InputChanged:Connect(function(i) if sd and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then trx=math.clamp((i.Position.X-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1) end end)
 UIS.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sd=false end end)
 RS.RenderStepped:Connect(function(dt)
  if not sd then return end
  crx=crx+(trx-crx)*math.clamp(dt*22,0,1)
  fill.Size=UDim2.new(crx,0,1,0) knob.Position=UDim2.new(crx,-8,0.5,-8)
  local v=mn+(mx-mn)*crx vl.Text=string.format("%.0f",v) cb(v)
 end)
end

local function createToggle(parent,nameKey,y,cb,autoOff)
 local cont=Instance.new("Frame")
 cont.Size=UDim2.new(1,-24,0,36) cont.Position=UDim2.new(0,12,0,y) cont.BackgroundColor3=Color3.fromRGB(30,30,45) cont.BackgroundTransparency=0.5 cont.BorderSizePixel=0 cont.Parent=parent
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=cont
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=0.6 s.Parent=cont
 reg(s,"Color")
 local lbl=Instance.new("TextLabel")
 lbl.Size=UDim2.new(1,-60,1,0) lbl.Position=UDim2.new(0,12,0,0) lbl.BackgroundTransparency=1 lbl.Text=T(nameKey) lbl.TextColor3=Color3.fromRGB(220,220,220) lbl.Font=Enum.Font.GothamMedium lbl.TextSize=11 lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Parent=cont
 table.insert(uiRefs.labels, {obj=lbl, key=nameKey})
 local sBg=Instance.new("Frame")
 sBg.Size=UDim2.new(0,36,0,20) sBg.Position=UDim2.new(1,-48,0.5,-10) sBg.BackgroundColor3=Color3.fromRGB(80,80,90) sBg.BorderSizePixel=0 sBg.Parent=cont
 local sbc=Instance.new("UICorner") sbc.CornerRadius=UDim.new(1,0) sbc.Parent=sBg
 local kn=Instance.new("Frame")
 kn.Size=UDim2.new(0,16,0,16) kn.Position=UDim2.new(0,2,0.5,-8) kn.BackgroundColor3=Color3.fromRGB(255,255,255) kn.BorderSizePixel=0 kn.Parent=sBg
 local kc=Instance.new("UICorner") kc.CornerRadius=UDim.new(1,0) kc.Parent=kn
 local st=false busy=false
 local function set(v)
  st=v
  if st then sBg.BackgroundColor3=_G.D.accent kn.Position=UDim2.new(1,-18,0.5,-8)
  else sBg.BackgroundColor3=Color3.fromRGB(80,80,90) kn.Position=UDim2.new(0,2,0.5,-8) end
  cb(st)
 end
 local btn=Instance.new("TextButton")
 btn.Size=UDim2.new(1,0,1,0) btn.Position=UDim2.new(0,0,0,0) btn.BackgroundTransparency=1 btn.Text="" btn.Parent=sBg
 btn.MouseButton1Click:Connect(function()
  if autoOff then if busy then return end busy=true set(true) task.wait(autoOff) set(false) busy=false
  else set(not st) end
 end)
 cont.SetState = set
 return cont
end

local tabBtns={}
local function createTab(key,y,fn)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(1,-20,0,34) b.Position=UDim2.new(0,10,0,y) b.BackgroundTransparency=0.8 b.Text=T(key) b.TextColor3=Color3.fromRGB(200,200,200) b.Font=Enum.Font.GothamMedium b.TextSize=11 b.BorderSizePixel=0 b.Parent=side
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=b
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=1 s.Parent=b
 b.MouseButton1Click:Connect(fn)
 table.insert(tabBtns,{button=b,stroke=s})
 table.insert(uiRefs.tabs, {obj=b, key=key})
 return b
end

local av=Instance.new("Frame")
av.Size=UDim2.new(0,46,0,46) av.Position=UDim2.new(0,12,1,-58) av.BackgroundTransparency=0.5 av.BorderSizePixel=0 av.Parent=side
local avc=Instance.new("UICorner") avc.CornerRadius=UDim.new(1,0) avc.Parent=av
local avs=Instance.new("UIStroke") avs.Color=accent avs.Thickness=2 avs.Parent=av
_G.D.avatarStroke=avs
local avi=Instance.new("ImageLabel")
avi.Size=UDim2.new(1,-4,1,-4) avi.Position=UDim2.new(0,2,0,2) avi.BackgroundTransparency=1 avi.Parent=av
local avic=Instance.new("UICorner") avic.CornerRadius=UDim.new(1,0) avic.Parent=avi
avi.Image=string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150",plr.UserId)

_G.D.gui=gui _G.D.main=main _G.D.side=side _G.D.content=content _G.D.ms=ms _G.D.openBtn=openBtn
_G.D.ui = { createSlider=createSlider, createToggle=createToggle, createTab=createTab, tabBtns=tabBtns, uiRefs=uiRefs, updateLangFunc=nil }
print("Part 1 OK")
local D=_G.D
if not D then return end
local plr=D.plr local UIS=game:GetService("UserInputService") local RS=game:GetService("RunService") local accent=D.accent
local UI=D.ui local createSlider=UI.createSlider local createToggle=UI.createToggle local createTab=UI.createTab local tabBtns=UI.tabBtns local uiRefs=UI.uiRefs

-- Playerタブ
local playerPage=Instance.new("ScrollingFrame")
playerPage.Size=UDim2.new(1,0,1,0) playerPage.BackgroundTransparency=1 playerPage.BorderSizePixel=0 playerPage.ScrollBarThickness=4 playerPage.CanvasSize=UDim2.new(0,0,0,0) playerPage.Parent=D.content
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
 if not st then for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
end)
RS.Stepped:Connect(function() if wallClipActive then local c=plr.Character if c then for _,p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end end)

local flyActive=false local bv,bg
createToggle(playerPage,"fly",266,function(st)
 flyActive=st local ch=plr.Character if not ch then return end local r=ch:FindFirstChild("HumanoidRootPart") if not r then return end
 if st then
  bv=Instance.new("BodyVelocity") bv.MaxForce=Vector3.new(1e5,1e5,1e5) bv.Parent=r
  bg=Instance.new("BodyGyro") bg.MaxTorque=Vector3.new(1e5,1e5,1e5) bg.P=1e4 bg.Parent=r
 else
  if bv then bv:Destroy() bv=nil end if bg then bg:Destroy() bg=nil end
 end
end)
RS.RenderStepped:Connect(function()
 if not flyActive or not bv or not bg then return end
 local cam=workspace.CurrentCamera local move=Vector3.new(0,0,0)
 if UIS:IsKeyDown(Enum.KeyCode.W) then move=move+cam.CFrame.LookVector end
 if UIS:IsKeyDown(Enum.KeyCode.S) then move=move-cam.CFrame.LookVector end
 if UIS:IsKeyDown(Enum.KeyCode.A) then move=move-cam.CFrame.RightVector end
 if UIS:IsKeyDown(Enum.KeyCode.D) then move=move+cam.CFrame.RightVector end
 if UIS:IsKeyDown(Enum.KeyCode.Space) then move=move+Vector3.new(0,1,0) end
 bv.Velocity=move*50 bg.CFrame=cam.CFrame
end)

createToggle(playerPage,"respawn",304,function(st) if st then local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end end, 1)
createToggle(playerPage,"leave",342,function(st) if st then plr:Kick("Left") end end)

-- Itemタブ
local itemPage=Instance.new("ScrollingFrame")
itemPage.Size=UDim2.new(1,0,1,0) itemPage.BackgroundTransparency=1 itemPage.BorderSizePixel=0 itemPage.ScrollBarThickness=4 itemPage.CanvasSize=UDim2.new(0,0,0,0) itemPage.Visible=false itemPage.Parent=D.content

local spinBox=Instance.new("TextBox")
spinBox.Size=UDim2.new(1,-24,0,32) spinBox.Position=UDim2.new(0,12,0,12) spinBox.BackgroundColor3=Color3.fromRGB(30,30,45) spinBox.BackgroundTransparency=0.5 spinBox.PlaceholderText="Spin Speed..." spinBox.Text=""
spinBox.TextColor3=Color3.fromRGB(255,255,255) spinBox.Font=Enum.Font.GothamMedium spinBox.TextSize=11 spinBox.BorderSizePixel=0 spinBox.Parent=itemPage
local sbc=Instance.new("UICorner") sbc.CornerRadius=UDim.new(0,6) sbc.Parent=spinBox

createToggle(itemPage,"spin",50,function(st)
 local ch=plr.Character if not ch then return end local r=ch:FindFirstChild("HumanoidRootPart") if not r then return end
 if st then local b = Instance.new("BodyAngularVelocity") b.AngularVelocity=Vector3.new(0,tonumber(spinBox.Text) or 50,0) b.MaxTorque=Vector3.new(1e5,1e5,1e5) b.Name="SpinBV" b.Parent=r
 else local b=r:FindFirstChild("SpinBV") if b then b:Destroy() end end
end)

createToggle(itemPage,"transparent",88,function(st)
 local ch=plr.Character if not ch then return end
 for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=st and 1 or 0 end end
end)

-- Otherタブ
local otherPage=Instance.new("ScrollingFrame")
otherPage.Size=UDim2.new(1,0,1,0) otherPage.BackgroundTransparency=1 otherPage.BorderSizePixel=0 otherPage.ScrollBarThickness=4 otherPage.CanvasSize=UDim2.new(0,0,0,0) otherPage.Visible=false otherPage.Parent=D.content

local idBox=Instance.new("TextBox")
idBox.Size=UDim2.new(1,-24,0,32) idBox.Position=UDim2.new(0,12,0,12) idBox.BackgroundColor3=Color3.fromRGB(30,30,45) idBox.BackgroundTransparency=0.5 idBox.PlaceholderText="Target ID or Name..." idBox.Text="" idBox.TextColor3=Color3.fromRGB(220,220,220) idBox.Font=Enum.Font.GothamMedium idBox.TextSize=11 idBox.BorderSizePixel=0 idBox.Parent=otherPage
local idbc=Instance.new("UICorner") idbc.CornerRadius=UDim.new(0,6) idbc.Parent=idBox

local function getTarget()
 local txt=idBox.Text if txt=="" then return nil end
 for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
  if tostring(p.UserId)==txt or p.Name:lower():match(txt:lower()) then return p end
 end
end

local tpBtn=Instance.new("TextButton")
tpBtn.Size=UDim2.new(1,-24,0,32) tpBtn.Position=UDim2.new(0,12,0,50) tpBtn.BackgroundColor3=accent tpBtn.Text="Teleport to ID" tpBtn.TextColor3=Color3.fromRGB(255,255,255) tpBtn.Font=Enum.Font.GothamBold tpBtn.TextSize=11 tpBtn.BorderSizePixel=0 tpBtn.Parent=otherPage
local tpc=Instance.new("UICorner") tpc.CornerRadius=UDim.new(0,6) tpc.Parent=tpBtn
D.reg(tpBtn,"BackgroundColor3")
table.insert(uiRefs.labels, {obj=tpBtn, key="tp_to_id"})
tpBtn.MouseButton1Click:Connect(function()
 local target=getTarget() if not target or not target.Character then return end
 local mh=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") local th=target.Character:FindFirstChild("HumanoidRootPart")
 if mh and th then mh.CFrame=th.CFrame+Vector3.new(3,0,0) end
end)

local stickBtn=Instance.new("TextButton")
stickBtn.Size=UDim2.new(1,-24,0,32) stickBtn.Position=UDim2.new(0,12,0,88) stickBtn.BackgroundColor3=accent stickBtn.Text="Stick to ID" stickBtn.TextColor3=Color3.fromRGB(255,255,255) stickBtn.Font=Enum.Font.GothamBold stickBtn.TextSize=11 stickBtn.BorderSizePixel=0 stickBtn.Parent=otherPage
local stc=Instance.new("UICorner") stc.CornerRadius=UDim.new(0,6) stc.Parent=stickBtn
D.reg(stickBtn,"BackgroundColor3")
table.insert(uiRefs.labels, {obj=stickBtn, key="stick"})
stickBtn.MouseButton1Click:Connect(function()
 local target=getTarget() if not target or not target.Character then return end
 local mh=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") local th=target.Character:FindFirstChild("HumanoidRootPart")
 if mh and th then
  local bv=Instance.new("BodyPosition") bv.MaxForce=Vector3.new(1e5,1e5,1e5) bv.Parent=mh
  task.spawn(function() while bv.Parent do bv.Position=th.Position task.wait() end end)
  task.delay(3, function() if bv then bv:Destroy() end end)
 end
end)

-- Teleportタブ
local tpPage=Instance.new("Frame")
tpPage.Size=UDim2.new(1,0,1,0) tpPage.BackgroundTransparency=1 tpPage.Visible=false tpPage.Parent=D.content

local subBar=Instance.new("Frame")
subBar.Size=UDim2.new(1,-30,0,30) subBar.Position=UDim2.new(0,15,0,8) subBar.BackgroundTransparency=1 subBar.Parent=tpPage
local subTabs={}

local function createSub(name,x,w,fn)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(0,w,1,0) b.Position=UDim2.new(0,x,0,0) b.BackgroundTransparency=1 b.Text="LOADING" b.TextColor3=Color3.fromRGB(200,200,200) b.Font=Enum.Font.GothamMedium b.TextSize=11 b.BorderSizePixel=0 b.Parent=subBar
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=1 s.Parent=b
 D.reg(s,"Color") b.MouseButton1Click:Connect(fn)
 table.insert(subTabs,{button=b,stroke=s})
 table.insert(uiRefs.labels, {obj=b, key=name})
 return b
end

local playersSub=Instance.new("Frame")
playersSub.Size=UDim2.new(1,0,1,-46) playersSub.Position=UDim2.new(0,0,0,46) playersSub.BackgroundTransparency=1 playersSub.Parent=tpPage
local plist=Instance.new("ScrollingFrame")
plist.Size=UDim2.new(1,-30,1,-10) plist.Position=UDim2.new(0,15,0,5) plist.BackgroundTransparency=1 plist.BorderSizePixel=0 plist.ScrollBarThickness=4 plist.ScrollBarImageColor3=accent plist.CanvasSize=UDim2.new(0,0,0,0) plist.Parent=playersSub
local pll=Instance.new("UIListLayout") pll.Padding=UDim.new(0,5) pll.Parent=plist

local savedSub=Instance.new("Frame")
savedSub.Size=UDim2.new(1,0,1,-46) savedSub.Position=UDim2.new(0,0,0,46) savedSub.BackgroundTransparency=1 savedSub.Visible=false savedSub.Parent=tpPage

local function showSub(page,btn)
 playersSub.Visible=(page==playersSub) savedSub.Visible=(page==savedSub)
 for _,t in ipairs(subTabs) do
  if t.button==btn then t.button.BackgroundTransparency=0.8 t.button.TextColor3=D.accent t.stroke.Transparency=0.3
  else t.button.BackgroundTransparency=1 t.button.TextColor3=Color3.fromRGB(200,200,200) t.stroke.Transparency=1 end
 end
end
local pSub=createSub("players",0,100,function() showSub(playersSub,pSub) end)
local sSub=createSub("saved",108,100,function() showSub(savedSub,sSub) end)
showSub(playersSub,pSub)

local function tpTo(ch)
 local mc=plr.Character if not mc or not ch then return end
 local th=ch:FindFirstChild("HumanoidRootPart") local mh=mc:FindFirstChild("HumanoidRootPart")
 if th and mh then mh.CFrame=th.CFrame+Vector3.new(3,0,0) end
end
local function refresh()
 for _,c in ipairs(plist:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
 for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
  if p~=plr then
   local b=Instance.new("TextButton")
   b.Size=UDim2.new(1,-5,0,34) b.BackgroundTransparency=0.8 b.Text="  "..p.Name b.TextColor3=Color3.fromRGB(220,220,220) b.Font=Enum.Font.GothamMedium b.TextSize=12 b.TextXAlignment=Enum.TextXAlignment.Left b.BorderSizePixel=0 b.Parent=plist
   local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
   b.MouseButton1Click:Connect(function() if p.Character then tpTo(p.Character) end end)
  end
 end
 plist.CanvasSize=UDim2.new(0,0,0,pll.AbsoluteContentSize.Y)
end
game:GetService("Players").PlayerAdded:Connect(function() task.wait(0.5) refresh() end)
game:GetService("Players").PlayerRemoving:Connect(function() task.wait(0.5) refresh() end)
refresh()

local saveBtn=Instance.new("TextButton")
saveBtn.Size=UDim2.new(1,-30,0,32) saveBtn.Position=UDim2.new(0,15,0,5) saveBtn.BackgroundTransparency=0.5 saveBtn.BackgroundColor3=accent saveBtn.Text="Save Location" saveBtn.TextColor3=Color3.fromRGB(255,255,255) saveBtn.Font=Enum.Font.GothamBold saveBtn.TextSize=12 saveBtn.BorderSizePixel=0 saveBtn.Parent=savedSub
D.reg(saveBtn,"BackgroundColor3")
table.insert(uiRefs.labels, {obj=saveBtn, key="save_loc"})
local sbc=Instance.new("UICorner") sbc.CornerRadius=UDim.new(0,6) sbc.Parent=saveBtn

local savedList=Instance.new("ScrollingFrame")
savedList.Size=UDim2.new(1,-30,1,-50) savedList.Position=UDim2.new(0,15,0,45) savedList.BackgroundTransparency=1 savedList.BorderSizePixel=0 savedList.ScrollBarThickness=4 savedList.ScrollBarImageColor3=accent savedList.CanvasSize=UDim2.new(0,0,0,0) savedList.Parent=savedSub
local sl=Instance.new("UIListLayout") sl.Padding=UDim.new(0,5) sl.Parent=savedList
local locs={}
local function refreshSaved()
 for _,c in ipairs(savedList:GetChildren()) do if c:IsA("Frame") then c:Destroy() end end
 for i,d in ipairs(locs) do
  local r=Instance.new("Frame")
  r.Size=UDim2.new(1,-5,0,34) r.BackgroundTransparency=0.8 r.BorderSizePixel=0 r.Parent=savedList
  local rc=Instance.new("UICorner") rc.CornerRadius=UDim.new(0,6) rc.Parent=r
  local tb=Instance.new("TextButton")
  tb.Size=UDim2.new(1,-60,1,0) tb.BackgroundTransparency=1 tb.Text="  "..d.name tb.TextColor3=Color3.fromRGB(220,220,220) tb.Font=Enum.Font.GothamMedium tb.TextSize=12 tb.TextXAlignment=Enum.TextXAlignment.Left tb.Parent=r
  tb.MouseButton1Click:Connect(function() local h=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") if h then h.CFrame=d.cframe end end)
  local db=Instance.new("TextButton")
  db.Size=UDim2.new(0,50,0,24) db.Position=UDim2.new(1,-55,0.5,-12) db.BackgroundColor3=Color3.fromRGB(180,50,50) db.Text="Del" db.TextColor3=Color3.fromRGB(255,255,255) db.Font=Enum.Font.GothamBold db.TextSize=11 db.BorderSizePixel=0 db.Parent=r
  local dc=Instance.new("UICorner") dc.CornerRadius=UDim.new(0,4) dc.Parent=db
  db.MouseButton1Click:Connect(function() table.remove(locs,i) refreshSaved() end)
 end
 savedList.CanvasSize=UDim2.new(0,0,0,sl.AbsoluteContentSize.Y)
end
saveBtn.MouseButton1Click:Connect(function()
 local h=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
 if h then table.insert(locs,{name="Loc "..(#locs+1),cframe=h.CFrame}) refreshSaved() end
end)

-- Settingsタブ
local setPage=Instance.new("Frame")
setPage.Size=UDim2.new(1,0,1,0) setPage.BackgroundTransparency=1 setPage.Visible=false setPage.Parent=D.content
local tlab=Instance.new("TextLabel")
tlab.Size=UDim2.new(1,-30,0,22) tlab.Position=UDim2.new(0,15,0,12) tlab.BackgroundTransparency=1 tlab.Text="Accent Color" tlab.TextColor3=Color3.fromRGB(220,220,220) tlab.Font=Enum.Font.GothamMedium tlab.TextSize=11 tlab.TextXAlignment=Enum.TextXAlignment.Left tlab.Parent=setPage
table.insert(uiRefs.labels, {obj=tlab, key="accentcolor"})

local pal={{n="Blue",c=Color3.fromRGB(0,170,255)},{n="Purple",c=Color3.fromRGB(160,80,255)},{n="Red",c=Color3.fromRGB(255,60,60)},{n="Green",c=Color3.fromRGB(0,220,120)},{n="Orange",c=Color3.fromRGB(255,150,0)},{n="Pink",c=Color3.fromRGB(255,100,180)}}
for i,d in ipairs(pal) do
 local r=math.floor((i-1)/3) local col=(i-1)%3
 local sw=Instance.new("TextButton")
 sw.Size=UDim2.new(0,42,0,42) sw.Position=UDim2.new(0,15+col*52,0,45+r*52) sw.BackgroundColor3=d.c sw.Text="" sw.BorderSizePixel=0 sw.Parent=setPage
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=sw
 sw.MouseButton1Click:Connect(function()
  D.accent=d.c
  for _,it in ipairs(D.themeEls) do if it.element and it.element.Parent then it.element[it.property]=d.c end end
  D.ms.Color=d.c D.title.TextColor3=d.c
  for _,t in ipairs(tabBtns) do t.stroke.Color=d.c end
  for _,t in ipairs(subTabs) do t.stroke.Color=d.c end
  if D.avatarStroke then D.avatarStroke.Color=d.c end
 end)
end

local langLabel=Instance.new("TextLabel")
langLabel.Size=UDim2.new(1,-30,0,22) langLabel.Position=UDim2.new(0,15,0,165) langLabel.BackgroundTransparency=1 langLabel.Text="Language" langLabel.TextColor3=Color3.fromRGB(220,220,220) langLabel.Font=Enum.Font.GothamMedium langLabel.TextSize=11 langLabel.TextXAlignment=Enum.TextXAlignment.Left langLabel.Parent=setPage
table.insert(uiRefs.labels, {obj=langLabel, key="language"})

local function createLangBtn(txt,x)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(0,80,0,32) b.Position=UDim2.new(0,x,0,195) b.BackgroundTransparency=0.5 b.BackgroundColor3=Color3.fromRGB(30,30,45) b.Text=txt b.TextColor3=Color3.fromRGB(200,200,200) b.Font=Enum.Font.GothamBold b.TextSize=12 b.BorderSizePixel=0 b.Parent=setPage
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
 return b
end
local enBtn=createLangBtn("English",15)
local jaBtn=createLangBtn("Japanese",105)

local function updateLang(newLang)
 D.lang=newLang
 for _,t in ipairs(uiRefs.tabs) do t.obj.Text=D.T(t.key) end
 for _,t in ipairs(uiRefs.labels) do t.obj.Text=D.T(t.key) end
 D.cLabel.Text = D.T("confirm_close")
 D.yesBtn.Text = D.T("yes")
 D.noBtn.Text = D.T("no")
 if D.lang=="EN" then
  enBtn.BackgroundColor3=accent enBtn.TextColor3=Color3.fromRGB(255,255,255) jaBtn.BackgroundColor3=Color3.fromRGB(30,30,45) jaBtn.TextColor3=Color3.fromRGB(200,200,200)
 else
  jaBtn.BackgroundColor3=accent jaBtn.TextColor3=Color3.fromRGB(255,255,255) enBtn.BackgroundColor3=Color3.fromRGB(30,30,45) enBtn.TextColor3=Color3.fromRGB(200,200,200)
 end
end
enBtn.MouseButton1Click:Connect(function() updateLang("EN") end)
jaBtn.MouseButton1Click:Connect(function() updateLang("JA") end)

local pages={playerPage,itemPage,otherPage,tpPage,setPage}
local function showPage(page,btn)
 for _,p in ipairs(pages) do p.Visible=false end
 page.Visible=true
 for _,t in ipairs(tabBtns) do
  if t.button==btn then t.button.BackgroundTransparency=0.8 t.button.TextColor3=D.accent t.stroke.Transparency=0.3
  else t.button.BackgroundTransparency=1 t.button.TextColor3=Color3.fromRGB(200,200,200) t.stroke.Transparency=1 end
 end
end

local pTab=createTab("player",5,function() showPage(playerPage,pTab) end)
local iTab=createTab("item",45,function() showPage(itemPage,iTab) end)
local oTab=createTab("other",85,function() showPage(otherPage,oTab) end)
local tTab=createTab("teleport",125,function() showPage(tpPage,tTab) end)
local sTab=createTab("settings",165,function() showPage(setPage,sTab) end)
showPage(playerPage,pTab)
updateLang("EN")

local function apply(ch)
 local h=ch:WaitForChild("Humanoid",5)
 if h then h.WalkSpeed=D.speed h.JumpPower=D.jump h.UseJumpPower=true end
end
plr.CharacterAdded:Connect(apply)
if plr.Character then apply(plr.Character) end

print("Part 2 OK")
