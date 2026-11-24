--!strict
-- Manual Studio qualification. Runs only on the explicit test copy after installation.
-- This file has NOT been executed by the offline Python tests.
local runtime=game:GetService("ServerScriptService"):FindFirstChild("KinCityRuntime")
assert(runtime,"Install the test build first")
assert(not game:GetService("RunService"):IsRunning(),"Stop Play first")
local Shared=game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared")
local Data=require(runtime.ArtDecoData)
local liveAssets=require(runtime.ArtDecoAssets)
liveAssets.checkTarget()
local isolated=runtime.ArtDecoAssets:Clone()
isolated.Name="ArtDecoAssetsQualification";isolated.Parent=runtime
local sandbox=Instance.new("Folder")
sandbox.Name="ArtDecoQualificationTemporary";sandbox.Parent=workspace
local ok,err=xpcall(function()
    local assets=require(isolated)
    local count=0
    for _,record in ipairs(Data.manifest.assets) do
        assets.beginQualification()
        local frame=CFrame.new(0,100,0)*CFrame.Angles(0,0.6,0)
        local model=assets.place(sandbox,record.asset_key,"keenkonnect",Vector3.new(12,10,12),frame,"qualification")
        assert(model,"Clone/fit failed: "..record.asset_key)
        local bounds,size=model:GetBoundingBox()
        assert(size.X<=12.02 and size.Y<=10.02 and size.Z<=12.02,"Envelope exceeded: "..record.asset_key)
        local localCenter=frame:PointToObjectSpace(bounds.Position)
        assert(math.abs(localCenter.Y-size.Y/2)<0.02,"Bottom alignment: "..record.asset_key)
        for _,part in ipairs(model:GetDescendants()) do
            if part:IsA("BasePart") then
                assert(part.Anchored and not part.CanCollide and not part.CanTouch,"Unsafe cloned geometry")
                if assets.isAccent(part,model) then
                    assert(part.Color==require(Shared.HexagonalDistricts).byKey("keenkonnect").color,"Accent mismatch")
                end
            end
        end
        assets.release(model)
        assert(assets.stats().clones==0 and assets.stats().triangles==0,"Budget not released")
        count+=1
    end
    assets.beginQualification()
    assert(assets.clone("asset_that_does_not_exist","keenkonnect","qualification")==nil,"Missing-source fallback failed")
    local world=assert(workspace:FindFirstChild("KinCityGenerated"),"No generated city")
    assert(world:GetAttribute("KinBuildState")=="Ready","City not Ready")
    assert(world:GetAttribute("KinInteriorCount")==8,"Eight institutions required")
    local plan=require(Shared.WorldPlan)
    local facades=assert(world:FindFirstChild("Ville"):FindFirstChild("Bâtiments"),"No institution facades")
    for _,structure in ipairs(plan.structures) do
        local institution=nil
        for _,candidate in ipairs(facades:GetChildren()) do
            if candidate:GetAttribute("KinBuildingId")==structure.building_id then institution=candidate;break end
        end
        assert(institution and institution:GetAttribute("KinEntranceClearWidth")>=8,"Missing public entrance")
        assert(institution:GetAttribute("KinExteriorShellCount")==2,"Major Art Deco shells missing: "..structure.building_id)
        assert(institution:GetAttribute("KinInteriorLocation")=="separate_destination","Exterior/interior separation missing")
        assert(not institution:FindFirstChild("BuildingCore",true),"Old invisible core must not survive")
        local position=structure.center_studs
        local frame=CFrame.new(table.unpack(position))*CFrame.Angles(0,math.rad(structure.yaw_degrees),0)
        local parameters=OverlapParams.new()
        parameters.FilterType=Enum.RaycastFilterType.Include
        parameters.FilterDescendantsInstances={institution}
        local hits=workspace:GetPartBoundsInBox(frame*CFrame.new(0,4.3,-structure.footprint_studs[2]/2),Vector3.new(4,8,6),parameters)
        for _,hit in ipairs(hits) do assert(not hit.CanCollide,"Blocked institutional doorway: "..hit.Name) end
    end
    local pavilions=0
    for _,node in ipairs(world:GetDescendants()) do
        if node:GetAttribute("KinExteriorPavilion")==true then pavilions+=1 end
    end
    assert(pavilions==18,"Expected 18 imported sector pavilions, got "..pavilions)
    local interiors=assert(world:FindFirstChild("Bâtiments visitables"))
    local Spatial=require(runtime.Spatial)
    local Wings=require(runtime.InteriorWings)
    local roomCount=0
    for _,place in ipairs(plan.places) do
        if place.place_key~="city" then
            local model=assert(interiors:FindFirstChild("Intérieur — "..place.place_key))
            assert(model:GetAttribute("KinInteriorOrigin")==Spatial.origin(place.place_key),"Interior moved: "..place.place_key)
            for _,room in ipairs(Wings.expand(place).rooms) do
                local group=assert(model:FindFirstChild(room.room_id),"Missing existing room: "..room.room_id)
                local actual=group:GetAttribute("KinArtDecoSurfaceCount")
                local expected=group:GetAttribute("KinArtDecoSurfaceExpected")
                assert(actual and actual>0 and actual==expected,"Incomplete architecture: "..room.room_id)
                roomCount+=1
            end
            assert(model:GetAttribute("KinArtDecoConnectorCount")==model:GetAttribute("KinArtDecoConnectorExpected"),"Incomplete portal frames")
            assert(model:GetAttribute("KinArtDecoUpperCount")==6,"Missing upper gallery skins")
            for _,item in ipairs(place.furnishings) do
                local found=nil
                for _,candidate in ipairs(model:GetDescendants()) do
                    if candidate:IsA("Model") and candidate:GetAttribute("KinFurnishingId")==item.furnishing_id then found=candidate;break end
                end
                assert(found and found.PrimaryPart,"Missing functional furnishing: "..item.furnishing_id)
                assert(found.PrimaryPart.CanQuery,"Furnishing prompt host not queryable: "..item.furnishing_id)
                if item.anchor_id then assert(found:GetAttribute("KinAnchorId")==item.anchor_id,"Changed furnishing anchor") end
                if item.collision_policy=="no_collision" then
                    for _,part in ipairs(found:GetDescendants()) do
                        if part:IsA("BasePart") then assert(not part.CanCollide,"Changed furnishing collision policy") end
                    end
                end
            end
        end
    end
    assert(roomCount==48,"Expected 48 existing rooms with imported architectural surfaces")
    print("Art Deco architecture: 8 facades / 18 pavilions / 48 rooms / separate destinations preserved.")
    print("Kin City streaming enabled: "..tostring(workspace.StreamingEnabled))
    local identities={}
    for _,node in ipairs(world:GetDescendants()) do
        local sector=node:GetAttribute("KinSectorIdentity")
        if sector then
            assert(not identities[sector],"Duplicate sector identity sign")
            identities[sector]=true
            local face=assert(node:FindFirstChild("ReadableSign"),"Missing ornamented sign face")
            assert(face:FindFirstChild("LinteauOrnemental") and face:FindFirstChild("CabochonCentral"),"Sign ornament system missing")
        end
    end
    for _,section in ipairs(require(Shared.HexagonalDistricts).sections) do
        assert(identities[section.key],"Missing sector identity: "..section.key)
    end
    print("Art Deco Studio clone/fit qualification: "..count.."/121. Walkthrough and mobile profiling still required.")
end,debug.traceback)
sandbox:Destroy();isolated:Destroy()
assert(ok,err)
