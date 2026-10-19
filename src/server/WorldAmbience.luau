--!strict
-- Cycle solaire continu, sans saut brutal du soir au matin.
-- Une journée virtuelle dure environ 24 minutes réelles.
local Lighting=game:GetService("Lighting")
local Ambience={}
function Ambience.start(world)
    task.spawn(function()
        local clock=13.8
        while world.Parent do
            Lighting.ClockTime=clock
            clock=(clock+0.10)%24
            task.wait(6)
        end
    end)
end
return Ambience
