--!strict
-- Pure policy: shared by installer, runtime and offline behavioral tests.
local Policy={}
function Policy.isTestTarget(placeId,marked,config)
    if placeId==config.production_place_id then return false end
    if marked~=true then return false end
    if placeId==0 then return config.allow_local_test==true end
    if config.test_place_id~=nil and placeId==config.test_place_id then return true end
    -- Explicit staging allowlist, generated ONLY from nine validated PlaceIds.
    for _,approved in ipairs(config.test_place_ids or {}) do
        if approved==placeId then return true end
    end
    return false
end
-- Execution autorisee UNIQUEMENT dans la Place de production canonique ou
-- sur une cible de test explicitement marquee.
-- isTestTarget reste strict : les installateurs de test ne peuvent pas cibler la production.
function Policy.isRuntimeTarget(placeId,marked,config)
    if type(config)~="table" or config.enabled~=true then return false end
    local published=config.production_place_id
    if type(published)=="number" and published>0 and placeId==published then
        return true
    end
    return Policy.isTestTarget(placeId,marked,config)
end
function Policy.canSpend(used,cost,limit)
    return used.triangles+cost.triangles<=limit.triangles
        and used.parts+cost.parts<=limit.parts and used.clones+cost.clones<=limit.clones
end
function Policy.fitScale(size,envelope)
    local scale=math.huge
    local extent=false
    for _,axis in ipairs({"X","Y","Z"}) do
        local value=size[axis]
        local bound=envelope[axis]
        if value~=value or value<0 or value==math.huge or bound~=bound or bound<=0 or bound==math.huge then return nil end
        if value>0 then scale=math.min(scale,bound/value);extent=true end
    end
    -- Floor meshes may be planar. A wholly empty model has no usable scale.
    return extent and scale or nil
end

return Policy
