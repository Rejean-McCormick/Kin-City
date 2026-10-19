--!strict
-- Points de visite non métier partagés entre la construction 3D et l'orientation.
-- Positions absolues en studs; aucune identité ni information kOA.
local names={
    {"optics","Maison de la lumière","Réflexion et couleurs",{108,189,218}},
    {"astronomy","Observatoire planétaire","Orbites et gravitation",{174,146,218}},
    {"ecology","Serre des écosystèmes","Biodiversité locale",{112,198,138}},
    {"engineering","Atelier des forces","Équilibre et leviers",{231,176,98}},
    {"water","Atelier de l'eau","Cycles et courants",{92,174,212}},
    {"energy","Pavillon de l'énergie","Circuits et transformation",{238,199,99}},
    {"sound","Jardin des résonances","Ondes et vibrations",{219,142,165}},
    {"nature","Laboratoire végétal","Croissance et adaptation",{149,190,116}},
}
local output={}
for index,item in ipairs(names) do
    local a=(index-1)*math.pi/4+0.27
    table.insert(output,{
        id="kin.conservatory."..item[1],kind=item[1],title=item[2],caption=item[3],color=item[4],
        center_studs={math.cos(a)*414,0,math.sin(a)*414},
        angle=a
    })
end
return output
