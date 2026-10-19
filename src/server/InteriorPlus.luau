--!strict
-- Vocabulaire intérieur spécifique aux institutions, sans bloquer les axes de circulation.
local F=require(script.Parent.Factory)
local Interiors={}
local function place(parent,base,name,size,offset,color,material)
    return F.part(parent,name,size,base*CFrame.new(offset),color,material)
end
local function ball(parent,base,name,size,offset,color,material)
    local p=place(parent,base,name,size,offset,color,material)
    p.Shape=Enum.PartType.Ball
    return p
end
local cream=Color3.fromRGB(244,234,213)
local graphite=Color3.fromRGB(48,63,75)
local bronze=Color3.fromRGB(176,131,73)
local textile=Color3.fromRGB(66,123,120)
local timber=Color3.fromRGB(134,95,62)
local function tableDesk(parent,base,x,z,metalColor)
    place(parent,base,"Bureau",Vector3.new(7,0.5,3.5),Vector3.new(x,2.5,z),timber,Enum.Material.WoodPlanks)
    for _,sx in ipairs({-2.6,2.6}) do
        place(parent,base,"Pied",Vector3.new(0.4,2.2,0.5),Vector3.new(x+sx,1.1,z),metalColor,Enum.Material.Metal)
    end
    place(parent,base,"Document",Vector3.new(2,0.08,1.5),Vector3.new(x+0.8,2.82,z),cream,Enum.Material.SmoothPlastic).CanCollide=false
end
local function shelf(parent,base,x,z)
    place(parent,base,"Bibliothèque",Vector3.new(6.5,9,1.6),Vector3.new(x,4.5,z),timber,Enum.Material.WoodPlanks)
    for row=1,4 do
        place(parent,base,"Planche",Vector3.new(6.2,0.22,2),Vector3.new(x,row*1.9,z),bronze,Enum.Material.Wood)
        for col=1,7 do
            local clr=Color3.fromHSV((row*0.13+col*0.107)%1,0.5,0.8)
            place(parent,base,"Livre",Vector3.new(0.5,1.2,1.2),Vector3.new(x-2.7+(col-1)*0.85,row*1.9+0.75,z),clr,Enum.Material.SmoothPlastic)
        end
    end
end
local function podium(parent,base,x,z)
    place(parent,base,"Socle",Vector3.new(8,1.1,5),Vector3.new(x,0.55,z),bronze,Enum.Material.Marble)
    place(parent,base,"Pupitre",Vector3.new(3.4,3.4,2.3),Vector3.new(x,3.0,z),timber,Enum.Material.Wood)
    place(parent,base,"Plateau",Vector3.new(4.3,0.45,2.9),Vector3.new(x,4.8,z),cream,Enum.Material.Marble)
end
local function researchDesk(parent,base,x,z)
    tableDesk(parent,base,x,z,graphite)
    place(parent,base,"Instrument",Vector3.new(2,2.3,1.1),Vector3.new(x-1,4,z),graphite,Enum.Material.Metal)
    place(parent,base,"Ecran instrument",Vector3.new(1.6,1.5,0.15),Vector3.new(x-1,4.1,z-0.63),Color3.fromRGB(98,213,206),Enum.Material.Neon).CanCollide=false
    for n=1,3 do
        ball(parent,base,"Éprouvette",Vector3.new(0.7,1.5,0.7),Vector3.new(x+1+n*0.4,3.9,z),Color3.fromHSV(n/5,0.65,0.85),Enum.Material.Glass).CanCollide=false
    end
end
local function exhibit(parent,base,x,z,seed)
    place(parent,base,"Piédestal",Vector3.new(4.4,3,4.4),Vector3.new(x,1.5,z),cream,Enum.Material.Marble)
    local obj=ball(parent,base,"Œuvre",Vector3.new(3,4.8,3),Vector3.new(x,5.6,z),Color3.fromHSV(seed*0.21,0.4,0.73),Enum.Material.Metal)
    obj.CanCollide=false
    place(parent,base,"Cartel",Vector3.new(3.5,0.3,1.2),Vector3.new(x,3,z+2),graphite,Enum.Material.Metal).CanCollide=false
end
local function panel(parent,base,x,z,title,accent)
    local p=place(parent,base,"Panneau",Vector3.new(9,6,0.3),Vector3.new(x,7,z),graphite,Enum.Material.Metal)
    p.CanCollide=false
    F.sign(parent,"Panneau : "..title,(base*CFrame.new(x,7,z-0.3)).Position,0,title,8,2.6).CanCollide=false
    place(parent,base,"Bande",Vector3.new(8.5,0.3,0.5),Vector3.new(x,10,z),accent,Enum.Material.Neon).CanCollide=false
end
local function chandelier(parent,base,x,z,accent)
    place(parent,base,"Chaîne",Vector3.new(0.3,2.2,0.3),Vector3.new(x,13.4,z),graphite,Enum.Material.Metal).CanCollide=false
    local p=ball(parent,base,"Lustre",Vector3.new(5,1.3,5),Vector3.new(x,12.0,z),accent,Enum.Material.Neon)
    p.CanCollide=false
    local light=Instance.new("PointLight");light.Brightness=1.1;light.Range=30;light.Parent=p
end
function Interiors.decorateRoom(parent,placeKey,room,origin,style,roomIndex)
    local x,_,z=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    local base=CFrame.new(origin+Vector3.new(x,0,z))
    local tint=F.hex(style.palette.accent)
    local trim=F.hex(style.palette.trim)
    local rug=place(parent,base,"Tapis central",Vector3.new(math.min(18,w*0.45),0.08,math.min(15,d*0.34)),Vector3.new(0,0.07,0),tint,Enum.Material.Fabric)
    rug.CanCollide=false
    -- Allées centrales entièrement dégagées : décoration contre les murs latéraux.
    for _,side in ipairs({-1,1}) do
        local wallX=side*(w/2-3.2)
        for i=-1,1 do
            place(parent,base,"Lambris",Vector3.new(1.1,6,7),Vector3.new(side*(w/2-0.8),3,i*d/4),trim,Enum.Material.Wood).CanCollide=false
        end
        place(parent,base,"Colonne décorative",Vector3.new(1.8,13,1.8),Vector3.new(side*(w/2-1.6),6.5,-d/2+2),trim,Enum.Material.Marble)
        place(parent,base,"Socle colonnette",Vector3.new(2.6,0.6,2.6),Vector3.new(side*(w/2-1.6),0.3,-d/2+2),tint,Enum.Material.Marble)
        if placeKey=="library" then
            shelf(parent,base,wallX,side*2.5)
            shelf(parent,base,wallX,-side*10)
        elseif placeKey=="campus" then
            tableDesk(parent,base,wallX,side*7,graphite)
            place(parent,base,"Tableau cours",Vector3.new(1,5,10),Vector3.new(side*(w/2-0.5),8,0),graphite,Enum.Material.Slate).CanCollide=false
        elseif placeKey=="justice_palace" or placeKey=="city_hall" then
            tableDesk(parent,base,wallX,side*8,bronze)
            podium(parent,base,wallX,-side*8)
        elseif placeKey=="museum" then
            exhibit(parent,base,wallX,side*8,roomIndex+side)
            exhibit(parent,base,wallX,-side*8,roomIndex+4)
        elseif placeKey=="innovation_lab" then
            researchDesk(parent,base,wallX,side*7)
            researchDesk(parent,base,wallX,-side*9)
        elseif placeKey=="orgo_center" then
            tableDesk(parent,base,wallX,side*8,graphite)
            panel(parent,base,side*(w/2-1),-side*7,"SERVICES",tint)
        elseif placeKey=="ekoh_tower" then
            exhibit(parent,base,wallX,side*8,roomIndex+side)
            panel(parent,base,side*(w/2-1),-side*6,"EKO H",tint)
        end
    end
    for n=1,3 do
        local zz=-d/2+8+n*(d-16)/4
        local beam=place(parent,base,"Poutre plafond",Vector3.new(w-3,0.45,0.6),Vector3.new(0,15.2,zz),trim,Enum.Material.Wood)
        beam.CanCollide=false
    end
    chandelier(parent,base,0,0,tint)
    local title=room.display_name or room.room_id
    -- Frise d'identification sur un pan non traversant.
    F.sign(parent,"Identité de pièce",(base*CFrame.new(0,11,d/2-0.45)).Position,180,title,math.min(w-9,30),2.3).CanCollide=false
end
return Interiors
