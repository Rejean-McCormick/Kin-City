--!strict
-- v19 : une narration visuelle différente pour chacune des 8 institutions.
-- Installations murales hautes : la surface praticable et les portails restent libres.
local Kit=require(script.Parent.CrystalKit)
local F=require(script.Parent.Factory)
local RoomStories={}
local themes={
    city_hall={title="Cité solidaire",form="mandala",tones=7},
    ekoh_tower={title="Cartographie du savoir",form="constellation",tones=9},
    library={title="Archives vivantes",form="books",tones=8},
    campus={title="Univers des possibles",form="orbits",tones=8},
    justice_palace={title="Harmonie des équilibres",form="symmetry",tones=8},
    innovation_lab={title="Fabrique expérimentale",form="gears",tones=7},
    museum={title="Matières et couleurs",form="ribbons",tones=9},
    orgo_center={title="Réseau de coopération",form="network",tones=8},
}
local function ornament(parent,name,size,cf,color,material,optional)
    local p=Kit.part(parent,"Part",name,size,cf,color,material)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    return p
end
local function line(parent,name,a,b,width,color,optional)
    local d=b-a
    if d.Magnitude<0.04 then return nil end
    return ornament(parent,name,Vector3.new(width,width,d.Magnitude),CFrame.lookAt((a+b)*0.5,b),color,Enum.Material.Metal,optional)
end
local function tableau(root,frame,form,accent,radius,count)
    -- Tous les panneaux sont au-dessus des avatars, devant un mur d'exposition.
    if form=="books" then
        for n=1,5 do
            local x=(n-3)*1.65
            local leaf=ornament(root,"Volume des archives",Vector3.new(1.25,4.6+(n%2)*0.6,0.4),
                frame*CFrame.new(x,0,0),if n%2==0 then accent else Kit.gold,Enum.Material.Slate,n>3)
            leaf.CFrame=leaf.CFrame*CFrame.Angles(0,0,(n-3)*0.075)
        end
    elseif form=="symmetry" then
        line(root,"Fléau symétrique",(frame*CFrame.new(-radius,0,0)).Position,(frame*CFrame.new(radius,0,0)).Position,0.45,Kit.gold,false)
        line(root,"Socle vertical",(frame*CFrame.new(0,-radius,0)).Position,(frame*CFrame.new(0,radius,0)).Position,0.45,accent,false)
        for _,s in ipairs({-1,1}) do
            ornament(root,"Coupelle",Vector3.new(2.9,0.22,0.5),frame*CFrame.new(s*radius*0.73,-radius*0.48,0),accent,Enum.Material.Metal,true)
        end
    else
        local sides=if form=="mandala" then 8 elseif form=="ribbons" then 5 else 6
        for i=1,sides do
            local a=(i-1)*2*math.pi/sides
            local b=i*2*math.pi/sides
            local pos1=(frame*CFrame.new(math.cos(a)*radius,math.sin(a)*radius,0)).Position
            local pos2=(frame*CFrame.new(math.cos(b)*radius,math.sin(b)*radius,0)).Position
            if form=="network" or form=="gears" or form=="orbits" then
                line(root,"Connexion opaline",pos1,pos2,0.28,if i%2==0 then accent else Kit.gold,i>3)
            else
                line(root,"Facette murale",frame.Position,pos1,0.28,if i%2==0 then accent else Kit.gold,i>3)
            end
            if i<=count and (form=="constellation" or form=="network") then
                local star=ornament(root,"Cristal de connaissance",Vector3.new(0.6,0.6,0.4),CFrame.new(pos1),accent,Enum.Material.Neon,true)
                star.Shape=Enum.PartType.Ball
            end
        end
        if form=="gears" or form=="orbits" then
            local core=ornament(root,"Centre de la découverte",Vector3.new(1.5,1.5,0.6),frame,Kit.opal,Enum.Material.Neon,false)
            core.Shape=Enum.PartType.Ball
        end
    end
end
function RoomStories.make(model,place,origin,_style)
    local theme=themes[place.place_key]
    if not theme then return nil end
    local root=Instance.new("Folder")
    root.Name="Galeries narratives — v19"
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v19")
    root.Parent=model
    local accent=Kit.accent(place.place_key)
    for i,room in ipairs(place.rooms) do
        -- Ne pas surcharger les 6 salles. L'entrée et deux salles de parcours font la signature.
        if i<=3 then
            local x,_,z=table.unpack(room.center_studs)
            local w,_,d=table.unpack(room.size_studs)
            local width=math.max(6,math.min(15,(w-12)*0.45))
            local wallZ=z+d/2-1.45
            -- Le centre du mur est réservé aux panneaux de signalétique existants.
            local muralX=x-w*0.32
            local base=CFrame.new(origin+Vector3.new(muralX,10.7,wallZ))*CFrame.Angles(0,math.pi,0)
            -- Encadrement haut, dégagé du plancher et du mobilier.
            local border=ornament(root,"Panneau d'institution",Vector3.new(width,6.8,0.24),
                base*CFrame.new(0,0,0.12),Kit.deep,Enum.Material.Slate,false)
            border.Transparency=0.07
            ornament(root,"Bandeau supérieur",Vector3.new(width+0.7,0.34,0.38),base*CFrame.new(0,3.5,0),Kit.gold,Enum.Material.Metal,true)
            ornament(root,"Liseré inférieur",Vector3.new(width+0.7,0.23,0.38),base*CFrame.new(0,-3.5,0),Kit.primary,Enum.Material.Metal,true)
            tableau(root,base*CFrame.new(0,0,-0.35),theme.form,accent,math.min(2.8,width*0.22),theme.tones)
        end
    end
    return root
end
return RoomStories
