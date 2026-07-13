-- MM2 Full Script By WgRo (готовый)
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
MainFrame.Size = UDim2.new(0, 260, 0, 450)
MainFrame.Position = UDim2.new(0.5, -130, 0.2, 0)
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
Credit.TextSize = 17
Credit.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,40,0,40)
CloseBtn.Position = UDim2.new(1,-45,0,5)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,10)

local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,180,0,45)
OpenBtn.Position = UDim2.new(0.5,-90,0,10)
OpenBtn.Text = "By WgRo"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0,170,130)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 19
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,12)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1,-30,1,-110)
Container.Position = UDim2.new(0,15,0,80)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0,12)
List.Parent = Container

local function NewBtn(text)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,55)
    b.BackgroundColor3 = Color3.fromRGB(40,40,55)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 17
    b.Parent = Container
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
    return b
end

local b1 = NewBtn("ESP All: OFF")
local b2 = NewBtn("ESP Gun: OFF")
local b3 = NewBtn("Shot Murderer: OFF")
local b4 = NewBtn("Crosshair: OFF")

b1.MouseButton1Click:Connect(function() ESPAll = not ESPAll; b1.Text = "ESP All: " .. (ESPAll and "ON ✅" or "OFF") end)
b2.MouseButton1Click:Connect(function() ESPGun = not ESPGun; b2.Text = "ESP Gun: " .. (ESPGun and "ON ✅" or "OFF") end)
b3.MouseButton1Click:Connect(function() ShotMurderer = not ShotMurderer; b3.Text = "Shot Murderer: " .. (ShotMurderer and "ON ✅" or "OFF") end)
b4.MouseButton1Click:Connect(function() CrosshairEnabled = not CrosshairEnabled; b4.Text = "Crosshair: " .. (CrosshairEnabled and "ON ✅" or "OFF") end)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true; OpenBtn.Visible = false end)

-- Функции
local ESP = {}
local Guns = {}

local function getRole(p)
    if not p.Character then return "Innocent" end
    if p.Character:FindFirstChild("Knife") or p.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if p.Character:FindFirstChild("Gun") or p.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

RunService.RenderStepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or not p.Character then continue end
        local root = p.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end
        local role = getRole(p)
        local col = role == "Murderer" and Color3.fromRGB(255,0,0) or (role == "Sheriff" and Color3.fromRGB(0,100,255) or Color3.fromRGB(0,255,0))
        
        if not ESP[p] then
            local box = Drawing.new("Square")
            box.Thickness = 2
            box.Filled = false
            ESP[p] = box
        end
        local box = ESP[p]
        local pos, vis = Camera:WorldToViewportPoint(root.Position + Vector3.new(0,3,0))
        if ESPAll and vis then
            box.Size = Vector2.new(1600/pos.Z, 2500/pos.Z)
            box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
            box.Color = col
            box.Visible = true
        else
            box.Visible = false
        end
    end

    -- Gun ESP
    for _, v in ipairs(workspace:GetDescendants()) do
        if v:IsA("Model") and v:FindFirstChild("Handle") and string.find(v.Name:lower(), "gun") then
            if not Guns[v] then
                local t = Drawing.new("Text")
                t.Text = "🔫 GUN"
                t.Color = Color3.fromRGB(255,215,0)
                t.Size = 18
                Guns[v] = t
            end
            local t = Guns[v]
            local pos, vis = Camera:WorldToViewportPoint(v.Handle.Position)
            if ESPGun and vis then
                t.Position = Vector2.new(pos.X, pos.Y)
                t.Visible = true
            else
                t.Visible = false
            end
        end
    end

    if ShotMurderer then
        -- Auto aim on click will be added later if needed
    end
end)

print("Готово! Попробуй.")
