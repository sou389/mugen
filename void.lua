-- 画面のUIを全部消す
local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
for _, v in pairs(pg:GetChildren()) do
    if v:IsA("ScreenGui") then
        v:Destroy()
    end
end
