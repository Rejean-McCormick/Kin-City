-- Coller en ÉDITION, puis Play. Mesure locale de 20 s, après 5 s d'attente.
-- Aucun envoi de données. Retirer KinCityPerformanceProbe de StarterPlayerScripts pour désactiver.
assert(not game:GetService("RunService"):IsRunning(),"Arrêtez Play avant l'installation du diagnostic.")
local parent=game:GetService("StarterPlayer"):WaitForChild("StarterPlayerScripts")
local old=parent:FindFirstChild("KinCityPerformanceProbe")
if old then old:Destroy() end
local probe=Instance.new("LocalScript")
probe.Name="KinCityPerformanceProbe"
probe.Source=[==[
local RunService=game:GetService("RunService")
local Stats=game:GetService("Stats")
local Players=game:GetService("Players")
task.wait(5)
local frames={}
local elapsed=0
local connection
connection=RunService.RenderStepped:Connect(function(dt)
    if dt<=0 then return end
    table.insert(frames,dt)
    elapsed+=dt
    if elapsed<20 then return end
    connection:Disconnect()
    table.sort(frames)
    local median=frames[math.max(1,math.ceil(#frames*0.5))]
    local p95=frames[math.max(1,math.ceil(#frames*0.95))]
    local world=workspace:FindFirstChild("KinCityGenerated")
    local parts,lights,emitters=0,0,0
    if world then
        for _,item in ipairs(world:GetDescendants()) do
            if item:IsA("BasePart") then parts+=1 end
            if item:IsA("Light") then lights+=1 end
            if item:IsA("ParticleEmitter") then emitters+=1 end
        end
    end
    local ok,memory=pcall(function()return Stats:GetTotalMemoryUsageMb() end)
    print(string.format("KIN CITY PERF | %d images / %.1f s | FPS moyen %.1f | image médiane %.2f ms | p95 %.2f ms",
        #frames,elapsed,#frames/elapsed,median*1000,p95*1000))
    print("Zone",Players.LocalPlayer:GetAttribute("KinZone"),"Qualité",Players.LocalPlayer:GetAttribute("KinCityLocalQuality"),
        "Pièces chargées client",parts,"Lumières",lights,"Émetteurs décor",emitters,"Mémoire client Mo",if ok then memory else "indisponible")
    print("Mesure locale dépendante du trajet, du streaming et de l'appareil; pas une comparaison automatique avec v26.")
    script:Destroy()
end)
]==]
probe.Parent=parent
print("Diagnostic installé. Lancez Play, marchez 25 secondes et consultez Sortie côté client.")
