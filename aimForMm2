-- Добавляем проверку препятствий
local function isVisible(targetPart)
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin).Unit * 500 -- Дистанция луча
    local raycastParams = RaycastParams.new()
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, workspace.CurrentCamera}
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    
    local raycastResult = workspace:Raycast(origin, direction * 500, raycastParams)
    
    if raycastResult and raycastResult.Instance then
        -- Проверяем, является ли объект частью персонажа цели или это просто стена
        return raycastResult.Instance:IsDescendantOf(targetPart.Parent)
    end
    return false
end

-- Обновленный Hook
oldIndex = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if method == "FireServer" and self.Name == "ShootGun" then
        local target = getMurderer()
        
        -- Проверяем наличие пистолета И видимость цели
        if target and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Gun") then
            if isVisible(target) then
                -- Цель видна — стреляем точно в неё
                args[1] = (target.Position - LocalPlayer.Character.Gun.Handle.Position).Unit
            else
                -- Цель за стеной — не вмешиваемся (пуля полетит по траектории прицела)
                -- Или можно добавить return nil, если не хочешь стрелять вообще
            end
        end
    end
    
    return oldIndex(self, unpack(args))
end)
