--!strict
-- Correspondances intermodales locales. Pas de pass inventé, billet ou API.
local Players=game:GetService("Players")
local Prompts=game:GetService("ProximityPromptService")
local RS=game:GetService("ReplicatedStorage")
local Network=require(RS:WaitForChild("KinCityShared"):WaitForChild("IntermodalNetwork"))
local RateLimiter=require(script.Parent.RateLimiter)
local TravelSession=require(script.Parent.TravelSession)
local Transfers={}
local destinations={}
for _,gate in ipairs(Network.gates) do
    destinations[gate.id]={target=gate.arrival_studs,from="hub",name=gate.title}
end
for _,ret in ipairs(Network.returns) do
    destinations[ret.id]={target=ret.arrival_studs,from="station",name="Gare centrale des Connexions"}
end
local function eligible(player)
    if player.Parent~=Players or player:GetAttribute("KinZone")~="city" then return nil end
    if player:GetAttribute("KinBusActive") or player:GetAttribute("KinFerryActive") then return nil end
    local char=player.Character
    local hum=char and char:FindFirstChildOfClass("Humanoid")
    local hrp=char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not hrp or hum.Health<=0 or hrp.Anchored or hum.SeatPart then return nil end
    return char,hrp
end
function Transfers.start(world,reply)
    Prompts.PromptTriggered:Connect(function(prompt,player)
        if not prompt.Enabled then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") or not host:IsDescendantOf(world) then return end
        local id=host:GetAttribute("KinIntermodalTransfer")
        if type(id)~="string" then return end
        local data=destinations[id]
        if not data or host:GetAttribute("KinIntermodalFrom")~=data.from then return end
        local char,hrp=eligible(player)
        if not char or not hrp then return end
        if (host.Position-hrp.Position).Magnitude>prompt.MaxActivationDistance+3 then return end
        if not RateLimiter.allowed(player,"intermodal/"..id,2.5) then return end
        local session=TravelSession.begin(player,"intermodal")
        if not session then return end
        local target=Vector3.new(data.target[1],4.2,data.target[3])
        pcall(function()player:RequestStreamAroundAsync(target,3) end)
        if not TravelSession.valid(player,session) then
            TravelSession.finish(player,session)
            return
        end
        char:PivotTo(CFrame.new(target))
        TravelSession.finish(player,session)
        reply:FireClient(player,{
            kind="interaction.reply.v1",status="LOCAL_SUCCESS",
            title="Correspondance — Kin City",
            message="Arrivée : "..data.name,
            notice="Déplacement rapide local. Les véhicules restent accessibles aux stations."
        })
    end)
end
return Transfers
