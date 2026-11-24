#!/usr/bin/env python3
"""Build idempotent, edit-only Roblox Studio Command Bar overlay from B08 JSON.

Never mutates KinCity core, doors, room parts, canonical UI, or PlaceIds.
"""
from pathlib import Path
import json
from math import isfinite
HERE=Path(__file__).resolve().parents[1]

def lua_literal(x):
    if x is None:return 'nil'
    if x is True:return 'true'
    if x is False:return 'false'
    if isinstance(x,(int,float)):
        if not isfinite(x):raise ValueError('nonfinite')
        return str(x)
    if isinstance(x,str):return json.dumps(x,ensure_ascii=False)
    if isinstance(x,(tuple,list)):return '{'+','.join(lua_literal(v) for v in x)+'}'
    if isinstance(x,dict):
        return '{'+','.join('['+lua_literal(k)+']='+lua_literal(v) for k,v in x.items())+'}'
    raise TypeError(type(x))

HEAD='''--!strict
-- B08 / MAISON ORGO -- VISUAL OVERLAY, TEST LOCAL UNIQUEMENT
-- Dans la Command Bar en mode EDIT, PlaceId 0, Play arrête.
-- Ne publie rien, ne modifie aucun contrat, aucune porte, aucune ancre.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"B08: mode EDIT Studio uniquement")
assert(game.PlaceId==0,"B08: seulement une copie locale PlaceId=0 ; staging/production interdits")
local scene=__SCENE__
local world=assert(workspace:FindFirstChild("KinCityGenerated"),"B08: KinCityGenerated absent")
assert(world:GetAttribute("KinBuildState")=="Ready","B08: monde non prêt")
assert(world:GetAttribute("KinRoutingMode")=="LOCAL_UNIVERSE","B08: installer local uniquement")
local inside=assert(world:FindFirstChild("Bâtiments visitables"),"B08: dossier des intérieurs absent")
local target=assert(inside:FindFirstChild("Intérieur — orgo_center"),"B08: intérieur Orgo absent")
assert(target:GetAttribute("KinPlaceKey")=="orgo_center","B08: mauvaise institution")
local origin=target:GetAttribute("KinInteriorOrigin")
assert(typeof(origin)=="Vector3","B08: attribut KinInteriorOrigin absent")
for _,room in ipairs(scene.rooms) do
    assert(target:FindFirstChild(room.id,true),"B08: salle manquante "..room.id)
end
for _,anchorId in ipairs({"orgo_center.lobby.spawn","orgo_center.exit.door","hall.terminal_01"}) do
    local found=false
    for _,part in ipairs(world:GetDescendants()) do
        if part:IsA("BasePart") and part:GetAttribute("KinPlaceKey")=="orgo_center" and part:GetAttribute("KinAnchorId")==anchorId then
            found=true;break
        end
    end
    assert(found,"B08: ancre manquante "..anchorId)
end
local profile=workspace:GetAttribute("KinB08Profile") or "STANDARD"
assert(scene.quality_profiles[profile]~=nil,"B08: profil qualité inconnu")
local old=target:FindFirstChild("B08_OrgoDecor_V1")
local model=Instance.new("Model")
model.Name="B08_OrgoDecor_V1__IN_PROGRESS"
model:SetAttribute("KinB08Owner","B08")
model:SetAttribute("KinB08PlaceKey",scene.place_key)
model:SetAttribute("KinB08Profile",profile)
model:SetAttribute("KinB08Contract",scene.contracts_version)
model.Parent=target
local stone=Color3.fromRGB(220,210,191)
local teal=Color3.fromRGB(30,104,100)
local bronze=Color3.fromRGB(189,148,90)
local ink=Color3.fromRGB(38,63,76)
local opal=Color3.fromRGB(231,238,233)
local function part(parent,name,worldPosition,size,color,material)
    local p=Instance.new("Part")
    p.Name=name
    p.Size=size
    p.CFrame=CFrame.new(worldPosition)
    p.Material=material or Enum.Material.SmoothPlastic
    p.Color=color
    p.Anchored=true
    p.CanCollide=false
    p.CanTouch=false
    p.CanQuery=false
    p.CastShadow=false
    p.Parent=parent
    return p
end
local function signage(parent,node,isSubtitle)
    local pos=origin+Vector3.new(node.position[1],node.position[2],node.position[3])
    local wide=if isSubtitle then 12 else 15
    local high=if isSubtitle then 1.35 else 2.9
    local slab=part(parent,node.id,pos,Vector3.new(wide,high,0.18),ink,Enum.Material.SmoothPlastic)
    slab:SetAttribute("KinB08DecorationId",node.id)
    part(parent,node.id..".top",pos+Vector3.new(0,high/2+0.13,0),Vector3.new(wide+0.45,0.13,0.25),bronze,Enum.Material.Metal)
    part(parent,node.id..".bottom",pos-Vector3.new(0,high/2+0.13,0),Vector3.new(wide+0.45,0.13,0.25),bronze,Enum.Material.Metal)
    local gui=Instance.new("BillboardGui")
    gui.Name="B08_Texte"
    gui.Size=UDim2.fromOffset(if isSubtitle then 580 else 720,if isSubtitle then 90 else 120)
    gui.MaxDistance=48
    gui.AlwaysOnTop=false
    gui.Adornee=slab
    gui.Parent=slab
    local label=Instance.new("TextLabel")
    label.Size=UDim2.fromScale(1,1)
    label.BackgroundTransparency=1
    label.Text=node.text
    label.TextColor3=if isSubtitle then opal else bronze
    label.Font=Enum.Font.GothamBold
    label.TextScaled=true
    label.TextStrokeTransparency=0.8
    label.Parent=gui
end
local function medallion(parent,node)
    local pos=origin+Vector3.new(node.position[1],node.position[2],node.position[3])
    local base=part(parent,node.id,pos,Vector3.new(8,0.10,8),teal,Enum.Material.Metal)
    base:SetAttribute("KinB08DecorationId",node.id)
    local thin=0.10
    for _,offset in ipairs({
        {4,0,0,0.2,8},{-4,0,0,0.2,8},{0,0,4,8,0.2},{0,0,-4,8,0.2}
    }) do
        part(parent,node.id..".border",pos+Vector3.new(offset[1],0.065,offset[3]),Vector3.new(offset[4],thin,offset[5]),bronze,Enum.Material.Metal)
    end
    part(parent,node.id..".axis",pos+Vector3.new(0,0.07,0),Vector3.new(2,0.11,2),opal,Enum.Material.Marble)
end
local function pilaster(parent,node)
    local pos=origin+Vector3.new(node.position[1],node.position[2],node.position[3])
    local frame=part(parent,node.id,pos,Vector3.new(0.22,8.6,0.42),bronze,Enum.Material.Metal)
    frame:SetAttribute("KinB08DecorationId",node.id)
    for _,y in ipairs({-3.8,-2.7,2.7,3.8}) do
        part(parent,node.id..".band",pos+Vector3.new(0,y,0),Vector3.new(0.31,0.12,0.65),opal,Enum.Material.Metal)
    end
end
local built=0
local ok,err=xpcall(function()
    for _,node in ipairs(scene.decorations) do
        if scene.quality_profiles[node.profile]<=scene.quality_profiles[profile] then
            if node.kind=="sign" then signage(model,node,false)
            elseif node.kind=="subtitle" then signage(model,node,true)
            elseif node.kind=="medallion" then medallion(model,node)
            elseif node.kind=="pilaster" then pilaster(model,node)
            else error("B08: élément inconnu "..tostring(node.kind)) end
            built+=1
        end
    end
end,debug.traceback)
if not ok then model:Destroy();error("B08 : génération échouée, ancienne version conservée : "..tostring(err)) end
if old then old:Destroy() end
model.Name="B08_OrgoDecor_V1"
model:SetAttribute("KinB08Decorations",built)
print("B08 Maison Orgo : "..built.." éléments décoratifs, profil "..profile..". AUCUN raccord runtime ni téléportation testé.")
'''

def generate(source=HERE/'scene_recipe.json',out=HERE/'studio/B08_STUDIO_PREVIEW_LOCAL.luau'):
    d=json.loads(Path(source).read_text(encoding='utf8'))
    if d['place_key']!='orgo_center':raise ValueError('wrong place')
    script=HEAD.replace('__SCENE__',lua_literal(d))
    if script.count('local scene=')!=1:raise ValueError('unexpected template')
    Path(out).parent.mkdir(parents=True,exist_ok=True)
    Path(out).write_text(script,encoding='utf8')
    return Path(out)

if __name__=='__main__':print(generate())
