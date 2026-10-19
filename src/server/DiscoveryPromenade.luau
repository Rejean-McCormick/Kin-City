--!strict
-- Parcours de vingt-quatre bornes de découverte. Les visites restent locales à la session.
local F=require(script.Parent.Factory)
local Trail={}
local captions={
    {"La place centrale","La ville est organisée autour d'un espace commun."},
    {"Les huit quartiers","Chaque quartier possède une identité et des usages distincts."},
    {"Le lac annulaire","Les paysages naturels peuvent inspirer l'urbanisme."},
    {"La bibliothèque","Les connaissances deviennent plus utiles quand elles sont partagées."},
    {"La démarche scientifique","Observer, tester et expliquer sont trois étapes complémentaires."},
    {"Le jardin vivant","Une ville peut offrir de nombreux habitats à la biodiversité."},
    {"Les métiers du monde","Les techniques s'apprennent aussi par l'expérimentation."},
    {"L'architecture civique","Un bâtiment public doit accueillir différentes personnes."},
    {"Les matériaux","Bois, pierre et métal ont des propriétés différentes."},
    {"Le cycle de l'eau","L'eau circule entre la terre, les rivières et l'atmosphère."},
    {"La lumière du jour","L'orientation des bâtiments influence leur ensoleillement."},
    {"La mobilité douce","Des rues piétonnes donnent une place au déplacement lent."},
    {"Les rencontres","Les espaces communs permettent des échanges inattendus."},
    {"L'observation","Voir un phénomène ne suffit pas toujours à l'expliquer."},
    {"La création","Arts et sciences peuvent enrichir une même expérience."},
    {"La transmission","L'enseignement relie les générations et les communautés."},
    {"Le patrimoine","Préserver une trace aide à comprendre son histoire."},
    {"Le dialogue","Écouter plusieurs perspectives améliore la compréhension."},
    {"L'éthique","Une décision peut avoir des conséquences différentes selon les personnes."},
    {"La collaboration","Un projet collectif demande une coordination explicite."},
    {"La réparation","Réutiliser et réparer peut limiter le gaspillage."},
    {"L'énergie","Toute transformation d'énergie a des contraintes physiques."},
    {"Le temps long","Une ville évolue et se transforme au fil des usages."},
    {"Le chemin parcouru","Explorer un lieu aide à se construire des repères."},
}
function Trail.make(city)
    local root=F.folder(city,"Sentier pédagogique — 24 haltes")
    for i,item in ipairs(captions) do
        local a=(i-1)*math.pi*2/#captions+0.09
        local r=376+(i%2)*6
        local x,z=math.cos(a)*r,math.sin(a)*r
        local angle=math.pi/2-a
        local base=CFrame.new(x,0,z)*CFrame.Angles(0,angle,0)
        local m=Instance.new("Model")
        m.Name=string.format("Halte %02d — %s",i,item[1]);m.Parent=root
        local floor=F.part(m,"Pavement de la halte",Vector3.new(9,0.24,7),base*CFrame.new(0,-0.14,0),Color3.fromRGB(216,206,184),Enum.Material.Cobblestone)
        local pedestal=F.part(m,"Borne de découverte",Vector3.new(2.3,3.6,1.6),base*CFrame.new(0,1.9,0.5),Color3.fromRGB(42,71,82),Enum.Material.Metal)
        pedestal:SetAttribute("KinTrailId",string.format("kin.trail.%02d",i))
        pedestal:SetAttribute("KinTrailTitle",item[1]);pedestal:SetAttribute("KinTrailText",item[2])
        F.prompt(pedestal,"Découvrir",item[1])
        local cap=F.part(m,"Lanterne",Vector3.new(1.7,0.75,1.7),base*CFrame.new(0,4.0,0.5),Color3.fromRGB(241,208,146),Enum.Material.Neon)
        cap.CanCollide=false
        F.sign(m,"Plaque",(base*CFrame.new(0,5.6,0.5)).Position,math.deg(angle),string.format("%02d  %s",i,item[1]),12,2.1).CanCollide=false
    end
    root:SetAttribute("KinTrailStops",#captions)
    return root
end
function Trail.isReserved(x,z)
    for i=1,#captions do
        local a=(i-1)*math.pi*2/#captions+0.09
        local r=376+(i%2)*6
        local dx=x-math.cos(a)*r
        local dz=z-math.sin(a)*r
        if dx*dx+dz*dz<11*11 then return true end
    end
    return false
end
return Trail
