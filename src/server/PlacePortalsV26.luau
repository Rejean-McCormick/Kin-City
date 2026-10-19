--!strict
-- Les portes sont des frontières explicites entre le monde extérieur et les
-- huit Places institutionnelles. La décoration ne porte AUCUNE collision.
local F=require(script.Parent.Factory)
local Portals={}
local names={
 city="Kin City",city_hall="Hôtel de ville",ekoh_tower="Tour EkoH",
 library="Grande Bibliothèque",campus="Université KonnectED",
 justice_palace="Palais de justice",innovation_lab="Parc de l'Innovation",
 museum="Musée Kreative",orgo_center="Centre Orgo",
}
local teal=Color3.fromRGB(30,104,100)
local opal=Color3.fromRGB(197,244,240)
local gold=Color3.fromRGB(229,215,175)
local function ornament(parent,name,size,frame,color,material)
 local p=F.part(parent,name,size,frame,color,material)
 p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false
 p:SetAttribute("KinOptionalDetail",true)
 return p
end
function Portals.decorate(parent,door,frame,mode)
 local name=names[door.destination_place_key] or door.destination_place_key
 local isEntry=door.source_place_key=="city"
 local deco=Instance.new("Folder")
 deco.Name="Seuil de Place — "..door.door_id
 deco:SetAttribute("KinPortalBoundary",true)
 deco:SetAttribute("KinFromPlace",door.source_place_key)
 deco:SetAttribute("KinToPlace",door.destination_place_key)
 deco.Parent=parent
 for _,side in ipairs({-1,1}) do
  ornament(deco,"Pilastre sarcelle",Vector3.new(0.65,8.0,0.9),
   frame*CFrame.new(side*5.0,1.7,0),teal,Enum.Material.Metal)
  ornament(deco,"Cristal opalin",Vector3.new(0.85,1.15,0.85),
   frame*CFrame.new(side*5.0,6.25,0)*CFrame.Angles(0,0,math.rad(45)),opal,Enum.Material.Neon)
 end
 ornament(deco,"Linteau champagne",Vector3.new(11.3,0.5,1.1),
  frame*CFrame.new(0,5.95,0),gold,Enum.Material.Metal)
 local tag=if isEntry then "ENTRÉE • "..name else "RETOUR • KIN CITY"
 local label=F.sign(deco,"Signalétique de la Place",(frame*CFrame.new(0,4.7,-0.55)).Position,
  math.deg(math.atan2(-frame.LookVector.X,-frame.LookVector.Z)),tag,9.5,1.6)
 label.CastShadow=false;label.CanTouch=false;label.CanQuery=false
 if mode=="SPLIT_PREVIEW" then
  local info=F.sign(deco,"Statut de publication",(frame*CFrame.new(0,3.5,-0.65)).Position,
    math.deg(math.atan2(-frame.LookVector.X,-frame.LookVector.Z)),"PLACE DISTINCTE • À PUBLIER",8,0.8)
  info.CanTouch=false;info.CanQuery=false;info.CastShadow=false
 end
 return deco
end
return Portals
