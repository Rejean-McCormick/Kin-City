--!strict
-- Six lignes de navettes de surface entre l'entrée de boulevard et chaque quartier.
-- Réseau local. Aucune billettique ni suivi de compte kOA.
local RS=game:GetService("ReplicatedStorage")
local residential=require(RS:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local routes={}
for i,g in ipairs(residential) do
    local radial=Vector3.new(math.cos(g.angle),0,math.sin(g.angle))
    local tangent=Vector3.new(-radial.Z,0,radial.X)
    local offset=tangent*10
    local a=radial*162+offset
    local b=radial*290+offset
    table.insert(routes,{
        id=string.format("kin.boulevard.bus.%02d",i),
        title="Navette · "..g.title,
        quarter_id=g.id,
        color=g.color,
        start_studs={a.X,0,a.Z},
        finish_studs={b.X,0,b.Z},
        station_names={"Entrée du boulevard",g.title},
    })
end
return routes
