--!strict
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
    l.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    l.TextColor3=colors.text;l.TextSize=bold and 16 or 13
    l.Size=size;l.Position=position;l.TextXAlignment=Enum.TextXAlignment.Left
    l.Parent=parent
    return l
end
local pathsByBuilding={}
for _,walk in ipairs(Plan.pedestrian_paths) do pathsByBuilding[walk.building_id]=walk end
local function directionForWalk(playerPosition,path)
    if not path then return nil,math.huge end
    local points=path.path_xyz_studs
    local bestDistance=math.huge
    local nextTarget=nil
    for i=2,#points do
        local a=Vector3.new(points[i-1][1],playerPosition.Y,points[i-1][3])
        local b=Vector3.new(points[i][1],playerPosition.Y,points[i][3])
        local segment=b-a
        local lengthSq=segment:Dot(segment)
        if lengthSq>0.1 then
            local t=math.clamp((playerPosition-a):Dot(segment)/lengthSq,0,1)
            local near=a+segment*t
            local dist=(near-playerPosition).Magnitude
            if dist<bestDistance then
                bestDistance=dist
                local pointIndex=i
                if (b-playerPosition).Magnitude<8 and i<#points then pointIndex=i+1 end
                nextTarget=Vector3.new(points[pointIndex][1],playerPosition.Y,points[pointIndex][3])
            end
        end
    end
    return nextTarget,bestDistance
end
local names={}
for _,b in ipairs(Buildings) do names[b.building_id]=b.name end
local sorted={}
for _,st in ipairs(Plan.structures) do table.insert(sorted,st) end
for _,public in ipairs(PublicDestinations) do
    names[public.id]=public.title
    table.insert(sorted,{building_id=public.id,center_studs=public.center_studs,isPublicAttraction=true})
end
for _,island in ipairs(IslandDestinations) do
    names[island.id]=island.title
    table.insert(sorted,{building_id=island.id,center_studs=island.center_studs,isPublicAttraction=true,isIsland=true})
end
for _,marina in ipairs(MarinaDestinations) do
    names[marina.id]=marina.title
    table.insert(sorted,{building_id=marina.id,center_studs=marina.center_studs,isPublicAttraction=true,isMarina=true})
end
for _,quarter in ipairs(ResidentialDestinations) do
    names[quarter.id]=quarter.title
    table.insert(sorted,{building_id=quarter.id,center_studs=quarter.center_studs,isPublicAttraction=true,isResidential=true})
end
for _,place in ipairs(CommunityDestinations) do
    names[place.id]=place.title
    table.insert(sorted,{building_id=place.id,center_studs=place.center_studs,isPublicAttraction=true,isCommunity=true})
end
local hub=IntermodalNetwork.hub
names[hub.id]=hub.title
table.insert(sorted,{building_id=hub.id,center_studs=hub.center_studs,isPublicAttraction=true})
for _,stage in ipairs(CivicDestinations) do
    names[stage.id]=stage.title
    table.insert(sorted,{building_id=stage.id,center_studs=stage.center_studs,isPublicAttraction=true})
end
for _,shop in ipairs(PromenadeCommerce) do
    names[shop.id]=shop.title.." · Promenade des métiers"
    table.insert(sorted,{building_id=shop.id,center_studs=shop.center_studs,isPublicAttraction=true})
end
for _,shop in ipairs(UrbanV14Destinations.arcades) do
    names[shop.id]=shop.title.." · Galeries de la gare"
    table.insert(sorted,{building_id=shop.id,center_studs=shop.center_studs,isPublicAttraction=true})
end
for _,workshop in ipairs(UrbanV14Destinations.workshops) do
    names[workshop.id]=workshop.title.." · Trois étapes"
    table.insert(sorted,{building_id=workshop.id,center_studs=workshop.center_studs,isPublicAttraction=true})
end
table.sort(sorted,function(a,b)return a.building_id<b.building_id end)
local function createButton(parent,title,y)
    local b=Instance.new("TextButton")
    b.Size=UDim2.new(1,-20,0,40);b.Position=UDim2.fromOffset(10,y)
    b.BackgroundColor3=colors.card;b.Font=Enum.Font.GothamMedium
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
    toggle.Font=Enum.Font.GothamBold
    toggle.TextColor3=colors.text
    toggle.TextSize=13
    toggle.Parent=gui;rounded(toggle,8)
    local panel=Instance.new("Frame")
    panel.Size=UDim2.new(0,294,0,437)
    panel.Position=UDim2.fromOffset(15,141)
    panel.BackgroundColor3=colors.background
    panel.Visible=false;panel.Parent=gui;rounded(panel,12)
    local heading=text(panel,"DESTINATIONS",UDim2.new(1,-20,0,32),UDim2.fromOffset(12,11),true)
    local selected=sorted[1]
    local buttons={}
    local list=Instance.new("ScrollingFrame")
    list.BackgroundTransparency=1
    list.BorderSizePixel=0
    list.Position=UDim2.fromOffset(0,48)
    list.Size=UDim2.new(1,0,1,-104)
    list.ScrollBarThickness=5
    list.ScrollBarImageColor3=colors.highlight
    list.CanvasSize=UDim2.fromOffset(0,#sorted*48+7)
    list.Parent=panel
    local status=text(panel,"",UDim2.new(1,-26,0,49),UDim2.new(0,13,1,-54),false)
    local guidance=Instance.new("Frame")
    guidance.Name="Direction"
    guidance.BackgroundColor3=colors.background
    guidance.BackgroundTransparency=0.1
    guidance.Size=UDim2.new(0,280,0,47)
    guidance.Position=UDim2.new(0.5,-140,0,15)
    guidance.Parent=gui;rounded(guidance,11)
    local navLabel=text(guidance,"",UDim2.new(1,-20,1,-8),UDim2.fromOffset(10,4),false)
    navLabel.TextSize=13
    for i,st in ipairs(sorted) do
        local b=createButton(list,names[st.building_id] or st.building_id,5+(i-1)*47)
        buttons[i]=b
        b.Activated:Connect(function()
            selected=st
            for j,button in ipairs(buttons) do
                button.BackgroundColor3=j==i and colors.highlight or colors.card
            end
            panel.Visible=false
        end)
    end
    buttons[1].BackgroundColor3=colors.highlight
    local function togglePanel()panel.Visible=not panel.Visible end
    toggle.Activated:Connect(togglePanel)
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
        local waypoint,pathGap=directionForWalk(p,pathsByBuilding[selected.building_id])
        local target=waypoint or destination
        local delta=target-p
        local bearing=math.deg(math.atan2(delta.X,-delta.Z))%360
        local cardinal=if bearing<45 or bearing>=315 then "N" elseif bearing<135 then "E" elseif bearing<225 then "S" else "O"
        local name=names[selected.building_id] or "Institution"
        if distance<19 then
            navLabel.Text="ARRIVÉE · "..name
            status.Text=if selected.isResidential then "Bienvenue dans le quartier habité !" elseif selected.isIsland then "Bienvenue sur l’île !" elseif selected.isMarina then "Bienvenue au port !" elseif selected.isCommunity then "Bienvenue dans l’espace public !" elseif selected.isPublicAttraction then "Tu es au pavillon scientifique." else "Tu es à proximité de l’institution."
        else
            navLabel.Text=string.format("%s · %d studs %s",name,math.floor(distance+0.5),cardinal)
            status.Text=if selected.isResidential then "Rejoins les cours habitées • direction "..math.floor(bearing).."°" elseif selected.isIsland then "Rejoins une passerelle ou un ferry • direction "..math.floor(bearing).."°" elseif selected.isMarina then "Rejoins la promenade côtière • direction "..math.floor(bearing).."°" elseif selected.isCommunity then "Rejoins la halle ou la maison communautaire • direction "..math.floor(bearing).."°" elseif selected.isPublicAttraction then "Explore le pavillon • direction "..math.floor(bearing).."°" elseif pathGap>30 then "Rejoins le sentier balisé · "..math.floor(pathGap).." studs" else "Suis le jalonnement doré · direction "..math.floor(bearing).."°"
        end
    end)
end
return Guide
