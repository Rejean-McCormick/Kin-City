--!strict
-- EkoH relie les six quartiers par un halo sarcelle illuminé à mi-parcours.
-- Cette promenade EXPLIQUE EkoH et les ponts entre produits : aucun score,
-- vote civique, identité, ou donnée de service externe n'est exposé par les bornes.
local F=require(script.Parent.Factory)
local Palette=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("HexagonalDistricts"))
local Halo={}
local RADIUS=211
local HEIGHT=17
local SEGMENTS=96
local ANGLES=math.pi*2
local function deco(parent,name,size,cf,color,material)
    local p=F.part(parent,name,size,cf,color,material)
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
    return p
end
local function beam(parent,name,a,b,width,height,color,material)
    local d=b-a
    return deco(parent,name,Vector3.new(d.Magnitude,height,width),
        CFrame.new((a+b)*0.5)*CFrame.Angles(0,-math.atan2(d.Z,d.X),0),color,material)
end
local function buildingNearby(x,z,structures,pad)
    for _,b in ipairs(structures) do
        local dx,dz=x-b.center_studs[1],z-b.center_studs[3]
        local yaw=math.rad(b.yaw_degrees)
        local lx=math.cos(yaw)*dx-math.sin(yaw)*dz
        local lz=math.sin(yaw)*dx+math.cos(yaw)*dz
        if math.abs(lx)<b.footprint_studs[1]/2+pad and math.abs(lz)<b.footprint_studs[2]/2+pad then return true end
    end
    return false
end
local function kioskPlace(direction,structures)
    local side=Vector3.new(-direction.Z,0,direction.X)
    for _,r in ipairs({RADIUS,RADIUS-10,RADIUS+10,RADIUS-20,RADIUS+20}) do
        for _,offset in ipairs({0,12,-12,23,-23}) do
            local p=direction*r+side*offset
            if not buildingNearby(p.X,p.Z,structures,9) then return p end
        end
    end
    return direction*RADIUS
end
local topics={
    keenkonnect={"Collaboration", "Konstruct • TeamBuilder", "Konnaxion"},
    ethikos={"Éthique & expertise", "Contexte EkoH • accès privé", "Konnaxion"},
    kreative={"Création & mémoire", "Konservation • œuvres", "Konnaxion"},
    uckk={"Parcours", "Cours • activités • communauté", "Université King Klown"},
    ekole={"Connaissance", "Kristals • perspectives", "Ekole / Konstellation"},
    konnected={"Apprendre & valider", "Knowledge • CertifiKation", "Konnaxion"},
}
function Halo.make(city,plan)
    local root=F.folder(city,"EkoH • halo transversal lumineux")
    root:SetAttribute("KinHaloOwner","Konnaxion/EkoH")
    root:SetAttribute("KinColor","#1E6864")
    root:SetAttribute("KinRadiusStuds",RADIUS)
    root:SetAttribute("KinHeightStuds",HEIGHT)
    root:SetAttribute("KinScope","interpretation_and_wayfinding_only")
    root:SetAttribute("KinRingSegments",SEGMENTS)
    -- Anneau continu en altitude : son étage n'est PAS une surface praticable.
    -- Les bornes sont au sol, accessibles sans téléportation ni plateforme flottante.
    for i=0,SEGMENTS-1 do
        local a=i*ANGLES/SEGMENTS
        local b=(i+1)*ANGLES/SEGMENTS
        local p=Vector3.new(math.cos(a)*RADIUS,HEIGHT,math.sin(a)*RADIUS)
        local q=Vector3.new(math.cos(b)*RADIUS,HEIGHT,math.sin(b)*RADIUS)
        beam(root,"Structure du halo EkoH",p,q,1.8,1.0,Palette.base,Enum.Material.Metal)
        beam(root,"Lumière EkoH",p+Vector3.new(0,0.58,0),
            q+Vector3.new(0,0.58,0),0.7,0.3,Palette.light,Enum.Material.Neon)
        if i%8==0 then
            local point=deco(root,"Source de lumière",Vector3.new(1.3,1.3,1.3),
                CFrame.new(p+Vector3.new(0,0.8,0)),Palette.light,Enum.Material.Neon)
            local light=Instance.new("PointLight")
            light.Color=Palette.light
            light.Brightness=0.8
            light.Range=31
            light.Shadows=false
            light.Parent=point
        end
    end
    local posts=F.folder(root,"Bornes EkoH aux six axes")
    for _,section in ipairs(Palette.sections) do
        local direction=Vector3.new(section.x,0,section.z)
        local p=kioskPlace(direction,plan.structures)
        local group=F.folder(posts,"Borne "..section.name)
        group:SetAttribute("KinSector",section.key)
        group:SetAttribute("KinTheme",section.material)
        -- KC36 : supports latéraux, jamais d'axe opaque devant le texte.
        -- Le portique entier est orienté comme l'avenue du secteur.
        local yaw=math.atan2(section.x,section.z)
        local frame=CFrame.new(p)*CFrame.Angles(0,yaw,0)
        local boardWidth=25
        local signY=10.3
        local supportHeight=13.0
        local supportDistance=boardWidth/2+1.1
        for _,side in ipairs({-1,1}) do
            local foot=(frame*CFrame.new(side*supportDistance,supportHeight/2,0)).Position
            local post=deco(group,"Colonne latérale du portique",Vector3.new(supportHeight,0.78,0.78),
                CFrame.new(foot)*CFrame.Angles(0,0,math.pi/2),Palette.base,Enum.Material.Metal)
            post.Shape=Enum.PartType.Cylinder
            post:SetAttribute("KinSignStructuralSupport",true)
            local link=deco(group,"Fixation latérale du panneau",Vector3.new(1.4,0.22,0.38),
                frame*CFrame.new(side*(boardWidth/2+0.4),signY,0),Palette.light,Enum.Material.Metal)
            link:SetAttribute("KinSignStructuralSupport",true)
        end
        group:SetAttribute("KinSignSupportRevision","KC36-twin-post-clear-center")
        local terminal=deco(group,"Borne d'exploration",Vector3.new(5.4,5.3,3.5),
            frame*CFrame.new(0,3.5,0),Palette.base,Enum.Material.Metal)
        deco(group,"Façade éclairée",Vector3.new(4.6,3.0,0.32),
            frame*CFrame.new(0,4.2,-1.94),Palette.light,Enum.Material.Neon).Transparency=0.3
        deco(group,"Sommet coloré",Vector3.new(5.7,0.5,3.6),
            frame*CFrame.new(0,6.35,0),section.color,Enum.Material.Neon)
        local meta=topics[section.key]
        local sign=F.sign(group,"EkoH • "..section.name,p+Vector3.new(0,signY,0),math.deg(yaw),
            "EkoH • "..meta[1].."\n"..meta[2],boardWidth,3.7,
            {section=section.key,doubleSided=true})
        sign:SetAttribute("KinDisclosure","Découverte publique, aucune donnée personnelle")
        sign:SetAttribute("KinSignMount","twin-post")
        terminal:SetAttribute("KinStubInteractionId","ekoh.terminal."..section.key)
        terminal:SetAttribute("KinStubCapabilityId","ekoh.public.exploration")
        terminal:SetAttribute("KinStubTitle","EkoH • "..section.name)
        F.prompt(terminal,"Découvrir",meta[3].." / EkoH")
    end
    -- Orgo et Konstellation traversent la ville, mais ne deviennent pas des quartiers.
    local links=F.folder(root,"Systèmes transversaux")
    local cross={
        {angle=-math.pi/3,title="ORGO",detail="Coordonner • transmettre"},
        {angle=2*math.pi/3,title="KONSTELLATION",detail="Explorer • relier"},
    }
    for _,item in ipairs(cross) do
        local p=kioskPlace(Vector3.new(math.cos(item.angle),0,math.sin(item.angle)),plan.structures)
        local terminal=deco(links,"Kiosque "..item.title,Vector3.new(4.5,5,2.8),
            CFrame.new(p+Vector3.new(0,3.1,0)),Palette.base,Enum.Material.Metal)
        terminal:SetAttribute("KinStubInteractionId","ekoh.cross."..item.title)
        terminal:SetAttribute("KinStubCapabilityId","ecosystem.public.discover")
        terminal:SetAttribute("KinStubTitle",item.title)
        F.prompt(terminal,"Explorer",item.title)
        F.sign(links,"Passerelle "..item.title,p+Vector3.new(0,8.8,0),0,
            item.title.."\n"..item.detail,28,3.4)
    end
    return root
end
return Halo
