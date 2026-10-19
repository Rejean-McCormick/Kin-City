--!strict
-- Registre géographique de deux marinas. Commun aux générateurs et au guide.
-- Les activités physiques sont des jeux locaux sans compte ni crédits kOA.
local result={}
for index,angle in ipairs({math.pi/8,9*math.pi/8}) do
    table.insert(result,{
        id=string.format("kin.marina.%02d",index),
        title=if index==1 then "Marina des Découvertes" else "Port des Artisans",
        angle=angle,
        radius=480,
        center_studs={480*math.cos(angle),0,480*math.sin(angle)},
        color=if index==1 then {84,180,203} else {227,170,103},
    })
end
return result
