--!strict
-- Kin City v20 — mobilier sculpté/minéral pour les six pièces de chaque institution.
-- Éléments purement architecturaux, jamais de remplacement des interactions canoniques.
local Factory=require(script.Parent.Factory)
local Kit=require(script.Parent.CrystalKit)
local Craft={}
local signatures={
    city_hall="civic", ekoh_tower="knowledge", library="archive", campus="orbit",
    justice_palace="balance", innovation_lab="mechanism", museum="art", orgo_center="network"
}
local function decor(parent,kind,name,size,frame,color,material,optional)
    local part=Kit.part(parent,kind,name,size,frame,color,material)
    if optional then part:SetAttribute("KinOptionalDetail",true) end
    return part
end
local function cabinet(parent,base,label,accent,signature,seed,light)
    local m=Instance.new("Model");m.Name=label;m.Parent=parent
    m:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
    local xSize=7.2
    decor(m,"Part","Socle en pierre",Vector3.new(xSize,0.7,2.3),base*CFrame.new(0,0.35,0),Kit.deep,Enum.Material.Slate,false)
    for _,side in ipairs({-1,1}) do
        decor(m,"Part","Pilastre sarcelle",Vector3.new(0.48,5.4,1.7),base*CFrame.new(side*3.15,3,0),Kit.primary,Enum.Material.Marble,false)
    end
    for layer=1,2 do
        decor(m,"Part","Tablette gravée",Vector3.new(6.7,0.24,1.9),base*CFrame.new(0,1.2+layer*1.5,0),Kit.gold,Enum.Material.Metal,false)
    end
    decor(m,"Part","Fronton minéral",Vector3.new(7.5,0.46,2.1),base*CFrame.new(0,6.1,0),Kit.medium,Enum.Material.Slate,false)
    local accentPiece=decor(m,"WedgePart","Gemme taillée",Vector3.new(2.0,2.3,1.3),
        base*CFrame.new(0,4.9,-0.25)*CFrame.Angles(0,math.rad((seed%3)*23),0),accent,Enum.Material.Slate,false)
    accentPiece:SetAttribute("KinInstitutionSignature",signature)
    -- Une texture de silhouettes propre à l'institution, par volumes simples.
    if signature=="archive" or signature=="knowledge" then
        for n=1,3 do
            decor(m,"Part","Volume d'archives",Vector3.new(0.75,1.25+0.15*(n%2),0.85),
                base*CFrame.new((n-2)*1.15,1.2+1.5+0.7,-0.5),
                if n%2==0 then Kit.gold else accent,Enum.Material.Slate,true)
        end
    elseif signature=="orbit" or signature=="network" then
        for n=1,3 do
            local a=(n-1)*math.pi*2/3
            local orb=decor(m,"Part","Nœud de savoir",Vector3.new(0.8,0.8,0.8),
                base*CFrame.new(math.cos(a)*2.2,2.0+math.sin(a)*0.7,-0.65),accent,Enum.Material.Neon,true)
            orb.Shape=Enum.PartType.Ball
        end
    elseif signature=="balance" or signature=="civic" then
        decor(m,"Part","Barre d'équilibre",Vector3.new(4.7,0.2,0.3),base*CFrame.new(0,3.6,-1.1),Kit.gold,Enum.Material.Metal,true)
    else
        for n=1,2 do
            local tile=decor(m,"WedgePart","Étude facettée",Vector3.new(1.1,1.4,1.0),
                base*CFrame.new((n-1.5)*3.7,2.1,-0.65)*CFrame.Angles(0,n*0.6,0),
                if n==1 then accent else Kit.gold,Enum.Material.Slate,true)
        end
    end
    if light then
        decor(m,"Part","Filet lumineux",Vector3.new(6.5,0.12,0.24),
            base*CFrame.new(0,6.45,-0.6),Kit.opal,Enum.Material.Neon,true)
    end
    return m
end
function Craft.decorate(roomFolder,placeKey,room,origin,roomIndex)
    local x,_,z=table.unpack(room.center_studs)
    local w,_,d=table.unpack(room.size_studs)
    if w<20 or d<20 then return end
    local signature=signatures[placeKey] or "civic"
    local root=Instance.new("Folder")
    root.Name="Ébénisterie cristalline v20"
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
    root.Parent=roomFolder
    local accent=Kit.accent(placeKey)
    -- Sur les deux côtés du mur arrière, loin du passage central de porte.
    -- Les meubles sont sans collision pour préserver la circulation au sein des pièces.
    local count=if Kit.profile=="LITE" then 1 else 2
    for n=1,count do
        local side=if n==1 then -1 else 1
        local bx=x+side*(w/2-5.7)
        local bz=z+d/2-3.4
        local base=CFrame.new(origin+Vector3.new(bx,0,bz))*CFrame.Angles(0,math.pi,0)
        cabinet(root,base,"Vitrine institutionnelle "..n,accent,signature,roomIndex+n,Kit.profile=="SHOWCASE" or roomIndex==1)
    end
    return root
end
return Craft
