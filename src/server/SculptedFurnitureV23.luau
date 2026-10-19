--!strict
-- Kin City v23: mobilier architectural réellement distinct pour les huit institutions.
-- N'ajoute pas de fausses fonctionnalités kOA. Les structures principales restent
-- visuelles (aucune collision); les sièges sont des Seat Roblox utilisables.
local Kit=require(script.Parent.CrystalKit)
local Factory=require(script.Parent.Factory)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Furniture={}
local ROLE={
    city_hall="civic",ekoh_tower="knowledge",library="archive",campus="orbit",
    justice_palace="balance",innovation_lab="mechanism",museum="art",orgo_center="network",
}
local function detail(parent,kind,label,sz,cf,color,material,optional)
    local p=Kit.part(parent,kind,label,sz,cf,color,material or Enum.Material.Slate)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    return p
end
local function beam(parent,from,to,thick,color)
    local delta=to-from
    if delta.Magnitude<0.01 then return end
    detail(parent,"Part","Traverse en bronze clair",Vector3.new(thick,thick,delta.Magnitude),
        CFrame.lookAt((from+to)*0.5,to),color,Enum.Material.Metal,false)
end
local function case(parent,root,role,accent,seed)
    detail(parent,"Part","Îlot de pierre",Vector3.new(7.4,0.75,3.9),root*CFrame.new(0,0.42,0),Kit.deep,Enum.Material.Slate,false)
    detail(parent,"Part","Surface ouvragée",Vector3.new(7.7,0.25,4.0),root*CFrame.new(0,0.91,0),Kit.gold,Enum.Material.Metal,false)
    for _,side in ipairs({-1,1}) do
        Meshes.decorate(parent,"Colonne facettée","mineral_column",Vector3.new(0.65,3.3,1.1),
            root*CFrame.new(side*3.1,2.15,0),Kit.primary)
    end
    if role=="archive" or role=="knowledge" then
        -- Les livres, archives et savoirs sont des volumes physiques sculptés.
        for i=1,5 do
            local height=2.0+((i+seed)%3)*0.38
            detail(parent,"Part","Codex minéral",Vector3.new(0.8,height,2.1),
                root*CFrame.new((i-3)*1.13,1.02+height/2,0),if i%2==0 then accent else Kit.stone,
                Enum.Material.Slate,true)
        end
        detail(parent,"Part","Ruban de classement",Vector3.new(6.0,0.15,0.3),root*CFrame.new(0,3.55,-1.1),Kit.gold,Enum.Material.Metal,true)
    elseif role=="orbit" then
        detail(parent,"Part","Socle d'orbite",Vector3.new(0.7,4.1,0.7),root*CFrame.new(0,2.9,0),Kit.gold,Enum.Material.Metal,false)
        for i=1,3 do
            local a=i*math.pi*2/3+seed*0.13
            local r=1.45+i*0.28
            local orb=detail(parent,"Part","Corps céleste",Vector3.new(r,r,r),
                root*CFrame.new(math.cos(a)*2.1,4+math.sin(a)*0.72,math.sin(a)*0.75),
                if i==2 then Kit.gold else accent,Enum.Material.Slate,true)
            orb.Shape=Enum.PartType.Ball
        end
    elseif role=="balance" then
        detail(parent,"Part","Axe d'équilibre",Vector3.new(0.5,3.8,0.5),root*CFrame.new(0,2.95,0),Kit.primary,Enum.Material.Metal,false)
        beam(parent,(root*CFrame.new(-2.6,4.55,0)).Position,(root*CFrame.new(2.6,4.55,0)).Position,0.19,Kit.gold)
        for _,side in ipairs({-1,1}) do
            detail(parent,"Part","Plateau des équilibres",Vector3.new(2.3,0.21,1.8),
                root*CFrame.new(side*2.55,2.95,0),accent,Enum.Material.Metal,true)
            beam(parent,(root*CFrame.new(side*2.55,4.45,0)).Position,
                (root*CFrame.new(side*2.55,3.02,0)).Position,0.1,Kit.gold)
        end
    elseif role=="mechanism" then
        for i=1,4 do
            local angle=i*math.pi*0.5
            detail(parent,"WedgePart","Aube de turbine",Vector3.new(1.1,2.4,1.2),
                root*CFrame.new(math.sin(angle)*1.75,2.7,math.cos(angle)*0.9)*CFrame.Angles(0,angle,0),
                if i%2==0 then accent else Kit.gold,Enum.Material.Metal,true)
        end
        detail(parent,"Part","Moyeu central",Vector3.new(1.1,1.1,1.1),root*CFrame.new(0,2.6,0),Kit.opal,Enum.Material.Slate,true)
    elseif role=="art" then
        for i=1,3 do
            detail(parent,"WedgePart","Prisme de composition",Vector3.new(1.0+i*0.25,2.3+i*0.65,1.4),
                root*CFrame.new((i-2)*1.85,2.0+i*0.24,0)*CFrame.Angles(0,i*0.53,(i-2)*0.17),
                if i==2 then accent else Kit.gold,Enum.Material.Slate,true)
        end
    elseif role=="network" then
        for i=1,5 do
            local a=i*2*math.pi/5
            local target=(root*CFrame.new(math.cos(a)*2.5,2.9+math.sin(a)*1.0,math.sin(a)*1.1)).Position
            beam(parent,(root*CFrame.new(0,2.4,0)).Position,target,0.16,Kit.gold)
            local orb=detail(parent,"Part","Nœud de réseau",Vector3.new(0.68,0.68,0.68),CFrame.new(target),accent,Enum.Material.Slate,true)
            orb.Shape=Enum.PartType.Ball
        end
    else
        for i=-2,2 do
            detail(parent,"Part","Quartier miniature",Vector3.new(0.9,1.8+(i+3)%3,1.1),
                root*CFrame.new(i*1.15,1.9+(i+3)%3*0.5,0),if i%2==0 then accent else Kit.medium,Enum.Material.Marble,true)
        end
    end
end
local function bench(parent,root,accent)
    -- Le siège, contrairement aux incrustations, est réellement utilisable.
    local seat=Instance.new("Seat")
    seat.Name="Banquette de lecture et de rencontre"
    seat.Size=Vector3.new(4.2,0.65,2.15)
    seat.CFrame=root*CFrame.new(0,1.55,-3.75)
    seat.Anchored=true
    seat.Material=Enum.Material.Wood
    seat.Color=Kit.primary
    seat.Parent=parent
    detail(parent,"Part","Dossier orné",Vector3.new(4.35,2.05,0.42),
        root*CFrame.new(0,2.48,-4.8),Kit.deep,Enum.Material.Wood,false)
    detail(parent,"Part","Fil opalin de banquette",Vector3.new(4.45,0.13,0.18),
        root*CFrame.new(0,3.33,-4.51),accent,Enum.Material.Slate,true)
end
function Furniture.decorate(parent,placeKey,room,origin,index)
    local role=ROLE[placeKey]
    if not role then return end
    local cx,_,cz=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<28 or d<26 then return end
    local rootFolder=Instance.new("Folder")
    rootFolder.Name="Mobilier sculpté v23"
    rootFolder:SetAttribute("KinArtTheme","sarcelle-cristal-v23")
    rootFolder:SetAttribute("KinFurnitureType",role)
    rootFolder.Parent=parent
    local count=if Kit.profile=="LITE" then 1 elseif Kit.profile=="SHOWCASE" then 3 else 2
    for n=1,count do
        local side=if n%2==1 then -1 else 1
        local slot=if n==3 then 1 else 0
        -- Côté de la salle, dans le premier tiers : les sorties et l'axe central restent libres.
        local x=cx+side*(w/2-7.6)
        local z=cz-d/2+9+slot*9
        local root=CFrame.new(origin+Vector3.new(x,0,z))*CFrame.Angles(0,if side==-1 then -math.pi/2 else math.pi/2,0)
        local group=Instance.new("Model")
        group.Name="Composition de mobilier "..n
        group.Parent=rootFolder
        case(group,root,role,Kit.accent(placeKey),index*3+n)
        if index==1 and n==1 then bench(group,root,Kit.accent(placeKey)) end
    end
    return rootFolder
end
return Furniture
