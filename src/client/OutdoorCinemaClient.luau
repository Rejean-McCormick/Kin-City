--!strict
-- La vidéo est lue localement : VideoFrame.Playing ne se réplique pas.
local Cinema={}
local started=false

function Cinema.start()
    if started then return end
    started=true
    task.spawn(function()
        local model=workspace:WaitForChild("KinCityOutdoorCinema",90)
        if not model then return end
        local screen=model:WaitForChild("Écran",20)
        local surface=screen and screen:WaitForChild("Projection",20)
        local video=surface and surface:WaitForChild("Film",20)
        local message=surface and surface:WaitForChild("Message",20)
        if not video or not video:IsA("VideoFrame") then return end
        local sequence=0
        local function playback()
            sequence+=1
            local ticket=sequence
            local timestamp=tonumber(model:GetAttribute("KinVideoPlaybackStart")) or 0
            local asset=tonumber(model:GetAttribute("KinVideoAssetId")) or 0
            if timestamp<=0 or asset<=0 then return end
            if workspace:GetServerTimeNow()-timestamp>300 then return end
            if not video.Video or video.Video=="" then return end
            video:Pause()
            video.TimePosition=0
            local limit=os.clock()+20
            while not video.IsLoaded and os.clock()<limit and ticket==sequence do
                task.wait(0.2)
            end
            if ticket~=sequence then return end
            if not video.IsLoaded then
                warn("KOALI CINÉMA : vidéo non chargée. Vérifier l'AssetId, les droits et la modération Roblox.")
                return
            end
            local elapsed=workspace:GetServerTimeNow()-timestamp
            if video.TimeLength>0 and elapsed>=video.TimeLength then return end
            video.TimePosition=math.max(0,elapsed)
            if message and message:IsA("TextLabel") then message.Visible=false end
            video:Play()
        end
        model:GetAttributeChangedSignal("KinVideoPlaybackStart"):Connect(function()
            task.spawn(playback)
        end)
        model:GetAttributeChangedSignal("KinVideoAssetId"):Connect(function()
            video:Pause()
            if message and message:IsA("TextLabel") then message.Visible=true end
        end)
        video.Ended:Connect(function()
            if message and message:IsA("TextLabel") then
                message.Text="PROJECTION TERMINÉE\nRevenez sur la dalle pour recommencer"
                message.Visible=true
            end
        end)
        if (tonumber(model:GetAttribute("KinVideoPlaybackStart")) or 0)>0 then
            task.spawn(playback)
        end
    end)
end
return Cinema
