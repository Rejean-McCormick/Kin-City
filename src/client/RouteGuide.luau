--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Guide de lieux : panneau cliquable et indication d'azimut / distance.
-- Fonctionne même sans kOA, sans accès HTTP et sans serveur RemoteEvent.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local RunService=game:GetService("RunService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared:WaitForChild("WorldPlan"))
local Buildings=require(Shared:WaitForChild("Buildings"))
local PublicDestinations=require(Shared:WaitForChild("PublicDestinations"))
local IslandDestinations=require(Shared:WaitForChild("IslandDestinations"))
local MarinaDestinations=require(Shared:WaitForChild("MarinaDestinations"))
local ResidentialDestinations=require(Shared:WaitForChild("ResidentialDestinations"))
local CommunityDestinations=require(Shared:WaitForChild("CommunityDestinations"))
local IntermodalNetwork=require(Shared:WaitForChild("IntermodalNetwork"))
local CivicDestinations=require(Shared:WaitForChild("CivicDestinations"))
local PromenadeCommerce=require(Shared:WaitForChild("PromenadeCommerce"))
local UrbanV14Destinations=require(Shared:WaitForChild("UrbanV14Destinations"))
local player=Players.LocalPlayer
local Guide={}
local colors={background=Color3.fromRGB(24,46,57),card=Color3.fromRGB(38,72,79),highlight=Color3.fromRGB(72,132,129),text=Color3.fromRGB(244,242,227)}
local function rounded(parent,r)
    local c=Instance.new("UICorner");c.CornerRadius=UDim.new(0,r);c.Parent=parent
end
local function text(parent,value,size,position,bold)
    local l=Instance.new("TextLabel")
    l.BackgroundTransparency=1;l.Text=value;l.TextWrapped=true
    l.Font=bold and Typography.body() or Typography.body()
    l.TextColor3=colors.text;l.TextSize=bold and 16 or 13
    l.Size=size;l.Position=position;l.TextXAlignment=Enum.TextXAlignment.Left
    l.Parent=parent
    return l
end
local pathsByBuilding={}
for _,walk in ipairs(Plan.pedestrian_paths) do pathsByBuilding[walk.building_id]=walk end
-- Projection sur un segment du parcours public : distance restant sur les virages,
-- sans traverser fictivement les obstacles en ligne droite.
local function directionForWalk(playerPosition,path)
    if not path or #path.path_xyz_studs<2 then return nil,math.huge,nil end
    local points=path.path_xyz_studs
    local nearest=math.huge
    local remaining=nil
    local nextTarget=nil
    local after={}
    after[#points]=0
    for i=#points-1,1,-1 do
        local a,b=points[i],points[i+1]
        local segmentLength=math.sqrt((b[1]-a[1])^2+(b[3]-a[3])^2)
        after[i]=after[i+1]+segmentLength
    end
    for i=2,#points do
        local a=Vector3.new(points[i-1][1],playerPosition.Y,points[i-1][3])
        local b=Vector3.new(points[i][1],playerPosition.Y,points[i][3])
        local segment=b-a
        local lengthSq=segment:Dot(segment)
        if lengthSq>0.1 then
            local t=math.clamp((playerPosition-a):Dot(segment)/lengthSq,0,1)
            local projected=a+segment*t
            local gap=(projected-playerPosition).Magnitude
            if gap<nearest then
                nearest=gap
                local index=i
                if (b-playerPosition).Magnitude<8 and i<#points then index=i+1 end
                -- Écart important : guider d'abord vers le sentier, pas à travers un virage.
                nextTarget=if gap>18 then projected else Vector3.new(points[index][1],playerPosition.Y,points[index][3])
                remaining=gap+(1-t)*math.sqrt(lengthSq)+after[i]
            end
        end
    end
    return nextTarget,nearest,remaining
end

local names={}
for _,b in ipairs(Buildings) do names[b.building_id]=b.name end
local sorted={}
for _,st in ipairs(Plan.structures) do table.insert(sorted,st) end
-- Six destinations génériques correspondent aux six avenues réellement bâties.
for _,sector in ipairs(require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("HexagonalDistricts")).sections) do
    local id="koali.secteur."..sector.key
    names[id]=sector.name
    table.insert(sorted,{building_id=id,center_studs={sector.x*155,0,sector.z*155},isPublicAttraction=true})
end
-- Les marques, les rues et les institutions affichées existent dans la scène.
table.sort(sorted,function(a,b)
    return (names[a.building_id] or a.building_id)<(names[b.building_id] or b.building_id)
end)
local function createButton(parent,title,y)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-20,0,40);b.Position=UDim2.fromOffset(10,y)
    b.BackgroundColor3=colors.card;b.Font=Typography.body()
    b.TextColor3=colors.text;b.TextSize=13;b.TextWrapped=true
    b.Text=title;b.Parent=parent;rounded(b,7)
    return b
end
function Guide.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityGuide"
    gui.ResetOnSpawn=false
    gui.IgnoreGuiInset=false
    gui.DisplayOrder=8
    gui.Parent=player:WaitForChild("PlayerGui")
    local toggle=Instance.new("TextButton")
    toggle.Name="GuideToggle"
    toggle.Size=UDim2.fromOffset(120,39)
    toggle.Position=UDim2.new(0,17,0,92)
    toggle.BackgroundColor3=colors.card
    toggle.Text="LIEUX [N]"
    toggle.Font=Typography.body()
    toggle.TextColor3=colors.text
    toggle.TextSize=13
    toggle.Parent=gui;rounded(toggle,8)
    local panel=Instance.new("Frame")
    panel.Size=UDim2.fromOffset(300,456)
    panel.Position=UDim2.fromOffset(15,141)
    panel.BackgroundColor3=colors.background
    panel.Visible=false;panel.Parent=gui;rounded(panel,12)
    local heading=text(panel,"DESTINATIONS",UDim2.new(1,-20,0,32),UDim2.fromOffset(12,11),true)
    local selected=nil
    local buttons={}
    local search=Instance.new("TextBox")
    search.Name="Rechercher une destination"
    search.PlaceholderText="Rechercher un lieu…"
    search.Text="";search.ClearTextOnFocus=false
    search.TextColor3=colors.text;search.PlaceholderColor3=Color3.fromRGB(178,208,203)
    search.BackgroundColor3=colors.card;search.Font=Typography.body()
    search.TextSize=14;search.Size=UDim2.new(1,-22,0,36)
    search.Position=UDim2.fromOffset(11,47);search.Parent=panel;rounded(search,7)
    local list=Instance.new("ScrollingFrame")
    list.BackgroundTransparency=1
    list.BorderSizePixel=0
    list.Position=UDim2.fromOffset(0,91)
    list.Size=UDim2.new(1,0,1,-165)
    list.ScrollBarThickness=5
    list.ScrollBarImageColor3=colors.highlight
    list.CanvasSize=UDim2.fromOffset(0,#sorted*48+7)
    list.Parent=panel
    local status=text(panel,"",UDim2.new(1,-26,0,38),UDim2.new(0,13,1,-69),false)
    local clear=Instance.new("TextButton")
    clear.Name="Annuler la destination";clear.Text="✕  Effacer la destination"
    clear.Size=UDim2.new(1,-26,0,27);clear.Position=UDim2.new(0,13,1,-29)
    clear.BackgroundColor3=colors.card;clear.TextColor3=colors.text
    clear.TextSize=12;clear.Font=Typography.body();clear.Parent=panel;rounded(clear,6)
    local guidance=Instance.new("Frame")
    guidance.Name="Direction"
    guidance.BackgroundColor3=colors.background
    guidance.BackgroundTransparency=0.1
    guidance.Size=UDim2.new(0,280,0,47)
    guidance.Position=UDim2.new(0.5,-140,0,15)
    guidance.Parent=gui;guidance.Visible=false;rounded(guidance,11)
    local navLabel=text(guidance,"",UDim2.new(1,-20,1,-8),UDim2.fromOffset(10,4),false)
    navLabel.TextSize=13
    local dismiss=Instance.new("TextButton")
    dismiss.Name="Masquer le guide";dismiss.Text="✕";dismiss.Font=Typography.body()
    dismiss.TextColor3=colors.text;dismiss.BackgroundColor3=colors.card
    dismiss.Size=UDim2.fromOffset(30,29);dismiss.Position=UDim2.new(1,-33,0,8)
    dismiss.Parent=guidance;rounded(dismiss,7)
    navLabel.Size=UDim2.new(1,-51,1,-8)
    local function clearDestination()
        selected=nil
        if player:GetAttribute("KinGuideMode")=="route" then player:SetAttribute("KinGuideMode","none") end
        guidance.Visible=false
        for _,item in ipairs(buttons) do item.BackgroundColor3=colors.card end
    end
    dismiss.Activated:Connect(clearDestination)
    clear.Activated:Connect(clearDestination)
    for i,st in ipairs(sorted) do
        local b=createButton(list,names[st.building_id] or st.building_id,5+(i-1)*47)
        buttons[i]=b
        b.Activated:Connect(function()
            selected=st
            player:SetAttribute("KinGuideMode","route")
            for j,button in ipairs(buttons) do
                button.BackgroundColor3=j==i and colors.highlight or colors.card
            end
            panel.Visible=false
            guidance.Visible=true
        end)
    end
    local filteredCount=#buttons
    local function updateResults()
        local query=string.lower(search.Text)
        local visible=0
        for i,st in ipairs(sorted) do
            local caption=names[st.building_id] or st.building_id
            local match=query=="" or string.find(string.lower(caption),query,1,true)~=nil
                or string.find(string.lower(st.building_id),query,1,true)~=nil
            buttons[i].Visible=match
            if match then
                buttons[i].Position=UDim2.fromOffset(10,5+visible*47)
                visible+=1
            end
        end
        filteredCount=visible
        list.CanvasSize=UDim2.fromOffset(0,visible*47+10)
        status.Text=if visible==0 then "Aucune destination trouvée." else "8 institutions en tête · Choisir une destination."
    end
    search:GetPropertyChangedSignal("Text"):Connect(updateResults)
    updateResults()
    navLabel.Text="Bienvenue · Bibliothèque : première visite facultative"
    local function togglePanel()
        panel.Visible=not panel.Visible
        if panel.Visible then guidance.Visible=selected~=nil and player:GetAttribute("KinGuideMode")=="route" end
    end
    toggle.Activated:Connect(togglePanel)
    require(script.Parent.KinCityMenu).register("destinations","Destinations [N]",toggle,panel,togglePanel)
    UIS.InputBegan:Connect(function(input,processed)
        if processed then return end
        if input.KeyCode==Enum.KeyCode.N then togglePanel() end
    end)
    local elapsed=0
    RunService.RenderStepped:Connect(function(dt)
        elapsed+=dt
        if elapsed<0.25 then return end
        elapsed=0
        local current=player:GetAttribute("KinZone") or "city"
        guidance.Visible=selected~=nil and player:GetAttribute("KinGuideMode")=="route" and current=="city"
        if not selected then
            status.Text=if filteredCount==0 then "Aucune destination trouvée." else "Choisis un lieu ou la première visite facultative."
            return
        end
        if current~="city" then
            navLabel.Text="INTÉRIEUR · Parcours libre"
            status.Text="Reviens à l'extérieur pour suivre une destination."
            return
        end
        local char=player.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local p=root.Position
        local destination=Vector3.new(selected.center_studs[1],p.Y,selected.center_studs[3])
        local distance=(destination-p).Magnitude
        local waypoint,pathGap,routeRemaining=directionForWalk(p,pathsByBuilding[selected.building_id])
        local target=waypoint or destination
        local delta=target-p
        local bearing=math.deg(math.atan2(delta.X,-delta.Z))%360
        local cardinal=if bearing<45 or bearing>=315 then "N" elseif bearing<135 then "E" elseif bearing<225 then "S" else "O"
        local name=names[selected.building_id] or "Destination"
        local remaining=routeRemaining or distance
        local arrived=if routeRemaining then remaining<14 and pathGap<16 else distance<19
        if arrived then
            navLabel.Text="ARRIVÉE · "..name
            status.Text=if selected.isResidential then "Bienvenue dans le quartier habité !" elseif selected.isIsland then "Bienvenue sur l’île !" elseif selected.isMarina then "Bienvenue au port !" elseif selected.isCommunity then "Bienvenue dans l’espace public !" elseif selected.isPublicAttraction then "Tu es à proximité de ce lieu public." else "Tu es près de l'entrée de l’institution."
        else
            navLabel.Text=string.format("%s · %d studs %s",name,math.floor(remaining+0.5),cardinal)
            status.Text=if selected.isResidential then "Rejoins les cours habitées • direction "..math.floor(bearing).."°" elseif selected.isIsland then "Rejoins une passerelle ou un ferry • direction "..math.floor(bearing).."°" elseif selected.isMarina then "Rejoins la promenade côtière • direction "..math.floor(bearing).."°" elseif selected.isCommunity then "Rejoins la halle ou la maison communautaire • direction "..math.floor(bearing).."°" elseif selected.isPublicAttraction then "Rejoins ce lieu public • direction "..math.floor(bearing).."°" elseif pathGap>30 then "Rejoins le sentier balisé · "..math.floor(pathGap).." studs" elseif routeRemaining then "Distance sur le chemin · direction "..math.floor(bearing).."°" else "Distance directe indicative · direction "..math.floor(bearing).."°"
        end
    end)
end
return Guide
