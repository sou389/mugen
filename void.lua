local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local plr = Players.LocalPlayer
local pg = plr:WaitForChild("PlayerGui")
if pg:FindFirstChild("DeltaUI") then pg.DeltaUI:Destroy() end

local accent = Color3.fromRGB(0,170,255)
local themeEls = {}
local function reg(e,p) table.insert(themeEls,{element=e,property=p}) end
_G.D = {accent=accent, themeEls=themeEls, reg=reg, speed=16, jump=50}

local gui = Instance.new("ScreenGui")
gui.Name="DeltaUI" gui.ResetOnSpawn=false gui.Parent=pg

local main = Instance.new("Frame")
main.Size=UDim2.new(0,520,0,340)
main.Position=UDim2.new(0.5,-260,0.5,-170)
main.BackgroundColor3=Color3.fromRGB(20,20,30)
main.BorderSizePixel=0 main.Parent=gui
local mc=Instance.new("UICorner") mc.CornerRadius=UDim.new(0,12) mc.Parent=main
local ms=Instance.new("UIStroke") ms.Color=accent ms.Thickness=2 ms.Transparency=0.3 ms.Parent=main

local tb=Instance.new("Frame")
tb.Size=UDim2.new(1,0,0,38) tb.BackgroundColor3=Color3.fromRGB(30,30,50)
tb.BorderSizePixel=0 tb.Parent=main
local tbc=Instance.new("UICorner") tbc.CornerRadius=UDim.new(0,12) tbc.Parent=tb

local title=Instance.new("TextLabel")
title.Size=UDim2.new(1,-50,1,0) title.Position=UDim2.new(0,14,0,0)
title.BackgroundTransparency=1 title.Text="DELTA HUB" title.TextColor3=accent
title.Font=Enum.Font.GothamBold title.TextSize=15
title.TextXAlignment=Enum.TextXAlignment.Left title.Parent=tb

local close=Instance.new("TextButton")
close.Size=UDim2.new(0,26,0,26) close.Position=UDim2.new(1,-34,0,6)
close.BackgroundColor3=Color3.fromRGB(200,50,50) close.Text="X"
close.TextColor3=Color3.fromRGB(255,255,255) close.Font=Enum.Font.GothamBold
close.TextSize=12 close.BorderSizePixel=0 close.Parent=tb
local cc=Instance.new("UICorner") cc.CornerRadius=UDim.new(0,8) cc.Parent=close
close.MouseButton1Click:Connect(function() gui:Destroy() end)

local dragging=false
local dragStart=nil
local startPos=nil
local tPos=main.Position
local cPos=main.Position
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
side.BackgroundColor3=Color3.fromRGB(18,18,28) side.BorderSizePixel=0 side.Parent=main
local sc=Instance.new("UICorner") sc.CornerRadius=UDim.new(0,12) sc.Parent=side

local content=Instance.new("Frame")
content.Size=UDim2.new(1,-110,1,-38) content.Position=UDim2.new(0,110,0,38)
content.BackgroundTransparency=1 content.Parent=main

_G.D.gui=gui _G.D.main=main _G.D.side=side _G.D.content=content
_G.D.title=title _G.D.ms=ms _G.D.plr=plr

print("Part 1 OK")
local D=_G.D
if not D then warn("Part 1 を先に！") return end
local plr=D.plr
local UIS=game:GetService("UserInputService")
local RS=game:GetService("RunService")
local accent=D.accent
local reg=D.reg

local tabBtns={}
local function createTab(name,y,fn)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(1,-20,0,42) b.Position=UDim2.new(0,10,0,y)
 b.BackgroundColor3=Color3.fromRGB(30,30,45) b.Text=name
 b.TextColor3=Color3.fromRGB(200,200,200) b.Font=Enum.Font.GothamMedium
 b.TextSize=12 b.BorderSizePixel=0 b.Parent=D.side
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=b
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=1 s.Parent=b
 b.MouseButton1Click:Connect(fn)
 table.insert(tabBtns,{button=b,stroke=s})
 return b
end

local function createSlider(parent,name,y,mn,mx,dv,cb)
 local cont=Instance.new("Frame")
 cont.Size=UDim2.new(1,-24,0,66) cont.Position=UDim2.new(0,12,0,y)
 cont.BackgroundTransparency=1 cont.Parent=parent
 local lbl=Instance.new("TextLabel")
 lbl.Size=UDim2.new(1,-56,0,20) lbl.BackgroundTransparency=1
 lbl.Text=name lbl.TextColor3=Color3.fromRGB(220,220,220)
 lbl.Font=Enum.Font.GothamMedium lbl.TextSize=11
 lbl.TextXAlignment=Enum.TextXAlignment.Left lbl.Parent=cont
 local vl=Instance.new("TextLabel")
 vl.Size=UDim2.new(0,50,0,20) vl.Position=UDim2.new(1,-50,0,0)
 vl.BackgroundTransparency=1 vl.Text=string.format("%.0f",dv)
 vl.TextColor3=accent vl.Font=Enum.Font.GothamBold vl.TextSize=11
 vl.TextXAlignment=Enum.TextXAlignment.Right vl.Parent=cont
 reg(vl,"TextColor3")
 local bg=Instance.new("Frame")
 bg.Size=UDim2.new(1,0,0,10) bg.Position=UDim2.new(0,0,0,36)
 bg.BackgroundColor3=Color3.fromRGB(50,50,70) bg.BorderSizePixel=0 bg.Parent=cont
 local bgc=Instance.new("UICorner") bgc.CornerRadius=UDim.new(1,0) bgc.Parent=bg
 local fill=Instance.new("Frame")
 fill.Size=UDim2.new((dv-mn)/(mx-mn),0,1,0) fill.BackgroundColor3=accent
 fill.BorderSizePixel=0 fill.Parent=bg
 reg(fill,"BackgroundColor3")
 local fc=Instance.new("UICorner") fc.CornerRadius=UDim.new(1,0) fc.Parent=fill
 local knob=Instance.new("Frame")
 knob.Size=UDim2.new(0,22,0,22) knob.Position=UDim2.new((dv-mn)/(mx-mn),-11,0.5,-11)
 knob.BackgroundColor3=Color3.fromRGB(255,255,255) knob.BorderSizePixel=0 knob.Parent=bg
 local kc=Instance.new("UICorner") kc.CornerRadius=UDim.new(1,0) kc.Parent=knob
 local ks=Instance.new("UIStroke") ks.Color=accent ks.Thickness=2 ks.Parent=knob
 reg(ks,"Color")
 local sd=false
 local trx=(dv-mn)/(mx-mn)
 local crx=trx
 local function crxof(x) return math.clamp((x-bg.AbsolutePosition.X)/bg.AbsoluteSize.X,0,1) end
 bg.InputBegan:Connect(function(i)
  if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
   sd=true trx=crxof(i.Position.X)
  end
 end)
 UIS.InputChanged:Connect(function(i)
  if sd and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
   trx=crxof(i.Position.X)
  end
 end)
 UIS.InputEnded:Connect(function(i)
  if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then sd=false end
 end)
 RS.RenderStepped:Connect(function(dt)
  if not sd then return end
  crx=crx+(trx-crx)*math.clamp(dt*22,0,1)
  fill.Size=UDim2.new(crx,0,1,0)
  knob.Position=UDim2.new(crx,-11,0.5,-11)
  local v=mn+(mx-mn)*crx
  vl.Text=string.format("%.0f",v)
  cb(v)
 end)
 return cont
end

local function createToggle(parent,name,y,cb,autoOff)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(1,-24,0,32) b.Position=UDim2.new(0,12,0,y)
 b.BackgroundColor3=Color3.fromRGB(30,30,45) b.Text=name
 b.TextColor3=Color3.fromRGB(220,220,220) b.Font=Enum.Font.GothamMedium
 b.TextSize=11 b.TextXAlignment=Enum.TextXAlignment.Left
 b.BorderSizePixel=0 b.Parent=parent
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=0.6 s.Parent=b
 reg(s,"Color")
 local st=false
 local busy=false
 local ind=Instance.new("Frame")
 ind.Size=UDim2.new(0,8,0,8) ind.Position=UDim2.new(1,-18,0.5,-4)
 ind.BackgroundColor3=Color3.fromRGB(100,100,100) ind.BorderSizePixel=0 ind.Parent=b
 local ic=Instance.new("UICorner") ic.CornerRadius=UDim.new(1,0) ic.Parent=ind
 local function set(v)
  st=v ind.BackgroundColor3=st and D.accent or Color3.fromRGB(100,100,100) cb(st)
 end
 b.MouseButton1Click:Connect(function()
  if autoOff then
   if busy then return end
   busy=true set(true) task.wait(autoOff) set(false) busy=false
  else set(not st) end
 end)
 return b
end

local playerPage=Instance.new("ScrollingFrame")
playerPage.Size=UDim2.new(1,0,1,0) playerPage.BackgroundTransparency=1
playerPage.BorderSizePixel=0 playerPage.ScrollBarThickness=4
playerPage.ScrollBarImageColor3=accent playerPage.CanvasSize=UDim2.new(0,0,0,0)
playerPage.Parent=D.content
reg(playerPage,"ScrollBarImageColor3")
local pl=Instance.new("UIListLayout") pl.Padding=UDim.new(0,4) pl.Parent=playerPage

createSlider(playerPage,"Speed",12,1,500,16,function(v)
 D.speed=v local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
 if h then h.WalkSpeed=v end
end)
createSlider(playerPage,"Jump Power",82,1,500,50,function(v)
 D.jump=v local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
 if h then h.JumpPower=v h.UseJumpPower=true end
end)
createToggle(playerPage,"Wall Walk",152,function(st)
 local ch=plr.Character if not ch then return end
 local h=ch:FindFirstChildOfClass("Humanoid") if not h then return end
 h.PlatformStand=st
 if st then local r=ch:FindFirstChild("HumanoidRootPart")
  if r then r.CFrame=r.CFrame*CFrame.Angles(math.rad(-90),0,0) end end
end)
createToggle(playerPage,"Wall Clip",190,function(st)
 local ch=plr.Character if not ch then return end
 for _,p in ipairs(ch:GetDescendants()) do
  if p:IsA("BasePart") and p.CanCollide then p.CanCollide=not st end
 end
 if st then RS.Stepped:Connect(function()
  local c=plr.Character if not c then return end
  for _,p in ipairs(c:GetDescendants()) do
   if p:IsA("BasePart") then p.CanCollide=false end end
 end) end
end)
createToggle(playerPage,"Respawn",228,function(st)
 if st then local h=plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
  if h then h.Health=0 end end
end,1)
createToggle(playerPage,"Leave Game",266,function(st)
 if st then plr:Kick("Left via Delta Hub") end
end)

pl:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
 playerPage.CanvasSize=UDim2.new(0,0,0,pl.AbsoluteContentSize.Y+12)
end)

local tpPage=Instance.new("Frame")
tpPage.Size=UDim2.new(1,0,1,0) tpPage.BackgroundTransparency=1
tpPage.Visible=false tpPage.Parent=D.content

local subBar=Instance.new("Frame")
subBar.Size=UDim2.new(1,-30,0,30) subBar.Position=UDim2.new(0,15,0,8)
subBar.BackgroundTransparency=1 subBar.Parent=tpPage
local subTabs={}
local function createSub(name,x,w,fn)
 local b=Instance.new("TextButton")
 b.Size=UDim2.new(0,w,1,0) b.Position=UDim2.new(0,x,0,0)
 b.BackgroundColor3=Color3.fromRGB(30,30,45) b.Text=name
 b.TextColor3=Color3.fromRGB(200,200,200) b.Font=Enum.Font.GothamMedium
 b.TextSize=11 b.BorderSizePixel=0 b.Parent=subBar
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
 local s=Instance.new("UIStroke") s.Color=accent s.Thickness=1 s.Transparency=1 s.Parent=b
 reg(s,"Color")
 b.MouseButton1Click:Connect(fn)
 table.insert(subTabs,{button=b,stroke=s})
 return b
end

local playersSub=Instance.new("Frame")
playersSub.Size=UDim2.new(1,0,1,-46) playersSub.Position=UDim2.new(0,0,0,46)
playersSub.BackgroundTransparency=1 playersSub.Parent=tpPage
local plist=Instance.new("ScrollingFrame")
plist.Size=UDim2.new(1,-30,1,-10) plist.Position=UDim2.new(0,15,0,5)
plist.BackgroundTransparency=1 plist.BorderSizePixel=0
plist.ScrollBarThickness=4 plist.ScrollBarImageColor3=accent
plist.CanvasSize=UDim2.new(0,0,0,0) plist.Parent=playersSub
reg(plist,"ScrollBarImageColor3")
local pll=Instance.new("UIListLayout") pll.Padding=UDim.new(0,5) pll.Parent=plist

local savedSub=Instance.new("Frame")
savedSub.Size=UDim2.new(1,0,1,-46) savedSub.Position=UDim2.new(0,0,0,46)
savedSub.BackgroundTransparency=1 savedSub.Visible=false savedSub.Parent=tpPage

local setPage=Instance.new("Frame")
setPage.Size=UDim2.new(1,0,1,0) setPage.BackgroundTransparency=1
setPage.Visible=false setPage.Parent=D.content
local tlab=Instance.new("TextLabel")
tlab.Size=UDim2.new(1,-30,0,22) tlab.Position=UDim2.new(0,15,0,12)
tlab.BackgroundTransparency=1 tlab.Text="Accent Color"
tlab.TextColor3=Color3.fromRGB(220,220,220) tlab.Font=Enum.Font.GothamMedium
tlab.TextSize=11 tlab.TextXAlignment=Enum.TextXAlignment.Left tlab.Parent=setPage

local pal={
 {n="Blue",c=Color3.fromRGB(0,170,255)},
 {n="Purple",c=Color3.fromRGB(160,80,255)},
 {n="Red",c=Color3.fromRGB(255,60,60)},
 {n="Green",c=Color3.fromRGB(0,220,120)},
 {n="Orange",c=Color3.fromRGB(255,150,0)},
 {n="Pink",c=Color3.fromRGB(255,100,180)},
}
for i,d in ipairs(pal) do
 local r=math.floor((i-1)/3) local col=(i-1)%3
 local sw=Instance.new("TextButton")
 sw.Size=UDim2.new(0,42,0,42)
 sw.Position=UDim2.new(0,15+col*52,0,45+r*52)
 sw.BackgroundColor3=d.c sw.Text="" sw.BorderSizePixel=0 sw.Parent=setPage
 local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,8) c.Parent=sw
 local s=Instance.new("UIStroke") s.Color=Color3.fromRGB(255,255,255)
 s.Thickness=2 s.Transparency=1 s.Parent=sw
 sw.MouseButton1Click:Connect(function()
  D.accent=d.c
  for _,it in ipairs(D.themeEls) do
   if it.element and it.element.Parent then it.element[it.property]=d.c end
  end
  D.ms.Color=d.c D.title.TextColor3=d.c
  for _,t in ipairs(tabBtns) do t.stroke.Color=d.c end
  for _,t in ipairs(subTabs) do t.stroke.Color=d.c end
  if D.avatarStroke then D.avatarStroke.Color=d.c end
  for _,o in ipairs(setPage:GetChildren()) do
   if o:IsA("TextButton") and o:FindFirstChildOfClass("UIStroke") then
    o:FindFirstChildOfClass("UIStroke").Transparency=1 end
  end
  s.Transparency=0
 end)
end

local pages={playerPage,tpPage,setPage}
local function showPage(page,btn)
 for _,p in ipairs(pages) do p.Visible=false end
 page.Visible=true
 for _,t in ipairs(tabBtns) do
  if t.button==btn then
   t.button.BackgroundColor3=Color3.fromRGB(40,40,60)
   t.button.TextColor3=D.accent t.stroke.Transparency=0.3
  else
   t.button.BackgroundColor3=Color3.fromRGB(30,30,45)
   t.button.TextColor3=Color3.fromRGB(200,200,200) t.stroke.Transparency=1
  end
 end
end

local pTab=createTab("Player",15,function() showPage(playerPage,pTab) end)
local tTab=createTab("Teleport",65,function() showPage(tpPage,tTab) end)
local sTab=createTab("Settings",115,function() showPage(setPage,sTab) end)
showPage(playerPage,pTab)

local av=Instance.new("Frame")
av.Size=UDim2.new(0,46,0,46) av.Position=UDim2.new(0,12,1,-58)
av.BackgroundColor3=Color3.fromRGB(30,30,50) av.BorderSizePixel=0 av.Parent=D.side
local avc=Instance.new("UICorner") avc.CornerRadius=UDim.new(1,0) avc.Parent=av
local avs=Instance.new("UIStroke") avs.Color=accent avs.Thickness=2 avs.Parent=av
D.avatarStroke=avs
local avi=Instance.new("ImageLabel")
avi.Size=UDim2.new(1,-4,1,-4) avi.Position=UDim2.new(0,2,0,2)
avi.BackgroundTransparency=1 avi.Parent=av
local avic=Instance.new("UICorner") avic.CornerRadius=UDim.new(1,0) avic.Parent=avi
avi.Image=string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150",plr.UserId)

D.showSub=function(page,btn)
 playersSub.Visible=(page==playersSub)
 savedSub.Visible=(page==savedSub)
 for _,t in ipairs(subTabs) do
  if t.button==btn then
   t.button.BackgroundColor3=Color3.fromRGB(40,40,60)
   t.button.TextColor3=D.accent t.stroke.Transparency=0.3
  else
   t.button.BackgroundColor3=Color3.fromRGB(30,30,45)
   t.button.TextColor3=Color3.fromRGB(200,200,200) t.stroke.Transparency=1
  end
 end
end

D.playersSub=playersSub D.savedSub=savedSub
D.plist=plist D.pll=pll D.createSub=createSub D.subTabs=subTabs

UIS.InputBegan:Connect(function(i,gp)
 if gp then return end
 if i.KeyCode==Enum.KeyCode.Return then D.main.Visible=not D.main.Visible end
end)

print("Part 2 OK")
local D=_G.D
if not D then warn("Part 1,2 を先に！") return end
local Players=game:GetService("Players")
local plr=Players.LocalPlayer

local pSub=D.createSub("Players",0,100,function() D.showSub(D.playersSub,pSub) end)
local sSub=D.createSub("Saved",108,100,function() D.showSub(D.savedSub,sSub) end)
D.showSub(D.playersSub,pSub)

local function tpTo(ch)
 local mc=plr.Character if not mc or not ch then return end
 local th=ch:FindFirstChild("HumanoidRootPart") local mh=mc:FindFirstChild("HumanoidRootPart")
 if th and mh then mh.CFrame=th.CFrame+Vector3.new(3,0,0) end
end

local function refresh()
 for _,c in ipairs(D.plist:GetChildren()) do
  if c:IsA("TextButton") then c:Destroy() end
 end
 for _,p in ipairs(Players:GetPlayers()) do
  if p~=plr then
   local b=Instance.new("TextButton")
   b.Size=UDim2.new(1,-5,0,34) b.BackgroundColor3=Color3.fromRGB(30,30,45)
   b.Text="  "..p.Name b.TextColor3=Color3.fromRGB(220,220,220)
   b.Font=Enum.Font.GothamMedium b.TextSize=12
   b.TextXAlignment=Enum.TextXAlignment.Left b.BorderSizePixel=0 b.Parent=D.plist
   local c=Instance.new("UICorner") c.CornerRadius=UDim.new(0,6) c.Parent=b
   local s=Instance.new("UIStroke") s.Color=D.accent s.Thickness=1
   s.Transparency=0.6 s.Parent=b
   D.reg(s,"Color")
   b.MouseButton1Click:Connect(function() if p.Character then tpTo(p.Character) end end)
  end
 end
 D.plist.CanvasSize=UDim2.new(0,0,0,D.pll.AbsoluteContentSize.Y)
end
Players.PlayerAdded:Connect(function() task.wait(0.5) refresh() end)
Players.PlayerRemoving:Connect(function() task.wait(0.5) refresh() end)
refresh()

local saveBtn=Instance.new("TextButton")
saveBtn.Size=UDim2.new(1,-30,0,32) saveBtn.Position=UDim2.new(0,15,0,5)
saveBtn.BackgroundColor3=D.accent saveBtn.Text="Save Current Location"
saveBtn.TextColor3=Color3.fromRGB(255,255,255) saveBtn.Font=Enum.Font.GothamBold
saveBtn.TextSize=12 saveBtn.BorderSizePixel=0 saveBtn.Parent=D.savedSub
D.reg(saveBtn,"BackgroundColor3")
local sbc=Instance.new("UICorner") sbc.CornerRadius=UDim.new(0,6) sbc.Parent=saveBtn

local savedList=Instance.new("ScrollingFrame")
savedList.Size=UDim2.new(1,-30,1,-50) savedList.Position=UDim2.new(0,15,0,45)
savedList.BackgroundTransparency=1 savedList.BorderSizePixel=0
savedList.ScrollBarThickness=4 savedList.ScrollBarImageColor3=D.accent
savedList.CanvasSize=UDim2.new(0,0,0,0) savedList.Parent=D.savedSub
D.reg(savedList,"ScrollBarImageColor3")
local sl=Instance.new("UIListLayout") sl.Padding=UDim.new(0,5) sl.Parent=savedList
local locs={}

local function refreshSaved()
 for _,c in ipairs(savedList:GetChildren()) do
  if c:IsA("Frame") then c:Destroy() end
 end
 for i,d in ipairs(locs) do
  local r=Instance.new("Frame")
  r.Size=UDim2.new(1,-5,0,34) r.BackgroundColor3=Color3.fromRGB(30,30,45)
  r.BorderSizePixel=0 r.Parent=savedList
  local rc=Instance.new("UICorner") rc.CornerRadius=UDim.new(0,6) rc.Parent=r
  local rs=Instance.new("UIStroke") rs.Color=D.accent rs.Thickness=1
  rs.Transparency=0.6 rs.Parent=r
  D.reg(rs,"Color")
  local tb=Instance.new("TextButton")
  tb.Size=UDim2.new(1,-60,1,0) tb.BackgroundTransparency=1
  tb.Text="  "..d.name tb.TextColor3=Color3.fromRGB(220,220,220)
  tb.Font=Enum.Font.GothamMedium tb.TextSize=12
  tb.TextXAlignment=Enum.TextXAlignment.Left tb.Parent=r
  tb.MouseButton1Click:Connect(function()
   local h=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
   if h then h.CFrame=d.cframe end
  end)
  local db=Instance.new("TextButton")
  db.Size=UDim2.new(0,50,0,24) db.Position=UDim2.new(1,-55,0.5,-12)
  db.BackgroundColor3=Color3.fromRGB(180,50,50) db.Text="Del"
  db.TextColor3=Color3.fromRGB(255,255,255) db.Font=Enum.Font.GothamBold
  db.TextSize=11 db.BorderSizePixel=0 db.Parent=r
  local dc=Instance.new("UICorner") dc.CornerRadius=UDim.new(0,4) dc.Parent=db
  db.MouseButton1Click:Connect(function()
   table.remove(locs,i) refreshSaved()
  end)
 end
 savedList.CanvasSize=UDim2.new(0,0,0,sl.AbsoluteContentSize.Y)
end

saveBtn.MouseButton1Click:Connect(function()
 local h=plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
 if h then
  table.insert(locs,{name="Loc "..(#locs+1),cframe=h.CFrame})
  refreshSaved()
 end
end)

local function apply(ch)
 local h=ch:WaitForChild("Humanoid",5)
 if h then h.WalkSpeed=D.speed h.JumpPower=D.jump h.UseJumpPower=true end
end
plr.CharacterAdded:Connect(apply)
if plr.Character then apply(plr.Character) end

print("Part 3 OK")
