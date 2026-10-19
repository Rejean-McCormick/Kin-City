--!strict
-- Couche volumétrique de façades : arches, cadres, balcons, bannières, toiture.
-- Géométrie locale, reproductible, sans asset externe.
local F=require(script.Parent.Factory)
local Detail={}
local pale=Color3.fromRGB(230,225,213)
local dark=Color3.fromRGB(18,62,60)
local function part(parent,name,base,offset,size,color,mat,solid)
    local p=F.part(parent,name,size,base*CFrame.new(offset),color,mat or Enum.Material.Metal)
    if solid==false then p.CanCollide=false;p.CastShadow=false end
    return p
end
function Detail.make(model,structure,building,style)
    local cx,cy,cz=table.unpack(structure.center_studs)
    local width,depth=table.unpack(structure.footprint_studs)
    local height=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local accent=F.hex(style.palette.accent)
    local trim=F.hex(style.palette.trim)
    local folder=F.folder(model,"Détails façades v4")
    -- Accès monumental en arcade : dégagement non bloquant devant la porte de téléportation.
    part(folder,"Auvent",base,Vector3.new(0,10,-depth/2-5.2),Vector3.new(20,0.85,9),trim,Enum.Material.Marble,false)
    for _,s in ipairs({-1,1}) do
        part(folder,"Pylône d'entrée",base,Vector3.new(s*9.2,5,-depth/2-6.5),Vector3.new(1.7,10,1.7),accent,Enum.Material.Marble,false)
        part(folder,"Ornement d'entrée",base,Vector3.new(s*9.2,10.6,-depth/2-6.5),Vector3.new(3.1,1.1,3.1),trim,Enum.Material.Metal,false)
        -- Étendard de quartier, sans collision.
        part(folder,"Hampe verticale",base,Vector3.new(s*12.4,15,-depth/2-0.8),Vector3.new(0.3,10,0.3),dark,Enum.Material.Metal,false)
        part(folder,"Bannière",base,Vector3.new(s*12.4,14.5,-depth/2-1.4),Vector3.new(3.2,6.6,0.15),accent,Enum.Material.Fabric,false)
        part(folder,"Pointe bannière",base,Vector3.new(s*12.4,10.7,-depth/2-1.4),Vector3.new(0.85,0.6,0.25),pale,Enum.Material.Metal,false)
    end
    local levels=math.max(1,math.min(5,math.floor(height/9)))
    local count=math.max(2,math.min(8,math.floor(width/12)))
    for floor=1,levels do
        local y=6+floor*6
        if y<height-4 then
            for n=1,count do
                local x=-width/2+n*width/(count+1)
                -- Encadrements, tableaux de fenêtre et garde-corps visuels.
                local z=-depth/2-0.47
                part(folder,"Linteau sculpté",base,Vector3.new(x,y+2.25,z),Vector3.new(5,0.45,0.55),trim,Enum.Material.Marble,false)
                part(folder,"Appui de fenêtre",base,Vector3.new(x,y-2.35,z),Vector3.new(5.2,0.48,0.8),trim,Enum.Material.Marble,false)
                part(folder,"Croisée verticale",base,Vector3.new(x,y,z-0.2),Vector3.new(0.17,4.3,0.25),dark,Enum.Material.Metal,false)
                part(folder,"Croisée horizontale",base,Vector3.new(x,y,z-0.2),Vector3.new(4.0,0.14,0.25),dark,Enum.Material.Metal,false)
                if floor%2==0 and n%2==0 then
                    part(folder,"Balcon décoratif",base,Vector3.new(x,y-2.7,z-1.1),Vector3.new(6.2,0.35,2.4),accent,Enum.Material.Metal,false)
                    part(folder,"Garde-corps balcon",base,Vector3.new(x,y-0.85,z-2.1),Vector3.new(6.2,2.4,0.25),dark,Enum.Material.Metal,false)
                end
            end
        end
    end
    -- Silhouette de toit : lucarnes et lanternon. Limiter les détails sur les petites façades.
    for n=-2,2 do
        local x=n*(width-13)/6
        part(folder,"Lucarne principale",base,Vector3.new(x,height+2,0),Vector3.new(5,4,5),trim,Enum.Material.Marble,false)
        part(folder,"Verrière de lucarne",base,Vector3.new(x,height+2,-2.7),Vector3.new(3.6,2.4,0.17),Color3.fromRGB(92,175,195),Enum.Material.Glass,false)
    end
    part(folder,"Lanternon de toiture",base,Vector3.new(0,height+4,0),Vector3.new(10,6,10),Color3.fromRGB(68,112,126),Enum.Material.Glass,false)
    part(folder,"Chapeau du lanternon",base,Vector3.new(0,height+7.2,0),Vector3.new(12,0.75,12),accent,Enum.Material.Metal,false)
    return folder
end
return Detail
