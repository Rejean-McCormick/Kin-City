--!strict
-- Axes de place, pétales urbains et bornes en cristal, géométrie légère.
local Kit=require(script.Parent.CrystalKit)
local Public={}
function Public.make(city)
    local folder=Instance.new("Folder")
    folder.Name="Mandala sarcelle et cristal v17"
    folder.Parent=city
    Kit.mosaic(folder,CFrame.new(0,1.10,0),16)
    -- Couronne : les ornements sont sans collision pour ne fermer AUCUN itinéraire.
    local count=Kit.settings.central_jalons
    for i=1,count do
        local a=2*math.pi*i/count
        local x,z=math.cos(a)*62,math.sin(a)*62
        local at=CFrame.new(x,0.1,z)*CFrame.Angles(0,-a,0)
        Kit.pedestal(folder,"Socle cardinal",at,3.4,0.8,Kit.primary)
        Kit.spire(folder,"Jalon de cristal",at*CFrame.new(0,0.8,0),1.7,8,
            {accent=if i%3==0 then Kit.gold else Kit.opal})
    end
    -- Huit portes thématiques le long de la couronne. Les poutres sont un décor optique.
    local accents={"city_hall","ekoh_tower","library","campus","justice_palace","innovation_lab","museum","orgo_center"}
    for i,key in ipairs(accents) do
        local a=(i-1)*math.pi/4
        local center=Vector3.new(math.cos(a)*342,0.4,math.sin(a)*342)
        local frame=CFrame.new(center)*CFrame.Angles(0,-a,0)
        local accent=Kit.accent(key)
        local exhibit=Instance.new("Folder")
        exhibit.Name="Signal de quartier / "..key
        exhibit.Parent=folder
        for _,side in ipairs({-1,1}) do
            Kit.spire(exhibit,"Pylône de district",frame*CFrame.new(side*11,0,0),2.15,10,
                {accent=accent})
        end
        local bar=Kit.part(exhibit,"Part","Pont cristallin",Vector3.new(24,0.7,1.0),
            frame*CFrame.new(0,12,0),Kit.primary,Enum.Material.Metal)
        Kit.rosette(exhibit,"Médaillon district",frame*CFrame.new(0,12,0.75),2.8,accent,6)
    end
    -- Signature sur le monument existant (0,0,39), sans masquer sa façade.
    Kit.spire(folder,"Flèche du savoir",CFrame.new(0,19.4,39),2.9,12,{accent=Kit.opal,hero=true})
    Kit.heroGlow(folder,Vector3.new(0,27,39))
    return folder
end
return Public
