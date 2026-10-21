--!strict
-- Navigation des PNJ : parcours de quartier, obstacles réellement traversables et
-- refus de déplacer un PNJ si aucun trajet sûr n'est trouvé (sans téléportation).
-- Les mêmes six quartiers servent aux 36 citoyens, 14 R15 et 12 résidents.
local RS=game:GetService("ReplicatedStorage")
local PathfindingService=game:GetService("PathfindingService")
local Groups=require(RS:WaitForChild("KinCityShared"):WaitForChild("ResidentialDestinations"))
local Nav={}
-- Coordonnées locales alignées sur ResidentialQuarters : le kiosque occupe
-- [-8.5,8.5]^2 ; les quatre maisons sont centrées à (+/-29,+/-29).
-- Les haltes restent sur les allées entre kiosque, jardins et façades.
local STOPS={
    {0,-27,"Entrée de quartier"}, {0,-55,"Promenade du boulevard"},
    {0,-79,"Perspective de la ville"}, {0,-55,"Promenade du boulevard"},
    {0,-27,"Accueil"}, {10,-23,"Allée des voisins"},
    {23,-10,"Place publique"}, {27,0,"Atelier de quartier"},
    {23,10,"Allée plantée"}, {10,23,"Promenade calme"},
    {0,27,"Terrasse commune"}, {-10,23,"Balade du jardin"},
    {-23,10,"Maison des voisins"}, {-27,0,"Place publique"},
    {-23,-10,"Allée de quartier"}, {-10,-23,"Rencontre"},
}
-- Alternance de visites courtes, demi-tours et petites sorties sur le boulevard.
-- Aucune boucle orbitale ou déplacement aléatoire sans contrôle d'obstacles.
local ROUTES={
    {1,6,7,8,9,10,11,12,13,14,15,16},
    {11,10,9,8,7,6,1,2,3,4,5,16,15},
    {1,2,3,4,5,16,15,14,13,12,11},
    {7,8,9,10,11,12,13,14,15,16,1,6},
    {11,12,13,14,15,16,1,2,4,5,6,7},
    {1,16,15,14,13,12,11,10,9,8,7,6},
}
function Nav.quarter(index)
    return Groups[(index-1)%#Groups+1]
end
function Nav.frame(quarter)
    return CFrame.new(quarter.center_studs[1],0,quarter.center_studs[3])
        *CFrame.Angles(0,math.pi/2-quarter.angle,0)
end
function Nav.localPoint(quarter,x,z)
    return (Nav.frame(quarter)*CFrame.new(x,0,z)).Position
end
function Nav.within(quarter,position)
    local p=Nav.frame(quarter):PointToObjectSpace(position)
    -- 65x95 studs autour de l'îlot, y compris son allée d'approche.
    return math.abs(p.X)<=65 and p.Z>=-95 and p.Z<=55
end
function Nav.stop(quarter,index,step)
    local route=ROUTES[(index-1)%#ROUTES+1]
    local id=route[((step-1)%#route)+1]
    local stop=STOPS[id]
    return Nav.localPoint(quarter,stop[1],stop[2]),stop[3]
end
-- Un chemin Roblox est construit sur les collisions du monde, non pas sur la
-- distance en ligne droite. Un détour hors quartier ou un saut est refusé.
function Nav.plan(quarter,from,to)
    if not Nav.within(quarter,from) or not Nav.within(quarter,to) then return nil end
    local path=PathfindingService:CreatePath({
        AgentRadius=2.5,AgentHeight=6,AgentCanJump=false,AgentCanClimb=false,
        WaypointSpacing=3,
    })
    local ok=pcall(function() path:ComputeAsync(from,to) end)
    if not ok or path.Status~=Enum.PathStatus.Success then return nil end
    local points=path:GetWaypoints()
    if #points<2 or #points>100 then return nil end
    local traveled=0
    local last=from
    for _,waypoint in ipairs(points) do
        if waypoint.Action==Enum.PathWaypointAction.Jump then return nil end
        if not Nav.within(quarter,waypoint.Position) then return nil end
        traveled+=(waypoint.Position-last).Magnitude
        last=waypoint.Position
    end
    -- Garde-fou contre une navigation qui traverse toute la ville.
    if traveled>190 then return nil end
    return path,points
end
-- Déplacement physique des R15, avec replanification au prochain arrêt si le
-- navmesh est bloqué. Pas de MoveTo direct vers la destination en secours.
function Nav.walkHumanoid(model,humanoid,quarter,destination,world)
    local root=model:FindFirstChild("HumanoidRootPart")
    if not root or not root:IsA("BasePart") then return false end
    local target=Vector3.new(destination.X,root.Position.Y,destination.Z)
    local path,points=Nav.plan(quarter,root.Position,target)
    if not path or not points then return false end
    local blocked=false
    local blockedConnection=path.Blocked:Connect(function() blocked=true end)
    local success=true
    for index=2,#points do
        if blocked or not model.Parent or not world.Parent or humanoid.Health<=0 then
            success=false;break
        end
        local waypoint=points[index].Position
        local targetPosition=Vector3.new(waypoint.X,root.Position.Y,waypoint.Z)
        local finished,reached=false,false
        local connection=humanoid.MoveToFinished:Connect(function(ok)
            finished=true;reached=ok
        end)
        humanoid:MoveTo(targetPosition)
        local untilTime=os.clock()+math.max(2.8,(root.Position-targetPosition).Magnitude/math.max(humanoid.WalkSpeed,1)+1.8)
        while not finished and not blocked and os.clock()<untilTime and model.Parent and world.Parent and humanoid.Health>0 do
            task.wait(0.15)
        end
        connection:Disconnect()
        if blocked or not reached then success=false;break end
    end
    blockedConnection:Disconnect()
    if not success then
        humanoid:MoveTo(root.Position) -- annuler la dernière instruction de mouvement
    end
    return success
end
-- Une vérification additionnelle empêche les figurines ancrées de traverser un
-- banc ou un poteau apparu après le calcul de chemin. Vérifie la collision.
function Nav.blockedAhead(model,from,displacement,world)
    if displacement.Magnitude<0.01 then return false end
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Exclude
    local city=world:FindFirstChild("Ville")
    local ignored={model}
    if city then
        for _,name in ipairs({"Citoyens","Citoyens Roblox R15","Habitants R15 des quartiers"}) do
            local folder=city:FindFirstChild(name)
            if folder then table.insert(ignored,folder) end
        end
    end
    params.FilterDescendantsInstances=ignored
    params.RespectCanCollide=true
    local start=from+Vector3.new(0,3.1,0)
    local hit=workspace:Blockcast(CFrame.new(start),Vector3.new(1.6,3.4,1.6),displacement,params)
    return hit~=nil
end
return Nav
