--!strict
-- Petits espaces d'arrivée et sculptures civiques autour des 8 monuments.
-- Ne déplace pas de routes, portes ou points de téléportation.
local Kit=require(script.Parent.CrystalKit)
local Meshes=require(script.Parent.ReusableMeshesV23)
local Factory=require(script.Parent.Factory)
local Landings={}
local function decor(parent,name,size,cf,color,material)
    local p=Kit.part(parent,"Part",name,size,cf,color,material or Enum.Material.Slate)
    p:SetAttribute("KinOptionalDetail",true)
    return p
end
function Landings.make(city,plan)
    local root=Instance.new("Folder")
    root.Name="Parterres de cristal et ateliers des matières v24"
    root:SetAttribute("KinArtTheme","#1E6864 + cristal opalin")
    root.Parent=city
    for _,structure in ipairs(plan.structures) do
        local w,d=table.unpack(structure.footprint_studs)
        local x,y,z=table.unpack(structure.center_studs)
        local frame=CFrame.new(x,y,z)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
        local group=Instance.new("Model")
        group.Name="Parterre des matières — "..structure.building_id
        group:SetAttribute("KinBuildingId",structure.building_id)
        group.Parent=root
        for _,side in ipairs({-1,1}) do
            -- Sur les bas-côtés extérieurs de la façade : pas sur l'axe de la porte.
            local base=frame*CFrame.new(side*(w*0.5+13),0,-d*0.5-8)
            decor(group,"Nappe de pierre",Vector3.new(8.1,0.22,7.5),
                base*CFrame.new(0,0.12,0),Kit.stone,Enum.Material.Cobblestone)
            Meshes.decorate(group,"Jardinière minérale","mineral_planter",Vector3.new(5.5,2.4,5.1),
                base*CFrame.new(0,1.5,0),Kit.primary)
            local count=if Kit.profile=="LITE" then 2 else 4
            for i=1,count do
                local a=(i-1)*2*math.pi/count
                local sprout=decor(group,"Feuille facettée",Vector3.new(0.8,2.6,1.0),
                    base*CFrame.new(math.cos(a)*1.25,3.25,math.sin(a)*1.2)*CFrame.Angles(0,a,math.rad(15)),
                    if i%2==0 then Kit.opal else Kit.medium,Enum.Material.Slate)
                sprout:SetAttribute("KinDecorRole","botanical")
            end
        end
        if Kit.profile~="LITE" then
            -- Un pupitre d'observation des matières : visite libre, sans faux service métier.
            local cf=frame*CFrame.new(w*0.5+13,0,-d*0.5+4)*CFrame.Angles(0,-math.pi/2,0)
            Meshes.decorate(group,"Pupitre de collection","opal_console",Vector3.new(3.2,4.1,3.2),
                cf*CFrame.new(0,2.1,0),Kit.opal)
            local sign=Factory.sign(group,"Cartel des matières",
                (cf*CFrame.new(0,4.4,0.0)).Position,structure.yaw_degrees+90,
                "PIERRE + CRISTAL",8,1.7)
            sign.CanCollide=false;sign.CanTouch=false;sign.CanQuery=false
        end
    end
    return root
end
return Landings
