--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Plan=require(Shared.WorldPlan)
local Config=require(Shared.RuntimeConfig)
local Origins=require(Shared.InteriorOrigins)
local Journey=require(Shared.LibraryJourney)
local Path=require(Shared.JourneyPath)
local Guide={}
function Guide.start()
    local player=Players.LocalPlayer
    local gui=Instance.new("ScreenGui");gui.Name="KinCityLibraryJourney";gui.ResetOnSpawn=false
    gui.DisplayOrder=9;gui.Parent=player:WaitForChild("PlayerGui")
    local toggle=Instance.new("TextButton");toggle.AnchorPoint=Vector2.new(1,0)
    toggle.Position=UDim2.new(1,-16,0,130);toggle.Size=UDim2.fromOffset(195,38)
    toggle.BackgroundColor3=Color3.fromRGB(30,104,100);toggle.TextColor3=Color3.fromRGB(197,244,240)
    toggle.Text="PARCOURS BIBLIOTHÈQUE";toggle.Font=Typography.body();toggle.TextSize=12;toggle.Parent=gui
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,10);corner.Parent=toggle
    local card=Instance.new("TextLabel");card.AnchorPoint=Vector2.new(1,0)
    card.Position=UDim2.new(1,-16,0,176);card.Size=UDim2.new(0.85,0,0,114)
    card.BackgroundColor3=Color3.fromRGB(16,47,55);card.BackgroundTransparency=0.08
    card.TextColor3=Color3.fromRGB(224,244,237);card.Font=Typography.body();card.TextSize=14;card.TextWrapped=true
    card.Parent=gui;local cap=Instance.new("UISizeConstraint");cap.MaxSize=Vector2.new(300,114);cap.Parent=card
    local padding=Instance.new("UIPadding");padding.PaddingLeft=UDim.new(0,12);padding.PaddingRight=UDim.new(0,12);padding.Parent=card
    local round=corner:Clone();round.Parent=card
    local enabled=false
    local dismissed=false -- Le masquage volontaire reste respecté pendant la session.
    card.Visible=false
    local function autoEnable()
        local zone=player:GetAttribute("KinZone")
        local mode=player:GetAttribute("KinGuideMode")
        if not dismissed and mode~="route" and (zone=="library" or player:GetAttribute("KinLibraryReturn")==true) then
            enabled=true;player:SetAttribute("KinGuideMode","library")
        end
    end
    autoEnable()
    player:GetAttributeChangedSignal("KinZone"):Connect(autoEnable)
    player:GetAttributeChangedSignal("KinLibraryReturn"):Connect(autoEnable)
    local function toggleJourney()
        -- Si un autre guide est actif, une activation bascule directement sur le récit.
        enabled=player:GetAttribute("KinGuideMode")~="library"
        dismissed=not enabled
        player:SetAttribute("KinGuideMode",if enabled then "library" else "none")
    end
    toggle.Activated:Connect(toggleJourney)
    local hide=Instance.new("TextButton")
    hide.Text="✕";hide.Size=UDim2.fromOffset(28,28)
    hide.AnchorPoint=Vector2.new(1,0);hide.Position=UDim2.new(1,-17,0,181)
    hide.BackgroundColor3=Color3.fromRGB(30,104,100);hide.TextColor3=Color3.fromRGB(197,244,240)
    hide.Parent=gui;hide.Visible=false;hide.Activated:Connect(function()enabled=false;dismissed=true;player:SetAttribute("KinGuideMode","none") end)
    toggle.Visible=false
    -- Le parcours est une action facultative du menu, non une deuxième barre flottante.
    local menu=require(script.Parent.KinCityMenu)
    local tool=Instance.new("Frame");tool.Visible=false;tool.Size=UDim2.fromOffset(300,155)
    tool.BackgroundColor3=Color3.fromRGB(16,47,55);tool.Parent=gui
    local intro=Instance.new("TextLabel");intro.BackgroundTransparency=1
    intro.Text="Le livre sans dernière page\nPremière visite facultative : suivez le chemin opalin."
    intro.TextWrapped=true;intro.TextSize=14;intro.TextColor3=Color3.fromRGB(197,244,240)
    intro.Size=UDim2.new(1,-20,1,-55);intro.Position=UDim2.fromOffset(10,18);intro.Parent=tool
    local launch=Instance.new("TextButton");launch.Text="Activer / masquer le parcours"
    launch.TextSize=14;launch.Size=UDim2.new(1,-20,0,38)
    launch.Position=UDim2.new(0,10,1,-43);launch.Parent=tool
    launch.Activated:Connect(function()toggleJourney();tool.Visible=false end)
    menu.register("library","Bibliothèque · première visite",toggle,tool)
    local cityPath={}
    for _,path in ipairs(Plan.pedestrian_paths) do
        if path.building_id==Journey.building_id then
            for _,point in ipairs(path.path_xyz_studs) do table.insert(cityPath,point) end
        end
    end
    local city,library
    for _,place in ipairs(Plan.places) do
        if place.place_key=="city" then city=place elseif place.place_key=="library" then library=place end
    end
    local entry,exit
    for _,door in ipairs(Plan.doors) do
        if door.door_id==Journey.entry_door_id then entry=door elseif door.door_id==Journey.exit_door_id then exit=door end
    end
    local function anchor(place,id)
        for _,a in ipairs(place.anchors) do if a.anchor_id==id then return a.position_studs end end
    end
    table.insert(cityPath,anchor(city,entry.source_anchor_id))
    local stations={}
    for _,station in ipairs(Journey.stations) do
        for _,furn in ipairs(library.furnishings) do
            if furn.furnishing_id==station.furnishing_id then stations[station.id]={station=station,position=furn.position_studs} end
        end
    end
    local folder=Instance.new("Folder");folder.Name="LibraryJourneyLocalTrail";folder.Parent=workspace
    local dots={}
    for i=1,10 do
        local dot=Instance.new("Part");dot.Name="Repère de parcours";dot.Shape=Enum.PartType.Ball
        dot.Size=Vector3.new(0.22,0.12,0.22);dot.Color=Color3.fromRGB(197,244,240);dot.Material=Enum.Material.Neon
        dot.Anchored=true;dot.CanCollide=false;dot.CanTouch=false;dot.CanQuery=false;dot.CastShadow=false
        dot.Transparency=1;dot.Parent=folder;table.insert(dots,dot)
    end
    local elapsed=0
    RunService.Heartbeat:Connect(function(dt)
        elapsed+=dt;if elapsed<0.2 then return end;elapsed=0
        local zone=player:GetAttribute("KinZone") or "city"
        local root=player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        toggle.Visible=zone=="city" or zone=="library"
        card.Visible=enabled and (zone=="city" or zone=="library") and player:GetAttribute("KinGuideMode")=="library"
        hide.Visible=card.Visible
        for _,dot in ipairs(dots) do dot.Transparency=1 end
        if not card.Visible or not root then return end
        local origin=Vector3.zero
        if zone=="library" and Config.mode=="LOCAL_UNIVERSE" then origin=Vector3.new(table.unpack(Origins.library)) end
        local pos=root.Position-origin
        local points={}
        local title,message
        if zone=="city" then
            if player:GetAttribute("KinLibraryReturn") then
                for i=#cityPath,1,-1 do table.insert(points,cityPath[i]) end
                title="Retour à la place centrale";message="Suivez le chemin opalin vers le cœur de Kin City."
            else
                points=cityPath;title="La bibliothèque vous attend"
                message=if Config.mode=="SPLIT_PREVIEW" then "L'intérieur se visite dans sa Place dédiée. Les passages ne sont pas encore publiés." else "Suivez le chemin opalin, puis activez la porte."
            end
        else
            local id=player:GetAttribute("KinLibraryStoryTarget") or "welcome"
            local target
            if id=="exit" then
                target=anchor(library,exit.source_anchor_id);title="La suite est dans la ville"
                message=if Config.mode=="SPLIT_PREVIEW" then "Récit terminé. La porte de retour attend la publication des Places." else "Rejoignez la sortie, puis la place centrale."
            else
                local stop=stations[id] or stations.welcome
                if not stop then return end
                target=stop.position;title=stop.station.title
                message=string.format("%d/3 fragments · Approchez du livre et activez l'invite.",player:GetAttribute("KinLibraryStoryCount") or 0)
            end
            -- Rejoindre l'axe du portail avant de franchir la cloison.
            local approach={target[1],0,target[3]-(if id=="exit" then -4 else 5)}
            points=Path.roomRoute(pos.X,pos.Z,approach)
        end
        local goal=points[#points]
        local remaining=Vector3.new(goal[1]-pos.X,0,goal[3]-pos.Z).Magnitude
        if zone=="city" and player:GetAttribute("KinLibraryReturn") and remaining<12 then
            title="De retour au cœur de Kin City";message="La promenade continue. Vous pouvez masquer ce guide."
        end
        card.Text=title.."\n"..math.floor(remaining+0.5).." studs · "..message
        local nextPoint=Path.target(points,pos.X,pos.Z)
        if not nextPoint or remaining<6 then return end
        local start=Vector3.new(pos.X,0.65,pos.Z)
        local target=Vector3.new(nextPoint[1],0.65,nextPoint[3])
        local delta=target-start
        if delta.Magnitude<1 then return end
        local count=if player:GetAttribute("KinCityLocalQuality")=="LITE" then 5 else 10
        for i=1,count do
            local distance=i*2.5
            if distance<=delta.Magnitude then
                dots[i].Position=origin+start+delta.Unit*distance;dots[i].Transparency=0.25+i*0.035
            end
        end
    end)
end
return Guide
