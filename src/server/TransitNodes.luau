--!strict
-- Navettes locales entre la place centrale et les entrées institutionnelles.
-- Aucun portail externe, aucun calcul ou paiement. Contrôle de destination côté serveur.
local F=require(script.Parent.Factory)
local Transit={}
local gold=Color3.fromRGB(201,167,107)
local navy=Color3.fromRGB(34,62,73)
local function terminal(parent,position,title,id,anchor)
    local m=F.folder(parent,"Navette "..title)
    F.part(m,"Plateforme",Vector3.new(9,0.4,9),CFrame.new(position+Vector3.new(0,0.15,0)),navy,Enum.Material.Metal)
    for _,side in ipairs({-1,1}) do
        F.part(m,"Colonne",Vector3.new(0.5,8,0.5),CFrame.new(position+Vector3.new(side*3.5,4,2.5)),gold,Enum.Material.Metal)
    end
    F.part(m,"Arche",Vector3.new(8,0.6,1.0),CFrame.new(position+Vector3.new(0,8,2.5)),gold,Enum.Material.Metal)
    local kiosk=F.part(m,"Destination",Vector3.new(5.6,4.3,1.2),CFrame.new(position+Vector3.new(0,2.25,-2.5)),navy,Enum.Material.Metal)
    local label=F.sign(m,"Destination affichée",position+Vector3.new(0,3.3,-3.3),0,title,5,2.8)
    label.CanCollide=false
    kiosk:SetAttribute("KinShuttleId",id)
    kiosk:SetAttribute("KinShuttleAnchor",anchor)
    F.prompt(kiosk,"Se rendre","Destination : "..title)
    return m
end
function Transit.make(parent,plan,named)
    local group=F.folder(parent,"Transport public")
    local destinations={}
    for _,door in ipairs(plan.doors) do
        if door.source_place_key=="city" then table.insert(destinations,door) end
    end
    table.sort(destinations,function(a,b)return a.building_id<b.building_id end)
    for i,door in ipairs(destinations) do
        local label=(named[door.building_id] and named[door.building_id].name) or door.building_id
        local angle=2*math.pi*(i-1)/#destinations
        local pos=Vector3.new(math.sin(angle)*29,0,math.cos(angle)*29)
        terminal(group,pos,label,"shuttle."..door.building_id,door.source_anchor_id)
    end
    for _,door in ipairs(destinations) do
        -- Une borne de retour en ville près de l'entrée, éloignée de la vraie porte.
        local anchor=nil
        for _,p in ipairs(plan.places) do
            if p.place_key=="city" then
                for _,a in ipairs(p.anchors) do
                    if a.anchor_id==door.source_anchor_id then anchor=a;break end
                end
            end
        end
        if anchor then
            local p=Vector3.new(anchor.position_studs[1],0,anchor.position_studs[3])
            local dir=Vector3.new(p.X,0,p.Z).Unit
            local tangent=Vector3.new(-dir.Z,0,dir.X)
            terminal(group,p+tangent*12+dir*6,"Place centrale","shuttle.return."..door.building_id,"city.central.spawn")
        end
    end
    return group
end
return Transit
