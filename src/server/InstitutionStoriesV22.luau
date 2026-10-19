--!strict
-- Scénographie lisible et THÉMATIQUE dans chacune des six salles institutionnelles.
-- Zones murales en retrait; zéro collision et zéro nouveau faux terminal métier.
local Studio=require(script.Parent.ArtisanGeometryV22)
local Kit=require(script.Parent.CrystalKit)
local CollectionService=game:GetService("CollectionService")
local Stories={}
local profile=Kit.profile
local info={
    city_hall={role="civic",theme="L'assemblée des quartiers",body="La ville se construit autour d'espaces communs."},
    ekoh_tower={role="knowledge",theme="L'échange des savoirs",body="Une constellation de connaissances, à explorer ensemble."},
    library={role="archive",theme="La mémoire vivante",body="Chaque ouvrage ouvre une nouvelle perspective."},
    campus={role="orbit",theme="Le ciel et les sciences",body="Observer, questionner et expérimenter."},
    justice_palace={role="balance",theme="Les équilibres",body="Écoute, responsabilité et respect mutuel."},
    innovation_lab={role="mechanism",theme="Les inventions",body="Idées, essais et découvertes en mouvement."},
    museum={role="art",theme="La créativité",body="Les formes dialoguent avec les couleurs."},
    orgo_center={role="network",theme="Les liens invisibles",body="Relier les gens, les lieux et les initiatives."},
}
local function inscription(parent,text,base)
    local p=Studio.part(parent,"Cartouche minéral",Vector3.new(8.6,1.9,0.32),base,"deep",Enum.Material.Slate,false)
    local ui=Instance.new("SurfaceGui")
    ui.Name="Cartouche lisible"
    ui.Face=Enum.NormalId.Front
    ui.PixelsPerStud=45
    ui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
    ui.LightInfluence=0
    ui.Parent=p
    local label=Instance.new("TextLabel")
    label.Name="Texte"
    label.Size=UDim2.fromScale(1,1)
    label.BackgroundTransparency=1
    label.Text=text
    label.Font=Enum.Font.GothamSemibold
    label.TextColor3=Kit.pearl
    label.TextSize=25
    label.TextWrapped=true
    label.Parent=ui
end
function Stories.decorate(parent,placeKey,room,origin,index)
    local spec=info[placeKey]
    if not spec then return end
    local x,_,z=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<21 or d<20 then return end
    local scene=Instance.new("Folder")
    scene.Name="Scénographie narrative v22"
    scene:SetAttribute("KinArtTheme","sarcelle-cristal-v22")
    scene.Parent=parent
    local side=if index%2==0 then -1 else 1
    -- Sur le mur arrière latéral; le centre du passage demeure complètement dégagé.
    local anchor=CFrame.new(origin+Vector3.new(x+side*(w/2-7.8),8.3,z+d/2-1.1))
    Studio.part(scene,"Encadrement sculpté",Vector3.new(12.4,10.0,0.42),anchor,"deep",Enum.Material.Slate,false)
    Studio.part(scene,"Panneau opalin",Vector3.new(11.55,9.1,0.3),anchor*CFrame.new(0,0,-0.31),"medium",Enum.Material.Marble,false)
    Studio.part(scene,"Frise supérieure",Vector3.new(12.3,0.24,0.55),anchor*CFrame.new(0,5.2,-0.35),"gold",Enum.Material.Metal,true)
    local face=anchor*CFrame.new(0,0,-0.65)
    Studio.motif(scene,face*CFrame.new(0,0.9,0),spec.role,"opal",0.9)
    inscription(scene,spec.theme,anchor*CFrame.new(0,-3.55,-0.78))
    inscription(scene,spec.body,anchor*CFrame.new(0,-5.65,-0.78))
    -- Petit marqueur invisible NON INTERACTIF : découverte géométrique côté client.
    local marker=Instance.new("Part")
    marker.Name="Découverte de galerie"
    marker.Size=Vector3.new(0.2,0.2,0.2)
    marker.CFrame=CFrame.new(origin+Vector3.new(x,4,z))
    marker.Anchored=true
    marker.Transparency=1
    marker.CanCollide=false
    marker.CanTouch=false
    marker.CanQuery=false
    marker:SetAttribute("KinGalleryId",placeKey.."/"..room.room_id)
    marker:SetAttribute("KinGalleryTitle",room.display_name.." — "..spec.theme)
    marker.Parent=scene
    CollectionService:AddTag(marker,"KinCityGalleryV22")
    -- Salle 1 et salles alternées : petits reliefs secondaires; LITE reste dépouillé.
    if profile~="LITE" and index%2==1 then
        for _,side2 in ipairs({-1,1}) do
            Studio.facet(scene,"Cadran de cristal",anchor*CFrame.new(side2*5.15,-4.55,-0.9),0.45,1.5,
                if side2==-1 then "gold" else "opal",true)
        end
    end
    scene:SetAttribute("KinStoryTitle",spec.theme)
    scene:SetAttribute("KinStoryDescription",spec.body)
    return scene
end
return Stories
