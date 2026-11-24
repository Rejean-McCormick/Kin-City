-- KC36 : INSTALLATION SOURCE POPULATION B10/B09
-- Command Bar Studio, Play arrêté ; ne reconstruit pas la scène.
-- 24 PNJ procéduraux + 18 PNJ R15 maximum, 7 sites par secteur.
-- Le Package Art Déco et les neuf contributions restent inchangés.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Arrêter Play")
assert(game.PlaceId==0,"Utiliser une Place locale KC36 non publiée")
local SS=game:GetService("ServerStorage")
local SSS=game:GetService("ServerScriptService")
local library=assert(SS:FindFirstChild("KinCityArtDecoLibrary"),"Package central manquant")
assert(library:FindFirstChildOfClass("PackageLink"),"PackageLink central absent")
assert(library:GetAttribute("KinSourceCount")==121,"Assets centraux incomplets")
local runtime=assert(SSS:FindFirstChild("KinCityRuntime"),"KinCityRuntime absent")
local world=assert(workspace:FindFirstChild("KinCityGenerated"),"Ville absente")
assert(world:GetAttribute("KinBuildState")=="Ready","Ville non prête")
local backupName="KC36PopulationSourceBackup_v1"
local originals={}
for _,name in ipairs({"Citizens","NativeR15Citizens","CityGenerator"}) do
    local m=assert(runtime:FindFirstChild(name),"Module manquant : "..name)
    assert(m:IsA("ModuleScript"),"Module incorrect : "..name)
    originals[name]=m.Source
end
local previous=runtime:FindFirstChild("CityPopulationV36")
if previous then assert(previous:IsA("ModuleScript"),"CityPopulationV36 inattendu") end
if runtime:GetAttribute("KC36PopulationRevision")=="KC36-POPULATION-AVENUES-1" then
    print("KC36 POPULATION : déjà installée, aucune modification")
    return
end

local source_CityPopulationV36=[========[
--!strict
-- KC36 B10 / B09: positions de population déterministes dans les SIX avenues actives.
-- Les îlots ResidentialQuarters v30/v31 ne sont plus le référentiel de placement.
-- Les bâtiments canoniques et une courte enveloppe de mouvement sont réservés.
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Districts=require(Shared:WaitForChild("HexagonalDistricts"))
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Pop={}
Pop.REVISION="KC36-POPULATION-AVENUES-1"
Pop.PROCEDURAL_PER_SECTOR=4
Pop.R15_PER_SECTOR=3
local RADII={stylized={105,185,275,370},r15={145,235,335}}
local DELTAS={0}
for delta=9,351,9 do
    table.insert(DELTAS,delta)
    table.insert(DELTAS,-delta)
end
local LATERALS={-4.0,4.0,-6.5,6.5}

local function collidesStructure(x:number,z:number,pad:number):boolean
    for _,b in ipairs(Plan.structures) do
        local dx=x-b.center_studs[1]
        local dz=z-b.center_studs[3]
        local yaw=math.rad(b.yaw_degrees)
        local lx=math.cos(yaw)*dx-math.sin(yaw)*dz
        local lz=math.sin(yaw)*dx+math.cos(yaw)*dz
        if math.abs(lx)<b.footprint_studs[1]/2+pad
            and math.abs(lz)<b.footprint_studs[2]/2+pad then
            return true
        end
    end
    return false
end

local cache={stylized={},r15={}}
local assigned={}
local function reserved(x:number,z:number):boolean
    for _,p in ipairs(assigned) do
        if (p-Vector3.new(x,0,z)).Magnitude<17 then return true end
    end
    return false
end
local function planned(kind:string,index:number)
    local n=if kind=="stylized" then Pop.PROCEDURAL_PER_SECTOR else Pop.R15_PER_SECTOR
    assert(index>=1 and index<=n*#Districts.sections and index%1==0,"Indice PNJ invalide")
    local sectorIndex=(index-1)%#Districts.sections+1
    local tier=math.floor((index-1)/#Districts.sections)+1
    local section=Districts.sections[sectorIndex]
    local axis=Vector3.new(section.x,0,section.z)
    local tangent=Vector3.new(-axis.Z,0,axis.X)
    local radius=RADII[kind][tier]
    assert(radius,"Rayon PNJ inexistant")
    -- Les personnages sont sur les avenues natives de 19 studs.
    -- Les 14 studs de leur petit circuit sont validés contre les façades.
    for _,delta in ipairs(DELTAS) do
        local r=radius+delta
        if r>=88 and r<=417 then
            local offsetOrder=if (index+tier)%2==0 then {1,2,3,4} else {2,1,4,3}
            for _,j in ipairs(offsetOrder) do
                local point=axis*r+tangent*LATERALS[j]
                local safe=true
                for _,step in ipairs({-15,0,15}) do
                    local p=point+axis*step
                    if collidesStructure(p.X,p.Z,8) then safe=false;break end
                end
                if safe and not reserved(point.X,point.Z) then
                    return {
                        position=point,axis=axis,section=section,
                        index=index,kind=kind,radius=r,sector_index=sectorIndex,
                        itinerary_half_length=12,
                    }
                end
            end
        end
    end
    error("KC36 POPULATION : aucune parcelle piétonne libre pour "..kind.." #"..index)
end

-- Attribution déterministe globale : ordre immuable, sans doublons entre styles.
for _,kind in ipairs({"stylized","r15"}) do
    local limit=if kind=="stylized" then Pop.PROCEDURAL_PER_SECTOR else Pop.R15_PER_SECTOR
    for index=1,limit*#Districts.sections do
        local record=planned(kind,index)
        cache[kind][index]=record
        table.insert(assigned,record.position)
    end
end

function Pop.site(kind:string,index:number)
    assert(kind=="stylized" or kind=="r15","Type PNJ inconnu")
    return assert(cache[kind][index],"Indice ou type PNJ hors contrat")
end

function Pop.safeWaypoint(site,point:Vector3):boolean
    local d=point-site.position
    local parallel=d:Dot(site.axis)
    local tangent=Vector3.new(-site.axis.Z,0,site.axis.X)
    local lateral=math.abs(d:Dot(tangent))
    return math.abs(parallel)<=20 and lateral<=10
        and not collidesStructure(point.X,point.Z,5)
end

function Pop.audit():{[string]:number}
    local stats={stylized=0,r15=0,sectors=#Districts.sections}
    for _,kind in ipairs({"stylized","r15"}) do
        local per=if kind=="stylized" then Pop.PROCEDURAL_PER_SECTOR else Pop.R15_PER_SECTOR
        for i=1,per*#Districts.sections do
            local s=Pop.site(kind,i)
            assert(s and Pop.safeWaypoint(s,s.position),"Placement PNJ bloqué")
            stats[kind]+=1
        end
    end
    return stats
end
return Pop

]========]

local source_Citizens=[========[
--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Citoyens procéduraux : coiffures, teintes, vêtements, marche articulée et interactions.
-- Aucun avatar externe, aucune identité kOA et aucun ID asset obligatoire.
local F=require(script.Parent.Factory)
local Presence=require(script.Parent.ViewerPresenceV21)
local Nav=require(script.Parent.NeighborhoodNPCNavigation)
local Population=require(script.Parent.CityPopulationV36)
local Citizens={}
local outfits={
    {"Bibliothécaire","Savoirs"},{"Guide du savoir","Accueil"},{"Étudiante","Université"},
    {"Chercheur","Innovation"},{"Artisane","Création"},{"Médiateur","Éthique"},
    {"Curatrice","Musée"},{"Citoyen","Place publique"},{"Architecte","Urbanisme"},
    {"Conseillère","Hôtel de ville"},{"Historien","Archives"},{"Technicienne","Orgo"},
}
local tones={Color3.fromRGB(239,196,155),Color3.fromRGB(194,137,97),Color3.fromRGB(105,69,55),Color3.fromRGB(158,106,77),Color3.fromRGB(224,173,136),Color3.fromRGB(85,56,49)}
local coats={Color3.fromRGB(53,127,130),Color3.fromRGB(115,82,142),Color3.fromRGB(173,99,72),Color3.fromRGB(76,132,103),Color3.fromRGB(182,140,75),Color3.fromRGB(69,104,153),Color3.fromRGB(175,105,116)}
local hairs={Color3.fromRGB(56,44,39),Color3.fromRGB(149,108,66),Color3.fromRGB(203,164,108),Color3.fromRGB(81,63,56),Color3.fromRGB(42,42,57)}
local dark=Color3.fromRGB(43,58,75)
local function makeCitizen(parent,index)
    local named=outfits[(index-1)%#outfits+1]
    local name=string.format("%s %02d",named[1],index)
    local model=Instance.new("Model")
    model.Name=name
    model:SetAttribute("KinCitizen",true)
    model:SetAttribute("CitizenIndex",index)
    model.Parent=parent
    local skin=tones[(index*7-1)%#tones+1]
    local coat=coats[(index*5-1)%#coats+1]
    local hair=hairs[(index*3-1)%#hairs+1]
    local root=F.part(model,"Root",Vector3.new(0.7,0.7,0.7),CFrame.new(),Color3.new(1,1,1))
    root.Transparency=1;root.CanCollide=false;root.CanTouch=false
    model.PrimaryPart=root
    local function make(name,size,offset,color,mat)
        local p=F.part(model,name,size,CFrame.new(offset),color,mat or Enum.Material.SmoothPlastic)
        p.CanCollide=false;p.CanTouch=false
        return p
    end
    make("Chemise",Vector3.new(2.35,2.9,1.3),Vector3.new(0,3.4,0),coat)
    make("Col",Vector3.new(1,0.5,1.4),Vector3.new(0,4.9,0),Color3.fromRGB(233,229,211))
    make("Cou",Vector3.new(0.75,0.5,0.72),Vector3.new(0,5.25,0),skin)
    local head=make("Visage",Vector3.new(1.65,1.85,1.56),Vector3.new(0,6.1,0),skin)
    head.Shape=Enum.PartType.Ball
    for _,s in ipairs({-1,1}) do
        local eye=make("Oeil",Vector3.new(0.19,0.16,0.09),Vector3.new(s*0.34,6.23,-0.77),dark)
        eye.Shape=Enum.PartType.Ball
    end
    if index%4==0 then
        make("Chapeau",Vector3.new(2.1,0.35,2.1),Vector3.new(0,7.18,0),hair)
        make("Calotte",Vector3.new(1.55,0.7,1.5),Vector3.new(0,7.6,0),hair)
    elseif index%3==0 then
        local cap=make("Coiffure longue",Vector3.new(1.8,1.2,1.6),Vector3.new(0,6.78,0.18),hair)
        cap.CanCollide=false
    else
        make("Coiffure",Vector3.new(1.75,0.65,1.63),Vector3.new(0,6.96,0),hair)
    end
    local arms={}
    local legs={}
    for _,s in ipairs({-1,1}) do
        local a=make(s<0 and "Bras gauche" or "Bras droit",Vector3.new(0.72,2.5,0.85),Vector3.new(s*1.58,3.43,0),skin)
        table.insert(arms,a)
        local b=make(s<0 and "Jambe gauche" or "Jambe droite",Vector3.new(0.95,2.5,1),Vector3.new(s*0.6,1.2,0),dark)
        table.insert(legs,b)
        make(s<0 and "Chaussure gauche" or "Chaussure droite",Vector3.new(0.96,0.45,1.3),Vector3.new(s*0.6,0.25,-0.15),Color3.fromRGB(50,50,52))
    end
    -- Visage expressif et détails de tenue ; aucune texture ou ressource distante.
    make("Sourcil gauche",Vector3.new(0.29,0.07,0.08),Vector3.new(-0.35,6.51,-0.75),hair)
    make("Sourcil droit",Vector3.new(0.29,0.07,0.08),Vector3.new(0.35,6.51,-0.75),hair)
    make("Sourire",Vector3.new(0.34,0.07,0.06),Vector3.new(0,5.78,-0.79),Color3.fromRGB(130,72,72))
    make("Ceinture",Vector3.new(2.28,0.24,1.35),Vector3.new(0,2.15,0),Color3.fromRGB(39,69,70))
    make("Boucle opaline",Vector3.new(0.34,0.25,0.10),Vector3.new(0,2.15,-0.72),Color3.fromRGB(197,244,240),Enum.Material.Metal)
    make("Revers gauche",Vector3.new(0.32,1.20,0.12),Vector3.new(-0.58,4.13,-0.71),Color3.fromRGB(197,244,240))
    make("Revers droit",Vector3.new(0.32,1.20,0.12),Vector3.new(0.58,4.13,-0.71),Color3.fromRGB(197,244,240))
    for _,side in ipairs({-1,1}) do
        make(side<0 and "Manche gauche" or "Manche droite",Vector3.new(0.82,1.05,0.90),Vector3.new(side*1.58,4.15,0),coat)
    end
    if index%5==1 then
        make("Sac",Vector3.new(2.1,2,0.8),Vector3.new(0,3.1,1),Color3.fromRGB(123,84,62))
    elseif index%5==3 then
        make("Badge",Vector3.new(0.55,0.65,0.12),Vector3.new(-0.65,4,-0.75),Color3.fromRGB(246,204,116))
    end
    local marker=Instance.new("BillboardGui")
    marker.Name="Nom"
    marker.Size=UDim2.fromOffset(170,40)
    marker.StudsOffset=Vector3.new(0,2.0,0)
    marker.MaxDistance=70
    marker.AlwaysOnTop=false
    marker.Adornee=head
    marker.Parent=head
    local txt=Instance.new("TextLabel")
    txt.Size=UDim2.fromScale(1,1)
    txt.BackgroundColor3=Color3.fromRGB(26,48,56)
    txt.BackgroundTransparency=0.23
    txt.TextColor3=Color3.fromRGB(249,248,233)
    txt.TextSize=13
    txt.Font=Typography.body()
    txt.Text=name
    txt.Parent=marker
    local rounded=Instance.new("UICorner");rounded.CornerRadius=UDim.new(0,9);rounded.Parent=txt
    head:SetAttribute("KinStubInteractionId",string.format("citizen.%03d.dialogue",index))
    head:SetAttribute("KinStubCapabilityId","future.citizen.dialogue")
    head:SetAttribute("KinStubTitle",named[1].." — "..named[2])
    F.prompt(head,"Parler",named[1])
    return model,arms,legs
end
function Citizens.make(parent)
    local existing=parent:FindFirstChild("Citoyens")
    if existing and existing:GetAttribute("KinNPCPopulationRevision")==Population.REVISION then return existing end
    -- Construire la nouvelle population AVANT d'enlever la précédente.
    local stage=F.folder(parent,"Citoyens_KC36_PREPARE")
    local ok,err=pcall(function()
        for i=1,Population.PROCEDURAL_PER_SECTOR*6 do
            local site=Population.site("stylized",i)
            local model=makeCitizen(stage,i)
            model:SetAttribute("KinResidenceQuarter",site.section.key)
            model:SetAttribute("KinNPCActivity","Promenade de l'avenue")
            model:SetAttribute("KinNPCAnchor",site.position)
            local pos=site.position+Vector3.new(0,0.55,0)
            model:PivotTo(CFrame.lookAt(pos,pos+site.axis))
        end
    end)
    if not ok then stage:Destroy();error(err) end
    stage:SetAttribute("KinNPCPopulationRevision",Population.REVISION)
    if existing then existing:Destroy() end
    stage.Name="Citoyens"
    return stage
end
-- Les PNJ primitifs sont ancrés et n'utilisent pas Humanoid:MoveTo. On avance
-- sur une tangente à vitesse constante, puis on aligne le regard sur ce vecteur.
-- Les membres pivotent autour de l'épaule/hanche : ni glissade latérale ni
-- jambes/chaussures laissées en arrière durant le déplacement.
local function animate(model,frame,phase,walking)
    local swing=if walking then math.sin(phase)*0.42 else 0
    for i,side in ipairs({-1,1}) do
        local armAngle=swing*(if i==1 then 1 else -1)
        local legAngle=swing*(if i==1 then -1 else 1)
        local shoulder=frame*CFrame.new(side*1.58,4.48,0)*CFrame.Angles(armAngle,0,0)
        local hip=frame*CFrame.new(side*0.6,2.35,0)*CFrame.Angles(legAngle,0,0)
        local arm=model:FindFirstChild(if i==1 then "Bras gauche" else "Bras droit")
        local sleeve=model:FindFirstChild(if i==1 then "Manche gauche" else "Manche droite")
        local leg=model:FindFirstChild(if i==1 then "Jambe gauche" else "Jambe droite")
        local shoe=model:FindFirstChild(if i==1 then "Chaussure gauche" else "Chaussure droite")
        if arm then arm.CFrame=shoulder*CFrame.new(0,-1.05,0) end
        if sleeve then sleeve.CFrame=shoulder*CFrame.new(0,-0.33,0) end
        if leg then leg.CFrame=hip*CFrame.new(0,-1.15,0) end
        if shoe then shoe.CFrame=hip*CFrame.new(0,-2.10,-0.15) end
    end
end
local function face(position,tangent)
    return CFrame.lookAt(position,position+tangent)
end
function Citizens.start(world)
    local city=world:FindFirstChild("Ville")
    if not city then return end
    -- WorldBuilder peut réutiliser une scène KC35 : la population est rattrapée
    -- ici si le générateur d'édition n'avait pas encore les nouveaux PNJ.
    local folder=Citizens.make(city)
    local started=0
    for _,model in ipairs(folder:GetChildren()) do
        if model:IsA("Model") then
            local index=model:GetAttribute("CitizenIndex")
            if typeof(index)=="number" then
                local site=Population.site("stylized",index)
                started+=1
                task.spawn(function()
                    local offset=if index%2==0 then 8 else -8
                    local goalSign=if index%2==0 then -1 else 1
                    local last=os.clock()
                    local phase=index*0.35
                    while model.Parent==folder and world.Parent do
                        local now=os.clock()
                        local dt=math.clamp(now-last,0,0.12)
                        last=now
                        if not Presence.near(model:GetPivot().Position,190) then
                            model:SetAttribute("KinNPCMotion","idle")
                            task.wait(0.7)
                            continue
                        end
                        local position=model:GetPivot().Position
                        local current=(position-site.position):Dot(site.axis)
                        local goal=goalSign*site.itinerary_half_length
                        local delta=goal-current
                        if math.abs(delta)<0.65 then
                            goalSign=-goalSign
                            model:SetAttribute("KinNPCMotion","idle")
                            task.wait(1.5+(index%4)*0.4)
                        else
                            local step=math.min(math.abs(delta),7*dt)
                            local motion=site.axis*(if delta>0 then step else -step)
                            if Nav.blockedAhead(model,position,motion,world) then
                                goalSign=-goalSign
                                model:SetAttribute("KinNPCMotion","idle")
                                task.wait(1.2)
                            else
                                local nextPos=position+motion
                                if Population.safeWaypoint(site,nextPos) then
                                    local frame=face(nextPos,motion.Unit)
                                    model:PivotTo(frame)
                                    phase+=step*1.4
                                    animate(model,frame,phase,true)
                                    model:SetAttribute("KinNPCMotion","walk")
                                else
                                    goalSign=-goalSign
                                end
                                task.wait(0.09)
                            end
                        end
                    end
                end)
            end
        end
    end
    print("KC36 POPULATION :",started,"citoyens stylisés répartis sur 6 avenues")
end
return Citizens

]========]

local source_NativeR15Citizens=[========[
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
local Population=require(script.Parent.CityPopulationV36)
local PathfindingService=game:GetService("PathfindingService")
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
-- Déplacements courts sur la voie autorisée, jamais vers les anciens îlots.
-- Aucun MoveTo direct traversant les structures en cas d'échec de Pathfinding.
local function travel(model,humanoid,site,goal,world)
    local root=model:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    local path=PathfindingService:CreatePath({
        AgentRadius=2.5,AgentHeight=6,AgentCanJump=false,AgentCanClimb=false,
        WaypointSpacing=3,
    })
    local ok=pcall(function()
        path:ComputeAsync(root.Position,goal+Vector3.new(0,2.4,0))
    end)
    if not ok or path.Status~=Enum.PathStatus.Success then return false end
    local points=path:GetWaypoints()
    if #points<2 or #points>32 then return false end
    for _,waypoint in ipairs(points) do
        if waypoint.Action==Enum.PathWaypointAction.Jump
            or not Population.safeWaypoint(site,waypoint.Position) then return false end
    end
    for i=2,#points do
        if not model.Parent or not world.Parent or humanoid.Health<=0 then return false end
        local finished,reached=false,false
        local connection=humanoid.MoveToFinished:Connect(function(success)
            finished=true;reached=success
        end)
        humanoid:MoveTo(points[i].Position)
        local deadline=os.clock()+6
        while not finished and os.clock()<deadline and model.Parent and world.Parent do
            task.wait(0.1)
        end
        connection:Disconnect()
        if not reached then humanoid:MoveTo(root.Position);return false end
    end
    return true
end

local function walk(model,humanoid,index,world)
    local site=Population.site("r15",index)
    model:SetAttribute("KinResidenceQuarter",site.section.key)
    model:SetAttribute("KinNPCAnchor",site.position)
    model:PivotTo(CFrame.new(site.position+Vector3.new(0,3.6,0)))
    local root=model:FindFirstChild("HumanoidRootPart")
    if root and root:IsA("BasePart") then
        pcall(function() root:SetNetworkOwner(nil) end)
    end
    task.spawn(function()
        local direction=if index%2==0 then 1 else -1
        while model.Parent and world.Parent and humanoid.Health>0 do
            if not Presence.near(site.position,200) then
                model:SetAttribute("KinNPCMotion","idle")
                task.wait(2)
                continue
            end
            local destination=site.position+site.axis*(direction*site.itinerary_half_length)
            model:SetAttribute("KinNPCMotion","walk")
            model:SetAttribute("KinNPCActivity","Promenade de "..site.section.name)
            local reached=travel(model,humanoid,site,destination,world)
            model:SetAttribute("KinNPCMotion","idle")
            if reached then direction=-direction end
            task.wait(if reached then 2.5+(index%3) else 3.5)
        end
        model:SetAttribute("KinNPCMotion","idle")
    end)
end

function R15.start(world)
    local city=world:FindFirstChild("Ville")
    if not city then return end
    local previous=city:FindFirstChild("Citoyens Roblox R15")
    if previous and previous:GetAttribute("KinNPCPopulationRevision")==Population.REVISION then return end
    local folder=F.folder(city,"Citoyens Roblox R15")
    folder:SetAttribute("KinNPCPopulationRevision",Population.REVISION)
    if previous then previous.Name="Citoyens R15 anciens";previous:Destroy() end
    task.spawn(function()
        local count=0
        for i=1,Population.R15_PER_SECTOR*6 do
            if not world.Parent then break end
            local model,humanoid=make(i,folder)
            if model and humanoid then
                walk(model,humanoid,i,world)
                count+=1
            end
            task.wait(0.4)
        end
        print("KC36 POPULATION :",count,"R15 chargés sur 18 prévus; 6 secteurs")
    end)
end
return R15

]========]

local source_CityGenerator=[========[
--!strict
local Factory=require(script.Parent.Factory)
local ArtDecoProps=require(script.Parent.ArtDecoProps)
local ArtDecoDistricts=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared").HexagonalDistricts)
local FacadeGenerator=require(script.Parent.FacadeGenerator)
local UrbanDetails=require(script.Parent.UrbanDetails)
local Citizens=require(script.Parent.Citizens)
local DistrictLandmarks=require(script.Parent.DistrictLandmarks)
local Wildlife=require(script.Parent.Wildlife)
local PromenadeLife=require(script.Parent.PromenadeLife)
local OutdoorAtmosphere=require(script.Parent.OutdoorAtmosphere)
local InstitutionForecourts=require(script.Parent.InstitutionForecourts)
local ScenicCoast=require(script.Parent.ScenicCoast)
local PedestrianWayfinding=require(script.Parent.PedestrianWayfinding)
local WaterfrontDistrict=require(script.Parent.WaterfrontDistrict)
local ArtisanStreets=require(script.Parent.ArtisanStreets)
local InteractiveGardens=require(script.Parent.InteractiveGardens)
local LearningConservatories=require(script.Parent.LearningConservatories)
local DiscoveryPromenade=require(script.Parent.DiscoveryPromenade)
local OuterIslands=require(script.Parent.OuterIslands)
local MarinaDistrict=require(script.Parent.MarinaDistrict)
local IslandAnnexes=require(script.Parent.IslandAnnexes)
local IslandFootpaths=require(script.Parent.IslandFootpaths)
local ResidentialQuarters=require(script.Parent.ResidentialQuarters)
local CommunityBuildings=require(script.Parent.CommunityBuildings)
local IntermodalHub=require(script.Parent.IntermodalHub)
local CivicStages=require(script.Parent.CivicStages)
local PromenadeCommerce=require(script.Parent.PromenadeCommerce)
local SecondaryStreets=require(script.Parent.SecondaryStreets)
local CooperativeInstallations=require(script.Parent.CooperativeInstallations)
local StationArcades=require(script.Parent.StationArcades)
local PublicWorkshops=require(script.Parent.PublicWorkshops)
local CrystalPublic=require(script.Parent.CrystalPublic)
local OpalWayfindingV19=require(script.Parent.OpalWayfindingV19)
local BotanicalKitV20=require(script.Parent.BotanicalKitV20)
local CrystalRestStopsV22=require(script.Parent.CrystalRestStopsV22)
local CrystalLandingsV24=require(script.Parent.CrystalLandingsV24)
local GroundCompatibility=require(script.Parent.GroundCompatibility)
local KoaliUrbanism=require(script.Parent.KoaliUrbanism)
local HexagonalHeart=require(script.Parent.HexagonalHeart)
local DistrictChromatics=require(script.Parent.DistrictChromatics)
local EkohHalo=require(script.Parent.EkohHalo)
local Spatial=require(script.Parent.Spatial)
local CityGenerator={}

local function nearestBuildings(x,z,structures)
    for _,b in ipairs(structures) do
        local cx,_,cz=table.unpack(b.center_studs)
        local yaw=math.rad(b.yaw_degrees)
        local dx=x-cx
        local dz=z-cz
        local localX=math.cos(yaw)*dx-math.sin(yaw)*dz
        local localZ=math.sin(yaw)*dx+math.cos(yaw)*dz
        if math.abs(localX)<b.footprint_studs[1]/2+14 and math.abs(localZ)<b.footprint_studs[2]/2+14 then return true end
    end
    return false
end

local function distanceToPath(x,z,path)
    local p=Vector3.new(x,0,z)
    local nearest=math.huge
    for i=2,#path.path_xyz_studs do
        local a=path.path_xyz_studs[i-1]
        local b=path.path_xyz_studs[i]
        local av=Vector3.new(a[1],0,a[3])
        local bv=Vector3.new(b[1],0,b[3])
        local segment=bv-av
        if segment.Magnitude>0.1 then
            local t=math.clamp((p-av):Dot(segment)/segment:Dot(segment),0,1)
            nearest=math.min(nearest,(p-(av+segment*t)).Magnitude)
        end
    end
    return nearest
end
local function tree(parent,x,z,seed)
    -- Only sites already cleared by the city's path/forecourt exclusion tests.
    if seed%9==0 then
        local section=ArtDecoDistricts.nearestAxis(x,z)
        local imported=ArtDecoProps.environment(parent,"palm",CFrame.new(x,0,z),if section then section.key else nil)
        if imported then return imported end
    end
    return BotanicalKitV20.tree(parent,x,z,seed)
end

-- v29 : union discrète des routes alignées sur la grille canonique de 10 studs.
-- Un seul carreau par noeud et un seul tronçon par arête, sans surfaces coplanaires.
-- Au centre, la Place centrale couvre le sol : ne pas générer de pavés cachés.
local function streetTiles(folder,paths)
    local nodes,edges={},{}
    local function nodeKey(x,z) return string.format("%d:%d",x,z) end
    local function addNode(x,z)
        local key=nodeKey(x,z)
        if Vector2.new(x,z).Magnitude>56 then nodes[key]={x,z} end
    end
    for _,path in ipairs(paths) do
        local pts=path.path_xyz_studs
        for i=2,#pts do
            local a,b=pts[i-1],pts[i]
            local dx=if a[1]~=b[1] then (b[1]>a[1] and 10 or -10) else 0
            local dz=if a[3]~=b[3] then (b[3]>a[3] and 10 or -10) else 0
            if dx~=0 or dz~=0 then
                local steps=math.floor((math.abs(b[1]-a[1])+math.abs(b[3]-a[3]))/10+0.5)
                for j=0,steps do
                    local x,z=a[1]+j*dx,a[3]+j*dz
                    addNode(x,z)
                    if j>0 then
                        local px,pz=x-dx,z-dz
                        local midx,midz=(px+x)/2,(pz+z)/2
                        if Vector2.new(px,pz).Magnitude>56 and Vector2.new(x,z).Magnitude>56 then
                            local key=if dx~=0 then "H:"..nodeKey(midx,midz) else "V:"..nodeKey(midx,midz)
                            edges[key]={midx,midz,dx~=0}
                        end
                    end
                end
            end
        end
    end
    -- Raster de 2 studs : cellules disjointes, puis fusion par rangées contiguës.
    -- La forme visible et la forme de collision utilisent les mêmes rectangles.
    local rows={}
    local function cell(x,z)
        local ix,iz=math.floor(x/2+0.5),math.floor(z/2+0.5)
        rows[iz]=rows[iz] or {}
        rows[iz][ix]=true
    end
    for _,v in pairs(nodes) do
        for dx=-2,2,2 do
            for dz=-2,2,2 do cell(v[1]+dx,v[2]+dz) end
        end
    end
    for _,v in pairs(edges) do
        if v[3] then
            for dx=-1,1,2 do
                for dz=-2,2,2 do cell(v[1]+dx,v[2]+dz) end
            end
        else
            for dx=-2,2,2 do
                for dz=-1,1,2 do cell(v[1]+dx,v[2]+dz) end
            end
        end
    end
    local color=Color3.fromRGB(211,200,175)
    local count=0
    local function emit(r)
        local x1,x2,z1,z2=r[1],r[2],r[3],r[4]
        local width=(x2-x1+1)*2
        local depth=(z2-z1+1)*2
        local tile=Factory.part(folder,"Chemin unifié",Vector3.new(width,0.24,depth),CFrame.new(x1+x2,0.09,z1+z2),color,Enum.Material.Cobblestone)
        tile.CanCollide=true;count+=1
    end
    local zs={}
    for z in pairs(rows) do table.insert(zs,z) end
    table.sort(zs)
    local active={}
    for _,z in ipairs(zs) do
        local xs={}
        for x in pairs(rows[z]) do table.insert(xs,x) end
        table.sort(xs)
        local runs={}
        for _,x in ipairs(xs) do
            local last=runs[#runs]
            if last and x==last[2]+1 then last[2]=x
            else table.insert(runs,{x,x}) end
        end
        local nextActive={}
        for _,run in ipairs(runs) do
            local key=tostring(run[1])..":"..tostring(run[2])
            local old=active[key]
            if old and old[4]==z-1 then
                old[4]=z;nextActive[key]=old
            else
                nextActive[key]={run[1],run[2],z,z}
            end
        end
        for key,r in pairs(active) do
            if not nextActive[key] then emit(r) end
        end
        active=nextActive
    end
    for _,r in pairs(active) do emit(r) end
    folder:SetAttribute("KinUniquePavementPieces",count)
    folder:SetAttribute("KinPavementUnionV29",true)
end

function CityGenerator.make(parent,plan,buildingsById)
    GroundCompatibility.prepare()
    local city=Factory.folder(parent,"Ville")
    local disk=Factory.part(city,"Île circulaire",Vector3.new(2,990,990),CFrame.new(0,-1,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(84,141,107),Enum.Material.Grass)
    disk.Shape=Enum.PartType.Cylinder
    local water=Factory.part(city,"Lac périphérique",Vector3.new(1,1800,1800),CFrame.new(0,-3.8,0)*CFrame.Angles(0,0,math.pi/2),Color3.fromRGB(47,125,163),Enum.Material.SmoothPlastic)
    water.Shape=Enum.PartType.Cylinder
    HexagonalHeart.make(city)
    local roads=Factory.folder(city,"Sentiers piétons")
    streetTiles(roads,plan.pedestrian_paths)
    local facades=Factory.folder(city,"Bâtiments")
    for _,b in ipairs(plan.structures) do
        local building=buildingsById[b.building_id]
        assert(building,"Missing building: "..b.building_id)
        FacadeGenerator.make(facades,b,building,plan.styles[b.style_id])
    end
    KoaliUrbanism.make(city,plan)
    local gardens=Factory.folder(city,"Nature • alignements")
    local rng=Random.new(plan.seed)
    local planted=0
    for i=1,185 do
        local angle=rng:NextNumber(0,2*math.pi)
        local radius=rng:NextNumber(90,465)
        local x,z=math.cos(angle)*radius,math.sin(angle)*radius
        if not KoaliUrbanism.isReserved(x,z) and not nearestBuildings(x,z,plan.structures) and not InstitutionForecourts.isReserved(x,z,plan.structures) and not LearningConservatories.isReserved(x,z) and not DiscoveryPromenade.isReserved(x,z) and not ResidentialQuarters.isReserved(x,z) and not CommunityBuildings.isReserved(x,z) and not IntermodalHub.isReserved(x,z) and not CivicStages.isReserved(x,z) and not PromenadeCommerce.isReserved(x,z) and not CooperativeInstallations.isReserved(x,z) and not SecondaryStreets.isReserved(x,z) and not StationArcades.isReserved(x,z) and not PublicWorkshops.isReserved(x,z) then
            local blockedPath=false
            for _,path in ipairs(plan.pedestrian_paths) do
                if distanceToPath(x,z,path)<path.width_studs/2+7 then
                    blockedPath=true
                    break
                end
            end
            if not blockedPath then
                tree(gardens,x,z,i);planted+=1
            end
        end
    end
    for _,item in ipairs(plan.navigation_obstacles) do
        if item.kind=="monument" then
            Factory.part(city,"Monument du savoir",Vector3.new(5,19,5),CFrame.new(item.center_studs[1],9.5,item.center_studs[2]),Color3.fromRGB(30,104,100),Enum.Material.Marble)
        elseif item.kind=="welcome" then
            -- Grand panneau redondant supprimé : la Place hexagonale sert de repère.
        end
    end
    local spawn=Instance.new("SpawnLocation")
    spawn.Name="Arrivée Kin City"
    spawn.Size=Vector3.new(12,1,12)
    local arrival=assert(Spatial.anchorCFrame("city","city.central.spawn"))
    spawn.CFrame=arrival*CFrame.new(0,-2.2,0)
    spawn.Anchored=true
    spawn.Neutral=true
    spawn.CanCollide=true
    spawn.Transparency=1
    spawn.Duration=0
    spawn.Parent=city
    -- v31 : allègement du bac à sable préexistant. Les institutions et leurs
    -- mécanismes demeurent ; les anciens lotissements aléatoires, marchés,
    -- navettes et mises en scène non structurées ne sont plus construits.
    InstitutionForecourts.make(city,plan)
    CrystalLandingsV24.make(city,plan)
    ScenicCoast.make(city)
    OuterIslands.make(city)
    PedestrianWayfinding.make(city,plan,buildingsById)
    DistrictChromatics.make(city,plan)
    DistrictLandmarks.make(city,plan)
    EkohHalo.make(city,plan)
    OutdoorAtmosphere.make(city)
    -- KC36 B10 : population compatible avec la scène régénérée en édition.
    Citizens.make(city)
    return city
end
return CityGenerator

]========]

-- Prévalidation géométrique AVANT toute modification du runtime.
local proof=Instance.new("ModuleScript")
proof.Name="KC36PopulationGeomAudit_TEMP"
proof.Source=source_CityPopulationV36
proof.Parent=SS
local valid,stats=pcall(function() return require(proof).audit() end)
proof:Destroy()
assert(valid,"Contrat de placement PNJ refusé : "..tostring(stats))
assert(stats.stylized==24 and stats.r15==18 and stats.sectors==6,"Contrat PNJ inattendu")

local backup=SS:FindFirstChild(backupName)
if backup then error("Sauvegarde de la première migration déjà présente; inspecter avant de réexécuter") end
backup=Instance.new("Folder")
backup.Name=backupName
backup:SetAttribute("KC36PopulationRevision","KC36-POPULATION-AVENUES-1")
backup.Parent=SS
local recordSources={Citizens=source_Citizens,NativeR15Citizens=source_NativeR15Citizens,CityGenerator=source_CityGenerator}
for name,old in pairs(originals) do
    local v=Instance.new("StringValue")
    v.Name="SourceOriginal_"..name
    v.Value=old
    v.Parent=backup
end
if previous then
    local v=Instance.new("StringValue")
    v.Name="SourceOriginal_CityPopulationV36"
    v.Value=previous.Source
    v.Parent=backup
end

local ok,err=pcall(function()
    local module=previous or Instance.new("ModuleScript")
    module.Name="CityPopulationV36"
    module.Source=source_CityPopulationV36
    module.Parent=runtime
    for name,newCode in pairs(recordSources) do
        runtime[name].Source=newCode
    end
    runtime:SetAttribute("KC36PopulationRevision","KC36-POPULATION-AVENUES-1")
end)
if not ok then
    for name,oldCode in pairs(originals) do pcall(function() runtime[name].Source=oldCode end) end
    local current=runtime:FindFirstChild("CityPopulationV36")
    if current then
        if previous then
            local v=backup:FindFirstChild("SourceOriginal_CityPopulationV36")
            if v then pcall(function() current.Source=v.Value end) end
        else
            current:Destroy()
        end
    end
    runtime:SetAttribute("KC36PopulationRevision",nil)
    error("Installation annulée; codes restaurés : "..tostring(err))
end

print("========== KC36 POPULATION ==========")
print("Modules sources installés : 4")
print("Emplacements contrôlés : 42 = 24 stylisés + 18 R15")
print("Répartition : 7 sites dans chacun des 6 secteurs")
print("PNJ R15 : chargement Roblox réel à vérifier en Play")
print("Sauvegarde sources : ServerStorage."..backupName)
print("Package Art Deco : conservé, 121/121")
print("PASS KC36 POPULATION SOURCES")
print("Ctrl+S puis Play ; regarder Output KC36 POPULATION")
