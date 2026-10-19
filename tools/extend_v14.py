"""Intégration reproductible v14 au dépôt existant."""
from pathlib import Path
p=Path(__file__).resolve().parents[1]
def rewrite(path,before,after):
    f=p/path
    txt=f.read_text(encoding='utf8')
    if after in txt:
        return
    if before not in txt:
        raise RuntimeError(f'Integration target not found: {path} {before[:80]}')
    f.write_text(txt.replace(before,after),encoding='utf8')

rewrite('src/server/CityGenerator.luau',
    'local CityGenerator={}',
    'local StationArcades=require(script.Parent.StationArcades)\nlocal PublicWorkshops=require(script.Parent.PublicWorkshops)\nlocal CityGenerator={}')
rewrite('src/server/CityGenerator.luau',
    'and not SecondaryStreets.isReserved(x,z) then',
    'and not SecondaryStreets.isReserved(x,z) and not StationArcades.isReserved(x,z) and not PublicWorkshops.isReserved(x,z) then')
rewrite('src/server/CityGenerator.luau',
    '    IntermodalHub.make(city)\n',
    '    IntermodalHub.make(city)\n    StationArcades.make(city)\n    PublicWorkshops.make(city)\n')
rewrite('src/server/init.server.luau',
    'local CooperativeRuntime=require(script.CooperativeRuntime)',
    'local CooperativeRuntime=require(script.CooperativeRuntime)\nlocal UrbanV14Runtime=require(script.UrbanV14Runtime)')
rewrite('src/server/init.server.luau',
    'CooperativeRuntime.start(state.world,reply)',
    'CooperativeRuntime.start(state.world,reply)\nUrbanV14Runtime.start(state.world,reply)')
rewrite('src/server/WorldBuilder.luau',
    'local WORLD_BUILD_REVISION="construction-v13.0.0"',
    'local WORLD_BUILD_REVISION="construction-v14.0.0"')
rewrite('src/client/MapHud.luau',
    'local PromenadeCommerce=require(Shared:WaitForChild("PromenadeCommerce"))',
    'local PromenadeCommerce=require(Shared:WaitForChild("PromenadeCommerce"))\nlocal UrbanV14Destinations=require(Shared:WaitForChild("UrbanV14Destinations"))')
rewrite('src/client/MapHud.luau',
    '    local playerDot=point(square,0,0,Color3.fromRGB(47,211,234))',
    '''    for _,shop in ipairs(UrbanV14Destinations.arcades) do
        local dot=point(square,shop.center_studs[1],shop.center_studs[3],Color3.fromRGB(248,212,139))
        dot.Size=UDim2.fromOffset(7,7)
    end
    for _,workshop in ipairs(UrbanV14Destinations.workshops) do
        local dot=point(square,workshop.center_studs[1],workshop.center_studs[3],Color3.fromRGB(141,235,206))
        dot.Size=UDim2.fromOffset(8,8)
    end
    local playerDot=point(square,0,0,Color3.fromRGB(47,211,234))''')
rewrite('src/client/RouteGuide.luau',
    'local PromenadeCommerce=require(Shared:WaitForChild("PromenadeCommerce"))',
    'local PromenadeCommerce=require(Shared:WaitForChild("PromenadeCommerce"))\nlocal UrbanV14Destinations=require(Shared:WaitForChild("UrbanV14Destinations"))')
rewrite('src/client/RouteGuide.luau',
    'table.sort(sorted,function(a,b)return a.building_id<b.building_id end)',
    '''for _,shop in ipairs(UrbanV14Destinations.arcades) do
    names[shop.id]=shop.title.." · Galeries de la gare"
    table.insert(sorted,{building_id=shop.id,center_studs=shop.center_studs,isPublicAttraction=true})
end
for _,workshop in ipairs(UrbanV14Destinations.workshops) do
    names[workshop.id]=workshop.title.." · Trois étapes"
    table.insert(sorted,{building_id=workshop.id,center_studs=workshop.center_studs,isPublicAttraction=true})
end
table.sort(sorted,function(a,b)return a.building_id<b.building_id end)''')
rewrite('tools/make_studio_installer.py',
    'print("KIN CITY v13 installé : promenade des métiers, boutiques accessibles, 6 coopératives et univers existant.")',
    'print("KIN CITY v14 installé : galeries de la gare, huit ateliers, six machines à trois étapes, routines des habitants et univers cumulatif.")')
print('OK: v14 construction wired into server, edition generator, map, destinations and installer')
