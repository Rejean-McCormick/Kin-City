--!strict
-- Kin City v16 : façades emblématiques propres aux huit institutions.
-- Ornements non-collidables devant la façade : les portes restent accessibles.
local F=require(script.Parent.Factory)
local Facades={}
local COLD=Color3.fromRGB(37,60,71)
local WARM=Color3.fromRGB(233,216,176)
local GLASS=Color3.fromRGB(143,213,221)
local STYLES={
    city_hall={"HÔTEL DE VILLE","city",Color3.fromRGB(229,183,112)},
    ekoh_tower={"LA TOUR DES SAVOIRS","network",Color3.fromRGB(97,215,192)},
    library={"GRANDE BIBLIOTHÈQUE","books",Color3.fromRGB(142,195,225)},
    campus={"UNIVERS-CITÉ","orbits",Color3.fromRGB(183,157,226)},
    justice_palace={"PALAIS DES ÉQUILIBRES","balance",Color3.fromRGB(222,189,131)},
    innovation_lab={"LABORATOIRE D'INNOVATION","turbine",Color3.fromRGB(94,214,226)},
    museum={"MUSÉE KREATIVE","art",Color3.fromRGB(229,144,165)},
    orgo_center={"CENTRE ORGO","network",Color3.fromRGB(138,184,232)},
}
local function p(parent,name,base,x,y,z,sx,sy,sz,color,mat)
    local q=F.part(parent,name,Vector3.new(sx,sy,sz),base*CFrame.new(x,y,z),color,mat)
    q.CanCollide=false;q.CanTouch=false;q.CanQuery=false
    return q
end
local function orb(parent,name,base,x,y,z,size,color)
    local q=p(parent,name,base,x,y,z,size,size,size,color,Enum.Material.Glass)
    q.Shape=Enum.PartType.Ball
    return q
end
local function link(parent,base,a,b,size,color)
    local from=(base*CFrame.new(a)).Position
    local dest=(base*CFrame.new(b)).Position
    local delta=dest-from
    local part=F.part(parent,"Liaison sculpturale",Vector3.new(size,size,delta.Magnitude),CFrame.lookAt((from+dest)*0.5,dest),color,Enum.Material.Metal)
    part.CanCollide=false;part.CanTouch=false;part.CanQuery=false
end
local function motif(parent,base,kind,accent,front,w,height)
    local y=math.min(height-7,math.max(13,height*0.65))
    if kind=="city" then
        for i=-3,3 do
            p(parent,"Colonnade citoyenne",base,i*4.3,y*0.46,front-0.55,0.65,y*0.8,0.65,accent,Enum.Material.Marble)
        end
        p(parent,"Frise civique",base,0,y*0.88,front-0.7,33,1.1,0.8,WARM,Enum.Material.Marble)
        orb(parent,"Hologramme central",base,0,y+1.5,front-1.5,3.6,accent)
    elseif kind=="books" then
        for n=1,9 do
            local x=-20+(n-1)*5
            local h=4+(n%3)*2
            local book=p(parent,"Ouvrage architectural",base,x,y,front-0.65,3.1,h,0.5,if n%2==0 then accent else WARM,Enum.Material.Marble)
            book.CFrame=book.CFrame*CFrame.Angles(0,0,math.rad((n%3-1)*5))
        end
    elseif kind=="orbits" then
        orb(parent,"Soleil du campus",base,0,y,front-1,4.5,WARM)
        for n=1,8 do
            local a=2*math.pi*n/8
            local x=math.cos(a)*14
            local yy=y+math.sin(a)*7
            orb(parent,"Astres du savoir",base,x,yy,front-1.1,1.5+(n%3)*0.4,accent)
            if n%2==0 then link(parent,base,Vector3.new(0,y,front-1),Vector3.new(x,yy,front-1.1),0.22,WARM) end
        end
    elseif kind=="balance" then
        p(parent,"Axe de la justice",base,0,y,front-1,0.9,12,0.8,WARM,Enum.Material.Marble)
        p(parent,"Traverse de l'équilibre",base,0,y+4.8,front-1,25,0.8,0.8,accent,Enum.Material.Metal)
        for _,side in ipairs({-1,1}) do
            p(parent,"Suspension",base,side*10, y+1.7,front-1,0.3,6,0.3,WARM,Enum.Material.Metal)
            p(parent,"Plateau",base,side*10, y-1.5,front-1,5.5,0.5,4.3,accent,Enum.Material.Metal)
        end
    elseif kind=="turbine" then
        orb(parent,"Coeur mécanique",base,0,y,front-1,5,accent)
        for n=1,10 do
            local a=n*2*math.pi/10
            local blade=p(parent,"Pale architecturale",base,math.cos(a)*9,y+math.sin(a)*7,front-1,4.2,1.0,0.5,if n%2==0 then accent else WARM,Enum.Material.Metal)
            blade.CFrame=blade.CFrame*CFrame.Angles(0,0,a)
        end
    elseif kind=="art" then
        for n=1,11 do
            local x=-22+n*4
            local yy=y+math.sin(n*0.9)*5
            local s=p(parent,"Vitrail sculptural",base,x,yy,front-1,2.4,4.8,0.35,Color3.fromHSV(n/11,0.53,0.92),Enum.Material.Glass)
            s.Transparency=0.16
        end
    else
        local nodes={}
        for n=1,9 do
            local a=n*2*math.pi/9
            local v=Vector3.new(math.cos(a)*17,y+math.sin(a)*6,front-1)
            nodes[n]=v
            orb(parent,"Noeud de savoir",base,v.X,v.Y,v.Z,1.8,accent)
        end
        for n=1,9 do
            link(parent,base,nodes[n],nodes[n%9+1],0.3,WARM)
        end
    end
end
function Facades.make(model,structure,building,style)
    local key=building.interior_place_key
    local subject=STYLES[key]
    if not subject then return nil end
    local cx,cy,cz=table.unpack(structure.center_studs)
    local w,d=table.unpack(structure.footprint_studs)
    local h=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local accent=subject[3]
    local folder=F.folder(model,"Façade emblématique v16")
    local front=-d/2-1.8
    -- Strates horizontales et trame de vitraux à faible coût en primitives.
    for _,heightFraction in ipairs({0.28,0.5,0.75}) do
        local y=h*heightFraction
        p(folder,"Ruban de pierre",base,0,y,front+1,math.min(w-5,70),0.45,0.6,accent,Enum.Material.Marble)
    end
    for _,s in ipairs({-1,1}) do
        local x=s*math.min(w*0.38,29)
        p(folder,"Ailette de façade",base,x,h*0.5,front+0.8,0.65,h*0.72,1.2,accent,Enum.Material.Metal)
        for y=10,math.max(10,h-8),9 do
            local glass=p(folder,"Vitrail de quartier",base,x-s*3,y,front+0.25,2.7,4.5,0.25,GLASS,Enum.Material.Glass)
            glass.Transparency=0.25
        end
        p(folder,"Colonne monumentale",base,s*12,7.2,front-1,1.4,14.4,1.5,WARM,Enum.Material.Marble)
        p(folder,"Chapiteau monumental",base,s*12,14.6,front-1,3,1,2.5,accent,Enum.Material.Marble)
    end
    -- Le motif est au-dessus du seuil; aucune pièce ne barre la porte centrale.
    motif(folder,base,subject[2],accent,front,w,h)
    return folder
end
return Facades
