--!strict
-- Kin City v13 : adresses stables des commerces sur la promenade extérieure.
-- Aucun achat réel; toutes les consultations métier restent WORLD_STUB.
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Civic=require(Shared:WaitForChild("CivicDestinations"))
local Public=require(Shared:WaitForChild("PublicDestinations"))
local Plan=require(Shared:WaitForChild("WorldPlan"))
local styles={
    {slug="bookbind",name="Atelier de reliure",subtitle="Papier, livres et impression",color={159,184,213}},
    {slug="botanic",name="Herboristerie",subtitle="Plantes et parfums",color={132,191,151}},
    {slug="ceramics",name="Maison des céramiques",subtitle="Matières et techniques",color={222,163,139}},
    {slug="weaving",name="Atelier textile",subtitle="Fibres et tissus",color={203,165,217}},
    {slug="optics",name="Atelier des lumières",subtitle="Couleurs et transparence",color={217,195,115}},
    {slug="instrument",name="Lutherie et sons",subtitle="Musique et fabrication",color={132,196,197}},
}
local output={}
local function near(x,z,pos,r)
    local dx=x-pos[1]
    local dz=z-pos[3]
    return dx*dx+dz*dz<r*r
end
for slot=1,48 do
    local a=2*math.pi*(slot-0.3)/48
    local r=459
    local x,z=math.cos(a)*r,math.sin(a)*r
    local clear=true
    for _,stage in ipairs(Civic) do
        if near(x,z,stage.center_studs,58) then clear=false;break end
    end
    if clear then
        for _,place in ipairs(Public) do
            if near(x,z,place.center_studs,50) then clear=false;break end
        end
    end
    -- Aucun kiosque n'occulte les panoramas, les marinas ou les accès aux quais.
    if clear then
        for _,marinaAngle in ipairs({math.pi/8,9*math.pi/8}) do
            if near(x,z,{480*math.cos(marinaAngle),0,480*math.sin(marinaAngle)},86) then clear=false;break end
        end
    end
    if clear then
        for n=1,8 do
            local theta=n*math.pi/4
            if near(x,z,{467*math.cos(theta),0,467*math.sin(theta)},24) then clear=false;break end
        end
    end
    if clear then
        for n=1,12 do
            local theta=(n-1)*math.pi/6+math.pi/24
            local diff=math.atan2(math.sin(a-theta),math.cos(a-theta))
            if math.abs(diff)<0.06 then clear=false;break end
        end
    end
    if clear then
        for _,b in ipairs(Plan.structures) do
            if near(x,z,b.center_studs,76) then clear=false;break end
        end
    end
    if clear then
        for i=0,5 do
            local bridge=i*math.pi/3+math.pi/24
            local delta=math.atan2(math.sin(a-bridge),math.cos(a-bridge))
            if math.abs(delta)<0.086 then clear=false;break end
        end
    end
    if clear then
        local theme=styles[(slot-1)%#styles+1]
        table.insert(output,{
            id=string.format("kin.commerce.promenade.%02d",slot),
            slot=slot,kind=theme.slug,title=theme.name,
            subtitle=theme.subtitle,color=theme.color,
            center_studs={x,0,z},angle=a,
            yaw=math.pi/2-a,
        })
    end
end
return output
