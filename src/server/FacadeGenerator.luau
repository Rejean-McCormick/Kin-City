--!strict
local Factory = require(script.Parent.Factory)
local ArchitecturePlus = require(script.Parent.ArchitecturePlus)
local FacadeDetail = require(script.Parent.FacadeDetail)
local HeritageFacadesV16 = require(script.Parent.HeritageFacadesV16)
local CrystalFacades = require(script.Parent.CrystalFacades)
local CrystalPorticosV19 = require(script.Parent.CrystalPorticosV19)
local SkylineV22=require(script.Parent.InstitutionSkylineV22)
local FacadeKitV24=require(script.Parent.InstitutionFacadeKitV24)
local FacadeGenerator = {}

local function element(parent, name, size, frame, offset, color, material)
    return Factory.part(parent,name,size,frame*CFrame.new(offset),color,material)
end

function FacadeGenerator.make(parent, structure, building, style)
    local model=Instance.new("Model")
    model.Name=building.name
    model:SetAttribute("KinBuildingId",building.building_id)
    model.Parent=parent
    local cx,cy,cz=table.unpack(structure.center_studs)
    local w,d=table.unpack(structure.footprint_studs)
    local h=structure.height_studs
    local yaw=structure.yaw_degrees
    local base=CFrame.new(cx,cy,cz)*CFrame.Angles(0,math.rad(yaw),0)
    local walls=Factory.hex(style.palette.wall)
    local trim=Factory.hex(style.palette.trim)
    local accent=Factory.hex(style.palette.accent)
    local glazing=Color3.fromRGB(197,244,240)
    local function mineralPane(name,size,offset)
        local pane=element(model,name,size,base,offset,glazing,Enum.Material.SmoothPlastic)
        pane.CanCollide=false;pane.CanTouch=false;pane.CanQuery=false;pane.CastShadow=false
        pane.Reflectance=0.09
        pane:SetAttribute("KinArtTheme","sarcelle-cristal-v20")
        return pane
    end
    element(model,"BuildingCore",Vector3.new(w,h,d),base,Vector3.new(0,h/2,0),walls,Enum.Material.Concrete)
    element(model,"BasePlinth",Vector3.new(w+3,1,d+3),base,Vector3.new(0,0.5,0),trim,Enum.Material.Slate)
    element(model,"Cornice",Vector3.new(w+3,1.5,d+3),base,Vector3.new(0,h-1,0),trim,Enum.Material.Concrete)
    element(model,"Roof",Vector3.new(w+2,1,d+2),base,Vector3.new(0,h,0),accent,Enum.Material.Metal)
    -- Fenêtres par bandes et corniches, contrôlées par la hauteur réelle.
    local levels = math.max(1,math.floor((h-8)/8))
    local count=math.max(2,math.floor((w-12)/9))
    for level=1,levels do
        local y=5+level*6
        if y<h-3 then
            for col=1,count do
                local x=-w/2 + col*w/(count+1)
                mineralPane("WindowFront",Vector3.new(3.6,3.8,0.25),Vector3.new(x,y,-d/2-0.17))
                mineralPane("WindowBack",Vector3.new(3.6,3.8,0.25),Vector3.new(x,y,d/2+0.17))
            end
        end
    end
    for i=1,math.max(2, math.floor((d-10)/11)) do
        local z=-d/2 + i*d/(math.max(2,math.floor((d-10)/11))+1)
        mineralPane("SideWindowL",Vector3.new(0.22,4.3,3.5),Vector3.new(-w/2-0.13,h*0.49,z))
        mineralPane("SideWindowR",Vector3.new(0.22,4.3,3.5),Vector3.new(w/2+0.13,h*0.49,z))
    end
    -- Façade d'entrée bien visible (ne prétend pas avoir une ouverture géométrique : transition au prompt).
    element(model,"MainEntrance",Vector3.new(9,8,0.75),base,Vector3.new(0,4,-d/2-0.6),Color3.fromRGB(45,60,65),Enum.Material.Metal)
    for side=-1,1,2 do
        element(model,"EntranceColumn",Vector3.new(1.4,10,1.4),base,Vector3.new(side*6.5,5,-d/2-1.2),trim,Enum.Material.Marble)
    end
    Factory.sign(model,"BuildingSign",(base*CFrame.new(0,math.min(h-3,13),-d/2-1.25)).Position,yaw,building.name,math.min(w-12,40),3.3)
    if style.roof=="spire" then
        element(model,"Spire",Vector3.new(3,math.min(15,h*0.32),3),base,Vector3.new(0,h+math.min(15,h*0.32)/2,0),accent,Enum.Material.Metal)
    elseif style.roof=="gable" then
        element(model,"RoofRidge",Vector3.new(w+2,2.5,4),base,Vector3.new(0,h+1,0),accent,Enum.Material.Slate)
    end
    ArchitecturePlus.decorate(model,structure,building,style)
    FacadeDetail.make(model,structure,building,style)
    HeritageFacadesV16.make(model,structure,building,style)
    CrystalFacades.make(model,structure,building,style)
    CrystalPorticosV19.make(model,structure,building,style)
    SkylineV22.make(model,structure,building)
    FacadeKitV24.make(model,structure,building)
    return model
end

return FacadeGenerator
