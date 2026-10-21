--!strict
local Typography=require(game:GetService("ReplicatedStorage"):WaitForChild("KinCityShared"):WaitForChild("Typography"))
-- Lecture défilable : le texte complet reste accessible sur petit écran.
local Players=game:GetService("Players")
local GuiService=game:GetService("GuiService")
local UIS=game:GetService("UserInputService")
local Reader={}
function Reader.start(remote)
    local gui=Instance.new("ScreenGui");gui.Name="KinCityStoryReader";gui.ResetOnSpawn=false
    gui.DisplayOrder=16;gui.Enabled=false;gui.Parent=Players.LocalPlayer:WaitForChild("PlayerGui")
    local card=Instance.new("Frame");card.AnchorPoint=Vector2.new(0.5,0.5);card.Position=UDim2.fromScale(0.5,0.5)
    card.Size=UDim2.fromScale(0.9,0.8);card.BackgroundColor3=Color3.fromRGB(16,47,55);card.Parent=gui
    local limits=Instance.new("UISizeConstraint");limits.MaxSize=Vector2.new(560,420);limits.Parent=card
    local corner=Instance.new("UICorner");corner.CornerRadius=UDim.new(0,16);corner.Parent=card
    local border=Instance.new("UIStroke");border.Color=Color3.fromRGB(197,244,240);border.Transparency=0.4;border.Parent=card
    local heading=Instance.new("TextLabel");heading.Size=UDim2.new(1,-32,0,56);heading.Position=UDim2.fromOffset(16,8)
    heading.BackgroundTransparency=1;heading.TextColor3=Color3.fromRGB(197,244,240)
    heading.Font=Typography.body();heading.TextSize=19;heading.TextWrapped=true;heading.Parent=card
    local scroll=Instance.new("ScrollingFrame");scroll.Position=UDim2.fromOffset(16,70)
    scroll.Size=UDim2.new(1,-32,1,-148);scroll.BackgroundTransparency=1;scroll.BorderSizePixel=0
    scroll.ScrollBarThickness=5;scroll.AutomaticCanvasSize=Enum.AutomaticSize.Y
    scroll.CanvasSize=UDim2.new();scroll.Selectable=true;scroll.Parent=card
    local body=Instance.new("TextLabel");body.Size=UDim2.new(1,-12,0,0);body.AutomaticSize=Enum.AutomaticSize.Y
    body.BackgroundTransparency=1;body.TextColor3=Color3.fromRGB(244,239,231);body.Font=Typography.body()
    body.TextSize=18;body.TextWrapped=true;body.TextXAlignment=Enum.TextXAlignment.Left;body.TextYAlignment=Enum.TextYAlignment.Top;body.Parent=scroll
    local close=Instance.new("TextButton");close.AnchorPoint=Vector2.new(0.5,1)
    close.Position=UDim2.new(0.5,0,1,-16);close.Size=UDim2.new(1,-32,0,46)
    close.BackgroundColor3=Color3.fromRGB(30,104,100);close.TextColor3=Color3.fromRGB(197,244,240)
    close.Font=Typography.body();close.TextSize=17;close.Text="Continuer la visite";close.Parent=card
    local previous=nil
    local function dismiss()
        gui.Enabled=false
        if GuiService.SelectedObject==close or GuiService.SelectedObject==scroll then
            GuiService.SelectedObject=if previous and previous.Parent then previous else nil
        end
    end
    close.Activated:Connect(dismiss)
    UIS.InputBegan:Connect(function(input)
        if gui.Enabled and (input.KeyCode==Enum.KeyCode.Escape or input.KeyCode==Enum.KeyCode.ButtonB) then dismiss() end
    end)
    remote.OnClientEvent:Connect(function(payload)
        if type(payload)~="table" or payload.status~="LOCAL_STORY" then return end
        if not gui.Enabled then previous=GuiService.SelectedObject end
        heading.Text=payload.title or "La bibliothèque"
        body.Text=(payload.message or "").."\n\n"..(payload.notice or "")
        scroll.CanvasPosition=Vector2.zero;gui.Enabled=true
        if UIS.GamepadEnabled then GuiService.SelectedObject=scroll end
    end)
end
return Reader
