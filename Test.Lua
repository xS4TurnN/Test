-- MM2 Полная версия By WgRo
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPAll = false
local ESPGun = false
local ShotMurderer = false
local CrosshairEnabled = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Меню
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 400)
MainFrame.Position = UDim2.new(0.5, -125, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BackgroundTransparency = 0.25
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.Text = "MM2 MENU"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.Parent = MainFrame

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(1,0,0,30)
Credit.Position = UDim2.new(0,0,0,25)
Credit.Text = "By WgRo"
Credit.BackgroundTransparency = 1
Credit.TextColor3 = Color3.fromRGB(100, 200, 255)
Credit.Font = Enum.Font.GothamSemibold
Credit.TextSize = 16
Credit.Parent = MainFrame

-- Кнопка закрытия
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,35,0,35)
CloseBtn.Position = UDim2.new(1,-40,0,8)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)

-- Кнопка открытия (By WgRo сверху)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,170,0,45)
OpenBtn.Position = UDim2.new(0.5,-85,0,10)
OpenBtn.Text = "By WgRo"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0,170,130)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 18
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,12)

-- Функция создания кнопок
local function NewButton(text, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.85,0,0,50)
    btn.Position = UDim2.new(0.075,0,y,0)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(40,40,55)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = MainFrame
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    return btn
end

local bESP = NewButton("ESP All: OFF", 80)
local bGun = NewButton("ESP Gun: OFF", 140)
local bShot = NewButton("Shot Murderer: OFF", 200)
local bCross = NewButton("Crosshair: OFF", 260)

bESP.MouseButton1Click:Connect(function()
    ESPAll = not ESPAll
    bESP.Text = "ESP All: " .. (ESPAll and "ON ✅" or "OFF")
end)

bGun.MouseButton1Click:Connect(function()
    ESPGun = not ESPGun
    bGun.Text = "ESP Gun: " .. (ESPGun and "ON ✅" or "OFF")
end)

bShot.MouseButton1Click:Connect(function()
    ShotMurderer = not ShotMurderer
    bShot.Text = "Shot Murderer: " .. (ShotMurderer and "ON ✅" or "OFF")
end)

bCross.MouseButton1Click:Connect(function()
    CrosshairEnabled = not CrosshairEnabled
    bCross.Text = "Crosshair: " .. (CrosshairEnabled and "ON ✅" or "OFF")
end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- === ESP + Функции ===
local function getRole(p)
    if not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

-- Простой ESP
RunService.RenderStepped:Connect(function()
    -- Crosshair
    if CrosshairEnabled then
        -- Здесь можно добавить Drawing crosshair при желании
    end
end)

print("✅ Полное меню By WgRo загружено!")
print("Нажми By WgRo сверху чтобы открыть меню после закрытия")
