-- KC36 : INSTALLATION PERMANENTE DU MODE ATELIER INTERIEUR
-- Command Bar Roblox Studio, Place principale Kin City, Play arrete.
-- Cree modules serveur/client, protege les intérieurs de l'ancien editeur.
-- Aucun rebuild, aucune suppression d'assets ou de batiments.
local Run=game:GetService("RunService")
local SS=game:GetService("ServerStorage")
local Server=game:GetService("ServerScriptService")
local SP=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
assert(Run:IsStudio() and not Run:IsRunning(),"Arreter Play")
assert(game.PlaceId==72097868581669,"Ouvrir Kin City principale dans Studio")
local runtime=assert(Server:FindFirstChild("KinCityRuntime"),"Runtime Kin City absent")
local ui=assert(SP:FindFirstChild("KinCityUI"),"Client KinCityUI absent")
local oldBuild=assert(runtime:FindFirstChild("PlayerBuildServer"),"Ancien editeur introuvable")
assert(runtime:IsA("Script") and ui:IsA("LocalScript") and oldBuild:IsA("ModuleScript"),"Scripts inattendus")
local world=assert(workspace:FindFirstChild("KinCityGenerated"),"Ville introuvable")
assert(world:GetAttribute("KinBuildState")=="Ready","Ville non prete")
local library=assert(SS:FindFirstChild("KinCityArtDecoLibrary"),"Bibliotheque Art Deco absente")
assert(library:FindFirstChildOfClass("PackageLink") and library:GetAttribute("KinSourceCount")==121,"Package 121 non valide")
assert(not SS:FindFirstChild("KC36InteriorEditorBackup_v1"),"Atelier déjà installé ou backup présent : inspection requise")
assert(not runtime:FindFirstChild("InteriorEditorV36"),"Module serveur déjà présent")
assert(not ui:FindFirstChild("InteriorEditorClientV36"),"Module client déjà présent")
local oldR,oldC,oldB=runtime.Source,ui.Source,oldBuild.Source
local serverAnchor="require(script.PlayerBuildServer).start(state.world)"
local clientAnchor="require(script.Hud).start(remote)"
local protectAnchor='if not p:IsDescendantOf(worldRef :: Instance) then return true end'
local function replaceOne(source,anchor,replacement)
    local _,count=source:gsub(anchor:gsub("([^%w])","%%%1"),"")
    assert(count==1,"Point d'insertion non unique : "..anchor)
    return (source:gsub(anchor:gsub("([^%w])","%%%1"),function() return replacement end))
end
local revisedR=replaceOne(oldR,serverAnchor,serverAnchor..'\nlocal kc36EditorOk,kc36EditorErr=pcall(function() require(script.InteriorEditorV36).start(state.world) end)\nif not kc36EditorOk then warn("KC36 ATELIER server : "..tostring(kc36EditorErr)) end')
local revisedC=replaceOne(oldC,clientAnchor,'task.spawn(function()\n    local ok,err=pcall(function() require(script.InteriorEditorClientV36).start() end)\n    if not ok then warn("KC36 ATELIER client : "..tostring(err)) end\nend)\n'..clientAnchor)
local revisedB=replaceOne(oldB,protectAnchor,protectAnchor..'\n    local interiorRoot=(worldRef :: Instance):FindFirstChild("Bâtiments visitables")\n    if interiorRoot and p:IsDescendantOf(interiorRoot) then return true end')
local editorServerSource=[========[
--!strict
-- KC36 B09/B01-B08 : edition d'OBJETS mobiliers, jamais de fragments architecturaux.
-- Autorite serveur; ecritures par Place; operations rejouables; undo/redo; aucune duplication d'interactions.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local SSS=game:GetService("ServerScriptService")
local SS=game:GetService("ServerStorage")
local DSS=game:GetService("DataStoreService")
local Plan=require(RS:WaitForChild("KinCityShared"):WaitForChild("WorldPlan"))
local Editor={}
local REMOTE="KinCityInteriorEditV36"
local STORE="KinCity_InteriorEditorV36_v1"
local MAX_ACTIONS=400
local MAX_COPIES=100
local MAX_REACH=65
local MODEL_ASSETS={
    ["prop.bench"]=true,["prop.planter"]=true,["prop.table"]=true,
    ["prop.bookshelf"]=true,["prop.lamp"]=true,["prop.board"]=true,
    ["prop.panel"]=true,["prop.display"]=true,
}
local FORBIDDEN={"KinDoorId","KinAnchorId","KinInteractionId","KinLiftId","KinShuttleId",
    "KinStubInteractionId","KinTransitId","KinSpawnId","KinCanonicalId","KinPortalBoundary",
    "KinDoorBoundary","KinProtectEdit"}
local interiors:Instance
local world:Instance
local registry:{[string]:any}={}
local copies=0
local actions:{any}={}
local cursor=0
local loaded=false
local persistent=false
local warning=""
local store:any=nil
local saveScheduled=false
local lastAction:{[number]:number}={}
local trash=Instance.new("Folder")
trash.Name="KinCityInteriorEditorTrashV36"
trash.Parent=SS
local rooms:{[string]:{any}}={}
for _,place in ipairs(Plan.places) do
    if place.place_key~="city" then rooms[place.place_key]=place.rooms end
end
local function owner(player:Player):boolean
    local runtime=SSS:FindFirstChild("KinCityRuntime")
    local uid=runtime and runtime:GetAttribute("KinCityBuildOwnerUserId")
    if typeof(uid)=="number" and uid>0 then return uid==player.UserId end
    return game.CreatorType==Enum.CreatorType.User and game.CreatorId>0 and game.CreatorId==player.UserId
end
local function reject(message:string):any return {ok=false,message=message} end
local function validNumber(n:any):boolean
    return type(n)=="number" and n==n and math.abs(n)<10000
end
local function blocked(model:Model):boolean
    for _,item in ipairs({model,table.unpack(model:GetDescendants())}) do
        for _,a in ipairs(FORBIDDEN) do if item:GetAttribute(a)~=nil then return true end end
        if item:IsA("LuaSourceContainer") or item:IsA("ProximityPrompt")
            or item:IsA("ClickDetector") or item:IsA("Seat")
            or item:IsA("VehicleSeat") or item:IsA("Humanoid") then return true end
        if item:IsA("BasePart") and not item.Anchored then return true end
    end
    return false
end
local function modelPlace(model:Model):string?
    local node:Instance?=model
    while node and node~=interiors do
        if node:IsA("Model") and node:GetAttribute("KinInteriorOrigin")~=nil then
            local place=node:GetAttribute("KinPlaceKey")
            if type(place)=="string" then return place end
        end
        node=node.Parent
    end
    return nil
end
local function index()
    local count=0
    for _,item in ipairs(interiors:GetDescendants()) do
        if item:IsA("Model") and typeof(item:GetAttribute("KinFurnishingId"))=="string" then
            local asset=item:GetAttribute("KinAssetId")
            local place=modelPlace(item)
            local furnishing=item:GetAttribute("KinFurnishingId")
            if MODEL_ASSETS[asset] and place and type(furnishing)=="string"
                and not blocked(item) then
                local key=place.."|"..furnishing
                assert(registry[key]==nil,"Mobilier double : "..key)
                registry[key]={model=item,home=item.Parent,place=place,source=key,copy=false}
                count+=1
            end
        end
    end
    print("KC36 ATELIER :",count,"meubles entiers admis; portes et architecture exclues")
end
local function rootModel(item:any):Model?
    if typeof(item)~="Instance" or not item:IsDescendantOf(interiors) then return nil end
    local node:Instance?=item
    while node and node~=interiors do
        if node:IsA("Model") and (typeof(node:GetAttribute("KinInteriorCopyId"))=="string"
            or typeof(node:GetAttribute("KinFurnishingId"))=="string") then return node end
        node=node.Parent
    end
    return nil
end
local function idFor(model:Model):string?
    local id=model:GetAttribute("KinInteriorCopyId")
    if type(id)=="string" then return id end
    local place=modelPlace(model)
    local furniture=model:GetAttribute("KinFurnishingId")
    if place and type(furniture)=="string" then return place.."|"..furniture end
    return nil
end
local function positionOk(model:Model,place:string):boolean
    local interior=interiors:FindFirstChild("Intérieur — "..place)
    local origin=interior and interior:GetAttribute("KinInteriorOrigin")
    if typeof(origin)~="Vector3" then return false end
    local boxCF,boxSize=model:GetBoundingBox()
    local x,y,z=boxCF.Position.X-origin.X,boxCF.Position.Y-origin.Y,boxCF.Position.Z-origin.Z
    if y-boxSize.Y/2 < -0.2 or y+boxSize.Y/2 > 15.5 then return false end
    for _,room in ipairs(rooms[place] or {}) do
        local cx,_,cz=table.unpack(room.center_studs)
        local w,_,d=table.unpack(room.size_studs)
        if math.abs(x-cx)+boxSize.X/2 <= w/2-2.5
            and math.abs(z-cz)+boxSize.Z/2 <= d/2-2.5 then return true end
    end
    return false
end
local function furnitureClear(model:Model,place:string):boolean
    local cf,size=model:GetBoundingBox()
    for _,entry in pairs(registry) do
        if entry.place==place and entry.model~=model and entry.model.Parent~=trash then
            local otherCF,otherSize=entry.model:GetBoundingBox()
            local dx=math.abs(cf.Position.X-otherCF.Position.X)
            local dz=math.abs(cf.Position.Z-otherCF.Position.Z)
            local dy=math.abs(cf.Position.Y-otherCF.Position.Y)
            if dx<(size.X+otherSize.X)/2-0.35
                and dz<(size.Z+otherSize.Z)/2-0.35
                and dy<(size.Y+otherSize.Y)/2-0.35 then return false end
        end
    end
    return true
end
local function inside(player:Player,entry:any):boolean
    if player:GetAttribute("KinZone")~=entry.place then return false end
    local character=player.Character
    local humanoid=character and character:FindFirstChildOfClass("Humanoid")
    local root=character and character:FindFirstChild("HumanoidRootPart")
    return humanoid~=nil and humanoid.Health>0 and root~=nil
        and (root.Position-entry.model:GetPivot().Position).Magnitude<=MAX_REACH
end
local function selectInfo(id:string):any
    local entry=registry[id]
    if not entry or entry.model.Parent==trash then return nil end
    local pos=entry.model:GetPivot().Position
    return {id=id,name=entry.model.Name,model=entry.model,place=entry.place,
        pos={math.round(pos.X*10)/10,math.round(pos.Y*10)/10,math.round(pos.Z*10)/10},
        copy=entry.copy}
end
local function translate(id:string,dx:number,dy:number,dz:number):boolean
    local entry=registry[id]
    if not entry or entry.model.Parent==trash then return false end
    local m=entry.model
    local previous=m:GetPivot()
    m:PivotTo(previous+Vector3.new(dx,dy,dz))
    if not positionOk(m,entry.place) or not furnitureClear(m,entry.place) then
        m:PivotTo(previous);return false
    end
    return true
end
local function rotate(id:string,degrees:number):boolean
    local entry=registry[id]
    if not entry or entry.model.Parent==trash then return false end
    local m=entry.model
    local previous=m:GetPivot()
    m:PivotTo(previous*CFrame.Angles(0,math.rad(degrees),0))
    if not positionOk(m,entry.place) or not furnitureClear(m,entry.place) then
        m:PivotTo(previous);return false
    end
    return true
end
local function duplicate(id:string,newId:string,dx:number,dz:number):boolean
    local source=registry[id]
    if not source or source.model.Parent==trash then return false end
    local existing=registry[newId]
    if existing then
        if existing.model.Parent~=trash then return false end
        existing.model.Parent=existing.home
        return true
    end
    if blocked(source.model) then return false end
    local m=source.model:Clone()
    m.Name="Copie • "..source.model.Name
    m:SetAttribute("KinInteriorCopyId",newId)
    m:SetAttribute("KinFurnishingId",nil)
    m:PivotTo(source.model:GetPivot()+Vector3.new(dx,0,dz))
    if not positionOk(m,source.place) or not furnitureClear(m,source.place) then
        m:Destroy();return false
    end
    m.Parent=source.home
    registry[newId]={model=m,home=source.home,place=source.place,source=source.source,copy=true}
    return true
end
local function hide(id:string,hideIt:boolean):boolean
    local entry=registry[id]
    if not entry then return false end
    if hideIt then
        if entry.model.Parent==trash then return false end
        entry.model.Parent=trash
    else
        if entry.model.Parent~=trash then return false end
        entry.model.Parent=entry.home
    end
    return true
end
local function doAction(action:any,reverse:boolean?):boolean
    local id=action.id
    if type(id)~="string" then return false end
    if action.k=="mv" then
        local sign=if reverse then -1 else 1
        return translate(id,action.x*sign,action.y*sign,action.z*sign)
    elseif action.k=="rt" then
        return rotate(id,(if reverse then -1 else 1)*action.deg)
    elseif action.k=="cp" then
        if reverse then return hide(id,true) end
        return duplicate(action.source,id,action.x,action.z)
    elseif action.k=="dl" then
        return hide(id,not reverse)
    end
    return false
end
local function export()
    return {version=1,cursor=cursor,actions=actions}
end
local function save()
    if not loaded or not persistent or not store then return end
    local value=export()
    local ok,err=pcall(function() store:SetAsync("place_"..game.PlaceId,value) end)
    if not ok then
        warning="Sauvegarde impossible : "..tostring(err)
        warn("KC36 ATELIER : "..warning)
    else warning="" end
end
local function queueSave()
    if saveScheduled or not persistent then return end
    saveScheduled=true
    task.delay(10,function() saveScheduled=false;save() end)
end
local function replay()
    if game.PlaceId<=0 then
        warning="Place locale : changements non persistants"
        loaded=true
        return
    end
    local ok,data=pcall(function()
        store=DSS:GetDataStore(STORE)
        return store:GetAsync("place_"..game.PlaceId)
    end)
    if not ok then
        warning="DataStore indisponible : modifications temporaires"
        warn("KC36 ATELIER : "..warning.." ("..tostring(data)..")")
        loaded=true
        return
    end
    persistent=true
    if type(data)=="table" and data.version==1 and type(data.actions)=="table"
        and #data.actions<=MAX_ACTIONS then
        actions=data.actions
        cursor=math.clamp(math.floor(tonumber(data.cursor) or #actions),0,#actions)
        for i=1,cursor do
            local a=actions[i]
            -- Journal existant seulement : jamais un Remote client transmis directement.
            if type(a)=="table" and (a.k=="mv" or a.k=="rt" or a.k=="cp" or a.k=="dl") then
                local valid=false
                if a.k=="mv" then
                    valid=validNumber(a.x) and validNumber(a.y) and validNumber(a.z)
                        and math.abs(a.x)<=4 and math.abs(a.y)<=2 and math.abs(a.z)<=4
                elseif a.k=="rt" then valid=validNumber(a.deg) and math.abs(a.deg)<=90
                elseif a.k=="cp" then
                    valid=type(a.source)=="string" and validNumber(a.x) and validNumber(a.z)
                        and math.abs(a.x)<=50 and math.abs(a.z)<=50
                else valid=true end
                if valid then
                    if a.k=="cp" then copies+=1 end
                    if not doAction(a) then warn("KC36 ATELIER : replay refusé, opération #"..i) end
                end
            end
        end
    end
    loaded=true
    print("KC36 ATELIER : historique chargé",cursor,"opérations")
end
local function handle(player:Player,verb:any,id:any,arg:any):any
    if not owner(player) then return reject("Atelier réservé au propriétaire de Kin City") end
    if not loaded then return reject("Chargement de l'atelier en cours") end
    if verb=="status" then
        local zone=player:GetAttribute("KinZone")
        return {ok=true,zone=zone,interior=rooms[zone]~=nil,persistent=persistent,
            warning=warning,actions=cursor,copies=copies,
            message=if rooms[zone] then "Atelier intérieur prêt" else "Entre dans une institution pour modifier son mobilier"}
    end
    if verb=="select" then
        local model=rootModel(id)
        local key=model and idFor(model)
        local entry=key and registry[key]
        if not entry or entry.model~=model or not inside(player,entry) then
            return reject("Objet non éditable : sélectionne un meuble libre, sans interaction")
        end
        return {ok=true,selection=selectInfo(key),message="Meuble sélectionné"}
    end
    if verb=="undo" or verb=="redo" then
        if player:GetAttribute("KinZone")=="city" then return reject("Entre dans un intérieur") end
        local n=if verb=="undo" then cursor else cursor+1
        local action=actions[n]
        if not action then return reject("Historique vide") end
        local entry=registry[action.id]
        if not entry or player:GetAttribute("KinZone")~=entry.place then
            return reject("Historique d'un autre intérieur : retourne dans cet intérieur")
        end
        if not doAction(action,verb=="undo") then return reject("Annulation impossible") end
        cursor+=if verb=="undo" then -1 else 1
        queueSave()
        return {ok=true,selection=selectInfo(action.id),message=if verb=="undo" then "Annulé" else "Rétabli"}
    end
    if type(id)~="string" or #id>190 then return reject("Identifiant invalide") end
    local entry=registry[id]
    if not entry or entry.model.Parent==trash or not inside(player,entry) then
        return reject("Meuble inaccessible, protégé ou dans un autre intérieur")
    end
    local now=os.clock()
    if now-(lastAction[player.UserId] or -100)<0.12 then return reject("Commande trop rapide") end
    lastAction[player.UserId]=now
    if cursor>=MAX_ACTIONS then return reject("Limite d'historique atteinte; exporter les modifications") end
    local action:any=nil
    if verb=="move" then
        if type(arg)~="table" or not validNumber(arg[1]) or not validNumber(arg[2]) or not validNumber(arg[3]) then
            return reject("Déplacement incorrect")
        end
        local x,y,z=arg[1],arg[2],arg[3]
        if math.abs(x)>4 or math.abs(y)>2 or math.abs(z)>4 then return reject("Déplacement trop grand") end
        if x*2~=math.round(x*2) or y*2~=math.round(y*2) or z*2~=math.round(z*2) then
            return reject("Grille de 0,5 stud")
        end
        action={k="mv",id=id,x=x,y=y,z=z}
    elseif verb=="rotate" then
        if arg~=15 and arg~=-15 and arg~=45 and arg~=-45 and arg~=90 and arg~=-90 then
            return reject("Rotation invalide")
        end
        action={k="rt",id=id,deg=arg}
    elseif verb=="duplicate" then
        if copies>=MAX_COPIES then return reject("Limite de copies atteinte") end
        local _,size=entry.model:GetBoundingBox()
        local possible={{size.X+3,0},{-(size.X+3),0},{0,size.Z+3},{0,-(size.Z+3)}}
        local newId=string.format("copy%04d",copies+1)
        for _,v in ipairs(possible) do
            -- Ne pas produire un clone invalide (vérification de salle par le serveur).
            local candidate={k="cp",id=newId,source=id,x=v[1],z=v[2]}
            if doAction(candidate) then action=candidate;copies+=1;break end
        end
        if not action then return reject("Pas d'espace libre dans cette pièce pour dupliquer") end
    elseif verb=="delete" then
        action={k="dl",id=id}
    else return reject("Action inconnue") end
    if verb~="duplicate" and not doAction(action) then return reject("Déplacement interdit : limites de pièce ou objet protégé") end
    for i=#actions,cursor+1,-1 do actions[i]=nil end
    table.insert(actions,action)
    cursor=#actions
    queueSave()
    return {ok=true,selection=selectInfo(action.id),message=if verb=="duplicate" then "Objet complet dupliqué" elseif verb=="delete" then "Objet effacé (Annuler disponible)" else "Objet modifié"}
end
function Editor.start(generated:Instance)
    world=generated
    interiors=assert(world:FindFirstChild("Bâtiments visitables"),"Atelier : intérieurs manquants")
    local remote=RS:FindFirstChild(REMOTE)
    if not remote then
        remote=Instance.new("RemoteFunction")
        remote.Name=REMOTE
        remote.Parent=RS
    end
    assert(remote:IsA("RemoteFunction"),"Atelier : mauvais type RPC")
    (remote::RemoteFunction).OnServerInvoke=handle
    index()
    task.spawn(replay)
    game:BindToClose(function() save() end)
    print("KC36 ATELIER : édition intérieure sécurisée démarrée")
end
return Editor

]========]
local editorClientSource=[========[
--!strict
-- KC36 : edition du MOBILIER complet depuis l'interieur; souris, tactile, gamepad.
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local UIS=game:GetService("UserInputService")
local Workspace=game:GetService("Workspace")
local Menu=require(script.Parent.KinCityMenu)
local Client={}
local player=Players.LocalPlayer
local rpc:RemoteFunction?=nil
local selected:any=nil
local panel:Frame
local selectionLabel:TextLabel
local feedback:TextLabel
local active=false
local mark:Highlight
local confirming=false
local function corner(parent:Instance,r:number)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=parent
end
local function text(parent:Instance,message:string,height:number):TextLabel
    local l=Instance.new("TextLabel")
    l.Size=UDim2.new(1,-16,0,height)
    l.BackgroundTransparency=1
    l.Text=message;l.TextWrapped=true
    l.Font=Enum.Font.Gotham
    l.TextSize=14;l.TextColor3=Color3.fromRGB(239,242,227)
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.Parent=parent
    return l
end
local function button(parent:Instance,message:string,action:()->()):TextButton
    local b=Instance.new("TextButton")
    b.Text=message;b.TextScaled=true;b.TextWrapped=true
    b.BackgroundColor3=Color3.fromRGB(30,104,100)
    b.TextColor3=Color3.fromRGB(247,242,226)
    b.Font=Enum.Font.GothamBold
    b.Size=UDim2.fromOffset(110,40);b.Parent=parent
    corner(b,8);b.Activated:Connect(action)
    return b
end
local function row(parent:Instance,items:{any})
    local r=Instance.new("Frame")
    r.Size=UDim2.new(1,-16,0,43);r.BackgroundTransparency=1;r.Parent=parent
    local layout=Instance.new("UIListLayout")
    layout.FillDirection=Enum.FillDirection.Horizontal
    layout.Padding=UDim.new(0,5);layout.Parent=r
    for _,item in ipairs(items) do
        local b=button(r,item[1],item[2])
        b.Size=UDim2.new(1/#items,-5,0,40)
    end
end
local function call(verb:string,key:any?,detail:any?):any
    if not rpc or not rpc.Parent then
        local candidate=RS:FindFirstChild("KinCityInteriorEditV36")
        if candidate and candidate:IsA("RemoteFunction") then rpc=candidate end
    end
    if not rpc then feedback.Text="Atelier serveur en cours de démarrage";return nil end
    local ok,result=pcall(function() return rpc:InvokeServer(verb,key,detail) end)
    if not ok then feedback.Text="Connexion Atelier indisponible";return nil end
    if not result or not result.ok then
        feedback.Text=result and result.message or "Action refusée"
        return nil
    end
    feedback.Text=result.message or "Action réussie"
    return result
end
local function repaint()
    if not selected then
        selectionLabel.Text="Aucun meuble sélectionné. Active SÉLECTION puis clique sur un meuble."
        mark.Adornee=nil
        return
    end
    selectionLabel.Text=string.format("%s\nX %.1f  Y %.1f  Z %.1f",
        selected.name,selected.pos[1],selected.pos[2],selected.pos[3])
    mark.Adornee=selected.model
end
local function update(result:any)
    if not result then return end
    selected=result.selection
    confirming=false
    repaint()
end
local function action(verb:string,detail:any?)
    if not selected then feedback.Text="Sélectionne d'abord un meuble";return end
    update(call(verb,selected.id,detail))
end
local function pick(screen:Vector2):BasePart?
    local camera=Workspace.CurrentCamera
    local generated=Workspace:FindFirstChild("KinCityGenerated")
    local interiors=generated and generated:FindFirstChild("Bâtiments visitables")
    if not camera or not interiors then return nil end
    local ray=camera:ViewportPointToRay(screen.X,screen.Y)
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances={interiors}
    local hit=Workspace:Raycast(ray.Origin,ray.Direction*250,params)
    return hit and hit.Instance or nil
end
function Client.start()
    if player:WaitForChild("PlayerGui"):FindFirstChild("KC36AtelierInterieur") then return end
    local ui=Instance.new("ScreenGui")
    ui.Name="KC36AtelierInterieur";ui.ResetOnSpawn=false
    ui.DisplayOrder=28;ui.Parent=player.PlayerGui
    panel=Instance.new("Frame")
    panel.Name="ATELIER INTERIEUR";panel.AnchorPoint=Vector2.new(1,0)
    panel.Position=UDim2.new(1,-12,0,76)
    panel.Size=UDim2.new(0.92,0,0.76,0)
    panel.BackgroundColor3=Color3.fromRGB(19,45,49)
    panel.Visible=false;panel.Parent=ui
    local limit=Instance.new("UISizeConstraint")
    limit.MaxSize=Vector2.new(360,720);limit.MinSize=Vector2.new(210,250);limit.Parent=panel
    corner(panel,10)
    local scroll=Instance.new("ScrollingFrame")
    scroll.Name="Commandes";scroll.Size=UDim2.new(1,-12,1,-12)
    scroll.Position=UDim2.fromOffset(6,6)
    scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=5;scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.CanvasSize=UDim2.new();scroll.Parent=panel
    local layout=Instance.new("UIListLayout")
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Padding=UDim.new(0,8);layout.Parent=scroll
    text(scroll,"ATELIER INTÉRIEUR • mobilier entier",36)
    feedback=text(scroll,"Entre dans une institution; propriétaire uniquement.",64)
    feedback.TextColor3=Color3.fromRGB(197,244,240)
    selectionLabel=text(scroll,"Aucun meuble sélectionné.",60)
    row(scroll,{{"SÉLECTION ON/OFF",function()
        active=not active
        feedback.Text=if active then "Sélection active : clique ou touche un meuble" else "Sélection arrêtée"
    end}})
    text(scroll,"DÉPLACER • Grille de 0,5 stud",27)
    row(scroll,{{"← X",function()action("move",{-0.5,0,0}) end},
        {"X →",function()action("move",{0.5,0,0}) end},
        {"↑ Z",function()action("move",{0,0,-0.5}) end},
        {"↓ Z",function()action("move",{0,0,0.5}) end}})
    row(scroll,{{"MONTER",function()action("move",{0,0.5,0}) end},
        {"DESCENDRE",function()action("move",{0,-0.5,0}) end}})
    row(scroll,{{"↶ -15°",function()action("rotate",-15) end},
        {"+15° ↷",function()action("rotate",15) end}})
    text(scroll,"DUPLIQUER crée un objet complet, à côté de l'original.",40)
    row(scroll,{{"DUPLIQUER",function()action("duplicate") end}})
    text(scroll,"EFFACER retire l'objet entier. Une confirmation évite les erreurs.",43)
    row(scroll,{{"EFFACER",function()
        if not selected then feedback.Text="Sélectionne un meuble";return end
        if not confirming then
            confirming=true;feedback.Text="Confirmer : appuie encore sur EFFACER";return
        end
        action("delete")
    end}})
    row(scroll,{{"ANNULER",function()update(call("undo")) end},
        {"RÉTABLIR",function()update(call("redo")) end}})
    text(scroll,"Meubles libres uniquement. Murs, portes, terminaux, œuvres interactives et structures sont intouchables.",60)
    mark=Instance.new("Highlight")
    mark.Name="KC36MeubleSelectionne";mark.FillColor=Color3.fromRGB(197,244,240)
    mark.FillTransparency=0.8;mark.OutlineColor=Color3.fromRGB(209,165,96)
    mark.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    mark.Parent=Workspace.CurrentCamera or ui
    Menu.register("interior_editor","ATELIER • Modifier l'intérieur",nil,panel)
    panel:GetPropertyChangedSignal("Visible"):Connect(function()
        if panel.Visible then
            local result=call("status")
            if result then
                feedback.Text=(result.message or "").."\n"..
                    (if result.persistent then "Sauvegarde en ligne active" else result.warning or "Session temporaire")
            end
        else active=false;confirming=false end
    end)
    UIS.InputBegan:Connect(function(input,processed)
        if not active or not panel.Visible or processed then return end
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            update(call("select",pick(UIS:GetMouseLocation())))
        elseif input.UserInputType==Enum.UserInputType.Touch then
            update(call("select",pick(Vector2.new(input.Position.X,input.Position.Y))))
        elseif input.KeyCode==Enum.KeyCode.ButtonR2 then
            local camera=Workspace.CurrentCamera
            if camera then update(call("select",pick(camera.ViewportSize/2))) end
        end
    end)
end
return Client

]========]
local backup=Instance.new("Folder")
backup.Name="KC36InteriorEditorBackup_v1"
backup:SetAttribute("KC36InteriorEditorRevision","KC36-INTERIOR-EDITOR-1")
for name,source in pairs({KinCityRuntime=oldR,KinCityUI=oldC,PlayerBuildServer=oldB}) do
    local original=Instance.new("StringValue")
    original.Name=name.."_Original"
    original.Value=source
    original.Parent=backup
end
backup.Parent=SS
local sm:ModuleScript?=nil
local cm:ModuleScript?=nil
local ok,reason=pcall(function()
    sm=Instance.new("ModuleScript")
    sm.Name="InteriorEditorV36"
    sm.Source=editorServerSource
    sm.Parent=runtime
    cm=Instance.new("ModuleScript")
    cm.Name="InteriorEditorClientV36"
    cm.Source=editorClientSource
    cm.Parent=ui
    oldBuild.Source=revisedB
    runtime.Source=revisedR
    ui.Source=revisedC
    runtime:SetAttribute("KC36InteriorEditorRevision","KC36-INTERIOR-EDITOR-1")
end)
if not ok then
    pcall(function() runtime.Source=oldR;ui.Source=oldC;oldBuild.Source=oldB end)
    if sm then sm:Destroy() end
    if cm then cm:Destroy() end
    runtime:SetAttribute("KC36InteriorEditorRevision",nil)
    error("KC36 Atelier : installation annulee, sources restaurees : "..tostring(reason))
end
print("========== KC36 ATELIER INTERIEUR ==========")
print("Editeur objets entiers : deplacer / dupliquer / effacer / annuler / retablir")
print("L'ancien editeur ne peut plus modifier les interieurs")
print("Place de production :",game.PlaceId)
print("Bibliotheque Art Deco : 121/121 conservee")
print("Backup : ServerStorage.KC36InteriorEditorBackup_v1")
print("PASS KC36 ATELIER INTERIEUR INSTALLE")
print("Ctrl+S puis Play : entrer dans un batiment et ouvrir ATELIER")
