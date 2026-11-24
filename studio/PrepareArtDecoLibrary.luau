-- Generated: private Studio imports only; no mesh bytes or uploads.
local config={
  ["allow_local_test"] = true,
  ["budget_scope"] = "Resident source geometry reservations across nine streamed zones; not a measured mobile frame budget.",
  ["enabled"] = true,
  ["library_name"] = "KinCityArtDecoLibrary",
  ["production_place_id"] = 72097868581669,
  ["profiles"] = {
    ["LITE"] = {
      ["bench_steps"] = {
        5,
      },
      ["clones"] = 2780,
      ["floor_tiles"] = 2,
      ["lamp_steps"] = {
        3,
      },
      ["near_lights"] = 8,
      ["parts"] = 12668,
      ["pools"] = {
        ["architecture"] = {
          ["clones"] = 240,
          ["parts"] = 1000,
          ["triangles"] = 40000,
        },
        ["building"] = {
          ["clones"] = 10,
          ["parts"] = 80,
          ["triangles"] = 45000,
        },
        ["environment"] = {
          ["clones"] = 1,
          ["parts"] = 20,
          ["triangles"] = 2000,
        },
        ["interior"] = {
          ["clones"] = 90,
          ["parts"] = 400,
          ["triangles"] = 35000,
        },
        ["pavilion"] = {
          ["clones"] = 3,
          ["parts"] = 40,
          ["triangles"] = 33000,
        },
        ["paving"] = {
          ["clones"] = 2,
          ["parts"] = 18,
          ["triangles"] = 500,
        },
        ["street"] = {
          ["clones"] = 4,
          ["parts"] = 60,
          ["triangles"] = 8000,
        },
      },
      ["road_steps"] = {
        4,
        12,
      },
      ["room_stations"] = 1,
      ["triangles"] = 1221000,
      ["wall_pitch"] = 20,
    },
    ["SHOWCASE"] = {
      ["bench_steps"] = {
        5,
      },
      ["clones"] = 2846,
      ["floor_tiles"] = 4,
      ["lamp_steps"] = {
        2,
        4,
        6,
        8,
      },
      ["near_lights"] = 24,
      ["parts"] = 13376,
      ["pools"] = {
        ["architecture"] = {
          ["clones"] = 240,
          ["parts"] = 1000,
          ["triangles"] = 60000,
        },
        ["building"] = {
          ["clones"] = 10,
          ["parts"] = 80,
          ["triangles"] = 45000,
        },
        ["environment"] = {
          ["clones"] = 3,
          ["parts"] = 30,
          ["triangles"] = 5000,
        },
        ["interior"] = {
          ["clones"] = 90,
          ["parts"] = 400,
          ["triangles"] = 55000,
        },
        ["pavilion"] = {
          ["clones"] = 3,
          ["parts"] = 40,
          ["triangles"] = 33000,
        },
        ["paving"] = {
          ["clones"] = 5,
          ["parts"] = 36,
          ["triangles"] = 1200,
        },
        ["street"] = {
          ["clones"] = 10,
          ["parts"] = 150,
          ["triangles"] = 26000,
        },
      },
      ["road_steps"] = {
        3,
        6,
        10,
        13,
        17,
      },
      ["room_stations"] = 2,
      ["triangles"] = 1671200,
      ["wall_pitch"] = 16,
    },
    ["STANDARD"] = {
      ["bench_steps"] = {
        5,
      },
      ["clones"] = 2810,
      ["floor_tiles"] = 4,
      ["lamp_steps"] = {
        2,
        6,
      },
      ["near_lights"] = 16,
      ["parts"] = 12944,
      ["pools"] = {
        ["architecture"] = {
          ["clones"] = 240,
          ["parts"] = 1000,
          ["triangles"] = 60000,
        },
        ["building"] = {
          ["clones"] = 10,
          ["parts"] = 80,
          ["triangles"] = 45000,
        },
        ["environment"] = {
          ["clones"] = 3,
          ["parts"] = 20,
          ["triangles"] = 5000,
        },
        ["interior"] = {
          ["clones"] = 90,
          ["parts"] = 400,
          ["triangles"] = 55000,
        },
        ["pavilion"] = {
          ["clones"] = 3,
          ["parts"] = 40,
          ["triangles"] = 33000,
        },
        ["paving"] = {
          ["clones"] = 3,
          ["parts"] = 24,
          ["triangles"] = 700,
        },
        ["street"] = {
          ["clones"] = 6,
          ["parts"] = 100,
          ["triangles"] = 14000,
        },
      },
      ["road_steps"] = {
        4,
        10,
        16,
      },
      ["room_stations"] = 2,
      ["triangles"] = 1596200,
      ["wall_pitch"] = 16,
    },
  },
  ["revision"] = "kc33-urban-roadway-six-sectors-2026-10",
  ["test_place_id"] = nil,
}
local expected={
  ["AD_Arc_Canopy_Disc"] = "KC32__AD_Arc_Canopy_Disc",
  ["AD_Arc_Column_Round_10"] = "KC32__AD_Arc_Column_Round_10",
  ["AD_Arc_Column_Round_4"] = "KC32__AD_Arc_Column_Round_4",
  ["AD_Arc_Curtain_Tower"] = "KC32__AD_Arc_Curtain_Tower",
  ["AD_Arc_Floor_Checker_Pink"] = "KC32__AD_Arc_Floor_Checker_Pink",
  ["AD_Arc_Floor_Steps_Neon"] = "KC32__AD_Arc_Floor_Steps_Neon",
  ["AD_Arc_Mezzanine_Open_Blue"] = "KC32__AD_Arc_Mezzanine_Open_Blue",
  ["AD_Arc_Mezzanine_Open_Violet"] = "KC32__AD_Arc_Mezzanine_Open_Violet",
  ["AD_Arc_Mezzanine_Rail_Blue"] = "KC32__AD_Arc_Mezzanine_Rail_Blue",
  ["AD_Arc_Mezzanine_Rail_Violet"] = "KC32__AD_Arc_Mezzanine_Rail_Violet",
  ["AD_Arc_Pavilion_Dome"] = "KC32__AD_Arc_Pavilion_Dome",
  ["AD_Arc_Pavilion_Drum"] = "KC32__AD_Arc_Pavilion_Drum",
  ["AD_Arc_Stair_Grand_Blue"] = "KC32__AD_Arc_Stair_Grand_Blue",
  ["AD_Arc_Stair_Grand_Violet"] = "KC32__AD_Arc_Stair_Grand_Violet",
  ["AD_Arc_Wall_Stars"] = "KC32__AD_Arc_Wall_Stars",
  ["AD_Arc_Window_Arch_Grid"] = "KC32__AD_Arc_Window_Arch_Grid",
  ["AD_Arc_Window_Slant"] = "KC32__AD_Arc_Window_Slant",
  ["AD_Ext_Airship_Gold"] = "KC32__AD_Ext_Airship_Gold",
  ["AD_Ext_Airship_Red"] = "KC32__AD_Ext_Airship_Red",
  ["AD_Ext_Airship_Silver"] = "KC32__AD_Ext_Airship_Silver",
  ["AD_Ext_Awning_Hotel"] = "KC32__AD_Ext_Awning_Hotel",
  ["AD_Ext_Bench"] = "KC32__AD_Ext_Bench",
  ["AD_Ext_Bldg_Base_Blue"] = "KC32__AD_Ext_Bldg_Base_Blue",
  ["AD_Ext_Bldg_Base_Cinema"] = "KC32__AD_Ext_Bldg_Base_Cinema",
  ["AD_Ext_Bldg_Base_Hotel_Blue"] = "KC32__AD_Ext_Bldg_Base_Hotel_Blue",
  ["AD_Ext_Bldg_Base_Hotel_Red"] = "KC32__AD_Ext_Bldg_Base_Hotel_Red",
  ["AD_Ext_Bldg_Base_Hotel_Violet"] = "KC32__AD_Ext_Bldg_Base_Hotel_Violet",
  ["AD_Ext_Bldg_Base_Red"] = "KC32__AD_Ext_Bldg_Base_Red",
  ["AD_Ext_Bldg_Base_Violet"] = "KC32__AD_Ext_Bldg_Base_Violet",
  ["AD_Ext_Bldg_Crown_Arches_Blue"] = "KC32__AD_Ext_Bldg_Crown_Arches_Blue",
  ["AD_Ext_Bldg_Crown_Arches_Red"] = "KC32__AD_Ext_Bldg_Crown_Arches_Red",
  ["AD_Ext_Bldg_Crown_Arches_Violet"] = "KC32__AD_Ext_Bldg_Crown_Arches_Violet",
  ["AD_Ext_Bldg_Crown_Blue"] = "KC32__AD_Ext_Bldg_Crown_Blue",
  ["AD_Ext_Bldg_Crown_Red"] = "KC32__AD_Ext_Bldg_Crown_Red",
  ["AD_Ext_Bldg_Crown_Violet"] = "KC32__AD_Ext_Bldg_Crown_Violet",
  ["AD_Ext_Bldg_Crown_Ziggurat_Blue"] = "KC32__AD_Ext_Bldg_Crown_Ziggurat_Blue",
  ["AD_Ext_Bldg_Crown_Ziggurat_Red"] = "KC32__AD_Ext_Bldg_Crown_Ziggurat_Red",
  ["AD_Ext_Bldg_Crown_Ziggurat_Violet"] = "KC32__AD_Ext_Bldg_Crown_Ziggurat_Violet",
  ["AD_Ext_Bldg_Mid_Blue"] = "KC32__AD_Ext_Bldg_Mid_Blue",
  ["AD_Ext_Bldg_Mid_Red"] = "KC32__AD_Ext_Bldg_Mid_Red",
  ["AD_Ext_Bldg_Mid_Ribbon_Blue"] = "KC32__AD_Ext_Bldg_Mid_Ribbon_Blue",
  ["AD_Ext_Bldg_Mid_Ribbon_Red"] = "KC32__AD_Ext_Bldg_Mid_Ribbon_Red",
  ["AD_Ext_Bldg_Mid_Ribbon_Violet"] = "KC32__AD_Ext_Bldg_Mid_Ribbon_Violet",
  ["AD_Ext_Bldg_Mid_Violet"] = "KC32__AD_Ext_Bldg_Mid_Violet",
  ["AD_Ext_Bridge_Suspension"] = "KC32__AD_Ext_Bridge_Suspension",
  ["AD_Ext_Car_Coupe_Black"] = "KC32__AD_Ext_Car_Coupe_Black",
  ["AD_Ext_Car_Coupe_Cream"] = "KC32__AD_Ext_Car_Coupe_Cream",
  ["AD_Ext_Car_Coupe_Red"] = "KC32__AD_Ext_Car_Coupe_Red",
  ["AD_Ext_Car_Limousine"] = "KC32__AD_Ext_Car_Limousine",
  ["AD_Ext_Car_Roadster"] = "KC32__AD_Ext_Car_Roadster",
  ["AD_Ext_Car_Taxi"] = "KC32__AD_Ext_Car_Taxi",
  ["AD_Ext_Car_Van"] = "KC32__AD_Ext_Car_Van",
  ["AD_Ext_Clock_Post"] = "KC32__AD_Ext_Clock_Post",
  ["AD_Ext_Fountain"] = "KC32__AD_Ext_Fountain",
  ["AD_Ext_Hydrant"] = "KC32__AD_Ext_Hydrant",
  ["AD_Ext_Kiosk_News"] = "KC32__AD_Ext_Kiosk_News",
  ["AD_Ext_Mailbox"] = "KC32__AD_Ext_Mailbox",
  ["AD_Ext_Palm_Tall"] = "KC32__AD_Ext_Palm_Tall",
  ["AD_Ext_Phone_Booth"] = "KC32__AD_Ext_Phone_Booth",
  ["AD_Ext_Planter_Palm"] = "KC32__AD_Ext_Planter_Palm",
  ["AD_Ext_Skybridge"] = "KC32__AD_Ext_Skybridge",
  ["AD_Ext_Street_Cross"] = "KC32__AD_Ext_Street_Cross",
  ["AD_Ext_Street_Straight"] = "KC32__AD_Ext_Street_Straight",
  ["AD_Ext_Streetlamp"] = "KC32__AD_Ext_Streetlamp",
  ["AD_Ext_Viaduct_Arch"] = "KC32__AD_Ext_Viaduct_Arch",
  ["AD_Int_Arch_Door"] = "KC32__AD_Int_Arch_Door",
  ["AD_Int_Arch_Window"] = "KC32__AD_Int_Arch_Window",
  ["AD_Int_Armchair_Club"] = "KC32__AD_Int_Armchair_Club",
  ["AD_Int_Armchair_Tub_Black"] = "KC32__AD_Int_Armchair_Tub_Black",
  ["AD_Int_Back_Bar"] = "KC32__AD_Int_Back_Bar",
  ["AD_Int_Banquette_Shell"] = "KC32__AD_Int_Banquette_Shell",
  ["AD_Int_Bar_Curve"] = "KC32__AD_Int_Bar_Curve",
  ["AD_Int_Bar_End"] = "KC32__AD_Int_Bar_End",
  ["AD_Int_Bar_Stool"] = "KC32__AD_Int_Bar_Stool",
  ["AD_Int_Bar_Straight"] = "KC32__AD_Int_Bar_Straight",
  ["AD_Int_Bed_Leopard"] = "KC32__AD_Int_Bed_Leopard",
  ["AD_Int_Bed_Satin"] = "KC32__AD_Int_Bed_Satin",
  ["AD_Int_Billiard_Table"] = "KC32__AD_Int_Billiard_Table",
  ["AD_Int_Chandelier"] = "KC32__AD_Int_Chandelier",
  ["AD_Int_Chandelier_Rings"] = "KC32__AD_Int_Chandelier_Rings",
  ["AD_Int_Column"] = "KC32__AD_Int_Column",
  ["AD_Int_Floor_Checker"] = "KC32__AD_Int_Floor_Checker",
  ["AD_Int_Floor_Medallion"] = "KC32__AD_Int_Floor_Medallion",
  ["AD_Int_Glass_Martini"] = "KC32__AD_Int_Glass_Martini",
  ["AD_Int_Lamp_Billiard"] = "KC32__AD_Int_Lamp_Billiard",
  ["AD_Int_Lamp_Floor"] = "KC32__AD_Int_Lamp_Floor",
  ["AD_Int_Lamp_Table"] = "KC32__AD_Int_Lamp_Table",
  ["AD_Int_Lamp_Wall_Sun"] = "KC32__AD_Int_Lamp_Wall_Sun",
  ["AD_Int_Mic_Stand"] = "KC32__AD_Int_Mic_Stand",
  ["AD_Int_Mirror_Sunburst"] = "KC32__AD_Int_Mirror_Sunburst",
  ["AD_Int_Nightstand"] = "KC32__AD_Int_Nightstand",
  ["AD_Int_Piano_Grand"] = "KC32__AD_Int_Piano_Grand",
  ["AD_Int_Plant_Monstera"] = "KC32__AD_Int_Plant_Monstera",
  ["AD_Int_Plant_Palm"] = "KC32__AD_Int_Plant_Palm",
  ["AD_Int_Planter_Flowers"] = "KC32__AD_Int_Planter_Flowers",
  ["AD_Int_Radio_Console"] = "KC32__AD_Int_Radio_Console",
  ["AD_Int_Room_Floor_Parquet"] = "KC32__AD_Int_Room_Floor_Parquet",
  ["AD_Int_Room_Wall_Door_Coral"] = "KC32__AD_Int_Room_Wall_Door_Coral",
  ["AD_Int_Room_Wall_Door_Teal"] = "KC32__AD_Int_Room_Wall_Door_Teal",
  ["AD_Int_Room_Wall_GlassBlock_Coral"] = "KC32__AD_Int_Room_Wall_GlassBlock_Coral",
  ["AD_Int_Room_Wall_GlassBlock_Teal"] = "KC32__AD_Int_Room_Wall_GlassBlock_Teal",
  ["AD_Int_Room_Wall_Plain_Coral"] = "KC32__AD_Int_Room_Wall_Plain_Coral",
  ["AD_Int_Room_Wall_Plain_Teal"] = "KC32__AD_Int_Room_Wall_Plain_Teal",
  ["AD_Int_Room_Wall_Window_Coral"] = "KC32__AD_Int_Room_Wall_Window_Coral",
  ["AD_Int_Room_Wall_Window_Teal"] = "KC32__AD_Int_Room_Wall_Window_Teal",
  ["AD_Int_Rug_Deco"] = "KC32__AD_Int_Rug_Deco",
  ["AD_Int_Sculpture_Deco"] = "KC32__AD_Int_Sculpture_Deco",
  ["AD_Int_Sideboard"] = "KC32__AD_Int_Sideboard",
  ["AD_Int_Sofa_Curved_Night"] = "KC32__AD_Int_Sofa_Curved_Night",
  ["AD_Int_Sofa_Curved_Red"] = "KC32__AD_Int_Sofa_Curved_Red",
  ["AD_Int_Sofa_Mod_Corner"] = "KC32__AD_Int_Sofa_Mod_Corner",
  ["AD_Int_Sofa_Mod_Ottoman"] = "KC32__AD_Int_Sofa_Mod_Ottoman",
  ["AD_Int_Sofa_Mod_Seat"] = "KC32__AD_Int_Sofa_Mod_Seat",
  ["AD_Int_Stage_Shell"] = "KC32__AD_Int_Stage_Shell",
  ["AD_Int_Stanchion_Rope"] = "KC32__AD_Int_Stanchion_Rope",
  ["AD_Int_Table_Cocktail"] = "KC32__AD_Int_Table_Cocktail",
  ["AD_Int_Table_Coffee_Glass"] = "KC32__AD_Int_Table_Coffee_Glass",
  ["AD_Int_Table_Drum_Gold"] = "KC32__AD_Int_Table_Drum_Gold",
  ["AD_Int_Table_Marble"] = "KC32__AD_Int_Table_Marble",
  ["AD_Int_Vanity"] = "KC32__AD_Int_Vanity",
  ["AD_Int_Wardrobe"] = "KC32__AD_Int_Wardrobe",
}
local RunService=game:GetService("RunService")
assert(not RunService:IsRunning(),"Stop Play before preparing the library")
assert(game.PlaceId~=config.production_place_id,"Production Place is forbidden")
assert(workspace:GetAttribute("KinArtDecoTestPlace")==true,"Explicit test-copy marker required")
assert((game.PlaceId==0 and config.allow_local_test) or
    (config.test_place_id~=nil and game.PlaceId==config.test_place_id),"Test PlaceId mismatch")
local storage=game:GetService("ServerStorage")
local function keyFor(name)
    return (name:gsub("^KC32__",""):gsub("%.%d+$",""))
end
local function scan(root)
    local found={}
    for _,node in ipairs(root:GetDescendants()) do
        local generated=false
        local ancestor=node
        while ancestor and ancestor~=root do
            if ancestor.Name=="KinCityGenerated" or ancestor:GetAttribute("KinArtDecoAsset") then
                generated=true;break
            end
            ancestor=ancestor.Parent
        end
        if not generated and (node:IsA("Model") or node:IsA("MeshPart")) then
            local key=keyFor(node.Name)
            if expected[key] then
                assert(not found[key],"Ambiguous imported model: "..key.." in "..root:GetFullName())
                found[key]=node
            end
        end
    end
    return found
end
-- Prefer actual Workspace imports. An empty historical import Folder must not
-- hide the 121 AD_Assets wrappers imported directly under Workspace.
local sources=scan(workspace)
if not next(sources) then
    local original=storage:FindFirstChild("KC_ARTDECO_V32_SOURCES")
    if original then sources=scan(original) end
end
if not next(sources) then
    local library=storage:FindFirstChild(config.library_name)
    if library then sources=scan(library) end
end
local missing={}
for key in pairs(expected) do
    if not sources[key] then table.insert(missing,key) end
end
table.sort(missing)
assert(#missing==0,"Missing imported sources: "..table.concat(missing,", "))
-- Validate the entire selection before replacing any library or moving imports.
local archiveRoots={}
for key,source in pairs(sources) do
    assert(source.Archivable,"Source is not Archivable: "..key)
    local meshes=0
    local nodes=source:GetDescendants()
    table.insert(nodes,source)
    for _,node in ipairs(nodes) do
        assert(not node:IsA("LuaSourceContainer"),"Script inside imported source: "..key)
        if node:IsA("MeshPart") then
            assert(node.MeshId:match("^rbxassetid://[1-9]%d*$"),"Missing persistent MeshId: "..key)
            meshes+=1
        end
    end
    assert(meshes>0,"No MeshPart: "..key)
    local top=source
    while top.Parent and top.Parent~=workspace do top=top.Parent end
    if top.Parent==workspace and
        (top.Name=="AD_Assets" or top.Name=="KinCityArtDecoImports") then
        archiveRoots[top]=true
    end
end
local staging=Instance.new("Folder")
staging.Name=config.library_name
local count=0
local ok,err=xpcall(function()
    for key,name in pairs(expected) do
        local source=assert(sources[key],"Missing imported source: "..key)
        assert(source.Archivable,"Source is not Archivable: "..key)
        local model
        if source:IsA("Model") then model=source:Clone()
        else
            model=Instance.new("Model")
            local part=source:Clone();part.Parent=model
        end
        assert(model:FindFirstChildWhichIsA("MeshPart",true),"No MeshPart: "..key)
        for _,node in ipairs(model:GetDescendants()) do
            assert(not node:IsA("LuaSourceContainer"),"Script inside imported source: "..key)
            if node:IsA("BasePart") then
                node.Anchored=true;node.CanCollide=false;node.CanTouch=false
            end
        end
        model.Name=name;model.Parent=staging;count+=1
    end
end,debug.traceback)
if not ok then staging:Destroy();error(err) end
assert(count==121,"Expected 121 imported sources")
local old=storage:FindFirstChild(config.library_name)
if old then
    old.Name=config.library_name.."_Previous_"..tostring(os.time())
end
staging:SetAttribute("KinLibraryRevision",config.revision.."-"..tostring(os.time()))
staging:SetAttribute("KinSourceCount",count)
staging.Parent=storage
-- Keep one previous prepared library. Originals remain intact in their archive;
-- repeated installs must not accumulate an unlimited number of private copies.
for _,previous in ipairs(storage:GetChildren()) do
    if previous~=old and previous.Name:sub(1,#config.library_name+10)==config.library_name.."_Previous_"
        and previous:GetAttribute("KinSourceCount")==121 then previous:Destroy() end
end
-- Original hierarchies are retained for recovery and reimport, outside the city.
if next(archiveRoots) then
    local archive=storage:FindFirstChild("KC_ARTDECO_V32_SOURCES")
    if not archive then
        archive=Instance.new("Folder")
        archive.Name="KC_ARTDECO_V32_SOURCES";archive.Parent=storage
    end
    for original in pairs(archiveRoots) do original.Parent=archive end
end
print("Private Art Deco library ready: "..count.."/121. No city created and no Place published.")
