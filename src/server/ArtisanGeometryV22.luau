--!strict
-- Kin City : grammaire de scènes sculptées. Déjà placés, tous les détails sont natifs Roblox.
-- Ces objets sont VISUELS, sans collisions, ni logique métier, ni boucle serveur.
local Kit=require(script.Parent.CrystalKit)
local Studio={}
local function color(kind)
    if kind=="opal" then return Kit.opal end
    if kind=="gold" then return Kit.gold end
    if kind=="deep" then return Kit.deep end
    if kind=="medium" then return Kit.medium end
    return Kit.primary
end
function Studio.part(parent,name,size,frame,pigment,material,optional)
    local p=Kit.part(parent,"Part",name,size,frame,color(pigment),material or Enum.Material.Slate)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    p:SetAttribute("KinDecorV22",true)
    return p
end
function Studio.wedge(parent,name,size,frame,pigment,optional)
    local p=Kit.part(parent,"WedgePart",name,size,frame,color(pigment),Enum.Material.Slate)
    if optional then p:SetAttribute("KinOptionalDetail",true) end
    p:SetAttribute("KinDecorV22",true)
    return p
end
function Studio.orb(parent,name,diameter,frame,pigment,optional)
    local p=Studio.part(parent,name,Vector3.new(diameter,diameter,diameter),frame,pigment,Enum.Material.Slate,optional)
    p.Shape=Enum.PartType.Ball
    return p
end
function Studio.beam(parent,name,from,to,thickness,pigment,optional)
    local dir=to-from
    if dir.Magnitude<0.1 then return nil end
    return Studio.part(parent,name,Vector3.new(thickness,thickness,dir.Magnitude),
        CFrame.lookAt((from+to)*0.5,to),pigment,Enum.Material.Metal,optional)
end
function Studio.facet(parent,name,base,radius,height,pigment,optional)
    local h=math.max(0.4,height)
    Studio.part(parent,name.." / cœur",Vector3.new(radius*0.9,h*0.68,radius*0.9),
        base*CFrame.new(0,h*0.34,0),pigment,Enum.Material.Slate,optional)
    local faces=if Kit.profile=="LITE" then 2 else 4
    for k=1,faces do
        local a=2*math.pi*k/faces
        Studio.wedge(parent,name.." / facette",Vector3.new(radius*1.2,h*0.32,radius*0.8),
            base*CFrame.new(math.sin(a)*radius*0.17,h*0.85,math.cos(a)*radius*0.17)*CFrame.Angles(0,a,0),
            if k%2==0 then "opal" else pigment,optional)
    end
end
function Studio.motif(parent,frame,signature,accent,scale)
    -- Lecture claire à distance : au maximum 12 volumes par motif.
    local s=scale or 1
    Studio.orb(parent,"Cœur",1.8*s,frame*CFrame.new(0,0,0),"opal",false)
    if signature=="archive" or signature=="knowledge" then
        for k=-2,2 do
            Studio.part(parent,"Volume gravé",Vector3.new(0.75*s,(2.2+0.2*math.abs(k))*s,0.65*s),
                frame*CFrame.new(k*1.05*s,-0.85*s,0),if k%2==0 then "gold" else accent,
                Enum.Material.Slate,k%2~=0)
        end
    elseif signature=="orbit" then
        for k=1,8 do
            local a=2*math.pi*k/8
            Studio.orb(parent,"Corps céleste",(if k%2==0 then 0.62 else 0.4)*s,
                frame*CFrame.new(math.sin(a)*3*s,math.cos(a)*1.45*s,0),accent,true)
        end
    elseif signature=="balance" then
        Studio.beam(parent,"Traverse",(frame*CFrame.new(-3*s,1.5*s,0)).Position,
            (frame*CFrame.new(3*s,1.5*s,0)).Position,0.24*s,"gold",false)
        for _,side in ipairs({-1,1}) do
            Studio.beam(parent,"Suspente",(frame*CFrame.new(side*2.3*s,1.4*s,0)).Position,
                (frame*CFrame.new(side*2.3*s,-1.4*s,0)).Position,0.12*s,accent,true)
            Studio.part(parent,"Plateau",Vector3.new(2.2*s,0.18*s,1.3*s),
                frame*CFrame.new(side*2.3*s,-1.5*s,0),"opal",Enum.Material.Metal,true)
        end
    elseif signature=="mechanism" then
        for k=1,8 do
            local a=2*math.pi*k/8
            Studio.wedge(parent,"Aube",Vector3.new(1.1*s,2.3*s,0.34*s),
                frame*CFrame.new(math.sin(a)*2.0*s,math.cos(a)*2.0*s,0)*CFrame.Angles(0,0,-a),
                if k%2==0 then accent else "gold",true)
        end
    elseif signature=="art" then
        for k=1,5 do
            Studio.wedge(parent,"Forme",Vector3.new(1.2*s,(1.2+k*0.35)*s,0.72*s),
                frame*CFrame.new((k-3)*1.4*s,((k%3)-1)*0.6*s,0)*CFrame.Angles(0,k*0.4,k*0.13),
                if k%2==0 then accent else "gold",true)
        end
    elseif signature=="network" then
        for k=1,6 do
            local a=2*math.pi*k/6
            local tip=(frame*CFrame.new(math.sin(a)*3*s,math.cos(a)*1.7*s,0)).Position
            Studio.beam(parent,"Lien",frame.Position,tip,0.16*s,"gold",true)
            Studio.orb(parent,"Nœud",0.55*s,CFrame.new(tip),accent,true)
        end
    else -- civic
        for k=-2,2 do
            Studio.part(parent,"Bâtiment miniature",Vector3.new(0.85*s,(1.2+0.4*(k%3))*s,0.78*s),
                frame*CFrame.new(k*1.3*s,-0.7*s,0),if k%2==0 then accent else "gold",Enum.Material.Slate,true)
        end
    end
end
return Studio
