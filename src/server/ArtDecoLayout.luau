--!strict
-- Pure architecture compiler: dimensions, entrance and silhouette exist without any imported mesh.
-- Plain Lua deliberately: the exact renderer input is exercised by offline behavioral tests.
local Layout={}
-- Autorité de surface : la pelouse de l'île est à Y=0 et les voies natives
-- culminent à Y=0.21. Une fondation à Y=0 engendrait un z-fighting certain.
Layout.SITE_FLOOR_TOP_STUDS=0.32
Layout.SITE_FLOOR_THICKNESS_STUDS=0.60
local function part(plan,name,size,center,role,solid)
    table.insert(plan.parts,{name=name,size=size,center=center,role=role,solid=solid==true})
end
function Layout.compile(width,depth,height,recipe)
    assert(width>20 and depth>20 and height>14,"Institution envelope too small")
    local body=height*recipe.body_height_ratio
    local opening=recipe.entry_width
    local doorHeight=math.min(recipe.entry_height,body-2)
    assert(opening>=8 and opening<width-8 and doorHeight>=8,"Invalid public entrance")
    local plan={parts={},slots={},primary_shells={},primary_parts={},width=width,depth=depth,height=height,
        entry={width=opening,height=doorHeight,z=-depth/2},body_height=body,shape=recipe.shape}
    local half=(width-opening)/2
    part(plan,"Floor",{width,Layout.SITE_FLOOR_THICKNESS_STUDS,depth},
        {0,Layout.SITE_FLOOR_TOP_STUDS-Layout.SITE_FLOOR_THICKNESS_STUDS/2,0},"stone",true)
    part(plan,"FrontLeft",{half,body,.65},{-(opening/2+half/2),body/2,-depth/2},"stone",true)
    part(plan,"FrontRight",{half,body,.65},{opening/2+half/2,body/2,-depth/2},"stone",true)
    part(plan,"FrontLintel",{opening,body-doorHeight,.65},{0,doorHeight+(body-doorHeight)/2,-depth/2},"stone",true)
    part(plan,"RearWall",{width,body,.65},{0,body/2,depth/2},"stone",true)
    for _,side in ipairs({-1,1}) do
        part(plan,"SideWall"..side,{.65,body,depth},{side*width/2,body/2,0},"stone",true)
        part(plan,"EntrancePier"..side,{1.2,doorHeight+1.5,1.2},{side*(opening/2+1.5),(doorHeight+1.5)/2,-depth/2-.8},"bronze",false)
        part(plan,"Window"..side,{width*.19,math.min(10,body-4),.2},{side*width*.29,body*.52,-depth/2-.45},"glazing",false)
        part(plan,"WindowCrown"..side,{width*.20,.35,.35},{side*width*.29,body*.52+math.min(10,body-4)/2,-depth/2-.6},"bronze",false)
        table.insert(plan.slots,{name="EntranceColumn"..side,asset=recipe.columns_asset,
            size={2,doorHeight+2,2},center={side*(opening/2+2),0,-depth/2-1},optional=true})
        table.insert(plan.slots,{name="ArchedWindow"..side,asset=recipe.window_asset,
            size={width*.19,math.min(10,body-4),1},center={side*width*.29,body*.52-math.min(10,body-4)/2,-depth/2-.65},optional=true})
    end
    part(plan,"Roof",{width,.6,depth},{0,body+.3,0},"dark",true)
    for _,side in ipairs({-1,1}) do
        part(plan,"RoofCorniceFront"..side,{width+.4,.4,.5},{0,body+.6,side*depth/2},"bronze",false)
        part(plan,"RoofCorniceSide"..side,{.5,.4,depth},{side*width/2,body+.6,0},"bronze",false)
    end
    part(plan,"UpperFrieze",{width,.35,.35},{0,body-1,-depth/2-.45},"teal",false)
    for _,side in ipairs({-1,1}) do
        part(plan,"FacadeFin"..side,{.55,body-1,.65},{side*width*.46,body/2,-depth/2-.5},"bronze",false)
        for _,bay in ipairs({-1,1}) do
            part(plan,"SideGlazing"..side..bay,{.2,math.min(8,body-5),depth*.22},
                {side*(width/2+.4),body*.52,bay*depth*.24},"glazing",false)
        end
    end
    part(plan,"EntranceHighlight",{opening+4,.35,.7},{0,doorHeight+.75,-depth/2-1},"accent",false)
    local top=height-body-.6
    if recipe.shape=="observatory" then
        part(plan,"ObservatoryShaft",{width*.42,top,depth*.42},{0,body+.6+top/2,0},"teal",false)
        for _,side in ipairs({-1,1}) do
            part(plan,"TowerFin"..side,{.6,top,.8},{side*width*.21,body+.6+top/2,-depth*.21-.4},"bronze",false)
        end
    elseif recipe.shape=="campus" then
        for _,side in ipairs({-1,1}) do
            part(plan,"AcademicWing"..side,{width*.23,top*.85,depth*.70},{side*width*.33,body+.6+top*.425,0},"stone",false)
        end
    elseif recipe.shape=="gallery" then
        for level=1,3 do
            local h=top/3
            part(plan,"GalleryStep"..level,{width*(.70-level*.12),h,depth*(.65-level*.10)},
                {0,body+.6+(level-.5)*h,0},"stone",false)
        end
    else
        local spans={civic=.45,court=.64,atelier=.76,library=.82,services=.50}
        local span=assert(spans[recipe.shape],"Unknown institution silhouette")
        part(plan,"RaisedPavilion",{width*span,top*.85,depth*.55},{0,body+.6+top*.425,0},"stone",false)
        part(plan,"UpperHighlight",{width*span,.4,.4},{0,body+.6+top*.70,-depth*.275-.3},"accent",false)
    end
    -- All features are anchored to an architectural location, never stacked into a generic tower.
    table.insert(plan.slots,{name="InstitutionFeature",asset=recipe.feature_asset,
        size={width*(recipe.shape=="observatory" and .42 or .36),math.max(1,top),depth*(recipe.shape=="observatory" and .42 or .36)},center={0,body+.6,recipe.shape=="observatory" and 0 or -depth*.32},optional=true})
    -- The streetscape is a pair of full-sized imported building wings. The
    -- destination interior is elsewhere; these volumes need no internal rooms.
    local source=recipe.shell_source_size
    local wingWidth=(width-opening-8)/2
    local scale=math.min(wingWidth/source[1],(depth-4)/source[3],body/source[2])
    local sx,sy,sz=source[1]*scale,source[2]*scale,source[3]*scale
    local canopyHeight=math.max(sy,doorHeight+3.5)
    plan.shell_height=sy
    for _,side in ipairs({-1,1}) do
        local center={side*(opening/2+4+sx/2),0,-depth/2+sz/2+.5}
        table.insert(plan.primary_shells,{name="PrimaryArtDecoWing"..side,asset=recipe.shell_asset,
            size={sx,sy,sz},center=center})
        table.insert(plan.primary_parts,{name="WingCollision"..side,size={sx,sy,sz},
            center={center[1],sy/2,center[3]},role="stone",solid=true,invisible=true})
    end
    table.insert(plan.primary_parts,{name="PortalLintel",size={opening+8,.6,2},
        center={0,doorHeight+.8,-depth/2},role="bronze",solid=false})
    table.insert(plan.primary_parts,{name="ConnectingCanopy",size={opening+8,.5,math.min(sz,12)},
        center={0,canopyHeight+.3,-depth/2+math.min(sz,12)/2+.5},role="teal",solid=false})
    table.insert(plan.primary_parts,{name="SectorFrieze",size={width,.4,.4},
        center={0,canopyHeight+.6,-depth/2+.2},role="accent",solid=false})
    plan.primary_feature={name="InstitutionFeature",asset=recipe.feature_asset,
        size={width*.42,math.max(1,height-canopyHeight-1),depth*.42},
        center={0,canopyHeight+.8,recipe.shape=="observatory" and 0 or -depth/2+sz*.65}}
    plan.sign={center={0,doorHeight+2.6,-depth/2-1.2},width=math.min(width-14,26),height=2.6}
    return plan
end
return Layout
