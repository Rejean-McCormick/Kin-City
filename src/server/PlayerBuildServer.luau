--!strict
-- Koali v31.7: éditeur en jeu, autorité serveur et retouches persistantes.
-- Les instances canonique (portes, interactions, spawn) ne sont jamais éditables.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local ServerScriptService=game:GetService("ServerScriptService")
local DataStoreService=game:GetService("DataStoreService")
local RunService=game:GetService("RunService")
local Editor={}

local STORE_NAME="KinCity_Koali_PlayerBuild_v1"
local MAX_CHANGES=450
local MAX_DISTANCE=75
local MAX_SIZE=80
local GRID=0.5
local MATERIALS={Slate=true,Wood=true,WoodPlanks=true,Brick=true,Cobblestone=true,Concrete=true,Marble=true,Metal=true,Grass=true,Fabric=true,SmoothPlastic=true,Glass=true,Granite=true,Sandstone=true,Neon=true}
local SAFE_OP={move=true,rotate=true,resize=true,color=true,material=true,delete=true,restore=true,undo=true,redo=true}
local GUARD_ATTR={"KinDoorId","KinAnchorId","KinInteractionId","KinLiftId","KinShuttleId","KinStubInteractionId","KinTransitId","KinSpawnId","KinCanonicalId","KinPortalBoundary","KinDoorBoundary"}
local worldRef:Instance?=nil
local byId:{[string]:BasePart}={}
local byPart:{[BasePart]:string}={}
local original:{[string]:any}={}
local edits:{[string]:any}={}
local undoStack:{any}={}
local redoStack:{any}={}
local canSave=false
local isLoaded=false
local saveWarning=""
local store:any=nil
local storeKey=""
local revision=0
local pending=false
local lastRequest:{[number]:number}={}

local function owner(player:Player):boolean
    local configured=ServerScriptService:FindFirstChild("KinCityRuntime")
    local chosen=configured and configured:GetAttribute("KinCityBuildOwnerUserId")
    if type(chosen)=="number" and chosen>0 then
        return player.UserId==chosen
    end
    return game.CreatorType==Enum.CreatorType.User and game.CreatorId>0 and player.UserId==game.CreatorId
end
local function errorReply(message:string)
    return {ok=false,message=message}
end
local function finite(n:any):boolean
    return type(n)=="number" and n==n and n>-1e6 and n<1e6
end
local function rounded(n:number,step:number):number
    return math.round(n/step)*step
end
local function vec(v:Vector3):{number}
    return {v.X,v.Y,v.Z}
end
local function validTriplet(v:any):boolean
    return type(v)=="table" and #v==3 and finite(v[1]) and finite(v[2]) and finite(v[3])
end
local function colorTuple(v:Color3):{number}
    return {math.round(v.R*255),math.round(v.G*255),math.round(v.B*255)}
end
local function capture(p:BasePart):any
    local x,y,z=p.CFrame:ToOrientation()
    return {pos=vec(p.Position),rot={math.deg(x),math.deg(y),math.deg(z)},size=vec(p.Size),color=colorTuple(p.Color),material=p.Material.Name,alpha=p.Transparency,hidden=p.Transparency>=0.999}
end
local function protected(p:BasePart):boolean
    if not p:IsDescendantOf(worldRef :: Instance) then return true end
    if p:IsA("Seat") or p:IsA("VehicleSeat") or p:IsA("SpawnLocation") then return true end
    if not p.Anchored then return true end
    local node:Instance?=p
    while node and node~=worldRef do
        for _,key in ipairs(GUARD_ATTR) do
            if node:GetAttribute(key)~=nil then return true end
        end
        if node:IsA("BasePart") and node~=p and node:GetAttribute("KinProtectEdit") then return true end
        if node.Name=="Points de connexion" or node.Name=="Portes" or node.Name=="SpawnLocation" then return true end
        node=node.Parent
    end
    if p:FindFirstChildOfClass("ProximityPrompt") or p:FindFirstChildOfClass("ClickDetector") then return true end
    if p:GetAttribute("KinProtectEdit") then return true end
    return false
end
-- Clef hiérarchique stable pour un même générateur: nom + classe + rang parmi les frères du même nom.
-- Ne dépend jamais d'une instance transmise par le client pour les opérations persistantes.
local function index(root:Instance)
    table.clear(byId);table.clear(byPart);table.clear(original)
    local count=0
    local function visit(node:Instance,path:string)
        local ranks:{[string]:number}={}
        for _,child in ipairs(node:GetChildren()) do
            local label=child.ClassName..":"..child.Name
            ranks[label]=(ranks[label] or 0)+1
            local key=path.."/"..tostring(#label)..":"..label..":"..tostring(ranks[label])
            if child:IsA("BasePart") and not protected(child) then
                count+=1
                byId[key]=child
                byPart[child]=key
                original[key]=capture(child)
            end
            visit(child,key)
        end
    end
    visit(root,"KinCityGenerated")
    print("KIN CITY ÉDITEUR : "..tostring(count).." pièces admissibles, pièces d'interaction protégées")
end
local function snapshot(id:string):any
    local p=byId[id]
    if not p or not p.Parent then return nil end
    return capture(p)
end
local function apply(id:string,data:any):boolean
    local p=byId[id]
    if not p or not p.Parent or not original[id] then return false end
    if type(data)~="table" or not validTriplet(data.pos) or not validTriplet(data.rot) or not validTriplet(data.size) or not validTriplet(data.color) then return false end
    if type(data.material)~="string" or (not MATERIALS[data.material] and data.material~=original[id].material) then return false end
    local size=Vector3.new(data.size[1],data.size[2],data.size[3])
    if size.X<0.2 or size.Y<0.2 or size.Z<0.2 or size.X>MAX_SIZE or size.Y>MAX_SIZE or size.Z>MAX_SIZE then return false end
    local pos=Vector3.new(data.pos[1],data.pos[2],data.pos[3])
    local base=original[id].pos
    if (pos-Vector3.new(base[1],base[2],base[3])).Magnitude>MAX_DISTANCE then return false end
    if math.abs(pos.X)>1500 or math.abs(pos.Y)>700 or math.abs(pos.Z)>1500 then return false end
    local rot=data.rot
    if math.abs(rot[1])>3600 or math.abs(rot[2])>3600 or math.abs(rot[3])>3600 then return false end
    for _,c in ipairs(data.color) do if c<0 or c>255 then return false end end
    p.Size=size
    p.CFrame=CFrame.new(pos)*CFrame.fromOrientation(math.rad(rot[1]),math.rad(rot[2]),math.rad(rot[3]))
    p.Color=Color3.fromRGB(data.color[1],data.color[2],data.color[3])
    p.Material=Enum.Material[data.material]
    local opacity=if finite(data.alpha) then math.clamp(data.alpha,0,0.99) else original[id].transparency
    p.Transparency=if data.hidden then 1 else opacity
    p.CanCollide=if data.hidden then false else original[id].canCollide==true
    p.CanQuery=if data.hidden then false else original[id].canQuery==true
    p.CanTouch=if data.hidden then false else original[id].canTouch==true
    return true
end
local function recordInitialFlags()
    for id,p in pairs(byId) do
        original[id].canCollide=p.CanCollide
        original[id].canTouch=p.CanTouch
        original[id].canQuery=p.CanQuery
        original[id].transparency=p.Transparency
    end
end
local function restoreExact(id:string)
    local originalValue=original[id]
    local p=byId[id]
    if not originalValue or not p then return end
    apply(id,originalValue)
    p.Transparency=originalValue.transparency
    p.CanCollide=originalValue.canCollide
    p.CanQuery=originalValue.canQuery
    p.CanTouch=originalValue.canTouch
end
local function applyAndTrack(id:string,data:any)
    if not apply(id,data) then return false end
    local orig=original[id]
    local same=true
    for _,key in ipairs({"pos","rot","size","color"}) do
        for i=1,3 do
            if math.abs(data[key][i]-orig[key][i])>0.001 then same=false end
        end
    end
    if data.material~=orig.material or data.hidden~=orig.hidden or math.abs((data.alpha or 0)-(orig.alpha or 0))>0.001 then same=false end
    if same then edits[id]=nil;restoreExact(id) else edits[id]=data end
    revision+=1
    return true
end
local function payload()
    local list={}
    for id,data in pairs(edits) do
        table.insert(list,{id=id,data=data,basis={pos=original[id].pos,size=original[id].size}})
    end
    table.sort(list,function(a,b) return a.id<b.id end)
    return {version=1,items=list}
end
local function save()
    if not canSave or not store or not isLoaded then return end
    local ok,err=pcall(function()
        store:SetAsync(storeKey,payload())
    end)
    if not ok then
        saveWarning="Sauvegarde impossible : "..tostring(err)
        warn("KIN CITY ÉDITEUR : "..saveWarning)
    else
        saveWarning=""
    end
end
local function scheduleSave()
    if pending or not canSave then return end
    pending=true
    task.delay(8,function()
        pending=false
        save()
    end)
end
local function replay()
    if game.PlaceId<=0 then
        saveWarning="Place non publiée : modifications temporaires dans cette session"
        isLoaded=true
        return
    end
    local ok,detail=pcall(function()
        store=DataStoreService:GetDataStore(STORE_NAME)
        storeKey="place_"..tostring(game.PlaceId)
        return store:GetAsync(storeKey)
    end)
    if not ok then
        saveWarning="DataStore inaccessible : modifications temporaires dans cette session"
        warn("KIN CITY ÉDITEUR : "..saveWarning.." ("..tostring(detail)..")")
        canSave=false
    else
        canSave=true
        if type(detail)=="table" and detail.version==1 and type(detail.items)=="table" then
            local restored=0
            for _,change in ipairs(detail.items) do
                if restored>=MAX_CHANGES then break end
                if type(change)=="table" and type(change.id)=="string" and type(change.basis)=="table" and original[change.id] then
                    local base=original[change.id]
                    local compatible=validTriplet(change.basis.pos) and validTriplet(change.basis.size)
                    if compatible then
                        for j=1,3 do
                            if math.abs(change.basis.pos[j]-base.pos[j])>0.02 or math.abs(change.basis.size[j]-base.size[j])>0.02 then compatible=false end
                        end
                    end
                    if compatible and applyAndTrack(change.id,change.data) then restored+=1 end
                end
            end
            print("KIN CITY ÉDITEUR : "..tostring(restored).." retouches rechargées")
        end
    end
    isLoaded=true
end
local function serializeInfo(id:string):any
    local p=byId[id]
    if not p then return nil end
    return {id=id,name=p.Name,part=p,info=capture(p),changed=edits[id]~=nil}
end
local function responder(player:Player,verb:any,value:any,details:any):any
    if not owner(player) then return errorReply("Éditeur réservé au propriétaire autorisé (voir notice)") end
    if not isLoaded then return errorReply("Chargement des retouches en cours") end
    if verb=="status" then return {ok=true,ready=true,persistent=canSave,warning=saveWarning,changed=(function() local n=0;for _ in pairs(edits) do n+=1 end;return n end)()} end
    if verb=="lastHidden" then
        local lastId=nil
        for id,data in pairs(edits) do
            if data.hidden and (not lastId or id<lastId) then lastId=id end
        end
        if not lastId then return errorReply("Aucune pièce masquée enregistrée") end
        return {ok=true,selection=serializeInfo(lastId),message="Pièce masquée retrouvée : utilise RESTAURER"}
    end
    if verb=="select" then
        if typeof(value)~="Instance" or not value:IsA("BasePart") then return errorReply("Sélectionne une pièce du décor") end
        local id=byPart[value]
        if not id then return errorReply("Objet protégé ou extérieur à KinCityGenerated") end
        return {ok=true,selection=serializeInfo(id)}
    end
    if not SAFE_OP[verb] then return errorReply("Commande non reconnue") end
    if type(value)~="string" or #value>700 then return errorReply("Identifiant invalide") end
    local p=byId[value]
    if not p or not p.Parent or protected(p) then return errorReply("Cette pièce est protégée") end
    local now=os.clock()
    if now-(lastRequest[player.UserId] or 0)<0.075 then return errorReply("Commande trop rapide") end
    lastRequest[player.UserId]=now
    if verb=="undo" or verb=="redo" then
        local from=if verb=="undo" then undoStack else redoStack
        local to=if verb=="undo" then redoStack else undoStack
        local entry=table.remove(from)
        if not entry then return errorReply("Historique vide") end
        if not byId[entry.id] then return errorReply("Objet de l'historique absent") end
        local prior=if verb=="undo" then entry.before else entry.after
        if not applyAndTrack(entry.id,prior) then return errorReply("Historique incompatible") end
        table.insert(to,entry)
        scheduleSave()
        return {ok=true,selection=serializeInfo(entry.id),message="Modification "..(if verb=="undo" then "annulée" else "rétablie")}
    end
    local before=snapshot(value)
    if not before then return errorReply("Objet absent") end
    local proposed=table.clone(before)
    local delta=details
    if verb=="move" then
        if not validTriplet(delta) then return errorReply("Déplacement invalide") end
        local dv=Vector3.new(delta[1],delta[2],delta[3])
        if dv.Magnitude>12 then return errorReply("Déplacement trop grand") end
        proposed.pos={rounded(before.pos[1]+dv.X,GRID),rounded(before.pos[2]+dv.Y,GRID),rounded(before.pos[3]+dv.Z,GRID)}
    elseif verb=="rotate" then
        if type(delta)~="number" or not finite(delta) or math.abs(delta)>90 then return errorReply("Rotation invalide") end
        proposed.rot={before.rot[1],rounded(before.rot[2]+delta,5),before.rot[3]}
    elseif verb=="resize" then
        if not validTriplet(delta) then return errorReply("Taille invalide") end
        proposed.size={rounded(before.size[1]+delta[1],0.25),rounded(before.size[2]+delta[2],0.25),rounded(before.size[3]+delta[3],0.25)}
    elseif verb=="color" then
        if not validTriplet(delta) then return errorReply("Couleur invalide") end
        proposed.color={math.round(delta[1]),math.round(delta[2]),math.round(delta[3])}
    elseif verb=="material" then
        if type(delta)~="string" or not MATERIALS[delta] then return errorReply("Matière non autorisée") end
        proposed.material=delta
    elseif verb=="delete" then
        proposed.hidden=true
    elseif verb=="restore" then
        proposed=table.clone(original[value])
    end
    local changed=edits[value]~=nil
    local n=0;for _ in pairs(edits) do n+=1 end
    if not changed and n>=MAX_CHANGES then return errorReply("Limite de retouches atteinte") end
    if not applyAndTrack(value,proposed) then return errorReply("Modification hors limites") end
    local after=snapshot(value)
    table.insert(undoStack,{id=value,before=before,after=after})
    if #undoStack>40 then table.remove(undoStack,1) end
    table.clear(redoStack)
    scheduleSave()
    return {ok=true,selection=serializeInfo(value),persistent=canSave,message="Modification appliquée"}
end

function Editor.start(world:Instance)
    worldRef=world
    -- Publier la connexion et son message d'attente AVANT le parcours de la ville.
    -- Même si l'indexation des milliers de pièces prend du temps, le client
    -- pourra démarrer normalement et afficher le bouton Création.
    local rpc=ReplicatedStorage:FindFirstChild("KinCityBuildRPC")
    if rpc and not rpc:IsA("RemoteFunction") then
        warn("KIN CITY ÉDITEUR : KinCityBuildRPC existe avec un type incorrect")
        return
    end
    if not rpc then
        rpc=Instance.new("RemoteFunction")
        rpc.Name="KinCityBuildRPC"
        rpc.Parent=ReplicatedStorage
    end
    (rpc :: RemoteFunction).OnServerInvoke=responder
    index(world)
    recordInitialFlags()
    task.spawn(replay)
    game:BindToClose(function()
        if canSave and isLoaded then save() end
    end)
    print("KIN CITY ÉDITEUR : autorisation requise; stockage par Place avec DataStore")
end
return Editor
