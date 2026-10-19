--!strict
-- Actions serveur des galeries et ateliers v14 : cinétiques + expériences à trois étapes.
-- Pas de DataStore, HTTP, récompenses ni données d'identité kOA.
local Players=game:GetService("Players")
local Prompts=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
local TIMELIMIT=48
local function tell(remote,player,title,message)
    if player.Parent~=Players then return end
    remote:FireClient(player,{
        kind="interaction.reply.v1",status="LOCAL_SUCCESS",
        title=title,message=message,
        notice="Expérience physique locale · aucune opération kOA",
    })
end
local function eligible(host,prompt,player,world)
    if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return false end
    if not prompt.Enabled or player:GetAttribute("KinZone")~="city" then return false end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local root=char and char:FindFirstChild("HumanoidRootPart")
    return hum~=nil and root~=nil and hum.Health>0 and (root.Position-host.Position).Magnitude<=prompt.MaxActivationDistance+3
end
local function spin(model,seconds,revolutions)
    if not model or not model.Parent then return end
    local start=model:GetPivot()
    local begun=os.clock()
    while model.Parent and model:IsDescendantOf(workspace) do
        local alpha=math.clamp((os.clock()-begun)/seconds,0,1)
        local eased=alpha*alpha*(3-2*alpha)
        model:PivotTo(start*CFrame.Angles(0,eased*2*math.pi*revolutions,0))
        if alpha>=1 then break end
        RunService.Heartbeat:Wait()
    end
    if model.Parent then model:PivotTo(start) end
end
function Runtime.start(world,reply)
    local art={}
    local machines={}
    local lights={}
    local cores={}
    local states={}
    local spinning={}
    for _,obj in ipairs(world:GetDescendants()) do
        if obj:IsA("Model") then
            local aid=obj:GetAttribute("KinArcadeDisplayId")
            if type(aid)=="string" then art[aid]=obj end
            local wid=obj:GetAttribute("KinWorkshopMachine")
            if type(wid)=="string" then machines[wid]=obj end
        elseif obj:IsA("BasePart") then
            local wid=obj:GetAttribute("KinWorkshopIndicator")
            if type(wid)=="string" then
                lights[wid]=lights[wid] or {}
                lights[wid][obj:GetAttribute("KinWorkshopIndicatorStep")]=obj
            end
            local core=obj:GetAttribute("KinWorkshopCore")
            if type(core)=="string" then cores[core]=obj end
        end
    end
    local function progress(host,id,step)
        local model=machines[id]
        local site=model and model:GetPivot().Position or host.Position
        for _,player in ipairs(Players:GetPlayers()) do
            local char=player.Character
            local root=char and char:FindFirstChild("HumanoidRootPart")
            if root and player:GetAttribute("KinZone")=="city" and (root.Position-site).Magnitude<75 then
                reply:FireClient(player,{
                    kind="workshop.progress.v1",title="ATELIER PUBLIC",step=step,id=id
                })
            end
        end
    end
    local function reflect(id,step)
        for k,bulb in pairs(lights[id] or {}) do
            if bulb.Parent then
                bulb.Color=if k<step then Color3.fromRGB(115,245,175) else Color3.fromRGB(94,124,136)
            end
        end
        local core=cores[id]
        if core and core.Parent then
            local glow=core:FindFirstChildOfClass("PointLight")
            if glow then glow.Brightness=if step==4 then 3 else 0.35+step*0.35 end
        end
    end
    Prompts.PromptTriggered:Connect(function(prompt,player)
        local host=prompt.Parent
        if not eligible(host,prompt,player,world) then return end
        local arcade=host:GetAttribute("KinArcadeId")
        if host:GetAttribute("KinArcadeAction")=="animate" and type(arcade)=="string" then
            if not RateLimiter.allowed(player,"arcade/"..arcade,1.2) then return end
            local display=art[arcade]
            if not display or spinning[arcade] then
                tell(reply,player,"Galerie des ateliers","Le mécanisme est déjà en mouvement.")
                return
            end
            spinning[arcade]=true
            tell(reply,player,"Galerie des ateliers","La collection s'anime sous tes yeux.")
            task.spawn(function()
                local ok,err=pcall(spin,display,3,2)
                if not ok then warn("Kin City arcade",err) end
                spinning[arcade]=nil
            end)
            return
        end
        local id=host:GetAttribute("KinWorkshopId")
        local nextStep=host:GetAttribute("KinWorkshopStep")
        if type(id)~="string" or type(nextStep)~="number" or nextStep<1 or nextStep>3 then return end
        if not RateLimiter.allowed(player,"workshop/"..id,0.55) then return end
        local now=os.clock()
        local st=states[id]
        if not st or now-st.last>TIMELIMIT then
            st={step=1,last=now,contributors={}}
            states[id]=st
            reflect(id,1)
            progress(host,id,1)
        end
        if st.step==4 then
            tell(reply,player,"Atelier public","La machine est active. Une nouvelle session commencera après le cycle.")
            return
        end
        if nextStep~=st.step then
            tell(reply,player,"Atelier public",string.format("Étape attendue : %d sur 3. Commence par la console correspondante.",st.step))
            return
        end
        st.contributors[player.UserId]=true
        st.last=now
        st.step+=1
        reflect(id,st.step)
        progress(host,id,st.step)
        if st.step<=3 then
            tell(reply,player,"Atelier public",string.format("Étape %d réussie ! Active maintenant la console %d.",nextStep,st.step))
            return
        end
        local total=0
        for _ in pairs(st.contributors) do total+=1 end
        tell(reply,player,"Atelier public",if total>=2 then "Vous avez mis la machine en marche ensemble !" else "Machine activée ! Les trois étapes sont complétées.")
        local model=machines[id]
        task.spawn(function()
            local ok,err=pcall(function()
                spin(model,6,4)
                task.wait(1.5)
            end)
            if not ok then warn("Kin City atelier",err) end
            if states[id]==st then
                states[id]=nil
                reflect(id,1)
            end
        end)
    end)
end
return Runtime
