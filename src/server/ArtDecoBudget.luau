--!strict
-- Reservation accounting shared by every renderer. Owner limits are allocated before generation.
local Budget={}
Budget.__index=Budget
local dimensions={"triangles","parts","clones"}
local function zero() return {triangles=0,parts=0,clones=0} end
local function copy(value) return {triangles=value.triangles,parts=value.parts,clones=value.clones} end
function Budget.new(limits)
    local self=setmetatable({limits=limits,owners={},total=zero(),receipts={},sequence=0},Budget)
    for owner in pairs(limits) do self.owners[owner]=zero() end
    return self
end
function Budget:addOwner(owner,limit)
    assert(not self.limits[owner],"Duplicate budget owner")
    self.limits[owner]=limit;self.owners[owner]=zero()
end
function Budget:reserve(owner,cost)
    local limit=self.limits[owner]
    if not limit then return nil end
    local used=self.owners[owner]
    for _,key in ipairs(dimensions) do
        local value=cost[key]
        if type(value)~="number" or value~=value or value<0 or value==math.huge or used[key]+value>limit[key] then return nil end
    end
    self.sequence=self.sequence+1
    local receipt=self.sequence
    self.receipts[receipt]={owner=owner,cost=copy(cost)}
    for _,key in ipairs(dimensions) do
        used[key]=used[key]+cost[key];self.total[key]=self.total[key]+cost[key]
    end
    return receipt
end
function Budget:release(receipt)
    local reservation=self.receipts[receipt]
    if not reservation then return false end
    self.receipts[receipt]=nil
    for _,key in ipairs(dimensions) do
        self.owners[reservation.owner][key]=self.owners[reservation.owner][key]-reservation.cost[key]
        self.total[key]=self.total[key]-reservation.cost[key]
    end
    return true
end
function Budget:stats(owner)
    if owner then return self.owners[owner] and copy(self.owners[owner]) or nil end
    return copy(self.total)
end
return Budget
