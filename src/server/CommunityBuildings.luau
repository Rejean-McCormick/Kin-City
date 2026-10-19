--!strict
-- Construction v11 : six marchés couverts et six maisons communautaires.
-- Chaque marché et maison est physiquement accessible, meublé et doté d'une
-- animation locale; aucun achat, dossier, note ou fonction kOA n'est exécuté.
local RS=game:GetService("ReplicatedStorage")
local Destinations=require(RS:WaitForChild("KinCityShared"):WaitForChild("CommunityDestinations"))
local F=require(script.Parent.Factory)
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local Community={}
local STONE=Color3.fromRGB(232,219,192)
local FRAME=Color3.fromRGB(30,104,100)
local TIMBER=Color3.fromRGB(148,104,71)
local GLASS=Color3.fromRGB(197,244,240)
local GOLD=Color3.fromRGB(224,190,114)

local function block(m,n,cf,x,y,z,w,h,d,color,material,collision)
    local p=F.part(m,n,Vector3.new(w,h,d),cf*CFrame.new(x,y,z),color,material)
    if collision==false then p.CanCollide=false;p.CanTouch=false;p.CanQuery=false end
    return p
end
local function orb(m,n,cf,x,y,z,diam,col)
    local o=block(m,n,cf,x,y,z,diam,diam,diam,col,Enum.Material.Neon,false)
    o.Shape=Enum.PartType.Ball
    return o
end
local function lamp(m,cf,x,y,z,id,color)
    local bulb=orb(m,"Luminaire communautaire",cf,x,y,z,1.2,color)
    bulb:SetAttribute("KinCommunityLamp",id)
    local point=Instance.new("PointLight")
    point.Brightness=1.0;point.Range=19;point.Shadows=false;point.Parent=bulb
    return bulb
end
local function sign(m,cf,at,text,width)
    local p=F.sign(m,"Enseigne publique",(cf*CFrame.new(at)).Position,math.deg(math.atan2(-cf.LookVector.X,-cf.LookVector.Z)),text,width,3)
    p.CanCollide=false
end
local function stub(m,cf,x,y,z,id,title)
    local terminal=block(m,"Terminal futur",cf,x,y,z,2.6,4,1.4,FRAME,Enum.Material.Metal)
    terminal:SetAttribute("KinStubInteractionId",id..".future.terminal")
    terminal:SetAttribute("KinStubCapabilityId","future.community.local")
    terminal:SetAttribute("KinStubTitle",title)
    F.prompt(terminal,"Consulter",title)
    local glass=block(m,"Écran en veille",cf,x,y+0.8,z-0.79,1.9,1.6,0.1,GLASS,Enum.Material.Glass,false)
    OpalGlazingV22.apply(glass,false)
end
local function seat(m,cf,x,y,z,color)
    local s=Instance.new("Seat")
    s.Name="Chaise utilisable";s.Size=Vector3.new(2.4,0.7,2.2)
    s.CFrame=cf*CFrame.new(x,y,z);s.Anchored=true;s.Material=Enum.Material.WoodPlanks;s.Color=color;s.Parent=m
    block(m,"Dossier",cf,x,y+0.9,z+1,2.45,1.75,0.35,FRAME,Enum.Material.Wood)
end
local function kiosk(m,cf,i,id,color)
    local x=if i%2==0 then 12 else -12
    local z=-19+math.floor((i-1)/2)*8.2
    block(m,"Étal du marché "..i,cf,x,1.8,z,8,2.6,5,TIMBER,Enum.Material.WoodPlanks)
    block(m,"Vitrine de l'étal",cf,x,3.38,z-1.1,7.2,0.25,2.6,color,Enum.Material.SmoothPlastic,false)
    for n=1,6 do
        local dx=-2.8+(n-1)*1.12
        local shade=if (n+i)%3==0 then GOLD elseif n%2==0 then color else Color3.fromRGB(122,172,126)
        local item=block(m,"Collection exposée",cf,x+dx,3.8,z-1.1,0.9,0.9,1.15,shade,Enum.Material.SmoothPlastic,false)
        item.Shape=if n%2==0 then Enum.PartType.Ball else Enum.PartType.Block
    end
    for _,side in ipairs({-1,1}) do
        block(m,"Montant du kiosque",cf,x+side*3.5,5.5,z,0.35,5,0.35,FRAME,Enum.Material.Wood)
    end
    block(m,"Auvent textile",cf,x,8.15,z,8.5,0.45,6.4,color,Enum.Material.Fabric,false)
    if i<=2 then
        local target=block(m,"Étiquette de collection",cf,x,5.0,z-3.0,2,2.5,0.8,FRAME,Enum.Material.Metal)
        target:SetAttribute("KinStubInteractionId",id..".stall."..i)
        target:SetAttribute("KinStubCapabilityId","future.community.market")
        target:SetAttribute("KinStubTitle","Collection de l'étal "..i)
        F.prompt(target,"Découvrir","Collection — bientôt")
    end
end
local function commonShell(m,cf,kind,color)
    local isMarket=kind=="market"
    local width=if isMarket then 46 else 38
    local depth=if isMarket then 58 else 43
    local halfX=width/2
    local halfZ=depth/2
    block(m,"Parvis",cf,0,-0.02,-halfZ-8,width+8,0.26,18,STONE,Enum.Material.Cobblestone)
    block(m,"Sol accessible",cf,0,0.15,0,width,0.55,depth,STONE,Enum.Material.Cobblestone)
    for _,side in ipairs({-1,1}) do
        local x=side*halfX
        block(m,"Mur longitudinal",cf,x,6.3,0,0.85,12.4,depth,TIMBER,Enum.Material.Brick)
        for n=1,4 do
            local z=-halfZ+8+(n-1)*13
            local pane=block(m,"Vitrail latéral",cf,x+side*0.5,6,z,0.16,5.5,5.9,GLASS,Enum.Material.Glass,false)
            OpalGlazingV22.apply(pane,false)
            block(m,"Traverse de façade",cf,x+side*0.58,6,z,0.23,0.28,6,GOLD,Enum.Material.Metal,false)
        end
    end
    block(m,"Mur arrière",cf,0,6.3,halfZ,width,12.4,0.85,TIMBER,Enum.Material.Brick)
    -- Panneaux frontaux de part et d'autre d'une ouverture de 9 studs.
    local edgeWidth=(width-9)/2
    for _,side in ipairs({-1,1}) do
        block(m,"Façade principale",cf,side*(4.5+edgeWidth/2),6.3,-halfZ,edgeWidth,12.4,0.8,TIMBER,Enum.Material.Brick)
    end
    block(m,"Linteau de porte",cf,0,11.2,-halfZ,9.3,2.4,0.85,FRAME,Enum.Material.Metal)
    -- Toiture à pans inclinés et claire-voie laissant entrer la lumière.
    for _,side in ipairs({-1,1}) do
        block(m,"Pan de toiture",cf,side*halfX/2,16.2,0,width/2+2,0.85,depth+3,color,Enum.Material.Slate,false)
        for _,z in ipairs({-halfZ+6,0,halfZ-6}) do
            local pane=block(m,"Lanterneau",cf,side*(halfX/2),16.8,z,6,0.22,3.9,GLASS,Enum.Material.Glass,false)
            OpalGlazingV22.apply(pane,true)
        end
    end
    for _,x in ipairs({-halfX+3,halfX-3}) do
        block(m,"Poutre de nef",cf,x,12,0,0.9,21,0.9,FRAME,Enum.Material.Wood)
    end
    -- Entrée et piétonnier libres pour l'avatar.
    block(m,"Seuil de pierre",cf,0,0.2,-halfZ-1,8.5,0.4,3,STONE,Enum.Material.Cobblestone)
    return halfX,halfZ
end
local function createMarket(parent,data,color,cf)
    local m=Instance.new("Model");m.Name=data.title;m.Parent=parent
    m:SetAttribute("KinCommunityId",data.id)
    m:SetAttribute("KinCommunityType","market")
    local _,halfZ=commonShell(m,cf,"market",color)
    -- Douze étals réels laissant un corridor central d'au moins 10 studs.
    for n=1,12 do kiosk(m,cf,n,data.id,color) end
    block(m,"Place de dégustation",cf,0,1.9,19,9,1,8,TIMBER,Enum.Material.WoodPlanks)
    for _,side in ipairs({-1,1}) do seat(m,cf,side*7,1.55,19,color) end
    for n=1,6 do lamp(m,cf,if n%2==0 then 16 else -16,11,-20+n*7,data.id,GOLD) end
    block(m,"Rosace de hall",cf,0,0.55,0,12,0.2,12,color,Enum.Material.Marble,false)
    local switch=block(m,"Commande des éclairages",cf,-18,2,-halfZ+7,2.5,3.4,1.5,FRAME,Enum.Material.Metal)
    switch:SetAttribute("KinCommunityAction","lights")
    switch:SetAttribute("KinCommunityId",data.id)
    F.prompt(switch,"Ambiance","Lumières du marché")
    stub(m,cf,18,2.1,halfZ-6,data.id,data.title)
    sign(m,cf,Vector3.new(0,13,-halfZ-0.6),data.title,30)
    SecondaryArchitectureV25.hall(m,cf,"market",color)
    return m
end
local function specialist(m,cf,data,color)
    local kind=data.special
    for n=1,5 do
        local x=-11+(n-1)*5.5
        if kind=="books" then
            block(m,"Étagère publique",cf,x,3,11,3.7,5,2.0,TIMBER,Enum.Material.Wood)
            for row=1,3 do for book=1,2 do
                block(m,"Volumes de lecture",cf,x-0.8+book*0.6,1.4+row*1.05,9.7,0.8,0.95,1.0,if row%2==0 then color else GOLD,Enum.Material.Fabric,false)
            end end
        elseif kind=="serres" then
            block(m,"Bac botanique",cf,x,1.3,11,3.5,2.2,4.5,TIMBER,Enum.Material.Wood)
            for leaf=1,2 do
                local crown=block(m,"Jardin vivant",cf,x+(leaf-1)*1.1,3.8,11,2.0,2.0,2.0,Color3.fromRGB(100,175,120),Enum.Material.Grass,false)
                crown.Shape=Enum.PartType.Ball
            end
        elseif kind=="arts" then
            block(m,"Chevalet créatif",cf,x,4,11,3.2,5,0.8,FRAME,Enum.Material.Wood,false)
            block(m,"Toile d'exposition",cf,x,4.2,10.5,2.7,4.3,0.25,if n%2==0 then color else GOLD,Enum.Material.Fabric,false)
        elseif kind=="movement" then
            local c=orb(m,"Mobile cinétique",cf,x,4.4,11,2.5,color)
            c:SetAttribute("KinCommunityOrnament",data.id)
        elseif kind=="light" then
            block(m,"Réfracteur de lumière",cf,x,3.6,11,2.7,5,2.1,GLASS,Enum.Material.Glass,false).Transparency=0.24
            lamp(m,cf,x,7.2,11,data.id,color)
        else
            block(m,"Table de collaboration",cf,x,2.3,11,4,1,4,TIMBER,Enum.Material.WoodPlanks)
            seat(m,cf,x,1.5,15,color)
        end
    end
end
local function createCommunity(parent,data,color,cf)
    local m=Instance.new("Model");m.Name=data.title;m.Parent=parent
    m:SetAttribute("KinCommunityId",data.id)
    m:SetAttribute("KinCommunityType","community")
    local _,halfZ=commonShell(m,cf,"community",color)
    -- Mezzanine latérale non traversante, accessible par un vrai escalier.
    block(m,"Mezzanine ouest",cf,-12.7,10.2,1,10.5,0.5,33,STONE,Enum.Material.WoodPlanks)
    block(m,"Mezzanine palier arrière",cf,0,10.2,16,16,0.5,5,STONE,Enum.Material.WoodPlanks)
    for n=1,14 do
        local z=-12+(n-1)*1.62
        block(m,"Escalier de lecture "..n,cf,-9,0.63+n*0.67,z,4.5,0.5,1.7,STONE,Enum.Material.Cobblestone)
    end
    for _,z in ipairs({-13,1,15}) do
        block(m,"Balustrade de galerie",cf,-7,11.1,z,0.35,1.7,8,GOLD,Enum.Material.Metal,false)
    end
    -- Lieu avec un véritable programme physique distinct de l'écran métier futur.
    block(m,"Grande table de quartier",cf,0,1.9,-2.5,10,1,5,TIMBER,Enum.Material.WoodPlanks)
    for _,z in ipairs({-6,1}) do
        for _,x in ipairs({-4,4}) do seat(m,cf,x,1.4,z,color) end
    end
    specialist(m,cf,data,color)
    for n=1,4 do lamp(m,cf,if n%2==0 then 12 else -12,10,-14+n*8,data.id,color) end
    local rotor=Instance.new("Model")
    rotor.Name="Mobile cinétique des rencontres"
    rotor:SetAttribute("KinCommunityArt",data.id)
    rotor.Parent=m
    local pivot=orb(rotor,"Noyau lumineux",cf,0,6,8,3,color)
    rotor.PrimaryPart=pivot
    for arm=1,4 do
        local a=arm*math.pi/2
        local dx,dz=math.cos(a),math.sin(a)
        local wing=block(rotor,"Branche artistique "..arm,cf,dx*2.8,6,8+dz*2.8,0.5,0.55,5.5,GOLD,Enum.Material.Metal,false)
        wing.CFrame=cf*CFrame.new(dx*2.8,6,8+dz*2.8)*CFrame.Angles(0,math.pi/2-a,0)
        orb(rotor,"Prisme mobile",cf,dx*5.3,6,8+dz*5.3,1.8,if arm%2==0 then color else GOLD)
    end
    local handle=block(m,"Commande artistique",cf,13,2,-9,2.6,3.2,1.5,FRAME,Enum.Material.Metal)
    handle:SetAttribute("KinCommunityAction","art")
    handle:SetAttribute("KinCommunityId",data.id)
    F.prompt(handle,"Animer","Sculpture locale")
    stub(m,cf,-15,2,halfZ-4,data.id,data.title)
    sign(m,cf,Vector3.new(0,13,-halfZ-0.6),data.title,30)
    SecondaryArchitectureV25.hall(m,cf,"community",color)
    return m
end

function Community.isReserved(x,z)
    for _,data in ipairs(Destinations) do
        local p=Vector3.new(data.center_studs[1],0,data.center_studs[3])
        if (Vector3.new(x,0,z)-p).Magnitude<40 then return true end
    end
    return false
end
function Community.make(city)
    local root=F.folder(city,"Halles et maisons publiques — douze édifices")
    local markets=0
    local centres=0
    for _,data in ipairs(Destinations) do
        local pos=Vector3.new(data.center_studs[1],0,data.center_studs[3])
        local cf=CFrame.new(pos)*CFrame.Angles(0,data.facing,0)
        local color=Color3.fromRGB(data.color[1],data.color[2],data.color[3])
        if data.kind=="market" then createMarket(root,data,color,cf);markets+=1
        else createCommunity(root,data,color,cf);centres+=1 end
        -- La place communale existante mène directement à chacune des deux entrées.
        local dir=cf.LookVector
        block(root,"Allée de liaison",cf,0,0.1,-33,8,0.22,24,STONE,Enum.Material.Cobblestone)
    end
    root:SetAttribute("KinMarketHalls",markets)
    root:SetAttribute("KinCommunityCentres",centres)
    return root
end
return Community
