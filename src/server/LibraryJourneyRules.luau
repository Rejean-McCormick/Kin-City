--!strict
-- État de récit local, sans crédits, certification ni persistance métier.
local Rules={}
local fragments={"memory","connection","imagination"}
function Rules.new() return {active=false,finished=false,seen={}} end
function Rules.count(state)
    local count=0
    for _,id in ipairs(fragments) do if state.seen[id] then count=count+1 end end
    return count
end
function Rules.target(state)
    if state.finished then return "exit" end
    if not state.active then return "welcome" end
    for _,id in ipairs(fragments) do if not state.seen[id] then return id end end
    return "welcome"
end
function Rules.visit(state,id)
    if id=="welcome" then
        if state.finished then return "finished" end
        if not state.active then state.active=true;return "start" end
        if Rules.count(state)==3 then state.finished=true;return "complete" end
        return "missing"
    end
    local known=false
    for _,fragment in ipairs(fragments) do if fragment==id then known=true end end
    if not known then return "invalid" end
    if not state.active then return "start_first" end
    if state.finished then return "finished" end
    if state.seen[id] then return "repeat" end
    state.seen[id]=true
    return "fragment"
end
return Rules
