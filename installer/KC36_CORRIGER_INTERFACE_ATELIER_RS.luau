-- KC36 : REPARATION DEFINITIVE DE LA LISIBILITE DE L'ATELIER
-- Place publiee Kin City / Command Bar en mode Edition, Play arrete.
-- Ne change que KinCityMenu et InteriorEditorClientV36 (UI uniquement).
local Run=game:GetService("RunService")
local SS=game:GetService("ServerStorage")
local Starter=game:GetService("StarterPlayer")
assert(Run:IsStudio() and not Run:IsRunning(),"Arreter Play avant la modification")
assert(game.PlaceId==72097868581669,"Ouvrir la Place principale Kin City dans Studio")
local scripts=Starter:WaitForChild("StarterPlayerScripts")
local ui=assert(scripts:FindFirstChild("KinCityUI"),"KinCityUI introuvable")
local menu=assert(ui:FindFirstChild("KinCityMenu"),"KinCityMenu introuvable")
local atelier=assert(ui:FindFirstChild("InteriorEditorClientV36"),"InteriorEditorClientV36 introuvable")
assert(menu:IsA("ModuleScript") and atelier:IsA("ModuleScript"),"Modules client invalides")
local REV="KC36-ATELIER-UI-V2"
if atelier:GetAttribute("KinAtelierUIRevision")==REV then
    print("KC36 ATELIER UI V2 deja installee : aucun changement")
    return
end
local oldMenu=menu.Source
local oldAtelier=atelier.Source
assert(oldMenu:find("function Menu.register",1,true),"Menu general inattendu")
assert(oldAtelier:find("SÉLECTION ON/OFF",1,true),"Atelier d'origine inattendu")
local beforeA='    local viewport=workspace.CurrentCamera\n    local normalWidth=math.max(window.Size.X.Offset,240)'
local beforeB='    if viewport then viewport:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end\n    local b=makeButton(items,label,38)'
assert(oldMenu:find(beforeA,1,true),"Ancre initiale du menu differente : ne rien modifier")
assert(oldMenu:find(beforeB,1,true),"Ancre finale du menu differente : ne rien modifier")
local function replaceExactlyOnce(src,old,new)
    local _,count=src:gsub(old:gsub("([^%w])","%%%1"),"")
    assert(count==1,"Ancre ambigue ou introuvable")
    return src:gsub(old:gsub("([^%w])","%%%1"),function()return new end,1)
end
local newMenu=replaceExactlyOnce(oldMenu,beforeA,
    '    -- KC36_NATIVE_WINDOW_LAYOUT_V2 : respecter la mise en page native des grands outils.\n'..
    '    if window:GetAttribute("KinUseNativeWindowLayout")~=true then\n'..beforeA)
newMenu=replaceExactlyOnce(newMenu,beforeB,
    '    if viewport then viewport:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end\n'..
    '    end -- Tous les autres menus conservent leur presentation v30.\n'..
    '    local b=makeButton(items,label,38)')
local sourceAtelier=[==========[
--!strict
-- KC36 ATELIER INTERIEUR V2: interface lisible, adaptee a l'ecran, sans double scroll.
-- Le serveur conserve l'autorite sur selection, permissions et mutations de meubles.
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
local selectButton:TextButton
local active=false
local mark:Highlight
local confirming=false

local BG=Color3.fromRGB(18,43,46)
local SURFACE=Color3.fromRGB(28,75,75)
local PRIMARY=Color3.fromRGB(32,112,106)
local BRASS=Color3.fromRGB(211,170,104)
local IVORY=Color3.fromRGB(247,243,224)
local MUTED=Color3.fromRGB(194,220,215)
local WARNING=Color3.fromRGB(242,188,127)

local function corner(parent:Instance,r:number)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=parent
end
local function border(parent:Instance,color:Color3,thickness:number)
    local line=Instance.new("UIStroke")
    line.Color=color;line.Thickness=thickness;line.Transparency=0.18
    line.Parent=parent
end
local function label(parent:Instance,message:string,height:number,fontSize:number,color:Color3,bold:boolean?):TextLabel
    local l=Instance.new("TextLabel")
    l.Name="Texte"
    l.Size=UDim2.new(1,-4,0,height)
    l.BackgroundTransparency=1
    l.Text=message;l.TextWrapped=true
    l.Font=if bold then Enum.Font.GothamBold else Enum.Font.Gotham
    l.TextSize=fontSize;l.TextColor3=color
    l.TextXAlignment=Enum.TextXAlignment.Left
    l.TextYAlignment=Enum.TextYAlignment.Center
    l.Parent=parent
    return l
end
local function button(parent:Instance,message:string,callback:()->(),tone:string?):TextButton
    local b=Instance.new("TextButton")
    b.Name=message
    b.Text=message;b.TextSize=15;b.TextScaled=false;b.TextWrapped=true
    b.BackgroundColor3=if tone=="danger" then Color3.fromRGB(124,61,53) else PRIMARY
    b.TextColor3=IVORY;b.Font=Enum.Font.GothamBold
    b.AutoButtonColor=true
    b.Size=UDim2.new(1,0,1,0);b.Parent=parent
    corner(b,7)
    b.Activated:Connect(callback)
    return b
end
local function commandRow(parent:Instance,items:{any}):Frame
    local r=Instance.new("Frame")
    r.Name="Ligne de commandes"
    r.Size=UDim2.new(1,-5,0,46)
    r.BackgroundTransparency=1
    r.Parent=parent
    local layout=Instance.new("UIListLayout")
    layout.FillDirection=Enum.FillDirection.Horizontal
    layout.HorizontalAlignment=Enum.HorizontalAlignment.Center
    layout.Padding=UDim.new(0,9)
    layout.SortOrder=Enum.SortOrder.LayoutOrder
    layout.Parent=r
    for i,item in ipairs(items) do
        local b=button(r,item[1],item[2],item[3])
        b.LayoutOrder=i
        b.Size=UDim2.new(1/#items,-9,1,0)
    end
    return r
end
local function call(verb:string,key:any?,detail:any?):any
    if not rpc or not rpc.Parent then
        local candidate=RS:FindFirstChild("KinCityInteriorEditV36")
        if candidate and candidate:IsA("RemoteFunction") then rpc=candidate end
    end
    if not rpc then
        feedback.Text="Serveur Atelier indisponible : regarde Output."
        feedback.TextColor3=WARNING
        return nil
    end
    local ok,result=pcall(function() return rpc:InvokeServer(verb,key,detail) end)
    if not ok then
        feedback.Text="Connexion indisponible. Réessaie."
        feedback.TextColor3=WARNING
        return nil
    end
    if not result or not result.ok then
        feedback.Text=(result and result.message) or "Action refusée"
        feedback.TextColor3=WARNING
        return nil
    end
    feedback.Text=result.message or "Action réussie"
    feedback.TextColor3=MUTED
    return result
end
local function repaint()
    if not selected then
        selectionLabel.Text="Aucun meuble sélectionné. Active SÉLECTION puis clique sur un meuble."
        mark.Adornee=nil
        return
    end
    selectionLabel.Text=string.format("%s  •  X %.1f   Y %.1f   Z %.1f",
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
    if not selected then
        feedback.Text="Sélectionne d'abord un meuble dans l'intérieur."
        feedback.TextColor3=WARNING
        return
    end
    update(call(verb,selected.id,detail))
end
local function pick(screen:Vector2):BasePart?
    local camera=Workspace.CurrentCamera
    local generated=Workspace:FindFirstChild("KinCityGenerated")
    local interiors=generated and generated:FindFirstChild("Bâtiments visitables")
    if not camera or not interiors then return nil end
    local ray=camera:ScreenPointToRay(screen.X,screen.Y)
    local params=RaycastParams.new()
    params.FilterType=Enum.RaycastFilterType.Include
    params.FilterDescendantsInstances={interiors}
    local hit=Workspace:Raycast(ray.Origin,ray.Direction*250,params)
    return hit and hit.Instance or nil
end
local function insidePanel(point:Vector2):boolean
    local pos=panel.AbsolutePosition
    local size=panel.AbsoluteSize
    return point.X>=pos.X and point.X<=pos.X+size.X
        and point.Y>=pos.Y and point.Y<=pos.Y+size.Y
end
local function toggleSelection()
    active=not active
    confirming=false
    selectButton.Text=if active then "SÉLECTION : ACTIVE ✓" else "SÉLECTION : ACTIVER"
    selectButton.BackgroundColor3=if active then Color3.fromRGB(135,89,48) else PRIMARY
    feedback.Text=if active then "Clique sur un meuble dans la pièce." else "Sélection désactivée."
    feedback.TextColor3=MUTED
end

function Client.start()
    local playerGui=player:WaitForChild("PlayerGui")
    if playerGui:FindFirstChild("KC36AtelierInterieur") then return end

    local ui=Instance.new("ScreenGui")
    ui.Name="KC36AtelierInterieur"
    ui.ResetOnSpawn=false
    ui.DisplayOrder=28
    ui.Parent=playerGui

    panel=Instance.new("Frame")
    panel.Name="ATELIER INTERIEUR"
    panel:SetAttribute("KinUseNativeWindowLayout",true)
    panel.AnchorPoint=Vector2.new(1,0)
    panel.Position=UDim2.new(1,-16,0,88)
    panel.Size=UDim2.fromOffset(448,750)
    panel.BackgroundColor3=BG
    panel.BorderSizePixel=0
    panel.Visible=false
    panel.Parent=ui
    corner(panel,12)
    border(panel,BRASS,1.6)

    local heading=Instance.new("Frame")
    heading.Name="En-tete fixe"
    heading.Position=UDim2.fromOffset(15,8)
    heading.Size=UDim2.new(1,-70,0,55)
    heading.BackgroundTransparency=1
    heading.Parent=panel
    local hTitle=label(heading,"ATELIER INTÉRIEUR",28,20,IVORY,true)
    hTitle.Position=UDim2.fromOffset(0,0)
    local hDetail=label(heading,"Édition de meubles entiers · KC36",20,12,MUTED)
    hDetail.Position=UDim2.fromOffset(0,30)

    local statusFrame=Instance.new("Frame")
    statusFrame.Name="Statut fixe"
    statusFrame.Position=UDim2.fromOffset(12,68)
    statusFrame.Size=UDim2.new(1,-24,0,88)
    statusFrame.BackgroundColor3=SURFACE
    statusFrame.Parent=panel
    corner(statusFrame,8)
    feedback=label(statusFrame,"Entre dans une institution pour aménager son mobilier.",40,14,MUTED)
    feedback.Position=UDim2.fromOffset(10,3)
    feedback.Size=UDim2.new(1,-20,0,40)
    selectionLabel=label(statusFrame,"Aucun meuble sélectionné.",39,13,IVORY,true)
    selectionLabel.Position=UDim2.fromOffset(10,45)
    selectionLabel.Size=UDim2.new(1,-20,0,40)

    local scroll=Instance.new("ScrollingFrame")
    scroll.Name="Commandes lisibles"
    scroll.Position=UDim2.fromOffset(15,164)
    scroll.Size=UDim2.new(1,-30,1,-177)
    scroll.BackgroundTransparency=1
    scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=7
    scroll.ScrollBarImageColor3=BRASS
    scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.CanvasSize=UDim2.fromOffset(0,0)
    scroll.ScrollingDirection=Enum.ScrollingDirection.Y
    scroll.Parent=panel

    local stack=Instance.new("UIListLayout")
    stack.SortOrder=Enum.SortOrder.LayoutOrder
    stack.Padding=UDim.new(0,8)
    stack.Parent=scroll
    local order=0
    local function nextOrder(object:GuiObject)
        order+=1
        object.LayoutOrder=order
        return object
    end
    local function headingSmall(message:string)
        local header=nextOrder(label(scroll,message,25,14,BRASS,true))
        header.Name=message
    end
    local selectionRow=nextOrder(commandRow(scroll,{{"SÉLECTION : ACTIVER",toggleSelection}}))
    selectButton=selectionRow:FindFirstChildWhichIsA("TextButton") :: TextButton
    headingSmall("DÉPLACER · pas de 0,5 stud")
    nextOrder(commandRow(scroll,{{"←  X −0,5",function() action("move",{-0.5,0,0}) end},
        {"X +0,5  →",function() action("move",{0.5,0,0}) end}}))
    nextOrder(commandRow(scroll,{{"↑  Z −0,5",function() action("move",{0,0,-0.5}) end},
        {"Z +0,5  ↓",function() action("move",{0,0,0.5}) end}}))
    nextOrder(commandRow(scroll,{{"MONTER  +0,5",function() action("move",{0,0.5,0}) end},
        {"DESCENDRE  −0,5",function() action("move",{0,-0.5,0}) end}}))
    nextOrder(commandRow(scroll,{{"↶  −15°",function() action("rotate",-15) end},
        {"+15°  ↷",function() action("rotate",15) end}}))
    headingSmall("OBJETS · modifications complètes")
    nextOrder(commandRow(scroll,{{"DUPLIQUER",function() action("duplicate") end},
        {"EFFACER",function()
            if not selected then
                feedback.Text="Sélectionne d'abord un meuble."
                feedback.TextColor3=WARNING
                return
            end
            if not confirming then
                confirming=true
                feedback.Text="Confirmer : appuie encore sur EFFACER"
                feedback.TextColor3=WARNING
                return
            end
            action("delete")
        end,"danger"}}))
    nextOrder(commandRow(scroll,{{"ANNULER",function() update(call("undo")) end},
        {"RÉTABLIR",function() update(call("redo")) end}}))
    nextOrder(label(scroll,"Meubles libres uniquement. Murs, planchers, portes et objets interactifs sont protégés.",49,13,MUTED))

    mark=Instance.new("Highlight")
    mark.Name="KC36MeubleSelectionne"
    mark.FillColor=Color3.fromRGB(197,244,240)
    mark.FillTransparency=0.80
    mark.OutlineColor=BRASS
    mark.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    mark.Parent=Workspace.CurrentCamera or ui

    -- Le menu cree seulement Fermer et une entree de navigation ; il ne recadre
    -- ni ne double-scrolle cette fenetre (attribut KinUseNativeWindowLayout).
    Menu.register("interior_editor","ATELIER • Modifier l'intérieur",nil,panel)
    local function resize()
        local camera=Workspace.CurrentCamera
        local v=if camera then camera.ViewportSize else Vector2.new(1280,720)
        local top=if v.Y<620 then 48 else 88
        local w=math.min(448,math.max(200,v.X-18))
        local h=math.min(770,math.max(260,v.Y-top-14))
        panel.Size=UDim2.fromOffset(w,h)
        panel.Position=UDim2.new(1,-9,0,top)
    end
    resize()
    local camera=Workspace.CurrentCamera
    if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(resize) end
    panel:GetPropertyChangedSignal("Visible"):Connect(function()
        if panel.Visible then
            local result=call("status")
            if result then
                feedback.Text=(result.message or "").." · "..(
                    if result.persistent then "Sauvegarde en ligne" else result.warning or "Session temporaire")
                feedback.TextColor3=MUTED
            end
        else
            active=false;confirming=false
            selectButton.Text="SÉLECTION : ACTIVER"
            selectButton.BackgroundColor3=PRIMARY
            mark.Adornee=nil
        end
    end)
    UIS.InputBegan:Connect(function(input,processed)
        if not active or not panel.Visible or processed then return end
        local screen:Vector2?=nil
        if input.UserInputType==Enum.UserInputType.MouseButton1 then
            screen=UIS:GetMouseLocation()
        elseif input.UserInputType==Enum.UserInputType.Touch then
            screen=Vector2.new(input.Position.X,input.Position.Y)
        elseif input.KeyCode==Enum.KeyCode.ButtonR2 then
            local current=Workspace.CurrentCamera
            if current then screen=current.ViewportSize/2 end
        end
        if not screen or insidePanel(screen) then return end
        update(call("select",pick(screen)))
    end)
    print("KC36 ATELIER UI V2 : panneau lateral lisible")
end
return Client
]==========]
local backupName="KC36AtelierUILayoutBackup_v2"
assert(not SS:FindFirstChild(backupName),"Backup UI V2 existant : inspection requise")
local backup=Instance.new("Folder")
backup.Name=backupName
backup:SetAttribute("KinUIRevision",REV)
local function saveOriginal(name,source)
    local v=Instance.new("StringValue")
    v.Name=name;v.Value=source;v.Parent=backup
end
saveOriginal("KinCityMenu_Original",oldMenu)
saveOriginal("InteriorEditorClientV36_Original",oldAtelier)
backup.Parent=SS
local ok,err=pcall(function()
    menu.Source=newMenu
    atelier.Source=sourceAtelier
    atelier:SetAttribute("KinAtelierUIRevision",REV)
end)
if not ok then
    pcall(function()menu.Source=oldMenu;atelier.Source=oldAtelier end)
    atelier:SetAttribute("KinAtelierUIRevision",nil)
    error("KC36 UI V2 annulee : "..tostring(err))
end
print("========== KC36 ATELIER UI V2 ==========")
print("Menu Kin City : layout natif pris en charge")
print("Atelier : panneau lateral 448 px, commandes lisibles et defilement unique")
print("Actions conservees : selection / mouvement XYZ / rotation / copier / supprimer / annuler / retablir")
print("Serveur, DataStore, portes, PNJ et Art Deco : inchanges")
print("Backup : ServerStorage."..backupName)
print("PASS KC36 ATELIER UI V2")
print("Ctrl+S -> Play -> entrer dans la bibliotheque -> menu ATELIER")
