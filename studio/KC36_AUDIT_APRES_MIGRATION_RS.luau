-- KC36 : audit d'installation - lecture seulement, mode Edition.
local RunService=game:GetService("RunService")
assert(RunService:IsStudio() and not RunService:IsRunning(),"Arreter Play")
local Storage=game:GetService("ServerStorage")
local pkg=assert(Storage:FindFirstChild("KinCityArtDecoLibrary"))
assert(pkg:FindFirstChildOfClass("PackageLink"),"PackageLink perdu")
local count=0
for _,m in ipairs(pkg:GetChildren()) do
    if m:IsA("Model") and m.Name:match("^KC32__AD_") then count+=1 end
end
assert(count==121,"Pack : attendu 121 modèles")
local world=assert(workspace:FindFirstChild("KinCityGenerated"))
assert(world:GetAttribute("KinBuildState")=="Ready","Monde non prêt")
local city=assert(world:FindFirstChild("Ville"))
local facade=assert(city:FindFirstChild("Bâtiments"))
local ground=0
for _,model in ipairs(facade:GetChildren()) do
    if model:IsA("Model") then
        local floor=assert(model:FindFirstChild("Floor"),"Sans fondation : "..model.Name)
        assert(floor:IsA("Part") and floor:GetAttribute("KinGroundAuthority")=="institution-foundation",
            "Propriété du sol non assignée : "..model.Name)
        local top=floor.Position.Y+floor.Size.Y/2
        print("KC36 FONDATION :",model.Name,"Y haut :",top)
        assert(top>0.25,"Plancher encore au niveau du gazon : "..model.Name)
        ground+=1
    end
end
assert(ground==8,"Il faut huit fondations")
local e=assert(city:FindFirstChild("EkoH • halo transversal lumineux"))
local kiosks=assert(e:FindFirstChild("Bornes EkoH aux six axes"))
local supports=0
for _,k in ipairs(kiosks:GetChildren()) do
    local posts=0
    for _,x in ipairs(k:GetChildren()) do
        if x.Name=="Colonne latérale du portique" then posts+=1 end
        assert(x.Name~="Fil vertical du halo","Montant central EkoH réintroduit")
    end
    assert(posts==2,"Portique non aligné : "..k.Name)
    supports+=1
end
assert(supports==6,"Il faut six portiques")
local avenueRoot=assert(city:FindFirstChild("KOALI • urbanisme d'allées brandées"))
local roads=0
for _,root in ipairs(avenueRoot:GetChildren()) do
    if root.Name:sub(1,7)=="Avenue " then
        assert(root:GetAttribute("KinGroundAuthority")=="native-avenue-slabs",
            "Avenue sans autorité de surface : "..root.Name)
        roads+=1
    end
end
assert(roads==6,"Six avenues requises")
local b10=assert(city:FindFirstChild("KinB10Orientation"))
assert(b10:GetAttribute("KinB10AvenueMarkers")==0,"Doublons B10 dans les avenues")
assert(b10:GetAttribute("KinB10EntranceMarkers")==8,"Il faut huit repères d'accès")
local billboards=0
for _,v in ipairs(b10:GetDescendants()) do
    if v:IsA("BillboardGui") then billboards+=1 end
end
assert(billboards==0,"Billboard B10 détecté")
assert(world:GetAttribute("KinBranchReadyCount")==9,"B09 incomplet")
local hotfix=world:FindFirstChild("KC36Hotfixes")
assert(not hotfix,"Anciens hotfixes encore dans le monde")
print("========== KC36 ALIGNEMENT ========== ")
print("8 fondations / 6 avenues / 6 portiques EkoH / 8 panneaux physiques B10")
print("9 branches B09 / Package 121 lié / sans dalles temporaires")
print("PASS : audit statique Studio. Inspecter ensuite en Play")
