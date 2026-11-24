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
