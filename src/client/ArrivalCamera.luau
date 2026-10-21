--!strict
-- Cadrage ponctuel après le placement serveur, puis contrôle Roblox normal.
local Players=game:GetService("Players")
local RunService=game:GetService("RunService")
local Arrival={}
function Arrival.start()
    local player=Players.LocalPlayer
    -- Occlusion native : rend le personnage visible sans caméra Scriptable permanente.
    player.DevCameraOcclusionMode=Enum.DevCameraOcclusionMode.Invisicam
    local function characterAdded(character)
        task.spawn(function()
            local root=character:WaitForChild("HumanoidRootPart",12)
            local humanoid=character:WaitForChild("Humanoid",12)
            if not root or not humanoid then return end
            local deadline=os.clock()+15
            while character.Parent and player.Character==character and os.clock()<deadline do
                if character:GetAttribute("KinArrivalFrame") then
                    local name="KinCityArrivalCamera"
                    RunService:BindToRenderStep(name,Enum.RenderPriority.Camera.Value+1,function()
                        RunService:UnbindFromRenderStep(name)
                        if player.Character~=character then return end
                        local camera=workspace.CurrentCamera
                        if not camera or camera.CameraType==Enum.CameraType.Scriptable then return end
                        camera.CameraSubject=humanoid
                        local focus=root.Position+Vector3.new(0,1.5,0)
                        camera.CFrame=CFrame.lookAt(focus+Vector3.new(0,7,16),focus)
                        camera.Focus=CFrame.new(focus)
                    end)
                    return
                end
                task.wait(0.1)
            end
        end)
    end
    player.CharacterAdded:Connect(characterAdded)
    if player.Character then characterAdded(player.Character) end
end
return Arrival
