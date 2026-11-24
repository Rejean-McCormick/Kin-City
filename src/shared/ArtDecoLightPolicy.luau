--!strict
-- Pure selection policy shared by the client and offline behavioral tests.
local Policy={}
local limits={LITE={count=8,radius=100},STANDARD={count=16,radius=150},SHOWCASE={count=24,radius=220}}
function Policy.select(candidates,quality)
    local limit=limits[quality] or limits.STANDARD
    table.sort(candidates,function(a,b) return a.distance<b.distance end)
    local active=0
    for index,item in ipairs(candidates) do
        item.selected=index<=limit.count and item.distance<=limit.radius*limit.radius
        if item.selected then active=active+1 end
    end
    return active
end
return Policy
