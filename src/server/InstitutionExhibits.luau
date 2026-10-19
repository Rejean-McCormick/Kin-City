--!strict
-- Sculptures éducatives uniques au centre des huit grands atriums.
-- Objets navigables, sans contenu sensible ni connexion réseau.
local F=require(script.Parent.Factory)
local Exhibit={}
local stone=Color3.fromRGB(220,205,177)
local iron=Color3.fromRGB(58,77,86)
local blue=Color3.fromRGB(80,179,198)
local copper=Color3.fromRGB(190,149,89)
local function part(parent,name,origin,size,x,y,z,color,material)
    return F.part(parent,name,size,CFrame.new(origin+Vector3.new(x,y,z)),color,material)
end
local function orb(parent,name,origin,radius,x,y,z,color)
    local p=part(parent,name,origin,Vector3.new(radius,radius,radius),x,y,z,color,Enum.Material.Glass)
    p.Shape=Enum.PartType.Ball
    p.CanCollide=false
    return p
end
local function interactive(parent,key,origin,title)
    local box=part(parent,"Socle interactif",origin,Vector3.new(3.7,4.2,2.0),14,2.1,68,iron,Enum.Material.Metal)
    part(parent,"Écran d'exposition",origin,Vector3.new(3.0,2.6,0.2),14,3.1,66.9,blue,Enum.Material.Neon).CanCollide=false
    box:SetAttribute("KinStubInteractionId",key..".atrium.exhibit")
    box:SetAttribute("KinStubCapabilityId","future."..key..".exhibit")
    box:SetAttribute("KinStubTitle",title)
    F.prompt(box,"Explorer",title)
end
local function library(parent,origin)
    for _,x in ipairs({-16,-8,0,8}) do
        local case=part(parent,"Archive verticale",origin,Vector3.new(6,11,2.4),x,5.5,68,Color3.fromRGB(119,78,49),Enum.Material.WoodPlanks)
        for y=2,9,2 do
            for n=1,6 do
                part(parent,"Volume relié",origin,Vector3.new(0.6,1.25,1.5),x-2.5+n*0.73,y,66.8,Color3.fromHSV((n+y)*0.084,0.55,0.80),Enum.Material.SmoothPlastic)
            end
        end
    end
end
local function justice(parent,origin)
    part(parent,"Colonne de justice",origin,Vector3.new(1.6,10,1.6),-4,5,68,stone,Enum.Material.Marble)
    part(parent,"Balance",origin,Vector3.new(17,0.6,0.8),-4,10.2,68,copper,Enum.Material.Metal)
    for _,x in ipairs({-12,4}) do
        part(parent,"Chaîne balance",origin,Vector3.new(0.25,3,0.25),x,8.4,68,copper,Enum.Material.Metal)
        local bowl=part(parent,"Plateau balance",origin,Vector3.new(5,0.7,5),x,6.8,68,stone,Enum.Material.Marble)
        bowl.Shape=Enum.PartType.Cylinder
    end
end
local function university(parent,origin)
    orb(parent,"Soleil du savoir",origin,5,-6,10,68,Color3.fromRGB(255,198,74))
    for i=1,6 do
        local theta=i*1.04
        local x=-6+math.cos(theta)*9
        local z=68+math.sin(theta)*6
        orb(parent,"Planète",origin,1.8+(i%3)*0.6,x,7+i%3,z,Color3.fromHSV(i/7,0.55,0.85))
    end
end
local function innovation(parent,origin)
    part(parent,"Prototypage",origin,Vector3.new(20,1,10),-3,1.5,68,stone,Enum.Material.Metal)
    part(parent,"Tour de démonstration",origin,Vector3.new(2,10,2),-3,7,68,iron,Enum.Material.Metal)
    for i=0,3 do
        local rad=math.rad(i*90)
        local blade=part(parent,"Rotor",origin,Vector3.new(1.3,8,0.5),-3+math.sin(rad)*4,12,68+math.cos(rad)*4,blue,Enum.Material.Metal)
        blade.CFrame=CFrame.new(blade.Position)*CFrame.Angles(0,0,rad)
        blade.CanCollide=false
    end
end
local function museum(parent,origin)
    for i=-2,2 do
        local x=-4+i*5
        part(parent,"Piédestal d'oeuvre",origin,Vector3.new(3.5,3.3,3.5),x,1.6,68,stone,Enum.Material.Marble)
        local art=orb(parent,"Œuvre d'art",origin,2.4,x,5.2,68,Color3.fromHSV((i+3)*0.16,0.34,0.88))
        art.Material=Enum.Material.Metal
    end
end
local function cityhall(parent,origin)
    part(parent,"Maquette de ville",origin,Vector3.new(18,2,11),-4,1.1,69,stone,Enum.Material.Marble)
    for i=1,14 do
        local x=-12+(i%5)*3.5
        local z=64+math.floor(i/5)*3
        local h=2+(i*7)%6
        part(parent,"Miniature urbaine",origin,Vector3.new(2,h,1.9),x,2+h/2,z,Color3.fromHSV(i*0.09,0.22,0.85),Enum.Material.Concrete)
    end
end
local function ekoh(parent,origin)
    part(parent,"Socle du savoir",origin,Vector3.new(12,2,12),-5,1,68,stone,Enum.Material.Marble)
    for i=1,14 do
        local a=i*0.56
        local y=2.4+i*0.85
        local p=orb(parent,"Cristal de connaissances",origin,2.3,-5+math.sin(a)*3.1,y,68+math.cos(a)*3.1,Color3.fromHSV(i*0.09,0.4,0.85))
        p.Material=Enum.Material.Neon
    end
end
local function orgo(parent,origin)
    for i=1,4 do
        local x=-14+(i-1)*6
        part(parent,"Serveur Orgo",origin,Vector3.new(4,9,3),x,4.5,68,iron,Enum.Material.Metal)
        for j=1,6 do
            local p=part(parent,"Indicateur",origin,Vector3.new(2.5,0.17,0.16),x,1+j*1.1,66.35,j%2==0 and blue or copper,Enum.Material.Neon)
            p.CanCollide=false
        end
    end
end
local renderer={library=library,justice_palace=justice,campus=university,innovation_lab=innovation,museum=museum,city_hall=cityhall,ekoh_tower=ekoh,orgo_center=orgo}
local titles={library="Conservatoire des livres",justice_palace="Justice et médiation",campus="Sciences et découvertes",innovation_lab="Fabrique des inventions",museum="Patrimoine vivant",city_hall="Plans de la cité",ekoh_tower="Savoir collectif",orgo_center="Réseau des services"}
function Exhibit.make(model,key,origin)
    local folder=F.folder(model,"Œuvre centrale de l'atrium")
    local fn=renderer[key]
    if fn then fn(folder,origin) end
    interactive(folder,key,origin,titles[key] or "Exposition")
    return folder
end
return Exhibit
