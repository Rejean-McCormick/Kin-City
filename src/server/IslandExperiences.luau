--!strict
-- Installations physiques de l'archipel: cycles lumineux et mécaniques locaux.
-- Les bornes métiers, distinctes, restent des stubs kOA.
local ProximityPromptService=game:GetService("ProximityPromptService")
local Players=game:GetService("Players")
local TweenService=game:GetService("TweenService")
local F=require(script.Parent.Factory)
local RateLimiter=require(script.Parent.RateLimiter)
local Islands={}
function Islands.start(world,reply)
    local discovered={}
    local function register(player)
        discovered[player]={}
        player:SetAttribute("KinIslandsVisited",0)
        player:SetAttribute("KinIslandsTotal",6)
    end
    Players.PlayerAdded:Connect(register)
    for _,player in ipairs(Players:GetPlayers()) do register(player) end
    Players.PlayerRemoving:Connect(function(player) discovered[player]=nil end)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        if not player or not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local id=host:GetAttribute("KinIslandExperienceId")
        if type(id)~="string" or not id:match("^kin%.island%.[%w_]+$") then return end
        local model=host.Parent
        if not model or not model:IsA("Model") or model:GetAttribute("KinIslandId")~=id then return end
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        local hum=player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health<=0 or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"island/"..id,1.4) then return end
        local visited=discovered[player]
        if visited and not visited[id] then
            visited[id]=true
            local count=0
            for _ in pairs(visited) do count+=1 end
            player:SetAttribute("KinIslandsVisited",count)
        end
        local active=not (model:GetAttribute("KinIslandActive")==true)
        model:SetAttribute("KinIslandActive",active)
        local exhibit=model:FindFirstChild("Installation — "..tostring(model:GetAttribute("KinIslandCaption")))
        if not exhibit then
            for _,child in ipairs(model:GetChildren()) do
                if child:IsA("Model") and string.find(child.Name,"Installation",1,true) then exhibit=child;break end
            end
        end
        if exhibit then
            for _,piece in ipairs(exhibit:GetDescendants()) do
                if piece:IsA("BasePart") then
                    if piece:GetAttribute("KinIslandReactive") then
                        if piece:GetAttribute("KinIslandRestTransparency")==nil then
                            piece:SetAttribute("KinIslandRestTransparency",piece.Transparency)
                        end
                        TweenService:Create(piece,TweenInfo.new(0.8),{Transparency=active and 0.02 or 0.65}):Play()
                        local light=piece:FindFirstChildOfClass("PointLight")
                        if not light then
                            light=Instance.new("PointLight")
                            light.Range=11;light.Brightness=0.8;light.Parent=piece
                        end
                        light.Enabled=active
                    end
                    if piece:GetAttribute("KinIslandRotor") then
                        local rest=piece:GetAttribute("KinIslandRestFrame")
                        if typeof(rest)~="CFrame" then rest=piece.CFrame;piece:SetAttribute("KinIslandRestFrame",rest) end
                        TweenService:Create(piece,TweenInfo.new(1.5,Enum.EasingStyle.Sine),{CFrame=if active then rest*CFrame.Angles(0,math.pi,0) else rest}):Play()
                    end
                end
            end
        end
        prompt.ActionText=active and "Éteindre" or "Activer"
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",title=model.Name,
            message=if active then "Installation insulaire activée" else "Installation insulaire arrêtée",
            notice=string.format("Archipel : %d/6 îles explorées • sans connexion à kOA.",player:GetAttribute("KinIslandsVisited") or 0)
        })
    end)
end
return Islands
