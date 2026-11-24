--!strict
-- Client-only selection of static architectural lights. Dynamic exhibit lights,
-- audio, interactive effects, doors and streaming settings are left to their owners.
local Players=game:GetService("Players")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Visual=require(Shared.VisualConfig)
local Policy=require(Shared.ArtDecoLightPolicy)
local player=Players.LocalPlayer
local LightLOD={}
function LightLOD.start(world)
    local lights={}
    local function add(node)
        if (node:IsA("PointLight") or node:IsA("SpotLight") or node:IsA("SurfaceLight"))
            and node:GetAttribute("KinStaticLightLOD")==true then lights[node]=node.Enabled end
    end
    local function remove(node) lights[node]=nil end
    local added=world.DescendantAdded:Connect(add)
    local removed=world.DescendantRemoving:Connect(remove)
    for _,node in ipairs(world:GetDescendants()) do add(node) end
    task.spawn(function()
        while world.Parent do
            local character=player.Character
            local root=character and character:FindFirstChild("HumanoidRootPart")
            if root then
                local quality=player:GetAttribute("KinCityLocalQuality") or Visual.profile
                local candidates={}
                for light,enabled in pairs(lights) do
                    if light.Parent and enabled then
                        local host=light.Parent
                        local position=if host:IsA("Attachment") then host.WorldPosition elseif host:IsA("BasePart") then host.Position else nil
                        if position then
                            local delta=position-root.Position
                            table.insert(candidates,{light=light,distance=delta:Dot(delta)})
                        end
                    end
                end
                local active=Policy.select(candidates,quality)
                for _,item in ipairs(candidates) do item.light.Enabled=item.selected end
                player:SetAttribute("KinArtDecoStaticLightsActive",active)
            end
            task.wait(1.5)
        end
        added:Disconnect();removed:Disconnect()
        for light,enabled in pairs(lights) do if light.Parent then light.Enabled=enabled end end
    end)
end
return LightLOD
