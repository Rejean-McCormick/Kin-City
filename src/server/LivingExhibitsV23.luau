--!strict
-- Huit expositions interactives à quatre chapitres. Les textes sont locaux,
-- consultables sans kOA; les changements de sculpture et de panneau répliquent.
-- Aucune décision, note ou vote n'est simulé.
local ProximityPromptService=game:GetService("ProximityPromptService")
local Kit=require(script.Parent.CrystalKit)
local Factory=require(script.Parent.Factory)
local Atlas={}
local pages={
    city_hall={
        {"La cité", "Les rues et places forment un espace de rencontre."},
        {"Les quartiers", "Chaque quartier possède sa silhouette et ses usages."},
        {"La place centrale", "Le mandala relie les promenades de Kin City."},
        {"La visite", "Explore les jardins, bâtiments et espaces publics."},
    },
    ekoh_tower={
        {"Curiosité", "Une idée naît souvent d'une question simple."},
        {"Transmission", "Observer et expliquer sont deux gestes complémentaires."},
        {"Constellations", "Des points distincts dessinent un savoir partagé."},
        {"Exploration", "La ville offre des découvertes sans score."},
    },
    library={
        {"Les livres", "Chaque volume invite à découvrir une histoire."},
        {"Les archives", "Conserver permet de retrouver et comparer."},
        {"Les cartes", "Les plans racontent la forme de notre cité."},
        {"L'imaginaire", "Les récits relient des mondes possibles."},
    },
    campus={
        {"Observer", "Une expérience commence par une observation."},
        {"Mesurer", "Les instruments nous aident à comparer."},
        {"Les orbites", "Les trajectoires révèlent des régularités."},
        {"Questionner", "Chaque réponse peut ouvrir une autre question."},
    },
    justice_palace={
        {"Écouter", "Un dialogue demande du temps et de l'attention."},
        {"Comprendre", "Les perspectives d'une situation peuvent varier."},
        {"Équilibre", "Une balance symbolise la recherche de justesse."},
        {"Respect", "La dignité de chacun guide les espaces de rencontre."},
    },
    innovation_lab={
        {"Imaginer", "Une invention commence par une possibilité."},
        {"Fabriquer", "Un premier assemblage rend l'idée tangible."},
        {"Essayer", "Les prototypes permettent d'apprendre."},
        {"Repenser", "Améliorer une machine exige d'observer ses effets."},
    },
    museum={
        {"Matière", "Les formes changent selon la lumière."},
        {"Couleurs", "Les teintes créent une ambiance singulière."},
        {"Mouvement", "Une œuvre peut se lire en marchant autour."},
        {"Création", "L'art propose des rencontres inattendues."},
    },
    orgo_center={
        {"Relier", "Un chemin associe deux lieux distincts."},
        {"Assembler", "De petites unités composent un ensemble."},
        {"Circuler", "Les passages permettent de traverser la ville."},
        {"Coordonner", "Un réseau vivant évolue au fil des usages."},
    },
}
local function piece(parent,kind,name,size,cf,color,material,optional)
    local obj=Kit.part(parent,kind,name,size,cf,color,material or Enum.Material.Slate)
    if optional then obj:SetAttribute("KinOptionalDetail",true) end
    return obj
end
local function caption(parent,name,position,size,text,textSize)
    local gui=Instance.new("SurfaceGui")
    gui.Name=name
    gui.Face=Enum.NormalId.Front
    gui.CanvasSize=Vector2.new(700,280)
    gui.LightInfluence=0
    gui.Parent=parent
    local label=Instance.new("TextLabel")
    label.Name="Contenu"
    label.Size=UDim2.fromScale(1,1)
    label.Position=UDim2.fromScale(0,0)
    label.BackgroundTransparency=1
    label.TextColor3=Kit.pearl
    label.Font=Enum.Font.GothamMedium
    label.TextWrapped=true
    label.TextSize=textSize
    label.Text=text
    label.Parent=gui
    return label
end
local function render(host,placeKey,pageIndex)
    local collection=pages[placeKey]
    if not collection then return end
    local page=collection[pageIndex]
    if not page then return end
    local heading=host:FindFirstChild("TitreChapitre",true)
    local body=host:FindFirstChild("TexteChapitre",true)
    local progress=host:FindFirstChild("Pagination",true)
    if heading and heading:IsA("TextLabel") then heading.Text=page[1] end
    if body and body:IsA("TextLabel") then body.Text=page[2] end
    if progress and progress:IsA("TextLabel") then progress.Text=tostring(pageIndex).." / "..tostring(#collection) end
    local gem=host.Parent and host.Parent:FindFirstChild("Noyau de chapitre")
    if gem and gem:IsA("BasePart") then
        local initial=gem:GetAttribute("KinOriginalCFrame")
        -- Référence reconstructible depuis une position fixe; pas de dérive cumulative.
        local base=host.CFrame*CFrame.new(0,2.65,0.2)
        gem.CFrame=base*CFrame.Angles(0,(pageIndex-1)*math.pi/2,math.rad(12))
        gem.Color=if pageIndex%2==0 then Kit.gold else Kit.accent(placeKey)
    end
    host:SetAttribute("KinAtlasPage",pageIndex)
end
function Atlas.decorate(roomFolder,placeKey,room,origin,index)
    local collection=pages[placeKey]
    if index~=1 or not collection then return end
    local cx,_,cz=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<30 or d<28 then return end
    local root=Instance.new("Model")
    root.Name="Atlas vivant — "..placeKey
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v23")
    root.Parent=roomFolder
    local localBase=CFrame.new(origin+Vector3.new(cx+w/2-10,0,cz-d/2+13))*CFrame.Angles(0,math.pi/2,0)
    piece(root,"Part","Socle de consultation",Vector3.new(7.8,1.2,4),localBase*CFrame.new(0,0.6,0),Kit.deep,Enum.Material.Marble,false)
    piece(root,"Part","Feuillet champagne",Vector3.new(7.6,0.22,4.1),localBase*CFrame.new(0,1.32,0),Kit.gold,Enum.Material.Metal,false)
    local host=piece(root,"Part","Écran de chapitres",Vector3.new(7.0,4.4,0.45),localBase*CFrame.new(0,4.3,1.38),Kit.deep,Enum.Material.Slate,false)
    host:SetAttribute("KinExhibitV23",true)
    host:SetAttribute("KinExhibitPlace",placeKey)
    host:SetAttribute("KinAtlasPage",1)
    local headingSurface=Instance.new("SurfaceGui")
    headingSurface.Name="Panneau de titre"
    headingSurface.Face=Enum.NormalId.Front
    headingSurface.CanvasSize=Vector2.new(700,200)
    headingSurface.LightInfluence=0
    headingSurface.Parent=host
    local heading=Instance.new("TextLabel")
    heading.Name="TitreChapitre"
    heading.Size=UDim2.fromScale(0.94,0.4)
    heading.Position=UDim2.fromScale(0.03,0.04)
    heading.TextColor3=Kit.gold
    heading.BackgroundTransparency=1
    heading.Font=Enum.Font.GothamBold
    heading.TextWrapped=true
    heading.TextSize=39
    heading.Parent=headingSurface
    local body=Instance.new("TextLabel")
    body.Name="TexteChapitre"
    body.Size=UDim2.fromScale(0.94,0.48)
    body.Position=UDim2.fromScale(0.03,0.46)
    body.TextColor3=Kit.pearl
    body.BackgroundTransparency=1
    body.Font=Enum.Font.Gotham
    body.TextWrapped=true
    body.TextSize=30
    body.Parent=headingSurface
    local progress=Instance.new("TextLabel")
    progress.Name="Pagination"
    progress.Size=UDim2.fromScale(0.2,0.17)
    progress.Position=UDim2.fromScale(0.78,0.01)
    progress.TextColor3=Kit.gold
    progress.BackgroundTransparency=1
    progress.Font=Enum.Font.GothamBold
    progress.TextSize=21
    progress.Parent=headingSurface
    piece(root,"WedgePart","Noyau de chapitre",Vector3.new(1.8,1.7,1.5),host.CFrame*CFrame.new(0,2.65,0.2),Kit.accent(placeKey),Enum.Material.Slate,false)
    local prompt=Factory.prompt(host,"Chapitre suivant","Exposition de Kin City")
    prompt.MaxActivationDistance=12
    render(host,placeKey,1)
    return root
end
function Atlas.start(world)
    local last=setmetatable({},{__mode="k"})
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or host:GetAttribute("KinExhibitV23")~=true then return end
        if not host:IsDescendantOf(world) then return end
        local placeKey=host:GetAttribute("KinExhibitPlace")
        local collection=pages[placeKey]
        if not collection then return end
        local character=player.Character
        local humanoid=character and character:FindFirstChildOfClass("Humanoid")
        local rootPart=character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or humanoid.Health<=0 or not rootPart or not rootPart:IsA("BasePart") then return end
        if (rootPart.Position-host.Position).Magnitude>15 then return end
        local now=os.clock()
        if last[player] and now-last[player]<0.35 then return end
        last[player]=now
        local current=host:GetAttribute("KinAtlasPage") or 1
        render(host,placeKey,(current%#collection)+1)
    end)
end
return Atlas
