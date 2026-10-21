--!strict
-- Façades colorées et véritables boutiques traversables de la couronne v13.
-- Construction en mode édition avec primitives natives, aucune Toolbox.
local RS=game:GetService("ReplicatedStorage")
local Places=require(RS:WaitForChild("KinCityShared"):WaitForChild("PromenadeCommerce"))
local Factory=require(script.Parent.Factory)
local CrystalEverydayV19=require(script.Parent.CrystalEverydayV19)
local SecondaryArchitectureV25=require(script.Parent.SecondaryArchitectureV25)
local OpalGlazingV22=require(script.Parent.OpalGlazingV22)
local Shops={}
local STONE=Color3.fromRGB(224,211,187)
local COPPER=Color3.fromRGB(173,120,76)
local INK=Color3.fromRGB(30,104,100)
local GLASS=Color3.fromRGB(197,244,240)
local GOLD=Color3.fromRGB(233,190,113)
local function part(root,label,base,x,y,z,w,h,d,color,material,solid)
    local obj=Factory.part(root,label,Vector3.new(w,h,d),base*CFrame.new(x,y,z),color,material)
    if solid==false then obj.CanCollide=false;obj.CanQuery=false;obj.CanTouch=false end
    return obj
end
local function seat(root,base,x,z)
    local s=Instance.new("Seat")
    s.Name="Chaise de la promenade"
    s.Size=Vector3.new(2.5,0.7,2.3)
    s.CFrame=base*CFrame.new(x,1.5,z)
    s.Anchored=true;s.Color=COPPER;s.Material=Enum.Material.Wood;s.Parent=root
    part(root,"Dossier",base,x,2.4,z+1.15,2.7,1.8,0.3,INK,Enum.Material.Wood)
end
local function plant(root,base,x,z,shade)
    part(root,"Jardinière",base,x,0.9,z,2.6,1.4,2.4,COPPER,Enum.Material.Wood)
    for i=1,3 do
        local bud=part(root,"Feuille",base,x+(i-2)*0.6,2.3,z,1.1,1.8,1.2,shade,Enum.Material.Grass,false)
        bud.Shape=Enum.PartType.Ball
    end
end
local function shop(parent,item)
    local mdl=Instance.new("Model")
    mdl.Name=item.title.." · numéro "..item.slot
    mdl:SetAttribute("KinCommerceId",item.id)
    mdl.Parent=parent
    local center=Vector3.new(item.center_studs[1],0,item.center_studs[3])
    -- Façade orientée vers le centre de l'île (z négatif = accès sur la promenade).
    local base=CFrame.new(center)*CFrame.Angles(0,item.yaw,0)
    local tint=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    local roof=Color3.fromRGB(math.floor(item.color[1]*0.55),math.floor(item.color[2]*0.55),math.floor(item.color[3]*0.55))
    part(mdl,"Fondation ouverte",base,0,0.2,0,17,0.6,21,STONE,Enum.Material.Cobblestone)
    part(mdl,"Mur arrière",base,0,6.5,10.5,17,12.5,0.8,tint,Enum.Material.Brick)
    for _,side in ipairs({-1,1}) do
        part(mdl,"Mur latéral",base,side*8.5,6.5,0,0.8,12.5,21,tint,Enum.Material.Brick)
        local glass=part(mdl,"Vitrine",base,side*5.75,5.6,-10.55,5.5,6.6,0.25,GLASS,Enum.Material.Glass,false)
        OpalGlazingV22.apply(glass,false)
        part(mdl,"Volet de vitrine",base,side*5.7,10.8,-10.65,5.7,0.4,0.3,COPPER,Enum.Material.Wood,false)
        part(mdl,"Pilier",base,side*8.4,6.4,-10.5,0.9,12.5,0.9,INK,Enum.Material.Metal)
        plant(mdl,base,side*12,-11,tint)
    end
    -- Passage central de 5,6 studs : pas de mur ou porte bloquante.
    part(mdl,"Linteau",base,0,11,-10.6,5.8,3.2,0.7,COPPER,Enum.Material.Wood)
    part(mdl,"Toiture ardoise",base,0,13.4,0,19.5,0.9,23,roof,Enum.Material.Slate)
    part(mdl,"Auvent textile",base,0,10.6,-13.0,14,0.5,5.4,tint,Enum.Material.Fabric,false)
    part(mdl,"Chemin du trottoir",base,0,0.11,-15,7,0.2,13,STONE,Enum.Material.Cobblestone)
    for i=1,3 do
        local xx=if i%2==0 then 3.8 else -3.8
        local zz=-2+(i-1)*4
        part(mdl,"Comptoir de fabrication",base,xx,2.1,zz,4.9,0.6,2.5,COPPER,Enum.Material.WoodPlanks)
        local palette=Color3.fromHSV((item.slot*0.072+i*0.17)%1,0.4,0.82)
        for k=1,4 do
            local piece=part(mdl,"Objet fait main",base,xx-1.7+(k-1)*1.12,2.95,zz,0.65,1.1+(k%2)*0.6,0.85,palette,Enum.Material.SmoothPlastic,false)
            if item.kind=="ceramics" then piece.Shape=Enum.PartType.Cylinder end
        end
    end
    for level=1,3 do
        part(mdl,"Rayon d'exposition",base,-6.4,1.8+level*2.45,7,2.1,0.35,4.5,COPPER,Enum.Material.Wood)
        for row=1,3 do
            part(mdl,"Collection",base,-6.4,2.5+level*2.45,5.2+row*0.9,1.1,1.45,0.6,tint,Enum.Material.Fabric,false)
        end
    end
    seat(mdl,base,4.5,-6)
    local switch=part(mdl,"Commande de vitrine cinétique",base,6.5,2.2,7.1,2.5,3.6,1.7,INK,Enum.Material.Metal)
    switch:SetAttribute("KinCommerceAction","display")
    switch:SetAttribute("KinCommerceId",item.id)
    Factory.prompt(switch,"Animer l'atelier",item.title)
    local mobile=Instance.new("Model")
    mobile.Name="Présentoir mobile"
    mobile:SetAttribute("KinCommerceDisplay",item.id)
    mobile.Parent=mdl
    local pivot=part(mobile,"Pivot",base,0,4.2,4.4,0.4,0.4,0.4,GOLD,Enum.Material.Metal,false)
    pivot.Transparency=1;mobile.PrimaryPart=pivot
    part(mobile,"Socle du présentoir",base,0,3.7,4.4,3.5,0.5,3.5,COPPER,Enum.Material.Wood)
    for n=1,4 do
        local ang=n*math.pi/2
        local jewel=part(mobile,"Pièce tournante",base,math.cos(ang)*1.2,5.2,4.4+math.sin(ang)*1.2,0.95,1.8,0.95,if n%2==0 then GOLD else tint,Enum.Material.Neon,false)
        jewel.Shape=Enum.PartType.Ball
    end
    -- Consultation préparée pour une future fonctionnalité : aucun achat ni débit.
    local future=part(mdl,"Terminal de future activité",base,-5.6,2.3,-3.8,2.4,3.8,1.5,INK,Enum.Material.Metal)
    future:SetAttribute("KinStubInteractionId",item.id..".catalog.future")
    future:SetAttribute("KinStubCapabilityId","future.commerce.catalog")
    future:SetAttribute("KinStubTitle",item.title)
    Factory.prompt(future,"Consulter", "Fonctionnalité à venir")
    part(mdl,"Écran du catalogue",base,-5.6,3.1,-4.65,1.9,1.8,0.15,GLASS,Enum.Material.Neon,false)
    Factory.sign(mdl,"Enseigne d'atelier",(base*CFrame.new(0,13.2,-13.65)).Position,math.deg(item.yaw),item.title,18.8,3.25).CanCollide=false
    CrystalEverydayV19.frame(mdl,base,17,21,13.4,"commerce")
    SecondaryArchitectureV25.boutique(mdl,base,item.kind,tint)
    return mdl
end
function Shops.isReserved(x,z)
    for _,item in ipairs(Places) do
        local dx=x-item.center_studs[1]
        local dz=z-item.center_studs[3]
        if dx*dx+dz*dz<17*17 then return true end
    end
    return false
end
function Shops.make(city)
    local root=Factory.folder(city,"Promenade des métiers — boutiques visitables")
    local last=nil
    for _,item in ipairs(Places) do
        shop(root,item)
        -- Petites allées tangentielles entre voisins proches, sans pont à travers
        -- les agoras et les débarcadères explicitement exclus du registre.
        if last and item.slot-last.slot<=2 then
            local a=Vector3.new(last.center_studs[1],0.13,last.center_studs[3])
            local b=Vector3.new(item.center_studs[1],0.13,item.center_studs[3])
            local d=b-a
            local seg=Factory.part(root,"Rue des artisans",Vector3.new(5,0.24,d.Magnitude),CFrame.lookAt((a+b)/2,b),STONE,Enum.Material.Cobblestone)
            seg.CanCollide=false
        end
        last=item
    end
    root:SetAttribute("KinCommerceShopsBuilt",#Places)
    return root
end
return Shops
