--!strict
-- KC36 WORLD EDIT V1: edition du decor entier (ville + huit interieurs).
-- Instances techniques protegees, autorite serveur, historique durable et annulation.
-- Terrain Roblox, PNJ, scripts et points de transit ne sont pas des decors editables.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local SSS=game:GetService("ServerScriptService")
local SS=game:GetService("ServerStorage")
local DSS=game:GetService("DataStoreService")
local Editor={}
local REMOTE_NAME="KinCityInteriorEditV36"
local STORE_NAME="KinCity_WorldEditorV36_v1"
local MAX_HISTORY=320
local MAX_COPIES=160
local MAX_REACH=160
local MAX_ORIGIN_OFFSET=600
local root:Instance
local byId:{[string]:any}={}
local byInstance:{[Instance]:string}={}
local originalPosition:{[string]:Vector3}={}
local actions:{any}={}
local cursor=0
local nextCopy=1
local liveCopies=0
local loaded=false
local canSave=false
local saveError=""
local savePending=false
local store:any=nil
local lastUse:{[number]:number}={}
local trash=Instance.new("Folder")
trash.Name="KinCityWorldEditorTrashV1"
trash.Parent=SS
local TECH_ATTR={"KinDoorId","KinAnchorId","KinInteractionId","KinLiftId","KinShuttleId",
    "KinStubInteractionId","KinTransitId","KinSpawnId","KinPortalBoundary","KinDoorBoundary"}
local TECH_NAME={ ["Portes"]=true,["Points de connexion"]=true,["SpawnLocation"]=true }
local function owner(player:Player):boolean
    local runtime=SSS:FindFirstChild("KinCityRuntime")
    local chosen=runtime and runtime:GetAttribute("KinCityBuildOwnerUserId")
    if type(chosen)=="number" and chosen>0 then return player.UserId==chosen end
    return game.CreatorType==Enum.CreatorType.User and game.CreatorId>0
        and player.UserId==game.CreatorId
end
local function fail(message:string):any return {ok=false,message=message} end
local function valid(n:any):boolean
    return type(n)=="number" and n==n and math.abs(n)<100000
end
local function hasTechnicalNode(node:Instance):boolean
    if TECH_NAME[node.Name] then return true end
    for _,name in ipairs(TECH_ATTR) do
        if node:GetAttribute(name)~=nil then return true end
    end
    return node:IsA("LuaSourceContainer") or node:IsA("ProximityPrompt")
        or node:IsA("ClickDetector") or node:IsA("Humanoid")
        or node:IsA("Seat") or node:IsA("VehicleSeat") or node:IsA("SpawnLocation")
        or node:IsA("PackageLink")
end
local function protectedPart(part:BasePart):boolean
    if not part.Anchored or not part:IsDescendantOf(root) then return true end
    -- KinProtectEdit sur un groupe protege le groupe, pas chaque decor visuel qu'il contient.
    if part:GetAttribute("KinProtectEdit")==true then return true end
    local node:Instance?=part
    while node and node~=root do
        if hasTechnicalNode(node) then return true end
        node=node.Parent
    end
    -- Les elements qui portent eux-memes une interaction ou des scripts restent intacts.
    for _,child in ipairs(part:GetDescendants()) do
        if hasTechnicalNode(child) then return true end
    end
    return false
end
local function protectedObject(item:Instance):boolean
    if item:IsA("BasePart") then return protectedPart(item) end
    if not item:IsA("Model") or not item:IsDescendantOf(root) then return true end
    if hasTechnicalNode(item) or item:GetAttribute("KinProtectEdit")==true then return true end
    local count=0
    for _,desc in ipairs(item:GetDescendants()) do
        if hasTechnicalNode(desc) or desc:GetAttribute("KinProtectEdit")==true then return true end
        if desc:IsA("BasePart") then
            count+=1
            if protectedPart(desc) then return true end
        end
    end
    return count==0
end
local function position(item:Instance):Vector3
    if item:IsA("Model") then return item:GetPivot().Position end
    return (item::BasePart).Position
end
local function pivot(item:Instance):CFrame
    if item:IsA("Model") then return item:GetPivot() end
    return (item::BasePart).CFrame
end
local function place(item:Instance,cf:CFrame)
    if item:IsA("Model") then
        local model=item::Model
        model:PivotTo(cf)
    else
        local part=item::BasePart
        part.CFrame=cf
    end
end
local function extents(item:Instance):Vector3
    if item:IsA("Model") then return item:GetExtentsSize() end
    return (item::BasePart).Size
end
local function makeIndex(world:Instance)
    table.clear(byId)
    table.clear(byInstance)
    table.clear(originalPosition)
    local total=0
    local function visit(parent:Instance,path:string)
        local ranks:{[string]:number}={}
        for _,child in ipairs(parent:GetChildren()) do
            local label=child.ClassName..":"..child.Name
            local rank=(ranks[label] or 0)+1
            ranks[label]=rank
            local id=path.."/"..tostring(#label)..":"..label..":"..tostring(rank)
            if child:IsA("Model") or child:IsA("BasePart") then
                byId[id]={item=child,home=child.Parent,isCopy=false}
                byInstance[child]=id
                originalPosition[id]=position(child)
                total+=1
            end
            visit(child,id)
        end
    end
    visit(world,"KinCityGenerated")
    print("KC36 WORLD EDIT :",total,"objets et pieces reperes dans la ville et les interieurs")
end
local function live(id:string):any
    local entry=byId[id]
    if entry and entry.item.Parent and entry.item.Parent~=trash then return entry end
    return nil
end
local function accessible(player:Player,item:Instance):boolean
    local ch=player.Character
    local humanoid=ch and ch:FindFirstChildOfClass("Humanoid")
    local part=ch and ch:FindFirstChild("HumanoidRootPart")
    if not humanoid or humanoid.Health<=0 or not part then return false end
    -- Distance au volume et non au pivot : les grands murs restent selectionnables.
    local boxCF: CFrame
    local size: Vector3
    if item:IsA("Model") then
        boxCF,size=item:GetBoundingBox()
    else
        local piece=item::BasePart
        boxCF,size=piece.CFrame,piece.Size
    end
    local rel=boxCF:PointToObjectSpace(part.Position)
    local closest=Vector3.new(
        math.clamp(rel.X,-size.X/2,size.X/2),
        math.clamp(rel.Y,-size.Y/2,size.Y/2),
        math.clamp(rel.Z,-size.Z/2,size.Z/2)
    )
    return (part.Position-boxCF:PointToWorldSpace(closest)).Magnitude<=MAX_REACH
end
local function selectionInfo(id:string):any
    local entry=live(id)
    if not entry then return nil end
    local p=position(entry.item)
    return {id=id,name=entry.item.Name,model=entry.item,
        pos={math.round(p.X*10)/10,math.round(p.Y*10)/10,math.round(p.Z*10)/10},
        copy=entry.isCopy,kind=entry.item.ClassName}
end
local function resolveSelection(hit:any,scope:any):string?
    if typeof(hit)~="Instance" or not hit:IsA("BasePart")
        or not hit:IsDescendantOf(root) then return nil end
    -- Toute copie est manipulee comme objet entier, quelle que soit la piece touchee.
    local parent:Instance?=hit
    while parent and parent~=root do
        local copyId=parent:GetAttribute("KinWorldEditCopyId")
        if type(copyId)=="string" and live(copyId) then return copyId end
        parent=parent.Parent
    end
    if scope=="part" then
        return if not protectedPart(hit) then byInstance[hit] else nil
    end
    local model:Instance?=hit.Parent
    while model and model~=root do
        if model:IsA("Model") and byInstance[model] and not protectedObject(model) then
            return byInstance[model]
        end
        model=model.Parent
    end
    return if not protectedPart(hit) then byInstance[hit] else nil
end
local function validPosition(id:string):boolean
    local entry=live(id)
    if not entry then return false end
    local p=position(entry.item)
    if math.abs(p.X)>12000 or math.abs(p.Z)>12000 or math.abs(p.Y)>3000 then return false end
    local base=originalPosition[id]
    return base~=nil and (p-base).Magnitude<=MAX_ORIGIN_OFFSET
end
local function move(id:string,dx:number,dy:number,dz:number):boolean
    local entry=live(id)
    if not entry then return false end
    local previous=pivot(entry.item)
    place(entry.item,previous+Vector3.new(dx,dy,dz))
    if not validPosition(id) then
        place(entry.item,previous)
        return false
    end
    return true
end
local function rotate(id:string,degrees:number):boolean
    local entry=live(id)
    if not entry then return false end
    local previous=pivot(entry.item)
    place(entry.item,previous*CFrame.Angles(0,math.rad(degrees),0))
    if not validPosition(id) then
        place(entry.item,previous)
        return false
    end
    return true
end
local function hide(id:string,hidden:boolean):boolean
    local entry=byId[id]
    if not entry then return false end
    if hidden then
        if entry.item.Parent==trash or not entry.item.Parent then return false end
        entry.item.Parent=trash
    else
        if entry.item.Parent~=trash or not entry.home or not entry.home.Parent then return false end
        entry.item.Parent=entry.home
    end
    return true
end
local function duplicate(sourceId:string,newId:string,dx:number,dz:number):boolean
    local existing=byId[newId]
    if existing then return hide(newId,false) end
    local entry=live(sourceId)
    if not entry or protectedObject(entry.item) or not entry.item.Archivable then return false end
    local clone=entry.item:Clone()
    clone.Name="Copie • "..entry.item.Name
    clone:SetAttribute("KinWorldEditCopyId",newId)
    place(clone,pivot(entry.item)+Vector3.new(dx,0,dz))
    clone.Parent=entry.home
    byId[newId]={item=clone,home=entry.home,isCopy=true}
    byInstance[clone]=newId
    originalPosition[newId]=position(clone)
    liveCopies+=1
    return true
end
local function perform(a:any,reverse:boolean?):boolean
    if type(a)~="table" or type(a.id)~="string" then return false end
    if a.k=="mv" then
        if not valid(a.x) or not valid(a.y) or not valid(a.z) then return false end
        local s=if reverse then -1 else 1
        return move(a.id,a.x*s,a.y*s,a.z*s)
    elseif a.k=="rt" then
        if not valid(a.deg) then return false end
        return rotate(a.id,(if reverse then -1 else 1)*a.deg)
    elseif a.k=="dl" then
        return hide(a.id,not reverse)
    elseif a.k=="cp" then
        if reverse then return hide(a.id,true) end
        if type(a.source)~="string" or not valid(a.x) or not valid(a.z) then return false end
        return duplicate(a.source,a.id,a.x,a.z)
    end
    return false
end
local function export():any
    return {version=1,cursor=cursor,nextCopy=nextCopy,actions=actions}
end
local function save()
    if not loaded or not canSave or not store then return end
    local ok,err=pcall(function() store:SetAsync("place_"..tostring(game.PlaceId),export()) end)
    if not ok then
        saveError="Sauvegarde indisponible : "..tostring(err)
        warn("KC36 WORLD EDIT : "..saveError)
    else saveError="" end
end
local function scheduleSave()
    if savePending or not canSave then return end
    savePending=true
    task.delay(10,function() savePending=false;save() end)
end
local function validSavedAction(a:any):boolean
    if type(a)~="table" or type(a.id)~="string" or #a.id>1600 then return false end
    if a.k=="mv" then
        return valid(a.x) and valid(a.y) and valid(a.z)
            and math.abs(a.x)<=4 and math.abs(a.y)<=2 and math.abs(a.z)<=4
    elseif a.k=="rt" then
        return valid(a.deg) and math.abs(a.deg)<=90
    elseif a.k=="cp" then
        return type(a.source)=="string" and #a.source<=1600
            and valid(a.x) and valid(a.z) and math.abs(a.x)<=500 and math.abs(a.z)<=500
    elseif a.k=="dl" then return true end
    return false
end
local function replay()
    if game.PlaceId<=0 then loaded=true;saveError="Place locale : session temporaire";return end
    local ok,data=pcall(function()
        store=DSS:GetDataStore(STORE_NAME)
        return store:GetAsync("place_"..tostring(game.PlaceId))
    end)
    if not ok then
        loaded=true
        saveError="DataStore indisponible : modifications temporaires"
        warn("KC36 WORLD EDIT : "..saveError.." ("..tostring(data)..")")
        return
    end
    canSave=true
    if type(data)=="table" and data.version==1 and type(data.actions)=="table"
        and #data.actions<=MAX_HISTORY then
        local requested=math.clamp(math.floor(tonumber(data.cursor) or 0),0,#data.actions)
        nextCopy=math.max(1,math.floor(tonumber(data.nextCopy) or 1))
        for i=1,#data.actions do
            local a=data.actions[i]
            if not validSavedAction(a) then
                warn("KC36 WORLD EDIT : journal invalide a la ligne "..i)
                break
            end
            table.insert(actions,a)
            if i<=requested then
                if not perform(a) then warn("KC36 WORLD EDIT : restauration refusee #"..i) end
                cursor=i
            end
        end
    end
    loaded=true
    print("KC36 WORLD EDIT : historique charge",cursor,"operations")
end
local function handle(player:Player,verb:any,id:any,arg:any):any
    if not owner(player) then return fail("Editeur reserve au proprietaire autorise") end
    if not loaded then return fail("Chargement du monde en cours") end
    if verb=="status" then
        return {ok=true,persistent=canSave,warning=saveError,actions=cursor,
            message="Editeur MONDE pret : ville et interieurs, objets ou pieces"}
    end
    if verb=="select" then
        local found=resolveSelection(id,arg)
        local entry=found and live(found)
        if not entry or not accessible(player,entry.item) then
            return fail("Objet technique protege, trop loin, ou non selectionnable : essaie MODE PIECE")
        end
        return {ok=true,selection=selectionInfo(found),message="Objet selectionne : "..entry.item.Name}
    end
    if verb=="undo" or verb=="redo" then
        local index=if verb=="undo" then cursor else cursor+1
        local a=actions[index]
        if not a then return fail("Aucune modification a "..(if verb=="undo" then "annuler" else "retablir")) end
        local entry=byId[a.id]
        if not entry or not accessible(player,entry.item) then
            return fail("Approche-toi de l'objet pour annuler ou retablir")
        end
        if not perform(a,verb=="undo") then return fail("Operation d'historique refusee") end
        cursor+=if verb=="undo" then -1 else 1
        scheduleSave()
        return {ok=true,selection=selectionInfo(a.id),message=if verb=="undo" then "Annule" else "Retabli"}
    end
    if type(id)~="string" or #id>1600 then return fail("Identifiant invalide") end
    local entry=live(id)
    if not entry or not accessible(player,entry.item) or protectedObject(entry.item) then
        return fail("Objet indisponible ou protege")
    end
    local now=os.clock()
    if now-(lastUse[player.UserId] or -100)<0.13 then return fail("Commande trop rapide") end
    lastUse[player.UserId]=now
    if cursor>=MAX_HISTORY then return fail("Historique plein : exporter ou compacter les changements") end
    local a:any=nil
    if verb=="move" then
        if type(arg)~="table" or not valid(arg[1]) or not valid(arg[2]) or not valid(arg[3])
            then return fail("Deplacement invalide") end
        local x,y,z=arg[1],arg[2],arg[3]
        if math.abs(x)>4 or math.abs(y)>2 or math.abs(z)>4
            or x*2~=math.round(x*2) or y*2~=math.round(y*2) or z*2~=math.round(z*2)
            then return fail("Deplacement de 0,5 stud, maximum 4 par commande") end
        a={k="mv",id=id,x=x,y=y,z=z}
    elseif verb=="rotate" then
        if arg~=15 and arg~=-15 and arg~=45 and arg~=-45
            and arg~=90 and arg~=-90 then return fail("Rotation non autorisee") end
        a={k="rt",id=id,deg=arg}
    elseif verb=="duplicate" then
        if liveCopies>=MAX_COPIES then return fail("Limite de copies atteinte") end
        local size=extents(entry.item)
        local distanceX=math.clamp(size.X+2,2,400)
        local distanceZ=math.clamp(size.Z+2,2,400)
        local offset=Vector3.new(distanceX,0,0)
        local base=position(entry.item)
        if (player.Character and player.Character:FindFirstChild("HumanoidRootPart")) then
            local p=(player.Character.HumanoidRootPart::BasePart).Position
            if (p-base).Magnitude<distanceX+15 then offset=Vector3.new(0,0,distanceZ) end
        end
        local newId="wcopy_"..tostring(nextCopy)
        nextCopy+=1
        a={k="cp",id=newId,source=id,x=offset.X,z=offset.Z}
    elseif verb=="delete" then
        a={k="dl",id=id}
    else return fail("Commande inconnue") end
    if not perform(a) then return fail("Modification refusee : objet ou limite du monde") end
    for i=#actions,cursor+1,-1 do actions[i]=nil end
    table.insert(actions,a)
    cursor=#actions
    scheduleSave()
    return {ok=true,selection=selectionInfo(a.id),message=if verb=="duplicate" then "Objet duplique"
        elseif verb=="delete" then "Objet efface - Annuler disponible" else "Modification effectuee"}
end
function Editor.start(generated:Instance)
    assert(generated and generated.Name=="KinCityGenerated","WORLD EDIT : monde KC36 absent")
    root=generated
    makeIndex(root)
    local found=RS:FindFirstChild(REMOTE_NAME)
    if not found then
        found=Instance.new("RemoteFunction")
        found.Name=REMOTE_NAME
        found.Parent=RS
    end
    assert(found:IsA("RemoteFunction"),"WORLD EDIT : RPC doit etre RemoteFunction")
    local rpc=found::RemoteFunction
    rpc.OnServerInvoke=handle
    task.spawn(replay)
    game:BindToClose(function() save() end)
    print("KC36 WORLD EDIT : mode complet pret, structures visuelles admises, mecanismes proteges")
end
return Editor
