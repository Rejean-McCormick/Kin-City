"""Generate a test-only importer adapter for models already imported in Studio."""
from pathlib import Path
from art_deco_catalog import load_art_deco
from export_roblox import lua_literal
ROOT=Path(__file__).resolve().parents[1]
def generate(root=ROOT):
    data=load_art_deco(root)
    expected={a['asset_key']:a['source_name'] for a in data['manifest']['assets']}
    code='-- Generated: private Studio imports only; no mesh bytes or uploads.\nlocal config='+lua_literal(data['config'])+'\nlocal expected='+lua_literal(expected)+'\n'
    code+='''local RunService=game:GetService("RunService")
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
'''
    target=root/'studio/PrepareArtDecoLibrary.luau';target.parent.mkdir(parents=True,exist_ok=True);target.write_text(code)
    return target
if __name__=='__main__':generate()
