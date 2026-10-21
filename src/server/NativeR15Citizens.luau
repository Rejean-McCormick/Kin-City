--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Avatars Roblox R15 créés par l'API officielle, SANS identifiant d'avatar externe requis.
-- L'échec d'un chargement Roblox ne doit jamais empêcher l'ouverture de Kin City.
-- Ces citoyens complètent la population stylisée déjà présente dans l'édition du monde.
local Players=game:GetService("Players")
local CollectionService=game:GetService("CollectionService")
local CitizenProps=require(script.Parent.CitizenPropsV21)
local Presence=require(script.Parent.ViewerPresenceV21)
local Nav=require(script.Parent.NeighborhoodNPCNavigation)
local F=require(script.Parent.Factory)
local R15={}
local skins={
    Color3.fromRGB(239,193,145),Color3.fromRGB(157,97,70),Color3.fromRGB(109,71,54),
    Color3.fromRGB(210,158,112),Color3.fromRGB(86,57,42),Color3.fromRGB(192,125,93),
}
local coats={
    Color3.fromRGB(43,115,124),Color3.fromRGB(169,109,71),Color3.fromRGB(111,91,160),
    Color3.fromRGB(71,132,100),Color3.fromRGB(177,146,72),Color3.fromRGB(92,115,146),
}
local roles={"Bibliothécaire","Étudiante","Chercheuse","Médiateur","Artiste","Guide","Inventrice","Archiviste","Citoyenne","Technicien"}
local function description(index)
    local d=Instance.new("HumanoidDescription")
    local skin=skins[(index-1)%#skins+1]
    local coat=coats[(index-1)%#coats+1]
    d.HeadColor=skin
    d.LeftArmColor=coat
    d.RightArmColor=coat
    d.TorsoColor=coat
    d.LeftLegColor=Color3.fromRGB(58,74,86)
    d.RightLegColor=Color3.fromRGB(58,74,86)
    d.HeightScale=0.92+(index%4)*0.055
    d.WidthScale=0.86+(index%3)*0.075
    d.DepthScale=0.95
    d.HeadScale=1
    d.BodyTypeScale=0
    d.ProportionScale=0
    return d
end
local function badger(model,part,title)
    local bb=Instance.new("BillboardGui")
    bb.Name="Métier"
    bb.Size=UDim2.fromOffset(155,30)
    bb.StudsOffset=Vector3.new(0,2.2,0)
    bb.MaxDistance=65
    bb.AlwaysOnTop=false
    bb.Adornee=part
    bb.Parent=part
    local text=Instance.new("TextLabel")
    text.Size=UDim2.fromScale(1,1)
    text.BackgroundColor3=Color3.fromRGB(31,53,60)
    text.BackgroundTransparency=0.26
    text.TextColor3=Color3.fromRGB(247,237,216)
    text.Font=Typography.body()
    text.TextSize=13
    text.Text=title
    text.Parent=bb
    local corner=Instance.new("UICorner")
    corner.CornerRadius=UDim.new(0,8)
    corner.Parent=text
end
local function make(index,parent)
    local desc=description(index)
    local ok,model=pcall(function()
        return Players:CreateHumanoidModelFromDescriptionAsync(desc,Enum.HumanoidRigType.R15)
    end)
    desc:Destroy()
    if not ok or not model then
        warn("Kin City : impossible de charger citoyen R15 "..index,model)
        return nil
    end
    local role=roles[(index-1)%#roles+1]
    model.Name=role.." R15 "..index
    model:SetAttribute("KinR15Citizen",true)
    model:SetAttribute("KinCitizenRole",role)
    local humanoid=model:FindFirstChildOfClass("Humanoid")
    local root=model:FindFirstChild("HumanoidRootPart")
    local head=model:FindFirstChild("Head")
    if not humanoid or not root or not head then model:Destroy();return nil end
    humanoid.WalkSpeed=7+(index%3)
    humanoid.AutoRotate=true -- regarder la direction de MoveTo, sans tween latéral
    humanoid.DisplayDistanceType=Enum.HumanoidDisplayDistanceType.None
    humanoid.BreakJointsOnDeath=false
    root.CanCollide=false
    -- Retirer toute invitation à récupérer une identité ou à déclencher des requêtes externes.
    head:SetAttribute("KinStubInteractionId",string.format("city.r15.%02d.dialogue",index))
    head:SetAttribute("KinStubCapabilityId","future.citizen.dialogue")
    head:SetAttribute("KinStubTitle",role.." — Kin City")
    F.prompt(head,"Parler",role)
    badger(model,head,role)
    model:SetAttribute("KinNPCPhase",index*0.73)
    model:SetAttribute("KinNPCMotion","idle")
    model:SetAttribute("KinNPCActivity","Accueil")
    model.Parent=parent
    CitizenProps.attach(model,role,index)
    CollectionService:AddTag(model,"KinCityAnimatedNPC")
    return model,humanoid,root
end
local function walk(model,humanoid,index,world)
    local quarter=Nav.quarter(index)
    local start=Nav.stop(quarter,index,1)
    model:SetAttribute("KinResidenceQuarter",quarter.id)
    model:PivotTo(CFrame.new(start+Vector3.new(0,2.5,0)))
    local root=model:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then
        pcall(function() root:SetNetworkOwner(nil) end)
    end
    local activities={"Promenade", "Observer", "Lecture", "Accueil", "Rencontre"}
    task.spawn(function()
        local step=1
        while model.Parent and world.Parent and humanoid.Health>0 do
            if not Presence.near(model:GetPivot().Position,200) then
                model:SetAttribute("KinNPCMotion","idle")
                task.wait(2.5)
                continue
            end
            step+=1
            local destination,title=Nav.stop(quarter,index,step)
            model:SetAttribute("KinNPCMotion","walk")
            model:SetAttribute("KinNPCActivity",title)
            local reached=Nav.walkHumanoid(model,humanoid,quarter,destination,world)
            if not model.Parent or not world.Parent then break end
            if not reached then
                model:SetAttribute("KinNPCMotion","idle")
                task.wait(2.0) -- aucun mouvement direct à travers le mobilier
                continue
            end
            local activity=activities[(step+index-2)%#activities+1]
            model:SetAttribute("KinNPCMotion",if activity=="Lecture" then "read" elseif activity=="Accueil" or activity=="Rencontre" then "greet" else "idle")
            model:SetAttribute("KinNPCActivity",activity)
            task.wait(1.5+(index%3)*0.55)
        end
        model:SetAttribute("KinNPCMotion","idle")
    end)
end
function R15.start(world)
    local city=world:FindFirstChild("Ville")
    if not city then return end
    local folder=F.folder(city,"Citoyens Roblox R15")
    -- Quatorze rigs natifs répartis sur les voies publiques, plus de variété sans surcharger la ville.
    task.spawn(function()
        for i=1,14 do
            if not world.Parent then break end
            local model,humanoid=make(i,folder)
            if model and humanoid then walk(model,humanoid,i,world) end
            task.wait(0.35)
        end
    end)
end
return R15
