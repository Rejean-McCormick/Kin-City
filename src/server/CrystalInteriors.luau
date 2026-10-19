--!strict
-- Les cristaux existent dans les ESPACES, pas seulement sur les toitures.
local Kit=require(script.Parent.CrystalKit)
local Interior={}
function Interior.make(model,place,origin,_style)
    local key=place.place_key
    if key=="city" then return end
    local root=Instance.new("Folder")
    root.Name="Signature intérieure sarcelle et cristal v17"
    root.Parent=model
    local accent=Kit.accent(key)
    for index,room in ipairs(place.rooms) do
        local x,_,z=table.unpack(room.center_studs)
        local width,_,depth=table.unpack(room.size_studs)
        local base=CFrame.new(origin+Vector3.new(x,0,z))
        -- Éléments sur les murs latéraux, hors du mobilier et des traversées.
        local axisX=width*0.43
        for indexSide,side in ipairs({-1,1}) do
            if indexSide>Kit.settings.interior_spires_per_room then break end
            Kit.spire(root,"Prisme mural - "..room.room_id,
                base*CFrame.new(side*axisX,5.4,depth*0.25),1.0,7.8,{accent=accent})
        end
        -- Motif incrusté sans collision, limité à la pièce d'entrée pour éviter le bruit visuel.
        if index==1 then
            Kit.mosaic(root,base*CFrame.new(0,0.04,4),7)
            Kit.rosette(root,"Emblème de l'atrium",base*CFrame.new(width*0.31,10.7,depth/2-0.35)*CFrame.Angles(0,math.pi,0),
                3.4,accent,6)
        end
    end
    -- Accent ponctuel sur le parcours vertical, sans transformer tous les meubles en verre.
    local lookout=CFrame.new(origin+Vector3.new(0,26,60))
    Kit.spire(root,"Signal du parcours supérieur",lookout,2.1,8,{accent=accent})
    return root
end
return Interior
