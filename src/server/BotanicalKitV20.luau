--!strict
-- Kin City v20 — arbres architecturaux, profils de détails, géométrie Roblox native.
-- Un tronc porteur et des feuillages sans collision. Aucune boucle, lumière ou asset externe.
local Factory=require(script.Parent.Factory)
local Crystal=require(script.Parent.CrystalKit)
local Botanical={}
local palette={
    Color3.fromRGB(46,112,89), Color3.fromRGB(63,131,103),
    Color3.fromRGB(76,135,116), Color3.fromRGB(73,119,103),
    Color3.fromRGB(58,131,113), Color3.fromRGB(91,135,105),
}
local function leaf(parent,label,size,frame,color)
    local p=Factory.part(parent,label,size,frame,color,Enum.Material.Grass)
    p.Shape=Enum.PartType.Ball
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
    p:SetAttribute("KinBotanicalDetail",true)
    p:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
    return p
end
local function twig(parent,base,x,y,z,length,angle)
    local p=Factory.part(parent,"Rameau courbé",Vector3.new(0.5,length,0.5),
        base*CFrame.new(x,y,z)*CFrame.Angles(0,0,angle),Color3.fromRGB(111,86,67),Enum.Material.Wood)
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
    p:SetAttribute("KinOptionalDetail",true)
end
function Botanical.tree(parent,x,z,seed)
    local model=Instance.new("Model")
    model.Name="Arbre minéral — "..tostring(seed)
    model:SetAttribute("KinBotanicalId","city.tree."..tostring(seed))
    model:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
    model.Parent=parent
    local kind=seed%3
    local height=11+(seed%5)
    local base=CFrame.new(x,0,z)
    local trunk=Factory.part(model,"Tronc porteur",Vector3.new(1.8,height,1.8),base*CFrame.new(0,height/2,0),
        Color3.fromRGB(111,86,67),Enum.Material.Wood)
    trunk.CanTouch=false;trunk.CastShadow=true
    local green=palette[seed%#palette+1]
    if kind==0 then
        -- Silhouette élancée : couronne étagée, quatre parties au plus en STANDARD.
        leaf(model,"Cime conique basse",Vector3.new(7.4,6.5,7.4),base*CFrame.new(0,height+1.7,0),green)
        leaf(model,"Cime conique haute",Vector3.new(5.5,7.2,5.5),base*CFrame.new(0,height+5,0),palette[(seed+2)%#palette+1])
    elseif kind==1 then
        -- Silhouette étalée de jardin.
        leaf(model,"Canopée principale",Vector3.new(10.5,7,9.8),base*CFrame.new(0,height+2,0),green)
        if Crystal.profile~="LITE" then
            leaf(model,"Canopée latérale",Vector3.new(5.1,5.5,6.2),base*CFrame.new(3.1,height+0.3,-1.3),palette[(seed+1)%#palette+1])
        end
    else
        -- Silhouette ovale, sommet en cristal végétal (pas de Glass).
        leaf(model,"Couronne arrondie",Vector3.new(7.3,9.8,7.3),base*CFrame.new(0,height+2.7,0),green)
        leaf(model,"Cime claire",Vector3.new(4.2,5.3,4.3),base*CFrame.new(-1,height+6.5,0.5),palette[(seed+3)%#palette+1])
    end
    if Crystal.profile~="LITE" and seed%2==0 then
        twig(model,base,-1.2,height-1,0,5.2,0.55)
        twig(model,base,1.25,height-1.2,0,4.5,-0.57)
    end
    if Crystal.profile=="SHOWCASE" and seed%5==0 then
        -- Une inclusion opaline rare dans la cime, sans lumière dynamique.
        local jewel=Crystal.part(model,"Part","Fruit opalin",Vector3.new(0.8,1.5,0.8),
            base*CFrame.new(1.7,height+3,-2),Crystal.opal,Enum.Material.Neon)
        jewel:SetAttribute("KinOptionalDetail",true)
    end
    return model
end
return Botanical
