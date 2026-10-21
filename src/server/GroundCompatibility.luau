--!strict
-- Retire de la scène uniquement le socle plat de démarrage qui affleure l'île.
-- L'objet est conservé intact dans ServerStorage, sans effacer le Terrain utilisateur.
local Ground={}
function Ground.prepare()
    local base=workspace:FindFirstChild("Baseplate")
    if not base or not base:IsA("Part") or not base.Anchored then return end
    if base.Shape~=Enum.PartType.Block or base.Size.X<100 or base.Size.Z<100 then return end
    if base.CFrame.UpVector:Dot(Vector3.yAxis)<0.9999 then return end
    local top=base.Position.Y+base.Size.Y/2
    local localOrigin=base.CFrame:PointToObjectSpace(Vector3.zero)
    if math.abs(top)>0.3 or math.abs(localOrigin.X)>base.Size.X/2 or math.abs(localOrigin.Z)>base.Size.Z/2 then return end
    -- Ne pas déplacer un socle devenu un conteneur de scripts ou de construction.
    for _,child in ipairs(base:GetDescendants()) do
        if child:IsA("BasePart") or child:IsA("LuaSourceContainer") then return end
    end
    local storage=game:GetService("ServerStorage")
    local archive=storage:FindFirstChild("KinCityOriginalGround")
    if not archive then
        archive=Instance.new("Folder")
        archive.Name="KinCityOriginalGround"
        archive.Parent=storage
    end
    base.Parent=archive
    print("Kin City : Baseplate superposée au gazon mise de côté dans ServerStorage.KinCityOriginalGround.")
end
return Ground
