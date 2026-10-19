--!strict
-- Pièces cristallines PROCÉDURALES : aucun mesh, aucune API externe.
-- Ornements sans collision ni requête physique; une seule facette Glass sur certains héros.
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Theme=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("CrystalTheme"))
local F=require(script.Parent.Factory)
local Visual=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("VisualConfig"))
local Kit={}
local B=Theme.brand
Kit.profile=Visual.profile
Kit.settings=Visual.settings
Kit.deep=F.hex(B.deep)
Kit.primary=F.hex(B.primary)
Kit.medium=F.hex(B.medium)
Kit.stone=F.hex(B.stone)
Kit.opal=F.hex(B.opal)
Kit.pearl=F.hex(B.pearl)
Kit.gold=F.hex(B.champagne)
function Kit.accent(placeKey)
    return F.hex(Theme.institution_accents[placeKey] or B.opal)
end
local function ornament(parent,kind,name,size,frame,color,material,transparency)
    local object=Instance.new(kind)
    object.Name=name
    object.Size=size
    object.CFrame=frame
    object.Color=color
    object.Material=material or Enum.Material.Slate
    object.Anchored=true
    object.CanCollide=false
    object.CanTouch=false
    object.CanQuery=false
    object.CastShadow=false
    object.Transparency=transparency or 0
    object.Parent=parent
    object:SetAttribute("KinArtTheme","sarcelle-cristal-v17")
    return object
end
Kit.part=ornament

function Kit.spire(parent,label,base,radius,height,variant)
    -- Base = CFrame au PIED de la sculpture. Géométrie de 6 à 7 primitives max.
    local m=Instance.new("Model")
    m.Name=label
    m:SetAttribute("KinArtTheme","sarcelle-cristal-v17")
    m.Parent=parent
    local hue=variant and variant.accent or Kit.opal
    local metallic=variant and variant.metal or Kit.primary
    local stemH=height*0.66
    local p=ornament(m,"Part","Prisme minéral",Vector3.new(radius*1.5,stemH,radius*1.5),base*CFrame.new(0,stemH/2,0),metallic,Enum.Material.Slate)
    p.CFrame=p.CFrame*CFrame.Angles(0,math.rad(45),0)
    local peakH=height-stemH
    local step=if Visual.settings.facets_per_spire==2 then 2 else 1
    for side=0,3,step do
        local angle=side*math.pi/2
        local face=ornament(m,"WedgePart","Facette taillée",Vector3.new(radius*1.6,peakH,radius*1.16),
            base*CFrame.new(math.sin(angle)*radius*0.28,stemH+peakH/2,math.cos(angle)*radius*0.28)*CFrame.Angles(0,angle,0),
            if side%2==0 then hue else Kit.stone,Enum.Material.Slate)
    end
    local lightCore=ornament(m,"Part","Veine lumineuse",Vector3.new(radius*0.26,stemH*0.88,radius*0.26),base*CFrame.new(0,stemH*0.53,0),Kit.opal,Enum.Material.Neon)
    if variant and variant.hero and Visual.settings.glass_hero then
        -- Le seul vitrage superposé du cristal; jamais de centaines de panneaux transparents.
        local glass=ornament(m,"Part","Éclat translucide",Vector3.new(radius*0.9,peakH*0.5,radius*0.16),
            base*CFrame.new(0,stemH+peakH*0.47,radius*0.37),hue,Enum.Material.Glass,0.26)
        glass.Reflectance=0.04
    end
    return m
end

function Kit.band(parent,name,base,width,y,z,color)
    return ornament(parent,"Part",name,Vector3.new(width,0.48,0.57),base*CFrame.new(0,y,z),color or Kit.primary,Enum.Material.Metal)
end
function Kit.pedestal(parent,name,base,width,height,color)
    local shape=ornament(parent,"Part",name,Vector3.new(width,height,width),base*CFrame.new(0,height/2,0),color or Kit.primary,Enum.Material.Slate)
    local edge=ornament(parent,"Part",name.." / dalle",Vector3.new(width+0.7,0.28,width+0.7),base*CFrame.new(0,height,0),Kit.gold,Enum.Material.Metal)
    return shape
end
function Kit.rosette(parent,name,frame,radius,accent,beams)
    local folder=Instance.new("Folder")
    folder.Name=name;folder.Parent=parent
    local count=if Visual.profile=="LITE" then math.min(beams or 8,4) else (beams or 8)
    local core=ornament(folder,"Part","Noyau opalin",Vector3.new(1.7,1.7,0.32),frame,Kit.opal,Enum.Material.Neon)
    core.Shape=Enum.PartType.Ball
    for k=1,count do
        local a=k*math.pi*2/count
        local beam=ornament(folder,"Part","Rayon cristallin",Vector3.new(0.35,radius*0.74,0.3),
            frame*CFrame.new(math.sin(a)*radius*0.42,math.cos(a)*radius*0.42,0)*CFrame.Angles(0,0,-a),
            if k%2==0 then accent or Kit.primary else Kit.gold,Enum.Material.Metal)
        beam:SetAttribute("KinOptionalDetail",true)
    end
    return folder
end
function Kit.mosaic(parent,base,radius)
    local m=Instance.new("Folder");m.Name="Mandala de pierre et cristal";m.Parent=parent
    local rays=Visual.settings.mandala_rays
    for n=1,rays do
        local a=n*2*math.pi/rays
        local inlay=ornament(m,"Part","Incrustation radiale",Vector3.new(0.33,0.08,radius*0.82),
            base*CFrame.Angles(0,a,0)*CFrame.new(0,0.08,-radius*0.33),
            if n%2==0 then Kit.primary else Kit.gold,Enum.Material.Metal)
        inlay:SetAttribute("KinOptionalDetail",true)
    end
    ornament(m,"Part","Noyau en pierre",Vector3.new(1.8,0.12,1.8),base*CFrame.new(0,0.11,0),Kit.primary,Enum.Material.Slate)
    return m
end
function Kit.heroGlow(parent,position)
    local anchor=ornament(parent,"Part","Cœur éclairant",Vector3.new(0.8,0.8,0.8),CFrame.new(position),Kit.opal,Enum.Material.Neon)
    local light=Instance.new("PointLight")
    light.Name="Éclat local"
    light.Brightness=if Visual.profile=="LITE" then 0 else 0.65
    light.Range=18
    light.Shadows=false
    light.Parent=anchor
    return anchor
end
return Kit
