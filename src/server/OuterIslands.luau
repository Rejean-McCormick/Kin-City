--!strict
-- Six îles, ponts piétons élevés et installations physiques actionnables.
-- Le lac agrandi est créé par CityGenerator, puis l'archipel par ce module.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local F=require(script.Parent.Factory)
local Destinations=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("IslandDestinations"))
local Islands={}
local NAVY=Color3.fromRGB(30,104,100)
local STONE=Color3.fromRGB(219,210,190)
local WOOD=Color3.fromRGB(147,108,76)
local GOLD=Color3.fromRGB(218,178,106)
local function add(parent,name,cf,size,color,material,solid)
    local p=F.part(parent,name,size,cf,color,material)
    if solid==false then p.CanCollide=false;p.CanTouch=false end
    return p
end
local function localPart(parent,name,base,x,y,z,w,h,d,color,mat,solid)
    return add(parent,name,base*CFrame.new(x,y,z),Vector3.new(w,h,d),color,mat,solid)
end
local function rounded(parent,name,cf,diameter,height,color)
    local p=add(parent,name,cf*CFrame.Angles(0,0,math.pi/2),Vector3.new(height,diameter,diameter),color,Enum.Material.Grass,true)
    p.Shape=Enum.PartType.Cylinder
    return p
end
local function globe(parent,name,cf,d,clr,mat)
    local p=add(parent,name,cf,Vector3.new(d,d,d),clr,mat or Enum.Material.SmoothPlastic,false)
    p.Shape=Enum.PartType.Ball
    return p
end
local function plantedTree(parent,base,index,x,z)
    local height=8+(index%3)*2
    localPart(parent,"Tronc de l'île",base,x,height/2,z,1.4,height,1.4,WOOD,Enum.Material.Wood,true)
    local leaf=globe(parent,"Feuillage insulaire",base*CFrame.new(x,height+2.4,z),7+(index%2)*2,Color3.fromRGB(73+(index%3)*10,154+(index%2)*17,116),Enum.Material.Grass)
    leaf.CanCollide=false
end
local function bridge(root,item)
    local t=item.angle
    local radial=Vector3.new(math.cos(t),0,math.sin(t))
    local tangent=Vector3.new(-radial.Z,0,radial.X)
    local bridgeRoot=F.folder(root,"Passerelle — "..item.title)
    bridgeRoot:SetAttribute("KinBridgeId",item.id)
    local function height(f)
        if f<0.23 then return 0.35+16*(f/0.23) end
        if f>0.76 then return 0.35+16*((1-f)/0.24) end
        return 16.35
    end
    local pieces=28
    local from=477
    local to=701
    for step=1,pieces do
        local f1=(step-1)/pieces
        local f2=step/pieces
        local a=radial*(from+(to-from)*f1)+Vector3.new(0,height(f1),0)
        local b=radial*(from+(to-from)*f2)+Vector3.new(0,height(f2),0)
        local segment=b-a
        local length=segment.Magnitude
        local cf=CFrame.lookAt((a+b)/2,b)
        add(bridgeRoot,"Tablier du pont",cf,Vector3.new(12,0.85,length+0.12),STONE,Enum.Material.Cobblestone,true)
        for _,side in ipairs({-1,1}) do
            -- Garde-corps continus; la circulation au centre reste dégagée.
            local rail=add(bridgeRoot,"Garde-corps",cf*CFrame.new(side*5.7,2.2,0),Vector3.new(0.3,0.55,length+0.16),GOLD,Enum.Material.Metal,false)
            rail.CanCollide=false
            if step%2==0 then
                add(bridgeRoot,"Balustre",cf*CFrame.new(side*5.7,1.0,0),Vector3.new(0.38,2.0,0.38),NAVY,Enum.Material.Metal,true)
            end
        end
        if step%7==0 then
            local pos=(a+b)/2-tangent*0
            for _,side in ipairs({-1,1}) do
                local lamp=globe(bridgeRoot,"Lanterne de liaison",CFrame.new(pos+tangent*side*5.8+Vector3.new(0,4,0)),1.0,Color3.fromRGB(255,226,151),Enum.Material.Neon)
                lamp.CanCollide=false
            end
        end
    end
    return bridgeRoot
end
local function islandSection(parent,item,index)
    local angle=item.angle
    local radial=Vector3.new(math.cos(angle),0,math.sin(angle))
    local origin=radial*item.radius
    local base=CFrame.new(origin)*CFrame.Angles(0,math.pi/2-angle,0)
    local clr=Color3.fromRGB(item.color[1],item.color[2],item.color[3])
    local model=Instance.new("Model")
    model.Name=item.title
    model:SetAttribute("KinIslandId",item.id)
    model.Parent=parent
    rounded(model,"Terre de l'île",CFrame.new(origin+Vector3.new(0,-2.2,0)),90,5.4,Color3.fromRGB(73,143,104))
    rounded(model,"Pavement insulaire",CFrame.new(origin+Vector3.new(0,0.55,0)),53,0.4,STONE)
    localPart(model,"Esplanade",base,0,0.7,-15,17,0.35,48,STONE,Enum.Material.Cobblestone,true)
    for k=1,10 do
        local a=k*2.399963+index
        local radius=26+(k%3)*4
        local x=math.cos(a)*radius
        local z=math.sin(a)*radius
        plantedTree(model,base,k,x,z)
    end
    -- Trois pavillons couverts, ouverts au public et utilisables sans téléportation.
    for n=1,3 do
        local a=(n-1)*math.pi*2/3+0.5
        local x,z=math.cos(a)*25,math.sin(a)*25
        localPart(model,"Sol du kiosque",base,x,0.9,z,17,0.55,15,STONE,Enum.Material.Marble,true)
        for _,dx in ipairs({-7,7}) do for _,dz in ipairs({-6,6}) do
            localPart(model,"Colonne d'abri",base,x+dx,5.6,z+dz,0.8,9.3,0.8,NAVY,Enum.Material.Metal,true)
        end end
        localPart(model,"Toit d'abri",base,x,10.5,z,19,1.2,17,clr,Enum.Material.Slate,false)
        local bench=Instance.new("Seat")
        bench.Name="Banc de l'île";bench.Size=Vector3.new(5,0.8,2.8)
        bench.CFrame=base*CFrame.new(x,1.5,z)
        bench.Anchored=true;bench.Color=WOOD;bench.Material=Enum.Material.WoodPlanks;bench.Parent=model
    end
    local exhibit=Instance.new("Model")
    exhibit.Name="Installation — "..item.caption
    exhibit.Parent=model
    localPart(exhibit,"Piédestal de l'installation",base,0,2.1,9,13,3.6,13,NAVY,Enum.Material.Marble,true)
    if item.kind=="gardens" then
        for ring=1,3 do
            local d=3+ring*2.6
            for k=1,8 do
                local a=k*math.pi/4
                local flower=globe(exhibit,"Jardin lumineux",base*CFrame.new(math.cos(a)*d,4.1+ring*0.25,9+math.sin(a)*d),1.2,Color3.fromHSV((k/8+ring*0.13)%1,0.52,0.94),Enum.Material.Neon)
                flower:SetAttribute("KinIslandReactive",true)
            end
        end
    elseif item.kind=="arts" then
        for k=1,8 do
            local a=k*math.pi/4
            local sculpture=localPart(exhibit,"Sculpture de scène",base,math.sin(a)*4.7,5.6+math.sin(a)*1.5,9+math.cos(a)*4.7,1.1,4.8,1.1,clr,Enum.Material.Neon,false)
            sculpture:SetAttribute("KinIslandReactive",true)
        end
    elseif item.kind=="energy" then
        for k=1,6 do
            local a=k*math.pi/3
            local turbine=localPart(exhibit,"Aube énergétique",base,math.cos(a)*3.5,6.6,9+math.sin(a)*3.5,5.5,0.4,0.55,GOLD,Enum.Material.Metal,false)
            turbine:SetAttribute("KinIslandRotor",true)
        end
    elseif item.kind=="stars" then
        globe(exhibit,"Soleil symbolique",base*CFrame.new(0,7.1,9),5,GOLD,Enum.Material.Neon):SetAttribute("KinIslandReactive",true)
        for k=1,5 do
            local a=k*1.2566
            globe(exhibit,"Planète",base*CFrame.new(math.cos(a)*5,5.3+(k%2)*2,9+math.sin(a)*5),1.1+(k%2),clr,Enum.Material.Glass)
        end
    elseif item.kind=="archives" then
        for shelf=1,5 do
            local x=(shelf-3)*2.5
            localPart(exhibit,"Volume monumental",base,x,5.8,9,1.7,3.5+(shelf%3),3.4,Color3.fromHSV(shelf/7,0.49,0.8),Enum.Material.Fabric,false):SetAttribute("KinIslandReactive",true)
        end
    else
        for k=1,8 do
            local a=k*math.pi/4
            globe(exhibit,"Anneau de rencontre",base*CFrame.new(math.cos(a)*4.5,5.1,9+math.sin(a)*4.5),1.7,clr,Enum.Material.Neon):SetAttribute("KinIslandReactive",true)
        end
    end
    local terminal=localPart(model,"Console de l'installation locale",base,0,2.5,-2,3.5,4.5,2.0,NAVY,Enum.Material.Metal,true)
    terminal:SetAttribute("KinIslandExperienceId",item.id)
    F.prompt(terminal,"Activer","Installation interactive")
    local info=localPart(model,"Borne du futur service",base,-13,2.4,-3,2.6,4.5,1.7,Color3.fromRGB(48,77,88),Enum.Material.Metal,true)
    info:SetAttribute("KinStubInteractionId",item.id..".kOA")
    info:SetAttribute("KinStubCapabilityId","future.island."..item.kind)
    info:SetAttribute("KinStubTitle",item.title)
    F.prompt(info,"Consulter","Fonction future")
    F.sign(model,"Enseigne de l'île",(base*CFrame.new(0,7.9,-26)).Position,math.deg(math.pi/2-angle),item.title,29,3.5).CanCollide=false
    local beacon=globe(model,"Phare d'orientation",base*CFrame.new(0,15,21),3,clr,Enum.Material.Neon)
    beacon.CanCollide=false
    localPart(model,"Mât du phare",base,0,8,21,1.4,13.8,1.4,NAVY,Enum.Material.Metal,true)
    return model
end
function Islands.make(city)
    local root=F.folder(city,"Archipel des six îles")
    for i,item in ipairs(Destinations) do
        bridge(root,item)
        islandSection(root,item,i)
    end
    root:SetAttribute("KinIslandCount",#Destinations)
    root:SetAttribute("KinBridgeCount",#Destinations)
    return root
end
return Islands
