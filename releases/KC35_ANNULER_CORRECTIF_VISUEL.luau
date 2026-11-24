-- KC35 VISUAL FIX : retour arriere, edit seulement.
local RunService=game:GetService("RunService")
local SS=game:GetService("ServerStorage")
local SSS=game:GetService("ServerScriptService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Arreter Play")
assert(game.PlaceId==0,"Place locale seulement")
local backup=assert(SS:FindFirstChild("KinCityVisualFixBackup_v1"),"Aucun correctif a annuler")
local runtime=assert(SSS:FindFirstChild("KinCityRuntime"),"Runtime absent")
for _,name in ipairs({"BranchRuntime","KoaliUrbanism"}) do
    local save=assert(backup:FindFirstChild("Original_"..name),"Sauvegarde source absente: "..name)
    local module=assert(runtime:FindFirstChild(name),"Module manquant: "..name)
    module.Source=save.Value
end
local world=assert(workspace:FindFirstChild("KinCityGenerated"),"Monde absent")
local city=assert(world:FindFirstChild("Ville"),"Ville absente")
for _,obj in ipairs(city:GetDescendants()) do
    if obj:IsA("BasePart") then
        local old=obj:GetAttribute("KinKC35OriginalTransparency")
        if old~=nil then
            obj.Transparency=old
            obj:SetAttribute("KinKC35OriginalTransparency",nil)
        end
    elseif obj:IsA("Model") and obj:GetAttribute("KinKC35PavingHidden") then
        obj:SetAttribute("KinKC35PavingHidden",nil)
    end
end
local previous=backup:FindFirstChild("Original_KinB10Orientation")
local current=city:FindFirstChild("KinB10Orientation")
if current then current:Destroy() end
if previous then previous.Name="KinB10Orientation";previous.Parent=city end
backup:Destroy()
print("KC35 VISUEL : correctif annule. Ctrl+S; Play pour valider.")
