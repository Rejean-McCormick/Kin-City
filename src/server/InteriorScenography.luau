--!strict
-- V5 : décors architecturaux de salles, sans masquer les couloirs ou portails.
-- Réutilisable pour tous les huit intérieurs et toutes leurs ailes.
local F=require(script.Parent.Factory)
local Scenography={}
local function part(parent,name,origin,size,pos,color,material,solid)
    local p=F.part(parent,name,size,CFrame.new(origin+pos),color,material)
    if solid==false then p.CanCollide=false;p.CastShadow=false end
    return p
end
function Scenography.decorate(parent,room,origin,style,placeKey,index)
    local cx,_,cz=table.unpack(room.center_studs)
    local w,h,d=table.unpack(room.size_studs)
    local accent=F.hex(style.palette.accent)
    local trim=F.hex(style.palette.trim)
    local title=room.display_name or "Espace public"
    local rot=if index%2==0 then 1 else -1
    -- Tapis/rosace plane; l'épaisseur n'entrave pas la marche.
    local floor=part(parent,"Rosace du patrimoine",origin,Vector3.new(math.min(w-14,26),0.08,math.min(d-14,19)),Vector3.new(cx,0.07,cz),accent,Enum.Material.Fabric,false)
    floor.Transparency=0.53
    for ring=1,2 do
        local r=5+ring*4
        for i=1,12 do
            local theta=i*math.pi/6
            local tile=part(parent,"Mosaïque",origin,Vector3.new(1.5,0.1,1.5),Vector3.new(cx+math.cos(theta)*r,0.12,cz+math.sin(theta)*r),trim,Enum.Material.Marble,false)
            tile.CFrame=tile.CFrame*CFrame.Angles(0,theta,0)
        end
    end
    -- Frises murales placées près du plafond et loin des zones de passage.
    for _,side in ipairs({-1,1}) do
        part(parent,"Frise supérieure",origin,Vector3.new(0.35,1.0,d-3),Vector3.new(cx+side*(w/2-0.8),13.5,cz),accent,Enum.Material.Metal,false)
        for n=1,3 do
            local zz=cz-d/2+4+n*(d-8)/4
            local frame=part(parent,"Emblème mural",origin,Vector3.new(0.35,3,3),Vector3.new(cx+side*(w/2-1.0),10.6,zz),trim,Enum.Material.Marble,false)
            frame.Transparency=0.2
        end
    end
    -- Luminaire sculptural signé, sans tripler les vitrages ni les lumières.
    require(script.Parent.CrystalLuminairesV23).decorate(parent,room,origin,placeKey,index)
    -- Plaque murale explicite : zone prête pour son interface future.
    local board=part(parent,"Emblème de salle",origin,Vector3.new(10,2.8,0.25),Vector3.new(cx,11.1,cz+d/2-0.8),Color3.fromRGB(39,60,72),Enum.Material.Metal,false)
    -- Le texte de surface ne remplace pas le contenu kOA : il nomme seulement l'espace.
    F.sign(parent,"Signalétique intérieure",origin+Vector3.new(cx,11.1,cz+d/2-1.0),180,title,9.2,2.2).CanCollide=false
end
return Scenography
