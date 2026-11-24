--!strict
-- Place hexagonale : six portes cardinales sur les sommets du logo.
-- Les décors sont sans collision, et la dalle centrale respecte les joueurs.
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Palette=require(Shared:WaitForChild("HexagonalDistricts"))
local F=require(script.Parent.Factory)
local Heart={}
local RADIUS=51
local ROOT3=math.sqrt(3)
local function decor(parent,name,size,cf,color,material)
    local p=F.part(parent,name,size,cf,color,material)
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
    return p
end
local function beam(parent,name,a,b,width,height,color,material)
    local d=b-a
    return decor(parent,name,Vector3.new(d.Magnitude,height,width),
        CFrame.new((a+b)*0.5)*CFrame.Angles(0,-math.atan2(d.Z,d.X),0),color,material)
end
local function hexOutline(parent,r,y,color,width)
    for i=0,5 do
        local a=-math.pi/2+i*math.pi/3
        local b=a+math.pi/3
        beam(parent,"Contour hexagonal "..i,
            Vector3.new(math.cos(a)*r,y,math.sin(a)*r),
            Vector3.new(math.cos(b)*r,y,math.sin(b)*r),width,0.32,color,Enum.Material.Neon)
    end
end
function Heart.make(city)
    local hub=F.folder(city,"COEUR HEXAGONAL • 6 DIRECTIONS")
    hub:SetAttribute("KinPrimaryColor","#1E6864")
    hub:SetAttribute("KinAxisReference","12h=-Z; 3h=+X; horaire")
    hub:SetAttribute("KinLogoShape","hexagone")
    -- Hexagone pointé vers le nord : bande horizontale calculée aux bords.
    -- Les 24 bandes n'ont aucun interstice praticable; pièces adjacentes.
    local steps=24
    local depth=2*RADIUS/steps
    for i=1,steps do
        local z=-RADIUS+(i-0.5)*depth
        local edge=math.min(RADIUS,math.abs(z)+depth/2)
        local halfWidth=if edge<=RADIUS/2 then ROOT3*RADIUS/2 else ROOT3*(RADIUS-edge)
        local tile=F.part(hub,"Dalle hexagonale "..i,
            Vector3.new(math.max(0.1,2*halfWidth),1.65,depth+0.04),
            CFrame.new(0,0,z),Color3.fromRGB(208,224,214),Enum.Material.Cobblestone)
        tile.CanCollide=true
    end
    hexOutline(hub,49.0,1.05,Palette.base,1.65)
    hexOutline(hub,45.8,1.08,Palette.opal,0.5)
    for _,section in ipairs(Palette.sections) do
        local axis=Vector3.new(section.x,0,section.z)
        beam(hub,"Ruban d'orientation • "..section.name,axis*17+Vector3.new(0,1.02,0),
            axis*47+Vector3.new(0,1.02,0),5.5,0.13,section.pale,Enum.Material.SmoothPlastic)
        beam(hub,"Filet lumineux • "..section.name,axis*17+Vector3.new(0,1.11,0),
            axis*47+Vector3.new(0,1.11,0),0.9,0.17,section.color,Enum.Material.Neon)
        local p=axis*58
        local panel=decor(hub,"Portique "..section.name,Vector3.new(7,6,0.95),
            CFrame.new(p+Vector3.new(0,4.2,0))*CFrame.Angles(0,math.atan2(section.x,section.z),0),
            Palette.base,Enum.Material.Metal)
        panel:SetAttribute("KinSector",section.key)
        panel:SetAttribute("KinSectorHour",section.hour)
        panel:SetAttribute("KinSectorColor",section.color:ToHex())
        decor(hub,"Frise colorée "..section.name,Vector3.new(7.3,0.5,1),panel.CFrame*CFrame.new(0,3.05,0),
            section.color,Enum.Material.Neon)
        local destination=if section.key=="uckk" then "Université" else section.name
        local sign=F.sign(hub,"Direction "..section.name,p+Vector3.new(0,9.0,0),
            math.deg(math.atan2(-section.x,-section.z)),destination,14,2.6)
        sign:SetAttribute("KinSector",section.key)
    end
    -- Logo hexagonal de construction native; aucun asset distant requis.
    local logo=F.folder(hub,"Logo hexagonal central")
    hexOutline(logo,9.7,8.5,Palette.opal,1.0)
    hexOutline(logo,7.6,8.55,Palette.base,1.2)
    local core=decor(logo,"Cristal sarcelle",Vector3.new(10.5,0.7,10.5),
        CFrame.new(0,8.18,0),Palette.base,Enum.Material.Glass)
    core.Transparency=0.2
    for _,section in ipairs(Palette.sections) do
        beam(logo,"Direction du logo "..section.name,Vector3.new(0,8.65,0),
            Vector3.new(section.x*7.2,8.65,section.z*7.2),0.9,0.24,section.color,Enum.Material.Neon)
    end
    decor(logo,"Mât central",Vector3.new(0.95,6.2,0.95),CFrame.new(0,4.35,0),
        Palette.base,Enum.Material.Metal)
    -- Sans grands panneaux au centre : les six directions et le logo orientent déjà la place.
    return hub
end
return Heart
