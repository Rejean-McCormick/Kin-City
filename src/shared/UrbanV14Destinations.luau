--!strict
-- Catalogue spatial unique pour les nouvelles constructions v14.
-- Pas de comptes, pas de monnaie, aucune capacité métier simulée.
local RS=game:GetService("ReplicatedStorage")
local stages=require(RS:WaitForChild("KinCityShared"):WaitForChild("CivicDestinations"))
local register={arcades={},workshops={}}
local crafts={
    {title="Librairie des voyages",kind="books",color={205,165,108}},
    {title="Atelier des horloges",kind="clock",color={137,188,187}},
    {title="Salon des jardins",kind="botany",color={123,180,120}},
    {title="Cabinet des inventions",kind="science",color={148,164,219}},
    {title="Maison des couleurs",kind="art",color={220,154,142}},
    {title="Atelier de musique",kind="music",color={202,169,203}},
    {title="Cartographie du monde",kind="maps",color={162,182,205}},
    {title="Objets du mouvement",kind="motion",color={222,189,112}},
}
for i,design in ipairs(crafts) do
    local side=if i<=4 then -1 else 1
    local row=(i-1)%4
    local center={side*64,0,85+row*21}
    table.insert(register.arcades,{
        id=string.format("kin.station.arcade.%02d",i),title=design.title,
        kind=design.kind,color=design.color,center_studs=center,
        yaw=-side*math.pi/2,side=side,
    })
end
local titles={
    "Atelier du vivant","Atelier du savoir","Atelier des couleurs",
    "Atelier du mouvement","Atelier du lien","Atelier des inventions",
}
for i,stage in ipairs(stages) do
    local cf=CFrame.new(stage.center_studs[1],0,stage.center_studs[3])*CFrame.Angles(0,stage.yaw,0)*CFrame.new(-43,0,-3)
    local p=cf.Position
    table.insert(register.workshops,{
        id=string.format("kin.public.workshop.%02d",i),title=titles[i],
        theme=stage.theme,color=stage.color,
        center_studs={p.X,0,p.Z},yaw=stage.yaw,stage_id=stage.id,
    })
end
return register
