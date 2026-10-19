--!strict
-- Reprise discrète des accès: vrais meshes Studio quand fournis, primitives sinon.
-- Aucune modification de l'entrée ou des ProximityPrompts.
local Kit=require(script.Parent.CrystalKit)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Facades={}
function Facades.make(model,structure,building)
    local place=building.interior_place_key
    if not place then return end
    local w,d=table.unpack(structure.footprint_studs)
    local x,y,z=table.unpack(structure.center_studs)
    local h=structure.height_studs
    local cf=CFrame.new(x,y,z)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local root=Instance.new("Folder")
    root.Name="Architecture minérale v24"
    root:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    root.Parent=model
    local accent=Kit.accent(place)
    -- L'arche reste décorative; devant la partie supérieure du portail, jamais
    -- une seconde porte ou une collision invisible.
    Meshes.decorate(root,"Arc de fronton","opal_arch",Vector3.new(12,5.3,1.45),
        cf*CFrame.new(0,11.5,-d*0.5-1.95),Kit.gold)
    for _,side in ipairs({-1,1}) do
        Meshes.decorate(root,"Pilastre d'identité","mineral_column",Vector3.new(1.25,11.0,1.25),
            cf*CFrame.new(side*(w*0.5-3.6),h*0.5,-d*0.5-1.28),Kit.primary)
        Meshes.decorate(root,"Rosace de façade","crystal_rosette",Vector3.new(3.8,3.8,0.6),
            cf*CFrame.new(side*w*0.31,math.min(h-3,17),-d*0.5-1.65)*CFrame.Angles(0,0,side*0.2),accent)
        if Kit.profile~="LITE" then
            Meshes.decorate(root,"Épi opalin de toiture","opal_spire",Vector3.new(2.25,7.4,2.25),
                cf*CFrame.new(side*w*0.38,h+3.7,0),Kit.opal)
        end
    end
    if Kit.profile=="SHOWCASE" then
        Meshes.decorate(root,"Couronnement principal","crystal_canopy",Vector3.new(math.min(w*0.35,22),3.0,7),
            cf*CFrame.new(0,h+2,0),accent)
    end
    return root
end
return Facades
