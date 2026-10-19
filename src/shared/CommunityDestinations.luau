--!strict
-- Registre unique des marchés et maisons communautaires v11.
-- Les constructions partent des mêmes coordonnées que les six quartiers v10.
local RS=game:GetService("ReplicatedStorage")
local neighborhoods=require(RS:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local themes={
    {market="Halle des récoltes",community="Maison des jardins",activity="Atelier botanique",special="serres"},
    {market="Marché du livre",community="Maison des connaissances",activity="Laboratoire de lecture",special="books"},
    {market="Galerie des artisans",community="Maison de la création",activity="Studio des couleurs",special="arts"},
    {market="Halle des promenades",community="Maison du mouvement",activity="Atelier des cycles",special="movement"},
    {market="Marché coopératif",community="Maison des rencontres",activity="Salle de la coopération",special="commons"},
    {market="Halle des inventions",community="Maison de la lumière",activity="Atelier des optiques",special="light"},
}
local places={}
for i,quarter in ipairs(neighborhoods) do
    local t=themes[i]
    local center=Vector3.new(quarter.center_studs[1],0,quarter.center_studs[3])
    local base=CFrame.new(center)*CFrame.Angles(0,math.pi/2-quarter.angle,0)
    for _,kind in ipairs({"market","community"}) do
        local offset=if kind=="market" then 78 else -78
        local pos=(base*CFrame.new(offset,0,0)).Position
        table.insert(places,{
            id=quarter.id.."."..kind,
            district=quarter.id,
            kind=kind,
            title=if kind=="market" then t.market else t.community,
            activity=t.activity,
            special=t.special,
            color=quarter.color,
            center_studs={pos.X,0,pos.Z},
            -- Façades orientées vers la place collective du quartier.
            facing=math.pi/2-quarter.angle+(if kind=="market" then math.pi/2 else -math.pi/2),
        })
    end
end
return places
