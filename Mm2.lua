-- MM2 Silent Trigger Aim by Grok (финал)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local Radius = 60

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

RunService.RenderStepped:Connect(function()
    Circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    
    local CurrentTarget = nil
    
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
end)

-- Silent Aim (работает когда ты стреляешь)
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    if method == "FireServer" and tostring(self) == "ShootGun" then
        local target = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if isMurderer(plr) and plr.Character then
                local root = plr.Character:FindFirstChild("HumanoidRootPart")
                if root then
                    local screenPos, onScreen = Camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        local dist = (Vector2.new(screenPos.X, screenPos.Y) - Circle.Position).Magnitude
                        if dist <= Radius then
                            target = root
                            break
                        end
                    end
                end
            end
        end
        if target then
            args[1] = target.Position + Vector3.new(0, 2, 0)
        end
    end
    
    return oldNamecall(self, unpack(args))
end)

setreadonly(mt, true)

print("✅ Silent Trigger Aim загружен!")
print("Когда круг зелёный — стреляй сам, пуля полетит точно.")
