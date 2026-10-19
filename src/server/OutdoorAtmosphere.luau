--!strict
-- Sources d'ambiance entièrement natives : lucioles, halos, scintillements, fanions.
local F=require(script.Parent.Factory)
local Lighting=game:GetService("Lighting")
local Atmos={}
local fol=Color3.fromRGB(79,143,98)
local function spot(parent,x,z,index)
    local m=F.folder(parent,"Jardin lumineux")
    local stem=F.part(m,"Rosier",Vector3.new(0.7,6,0.7),CFrame.new(x,3,z),fol,Enum.Material.Grass)
    stem.CanCollide=false
    local orb=F.part(m,"Orbe végétal",Vector3.new(2.4,2.4,2.4),CFrame.new(x,6.6,z),Color3.fromRGB(170,224,210),Enum.Material.Slate)
    orb.CanCollide=false
    orb.Shape=Enum.PartType.Ball
    for n=1,3 do
        local a=n*math.pi*2/3
        local x2,z2=x+math.cos(a)*3,z+math.sin(a)*3
        local lamp=F.part(m,"Lanterne",Vector3.new(0.7,0.7,0.7),CFrame.new(x2,4.5+(index%2),z2),Color3.fromRGB(254,207,119),Enum.Material.Neon)
        lamp.Shape=Enum.PartType.Ball
        lamp.CanCollide=false
        lamp:SetAttribute("KinFirefly",true)
        lamp:SetAttribute("KinFireflyPhase",index*0.7+n)
        -- Un seul émetteur par jardin de trois lanternes : conserver les
        -- trois lueurs de matière sans trois coûts d'éclairage distincts.
        if n==1 then
            local point=Instance.new("PointLight")
            point.Brightness=0.26
            point.Range=9
            point.Shadows=false
            point.Parent=lamp
        end
    end
end
function Atmos.make(city)
    local folder=F.folder(city,"Paysages d'ambiance")
    for i=1,24 do
        local angle=2*math.pi*(i-1)/24
        local radius=124+(i%3)*20
        spot(folder,math.cos(angle)*radius,math.sin(angle)*radius,i)
    end
    local shrine=F.folder(folder,"Anneaux de la connaissance")
    for i=1,8 do
        local angle=2*math.pi*i/8
        local r=28
        local orb=F.part(shrine,"Pierre du savoir",Vector3.new(3.6,3.6,3.6),CFrame.new(math.cos(angle)*r,2.2,math.sin(angle)*r),Color3.fromRGB(197,239,231),Enum.Material.Slate)
        orb.Shape=Enum.PartType.Ball
        orb.CanCollide=false
        local aura=Instance.new("PointLight")
        aura.Brightness=0.35;aura.Range=11;aura.Parent=orb
    end
    return folder
end
function Atmos.start(world)
    -- On adapte doucement la lumière aux heures de la journée.
    -- Les ressources ne changent pas de propriétaire et ne sont jamais reconnectées à une API.
    task.spawn(function()
        local parts={}
        local city=world:FindFirstChild("Ville")
        local f=city and city:FindFirstChild("Paysages d'ambiance")
        if not f then return end
        for _,p in ipairs(f:GetDescendants()) do
            if p:IsA("BasePart") and p:GetAttribute("KinFirefly") then table.insert(parts,p) end
        end
        while world.Parent do
            local night=(Lighting.ClockTime<6.4 or Lighting.ClockTime>18.2)
            local now=os.clock()
            for _,p in ipairs(parts) do
                if p.Parent then
                    local light=p:FindFirstChildOfClass("PointLight")
                    if light then light.Enabled=night;light.Brightness=0.22+0.1*math.sin(now*1.8+(p:GetAttribute("KinFireflyPhase") or 0)) end
                    p.Transparency=night and 0.06 or 0.58
                end
            end
            task.wait(2.4)
        end
    end)
end
return Atmos
