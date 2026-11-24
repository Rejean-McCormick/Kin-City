--!strict
local ReplicatedStorage=game:GetService("ReplicatedStorage")
local WorldBuilder=require(script.WorldBuilder)
local PlayerTravel=require(script.PlayerTravel)
local PromptRouter=require(script.PromptRouter)
local Citizens=require(script.Citizens)
local NativeR15Citizens=require(script.NativeR15Citizens)
local Wildlife=require(script.Wildlife)
local WorldAmbience=require(script.WorldAmbience)
local OutdoorAtmosphere=require(script.OutdoorAtmosphere)
local Soundscape=require(script.Soundscape)
local Tramways=require(script.Tramways)
local IslandFerries=require(script.IslandFerries)
local IslandExperiences=require(script.IslandExperiences)
local HarborAndTrailsRuntime=require(script.HarborAndTrailsRuntime)
local ResidentialLife=require(script.ResidentialLife)
local ResidentialResidents=require(script.ResidentialResidents)
local CommunityActivities=require(script.CommunityActivities)
local BoulevardBuses=require(script.BoulevardBuses)
local IntermodalTransfers=require(script.IntermodalTransfers)
local CivicStageRuntime=require(script.CivicStageRuntime)
local LocalMechanisms=require(script.LocalMechanisms)
local ScienceExperiments=require(script.ScienceExperiments)
local DiscoveryLedger=require(script.DiscoveryLedger)
local PromenadeCraftRuntime=require(script.PromenadeCraftRuntime)
local CooperativeRuntime=require(script.CooperativeRuntime)
local UrbanV14Runtime=require(script.UrbanV14Runtime)
local SkyPavilionRuntime=require(script.SkyPavilionRuntime)
local InstitutionDiscoveryRuntime=require(script.InstitutionDiscoveryRuntime)
local LivingExhibitsV23=require(script.LivingExhibitsV23)
local KreativeThemeRuntime=require(script.KreativeThemeRuntime)

local reply=ReplicatedStorage:FindFirstChild("KinCityReply")
if not reply then
    reply=Instance.new("RemoteEvent")
    reply.Name="KinCityReply"
    reply.Parent=ReplicatedStorage
end
-- Le petit installateur autonome peut déjà fournir le personnage.
if not game:GetService("ServerScriptService"):FindFirstChild("KinCityKingKlownAvatar") then
    local avatarConfig=table.clone(require(ReplicatedStorage.KinCityShared.KingKlownConfig))
    local preservedOwner=script:GetAttribute("KingKlownOwnerUserId")
    if avatarConfig.ownerUserId==0 and type(preservedOwner)=="number" and preservedOwner>0 then
        avatarConfig.ownerUserId=preservedOwner
    end
    require(script.KingKlownAvatar).start(avatarConfig)
end
local state=WorldBuilder.build(true)
require(script.PlayerBuildServer).start(state.world)
-- Écran extérieur autonome; ne modifie ni portes ni catalogue Koali.
if state.mode=="LOCAL_UNIVERSE" or state.currentPlace=="city" then
    require(script.OutdoorCinema).start()
end
PlayerTravel.setup(state,reply)
PromptRouter.start(state,reply)
KreativeThemeRuntime.start(state.world)
-- Les services spécialisés ne démarrent pas sur des Places où leur contenu
-- n'existe pas. Les intérieurs ne répliquent donc ni flotte ni population urbaine.
LocalMechanisms.start(state.world,reply)
ScienceExperiments.start(state.world,reply)
DiscoveryLedger.start(state.world,reply)
SkyPavilionRuntime.start(state.world,reply)
InstitutionDiscoveryRuntime.start(state.world,reply)
LivingExhibitsV23.start(state.world)
require(script.LibraryJourneyRuntime).start(state.world,reply)
if state.mode=="LOCAL_UNIVERSE" or state.currentPlace=="city" then
    Citizens.start(state.world)
    NativeR15Citizens.start(state.world)
    Wildlife.start(state.world)
    WorldAmbience.start(state.world)
    OutdoorAtmosphere.start(state.world)
    Soundscape.start(state.world)
    -- Les services de transport, commerces et lotissements hérités sont
    -- conservés dans les sources, mais désactivés dans l'urbanisme Koali v31.

end
print("KIN CITY WORLD_STUB prêt",state.mode,state.currentPlace)
