from pathlib import Path
base=Path(__file__).parent
source=(base/'Wayfinding.luau').read_text(encoding='utf8')
lines=source.splitlines()
if lines[0].strip()=='--!strict':source='\n'.join(lines[1:])
preview='''-- B10 / KC34. APERÇU LOCALE SEULEMENT — ne publie aucune Place.
-- Depuis Roblox Studio, Place locale PlaceId=0, Play arrêté, monde KC33 déjà construit.
-- Possibilité d'annulation : supprimer Ville/KinB10Orientation (décor uniquement).
local RunService=game:GetService("RunService")
assert(RunService:IsStudio(),"B10 : Studio obligatoire")
assert(not RunService:IsRunning(),"B10 : arrêter Play")
assert(game.PlaceId==0,"B10 : aperçu interdit dans une Place publiée")
local RS=game:GetService("ReplicatedStorage")
local shared=assert(RS:FindFirstChild("KinCityShared"),"B10 : modules KinCityShared manquants")
local world=assert(workspace:FindFirstChild("KinCityGenerated"),"B10 : génération KinCity absente")
assert(world:GetAttribute("KinBuildState")=="Ready","B10 : scène non prête")
assert(world:GetAttribute("KinRoutingMode")=="LOCAL_UNIVERSE", "B10 : preview uniquement LOCAL_UNIVERSE")
local city=assert(world:FindFirstChild("Ville"),"B10 : dossier Ville absent")
local plan=require(assert(shared:FindFirstChild("WorldPlan")))
local districts=require(assert(shared:FindFirstChild("HexagonalDistricts")))
local visual=require(assert(shared:FindFirstChild("VisualConfig")))
local B10=(function()
''' + source + '''
end)()
local folder,stats=B10.build(city,plan,districts,visual.profile)
print("B10 : orientation locale ajoutée",stats.avenue,"repères d'avenue",stats.entrances,"repères d'accès",stats.skipped,"emplacements écartés")
'''
(base/'preview/B10_APERCU_LOCAL_COMMAND_BAR.luau').write_text(preview,encoding='utf8')
print('WROTE',len(preview),'bytes')
