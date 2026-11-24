--!strict
-- KC35 B09 GENERATED from contrib/places/orgo_center/OrgoScene.luau sha256=e64f525ba359d2c5baa0934f1c5b79661aebeb154b869a27fd53b25510947c23
-- B08 native Art Deco overlay REBASED on KC33. No meshes, network or contracts.
local Data=require(script.Parent:WaitForChild("B08OrgoData"))
local Orgo={}
local LEVEL={LITE=1,STANDARD=2,SHOWCASE=3}
local INK=Color3.fromRGB(38,63,76)
local BRONZE=Color3.fromRGB(189,148,90)
local TEAL=Color3.fromRGB(30,104,100)
local OPAL=Color3.fromRGB(231,238,233)
local ROOT_NAME="B08_OrgoDecor_KC33"
local function part(parent:Instance,name:string,pos:Vector3,size:Vector3,color:Color3,material:Enum.Material):BasePart
    local p=Instance.new("Part")
    p.Name=name;p.Size=size;p.CFrame=CFrame.new(pos);p.Color=color;p.Material=material
    p.Anchored=true;p.CanCollide=false;p.CanTouch=false;p.CanQuery=false;p.CastShadow=false;p.Parent=parent
    return p
end
local function makeNode(root:Instance,item:any,origin:Vector3)
    local p=item.position
    local pos=origin+Vector3.new(p[1],p[2],p[3])
    local kind=item.kind
    local node=Instance.new("Folder");node.Name=item.id;node.Parent=root
    if kind=="sign" or kind=="subtitle" then
        local subtitle=kind=="subtitle"
        local width=if subtitle then 12 else 15
        local height=if subtitle then 1.35 else 2.9
        local face=part(node,"Cartouche",pos,Vector3.new(width,height,0.18),INK,Enum.Material.SmoothPlastic)
        part(node,"Rail supérieur",pos+Vector3.new(0,height/2+0.13,0),Vector3.new(width+0.4,0.13,0.2),BRONZE,Enum.Material.Metal)
        local gui=Instance.new("SurfaceGui");gui.Name="Titre";gui.Face=Enum.NormalId.Front
        gui.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud;gui.PixelsPerStud=32;gui.Parent=face
        local text=Instance.new("TextLabel");text.Size=UDim2.fromScale(1,1);text.BackgroundTransparency=1
        text.Text=item.text or "MAISON ORGO";text.TextColor3=if subtitle then OPAL else BRONZE
        text.Font=Enum.Font.GothamBold;text.TextScaled=true;text.TextWrapped=true;text.Parent=gui
    elseif kind=="medallion" then
        part(node,"Motif",pos+Vector3.new(0,0.07,0),Vector3.new(6,0.1,6),TEAL,Enum.Material.Metal)
        part(node,"Centre",pos+Vector3.new(0,0.15,0),Vector3.new(2,0.11,2),OPAL,Enum.Material.Marble)
    elseif kind=="pilaster" then
        part(node,"Pilastre",pos,Vector3.new(0.3,8.6,0.45),BRONZE,Enum.Material.Metal)
        part(node,"Cime",pos+Vector3.new(0,4.1,0),Vector3.new(1.2,0.24,0.5),OPAL,Enum.Material.Metal)
    else
        error("B08: type décoratif non reconnu "..tostring(kind))
    end
end
function Orgo.build(context:any):any
    assert(type(context)=="table" and context.place_key=="orgo_center","B08: mauvais place_key")
    local model=context.place_model or context.interiorModel or context.parent
    assert(typeof(model)=="Instance" and model:IsA("Model"),"B08: modèle intérieur absent")
    assert(model:GetAttribute("KinPlaceKey")=="orgo_center","B08: modèle étranger")
    local origin=context.origin
    assert(typeof(origin)=="Vector3","B08: origine absente")
    local profile=context.profile or "STANDARD"
    assert(LEVEL[profile]~=nil,"B08: profil inconnu")
    for _,room in ipairs(Data.rooms) do
        assert(model:FindFirstChild(room.id,true),"B08: salle manquante "..room.id)
    end
    local existing=model:FindFirstChild(ROOT_NAME)
    if existing then
        assert(existing:GetAttribute("KinB08Profile")==profile,"B08: profil différent, reconstruire explicitement")
        return {created=0,reused=true}
    end
    local root=Instance.new("Model");root.Name=ROOT_NAME
    root:SetAttribute("KinBranch","B08");root:SetAttribute("KinB08Profile",profile)
    root:SetAttribute("KinB08Contract","KC34-DOC-1.0")
    local created=0
    local ok,err=pcall(function()
        for _,node in ipairs(Data.decorations) do
            if LEVEL[node.profile]<=LEVEL[profile] then makeNode(root,node,origin);created+=1 end
        end
    end)
    if not ok then root:Destroy();error("B08 : erreur : "..tostring(err)) end
    root:SetAttribute("KinB08Decorations",created);root.Parent=model
    return {created=created,skipped=0,reused=false}
end
return Orgo
