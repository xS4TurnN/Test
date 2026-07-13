local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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
MainFrame.Size = UDim2.new(0, 240, 0, 400)
MainFrame.Position = UDim2.new(0.5, -120, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,50)
Title.Text = "MM2 MENU By WgRo"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = MainFrame

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,35,0,35)
CloseBtn.Position = UDim2.new(1,-40,0,5)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = MainFrame
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)

local Container = Instance.new("Frame")
Container.Size = UDim2.new(1,-20,1,-70)
Container.Position = UDim2.new(0,10,0,55)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0,10)
List.Parent = Container

local function btn(text, callback)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,50)
    b.BackgroundColor3 = Color3.fromRGB(40,40,55)
    b.Text = text
    b.TextColor3 = Color3.new(1,1,1)
    b.Font = Enum.Font.GothamSemibold
    b.TextSize = 16
    b.Parent = Container
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    b.MouseButton1Click:Connect(callback)
    return b
end

local b1 = btn("ESP All: OFF", function() ESPAll = not ESPAll; b1.Text = "ESP All: " .. (ESPAll and "ON" or "OFF") end)
local b2 = btn("ESP Gun: OFF", function() ESPGun = not ESPGun; b2.Text = "ESP Gun: " .. (ESPGun and "ON" or "OFF") end)
local b3 = btn("Shot Murderer: OFF", function() ShotMurderer = not ShotMurderer; b3.Text = "Shot Murderer: " .. (ShotMurderer and "ON" or "OFF") end)
local b4 = btn("Crosshair: OFF", function() CrosshairEnabled = not CrosshairEnabled; b4.Text = "Crosshair: " .. (CrosshairEnabled and "ON" or "OFF") end)

CloseBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end)

-- ESP All (точные рамки)
local ESP = {}
RunService.RenderStepped:Connect(function()
    for _, p in ipairs(Players:GetPlayers()) do
        if p == LocalPlayer or not p.Character then continue end
        local root = p.Character:FindFirstChild("HumanoidRootPart")
        local head = p.Character:FindFirstChild("Head")
        if not root or not head then continue end

        if not ESP[p] then
            local box = Drawing.new("Square")
            box.Thickness = 2
            box.Filled = false
            ESP[p] = box
        end

        local box = ESP[p]
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position)
        local headPos = Camera:WorldToViewportPoint(head.Position)

        if ESPAll and onScreen then
            local height = (headPos.Y - pos.Y) * 1.8
            box.Size = Vector2.new(height / 2, height)
            box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
            box.Color = Color3.fromRGB(0,255,0)
            box.Visible = true
        else
            box.Visible = false
        end
    end

    -- ESP Gun (точная форма)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Handle") and string.find(obj.Name:lower(), "gun") then
            if not ESP[obj] then
                local box = Drawing.new("Square")
                box.Thickness = 2
                box.Color = Color3.fromRGB(255, 215, 0)
                box.Filled = false
                ESP[obj] = box
            end
            local box = ESP[obj]
            local pos, onScreen = Camera:WorldToViewportPoint(obj.Handle.Position)
            if ESPGun and onScreen then
                box.Size = Vector2.new(50, 30)
                box.Position = Vector2.new(pos.X - 25, pos.Y - 15)
                box.Visible = true
            else
                box.Visible = false
            end
        end
    end
end)

print("✅ Готово!")
