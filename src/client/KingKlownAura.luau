--!strict
-- Une boucle locale partagée; aucun RemoteEvent, PointLight ou ForceField.
local CollectionService=game:GetService("CollectionService")
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Aura={}
function Aura.start()
    local player=Players.LocalPlayer
    local playerGui=player:WaitForChild("PlayerGui")
    if playerGui:GetAttribute("KingKlownAuraRunning") then return end
    playerGui:SetAttribute("KingKlownAuraRunning",true)
    local records={}
    local pending={}
    local function remove(model)
        pending[model]=nil
        local record=records[model]
        if record then
            record.orb:Destroy()
            for _,mote in ipairs(record.motes) do mote:Destroy() end
            if record.spark then record.spark:Destroy() end
            records[model]=nil
        end
    end
    local function add(model)
        if records[model] or pending[model] then return end
        local ticket={}
        pending[model]=ticket
        task.spawn(function()
            local character=model.Parent
            local root=character and character:WaitForChild("HumanoidRootPart",10)
            if pending[model]~=ticket or not root or not root:IsA("BasePart")
                or not model:IsDescendantOf(workspace) then
                if pending[model]==ticket then pending[model]=nil end
                return
            end
            pending[model]=nil
            local orb=Instance.new("Part")
            orb.Name="Aura locale du Trickster"
            orb.Shape=Enum.PartType.Ball
            orb.Size=Vector3.new(7.2,7.2,7.2)
            orb.Color=Color3.fromRGB(197,244,240)
            orb.Material=Enum.Material.Neon
            orb.Transparency=0.965
            orb.Massless=true
            orb.CanCollide=false;orb.CanTouch=false;orb.CanQuery=false;orb.CastShadow=false
            orb.CFrame=root.CFrame*CFrame.new(0,0.25,0)
            orb.Parent=model
            local weld=Instance.new("WeldConstraint")
            weld.Part0=root;weld.Part1=orb;weld.Parent=orb
            local emitter=Instance.new("ParticleEmitter")
            emitter.Texture="rbxasset://textures/particles/sparkles_main.dds"
            emitter.Shape=Enum.ParticleEmitterShape.Sphere
            emitter.ShapeStyle=Enum.ParticleEmitterShapeStyle.Surface
            emitter.Rate=4
            emitter.Lifetime=NumberRange.new(1,1.6)
            emitter.Speed=NumberRange.new(0.02,0.10)
            emitter.LockedToPart=true
            emitter.LightEmission=0.3
            emitter.Color=ColorSequence.new(Color3.fromRGB(30,104,100),Color3.fromRGB(197,244,240))
            emitter.Size=NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.3,0.12),NumberSequenceKeypoint.new(1,0)})
            emitter.Transparency=NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.3,0.25),NumberSequenceKeypoint.new(1,1)})
            emitter.Parent=orb
            local motes={}
            for i=1,3 do
                local mote=Instance.new("Part")
                mote.Name="Éclat orbital "..i;mote.Shape=Enum.PartType.Ball
                mote.Size=Vector3.new(0.10,0.10,0.10);mote.Material=Enum.Material.Neon
                mote.Color=Color3.fromRGB(197,244,240);mote.Anchored=true
                mote.CanCollide=false;mote.CanTouch=false;mote.CanQuery=false;mote.CastShadow=false
                mote.Transparency=1;mote.Parent=model
                local a=Instance.new("Attachment");a.Position=Vector3.new(0,0.025,0);a.Parent=mote
                local b=Instance.new("Attachment");b.Position=Vector3.new(0,-0.025,0);b.Parent=mote
                local trail=Instance.new("Trail");trail.Attachment0=a;trail.Attachment1=b
                trail.Lifetime=0.32;trail.LightEmission=0.4
                trail.Color=ColorSequence.new(Color3.fromRGB(30,104,100),Color3.fromRGB(197,244,240))
                trail.Transparency=NumberSequence.new(0.4,1);trail.Enabled=false;trail.Parent=mote
                table.insert(motes,mote)
            end
            local hand=character:FindFirstChild("RightHand") or character:FindFirstChild("Right Arm")
            local spark=nil
            if hand then
                spark=Instance.new("Attachment");spark.Name="KingKlownHandSpark";spark.Position=Vector3.new(0,-0.25,-0.3);spark.Parent=hand
                local burst=emitter:Clone();burst.Rate=0;burst.Lifetime=NumberRange.new(0.25,0.6)
                burst.Speed=NumberRange.new(0.6,1.8);burst.LockedToPart=false;burst.Parent=spark
            end
            records[model]={orb=orb,emitter=emitter,root=root,character=character,visible=false,motes=motes,spark=spark,lastCast=-100}
        end)
    end
    CollectionService:GetInstanceAddedSignal("KingKlownAvatar"):Connect(add)
    CollectionService:GetInstanceRemovedSignal("KingKlownAvatar"):Connect(remove)
    for _,model in ipairs(CollectionService:GetTagged("KingKlownAvatar")) do add(model) end
    local elapsed=0
    RunService.Heartbeat:Connect(function(dt)
        elapsed+=dt
        if elapsed<0.05 then return end
        elapsed=0
        local camera=workspace.CurrentCamera
        if not camera then return end
        local quality=player:GetAttribute("KinCityLocalQuality") or "STANDARD"
        local lite=quality=="LITE"
        local distance=if lite then 55 else 110
        local now=os.clock()
        for model,record in pairs(records) do
            if not model:IsDescendantOf(workspace) or not record.root.Parent then remove(model);continue end
            local delta=record.root.Position-camera.CFrame.Position
            local head=record.character:FindFirstChild("Head")
            local firstPerson=record.character==player.Character and head
                and (head.Position-camera.CFrame.Position).Magnitude<2
            local visible=not firstPerson and delta:Dot(delta)<distance*distance
            record.orb.LocalTransparencyModifier=if visible then 0 else 1
            record.emitter.Enabled=visible
            if visible then
                record.emitter.Rate=if lite then 2 elseif quality=="SHOWCASE" then 6 else 4
                record.orb.Transparency=if lite then 0.978 else 0.965+math.sin(now*1.3)*0.009
                if not record.visible then record.emitter:Emit(if lite then 3 else 8) end
            elseif record.visible then record.emitter:Clear() end
            local castAt=record.character:GetAttribute("KingKlownCastAt") or -100
            local age=workspace:GetServerTimeNow()-castAt
            local hum=record.character:FindFirstChildOfClass("Humanoid")
            local casting=age>=0 and age<2.4 and hum and hum.Health>0 and not hum.SeatPart
                and hum.MoveDirection.Magnitude<0.1 and hum.FloorMaterial~=Enum.Material.Air
                and not record.character:FindFirstChildOfClass("Tool")
            for i,mote in ipairs(record.motes) do
                local shown=visible and (not lite or i==1)
                mote.Transparency=if shown then 0.2 else 1
                local trail=mote:FindFirstChildOfClass("Trail")
                trail.Enabled=shown and not lite
                if not shown then trail:Clear() end
                if shown then
                    local angle=now*0.65+i*math.pi*2/3
                    local center=record.root.Position+Vector3.new(0,0.25,0)
                    local radius=3.45
                    if casting and record.spark and age>0.7 then
                        center=record.spark.WorldPosition;radius=0.30
                    end
                    mote.CFrame=CFrame.new(center+Vector3.new(math.cos(angle)*radius,math.sin(angle*1.4)*0.7,math.sin(angle)*radius))
                end
            end
            if visible and casting and age>=0.85 and record.lastCast~=castAt then
                record.lastCast=castAt
                record.emitter:Emit(if lite then 4 else 10)
                if record.spark then record.spark:FindFirstChildOfClass("ParticleEmitter"):Emit(if lite then 5 else 12) end
            end
            record.visible=visible
        end
    end)
end
return Aura
