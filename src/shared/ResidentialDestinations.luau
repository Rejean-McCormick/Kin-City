--!strict
-- Six îlots résidentiels. Coordonnées partagées par le constructeur, la carte et le guide.
-- Les édifices et interventions sont autonomes : aucune identité ou API kOA.
local groups={
    {id="kin.habitat.nord",title="Les Terrasses du Nord",angle=math.rad(75),style="jardin",color={113,177,132}},
    {id="kin.habitat.sagesse",title="Les Maisons des Savoirs",angle=math.rad(135),style="atelier",color={147,178,204}},
    {id="kin.habitat.arts",title="Les Cours des Arts",angle=math.rad(195),style="culture",color={212,152,143}},
    {id="kin.habitat.promenade",title="Le Clos des Promenades",angle=math.rad(255),style="jardin",color={178,181,125}},
    {id="kin.habitat.cooperation",title="Le Village Coopératif",angle=math.rad(315),style="collectif",color={201,169,111}},
    {id="kin.habitat.lumiere",title="Le Quartier de la Lumière",angle=math.rad(350),style="atelier",color={159,178,214}},
}
for _,g in ipairs(groups) do
    g.radius=352
    g.center_studs={g.radius*math.cos(g.angle),0,g.radius*math.sin(g.angle)}
    g.homes=4
end
return groups
