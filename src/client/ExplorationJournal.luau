--!strict
-- Carnet de promenade local. Aucun score, compte kOA ou stockage serveur.
local Players=game:GetService("Players")
local UIS=game:GetService("UserInputService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Buildings=require(Shared:WaitForChild("Buildings"))
local Plan=require(Shared:WaitForChild("WorldPlan"))
local player=Players.LocalPlayer
local Journal={}
local names={}
local visited={}
local keys={}
for _,b in ipairs(Buildings) do names[b.building_id]=b.name end
local seen={}
for _,door in ipairs(Plan.doors) do
    if door.source_place_key=="city" and not seen[door.destination_place_key] then
        seen[door.destination_place_key]=true
        table.insert(keys,{key=door.destination_place_key,name=names[door.building_id] or door.destination_place_key})
    end
end
table.sort(keys,function(a,b) return a.name<b.name end)
local function rounded(frame,n)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,n)
    c.Parent=frame
end
local function txt(parent,content,size,pos,sz,bold)
    local v=Instance.new("TextLabel")
    v.Size=size
    v.Position=pos
    v.BackgroundTransparency=1
    v.Text=content
    v.Font=bold and Enum.Font.GothamBold or Enum.Font.Gotham
    v.TextSize=sz
    v.TextColor3=Color3.fromRGB(244,241,227)
    v.TextWrapped=true
    v.TextXAlignment=Enum.TextXAlignment.Left
    v.Parent=parent
    return v
end
function Journal.start()
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityCarnet"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=9
    gui.Parent=player:WaitForChild("PlayerGui")
    local btn=Instance.new("TextButton")
    btn.Size=UDim2.fromOffset(140,38)
    btn.Position=UDim2.fromOffset(16,140)
    btn.BackgroundColor3=Color3.fromRGB(45,94,104)
    btn.TextColor3=Color3.fromRGB(241,238,220)
    btn.Font=Enum.Font.GothamBold
    btn.TextSize=13
    btn.Text="CARNET [J]"
    btn.Parent=gui
    rounded(btn,9)
    local panel=Instance.new("Frame")
    panel.Name="Carnet"
    panel.Size=UDim2.new(0,320,0,410)
    panel.Position=UDim2.fromOffset(16,190)
    panel.BackgroundColor3=Color3.fromRGB(25,48,58)
    panel.Visible=false
    panel.Parent=gui
    rounded(panel,13)
    local title=txt(panel,"MON CARNET DE KIN CITY",UDim2.new(1,-25,0,35),UDim2.fromOffset(14,12),16,true)
    local progress=txt(panel,"",UDim2.new(1,-25,0,45),UDim2.fromOffset(14,48),14,false)
    local subtitle=txt(panel,"Institutions à découvrir",UDim2.new(1,-25,0,22),UDim2.fromOffset(14,93),14,true)
    local entries={}
    for i,entry in ipairs(keys) do
        local row=txt(panel,"",UDim2.new(1,-26,0,32),UDim2.fromOffset(14,121+(i-1)*32),13,false)
        entries[i]=row
    end
    txt(panel,"Les visites sont conservées seulement pendant cette session. Les services restent à venir.",UDim2.new(1,-28,0,55),UDim2.fromOffset(14,355),12,false)
    local function redraw()
        local count=0
        for i,entry in ipairs(keys) do
            local done=visited[entry.key]
            if done then count+=1 end
            entries[i].Text=(done and "✓  " or "○  ")..entry.name
            entries[i].TextColor3=done and Color3.fromRGB(154,224,181) or Color3.fromRGB(223,223,216)
        end
        progress.Text=string.format("%d / %d institutions visitées",count,#keys)
    end
    local function capture()
        local zone=player:GetAttribute("KinZone")
        if zone and zone~="city" and not visited[zone] then
            visited[zone]=true
            redraw()
        end
    end
    local function flip() panel.Visible=not panel.Visible;capture() end
    btn.Activated:Connect(flip)
    UIS.InputBegan:Connect(function(key,processed)
        if not processed and key.KeyCode==Enum.KeyCode.J then flip() end
    end)
    player:GetAttributeChangedSignal("KinZone"):Connect(capture)
    redraw();capture()
end
return Journal
