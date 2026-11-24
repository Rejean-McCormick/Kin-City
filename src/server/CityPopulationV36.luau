--!strict
-- KC36 B10 / B09: positions de population déterministes dans les SIX avenues actives.
-- Les îlots ResidentialQuarters v30/v31 ne sont plus le référentiel de placement.
-- Les bâtiments canoniques et une courte enveloppe de mouvement sont réservés.
local RS=game:GetService("ReplicatedStorage")
local Shared=RS:WaitForChild("KinCityShared")
local Districts=require(Shared:WaitForChild("HexagonalDistricts"))
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Pop={}
Pop.REVISION="KC36-POPULATION-AVENUES-1"
Pop.PROCEDURAL_PER_SECTOR=4
Pop.R15_PER_SECTOR=3
local RADII={stylized={105,185,275,370},r15={145,235,335}}
local DELTAS={0}
for delta=9,351,9 do
    table.insert(DELTAS,delta)
    table.insert(DELTAS,-delta)
end
local LATERALS={-4.0,4.0,-6.5,6.5}

local function collidesStructure(x:number,z:number,pad:number):boolean
    for _,b in ipairs(Plan.structures) do
        local dx=x-b.center_studs[1]
        local dz=z-b.center_studs[3]
        local yaw=math.rad(b.yaw_degrees)
        local lx=math.cos(yaw)*dx-math.sin(yaw)*dz
        local lz=math.sin(yaw)*dx+math.cos(yaw)*dz
        if math.abs(lx)<b.footprint_studs[1]/2+pad
            and math.abs(lz)<b.footprint_studs[2]/2+pad then
            return true
        end
    end
    return false
end

local cache={stylized={},r15={}}
local assigned={}
local function reserved(x:number,z:number):boolean
    for _,p in ipairs(assigned) do
        if (p-Vector3.new(x,0,z)).Magnitude<17 then return true end
    end
    return false
end
local function planned(kind:string,index:number)
    local n=if kind=="stylized" then Pop.PROCEDURAL_PER_SECTOR else Pop.R15_PER_SECTOR
    assert(index>=1 and index<=n*#Districts.sections and index%1==0,"Indice PNJ invalide")
    local sectorIndex=(index-1)%#Districts.sections+1
    local tier=math.floor((index-1)/#Districts.sections)+1
    local section=Districts.sections[sectorIndex]
    local axis=Vector3.new(section.x,0,section.z)
    local tangent=Vector3.new(-axis.Z,0,axis.X)
    local radius=RADII[kind][tier]
    assert(radius,"Rayon PNJ inexistant")
    -- Les personnages sont sur les avenues natives de 19 studs.
    -- Les 14 studs de leur petit circuit sont validés contre les façades.
    for _,delta in ipairs(DELTAS) do
        local r=radius+delta
        if r>=88 and r<=417 then
            local offsetOrder=if (index+tier)%2==0 then {1,2,3,4} else {2,1,4,3}
            for _,j in ipairs(offsetOrder) do
                local point=axis*r+tangent*LATERALS[j]
                local safe=true
                for _,step in ipairs({-15,0,15}) do
                    local p=point+axis*step
                    if collidesStructure(p.X,p.Z,8) then safe=false;break end
                end
                if safe and not reserved(point.X,point.Z) then
                    return {
                        position=point,axis=axis,section=section,
                        index=index,kind=kind,radius=r,sector_index=sectorIndex,
                        itinerary_half_length=12,
                    }
                end
            end
        end
    end
    error("KC36 POPULATION : aucune parcelle piétonne libre pour "..kind.." #"..index)
end

-- Attribution déterministe globale : ordre immuable, sans doublons entre styles.
for _,kind in ipairs({"stylized","r15"}) do
    local limit=if kind=="stylized" then Pop.PROCEDURAL_PER_SECTOR else Pop.R15_PER_SECTOR
    for index=1,limit*#Districts.sections do
        local record=planned(kind,index)
        cache[kind][index]=record
        table.insert(assigned,record.position)
    end
end

function Pop.site(kind:string,index:number)
    assert(kind=="stylized" or kind=="r15","Type PNJ inconnu")
    return assert(cache[kind][index],"Indice ou type PNJ hors contrat")
end

function Pop.safeWaypoint(site,point:Vector3):boolean
    local d=point-site.position
    local parallel=d:Dot(site.axis)
    local tangent=Vector3.new(-site.axis.Z,0,site.axis.X)
    local lateral=math.abs(d:Dot(tangent))
    return math.abs(parallel)<=20 and lateral<=10
        and not collidesStructure(point.X,point.Z,5)
end

function Pop.audit():{[string]:number}
    local stats={stylized=0,r15=0,sectors=#Districts.sections}
    for _,kind in ipairs({"stylized","r15"}) do
        local per=if kind=="stylized" then Pop.PROCEDURAL_PER_SECTOR else Pop.R15_PER_SECTOR
        for i=1,per*#Districts.sections do
            local s=Pop.site(kind,i)
            assert(s and Pop.safeWaypoint(s,s.position),"Placement PNJ bloqué")
            stats[kind]+=1
        end
    end
    return stats
end
return Pop
