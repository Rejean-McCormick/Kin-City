--!strict
-- Identités visibles des six secteurs : maquettes natives, un axe chromatique
-- transversal en sarcelle et des matériaux propres à chaque secteur.
-- Les huit institutions suivent les nouvelles implantations canoniques v31.
local F=require(script.Parent.Factory)
local Districts=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("HexagonalDistricts"))
local Landmarks={}
local TEAL=Districts.base
local function ornament(parent,name,size,cf,color,material)
    local p=F.part(parent,name,size,cf,color,material)
    p.CanCollide=false;p.CanTouch=false;p.CanQuery=false
    return p
end
local function text(parent,name,at,string,width)
    local board=F.sign(parent,name,at,0,string,width or 24,3.0)
    board.CanCollide=false
    return board
end
local function nearBuilding(x,z,structures,pad)
    for _,b in ipairs(structures) do
        local dx=x-b.center_studs[1]
        local dz=z-b.center_studs[3]
        local yaw=math.rad(b.yaw_degrees)
        local lx=math.cos(yaw)*dx-math.sin(yaw)*dz
        local lz=math.sin(yaw)*dx+math.cos(yaw)*dz
        if math.abs(lx)<b.footprint_studs[1]/2+pad and math.abs(lz)<b.footprint_studs[2]/2+pad then return true end
    end
    return false
end
local function site(section,structures)
    local axis=Vector3.new(section.x,0,section.z)
    local across=Vector3.new(-axis.Z,0,axis.X)
    for _,r in ipairs({151,177,130,205,234}) do
        for _,offset in ipairs({0,23,-23,44,-44}) do
            local p=axis*r+across*offset
            if not nearBuilding(p.X,p.Z,structures,23) then return p end
        end
    end
    return axis*174 -- Toujours dans le bon secteur si l'urbanisme évolue.
end
-- L'identité du secteur est portée par les matériaux et les lumières, pas
-- par une seconde façade-panneau qui masque les institutions.
local function renderTheme(parent,section,at)
    local kind=section.material
    if kind=="metal" then
        for i=-2,2 do
            ornament(parent,"Colonne acier brossé",Vector3.new(1.8,9,1.8),CFrame.new(at+Vector3.new(i*7.1,5.4,0)),
                section.secondary,Enum.Material.Metal)
            ornament(parent,"Module expérimental",Vector3.new(4.7,2.1,4.7),
                CFrame.new(at+Vector3.new(i*7.1,10.7,0)),section.lightColor,Enum.Material.Glass)
            ornament(parent,"Trait d'énergie",Vector3.new(3.8,0.36,3.8),CFrame.new(at+Vector3.new(i*7.1,11.9,0)),
                section.lightColor,Enum.Material.Neon)
        end
    elseif kind=="wood" then
        for i=-2,2 do
            ornament(parent,"Pilotis de bois",Vector3.new(2.1,8.5,2.1),CFrame.new(at+Vector3.new(i*7.2,5.3,0)),
                section.secondary,Enum.Material.WoodPlanks)
            ornament(parent,"Linteau éthique",Vector3.new(6.5,1.1,4.7),CFrame.new(at+Vector3.new(i*7.2,10.1,0)),
                section.color,Enum.Material.Wood)
        end
        ornament(parent,"Table de concertation",Vector3.new(26,1.15,6),
            CFrame.new(at+Vector3.new(0,2.2,-5)),TEAL,Enum.Material.Wood)
    elseif kind=="black_marble" then
        for i=-2,2 do
            local x=i*7
            ornament(parent,"Marbre noir",Vector3.new(6.3,11.3,3.1),
                CFrame.new(at+Vector3.new(x,6.9,0)),section.dark,Enum.Material.Marble)
            for n=1,3 do
                ornament(parent,"Veinure dorée",Vector3.new(0.22,10.1,0.15),
                    CFrame.new(at+Vector3.new(x+(n-2)*1.65,7,1.62))*CFrame.Angles(0,0,math.rad(12+n*13)),
                    Districts.gold,Enum.Material.Metal)
            end
            ornament(parent,"Inclusion sarcelle",Vector3.new(5.6,0.46,3.4),
                CFrame.new(at+Vector3.new(x,12.7,0)),section.lightColor,Enum.Material.Neon)
        end
    elseif kind=="monochrome" then
        for i=-2,2 do
            local white=i%2==0
            ornament(parent,"Voile noir et blanc",Vector3.new(6.5,10.5,2.2),
                CFrame.new(at+Vector3.new(i*7.1,6.9,0)),
                if white then section.pale else section.dark,Enum.Material.SmoothPlastic)
            ornament(parent,"Relais Kristal",Vector3.new(1.3,1.3,2.65),
                CFrame.new(at+Vector3.new(i*7.1,7.8,1.6)),section.lightColor,Enum.Material.Neon)
        end
        for i=-2,1 do
            ornament(parent,"Relation entre connaissances",Vector3.new(7,0.37,0.37),
                CFrame.new(at+Vector3.new(i*7.1+3.55,7.8,1.7)),section.lightColor,Enum.Material.Neon)
        end
    elseif kind=="academy" then
        for i=-2,2 do
            ornament(parent,"Pilier pédagogique",Vector3.new(3.2,9.6,3.2),
                CFrame.new(at+Vector3.new(i*7.2,6.2,0)),section.dark,Enum.Material.Slate)
            ornament(parent,"Capitelle de progression",Vector3.new(5.2,1.1,5.2),
                CFrame.new(at+Vector3.new(i*7.2,11.4,0)),section.color,Enum.Material.Marble)
            ornament(parent,"Éclair de parcours",Vector3.new(1.1,2.5,0.35),
                CFrame.new(at+Vector3.new(i*7.2,6.5,-1.75)),section.lightColor,Enum.Material.Neon)
        end
    elseif kind=="creative" then
        for i=-2,2 do
            local sculpture=ornament(parent,"Oeuvre dynamique Kreative",Vector3.new(4.5,5,4.5),
                CFrame.new(at+Vector3.new(i*7.1,7,0))*CFrame.Angles(math.rad(12),i*0.25,math.rad(17+i*8)),
                section.color,Enum.Material.Glass)
            sculpture:SetAttribute("KinKreativeCanvas",true)
            sculpture:SetAttribute("KinArtElement",i)
            ornament(parent,"Pied d'œuvre",Vector3.new(3,5,3),CFrame.new(at+Vector3.new(i*7.1,2.5,0)),
                TEAL,Enum.Material.Metal)
        end
    end
end
local VOTE_OPTIONS={
    {id="cuivre",label="Cuivre & corail",color=Color3.fromRGB(206,132,106)},
    {id="nuit",label="Nuit opaline",color=Color3.fromRGB(90,124,165)},
    {id="prune",label="Prune & ivoire",color=Color3.fromRGB(155,111,164)},
}
Landmarks.themeOptions=VOTE_OPTIONS
function Landmarks.make(city,plan)
    local roots=F.folder(city,"Six secteurs • identités matérielles")
    roots:SetAttribute("KinArtSharedColor","#1E6864")
    for _,s in ipairs(Districts.sections) do
        local folder=F.folder(roots,s.name)
        folder:SetAttribute("KinSector",s.key)
        folder:SetAttribute("KinClockHour",s.hour)
        folder:SetAttribute("KinThemeMaterial",s.material)
        folder:SetAttribute("KinSectorSystem",s.system)
        local at=site(s,plan.structures)
        folder:SetAttribute("KinExhibitionCenter",at)
        local base=ornament(folder,"Parvis thématique",Vector3.new(43,0.25,36),
            CFrame.new(at+Vector3.new(0,0.23,0)),s.pale,Enum.Material.SmoothPlastic)
        base.Transparency=0.2
        renderTheme(folder,s,at)
        if s.key=="kreative" then
            -- Le scrutin modifie l'ambiance du lieu, pas seulement une sculpture.
            for _,piece in ipairs(folder:GetDescendants()) do
                if piece:IsA("BasePart") and
                    (piece.Material==Enum.Material.Neon and not string.find(piece.Name,"Échantillon",1,true)) then
                    piece:SetAttribute("KinKreativeCanvas",true)
                end
            end
        end
        for side=-1,1,2 do
            local shaft=ornament(folder,"Signal lumineux de district",Vector3.new(0.65,11.5,0.65),
                CFrame.new(at+Vector3.new(side*21,6,0)),s.lightColor,Enum.Material.Neon)
            local cap=ornament(folder,"Accent secondaire",Vector3.new(1.7,1.7,1.7),
                CFrame.new(at+Vector3.new(side*21,12.4,0)),s.lightColor,Enum.Material.Glass)
            local light=Instance.new("PointLight")
            light.Name="Lueur du secteur"
            light.Brightness=0.38;light.Range=16;light.Shadows=false;light.Color=s.lightColor;light.Parent=cap
            if s.key=="kreative" then
                shaft:SetAttribute("KinKreativeCanvas",true)
                cap:SetAttribute("KinKreativeCanvas",true)
                light:SetAttribute("KinKreativeLight",true)
            end
        end
        if s.key=="kreative" then
            -- Vrai vote visuel limité à la session. Aucun Smart Vote / EkoH.
            local board=text(folder,"Résultat de l'ambiance",at+Vector3.new(0,15,-20),
                "THÈME KREATIVE\nCuivre & corail",24)
            board:SetAttribute("KinKreativeResults",true)
            folder:SetAttribute("KinKreativeActiveTheme","cuivre")
            folder:SetAttribute("KinKreativeVoteScope","session_cosmetic_only")
            for i,option in ipairs(VOTE_OPTIONS) do
                local p=at+Vector3.new((i-2)*11,0,-31)
                local terminal=ornament(folder,"Choisir "..option.label,Vector3.new(7.7,6.1,3.9),
                    CFrame.new(p+Vector3.new(0,3.5,0)),TEAL,Enum.Material.Metal)
                terminal:SetAttribute("KinKreativeThemeId",option.id)
                terminal:SetAttribute("KinKreativeLocalOnly",true)
                ornament(folder,"Échantillon "..option.label,Vector3.new(6.7,2.1,0.3),
                    CFrame.new(p+Vector3.new(0,4.8,-2.08)),option.color,Enum.Material.Neon)
                local prompt=F.prompt(terminal,"Voter pour l'ambiance",option.label)
                prompt.HoldDuration=0.25
                prompt.MaxActivationDistance=13
                text(folder,"Nom du thème "..option.id,p+Vector3.new(0,9,0),option.label,12)
            end
        end
        -- Le devant de chaque pavillon fait face au coeur hexagonal.
        -- Transformation rigide des pièces après génération, invites incluses.
        local yaw=math.atan2(-s.x,s.z)
        local pivot=CFrame.new(at)*CFrame.Angles(0,yaw,0)*CFrame.new(-at)
        for _,piece in ipairs(folder:GetDescendants()) do
            if piece:IsA("BasePart") then piece.CFrame=pivot*piece.CFrame end
        end
    end
    return roots
end
return Landmarks
