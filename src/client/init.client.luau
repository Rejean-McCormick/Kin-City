--!strict
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local Mode=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("RuntimeConfig"))
local Routing=require(ReplicatedStorage:WaitForChild("KinCityShared"):WaitForChild("PlaceRouting"))
local isCity=Mode.mode=="LOCAL_UNIVERSE" or Mode.target_place_key=="city" or Routing.city==game.PlaceId
-- Demarrer le menu et le lecteur AVANT les autres interfaces et le RemoteEvent serveur.
-- Une erreur d'HUD, de camera ou de routage ne doit pas cacher la musique.
local menuOk,menuErr=xpcall(function()
    require(script.KinCityMenu).start()
    require(script.KinCityMusicPlayer).start()
end,function(err)
    return debug.traceback(tostring(err),2)
end)
if not menuOk then warn("KIN CITY : impossible d'ouvrir la médiathèque : "..tostring(menuErr)) end
local remote=ReplicatedStorage:WaitForChild("KinCityReply")
require(script.ArrivalCamera).start()
require(script.OutdoorCinemaClient).start()
-- L'éditeur est indépendant des dialogues et du guidage. Un problème de RPC
-- ne doit plus bloquer l'enregistrement des autres outils du menu.
task.spawn(function()
    local ok,err=xpcall(function()
        require(script.PlayerBuildClient).start()
    end,function(e)
        return debug.traceback(tostring(e),2)
    end)
    if not ok then warn("KIN CITY : Mode Création client non chargé : "..tostring(err)) end
end)
require(script.Hud).start(remote)
require(script.TravelTransition).start(remote)
require(script.LibraryJourneyGuide).start()
require(script.LocalPerformanceProbeV29).start()
require(script.LibraryStoryPanel).start(remote)
require(script.KingKlownAura).start()
require(script.KingKlownPerformance).start()
if isCity then
    require(script.MapHud).start()
    require(script.SectorHud).start()
    require(script.RouteGuide).start()
    require(script.ExplorationJournal).start()
    -- Les interfaces des navettes, marchés, trams et quartiers hérités ne
    -- s'affichent plus dans une ville qui ne génère pas ces lieux.

end
require(script.CrystalDetailLOD).start()
require(script.LocalVisualDirectorV22).start()
require(script.GalleryJournalV22).start()
require(script.PlaceIdentityHudV26).start()
