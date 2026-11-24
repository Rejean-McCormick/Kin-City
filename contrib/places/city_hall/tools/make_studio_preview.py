#!/usr/bin/env python3
"""Create a *local-copy-only* Roblox Studio Command Bar script for the B01 overlay.

Pre-flight guards happen before any scene modification. No commercial meshes.
"""
from pathlib import Path
ROOT=Path(__file__).resolve().parents[1]
OUT=ROOT/'preview/PREVIEW_B01_COPIE_LOCALE.luau'

def literal(s):
  for n in range(1,8):
    eq='='*n
    if f']{eq}]' not in s:
      return '['+eq+'['+s+']'+eq+']'
  raise ValueError('no safe Luau bracket literal')

def generate():
  scene=(ROOT/'CityHallScene.luau').read_text(encoding='utf8')
  spec=(ROOT/'CityHallSpec.luau').read_text(encoding='utf8')
  content='''-- KC34 B01: Studio COPIE LOCALE seulement. Ne modifie jamais la production.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(), "Arrêter Play dans Roblox Studio")
assert(game.PlaceId==0, "Utiliser une COPIE locale PlaceId=0, pas une Place publiée")
local found={}
for _,v in ipairs(workspace:GetDescendants()) do
  if v:IsA("Model") and v.Name=="Intérieur — city_hall" and v:GetAttribute("KinPlaceKey")=="city_hall" then
    table.insert(found,v)
  end
end
assert(#found==1, "Une et une seule copie de l'intérieur B01 doit exister")
local model=found[1]
assert(typeof(model:GetAttribute("KinInteriorOrigin"))=="Vector3", "Origine de l'intérieur non définie")
for _,id in ipairs({"city_hall.lobby","city_hall.gallery","city_hall.chamber","city_hall.west_wing","city_hall.east_wing","city_hall.rear_atrium"}) do
  assert(model:FindFirstChild(id), "Salle nécessaire manquante : "..id)
end
local holder=Instance.new("Folder")
holder.Name="B01_PREVIEW_TEMP"
holder.Parent=game:GetService("ServerScriptService")
local sceneModule=Instance.new("ModuleScript")
sceneModule.Name="CityHallScene"
sceneModule.Source=SCENE_SOURCE_PLACEHOLDER
sceneModule.Parent=holder
local specModule=Instance.new("ModuleScript")
specModule.Name="CityHallSpec"
specModule.Source=SPEC_SOURCE_PLACEHOLDER
specModule.Parent=holder
local ok,result=pcall(function()
  local constructor=require(sceneModule)
  return constructor.build({place_key="city_hall",contracts_version="KC34-DOC-1.0",profile="STANDARD",place_model=model})
end)
holder:Destroy()
if not ok then error("B01 NON INSTALLÉ : "..tostring(result)) end
print("B01 décoration locale installée : "..tostring(result.created).." pièces non-collidables. Les portes et le kiosque sont inchangés.")
'''
  content=content.replace('SCENE_SOURCE_PLACEHOLDER',literal(scene)).replace('SPEC_SOURCE_PLACEHOLDER',literal(spec))
  OUT.write_text(content,encoding='utf8')
  return OUT
if __name__=='__main__':print(generate())
