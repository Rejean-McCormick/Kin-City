--!strict
-- Corrélation pure des requêtes : les retours tardifs ne libèrent pas un autre voyage.
local PendingTravel={}
function PendingTravel.new()
    local requests={}
    local store={}
    function store.begin(player,request)
        if requests[player] then return false end
        requests[player]=request
        return true
    end
    function store.get(player) return requests[player] end
    function store.take(player,id)
        local request=requests[player]
        if not request or request.id~=id then return nil end
        requests[player]=nil
        return request
    end
    function store.clear(player)
        local request=requests[player]
        requests[player]=nil
        return request
    end
    return store
end
return PendingTravel
