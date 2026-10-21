--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Citoyens procéduraux : coiffures, teintes, vêtements, marche articulée et interactions.
-- Aucun avatar externe, aucune identité kOA et aucun ID asset obligatoire.
local F=require(script.Parent.Factory)
local Presence=require(script.Parent.ViewerPresenceV21)
local Nav=require(script.Parent.NeighborhoodNPCNavigation)
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
    local folder=F.folder(parent,"Citoyens")
    for i=1,36 do
        local model=makeCitizen(folder,i)
        local quarter=Nav.quarter(i)
        local start=Nav.stop(quarter,i,1)
        model:SetAttribute("KinResidenceQuarter",quarter.id)
        model:SetAttribute("KinNPCActivity","Accueil du quartier")
        model:PivotTo(CFrame.new(start+Vector3.new(0,0.15,0)))
    end
    return folder
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
    local folder=city and city:FindFirstChild("Citoyens")
    if not folder then return end
    for _,model in ipairs(folder:GetChildren()) do
        local index=model:GetAttribute("CitizenIndex")
        if index and model:IsA("Model") then
            task.spawn(function()
                local quarter=Nav.quarter(index)
                local routeStep=1
                local phase=index*1.7
                local speed=4.5+(index%4)*0.65
                local last=os.clock()
                local lastPresence=0
                local nearby=false
                local pathPoints=nil
                local waypointIndex=2
                local retryAt=0
                local pauseUntil=0
                local root=model.PrimaryPart
                while root and root.Parent and world.Parent do
                    local now=os.clock()
                    local dt=math.clamp(now-last,0,0.15)
                    last=now
                    if now-lastPresence>1.0 then
                        nearby=Presence.near(model:GetPivot().Position,180)
                        lastPresence=now
                    end
                    if not nearby then
                        task.wait(0.6)
                        continue
                    end
                    local position=model:GetPivot().Position
                    if not pathPoints and now>=retryAt then
                        routeStep+=1
                        local target,activity=Nav.stop(quarter,index,routeStep)
                        local _,points=Nav.plan(quarter,position+Vector3.new(0,2.35,0),target+Vector3.new(0,2.5,0))
                        pathPoints=points
                        waypointIndex=2
                        retryAt=now+(if points then 0 else 2.5)
                        if points then model:SetAttribute("KinNPCActivity",activity) end
                    end
                    local walking=false
                    local direction=Vector3.new(0,0,-1)
                    if pathPoints and now>=pauseUntil then
                        local waypoint=pathPoints[waypointIndex]
                        if waypoint then
                            local delta=Vector3.new(waypoint.Position.X-position.X,0,waypoint.Position.Z-position.Z)
                            if delta.Magnitude<0.55 then
                                waypointIndex+=1
                                if waypointIndex>#pathPoints then
                                    pathPoints=nil
                                    pauseUntil=now+1.2+(index%4)*0.6
                                end
                            else
                                direction=delta.Unit
                                local step=math.min(speed*dt,delta.Magnitude)
                                local advance=direction*step
                                if Nav.blockedAhead(model,position,advance+direction*1.1,world) then
                                    pathPoints=nil
                                    retryAt=now+2.0
                                else
                                    local nextPosition=position+advance
                                    -- Les PNJ ancrés ne traversent pas l'enveloppe de leur quartier.
                                    if Nav.within(quarter,nextPosition) then
                                        walking=true
                                        phase+=step*1.05
                                        local frame=face(nextPosition,direction)
                                        model:PivotTo(frame)
                                        animate(model,frame,phase,true)
                                    else
                                        pathPoints=nil
                                        retryAt=now+2.5
                                    end
                                end
                            end
                        else
                            pathPoints=nil
                        end
                    end
                    if not walking then
                        animate(model,model:GetPivot(),phase,false)
                    end
                    task.wait(0.08)
                end
            end)
        end
    end
end
return Citizens
