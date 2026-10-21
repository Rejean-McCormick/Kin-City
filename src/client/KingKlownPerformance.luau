--!strict
-- Gestes additifs locaux synchronisés par un seul timestamp serveur.
local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local RunService=game:GetService("RunService")
local CAS=game:GetService("ContextActionService")
local UIS=game:GetService("UserInputService")
local Performance={}
function Performance.start()
    local player=Players.LocalPlayer
    local gui=player:WaitForChild("PlayerGui")
    if gui:GetAttribute("KingKlownPerformanceRunning") then return end
    gui:SetAttribute("KingKlownPerformanceRunning",true)
    local records={}
    local function restore(record)
        for _,joint in ipairs(record.joints) do
            if joint.item.Parent and joint.output and joint.item.Transform==joint.output then
                joint.item.Transform=joint.base
            end
            joint.output=nil
        end
    end
    local function remove(model)
        local record=records[model]
        if record then
            restore(record)
            for _,eye in ipairs(record.eyes) do if eye.part.Parent then eye.part.Size=eye.size end end
            records[model]=nil
        end
    end
    local function add(model)
        if records[model] then return end
        local character=model.Parent
        if not character then return end
        local joints={}
        for _,item in ipairs(character:GetDescendants()) do
            if (item:IsA("Motor6D") or item:IsA("AnimationConstraint")) and (item.Name=="Neck" or item.Name=="RightShoulder"
                or item.Name=="LeftShoulder" or item.Name=="Right Shoulder" or item.Name=="Left Shoulder"
                or item.Name=="KingKlownCapeJoint") then
                table.insert(joints,{item=item,base=item.Transform})
            end
        end
        local eyes={}
        for _,item in ipairs(model:GetChildren()) do
            if item:IsA("BasePart") and (item.Name=="Œil gauche ouvert" or item.Name=="Œil droit mi-clos") then
                table.insert(eyes,{part=item,size=item.Size})
            end
        end
        records[model]={character=character,joints=joints,eyes=eyes}
    end
    CollectionService:GetInstanceAddedSignal("KingKlownAvatar"):Connect(add)
    CollectionService:GetInstanceRemovedSignal("KingKlownAvatar"):Connect(remove)
    for _,model in ipairs(CollectionService:GetTagged("KingKlownAvatar")) do add(model) end
    -- Retirer uniquement notre offset avant le passage de l'Animator.
    RunService.PreAnimation:Connect(function()
        for _,record in pairs(records) do restore(record) end
    end)
    RunService.PreSimulation:Connect(function()
        local camera=workspace.CurrentCamera
        if not camera then return end
        local now=workspace:GetServerTimeNow()
        local lite=player:GetAttribute("KinCityLocalQuality")=="LITE"
        for model,record in pairs(records) do
            local character=record.character
            local root=character:FindFirstChild("HumanoidRootPart")
            local hum=character:FindFirstChildOfClass("Humanoid")
            if not model:IsDescendantOf(workspace) then remove(model);continue end
            if not root or not hum or hum.Health<=0 then continue end
            if (root.Position-camera.CFrame.Position).Magnitude>(if lite then 55 else 100) then continue end
            local blinkPhase=now%5.3
            local eyelid=if blinkPhase<0.14 then math.max(0.12,math.abs(blinkPhase-0.07)/0.07) else 1
            for _,eye in ipairs(record.eyes) do if eye.part.Parent then eye.part.Size=eye.size*Vector3.new(1,eyelid,1) end end
            local seated=hum.SeatPart~=nil
            local grounded=hum.FloorMaterial~=Enum.Material.Air
            local moving=hum.MoveDirection.Magnitude>0.1
            local tool=character:FindFirstChildOfClass("Tool")~=nil
            local age=now-(character:GetAttribute("KingKlownCastAt") or -100)
            local casting=age>=0 and age<2.4 and grounded and not moving and not seated and not tool
            local pose=if casting then math.sin(math.pi*math.clamp(age/2.4,0,1)) else 0
            for _,joint in ipairs(record.joints) do
                local item=joint.item
                if not item.Parent then continue end
                local offset=CFrame.identity
                if item.Name=="KingKlownCapeJoint" then
                    local side=item:GetAttribute("KingKlownCapeSide") or 1
                    offset=CFrame.Angles(if seated then 0.65 else -0.08-math.min(root.AssemblyLinearVelocity.Magnitude/100,0.25)+math.sin(now*2.5+side)*0.025,0,side*0.05)
                elseif not seated and grounded and not tool then
                    if item.Name=="Neck" then
                        offset=CFrame.Angles(-pose*0.10,pose*0.10,if moving then 0 else 0.035+math.sin(now*0.65)*0.015)
                    elseif item.Name=="RightShoulder" or item.Name=="Right Shoulder" then
                        offset=CFrame.Angles(-pose*1.15,pose*0.15,pose*0.32)
                    elseif not moving then
                        offset=CFrame.Angles(0.025,0,-0.035)
                    end
                end
                joint.base=item.Transform
                joint.output=joint.base*offset
                item.Transform=joint.output
            end
        end
    end)
    local bound=false
    local function refresh()
        local character=player.Character
        local selected=character and character:GetAttribute("KinCityCharacter")=="King Klown"
        if selected and not bound then
            bound=true
            CAS:BindAction("KingKlownMagic",function(_,state)
                if UIS:GetFocusedTextBox() then return Enum.ContextActionResult.Pass end
                if state==Enum.UserInputState.Begin then
                    local remote=game:GetService("ReplicatedStorage"):FindFirstChild("KinCityTricksterCast")
                    if remote then remote:FireServer() end
                end
                return Enum.ContextActionResult.Sink
            end,true,Enum.KeyCode.G,Enum.KeyCode.ButtonR3)
            CAS:SetTitle("KingKlownMagic","Magie")
            CAS:SetPosition("KingKlownMagic",UDim2.new(1,-170,1,-180))
        elseif not selected and bound then
            bound=false;CAS:UnbindAction("KingKlownMagic")
        end
    end
    local appearanceConnection=nil
    local function watch(character)
        if appearanceConnection then appearanceConnection:Disconnect() end
        appearanceConnection=character:GetAttributeChangedSignal("KinCityCharacter"):Connect(refresh)
        refresh()
    end
    player.CharacterAdded:Connect(watch)
    player.CharacterRemoving:Connect(function() if bound then bound=false;CAS:UnbindAction("KingKlownMagic") end end)
    if player.Character then watch(player.Character) end
end
return Performance
