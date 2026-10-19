--!strict
-- v19 : portiques monumentaux facetés et silhouettes institutionnelles.
-- Surfaces ornementales, sans collisions, sans requêtes ni lumières permanentes.
local Kit=require(script.Parent.CrystalKit)
local M={}
local signatures={
    city_hall={name="Cité",shape="civic",scale=1.0},
    ekoh_tower={name="Savoirs",shape="constellation",scale=1.13},
    library={name="Archives",shape="leaves",scale=1.05},
    campus={name="Campus",shape="orbit",scale=1.06},
    justice_palace={name="Équilibres",shape="balance",scale=1.00},
    innovation_lab={name="Inventions",shape="gear",scale=0.95},
    museum={name="Création",shape="prism",scale=1.10},
    orgo_center={name="Réseaux",shape="network",scale=1.00},
}
local function art(parent,name,size,frame,color,material,optional)
    local p=Kit.part(parent,"Part",name,size,frame,color,material)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    return p
end
local function bar(parent,name,from,to,thickness,color,optional)
    local delta=to-from
    if delta.Magnitude<0.05 then return nil end
    return art(parent,name,Vector3.new(thickness,thickness,delta.Magnitude),
        CFrame.lookAt((from+to)*0.5,to),color,Enum.Material.Metal,optional)
end
local function emblem(parent,frame,kind,color,radius)
    local r=radius
    if kind=="balance" then
        bar(parent,"Fléau",(frame*CFrame.new(-r,0,0)).Position,(frame*CFrame.new(r,0,0)).Position,0.38,Kit.gold,false)
        bar(parent,"Axe",(frame*CFrame.new(0,-r*0.65,0)).Position,(frame*CFrame.new(0,r*0.55,0)).Position,0.36,color,false)
        for _,s in ipairs({-1,1}) do
            bar(parent,"Chaîne",(frame*CFrame.new(s*r*0.75,0,0)).Position,(frame*CFrame.new(s*r*0.75,-r*0.55,0)).Position,0.20,Kit.gold,true)
            art(parent,"Plateau",Vector3.new(r*0.74,0.17,0.65),frame*CFrame.new(s*r*0.75,-r*0.55,0),color,Enum.Material.Slate,true)
        end
    elseif kind=="leaves" then
        bar(parent,"Tige",(frame*CFrame.new(0,-r,0)).Position,(frame*CFrame.new(0,r,0)).Position,0.28,Kit.gold,false)
        for i=1,4 do
            local y=-r+i*(2*r)/5
            local side=if i%2==0 then 1 else -1
            local leaf=art(parent,"Page-feuille",Vector3.new(r*0.64,r*0.33,0.22),
                frame*CFrame.new(side*r*0.31,y,0)*CFrame.Angles(0,0,side*0.38),color,Enum.Material.Slate,true)
            leaf:SetAttribute("KinDecorationRole","knowledge")
        end
    elseif kind=="network" or kind=="constellation" then
        local points={Vector3.new(-r,0,0),Vector3.new(-r*0.3,r*0.8,0),Vector3.new(r*0.7,r*0.55,0),Vector3.new(r,-r*0.65,0),Vector3.new(-r*0.45,-r*0.85,0)}
        for i=1,#points do
            local a=points[i]
            local b=points[i%#points+1]
            bar(parent,"Lien minéral",(frame*CFrame.new(a)).Position,(frame*CFrame.new(b)).Position,0.22,Kit.gold,true)
            local sphere=art(parent,"Nœud",Vector3.new(0.8,0.8,0.8),frame*CFrame.new(a),color,Enum.Material.Neon,true)
            sphere.Shape=Enum.PartType.Ball
        end
    elseif kind=="orbit" or kind=="gear" then
        local n=if kind=="gear" then 8 else 6
        for i=1,n do
            local a=(i-1)*math.pi*2/n
            local b=i*math.pi*2/n
            bar(parent,"Arc orbital",(frame*CFrame.new(math.cos(a)*r,math.sin(a)*r,0)).Position,
                (frame*CFrame.new(math.cos(b)*r,math.sin(b)*r,0)).Position,0.29,if i%2==0 then Kit.gold else color,true)
        end
        local core=art(parent,"Cœur orbital",Vector3.new(1.6,1.6,0.6),frame,color,Enum.Material.Neon,false)
        core.Shape=Enum.PartType.Ball
    elseif kind=="prism" then
        for i=1,3 do
            local angle=(i-1)*2.094
            bar(parent,"Composition prismatique",(frame*CFrame.new(math.sin(angle)*r,math.cos(angle)*r,0)).Position,
                (frame*CFrame.new(math.sin(angle+2.094)*r,math.cos(angle+2.094)*r,0)).Position,0.55,if i==1 then Kit.gold else color,false)
        end
    else
        for i=1,4 do
            local a=i*math.pi/2
            bar(parent,"Rayon civique",frame.Position,(frame*CFrame.new(math.cos(a)*r,math.sin(a)*r,0)).Position,0.36,if i%2==0 then color else Kit.gold,false)
        end
    end
end
function M.make(model,structure,building,_style)
    local cx,cy,cz=table.unpack(structure.center_studs)
    local width,depth=table.unpack(structure.footprint_studs)
    local height=structure.height_studs
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
    local front=-depth*0.5-2.5
    local variant=signatures[building.interior_place_key] or {name="Cité",shape="civic",scale=1}
    local accent=Kit.accent(building.interior_place_key)
    local root=Instance.new("Folder")
    root.Name="Portique de cristal — v19"
    root:SetAttribute("KinArtTheme","sarcelle-cristal-v19")
    root.Parent=model
    local reach=math.min(width*0.35,21)
    local top=math.min(19,height*0.65)
    local thick=1.35*variant.scale
    -- Deux supports externes : le passage et les prompts à x=0 restent entièrement libres.
    for _,side in ipairs({-1,1}) do
        local x=side*reach
        art(root,"Pilastre sculpté",Vector3.new(thick,top,thick),base*CFrame.new(x,top/2,front),Kit.primary,Enum.Material.Slate,false)
        art(root,"Incrustation opaline",Vector3.new(0.36,top*0.76,0.24),base*CFrame.new(x,top*0.53,front-0.8),accent,Enum.Material.Neon,true)
        Kit.spire(root,"Fleuron",base*CFrame.new(x,top+0.6,front),1.1,6.7,{accent=accent})
    end
    local left=(base*CFrame.new(-reach,top,front)).Position
    local right=(base*CFrame.new(reach,top,front)).Position
    local peak=(base*CFrame.new(0,top+math.min(6,height*0.13),front)).Position
    bar(root,"Chevron gauche",left,peak,thick*0.85,Kit.primary,false)
    bar(root,"Chevron droit",peak,right,thick*0.85,Kit.primary,false)
    bar(root,"Frise horizontale",left,right,0.6,Kit.gold,true)
    -- Héraldique différente pour chacun des 8 édifices; au-dessus de la porte.
    emblem(root,base*CFrame.new(0,top+1.4,front-0.45),variant.shape,accent,math.min(4,reach*0.27))
    root:SetAttribute("KinInstitutionKey",building.interior_place_key)
    return root
end
return M
