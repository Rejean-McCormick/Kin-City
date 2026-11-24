--!strict
-- B03 / Kin City KC34 — library-only visual overlays.
-- Not wired into WorldBuilder or published. B09 must approve any integration.
-- Public entrypoint: Scene.build({place_key="library", interiorModel=..., origin=Vector3,...,
--    profile="LITE|STANDARD|SHOWCASE",authorized=true})
local Data=require(script.Parent:WaitForChild("LibrarySceneData"))
local Scene={}
local REVISION="KC34-B03-visual-1.0"
local STYLE={
    body=Color3.fromRGB(32,54,63),
    metal=Color3.fromRGB(194,151,86),
    opal=Color3.fromRGB(229,217,189),
    teal=Color3.fromRGB(30,104,100),
    accent=Color3.fromRGB(188,103,76),
}
local PROFILE_LEVEL={LITE=1,STANDARD=2,SHOWCASE=3}
local COST={sunburst=9,frieze=3,shelf_relief=10,reading_panel=4,leaf_motif=7}

local function part(parent,name,frame,size,color,material)
    local node=Instance.new("Part")
    node.Name=name
    node.CFrame=frame
    node.Size=size
    node.Color=color
    node.Material=material or Enum.Material.SmoothPlastic
    node.Anchored=true
    node.CanCollide=false
    node.CanTouch=false
    node.CanQuery=false
    node.CastShadow=false
    node.Locked=true
    node:SetAttribute("KinB03VisualOnly",true)
    node.Parent=parent
    return node
end

local function plaque(parent,frame,title)
    local face=part(parent,"Émail opalin",frame*CFrame.new(0,0,-0.12),Vector3.new(8,4.5,0.22),STYLE.opal)
    part(parent,"Encadrement bronze",frame*CFrame.new(0,0,0.08),Vector3.new(8.6,5.1,0.17),STYLE.metal,Enum.Material.Metal)
    part(parent,"Ligne d'accent",frame*CFrame.new(0,-2.06,-0.28),Vector3.new(7.2,0.18,0.12),STYLE.accent,Enum.Material.Metal)
    local top=part(parent,"Entablement",frame*CFrame.new(0,2.42,-0.22),Vector3.new(7.4,0.21,0.14),STYLE.teal,Enum.Material.Metal)
    local graphic=Instance.new("SurfaceGui")
    graphic.Name="Cartouche lisible"
    graphic.Face=Enum.NormalId.Front
    graphic.Adornee=face
    graphic.SizingMode=Enum.SurfaceGuiSizingMode.PixelsPerStud
    graphic.PixelsPerStud=40
    graphic.AlwaysOnTop=false
    graphic.LightInfluence=0.25
    graphic.Parent=face
    local label=Instance.new("TextLabel")
    label.Name="Texte"
    label.BackgroundTransparency=1
    label.Size=UDim2.fromScale(1,1)
    label.Text=title
    label.TextColor3=STYLE.body
    label.TextSize=25
    label.TextScaled=false
    label.TextWrapped=true
    label.Font=Enum.Font.GothamBold
    label.Parent=graphic
    top:SetAttribute("KinB03Title",title)
end

local function sunburst(parent,frame)
    part(parent,"Rosace fond",frame,Vector3.new(6.6,5.8,0.28),STYLE.body,Enum.Material.Metal)
    part(parent,"Rosace coeur",frame*CFrame.new(0,0,-0.23),Vector3.new(1.3,1.3,0.32),STYLE.accent,Enum.Material.Metal)
    for i=0,6 do
        local angle=math.rad(-78+i*26)
        local x=math.sin(angle)*1.9
        local y=math.cos(angle)*1.9
        part(parent,"Rayon ornemental "..tostring(i+1),
            frame*CFrame.new(x,y,-0.24)*CFrame.Angles(0,0,-angle),
            Vector3.new(0.22,2.0,0.16),STYLE.metal,Enum.Material.Metal)
    end
end

local function frieze(parent,frame)
    part(parent,"Bande architecturale",frame,Vector3.new(8.2,0.63,0.18),STYLE.body,Enum.Material.Metal)
    part(parent,"Trait bronze",frame*CFrame.new(0,0.18,-0.12),Vector3.new(7.9,0.12,0.12),STYLE.metal,Enum.Material.Metal)
    part(parent,"Trait terre cuite",frame*CFrame.new(0,-0.18,-0.13),Vector3.new(7.4,0.1,0.12),STYLE.accent,Enum.Material.Metal)
end

local function shelf(parent,frame)
    part(parent,"Niche géométrique",frame,Vector3.new(8.6,5.7,0.3),STYLE.body,Enum.Material.Metal)
    part(parent,"Étagère en bronze",frame*CFrame.new(0,-2.18,-0.28),Vector3.new(8.2,0.22,0.23),STYLE.metal,Enum.Material.Metal)
    for i=1,8 do
        local height=if i%3==0 then 2.8 else 3.3
        local color=if i%4==0 then STYLE.accent elseif i%3==0 then STYLE.teal else STYLE.opal
        part(parent,"Dos d'ouvrage "..i,
            frame*CFrame.new(-3.45+(i-1)*0.98,-1.95+height/2,-0.35),
            Vector3.new(0.72,height,0.24),color,Enum.Material.SmoothPlastic)
    end
end

local function leaf(parent,frame)
    part(parent,"Panneau jardin",frame,Vector3.new(7.6,6.2,0.22),STYLE.body,Enum.Material.Metal)
    part(parent,"Tige centrale",frame*CFrame.new(0,0,-0.2),Vector3.new(0.18,4.2,0.12),STYLE.metal,Enum.Material.Metal)
    for i=1,5 do
        local y=-1.5+(i-1)*0.72
        local side=if i%2==0 then -1 else 1
        part(parent,"Feuille du savoir "..i,
            frame*CFrame.new(side*1.0,y,-0.24)*CFrame.Angles(0,0,math.rad(side*31)),
            Vector3.new(2.1,0.32,0.14),if i%2==0 then STYLE.teal else STYLE.accent,Enum.Material.Metal)
    end
end

local function draw(parent,item,origin)
    local offset=item.position_studs
    local frame=CFrame.new(origin+Vector3.new(offset[1],offset[2],offset[3]))
        *CFrame.Angles(0,math.rad(item.yaw_degrees or 0),0)
    local holder=Instance.new("Model")
    holder.Name=item.id
    holder:SetAttribute("KinB03DecorationId",item.id)
    holder:SetAttribute("KinB03RoomId",item.room_id)
    holder:SetAttribute("KinB03Kind",item.kind)
    holder:SetAttribute("KinB03Title",item.title)
    holder.Parent=parent
    if item.kind=="sunburst" then
        sunburst(holder,frame)
    elseif item.kind=="frieze" then
        frieze(holder,frame)
    elseif item.kind=="shelf_relief" then
        shelf(holder,frame)
    elseif item.kind=="reading_panel" then
        plaque(holder,frame,item.title)
    elseif item.kind=="leaf_motif" then
        leaf(holder,frame)
    else
        holder:Destroy()
        error("B03: type d'ornement inconnu: "..tostring(item.kind))
    end
    return COST[item.kind]
end

function Scene.build(context)
    assert(type(context)=="table" and context.authorized==true,"B03: approbation explicite requise")
    assert(context.place_key=="library","B03: construction hors library interdite")
    local interior=context.interiorModel
    assert(typeof(interior)=="Instance" and interior:IsA("Model") and interior:GetAttribute("KinPlaceKey")=="library",
        "B03: vrai modèle d'intérieur library requis")
    local origin=context.origin
    assert(typeof(origin)=="Vector3","B03: origine Vector3 requise depuis Spatial.origin('library')")
    local profile=context.profile or "STANDARD"
    assert(PROFILE_LEVEL[profile],"B03: profil inconnu")
    local limit=Data.profile_limits[profile]
    assert(type(limit)=="number" and limit>0,"B03: limite invalide")
    local current=interior:FindFirstChild("KC34_B03_Library")
    if current then
        assert(current:IsA("Model") and current:GetAttribute("KinB03Owner")=="library",
            "B03: modèle homonyme externe, suppression bloquée")
    end
    if current and current:GetAttribute("KinB03Revision")==REVISION and current:GetAttribute("KinB03Profile")==profile then
        return {status="already_built",created_parts=current:GetAttribute("KinB03Parts") or 0,
            created_decorations=current:GetAttribute("KinB03Decorations") or 0,skipped=0}
    end
    local temp=Instance.new("Model")
    temp.Name="KC34_B03_Library__building"
    temp:SetAttribute("KinB03Owner","library")
    temp.Parent=interior
    local created=0
    local decorations=0
    local skipped=0
    local ok,err=pcall(function()
        for _,item in ipairs(Data.decorations) do
            local level=PROFILE_LEVEL[item.min_profile]
            assert(level and COST[item.kind],"B03: scène modifiée sans validation")
            if level>PROFILE_LEVEL[profile] or created+COST[item.kind]>limit then
                skipped+=1
            else
                created+=draw(temp,item,origin)
                decorations+=1
            end
        end
    end)
    if not ok then temp:Destroy();error(err) end
    local actual=0
    for _,node in ipairs(temp:GetDescendants()) do
        if node:IsA("BasePart") then
            assert(node.Anchored and not node.CanCollide and not node.CanTouch and not node.CanQuery,
                "B03: violation des règles de collision")
            actual+=1
        end
    end
    if actual~=created then
        temp:Destroy()
        error("B03: budget incohérent : "..tostring(actual).." != "..tostring(created))
    end
    if current then current:Destroy() end
    temp.Name="KC34_B03_Library"
    temp:SetAttribute("KinB03Revision",REVISION)
    temp:SetAttribute("KinB03Profile",profile)
    temp:SetAttribute("KinB03Parts",created)
    temp:SetAttribute("KinB03Decorations",decorations)
    return {status="built",created_parts=created,created_decorations=decorations,skipped=skipped}
end

return Scene
