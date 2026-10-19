--!strict
-- Animation de proximité des PNJ. Le serveur publie l'activité, le client anime
-- uniquement les rigs visibles et proches. Compatible Motor6D / AnimationConstraint.
-- Aucun asset d'animation Roblox requis, aucune modification des avatars joueurs.
local CollectionService=game:GetService("CollectionService")
local RunService=game:GetService("RunService")
local Players=game:GetService("Players")
local Animator={}
local TAG="KinCityAnimatedNPC"
local MAX_DISTANCE=155
local UPDATE_HZ=24
local LOD_CHECK_SECONDS=0.7

local poses={
    walk={shoulder=0.30,hip=0.39,waist=0.045,neck=0.035},
    idle={shoulder=0.035,hip=0,waist=0.025,neck=0.045},
    read={shoulder=0.34,hip=0,waist=0.09,neck=-0.13},
    garden={shoulder=0.48,hip=0.02,waist=0.12,neck=-0.10},
    greet={shoulder=0.55,hip=0,waist=0.035,neck=0.11},
    observe={shoulder=0.06,hip=0,waist=0.02,neck=0.14},
}

local function rigJoints(model:Model)
    local joints={}
    for _,item in ipairs(model:GetDescendants()) do
        if item:IsA("Motor6D") or item:IsA("AnimationConstraint") then
            if item.Name=="RightShoulder" or item.Name=="LeftShoulder" or item.Name=="RightHip" or item.Name=="LeftHip" or item.Name=="Waist" or item.Name=="Neck" then
                joints[item.Name]=item
            end
        end
    end
    return joints
end

function Animator.start()
    local npcs={}
    local function register(model:Instance)
        if not model:IsA("Model") or npcs[model] then return end
        npcs[model]={joints=rigJoints(model),enabled=false}
    end
    for _,model in ipairs(CollectionService:GetTagged(TAG)) do register(model) end
    CollectionService:GetInstanceAddedSignal(TAG):Connect(register)
    CollectionService:GetInstanceRemovedSignal(TAG):Connect(function(model)
        npcs[model]=nil
    end)

    local clock=0
    local lodClock=0
    local function distanceFromViewer(model:Model,camera:Camera?,avatarRoot:BasePart?):number
        local root=model:FindFirstChild("HumanoidRootPart")
        if not root or not root:IsA("BasePart") then return math.huge end
        local cameraDistance=if camera then (root.Position-camera.CFrame.Position).Magnitude else math.huge
        local playerDistance=if avatarRoot then (root.Position-avatarRoot.Position).Magnitude else math.huge
        return math.min(cameraDistance,playerDistance)
    end

    RunService.PreSimulation:Connect(function(dt)
        clock+=dt
        lodClock+=dt
        if lodClock>=LOD_CHECK_SECONDS then
            lodClock=0
            local camera=workspace.CurrentCamera
            local character=Players.LocalPlayer.Character
            local root=character and character:FindFirstChild("HumanoidRootPart")
            local avatarRoot=if root and root:IsA("BasePart") then root else nil
            for model,record in pairs(npcs) do
                if not model.Parent then
                    npcs[model]=nil
                else
                    if next(record.joints)==nil then record.joints=rigJoints(model) end
                    local visible=distanceFromViewer(model,camera,avatarRoot)<MAX_DISTANCE
                    if record.enabled and not visible then
                        for _,joint in pairs(record.joints) do
                            if joint.Parent then joint.Transform=CFrame.identity end
                        end
                    end
                    record.enabled=visible
                end
            end
        end
        if clock<1/UPDATE_HZ then return end
        clock=0
        local now=workspace:GetServerTimeNow()
        for model,record in pairs(npcs) do
            if record.enabled then
                local state=model:GetAttribute("KinNPCMotion") or "idle"
                local preset=poses[state] or poses.idle
                local phase=now*(state=="walk" and 7.0 or 2.1)+(model:GetAttribute("KinNPCPhase") or 0)
                local swing=math.sin(phase)
                for name,joint in pairs(record.joints) do
                    if joint.Parent then
                        local offset=CFrame.identity
                        if name=="RightShoulder" then
                            offset=CFrame.Angles((state=="walk" and swing or 0.30+0.12*swing)*preset.shoulder,0,-0.04)
                        elseif name=="LeftShoulder" then
                            offset=CFrame.Angles((state=="walk" and -swing or 0.22-0.12*swing)*preset.shoulder,0,0.04)
                        elseif name=="RightHip" then
                            offset=CFrame.Angles(-swing*preset.hip,0,0)
                        elseif name=="LeftHip" then
                            offset=CFrame.Angles(swing*preset.hip,0,0)
                        elseif name=="Waist" then
                            offset=CFrame.Angles(preset.waist+0.018*swing,0,0)
                        elseif name=="Neck" then
                            offset=CFrame.Angles(preset.neck,0,0.06*math.sin(phase*0.35))
                        end
                        -- Nos PNJ n'utilisent aucun AnimationTrack : remplacer l'offset
                        -- évite toute accumulation d'angle sur les deux types de joint.
                        joint.Transform=offset
                    end
                end
            end
        end
    end)
end
return Animator
