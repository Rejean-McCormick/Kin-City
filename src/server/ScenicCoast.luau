--!strict
-- Belvédères côtiers accessibles. Une longue-vue déclenche une vraie caméra locale,
-- sans transport du joueur ni service externe.
local F=require(script.Parent.Factory)
local Coast={}
function Coast.make(city)
    local root=F.folder(city,"Observatoires du littoral")
    for i=1,8 do
        local a=i*math.pi/4
        local radial=Vector3.new(math.cos(a),0,math.sin(a))
        local position=radial*467
        local base=CFrame.new(position)*CFrame.Angles(0,-a+math.pi/2,0)
        local m=F.folder(root,"Observatoire côtier "..i)
        local plinth=F.part(m,"Socle d'orientation",Vector3.new(3.2,3.0,3.2),base*CFrame.new(0,1.6,0),Color3.fromRGB(58,80,91),Enum.Material.Metal)
        local scope=F.part(m,"Tube optique",Vector3.new(1.4,1.5,4),base*CFrame.new(0,3.6,-0.5),Color3.fromRGB(189,150,91),Enum.Material.Metal)
        scope.CanCollide=false
        local lens=F.part(m,"Objectif",Vector3.new(1.0,1.0,0.25),base*CFrame.new(0,3.6,-2.56),Color3.fromRGB(102,197,214),Enum.Material.Glass)
        lens.CanCollide=false
        plinth:SetAttribute("KinVistaId","vista.coast."..i)
        plinth:SetAttribute("KinVistaTitle","Panorama de la cité "..i)
        plinth:SetAttribute("KinVistaCameraPosition",position+Vector3.new(0,34,0)+radial*16)
        plinth:SetAttribute("KinVistaLookAt",Vector3.new(0,25,0))
        F.prompt(plinth,"Observer","Panorama de Kin City")
    end
    return root
end
return Coast
