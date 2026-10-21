--!strict
local Players=game:GetService("Players")
local Prompts=game:GetService("ProximityPromptService")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Journey=require(Shared.LibraryJourney)
local Rules=require(script.Parent.LibraryJourneyRules)
local RateLimiter=require(script.Parent.RateLimiter)
local Runtime={}
function Runtime.start(world,remote)
    local states={}
    local stations={}
    for _,station in ipairs(Journey.stations) do stations[station.id]=station end
    local function sync(player,state)
        player:SetAttribute("KinLibraryStoryCount",Rules.count(state))
        player:SetAttribute("KinLibraryStoryTarget",Rules.target(state))
    end
    local function register(player)
        if states[player] then return end
        states[player]=Rules.new();sync(player,states[player])
    end
    Players.PlayerAdded:Connect(register)
    Players.PlayerRemoving:Connect(function(player) states[player]=nil end)
    for _,player in ipairs(Players:GetPlayers()) do register(player) end
    Prompts.PromptTriggered:Connect(function(prompt,player)
        if prompt.Name~="LibraryStoryPrompt" or not prompt.Enabled or not prompt:IsDescendantOf(world) then return end
        local host=prompt.Parent
        if not host or not host:IsA("BasePart") then return end
        local id=host:GetAttribute("KinLibraryStoryAction")
        local station=stations[id]
        if not station or player:GetAttribute("KinZone")~="library" then return end
        local character=player.Character
        local hum=character and character:FindFirstChildOfClass("Humanoid")
        local root=character and character:FindFirstChild("HumanoidRootPart")
        if not hum or hum.Health<=0 or not root or (root.Position-host.Position).Magnitude>14 then return end
        if not RateLimiter.allowed(player,"library-story",0.75) then return end
        register(player)
        local state=states[player]
        local result=Rules.visit(state,id)
        sync(player,state)
        local message=station.text
        if result=="complete" or result=="finished" then message=Journey.ending
        elseif result=="missing" then message="Il vous reste "..(3-Rules.count(state)).." fragment(s) à découvrir. Suivez le guide vers le prochain livre."
        elseif result=="start_first" then message="Commencez au livre d'accueil, sur le banc du hall. Le guide vous y conduit."
        elseif result=="repeat" then message="Fragment déjà découvert. "..station.text end
        remote:FireClient(player,{kind="interaction.reply.v1",status="LOCAL_STORY",title=station.title,
            message=message,notice="Récit de visite · "..Rules.count(state).."/3 fragments · aucune récompense ni service kOA"})
        if result=="complete" then player:SetAttribute("KinLibraryStoryCompletedAt",workspace:GetServerTimeNow()) end
    end)
end
return Runtime
