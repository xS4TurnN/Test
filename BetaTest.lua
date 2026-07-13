-- MM2 Улучшенная версия By WgRo
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local ESPAll = false
local ESPGun = false
local ShotMurderer = false
local CrosshairEnabled = false
local CrosshairStyle = "Point" -- Point, Plus, Bear

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

-- Меню (вертикальное, компактное)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 240, 0, 380)
MainFrame.Position = UDim2.new(0.5, -120, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.BackgroundTransparency = 0.3
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 14)

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1,0,0,45)
TitleBar.BackgroundTransparency = 1
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.7,0,1,0)
Title.Text = "MM2 MENU"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0, 255, 200)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 20
Title.Parent = TitleBar

local Credit = Instance.new("TextLabel")
Credit.Size = UDim2.new(0.3,0,1,0)
Credit.Position = UDim2.new(0.7,0,0,0)
Credit.Text = "By WgRo"
Credit.BackgroundTransparency = 1
Credit.TextColor3 = Color3.fromRGB(120, 220, 255)
Credit.Font = Enum.Font.GothamSemibold
Credit.TextSize = 16
Credit.Parent = TitleBar

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,35,0,35)
CloseBtn.Position = UDim2.new(1,-40,0,5)
CloseBtn.Text = "✕"
CloseBtn.BackgroundColor3 = Color3.fromRGB(220,40,40)
CloseBtn.TextColor3 = Color3.new(1,1,1)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 20
CloseBtn.Parent = TitleBar
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0,8)

-- Кнопка открытия (центр сверху)
local OpenBtn = Instance.new("TextButton")
OpenBtn.Size = UDim2.new(0,160,0,40)
OpenBtn.Position = UDim2.new(0.5,-80,0,10)
OpenBtn.Text = "By WgRo"
OpenBtn.BackgroundColor3 = Color3.fromRGB(0,170,130)
OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 18
OpenBtn.Visible = false
OpenBtn.Parent = ScreenGui
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0,10)

-- Кнопки
local Container = Instance.new("Frame")
Container.Size = UDim2.new(1,-20,1,-70)
Container.Position = UDim2.new(0,10,0,55)
Container.BackgroundTransparency = 1
Container.Parent = MainFrame

local List = Instance.new("UIListLayout")
List.Padding = UDim.new(0,10)
List.SortOrder = Enum.SortOrder.LayoutOrder
List.Parent = Container

local function createBtn(text)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1,0,0,50)
    btn.BackgroundColor3 = Color3.fromRGB(35,35,48)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.Parent = Container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)
    return btn
end

local bESP = createBtn("ESP All: OFF")
local bGun = createBtn("ESP Gun: OFF")
local bShot = createBtn("Shot Murderer: OFF")
local bCross = createBtn("Crosshair: OFF")

bESP.MouseButton1Click:Connect(function() ESPAll = not ESPAll; bESP.Text = "ESP All: " .. (ESPAll and "ON ✅" or "OFF") end)
bGun.MouseButton1Click:Connect(function() ESPGun = not ESPGun; bGun.Text = "ESP Gun: " .. (ESPGun and "ON ✅" or "OFF") end)
bShot.MouseButton1Click:Connect(function() ShotMurderer = not ShotMurderer; bShot.Text = "Shot Murderer: " .. (ShotMurderer and "ON ✅" or "OFF") end)
bCross.MouseButton1Click:Connect(function() CrosshairEnabled = not CrosshairEnabled; bCross.Text = "Crosshair: " .. (CrosshairEnabled and "ON ✅" or "OFF") end)

CloseBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)

-- ==================== ESP + FEATURES ====================
local ESPObjects = {}
local GunObjects = {}
local ShotButton = nil

local function getRole(plr)
    if not plr.Character then return "Innocent" end
    if plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife") then return "Murderer" end
    if plr.Character:FindFirstChild("Gun") or plr.Backpack:FindFirstChild("Gun") then return "Sheriff" end
    return "Innocent"
end

RunService.RenderStepped:Connect(function()
    -- ESP All (рамки)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == LocalPlayer or not plr.Character then continue end
        local root = plr.Character:FindFirstChild("HumanoidRootPart")
        if not root then continue end

        local role = getRole(plr)
        local col = role == "Murderer" and Color3.fromRGB(255,0,0) or (role == "Sheriff" and Color3.fromRGB(0,100,255) or Color3.fromRGB(0,255,0))

        if not ESPObjects[plr] then
            local box = Drawing.new("Square")
            box.Thickness = 2
            box.Filled = false
            ESPObjects[plr] = box
        end

        local box = ESPObjects[plr]
        local pos, onScreen = Camera:WorldToViewportPoint(root.Position + Vector3.new(0,3,0))
        if ESPAll and onScreen then
            box.Size = Vector2.new(1600 / pos.Z, 2400 / pos.Z)
            box.Position = Vector2.new(pos.X - box.Size.X/2, pos.Y - box.Size.Y/2)
            box.Color = col
            box.Visible = true
        else
            box.Visible = false
        end
    end

    -- ESP Gun (только dropped, жёлтая рамка)
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj:FindFirstChild("Handle") and string.find(obj.Name:lower(), "gun") then
            if not GunObjects[obj] then
                local box = Drawing.new("Square")
                box.Thickness = 2
                box.Color = Color3.fromRGB(255, 215, 0)
                box.Filled = false
                GunObjects[obj] = box
            end
            local box = GunObjects[obj]
            local pos, onScreen = Camera:WorldToViewportPoint(obj.Handle.Position)
            if ESPGun and onScreen then
                box.Size = Vector2.new(60, 60)
                box.Position = Vector2.new(pos.X - 30, pos.Y - 30)
                box.Visible = true
            else
                box.Visible = false
            end
        end
    end

    -- Shot Murderer Button
    if ShotMurderer and not ShotButton then
        ShotButton = Instance.new("TextButton")
        ShotButton.Size = UDim2.new(0, 140, 0, 70)
        ShotButton.Position = UDim2.new(0.75, 0, 0.6, 0)
        ShotButton.BackgroundColor3 = Color3.fromRGB(200, 20, 20)
        ShotButton.Text = "SHOT\nMURDERER"
        ShotButton.TextColor3 = Color3.new(1,1,1)
        ShotButton.Font = Enum.Font.GothamBold
        ShotButton.TextSize = 15
        ShotButton.Parent = ScreenGui
        Instance.new("UICorner", ShotButton).CornerRadius = UDim.new(0, 12)

        -- Drag + Resize (пока только drag)
        local dragging
        ShotButton.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                ShotButton.Position += UDim2.new(0, input.Position.X - ShotButton.AbsolutePosition.X - 70, 0, input.Position.Y - ShotButton.AbsolutePosition.Y - 35)
            end
        end)
        UserInputService.InputEnded:Connect(function() dragging = false end)

        ShotButton.MouseButton1Click:Connect(function()
            if not ShotMurderer then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p \~= LocalPlayer and getRole(p) == "Murderer" and p.Character then
                    local root = p.Character:FindFirstChild("HumanoidRootPart")
                    if root then
                        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, root.Position)
                        mouse1click()
                    end
                end
            end
        end)
    end

    -- Crosshair
    if CrosshairEnabled then
        local ch = Drawing.new("Text")
        ch.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
        ch.Center = true
        ch.Outline = true
        if CrosshairStyle == "Plus" then ch.Text = "+" 
        elseif CrosshairStyle == "Bear" then ch.Text = "🐻" 
        else ch.Text = "•" end
        ch.Color = Color3.fromRGB(0, 255, 200)
        ch.Size = 24
        ch.Visible = true
        RunService.RenderStepped:Wait()
        ch:Remove()
    end
end)

print("✅ Улучшенная версия загружена!")
