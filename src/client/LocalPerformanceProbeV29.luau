--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Mesure volontaire sur 20 secondes en local. Aucune transmission ni stockage.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Probe={}
function Probe.start()
    local player=Players.LocalPlayer
    local gui=Instance.new("ScreenGui");gui.Name="KinCityPerformanceLocalV29"
    gui.ResetOnSpawn=false;gui.DisplayOrder=10;gui.Parent=player:WaitForChild("PlayerGui")
    local panel=Instance.new("Frame");panel.Size=UDim2.fromOffset(315,238)
    panel.BackgroundColor3=Color3.fromRGB(18,45,53);panel.Visible=false;panel.Parent=gui
    local title=Instance.new("TextLabel");title.BackgroundTransparency=1;title.TextWrapped=true
    title.Text="PERFORMANCE · MESURE LOCALE 20 s";title.Font=Typography.body()
    title.TextSize=15;title.TextColor3=Color3.fromRGB(197,244,240)
    title.Position=UDim2.fromOffset(12,10);title.Size=UDim2.new(1,-24,0,39);title.Parent=panel
    local result=Instance.new("TextLabel");result.BackgroundTransparency=1;result.TextWrapped=true
    result.Text="Mesure facultative, sur cet appareil uniquement.\nNe déplacez pas la caméra ni la qualité pendant la mesure pour comparer deux scènes."
    result.TextSize=14;result.Font=Typography.body()
    result.TextColor3=Color3.fromRGB(239,247,244);result.Size=UDim2.new(1,-24,1,-107)
    result.Position=UDim2.fromOffset(12,49);result.TextYAlignment=Enum.TextYAlignment.Top
    result.Parent=panel
    local button=Instance.new("TextButton");button.Text="Lancer 20 secondes"
    button.Size=UDim2.new(1,-24,0,40);button.Position=UDim2.new(0,12,1,-49)
    button.BackgroundColor3=Color3.fromRGB(30,104,100)
    button.TextColor3=Color3.fromRGB(197,244,240);button.TextSize=14
    button.Font=Typography.body();button.Parent=panel
    local busy=false
    local measurementConnection=nil
    local zoneConnection=nil
    local qualityConnection=nil
    local function disconnect()
        if measurementConnection then measurementConnection:Disconnect();measurementConnection=nil end
        if zoneConnection then zoneConnection:Disconnect();zoneConnection=nil end
        if qualityConnection then qualityConnection:Disconnect();qualityConnection=nil end
        busy=false
    end
    local function percentile(values,p)
        if #values==0 then return 0 end
        local i=math.clamp(math.ceil(#values*p),1,#values)
        return values[i]
    end
    button.Activated:Connect(function()
        if busy then
            disconnect()
            button.Text="Relancer 20 secondes"
            result.Text="Mesure annulée. Aucune donnée conservée."
            return
        end
        busy=true;button.Text="Annuler la mesure"
        -- time() est le temps réel écoulé côté Roblox, contrairement à os.clock() (CPU).
        local started=time()
        local zone=player:GetAttribute("KinZone") or "city"
        local quality=player:GetAttribute("KinCityLocalQuality") or "STANDARD"
        local changed=false
        zoneConnection=player:GetAttributeChangedSignal("KinZone"):Connect(function()changed=true end)
        qualityConnection=player:GetAttributeChangedSignal("KinCityLocalQuality"):Connect(function()changed=true end)
        local frames={}
        local interrupted=false
        local lastDisplay=0
        measurementConnection=RunService.RenderStepped:Connect(function(dt)
            local elapsed=time()-started
            if (player:GetAttribute("KinZone") or "city")~=zone
                or (player:GetAttribute("KinCityLocalQuality") or "STANDARD")~=quality then changed=true end
            if dt>0 and dt<1 then table.insert(frames,dt*1000)
            else interrupted=true end
            if elapsed<20 then
                -- Une modification du texte à chaque image fausserait inutilement la mesure.
                if elapsed-lastDisplay>=0.4 then
                    result.Text=string.format("Enregistrement local · %.1f / 20 s\nZone : %s · Qualité : %s\nAppuyer de nouveau pour annuler.",elapsed,zone,quality)
                    lastDisplay=elapsed
                end
                return
            end
            disconnect()
            table.sort(frames)
            local total=0
            for _,ms in ipairs(frames) do total+=ms end
            local mean=if #frames>0 then total/#frames else 0
            local fps=if mean>0 then 1000/mean else 0
            local changedText=if changed then "⚠ Zone ou qualité modifiée : mesure non comparable."
                else "Zone et qualité stables sur l'intervalle observé."
            result.Text=string.format("%d images · %.1f secondes\nFPS moyen : %.1f\nTemps/image médian : %.2f ms\nTemps/image p95 : %.2f ms\n%s\nAucune donnée envoyée.",
                #frames,elapsed,fps,percentile(frames,0.5),percentile(frames,0.95),changedText)
            if #frames<120 or interrupted then result.Text..="\n⚠ Mesure perturbée (pause / arrière-plan)." end
            button.Text="Relancer 20 secondes"
        end)
    end)
    panel:GetPropertyChangedSignal("Visible"):Connect(function()
        if not panel.Visible and busy then
            disconnect()
            button.Text="Relancer 20 secondes"
            result.Text="Mesure interrompue à la fermeture de l'outil."
        end
    end)
    require(script.Parent.KinCityMenu).register("performance","Mesurer les FPS (20 s)",nil,panel)
end
return Probe
