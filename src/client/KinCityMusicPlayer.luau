--!strict
-- Koali v31.9.6 : médiathèque personnelle et raccourci visible en Play. Les pistes ne jouent que si leurs IDs Roblox sont valides.
local Players=game:GetService("Players")
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local SoundService=game:GetService("SoundService")
local Typography=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("Typography"))
local MusicLibrary=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("MusicLibrary"))
local AssetIds=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("MusicAssetIds"))
local KinCityMenu=require(script.Parent:WaitForChild("KinCityMenu"))
local Music={}
local started=false
local deep=Color3.fromRGB(17,42,49)
local teal=Color3.fromRGB(30,104,100)
local pearl=Color3.fromRGB(197,244,240)
local muted=Color3.fromRGB(165,191,193)

local function rounded(parent:Instance,r:number)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r)
    c.Parent=parent
end
local function label(parent:Instance,content:string,y:number,height:number,size:number):TextLabel
    local t=Instance.new("TextLabel")
    t.Size=UDim2.new(1,-20,0,height)
    t.Position=UDim2.fromOffset(10,y)
    t.BackgroundTransparency=1
    t.Text=content
    t.TextXAlignment=Enum.TextXAlignment.Left
    t.TextColor3=pearl
    t.Font=Typography.body()
    t.TextSize=size
    t.TextWrapped=true
    t.Parent=parent
    return t
end
local function button(parent:Instance,content:string,x:number,y:number,w:number,h:number):TextButton
    local b=Instance.new("TextButton")
    b.Size=UDim2.fromOffset(w,h)
    b.Position=UDim2.fromOffset(x,y)
    b.Text=content
    b.TextSize=14
    b.Font=Typography.body()
    b.TextWrapped=true
    b.TextColor3=pearl
    b.BackgroundColor3=teal
    b.Parent=parent
    rounded(b,7)
    return b
end
local function idFor(track):number
    local value=AssetIds[track.id]
    if type(value)=="number" and value>0 and value==math.floor(value) then return value end
    return 0
end
local function clock(seconds:number):string
    local n=math.max(0,math.floor(seconds))
    return string.format("%d:%02d",math.floor(n/60),n%60)
end
function Music.start()
    if started then return end
    started=true
    local gui=Instance.new("ScreenGui")
    gui.Name="KinCityMusicPlayerV31_9_6"
    gui.ResetOnSpawn=false
    gui.DisplayOrder=31
    gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
    local panel=Instance.new("Frame")
    panel.Name="Médiathèque"
    panel.Size=UDim2.fromOffset(475,510)
    panel.BackgroundColor3=deep
    panel.Visible=false
    panel.Parent=gui
    rounded(panel,12)
    label(panel,"MÉDIATHÈQUE KOALI  •  COLLECTION",10,32,17)
    local sub=label(panel,"4 albums · 49 titres · lecture personnelle",40,24,12)
    sub.TextColor3=muted

    local albumNames={}
    local albumIndex=1
    local index=0
    local playing=false
    local shuffled=false
    local repeatMode=0 -- 0: suivant puis stop, 1: piste, 2: album
    local volume=0.55
    local sound=Instance.new("Sound")
    sound.Name="KinCityMusiquePersonnelle"
    sound.Looped=false
    sound.Volume=volume
    sound.Parent=SoundService
    local albumButtons={}
    local selectedTitle=label(panel,"Choisis un morceau ci-dessous",109,42,14)
    selectedTitle.TextColor3=pearl
    local stateLabel=label(panel,"En attente des identifiants audio Roblox",153,40,12)
    stateLabel.TextColor3=muted

    local play=button(panel,"▶",9,194,60,36)
    local prev=button(panel,"⏮",76,194,55,36)
    local nextButton=button(panel,"⏭",138,194,55,36)
    local shuffle=button(panel,"Aléatoire : non",200,194,130,36)
    local repeatButton=button(panel,"Répéter : non",336,194,130,36)
    local volumeLabel=label(panel,"Volume 55 %",238,24,12)
    volumeLabel.Size=UDim2.fromOffset(92,24)
    local volumeDown=button(panel,"−",109,237,36,29)
    local volumeUp=button(panel,"+",151,237,36,29)
    local timing=label(panel,"0:00 / 0:00",278,21,12)
    timing.TextColor3=muted

    local list=Instance.new("ScrollingFrame")
    list.Name="Liste des pistes"
    list.Size=UDim2.new(1,-18,0,170)
    list.Position=UDim2.fromOffset(9,309)
    list.BackgroundColor3=Color3.fromRGB(20,53,60)
    list.ScrollBarThickness=5
    list.BorderSizePixel=0
    list.AutomaticCanvasSize=Enum.AutomaticSize.Y
    list.CanvasSize=UDim2.fromOffset(0,0)
    list.Parent=panel
    rounded(list,8)
    local listLayout=Instance.new("UIListLayout")
    listLayout.Padding=UDim.new(0,3)
    listLayout.SortOrder=Enum.SortOrder.LayoutOrder
    listLayout.Parent=list
    local function currentAlbum()
        return MusicLibrary[albumIndex]
    end
    local function currentTrack()
        return currentAlbum().tracks[index]
    end
    local function refreshInfo(message:string?)
        local t=currentTrack()
        if t then
            selectedTitle.Text=string.format("%s  —  %s",t.title,t.artist)
            stateLabel.Text=message or (idFor(t)>0 and "AssetId associé · sous réserve de validation Roblox" or "ID audio Roblox non renseigné pour ce titre")
        else
            selectedTitle.Text="Choisis un morceau ci-dessous"
            stateLabel.Text=message or "Sélectionne un titre ; renseigne ses AssetIds dans Studio pour écouter"
        end
        play.Text=if playing then "⏸" else "▶"
    end
    local function playIndex(i:number)
        local tracks=currentAlbum().tracks
        if not tracks[i] then return end
        index=i
        local t=tracks[i]
        local id=idFor(t)
        sound:Stop()
        playing=false
        if id==0 then
            sound.SoundId=""
            refreshInfo("À importer dans Roblox : identifiant audio manquant")
            return
        end
        sound.SoundId="rbxassetid://"..tostring(id)
        sound.TimePosition=0
        sound:Play()
        playing=true
        refreshInfo("Lecture demandée · "..currentAlbum().title)
    end
    local function nextPlayable(reverse:boolean)
        local tracks=currentAlbum().tracks
        local size=#tracks
        if size==0 then return end
        if shuffled and not reverse then
            local choices={}
            for i,t in ipairs(tracks) do
                if i~=index and idFor(t)>0 then table.insert(choices,i) end
            end
            if #choices>0 then playIndex(choices[math.random(1,#choices)]) end
            return
        end
        for n=1,size do
            local pos=(index-1+(if reverse then -n else n))%size+1
            if idFor(tracks[pos])>0 then playIndex(pos);return end
        end
        playing=false
        refreshInfo("Aucune autre piste avec identifiant Roblox")
    end
    local function buildTracks()
        for _,child in ipairs(list:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local album=currentAlbum()
        for i,t in ipairs(album.tracks) do
            local ready=idFor(t)>0
            local btn=Instance.new("TextButton")
            btn.Name=t.id
            btn.LayoutOrder=i
            btn.Size=UDim2.new(1,-8,0,35)
            btn.BackgroundColor3=if ready then teal else Color3.fromRGB(44,69,76)
            btn.TextColor3=if ready then pearl else muted
            btn.Font=Typography.body()
            btn.TextSize=12
            btn.TextXAlignment=Enum.TextXAlignment.Left
            btn.TextTruncate=Enum.TextTruncate.AtEnd
            btn.Text=(if ready then "  ▶  " else "  ○  ")..t.title.."   • "..clock(t.duration)
            btn.Parent=list
            rounded(btn,5)
            btn.Activated:Connect(function()playIndex(i) end)
        end
        sub.Text=string.format("%s  •  %d pistes  •  %s",album.title,#album.tracks,album.artist)
    end
    for a,album in ipairs(MusicLibrary) do
        local x=9+(a-1)*115
        local b=button(panel,string.format("Album %d",a),x,72,108,31)
        b.TextSize=12
        table.insert(albumButtons,b)
        b.Activated:Connect(function()
            if albumIndex~=a then
                sound:Stop()
                playing=false
                albumIndex=a
                index=0
                buildTracks()
                refreshInfo()
            end
        end)
    end
    prev.Activated:Connect(function()nextPlayable(true) end)
    nextButton.Activated:Connect(function()nextPlayable(false) end)
    play.Activated:Connect(function()
        if playing then
            sound:Pause()
            playing=false
            refreshInfo("Pause")
        elseif index>0 and currentTrack() and idFor(currentTrack())>0 and sound.SoundId~="" then
            sound:Resume()
            playing=true
            refreshInfo("Lecture reprise")
        else
            local tracks=currentAlbum().tracks
            for i,t in ipairs(tracks) do
                if idFor(t)>0 then playIndex(i);return end
            end
            refreshInfo("Aucune piste jouable : renseigne les 49 AssetIds Roblox")
        end
    end)
    shuffle.Activated:Connect(function()
        shuffled=not shuffled
        shuffle.Text=if shuffled then "Aléatoire : oui" else "Aléatoire : non"
    end)
    repeatButton.Activated:Connect(function()
        repeatMode=(repeatMode+1)%3
        repeatButton.Text=if repeatMode==0 then "Répéter : non" elseif repeatMode==1 then "Répéter : piste" else "Répéter : album"
    end)
    local function adjustVolume(v:number)
        volume=math.clamp(v,0,1)
        sound.Volume=volume
        volumeLabel.Text=string.format("Volume %d %%",math.floor(volume*100+0.5))
    end
    volumeDown.Activated:Connect(function()adjustVolume(volume-0.1) end)
    volumeUp.Activated:Connect(function()adjustVolume(volume+0.1) end)
    sound.Ended:Connect(function()
        playing=false
        if repeatMode==1 and index>0 then playIndex(index);return end
        if repeatMode==2 then nextPlayable(false);return end
        if not shuffled and index>=#currentAlbum().tracks then
            refreshInfo("Album terminé")
        else
            nextPlayable(false)
        end
    end)
    -- Une seule mise à jour/secondes pendant que l'outil est visible.
    task.spawn(function()
        while gui.Parent do
            if panel.Visible then
                local duration=sound.TimeLength
                local t=currentTrack()
                if duration<=0 and t then duration=t.duration end
                timing.Text=clock(sound.TimePosition).." / "..clock(duration)
            end
            task.wait(1)
        end
    end)
    buildTracks()
    refreshInfo()
    KinCityMenu.register("musique","MUSIQUE • Médiathèque Koali",nil,panel)
    -- Acces visible meme quand le joueur ne connait pas encore le menu KIN CITY.
    -- Un seul controle, pas de fenetre en double : les autres outils restent exclusifs.
    local shortcut=Instance.new("TextButton")
    shortcut.Name="OuvrirMusique"
    shortcut.AnchorPoint=Vector2.new(1,0)
    shortcut.Position=UDim2.new(1,-14,0,70)
    shortcut.Size=UDim2.fromOffset(154,40)
    shortcut.BackgroundColor3=teal
    shortcut.TextColor3=pearl
    shortcut.Font=Typography.body()
    shortcut.TextSize=15
    shortcut.Text="♫  MUSIQUE"
    shortcut.ZIndex=15
    shortcut.Parent=gui
    rounded(shortcut,10)
    shortcut.Activated:Connect(function()
        if panel.Visible then
            panel.Visible=false
        else
            KinCityMenu.open("musique")
        end
    end)
    -- La barre de statut confirme que le composant a bien demarre.
    print("KIN CITY MUSIQUE v31.9.6 : joueur actif, 4 albums / 49 pistes, bouton ♫ MUSIQUE visible")
end
return Music
