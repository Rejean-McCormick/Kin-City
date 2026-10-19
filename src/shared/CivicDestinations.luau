--!strict
-- Six scènes publiques autonomes au bord des quartiers résidentiels.
local RS=game:GetService("ReplicatedStorage")
local homes=require(RS:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local themes={
    {name="Scène du Vivant",theme="jardin",activity="Jardin de lumière"},
    {name="Forum des Savoirs",theme="lecture",activity="Rosace des idées"},
    {name="Esplanade des Arts",theme="arts",activity="Mobile des couleurs"},
    {name="Agora du Mouvement",theme="sport",activity="Cercle des rythmes"},
    {name="Place des Rencontres",theme="communaute",activity="Luminaires partagés"},
    {name="Terrasse des Inventions",theme="science",activity="Réacteur lumineux"},
}
local destinations={}
for i,home in ipairs(homes) do
    local t=themes[i]
    local radius=425
    table.insert(destinations,{
        id=string.format("kin.civic.stage.%02d",i),
        title=t.name,theme=t.theme,activity=t.activity,
        quarter_id=home.id,
        center_studs={math.cos(home.angle)*radius,0,math.sin(home.angle)*radius},
        yaw=math.pi/2-home.angle,
        color=home.color,
    })
end
return destinations
