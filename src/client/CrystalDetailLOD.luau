--!strict
-- LOD LOCAL des ornements décoratifs : aucune modification des structures,
-- portes, prompts ou mécanismes. Les parties optionnelles sont non-collidantes.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local Visual=require(RS:WaitForChild("KinCityShared"):WaitForChild("VisualConfig"))
local LOD={}
local player=Players.LocalPlayer

function LOD.start()
    local world=workspace:WaitForChild("KinCityGenerated",30)
    if not world then return end
    local optional={}
    local function add(inst)
        if inst:IsA("BasePart") and inst:GetAttribute("KinOptionalDetail")==true then
            optional[inst]=true
        end
    end
    local function remove(inst)
        if optional[inst] then optional[inst]=nil end
    end
    -- Tout objet tagué est purement visuel : le gameplay n'en dépend pas.
    for _,inst in ipairs(world:GetDescendants()) do add(inst) end
    world.DescendantAdded:Connect(add)
    world.DescendantRemoving:Connect(remove)
    local farDistance=if Visual.profile=="LITE" then 165 elseif Visual.profile=="SHOWCASE" then 570 else 340
    local nearDistance=farDistance-35 -- hystérésis évitant le clignotement à la limite
    task.spawn(function()
        while world.Parent do
            local char=player.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if root then
                local pos=root.Position
                -- La caméra peut observer un panorama distant pendant que l'avatar reste en place.
                local camera=workspace.CurrentCamera
                local viewPos=if camera then camera.CFrame.Position else pos
                local preference=player:GetAttribute("KinCityLocalQuality")
                local effectiveFar=if preference=="LITE" then 150 elseif preference=="SHOWCASE" then 540 else farDistance
                local effectiveNear=effectiveFar-35
                local checked=0
                for part in pairs(optional) do
                    if part.Parent then
                        local dist=math.min((part.Position-pos).Magnitude,(part.Position-viewPos).Magnitude)
                        if part.LocalTransparencyModifier<1 and dist>effectiveFar then
                            part.LocalTransparencyModifier=1
                        elseif part.LocalTransparencyModifier>=1 and dist<effectiveNear then
                            part.LocalTransparencyModifier=0
                        end
                    else
                        optional[part]=nil
                    end
                    checked+=1
                    if checked%180==0 then task.wait() end
                end
            end
            task.wait(1.8)
        end
    end)
end
return LOD
