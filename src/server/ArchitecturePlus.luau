--!strict
-- Grammaire architecturale distincte selon la destination du bâtiment.
-- Aucun asset importé : tout est fabriqué à partir de pièces natives Roblox.
local F = require(script.Parent.Factory)
local A = {}
local function piece(parent,name,base,size,offset,color,material)
    return F.part(parent,name,size,base*CFrame.new(offset),color,material)
end
local function orb(parent,name,base,size,offset,color,material)
    local p=piece(parent,name,base,size,offset,color,material)
    p.Shape=Enum.PartType.Ball
    return p
end
local function cylinder(parent,name,base,diameter,height,offset,color,material)
    local p=piece(parent,name,base,Vector3.new(height,diameter,diameter),offset,color,material)
    -- Cylindre Roblox aligné sur X : conserver son axe vertical avec une rotation locale.
    p.CFrame=base*CFrame.new(offset)*CFrame.Angles(0,0,math.pi/2)
    p.Shape=Enum.PartType.Cylinder
    return p
end
local function pillar(parent,base,x,z,h,stone,accent)
    piece(parent,"Pilier",base,Vector3.new(2.2,h,2.2),Vector3.new(x,h/2,z),stone,Enum.Material.Marble)
    piece(parent,"Chapiteau",base,Vector3.new(3.5,1.0,3.5),Vector3.new(x,h+0.4,z),accent,Enum.Material.Marble)
    piece(parent,"Pied",base,Vector3.new(3.1,0.7,3.1),Vector3.new(x,0.4,z),accent,Enum.Material.Slate)
end
local function staircase(parent,base,d,stone)
    for n=1,3 do
        local depth=2+n*1.3
        local step=piece(parent,"Marche principale",base,Vector3.new(15+n*3,0.35,depth),Vector3.new(0,0.18,-d/2-2-n*1.05),stone,Enum.Material.Marble)
    end
end
local function windowMullions(parent,base,w,d,h,metal)
    local count=math.max(2,math.floor(w/10))
    for level=1,math.max(1,math.floor(h/9)) do
        local y=level*7
        if y<h-4 then
            for i=1,count do
                local x=-w/2+i*w/(count+1)
                piece(parent,"Meneau",base,Vector3.new(0.23,4.6,0.4),Vector3.new(x,y,-d/2-0.45),metal,Enum.Material.Metal).CanCollide=false
                piece(parent,"Linteau fenêtre",base,Vector3.new(4.5,0.34,0.5),Vector3.new(x,y+2.5,-d/2-0.47),metal,Enum.Material.Metal).CanCollide=false
            end
        end
    end
end
function A.decorate(model,structure,building,style)
    local cx,cy,cz=table.unpack(structure.center_studs)
    local w,d=table.unpack(structure.footprint_studs)
    local h=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local accent=F.hex(style.palette.accent)
    local trim=F.hex(style.palette.trim)
    local wall=F.hex(style.palette.wall)
    local id=building.building_id
    local family=structure.style_id
    staircase(model,base,d,trim)
    windowMullions(model,base,w,d,h,trim)
    -- Nombre limité d'ornements répétables pour les appareils modestes.
    if family=="civic_stone" then
        local doorwayHalf=6.6
        for i=-2,2 do
            local px=i*9
            if math.abs(px)>doorwayHalf then
                pillar(model,base,px,-d/2-3,math.min(13,h-4),trim,accent)
            end
        end
        piece(model,"Fronton civique",base,Vector3.new(w-4,2,5),Vector3.new(0,math.min(16,h-3),-d/2-2.4),accent,Enum.Material.Marble)
        for i=-2,2 do
            piece(model,"Parapet",base,Vector3.new(7,3,3),Vector3.new(i*(w-8)/5,h+1,-d/2+1),trim,Enum.Material.Marble)
        end
        if string.find(id,"justice") then
            cylinder(model,"Rotonde",base,19,4,Vector3.new(0,h+2,0),trim,Enum.Material.Marble)
            orb(model,"Coupole",base,Vector3.new(20,10,20),Vector3.new(0,h+8,0),accent,Enum.Material.Slate)
            cylinder(model,"Flèche",base,1.5,8,Vector3.new(0,h+14,0),trim,Enum.Material.Metal)
        else
            cylinder(model,"Cloche du conseil",base,12,6,Vector3.new(0,h+3,0),trim,Enum.Material.Marble)
            orb(model,"Dôme hôtel de ville",base,Vector3.new(14,8,14),Vector3.new(0,h+8,0),accent,Enum.Material.Metal)
        end
    elseif family=="warm_academic" then
        local doorwayHalf=6.8
        for x=-w/2+5,w/2-5,9 do
            if math.abs(x)>doorwayHalf then
                pillar(model,base,x,-d/2-1.2,math.min(12,h-4),trim,wall)
            end
        end
        for i=-2,2 do
            piece(model,"Toiture académique",base,Vector3.new(math.max(8,w/5-1),1.3,d+2),Vector3.new(i*w/5,h+1.1,0),accent,Enum.Material.Slate)
        end
        for side=-1,1,2 do
            piece(model,"Tourelle",base,Vector3.new(7,12,7),Vector3.new(side*(w/2-5),h+5,-d/2+6),wall,Enum.Material.Brick)
            piece(model,"Couronnement",base,Vector3.new(10,2,10),Vector3.new(side*(w/2-5),h+11,-d/2+6),trim,Enum.Material.Slate)
        end
        if string.find(id,"university") then
            piece(model,"Beffroi",base,Vector3.new(12,15,12),Vector3.new(0,h+7,0),trim,Enum.Material.Marble)
            piece(model,"Toit beffroi",base,Vector3.new(15,3,15),Vector3.new(0,h+16,0),accent,Enum.Material.Slate)
        end
    elseif family=="central_glass" then
        for y=9,h-5,10 do
            piece(model,"Bande lumineuse",base,Vector3.new(w+0.3,0.5,d+0.3),Vector3.new(0,y,0),accent,Enum.Material.Neon).CanCollide=false
        end
        for x=-w/2+4,w/2-4,8 do
            piece(model,"Nervure tour",base,Vector3.new(1,h,1),Vector3.new(x,h/2,-d/2-0.8),trim,Enum.Material.Metal)
        end
        orb(model,"Sphère du savoir",base,Vector3.new(11,11,11),Vector3.new(0,h+13,0),accent,Enum.Material.Glass)
        piece(model,"Antenne",base,Vector3.new(1,19,1),Vector3.new(0,h+25,0),trim,Enum.Material.Metal)
    elseif family=="innovation_glass" then
        for side=-1,1,2 do
            piece(model,"Aile laboratoire",base,Vector3.new(w*0.26,h*0.55,d*0.75),Vector3.new(side*w*0.36,h*0.275,4),wall,Enum.Material.Glass)
            piece(model,"Aile accent",base,Vector3.new(w*0.28,1.5,d*0.78),Vector3.new(side*w*0.36,h*0.55,4),accent,Enum.Material.Metal)
        end
        for i=-2,2 do
            piece(model,"Lames solaires",base,Vector3.new(w*0.17,0.4,d*0.5),Vector3.new(i*w/5,h+2,-d/5),Color3.fromRGB(56,92,114),Enum.Material.Glass)
        end
    elseif family=="cultural_copper" then
        for x=-w/2+8,w/2-8,14 do
            piece(model,"Niche musée",base,Vector3.new(8,h*0.53,0.7),Vector3.new(x,h*0.54,-d/2-0.7),trim,Enum.Material.Marble)
            orb(model,"Médaillon",base,Vector3.new(5,5,1),Vector3.new(x,h*0.75,-d/2-1.2),accent,Enum.Material.Metal)
        end
        orb(model,"Verrière musée",base,Vector3.new(w*0.55,12,d*0.5),Vector3.new(0,h+2,0),Color3.fromRGB(130,180,178),Enum.Material.Glass)
        for i=-2,2 do
            piece(model,"Patine cuivre",base,Vector3.new(w/6,1.2,d+1),Vector3.new(i*w/6,h+1,0),accent,Enum.Material.CorrodedMetal)
        end
    elseif family=="service_brick" then
        for y=7,h-3,6 do
            piece(model,"Bande admin",base,Vector3.new(w+0.4,0.6,d+0.4),Vector3.new(0,y,0),accent,Enum.Material.Metal)
        end
        for x=-w/2+8,w/2-8,12 do
            piece(model,"Pilastre admin",base,Vector3.new(1,h-2,2.5),Vector3.new(x,h/2,-d/2-1),trim,Enum.Material.Brick)
        end
    end
    -- Enseigne cohérente avec le style, visible depuis la rue.
    local under=piece(model,"Bande enseigne",base,Vector3.new(math.min(w-9,52),4.4,0.4),Vector3.new(0,math.min(h-3,18),-d/2-2),Color3.fromRGB(36,48,54),Enum.Material.Metal)
    under.CanCollide=false
    return model
end
return A
