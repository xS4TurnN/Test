local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local Frame = Instance.new("Frame")
Frame.Size = UDim2.new(0, 250, 0, 300)
Frame.Position = UDim2.new(0.5, -125, 0.4, 0)
Frame.BackgroundColor3 = Color3.fromRGB(20,20,30)
Frame.Parent = ScreenGui

Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.Text = "MM2 Menu By WgRo"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0,255,200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = Frame

local Btn = Instance.new("TextButton")
Btn.Size = UDim2.new(0.8,0,0,50)
Btn.Position = UDim2.new(0.1,0,0,80)
Btn.Text = "Тест кнопка"
Btn.BackgroundColor3 = Color3.fromRGB(40,40,60)
Btn.TextColor3 = Color3.new(1,1,1)
Btn.Parent = Frame
Instance.new("UICorner", Btn).CornerRadius = UDim.new(0,10)

Btn.MouseButton1Click:Connect(function()
    print("Кнопка работает!")
end)

print("✅ Минимальное меню загружено!")
