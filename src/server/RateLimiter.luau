--!strict
local RateLimiter={}
local last={}
function RateLimiter.allowed(player,action,interval)
    local now=os.clock()
    local byUser=last[player.UserId]
    if not byUser then byUser={};last[player.UserId]=byUser end
    if now-(byUser[action] or -1e12)<interval then return false end
    byUser[action]=now
    return true
end
function RateLimiter.clear(player)
    last[player.UserId]=nil
end
return RateLimiter
