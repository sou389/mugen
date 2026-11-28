local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local plr = Players.LocalPlayer
local pg = plr:WaitForChild("PlayerGui")
if pg:FindFirstChild("DeltaUI") then pg.DeltaUI:Destroy() end

local accent = Color3.fromRGB(0,170,255)
_G.D = {accent=accent, speed=16, jump=50, plr=plr}

local gui = Instance.new("ScreenGui")
gui.Name="DeltaUI" gui.ResetOnSpawn=false gui.Parent=pg

-- メインUI
local main = Instance.new("Frame")
main.Size=UDim2.new(0,520,0,340) main.Position=UDim2.new(0.5,-260,0.5,-170)
main.BackgroundColor3=Color3.fromRGB(20,20,30) main.BackgroundTransparency=0.3
main.BorderSizePixel=0 main.Parent=gui
local mc=Instance.new("UICorner") mc.CornerRadius=UDim.new(0,12) mc.Parent=main
local ms=Instance.new("UIStroke") ms.Color=accent ms.Thickness=2 ms.Transparency=0.3 ms.Parent=main

-- タイトルバー
local tb=Instance.new("Frame")
tb.Size=UDim2.new(1,0,0,38) tb.BackgroundColor3=Color3.fromRGB(30,30,50)
tb.BackgroundTransparency=0.5 tb.BorderSizePixel=0 tb.Parent=main
local tbc=Instance.new("UICorner") tbc.CornerRadius=UDim.new(0,12) tbc.Parent=tb

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-90,1,0) title.Position=UDim2.new(0,14,0,0)
title.BackgroundTransparency=1 title.Text="DELTA HUB" title.TextColor3=accent
title.Font=Enum.Font.GothamBold title.TextSize=15 title.TextXAlignment=Enum.TextXAlignment.Left title.Parent=tb

local close=Instance.new("TextButton")
close.Size=UDim2.new(0,26,0,26) close.Position=UDim2.new(1,-34,0,6)
close.BackgroundColor3=Color3.fromRGB(200,50,50) close.Text="X"
close.TextColor3=Color3.fromRGB(255,255,255) close.Font=Enum.Font.GothamBold
close.TextSize=12 close.BorderSizePixel=0 close.Parent=tb
local cc=Instance.new("UICorner") cc.CornerRadius=UDim.new(0,8) cc.Parent=close
close.MouseButton1Click:Connect(function() gui:Destroy() end)

-- ドラッグ処理
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

_G.D.gui=gui _G.D.main=main _G.D.side=side _G.D.content=content _G.D.ms=ms
print("Part 1 OK")
local D=_G.D
if not D then return end
local plr=D.plr local UIS=game:GetService("UserInputService") local RS=game:GetService("RunService") local accent=D.accent

local function makeSlider(parent,name,y,mn,mx,dv,cb)
 local cont=Instance.new("Frame")
 cont.Size=UDim2.new(1,-24,0,60) cont.Position=UDim2.new(0,12,0,y) cont.BackgroundTransparency=1 cont.Parent=parent
 local lbl=Instance.new("TextLabel")
 lbl.Size=UDim2.new(1,-56,0,20) lbl.BackgroundTransparency=1 lbl.Text=name lbl.TextColor3=Color3.fromRGB(220,220,220) lbl.Font=Enum.Font.GothamMedium lbl.TextSize=11 lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Parent=cont
 local vl=Instance.new("TextLabel")
 vl.Size=UDim2.new(0,50,0,20) vl.Position=UDim2.new(1,-50,0,0) vl.BackgroundTransparency=1 vl.Text=string.format("%.0f",dv) vl.TextColor3=accent vl.Font=Enum.Font.GothamBold vl.TextSize=11 vl.TextXAlignment=Enum.TextXAlignment.Right vl.Parent=cont
 local bg=Instance.new("Frame")
 bg.Size=UDim2.new(1,0,0,6) bg.Position=UDim2.new(0,0,0,30) bg.BackgroundColor3=Color3.fromRGB(50,50,70) bg.BorderSizePixel=0 bg.Parent=cont
 local bgc=Instance.new("UICorner") bgc.CornerRadius=UDim.new(1,0) bgc.Parent=bg
 local fill=Instance.new("Frame")
 fill.Size=UDim2.new((dv-mn)/(mx-mn),0,1,0) fill.BackgroundColor3=accent fill.BorderSizePixel=0 fill.Parent=bg
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

local function makeToggle(parent,name,y,cb)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(1,-24,0,32) b.Position=UDim2.new(0,12,0,y) b.BackgroundColor3=Color3.fromRGB(30,30,45) b.Text="  "..name
 b.TextColor3=Color3.fromRGB(220,220,220) b.Font=Enum.Font.GothamMedium b.TextSize=11 b.TextXAlignment=Enum.TextXAlignment.Left b.BorderSizePixel=0 b.Parent=parent
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
 local st=false
 b.MouseButton1Click:Connect(function()
  st=not st
  if st then b.BackgroundColor3=D.accent else b.BackgroundColor3=Color3.fromRGB(30,30,45) end
  cb(st)
 end)
end

-- Playerタブ
local playerPage=Instance.new("ScrollingFrame")
playerPage.Size=UDim2.new(1,0,1,0) playerPage.BackgroundTransparency=1 playerPage.BorderSizePixel=0 playerPage.ScrollBarThickness=4 playerPage.CanvasSize=UDim2.new(0,0,0,0) playerPage.Parent=D.content

makeSlider(playerPage,"Speed",12,1,500,16,function(v) D.speed=v local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if h then h.WalkSpeed=v end end)
makeSlider(playerPage,"Jump",82,1,500,50,function(v) D.jump=v local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if h then h.JumpPower=v h.UseJumpPower=true end end)

local infJump=false
makeToggle(playerPage,"Infinite Jump",152,function(st) infJump=st end)
UIS.JumpRequest:Connect(function() if infJump then local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end end)

makeToggle(playerPage,"Wall Walk",190,function(st)
 local ch=plr.Character if not ch then return end local h=ch:FindFirstChildOfClass("Humanoid") if not h then return end
 if st then h.PlatformStand=true else h.PlatformStand=false end
end)

local wallClip=false
makeToggle(playerPage,"Wall Clip",228,function(st)
 wallClip=st local ch=plr.Character if not ch then return end
 if not st then for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=true end end end
end)
RS.Stepped:Connect(function() if wallClip then local ch=plr.Character if ch then for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.CanCollide=false end end end end end)

local flyActive=false local bv,bg
makeToggle(playerPage,"Fly",266,function(st)
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

makeToggle(playerPage,"Respawn",304,function(st) if st then local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid") if h then h.Health=0 end end end)
makeToggle(playerPage,"Leave Game",342,function(st) if st then plr:Kick("Left") end end)

-- Itemタブ
local itemPage=Instance.new("ScrollingFrame")
itemPage.Size=UDim2.new(1,0,1,0) itemPage.BackgroundTransparency=1 itemPage.BorderSizePixel=0 itemPage.ScrollBarThickness=4 itemPage.CanvasSize=UDim2.new(0,0,0,0) itemPage.Visible=false itemPage.Parent=D.content

local spinBox=Instance.new("TextBox")
spinBox.Size=UDim2.new(1,-24,0,32) spinBox.Position=UDim2.new(0,12,0,12) spinBox.BackgroundColor3=Color3.fromRGB(30,30,45) spinBox.PlaceholderText="Spin Speed..." spinBox.Text=""
spinBox.TextColor3=Color3.fromRGB(255,255,255) spinBox.Font=Enum.Font.GothamMedium spinBox.TextSize=11 spinBox.BorderSizePixel=0 spinBox.Parent=itemPage
local sbc=Instance.new("UICorner") sbc.CornerRadius=UDim.new(0,6) sbc.Parent=spinBox

local spinAct=false
makeToggle(itemPage,"Toggle Spin",50,function(st)
 spinAct=st local ch=plr.Character if not ch then return end local r=ch:FindFirstChild("HumanoidRootPart") if not r then return end
 if st then local b = Instance.new("BodyAngularVelocity") b.AngularVelocity=Vector3.new(0,tonumber(spinBox.Text) or 50,0) b.MaxTorque=Vector3.new(1e5,1e5,1e5) b.Name="SpinBV" b.Parent=r
 else local b=r:FindFirstChild("SpinBV") if b then b:Destroy() end end
end)

makeToggle(itemPage,"Transparent",88,function(st)
 local ch=plr.Character if not ch then return end
 for _,p in ipairs(ch:GetDescendants()) do if p:IsA("BasePart") then p.Transparency=st and 1 or 0 end end
end)

_G.D.playerPage=playerPage _G.D.itemPage=itemPage
print("Part 2 OK")
local D=_G.D
if not D then return end
local plr=D.plr local accent=D.accent local UIS=game:GetService("UserInputService")

-- Otherタブ
local otherPage=Instance.new("ScrollingFrame")
otherPage.Size=UDim2.new(1,0,1,0) otherPage.BackgroundTransparency=1 otherPage.BorderSizePixel=0 otherPage.ScrollBarThickness=4 otherPage.CanvasSize=UDim2.new(0,0,0,0) otherPage.Visible=false otherPage.Parent=D.content

local idBox=Instance.new("TextBox")
idBox.Size=UDim2.new(1,-24,0,32) idBox.Position=UDim2.new(0,12,0,12) idBox.BackgroundColor3=Color3.fromRGB(30,30,45) idBox.PlaceholderText="Target ID or Name..."
idBox.TextColor3=Color3.fromRGB(255,255,255) idBox.Font=Enum.Font.GothamMedium idBox.TextSize=11 idBox.BorderSizePixel=0 idBox.Parent=otherPage
local idc=Instance.new("UICorner") idc.CornerRadius=UDim.new(0,6) idc.Parent=idBox

local function getT()
 for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
  if tostring(p.UserId)==idBox.Text or p.Name:lower():match(idBox.Text:lower()) then return p end
 end
end

local tpBtn=Instance.new("TextButton")
tpBtn.Size=UDim2.new(1,-24,0,32) tpBtn.Position=UDim2.new(0,12,0,50) tpBtn.BackgroundColor3=accent tpBtn.Text="Teleport to ID"
tpBtn.TextColor3=Color3.fromRGB(255,255,255) tpBtn.Font=Enum.Font.GothamBold tpBtn.TextSize=11 tpBtn.BorderSizePixel=0 tpBtn.Parent=otherPage
local tpc=Instance.new("UICorner") tpc.CornerRadius=UDim.new(0,6) tpc.Parent=tpBtn
tpBtn.MouseButton1Click:Connect(function() local t=getT() if t and t.Character then local mh=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") local th=t.Character:FindFirstChild("HumanoidRootPart") if mh and th then mh.CFrame=th.CFrame+Vector3.new(3,0,0) end end end)

local stickBtn=Instance.new("TextButton")
stickBtn.Size=UDim2.new(1,-24,0,32) stickBtn.Position=UDim2.new(0,12,0,88) stickBtn.BackgroundColor3=accent stickBtn.Text="Stick to ID"
stickBtn.TextColor3=Color3.fromRGB(255,255,255) stickBtn.Font=Enum.Font.GothamBold stickBtn.TextSize=11 stickBtn.BorderSizePixel=0 stickBtn.Parent=otherPage
local stc=Instance.new("UICorner") stc.CornerRadius=UDim.new(0,6) stc.Parent=stickBtn
stickBtn.MouseButton1Click:Connect(function()
 local t=getT() if t and t.Character then
  local mh=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") local th=t.Character:FindFirstChild("HumanoidRootPart")
  if mh and th then local bp=Instance.new("BodyPosition",mh) bp.MaxForce=Vector3.new(1e5,1e5,1e5) task.spawn(function() while bp.Parent do bp.Position=th.Position task.wait() end end) task.delay(3,function() bp:Destroy() end) end
 end
end)

-- Teleportタブ
local tpPage=Instance.new("Frame")
tpPage.Size=UDim2.new(1,0,1,0) tpPage.BackgroundTransparency=1 tpPage.Visible=false tpPage.Parent=D.content
local plist=Instance.new("ScrollingFrame")
plist.Size=UDim2.new(1,-24,1,-10) plist.Position=UDim2.new(0,12,0,5) plist.BackgroundTransparency=1 plist.BorderSizePixel=0 plist.ScrollBarThickness=4 plist.CanvasSize=UDim2.new(0,0,0,0) plist.Parent=tpPage
local pll=Instance.new("UIListLayout") pll.Padding=UDim.new(0,5) pll.Parent=plist

local function tpTo(c)
 if c and plr.Character then local mh=plr.Character:FindFirstChild("HumanoidRootPart") local th=c:FindFirstChild("HumanoidRootPart") if mh and th then mh.CFrame=th.CFrame+Vector3.new(3,0,0) end end
end

local function refresh()
 for _,c in ipairs(plist:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
 for _,p in ipairs(game:GetService("Players"):GetPlayers()) do
  if p~=plr then
   local b=Instance.new("TextButton")
   b.Size=UDim2.new(1,-5,0,34) b.BackgroundColor3=Color3.fromRGB(30,30,45) b.Text="  "..p.Name b.TextColor3=Color3.fromRGB(220,220,220) b.Font=Enum.Font.GothamMedium b.TextSize=12 b.TextXAlignment=Enum.TextXAlignment.Left b.BorderSizePixel=0 b.Parent=plist
   local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
   b.MouseButton1Click:Connect(function() if p.Character then tpTo(p.Character) end end)
  end
 end
 plist.CanvasSize=UDim2.new(0,0,0,pll.AbsoluteContentSize.Y)
end
game:GetService("Players").PlayerAdded:Connect(function() task.wait(0.5) refresh() end)
game:GetService("Players").PlayerRemoving:Connect(function() task.wait(0.5) refresh() end)
refresh()

-- Settingsタブ
local setPage=Instance.new("Frame")
setPage.Size=UDim2.new(1,0,1,0) setPage.BackgroundTransparency=1 setPage.Visible=false setPage.Parent=D.content
local pal={
 {n="Blue",c=Color3.fromRGB(0,170,255)},{n="Purple",c=Color3.fromRGB(160,80,255)},
 {n="Red",c=Color3.fromRGB(255,60,60)},{n="Green",c=Color3.fromRGB(0,220,120)},
 {n="Orange",c=Color3.fromRGB(255,150,0)},{n="Pink",c=Color3.fromRGB(255,100,180)},
}
for i,d in ipairs(pal) do
 local r=math.floor((i-1)/3) local col=(i-1)%3
 local sw=Instance.new("TextButton")
 sw.Size=UDim2.new(0,42,0,42) sw.Position=UDim2.new(0,15+col*52,0,15+r*52) sw.BackgroundColor3=d.c sw.Text="" sw.BorderSizePixel=0 sw.Parent=setPage
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=sw
 sw.MouseButton1Click:Connect(function()
  D.accent=d.c D.ms.Color=d.c
  for _,v in ipairs(D.content:GetDescendants()) do
   if v:IsA("Frame") and v.BackgroundColor3==Color3.fromRGB(30,30,45) then v.BackgroundColor3=Color3.fromRGB(30,30,45) end
  end
 end)
end

-- タブボタン生成と切り替え
local pages={D.playerPage, D.itemPage, otherPage, tpPage, setPage}
local tabs={"Player","Item","Other","Teleport","Settings"}
local tabBtns={}

for i,name in ipairs(tabs) do
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(1,-20,0,34) b.Position=UDim2.new(0,10,0,5+(i-1)*40) b.BackgroundTransparency=1 b.Text=name
 b.TextColor3=Color3.fromRGB(200,200,200) b.Font=Enum.Font.GothamMedium b.TextSize=11 b.BorderSizePixel=0 b.Parent=D.side
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=b
 b.MouseButton1Click:Connect(function()
  for j,p in ipairs(pages) do p.Visible=(j==i) end
  for j,t in ipairs(tabBtns) do
   if j==i then t.BackgroundTransparency=0.8 t.TextColor3=accent else t.BackgroundTransparency=1 t.TextColor3=Color3.fromRGB(200,200,200) end
  end
 end)
 table.insert(tabBtns,b)
 if i==1 then b.BackgroundTransparency=0.8 b.TextColor3=accent end
end

-- アバター
local av=Instance.new("ImageLabel")
av.Size=UDim2.new(0,46,0,46) av.Position=UDim2.new(0,12,1,-58) av.BackgroundTransparency=1 av.Image=string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150",plr.UserId) av.Parent=D.side
local avc=Instance.new("UICorner") avc.CornerRadius=UDim.new(1,0) avc.Parent=av

-- リスポーン適用
local function apply(ch)
 local h=ch:WaitForChild("Humanoid",5)
 if h then h.WalkSpeed=D.speed h.JumpPower=D.jump h.UseJumpPower=true end
end
plr.CharacterAdded:Connect(apply)
if plr.Character then apply(plr.Character) end

print("Part 3 OK")
