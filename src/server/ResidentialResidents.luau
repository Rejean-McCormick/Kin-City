--!strict
-- Douze habitants R15 supplémentaires, répartis dans les six îlots.
-- Le chargement des avatars est facultatif : la ville reste accessible en cas d'échec.
-- Les conversations sont des stubs. Le mouvement est purement local.
local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local CitizenProps=require(script.Parent.CitizenPropsV21)
local Presence=require(script.Parent.ViewerPresenceV21)
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Destinations=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local F=require(script.Parent.Factory)
local Residents={}
local roles={"Jardinière", "Résident", "Architecte", "Voisine", "Artisan", "Guide"}
local skin={
    Color3.fromRGB(225,172,128), Color3.fromRGB(124,82,59),
    Color3.fromRGB(186,131,101), Color3.fromRGB(241,193,155),
    Color3.fromRGB(93,63,48), Color3.fromRGB(214,153,112),
}
local clothes={
    Color3.fromRGB(99,160,120), Color3.fromRGB(72,115,148),
    Color3.fromRGB(190,136,107), Color3.fromRGB(132,104,164),
    Color3.fromRGB(169,141,91), Color3.fromRGB(75,151,143),
}
local function newResident(folder,index,quarter)
    local d=Instance.new("HumanoidDescription")
    local color=skin[(index-1)%#skin+1]
    local shirt=clothes[(index-1)%#clothes+1]
    d.HeadColor=color
    d.LeftArmColor=shirt;d.RightArmColor=shirt;d.TorsoColor=shirt
    d.LeftLegColor=Color3.fromRGB(68,77,91)
    d.RightLegColor=Color3.fromRGB(68,77,91)
    d.HeightScale=0.96+(index%3)*0.05
    d.WidthScale=0.92+(index%2)*0.08
    d.DepthScale=0.96
    local ok,model=pcall(function()
        return Players:CreateHumanoidModelFromDescriptionAsync(d,Enum.HumanoidRigType.R15)
    end)
    d:Destroy()
    if not ok or not model then
        warn("Kin City : habitant résident R15 indisponible : ",index,model)
        return nil
    end
    local hum=model:FindFirstChildOfClass("Humanoid")
    local root=model:FindFirstChild("HumanoidRootPart")
    local head=model:FindFirstChild("Head")
    if not hum or not root or not head then model:Destroy();return nil end
    local role=roles[(index-1)%#roles+1]
    model.Name=role.." — "..quarter.title
    model:SetAttribute("KinResidentId",string.format("kin.resident.%02d",index))
    model:SetAttribute("KinResidenceQuarter",quarter.id)
    hum.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
    hum.WalkSpeed=5+(index%3)
    root.CanCollide=false
    head:SetAttribute("KinStubInteractionId",string.format("kin.resident.%02d.future",index))
    head:SetAttribute("KinStubCapabilityId","future.residential.dialogue")
    head:SetAttribute("KinStubTitle",role.." · "..quarter.title)
    F.prompt(head,"Parler",role)
    model:SetAttribute("KinNPCPhase",index*1.13)
    model:SetAttribute("KinNPCMotion","idle")
    model:SetAttribute("KinNPCActivity","Repos")
    model.Parent=folder
    CitizenProps.attach(model,role,index+10)
    CollectionService:AddTag(model,"KinCityAnimatedNPC")
    pcall(function() root:SetNetworkOwner(nil) end)
    return model,hum
end
-- Les habitants n'errent plus au hasard : ils suivent une petite routine publique.
-- Points contrôlés dans la cour dégagée, sans navigation vers les maisons closes.
-- Les rôles et les activités visibles sont purement narratifs et locaux.
local tasks={"Promenade", "Jardin partagé", "Lecture", "Rencontre", "Observation", "Repos"}
local function activityBadge(model,role)
    local head=model:FindFirstChild("Head")
    if not head then return nil end
    local gui=Instance.new("BillboardGui")
    gui.Name="Routine quotidienne"
    gui.Size=UDim2.fromOffset(176,43)
    gui.StudsOffset=Vector3.new(0,2.8,0)
    gui.AlwaysOnTop=false;gui.MaxDistance=55;gui.Adornee=head;gui.Parent=head
    local text=Instance.new("TextLabel")
    text.Size=UDim2.fromScale(1,1);text.TextWrapped=true
    text.BackgroundColor3=Color3.fromRGB(34,66,65)
    text.BackgroundTransparency=0.24
    text.TextColor3=Color3.fromRGB(245,236,204)
    text.Font=Enum.Font.GothamMedium;text.TextSize=12
    text.Text=role; text.Parent=gui
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,7);corner.Parent=text
    return text
end
local function wander(model,hum,world,quarter,index)
    local center=Vector3.new(quarter.center_studs[1],2.8,quarter.center_studs[3])
    local radius=13.3
    local phase=index*1.87
    local role=model.Name
    local badge=activityBadge(model,role)
    model:PivotTo(CFrame.new(center+Vector3.new(math.cos(phase)*radius,0,math.sin(phase)*radius)))
    task.spawn(function()
        local round=0
        while model.Parent and world.Parent and hum.Health>0 do
            if not Presence.near(center,190) then
                model:SetAttribute("KinNPCMotion","idle")
                task.wait(3)
                continue
            end
            round+=1
            phase+=math.pi/3
            local goal=center+Vector3.new(math.cos(phase)*radius,0,math.sin(phase)*radius)
            local clock=game:GetService("Lighting").ClockTime
            local work=if clock<8 then "Ouverture de quartier" elseif clock>=19 then "Promenade du soir" else tasks[((index+round-2)%#tasks)+1]
            model:SetAttribute("KinResidentActivity",work)
            if badge then badge.Text=work.." · "..role end
            model:SetAttribute("KinNPCActivity",work)
            model:SetAttribute("KinNPCMotion","walk")
            hum:MoveTo(goal)
            local finished=false
            local connection=hum.MoveToFinished:Connect(function() finished=true end)
            local deadline=os.clock()+9
            while not finished and os.clock()<deadline and model.Parent and world.Parent and hum.Health>0 do
                task.wait(0.25)
            end
            connection:Disconnect()
            if model.Parent then
                local motion=if work=="Lecture" then "read" elseif work=="Jardin partagé" then "garden" elseif work=="Rencontre" then "greet" elseif work=="Observation" then "observe" else "idle"
                model:SetAttribute("KinNPCMotion",motion)
                -- Pause devant une place ou un jardin : le lieu n'est pas traversé au pas de course.
                local pause=if round%4==0 then 6.0 else 1.8+(index%3)
                task.wait(pause)
            end
        end
    end)
end
function Residents.start(world)
    local city=world:FindFirstChild("Ville")
    if not city then return end
    local folder=F.folder(city,"Habitants R15 des quartiers")
    task.spawn(function()
        for index=1,12 do
            if not world.Parent then return end
            local quarter=Destinations[math.ceil(index/2)]
            if quarter then
                local model,hum=newResident(folder,index,quarter)
                if model and hum then wander(model,hum,world,quarter,index) end
            end
            task.wait(0.55)
        end
    end)
end
return Residents
