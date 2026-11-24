-- KC35 : echantillonnage camera du sol; AUCUNE modification.
-- A lancer en edition, camera placee devant le triangle blanc.
local camera=workspace.CurrentCamera
assert(camera,"Camera absente")
local view=camera.ViewportSize
print("KC35 DIAGNOSTIC : camera",camera.CFrame.Position,"viewport",view)
local rayParams=RaycastParams.new()
rayParams.FilterType=Enum.RaycastFilterType.Exclude
rayParams.FilterDescendantsInstances={}
rayParams.IgnoreWater=true
for _,sample in ipairs({{.35,.58},{.5,.58},{.65,.58},{.35,.76},{.5,.76},{.65,.76}}) do
    local ray=camera:ViewportPointToRay(view.X*sample[1],view.Y*sample[2])
    local hit=workspace:Raycast(ray.Origin,ray.Direction*1800,rayParams)
    if hit then
        local obj=hit.Instance
        print(string.format("POINT %.2f/%.2f : %s | %s | Y=%.2f | couleur %s | texture %s | asset %s",
            sample[1],sample[2],obj:GetFullName(),obj.ClassName,hit.Position.Y,
            tostring(obj.Color),tostring(obj.Material),tostring(obj:GetAttribute("KinArtDecoAsset"))))
    else
        warn(string.format("POINT %.2f/%.2f : aucun objet detecte",sample[1],sample[2]))
    end
end
print("Fin diagnostic. Copier uniquement les six lignes POINT dans le chat.")
