--!strict
-- Six installations collaboratives aux abords des agoras v12.
-- Deux joueurs distincts activent une sculpture; aucun point ou vote fictif.
local RS=game:GetService("ReplicatedStorage")
local D=require(RS:WaitForChild("KinCityShared"):WaitForChild("CivicDestinations"))
local F=require(script.Parent.Factory)
local Installations={}
local INK=Color3.fromRGB(47,74,85)
local STONE=Color3.fromRGB(226,209,173)
local GOLD=Color3.fromRGB(232,193,115)
local function p(parent,name,cf,x,y,z,w,h,d,color,material,solid)
    local part=F.part(parent,name,Vector3.new(w,h,d),cf*CFrame.new(x,y,z),color,material)
    if solid==false then part.CanCollide=false;part.CanQuery=false;part.CanTouch=false end
    return part
end
local function makeOne(parent,item)
    local m=Instance.new("Model")
    m.Name="Installation collaborative · "..item.title
    m:SetAttribute("KinCoopId",item.id)
    m.Parent=parent
    local base=CFrame.new(item.center_studs[1],0,item.center_studs[3])*CFrame.Angles(0,item.yaw,0)*CFrame.new(33,0,-3)
    local tint=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    p(m,"Plateforme commune",base,0,0.11,0,16,0.45,18,STONE,Enum.Material.Cobblestone)
    p(m,"Dallage de raccordement",base,-9,0.09,0,11,0.2,5,STONE,Enum.Material.Cobblestone)
    for side=1,2 do
        local x=if side==1 then -5.4 else 5.4
        local console=p(m,"Commande du participant "..side,base,x,1.9,-4,2.5,3.5,2.3,INK,Enum.Material.Metal)
        console:SetAttribute("KinCoopAction","participate")
        console:SetAttribute("KinCoopId",item.id)
        console:SetAttribute("KinCoopSide",side)
        F.prompt(console,"Activer en équipe", "2 personnes requises")
        local lamp=p(m,"Voyant du participant",base,x,4.1,-4,1.3,1.3,1.3,Color3.fromRGB(89,132,145),Enum.Material.Neon,false)
        lamp.Shape=Enum.PartType.Ball
        lamp:SetAttribute("KinCoopIndicator",item.id)
        lamp:SetAttribute("KinCoopSide",side)
    end
    for _,x in ipairs({-6.3,6.3}) do
        p(m,"Arc en alliage",base,x,4.7,2.5,0.65,8.7,0.65,GOLD,Enum.Material.Metal)
    end
    p(m,"Poutre de rencontre",base,0,9.1,2.5,13.2,0.65,0.65,GOLD,Enum.Material.Metal)
    local sculpture=Instance.new("Model")
    sculpture.Name="Cœur collaboratif"
    sculpture.Parent=m
    sculpture:SetAttribute("KinCoopSculpture",item.id)
    local pivot=p(sculpture,"Pivot",base,0,5.4,2.5,0.35,0.35,0.35,GOLD,Enum.Material.Metal,false)
    pivot.Transparency=1
    sculpture.PrimaryPart=pivot
    local core=p(sculpture,"Noyau lumineux",base,0,5.4,2.5,4.1,4.1,4.1,tint,Enum.Material.Neon,false)
    core.Shape=Enum.PartType.Ball
    core:SetAttribute("KinCoopCore",item.id)
    local light=Instance.new("PointLight")
    light.Name="Lumière commune";light.Range=22;light.Brightness=0.4;light.Parent=core
    for n=1,5 do
        local angle=n*math.pi*2/5
        local bead=p(sculpture,"Éclat solidaire",base,math.cos(angle)*3.2,5.4,2.5+math.sin(angle)*3.2,1.0,1.0,1.0,GOLD,Enum.Material.Neon,false)
        bead.Shape=Enum.PartType.Ball
    end
    F.sign(m,"Équipe",(base*CFrame.new(0,11.0,2.5)).Position,math.deg(item.yaw),"DEUX PERSONNES · UNE LUMIÈRE",20,2.4).CanCollide=false
    return m
end
function Installations.isReserved(x,z)
    for _,item in ipairs(D) do
        local base=CFrame.new(item.center_studs[1],0,item.center_studs[3])*CFrame.Angles(0,item.yaw,0)*CFrame.new(33,0,-3)
        local point=base:PointToObjectSpace(Vector3.new(x,0,z))
        if math.abs(point.X)<15 and math.abs(point.Z)<13 then return true end
    end
    return false
end
function Installations.make(city)
    local folder=F.folder(city,"Installations coopératives")
    for _,item in ipairs(D) do makeOne(folder,item) end
    folder:SetAttribute("KinCooperativeActivities",#D)
    return folder
end
return Installations
