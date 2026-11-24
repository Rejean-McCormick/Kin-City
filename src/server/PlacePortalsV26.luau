--!strict
-- Les portes sont des frontières explicites entre le monde extérieur et les
-- huit Places institutionnelles. La décoration ne porte AUCUNE collision.
local F=require(script.Parent.Factory)
local Portals={}
local names={
 city="Kin City",city_hall="Accueil",ekoh_tower="Observatoire EkoH",
 library="Grande Bibliothèque",campus="Université King Klown",
 justice_palace="Agora Korum",innovation_lab="Atelier Konstruct",
 museum="Galerie Konservation",orgo_center="Maison Orgo",
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
  ornament(deco,"Pilastre sarcelle",Vector3.new(0.45,7.6,0.7),
   frame*CFrame.new(side*5.85,1.85,-0.05),teal,Enum.Material.Metal)
  ornament(deco,"Cristal opalin",Vector3.new(0.85,1.15,0.85),
   frame*CFrame.new(side*5.9,6.1,-0.1)*CFrame.Angles(0,0,math.rad(45)),opal,Enum.Material.Neon)
 end
 ornament(deco,"Linteau champagne",Vector3.new(12.1,0.42,0.82),
  frame*CFrame.new(0,6.55,-0.08),gold,Enum.Material.Metal)
 -- Seuils décoratifs sans pancartes redondantes.
 return deco
end
return Portals
