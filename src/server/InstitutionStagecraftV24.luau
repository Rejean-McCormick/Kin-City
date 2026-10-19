--!strict
-- Fresques de salle et alcôves architecturales. Motifs typés, et non un empilement
-- de vitrage/PointLight : budget décoratif réduit selon le profil de construction.
local Kit=require(script.Parent.CrystalKit)
local Factory=require(script.Parent.Factory)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Stage={}
local ICON={
    city_hall={"LA CITÉ", "Places, routes et rencontres", "urban"},
    ekoh_tower={"LES SAVOIRS", "Observer, relier, comprendre", "star"},
    library={"LES ARCHIVES", "Des traces et des récits", "book"},
    campus={"LES SCIENCES", "Questions et expériences", "orbit"},
    justice_palace={"LES ÉQUILIBRES", "Écouter, comparer, respecter", "balance"},
    innovation_lab={"LES INVENTIONS", "Explorer les mécanismes", "gear"},
    museum={"LES ARTS", "Des formes qui dialoguent", "facet"},
    orgo_center={"LES RÉSEAUX", "Construire les passages", "network"},
}
local function detail(parent,name,size,cf,color,material)
    local p=Kit.part(parent,"Part",name,size,cf,color,material or Enum.Material.Slate)
    p:SetAttribute("KinOptionalDetail",true)
    return p
end
local function orb(parent,name,size,cf,color)
    local p=detail(parent,name,Vector3.new(size,size,size),cf,color,Enum.Material.Slate)
    p.Shape=Enum.PartType.Ball
    return p
end
local function glyph(parent,shape,root,index,accent)
    if shape=="urban" then
        for i=-2,2 do
            detail(parent,"Édifice du plan",Vector3.new(0.5,1.1+math.abs(i)*0.34,0.65),
                root*CFrame.new(i*0.8,0.4+math.abs(i)*0.16,0),if i%2==0 then accent else Kit.gold)
        end
    elseif shape=="book" then
        for i=-2,2 do
            detail(parent,"Volume d'archives",Vector3.new(0.47,1.5+(i%3)*0.17,0.54),
                root*CFrame.new(i*0.62,0,0),if i%2==0 then Kit.gold else accent)
        end
    elseif shape=="balance" then
        detail(parent,"Axe",Vector3.new(0.22,2.2,0.22),root,Kit.gold)
        detail(parent,"Fléau",Vector3.new(3.9,0.2,0.24),root*CFrame.new(0,0.8,0),Kit.gold)
        for _,x in ipairs({-1.55,1.55}) do
            detail(parent,"Plateau",Vector3.new(1.25,0.2,0.6),root*CFrame.new(x,-0.5,0),accent)
        end
    elseif shape=="gear" then
        for i=1,6 do
            local a=math.pi*2*i/6
            detail(parent,"Aube",Vector3.new(0.32,1.65,0.45),
                root*CFrame.new(math.cos(a),math.sin(a),0)*CFrame.Angles(0,0,a),accent)
        end
        orb(parent,"Moyeu",0.85,root,Kit.gold)
    elseif shape=="network" then
        for i=1,5 do
            local a=math.pi*2*i/5
            orb(parent,"Nœud",0.55,root*CFrame.new(math.cos(a)*1.55,math.sin(a)*1.2,0),accent)
            detail(parent,"Liaison",Vector3.new(0.15,1.2,0.15),
                root*CFrame.new(math.cos(a)*0.7,math.sin(a)*0.53,0)*CFrame.Angles(0,0,a),Kit.gold)
        end
    elseif shape=="orbit" or shape=="star" then
        orb(parent,"Cœur",1.0,root,Kit.gold)
        for i=1,5 do
            local a=math.pi*2*i/5
            orb(parent,"Satellite",0.35+(i%2)*0.13,
                root*CFrame.new(math.cos(a)*1.55,math.sin(a)*1.2,0),accent)
        end
    else
        for i=1,4 do
            local a=i*math.pi/2
            detail(parent,"Facet de galerie",Vector3.new(0.75,1.65,0.4),
                root*CFrame.new(math.cos(a)*1.1,math.sin(a)*0.8,0)*CFrame.Angles(0,0,a),
                if i%2==0 then Kit.gold else accent)
        end
    end
end
function Stage.decorate(roomFolder,placeKey,room,origin,index)
    local desc=ICON[placeKey]
    if not desc then return end
    local cx,_,cz=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<26 or d<25 then return end
    local label,sub,shape=table.unpack(desc)
    local group=Instance.new("Folder")
    group.Name="Alcôves minérales v24"
    group:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    group:SetAttribute("KinRoomId",room.room_id)
    group.Parent=roomFolder
    -- Un des murs latéraux au fond de la salle, à distance des portails centraux.
    local count=if Kit.profile=="LITE" then 1 elseif Kit.profile=="SHOWCASE" then 2 else 1
    for n=1,count do
        local x=cx+(if n==1 then -w*0.28 else w*0.28)
        local face=CFrame.new(origin+Vector3.new(x,8.5,cz+d*0.5-1.15))*CFrame.Angles(0,math.pi,0)
        local accent=Kit.accent(placeKey)
        detail(group,"Fond de niche",Vector3.new(9.8,10.3,0.55),face,Kit.deep)
        detail(group,"Champ sarcelle",Vector3.new(8.7,9.2,0.22),face*CFrame.new(0,0,0.45),Kit.primary)
        for _,side in ipairs({-1,1}) do
            Meshes.decorate(group,"Colonne sculptée","mineral_column",Vector3.new(0.8,9.5,0.75),
                face*CFrame.new(side*4.4,0,0.8),Kit.gold)
        end
        detail(group,"Bandeau opalin",Vector3.new(8.4,0.28,0.42),face*CFrame.new(0,4.35,0.75),Kit.opal)
        glyph(group,shape,face*CFrame.new(0,0.6,0.88),index,accent)
        local plaque=Factory.sign(group,"Cartel architectural",(face*CFrame.new(0,-3.7,0.86)).Position,180,
            label,7.9,1.0)
        plaque.CanCollide=false;plaque.CanTouch=false;plaque.CanQuery=false
    end
    return group
end
return Stage
