--!strict
-- Six places publiques reconnaissables, installées au voisinage des hubs canoniques.
local F=require(script.Parent.Factory)
local Landmarks={}
local profiles={
    central={label="Jardin des communes",color=Color3.fromRGB(189,163,113),kind="columns"},
    konnected={label="Jardin des livres",color=Color3.fromRGB(100,143,187),kind="books"},
    ethikos={label="Agora de l'écoute",color=Color3.fromRGB(205,174,138),kind="agora"},
    keenkonnect={label="Atelier des idées",color=Color3.fromRGB(77,171,171),kind="tech"},
    kreative={label="Promenade des arts",color=Color3.fromRGB(206,119,115),kind="art"},
    orgo={label="Réseau des connexions",color=Color3.fromRGB(106,140,194),kind="network"},
}
local function part(parent,name,size,cf,color,material)
    return F.part(parent,name,size,cf,color,material)
end
local function stone(parent,pos,w,d,color)
    return part(parent,"Place paysagère",Vector3.new(w,0.35,d),CFrame.new(pos+Vector3.new(0,0.12,0)),color,Enum.Material.Cobblestone)
end
local function theme(parent,pos,profile)
    local c=profile.color
    local themeName=profile.kind
    if themeName=="books" then
        for i=-2,2 do
            local p=part(parent,"Livre monument",Vector3.new(3,8+math.abs(i%3)*2,7),CFrame.new(pos+Vector3.new(i*6,6,-1)),Color3.fromHSV((i+4)*0.11,0.4,0.78),Enum.Material.Marble)
            p.CanCollide=false
        end
    elseif themeName=="agora" then
        for i=0,8 do
            local theta=i*math.pi/8
            local x=math.cos(theta)*17
            local z=math.sin(theta)*10
            part(parent,"Gradin de discussion",Vector3.new(5,1.6,5),CFrame.new(pos+Vector3.new(x,0.8,z)),c,Enum.Material.Marble)
        end
    elseif themeName=="tech" then
        for i=-2,2 do
            local p=part(parent,"Nervure technologique",Vector3.new(1.1,8,1.1),CFrame.new(pos+Vector3.new(i*7,4,0)),c,Enum.Material.Metal)
            part(parent,"Module lumineux",Vector3.new(3,2,3),CFrame.new(pos+Vector3.new(i*7,9,0)),Color3.fromRGB(122,233,221),Enum.Material.Neon).CanCollide=false
        end
    elseif themeName=="art" then
        for i=-2,2 do
            local p=part(parent,"Stèle créative",Vector3.new(4,4,4),CFrame.new(pos+Vector3.new(i*7,6,0))*CFrame.Angles(0,i*.35,math.rad(22+i*5)),Color3.fromHSV((i+4)*0.17,.5,.8),Enum.Material.Metal)
            p.CanCollide=false
        end
    elseif themeName=="network" then
        for i=1,7 do
            local a=i*math.pi*2/7
            local v=Vector3.new(math.cos(a)*11,5,math.sin(a)*11)
            part(parent,"Noeud réseau",Vector3.new(2,9,2),CFrame.new(pos+v),c,Enum.Material.Glass)
        end
    else
        for i=-2,2 do
            part(parent,"Colonne de place",Vector3.new(2,9,2),CFrame.new(pos+Vector3.new(i*7,4.5,0)),c,Enum.Material.Marble)
            part(parent,"Chapiteau",Vector3.new(3.5,1,3.5),CFrame.new(pos+Vector3.new(i*7,9.4,0)),Color3.fromRGB(238,214,164),Enum.Material.Marble)
        end
    end
end
function Landmarks.make(city,plan)
    local group=F.folder(city,"Jardins et places thématiques")
    for _,place in ipairs(plan.places) do
        if place.place_key=="city" then
            for _,a in ipairs(place.anchors) do
                local district=string.match(a.anchor_id,"^city%.district%.([%a]+)%.hub$")
                local profile=district and profiles[district]
                if profile and district~="central" then
                    -- Le repère reste près du hub, mais en retrait du sentier central.
                    local center=Vector3.new(a.position_studs[1],0,a.position_studs[3])
                    local radial=(center.Magnitude>1) and center.Unit or Vector3.new(1,0,0)
                    local side=Vector3.new(-radial.Z,0,radial.X)
                    local pos=center+side*28+radial*3
                    local folder=F.folder(group,profile.label)
                    stone(folder,pos,41,28,Color3.fromRGB(205,194,170))
                    theme(folder,pos,profile)
                    local booth=part(folder,"Borne des quartiers",Vector3.new(3.5,4.5,2),CFrame.new(pos+Vector3.new(0,2.4,-13)),Color3.fromRGB(37,61,72),Enum.Material.Metal)
                    part(folder,"Écran de découverte",Vector3.new(2.9,2.6,0.2),CFrame.new(pos+Vector3.new(0,3.1,-14.1)),profile.color,Enum.Material.Neon).CanCollide=false
                    booth:SetAttribute("KinStubInteractionId","district."..district..".information")
                    booth:SetAttribute("KinStubCapabilityId","future.district."..district)
                    booth:SetAttribute("KinStubTitle",profile.label)
                    F.prompt(booth,"Découvrir",profile.label)
                    F.sign(folder,"Nom du jardin",pos+Vector3.new(0,12,13),0,profile.label,31,3.1).CanCollide=false
                end
            end
        end
    end
    return group
end
return Landmarks
