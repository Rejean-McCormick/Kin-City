--!strict
-- Découvertes pédagogiques par session, sans compte externe ni crédits métier.
local Players=game:GetService("Players")
local ProximityPromptService=game:GetService("ProximityPromptService")
local RateLimiter=require(script.Parent.RateLimiter)
local Ledger={}
local perPlayer={}
local TOTAL=24
function Ledger.start(world,reply)
    local function register(player)
        perPlayer[player]={}
        player:SetAttribute("KinTrailCount",0)
        player:SetAttribute("KinTrailTotal",TOTAL)
    end
    Players.PlayerAdded:Connect(register)
    for _,p in ipairs(Players:GetPlayers()) do register(p) end
    Players.PlayerRemoving:Connect(function(p)perPlayer[p]=nil end)
    ProximityPromptService.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled or not player then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local id=host:GetAttribute("KinTrailId")
        if type(id)~="string" or not id:match("^kin%.trail%.%d%d$") then return end
        local char=player.Character
        local root=char and char:FindFirstChild("HumanoidRootPart")
        local hum=char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health<=0 or (root.Position-host.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"trail/"..id,0.6) then return end
        local discovered=perPlayer[player]
        if not discovered then return end
        local first=not discovered[id]
        if first then
            discovered[id]=true
            local total=0
            for _ in pairs(discovered) do total+=1 end
            player:SetAttribute("KinTrailCount",total)
        end
        local count=player:GetAttribute("KinTrailCount") or 0
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",
            title=host:GetAttribute("KinTrailTitle") or "Halte pédagogique",
            message=host:GetAttribute("KinTrailText") or "Découverte de Kin City",
            notice=string.format("%d/%d haltes découvertes%s",count,TOTAL,if first then " — nouvelle découverte !" else " — déjà visitée")
        })
    end)
end
return Ledger
