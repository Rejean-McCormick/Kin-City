--!strict
-- Petits pavillons réellement accessibles depuis la rue :
-- pas de téléportation, porte physique ouverte et terminal local en stub.
local F=require(script.Parent.Factory)
local Neighborhoods={}
local Conservatories=require(script.Parent.LearningConservatories)
local categories={
    {name="Café des idées",room="Rencontres",color=Color3.fromRGB(208,168,119)},
    {name="Atelier citoyen",room="Création",color=Color3.fromRGB(143,176,153)},
    {name="Maison des découvertes",room="Savoir",color=Color3.fromRGB(179,172,204)},
    {name="Galerie de quartier",room="Culture",color=Color3.fromRGB(212,158,144)},
    {name="Pavillon communautaire",room="Entraide",color=Color3.fromRGB(168,193,213)},
    {name="Atelier de réparation",room="Innovation",color=Color3.fromRGB(197,179,139)}
}
local function part(parent,name,base,size,offset,color,material)
    return F.part(parent,name,size,base*CFrame.new(offset),color,material)
end
local function capsule(parent,base,x,z,color)
    part(parent,"Table",base,Vector3.new(5,0.5,3),Vector3.new(x,2.5,z),Color3.fromRGB(103,77,59),Enum.Material.WoodPlanks)
    for _,sign in ipairs({-1,1}) do
        part(parent,"Tabouret",base,Vector3.new(1.7,1.6,1.7),Vector3.new(x+sign*4,0.8,z),color,Enum.Material.Wood)
    end
end
function Neighborhoods.make(parent,plan)
    local root=F.folder(parent,"Pavillons de quartier")
    local prompts={}
    local exterior=plan.structures
    for index=1,60 do
        local theta=(index-0.5)*math.pi*2/60
        local radius=420+(index%3)*7
        local x,z=radius*math.cos(theta),radius*math.sin(theta)
        local blocked=false
        for _,s in ipairs(exterior) do
            local dx=x-s.center_studs[1]
            local dz=z-s.center_studs[3]
            if math.sqrt(dx*dx+dz*dz)<64 then blocked=true;break end
        end
        if not blocked and not Conservatories.isReserved(x,z) then
            local category=categories[(index-1)%#categories+1]
            local name=string.format("%s %02d",category.name,index)
            local model=Instance.new("Model");model.Name=name;model:SetAttribute("KinNeighborhoodId","neighborhood."..index);model.Parent=root
            local yaw=math.pi/2-theta
            local base=CFrame.new(x,0,z)*CFrame.Angles(0,yaw,0)
            local w,d,h=22,22,13
            local wall=category.color
            local trim=Color3.fromRGB(233,223,203)
            part(model,"Sol accessible",base,Vector3.new(w,1,d),Vector3.new(0,-0.45,0),trim,Enum.Material.WoodPlanks)
            part(model,"Mur arrière",base,Vector3.new(w,h,1),Vector3.new(0,h/2,d/2),wall,Enum.Material.Brick)
            for _,side in ipairs({-1,1}) do
                part(model,"Mur côté",base,Vector3.new(1,h,d),Vector3.new(side*w/2,h/2,0),wall,Enum.Material.Brick)
                local half=(w-8)/2
                part(model,"Façade latérale",base,Vector3.new(half,h,1),Vector3.new(side*(8/2+half/2),h/2,-d/2),wall,Enum.Material.Brick)
                local pane=part(model,"Fenêtre",base,Vector3.new(4,4,0.18),Vector3.new(side*7,7,-d/2-0.6),Color3.fromRGB(94,157,171),Enum.Material.Glass)
                pane.CanCollide=false
                part(model,"Encadrement",base,Vector3.new(1,h,1.5),Vector3.new(side*4,h/2,-d/2-0.2),trim,Enum.Material.Marble)
            end
            part(model,"Linteau",base,Vector3.new(8,4,1.4),Vector3.new(0,h-2,-d/2),trim,Enum.Material.Marble)
            part(model,"Toit",base,Vector3.new(w+3,1,d+3),Vector3.new(0,h+0.4,0),Color3.fromRGB(66,90,93),Enum.Material.Slate)
            for n=-2,2 do
                part(model,"Lucarne",base,Vector3.new(2.1,0.7,2.1),Vector3.new(n*3.4,h+1.1,-4),category.color,Enum.Material.Metal)
            end
            F.sign(model,"Enseigne pavillon",(base*CFrame.new(0,10.8,-d/2-1.5)).Position,math.deg(yaw),name,18,2.6).CanCollide=false
            local mat=part(model,"Paillasson",base,Vector3.new(8,0.15,3),Vector3.new(0,0.08,-d/2-2),Color3.fromRGB(170,140,96),Enum.Material.Fabric)
            mat.CanCollide=false
            capsule(model,base,-5,4,category.color)
            capsule(model,base,4,5,category.color)
            local console=part(model,"Borne",base,Vector3.new(3,4,1.7),Vector3.new(0,2.1,8),Color3.fromRGB(53,72,77),Enum.Material.Metal)
            part(model,"Écran",base,Vector3.new(2.5,2.2,0.25),Vector3.new(0,3.1,7.05),Color3.fromRGB(66,184,182),Enum.Material.Neon).CanCollide=false
            local prompt=F.prompt(console,"Découvrir",category.room)
            local interactionId=string.format("neighborhood.%02d.terminal",index)
            console:SetAttribute("KinInteractionId",interactionId)
            console:SetAttribute("KinCapabilityId", "future."..category.room)
            prompts[prompt]={kind="ambient",data={interaction_id=interactionId,capability_id="future."..category.room,title=name}}
        end
    end
    return prompts
end
return Neighborhoods
