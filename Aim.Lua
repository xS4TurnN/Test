-- MM2 Auto Aim + Silent (авто-стрельба)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Radius = 65

local Circle = Drawing.new("Circle")
Circle.Radius = Radius
Circle.Thickness = 2
Circle.Color = Color3.fromRGB(255, 0, 100)
Circle.Transparency = 0.6
Circle.NumSides = 64
Circle.Filled = false
Circle.Visible = true

local function isMurderer(plr)
    if plr == LocalPlayer or not plr.Character then return false end
    return plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")
end

local CurrentTarget = nil

RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    CurrentTarget = nil
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if isMurderer(plr) and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - Circle.Position).Magnitude
                    if dist <= Radius then
                        CurrentTarget = root
                        break
                    end
                end
            end
        end
    end
    
    Circle.Color = CurrentTarget and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 100)
    
    -- Авто-стрельба
    if CurrentTarget then
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, CurrentTarget.Position)
        mouse1click()
        wait(0.15)  -- задержка чтобы не спамить
    end
end)

print("✅ Auto Aim + Круг загружен!")
