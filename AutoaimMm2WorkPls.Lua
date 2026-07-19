-- MM2 Auto Aim (финальная версия)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Radius = 55
local AutoAimEnabled = true

local Circle = Drawing.new("Circle")
Circle.Radius = Radius
Circle.Thickness = 2
Circle.Color = Color3.fromRGB(255, 0, 100)
Circle.Transparency = 0.6
Circle.NumSides = 64
Circle.Filled = false
Circle.Visible = true

local function hasGun()
    if not LocalPlayer.Character then return false end
    return LocalPlayer.Character:FindFirstChild("Gun") or LocalPlayer.Backpack:FindFirstChild("Gun")
end

local function isMurderer(plr)
    if plr == LocalPlayer or not plr.Character then return false end
    return plr.Character:FindFirstChild("Knife") or plr.Backpack:FindFirstChild("Knife")
end

local function canSee(target)
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local ray = Ray.new(root.Position, (target.Position - root.Position).Unit * 500)
    local hit = workspace:FindPartOnRayWithIgnoreList(ray, {LocalPlayer.Character})
    return hit == nil or hit:IsDescendantOf(target.Parent)
end

RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    if not AutoAimEnabled or not hasGun() then
        Circle.Color = Color3.fromRGB(100, 100, 100)
        return
    end
    
    local CurrentTarget = nil
    
    for _, plr in ipairs(Players:GetPlayers()) do
        if isMurderer(plr) and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root and canSee(root) then
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
        Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, CurrentTarget.Position + Vector3.new(0, 2, 0))
        mouse1click()
        wait(0.2)
    end
end)

print("✅ Финальная версия Auto Aim загружена!")
