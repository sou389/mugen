-- 画面に残っているUIを全部消すコード
for _, gui in pairs(game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):GetChildren()) do
    if gui:IsA("ScreenGui") then
        print("削除中: " .. gui.Name)
        gui:Destroy()
    end
end
print("全部消しました！")
