-- KC36 PRODUCTION : CORRECTION PERMANENTE DU BOOT ET DES PORTES
-- Command Bar Roblox Studio, Play arrete, sur la Place Kin City principale.
-- Aucun decalage de porte, aucune dalle, aucun asset supprime.
local RunService=game:GetService("RunService")
local SSS=game:GetService("ServerScriptService")
local SS=game:GetService("ServerStorage")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Arreter Play dans Roblox Studio")
local expectedPlace=72097868581669
assert(game.PlaceId==expectedPlace,"Ouvrir dans Studio la Place principale Kin City publiee (PlaceId 72097868581669)")
local rt=assert(SSS:FindFirstChild("KinCityRuntime"),"KinCityRuntime absent")
local pol=assert(rt:FindFirstChild("ArtDecoPolicy"),"ArtDecoPolicy absent")
local assets=assert(rt:FindFirstChild("ArtDecoAssets"),"ArtDecoAssets absent")
local data=assert(rt:FindFirstChild("ArtDecoData"),"ArtDecoData absent")
assert(pol:IsA("ModuleScript") and assets:IsA("ModuleScript") and data:IsA("ModuleScript"),"Modules Art Deco invalides")
local cfg=require(data).config
assert(cfg.enabled==true and cfg.production_place_id==expectedPlace,"Registre Art Deco production incorrect")
local library=assert(SS:FindFirstChild(cfg.library_name),"Bibliotheque centrale absente")
assert(library:FindFirstChildOfClass("PackageLink"),"PackageLink de la bibliotheque absent")
assert(library:GetAttribute("KinSourceCount")==121,"Bibliotheque centrale incomplete")
local count=0
for _,m in ipairs(library:GetChildren()) do
    if m:IsA("Model") and m.Name:match("^KC32__AD_") then count+=1 end
end
assert(count==121,"121 modeles source attendus, trouves : "..count)
local world=assert(workspace:FindFirstChild("KinCityGenerated"),"Ville KC36 absente")
assert(world:GetAttribute("KinBuildState")=="Ready","Monde KC36 non pret")
local revision="KC36-PRODUCTION-GATE-1"
if rt:GetAttribute("KC36ProductionGateRevision")==revision then
    print("KC36 PRODUCTION : deja installee ; aucun changement")
    return
end
assert(not SS:FindFirstChild("KC36ProductionGateBackup_v1"),"Backup precedent detecte : inspection necessaire")
local polOld,assOld=pol.Source,assets.Source
assert(polOld:find("function Policy.isTestTarget",1,true),"Politique d'origine inattendue")
assert(not polOld:find("function Policy.isRuntimeTarget",1,true),"La politique est deja modifiee : inspection necessaire")
local marker="function Policy.canSpend"
assert(select(2,polOld:gsub(marker,""))==1,"Ancre de politique ambigue")
local runtimeRule=[==[
-- Autorisation du runtime : production canonique OU test explicitement marque.
-- Ne jamais elargir isTestTarget : les installateurs de test restent interdits en production.
function Policy.isRuntimeTarget(placeId,marked,config)
    if type(config)~="table" or config.enabled~=true then return false end
    local published=config.production_place_id
    if type(published)=="number" and published>0 and placeId==published then
        return true
    end
    return Policy.isTestTarget(placeId,marked,config)
end
]==]
local polNew=polOld:gsub(marker,runtimeRule..marker)
local assNew,changed=assOld:gsub("Policy%.isTestTarget%(","Policy.isRuntimeTarget(")
assert(changed==2,"Deux gardes ArtDecoAssets attendues, trouvees : "..changed)
assNew=assNew:gsub("Art Deco : copie de test explicite requise ; production interdite",
    "Art Deco : Place non autorisee (production canonique ou test marque requis)")
local boundary="end\nlocal allowedClasses="
assert(assNew:find(boundary,1,true),"Ancre de validation du Package introuvable")
local prodCheck=[==[    if game.PlaceId==Data.config.production_place_id then
        local library=game:GetService("ServerStorage"):FindFirstChild(Data.config.library_name)
        assert(library and library:FindFirstChildOfClass("PackageLink")
            and library:GetAttribute("KinSourceCount")==121,
            "Art Deco production : Package central lie 121/121 requis")
    end
end
local allowedClasses=]==]
assNew=assNew:gsub("end\nlocal allowedClasses=",function() return prodCheck end,1)
-- Verifier la politique par un ModuleScript temporaire, avant toute ecriture.
local validator=Instance.new("ModuleScript")
validator.Name="KC36ProductionPolicyValidationTEMP"
validator.Source=polNew
validator.Parent=SS
local ok,reason=pcall(function()
    local policy=require(validator)
    assert(policy.isRuntimeTarget(expectedPlace,false,cfg)==true,"Production non autorisee")
    assert(policy.isTestTarget(expectedPlace,true,cfg)==false,"Test interdit en production")
    assert(policy.isRuntimeTarget(888888888,false,cfg)==false,"Place inconnue autorisee")
    assert(policy.isRuntimeTarget(0,true,cfg)==true,"Test local regresse")
    local disabled=table.clone(cfg);disabled.enabled=false
    assert(policy.isRuntimeTarget(expectedPlace,false,disabled)==false,"Profil desactive autorise")
end)
validator:Destroy()
assert(ok,"Prevalidation de la politique echouee : "..tostring(reason))
local backup=Instance.new("Folder")
backup.Name="KC36ProductionGateBackup_v1"
backup:SetAttribute("Revision",revision)
local a=Instance.new("StringValue");a.Name="ArtDecoPolicy_Original";a.Value=polOld;a.Parent=backup
local b=Instance.new("StringValue");b.Name="ArtDecoAssets_Original";b.Value=assOld;b.Parent=backup
backup.Parent=SS
local saved,err=pcall(function()
    pol.Source=polNew
    assets.Source=assNew
    rt:SetAttribute("KC36ProductionGateRevision",revision)
end)
if not saved then
    pcall(function() pol.Source=polOld;assets.Source=assOld end)
    rt:SetAttribute("KC36ProductionGateRevision",nil)
    error("KC36 : correction annulee : "..tostring(err))
end
print("========== KC36 PRODUCTION ==========")
print("Place autorisee :",expectedPlace)
print("Bibliotheque Art Deco : 121/121 ; PackageLink valide")
print("Politique test : toujours strictement interdite en production")
print("Deux gardes runtime reorientees vers production autorisee")
print("Sauvegarde des sources : ServerStorage.KC36ProductionGateBackup_v1")
print("PASS KC36 PRODUCTION GATE")
print("Ctrl+S, Play, puis lire Output : KIN CITY WORLD_STUB pret ...")
