#!/usr/bin/env python3
"""Build a deterministic, standalone Luau module for B06; no live Roblox mutations.

Output KonstructScene.luau is intended for later B09 runtime integration. The
source of truth for room decorations is room_layout.json. No imports of paid
assets, no file outside the innovation_lab contribution directory is changed.
"""
from __future__ import annotations
import json
from pathlib import Path
ROOT=Path(__file__).resolve().parent

def lua(x):
    if x is None:return 'nil'
    if isinstance(x,bool):return 'true' if x else 'false'
    if isinstance(x,(int,float)):return str(x)
    if isinstance(x,str):return json.dumps(x,ensure_ascii=False)
    if isinstance(x,list):return '{'+','.join(lua(v) for v in x)+'}'
    if isinstance(x,dict):return '{'+','.join(f'[{lua(k)}]={lua(v)}' for k,v in sorted(x.items()))+'}'
    raise TypeError(type(x))

HEADER='''--!strict
-- B06 Atelier Konstruct: deterministic decorative overlay.
-- Not wired into WorldBuilder. Call build(context) only from a B09-approved adapter.
-- All parts are visual only (CanCollide/CanTouch/CanQuery = false).
-- No PlaceIds, canonical anchors, doors or external KOALI calls are mutated.
local Konstruct={}
local PLACE_KEY="innovation_lab"
local ACCENT=Color3.fromRGB(208,191,134)
local TEAL=Color3.fromRGB(30,104,100)
local BRONZE=Color3.fromRGB(167,126,71)
local DARK=Color3.fromRGB(30,38,45)
local TIERS={LITE=1,STANDARD=2,SHOWCASE=3}
'''
BODY='''
local function visualPart(owner,name,size,frame,color,material)
    local obj=Instance.new("Part")
    obj.Name=name
    obj.Size=size
    obj.CFrame=frame
    obj.Color=color
    obj.Material=material or Enum.Material.SmoothPlastic
    obj.Anchored=true
    obj.CanCollide=false
    obj.CanTouch=false
    obj.CanQuery=false
    obj.CastShadow=false
    obj:SetAttribute("KinOptionalDetail",true)
    obj:SetAttribute("KinPlaceKey",PLACE_KEY)
    obj.Parent=owner
    return obj
end
local function signage(panel,title)
    local gui=Instance.new("SurfaceGui")
    gui.Name="Konstruct_Signalétique"
    gui.Face=Enum.NormalId.Front
    gui.PixelsPerStud=32
    gui.AlwaysOnTop=false
    gui.LightInfluence=0.2
    local line=Instance.new("TextLabel")
    line.Size=UDim2.fromScale(1,1)
    line.BackgroundTransparency=1
    line.Text=title
    line.TextColor3=ACCENT
    line.TextScaled=true
    line.TextWrapped=true
    line.Font=Enum.Font.GothamBold
    line.Parent=gui
    gui.Parent=panel
end

function Konstruct.plan(profile: string)
    assert(TIERS[profile]~=nil,"Profil visuel B06 inconnu")
    local chosen={}
    for _,detail in ipairs(DETAILS) do
        if TIERS[detail.tier]<=TIERS[profile] then
            table.insert(chosen,detail)
        end
    end
    return chosen
end

-- context = {parent=Instance, origin=Vector3, placeKey="innovation_lab", profile="LITE|STANDARD|SHOWCASE"}
-- May be called repeatedly: an existing matching overlay is preserved, never destroyed.
function Konstruct.build(context: any)
    assert(context~=nil and context.parent~=nil,"B06: parent requis")
    assert(context.placeKey==PLACE_KEY,"B06: autre Place interdite")
    local profile=context.profile or "LITE"
    assert(TIERS[profile]~=nil,"B06: profil inconnu")
    local origin=context.origin or Vector3.zero
    local desired=Konstruct.plan(profile)
    local existing=context.parent:FindFirstChild("KinB06_Konstruct_Overlay")
    if existing then
        assert(existing:GetAttribute("KinB06Revision")=="B06-0.1.0" and existing:GetAttribute("KinB06Profile")==profile,
            "B06: overlay existant incompatible; rollback manuel requis")
        return {created=0,reused=true,decorations=#desired,profile=profile}
    end
    local model=Instance.new("Model")
    model.Name="KinB06_Konstruct_Overlay"
    model:SetAttribute("KinPlaceKey",PLACE_KEY)
    model:SetAttribute("KinB06Revision","B06-0.1.0")
    model:SetAttribute("KinB06Profile",profile)
    local created=0
    for _,detail in ipairs(desired) do
        local v=detail.position_studs
        local pos=origin+Vector3.new(v[1],v[2],v[3])
        local frame=CFrame.new(pos)
        local width=detail.width_studs
        if detail.style=="wall_ribbon" then
            visualPart(model,detail.id.."_filet",Vector3.new(width,0.55,0.14),frame,ACCENT,Enum.Material.Metal)
            visualPart(model,detail.id.."_coeur",Vector3.new(width*0.66,0.14,0.18),frame*CFrame.new(0,-0.54,0),TEAL,Enum.Material.Metal)
            created+=2
        elseif detail.style=="hanging_cartouche" then
            local panel=visualPart(model,detail.id.."_cartouche",Vector3.new(width,2.1,0.18),frame,DARK,Enum.Material.SmoothPlastic)
            signage(panel,ROOM_LABELS[detail.room_id] or "KONSTRUCT")
            visualPart(model,detail.id.."_rail_haut",Vector3.new(width+0.5,0.17,0.2),frame*CFrame.new(0,1.17,0),BRONZE,Enum.Material.Metal)
            visualPart(model,detail.id.."_rail_bas",Vector3.new(width+0.5,0.17,0.2),frame*CFrame.new(0,-1.17,0),BRONZE,Enum.Material.Metal)
            created+=3
        elseif detail.style=="diamond_star" then
            visualPart(model,detail.id.."_losange",Vector3.new(width, width, 0.16),
                frame*CFrame.Angles(0,0,math.rad(45)),DARK,Enum.Material.SmoothPlastic)
            visualPart(model,detail.id.."_rayon_h",Vector3.new(width*1.4,0.16,0.22),frame,ACCENT,Enum.Material.Metal)
            visualPart(model,detail.id.."_rayon_v",Vector3.new(0.16,width*1.4,0.22),frame,TEAL,Enum.Material.Metal)
            created+=3
        else
            error("B06: style inconnu")
        end
    end
    assert(created<=PART_CAPS[profile],"B06: budget de parts dépassé")
    -- Mount only after all validation. Incomplete local Model is never left in Workspace.
    model:SetAttribute("KinB06Parts",created)
    model.Parent=context.parent
    return {created=created,reused=false,decorations=#desired,profile=profile}
end
return Konstruct
'''

def render():
    d=json.loads((ROOT/'room_layout.json').read_text(encoding='utf8'))
    assert d['place_key']=='innovation_lab'
    labels={x['room_id']:x['label'] for x in d['rooms']}
    caps={key:value['max_parts'] for key,value in d['profiles'].items()}
    data='local ROOM_LABELS='+lua(labels)+'\n'+'local PART_CAPS='+lua(caps)+'\n'+'local DETAILS='+lua(d['details'])+'\n'
    text=HEADER+data+BODY
    (ROOT/'KonstructScene.luau').write_text(text,encoding='utf8')
    return text
if __name__=='__main__':
    print('KonstructScene.luau:',len(render().splitlines()),'lines')
