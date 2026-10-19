--!strict
-- Réseau de correspondances physiques v12, défini une seule fois pour la 3D et l'UI.
-- Ces accès sont des liaisons locales instantanées clairement indiquées, pas des
-- faux voyages en bus, ni des opérations kOA ou des destinations Place publiées.
local RS = game:GetService("ReplicatedStorage")
local routes = require(RS:WaitForChild("KinCityShared"):WaitForChild("BoulevardRoutes"))
local Network = {}
Network.hub = {id="kin.intermodal.central",title="Gare centrale des Connexions",center_studs={0,0,114}}
Network.gates = {}
Network.returns = {}
for i,route in ipairs(routes) do
    local side = if i <= 3 then -1 else 1
    local row = ((i-1)%3)
    local localZ = -19+row*19
    local gateX = side*18
    local item = {
        id=string.format("kin.intermodal.gate.%02d",i),
        line_id=route.id,
        title=route.title,
        color=route.color,
        position_studs={gateX,0,114+localZ},
        arrival_studs={route.start_studs[1],0,route.start_studs[3]},
    }
    table.insert(Network.gates,item)
    for _,direction in ipairs({"start","finish"}) do
        local station=if direction=="start" then route.start_studs else route.finish_studs
        local radial=Vector3.new(station[1],0,station[3])
        local rad=if radial.Magnitude>0 then radial.Unit else Vector3.new(1,0,0)
        local tangent=Vector3.new(-rad.Z,0,rad.X)
        local p=radial+tangent*13
        table.insert(Network.returns,{
            id=string.format("kin.intermodal.return.%02d.%s",i,direction),
            title=route.title,
            line_id=route.id,
            position_studs={p.X,0,p.Z},
            arrival_studs={0,0,71},
            color=route.color,
            direction=direction,
        })
    end
end
return Network
