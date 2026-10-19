--!strict
-- Deux explorateurs, deux consoles, une activité collective purement visuelle.
-- Fenêtre 14 secondes, un joueur ne peut pas valider les deux commandes.
local Players=game:GetService("Players")
local PromptService=game:GetService("ProximityPromptService")
local RunService=game:GetService("RunService")
local RateLimiter=require(script.Parent.RateLimiter)
local Coop={}
local WINDOW=14
local ACTIVE=14
local function send(reply,player,text,status,id)
    if player and player.Parent==Players then
        reply:FireClient(player,{kind="coop.update.v1",text=text,state=status,coop_id=id})
    end
end
function Coop.start(world,reply)
    local sculptures={}
    local indicators={}
    local cores={}
    local pending={}
    local busy={}
    for _,item in ipairs(world:GetDescendants()) do
        local id=nil
        if item:IsA("Model") then
            id=item:GetAttribute("KinCoopSculpture")
            if type(id)=="string" then sculptures[id]=item end
        elseif item:IsA("BasePart") then
            id=item:GetAttribute("KinCoopIndicator")
            if type(id)=="string" then
                indicators[id]=indicators[id] or {}
                indicators[id][item:GetAttribute("KinCoopSide")]=item
            end
            id=item:GetAttribute("KinCoopCore")
            if type(id)=="string" then cores[id]=item end
        end
    end
    local function indicator(id,side,on)
        local light=indicators[id] and indicators[id][side]
        if light and light.Parent then light.Color=if on then Color3.fromRGB(129,249,192) else Color3.fromRGB(89,132,145) end
    end
    PromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        if host:GetAttribute("KinCoopAction")~="participate" then return end
        local id=host:GetAttribute("KinCoopId")
        local side=host:GetAttribute("KinCoopSide")
        if type(id)~="string" or (side~=1 and side~=2) then return end
        if busy[id] then
            send(reply,player,"L'installation collective est en mouvement !","active",id)
            return
        end
        local char=player.Character
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        local root=char and char:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not root then return end
        if (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"coop/"..id.."/"..side,1.0) then return end
        local now=os.clock()
        local entry=pending[id]
        if entry and now-entry.time>WINDOW then
            indicator(id,1,false);indicator(id,2,false)
            pending[id]=nil
            send(reply,entry.player,"Le délai est écoulé. Essaie à nouveau avec quelqu'un !","timeout",id)
            entry=nil
        end
        if not entry then
            pending[id]={player=player,side=side,time=now}
            indicator(id,side,true)
            send(reply,player,"Un autre explorateur doit activer l'autre console dans les 14 secondes.","waiting",id)
            task.delay(WINDOW+0.1,function()
                local live=pending[id]
                if live and live.player==player and live.time==now then
                    pending[id]=nil
                    indicator(id,1,false);indicator(id,2,false)
                    send(reply,player,"Personne n'a rejoint la console. Tu peux recommencer.","timeout",id)
                end
            end)
            return
        end
        if entry.player==player then
            send(reply,player,"Il faut deux visiteurs différents pour l'activité.","waiting",id)
            return
        end
        if entry.side==side then
            send(reply,player,"Choisis la console opposée pour activer le cœur.","waiting",id)
            return
        end
        if entry.player.Parent~=Players or not entry.player.Character then
            pending[id]=nil
            indicator(id,entry.side,false)
            send(reply,player,"L'autre explorateur est parti. Relance l'activité.","timeout",id)
            return
        end
        pending[id]=nil
        busy[id]=true
        indicator(id,1,true);indicator(id,2,true)
        send(reply,entry.player,"Bravo ! Vous avez activé le cœur ensemble.","success",id)
        send(reply,player,"Bravo ! Vous avez activé le cœur ensemble.","success",id)
        local model=sculptures[id]
        local core=cores[id]
        task.spawn(function()
            local ok,reason=pcall(function()
                if not model or not model.Parent then return end
                local original=model:GetPivot()
                local start=os.clock()
                local light=core and core:FindFirstChildOfClass("PointLight")
                if light then light.Brightness=3.0;light.Range=35 end
                while model.Parent and world.Parent do
                    local elapsed=os.clock()-start
                    local angle=elapsed*math.pi*2/5
                    model:PivotTo(original*CFrame.Angles(0,angle,0))
                    if elapsed>=ACTIVE then break end
                    RunService.Heartbeat:Wait()
                end
                if model.Parent then model:PivotTo(original) end
                if light then light.Brightness=0.4;light.Range=22 end
            end)
            if not ok then warn("Kin City coopération",reason) end
            busy[id]=nil
            indicator(id,1,false);indicator(id,2,false)
        end)
    end)
end
return Coop
