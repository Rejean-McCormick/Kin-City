--!strict
-- Géométrie 2D pure : projection au sentier puis prochain virage, sans couper les angles.
local Path={}
function Path.target(points,x,z)
    if #points==0 then return nil end
    if #points==1 then return points[1] end
    local best=nil
    local distance=math.huge
    for i=1,#points-1 do
        local a,b=points[i],points[i+1]
        local dx,dz=b[1]-a[1],b[3]-a[3]
        local length=dx*dx+dz*dz
        local t=0
        if length>0 then t=math.max(0,math.min(1,((x-a[1])*dx+(z-a[3])*dz)/length)) end
        local px,pz=a[1]+dx*t,a[3]+dz*t
        local d=(px-x)^2+(pz-z)^2
        if d<distance then distance=d;best={index=i,t=t,point={px,a[2],pz}} end
    end
    if distance>81 then return best.point end
    local nextIndex=best.index+1
    local target=points[nextIndex]
    if (target[1]-x)^2+(target[3]-z)^2<16 and nextIndex<#points then target=points[nextIndex+1] end
    return target
end
function Path.roomRoute(x,z,target)
    local points={{x,0,z}}
    local currentSide=0
    local targetSide=0
    if z>-10 then if x<0 then currentSide=-1 else currentSide=1 end end
    if target[3]>-10 then if target[1]<0 then targetSide=-1 else targetSide=1 end end
    if currentSide~=targetSide then
        if currentSide~=0 then
            if math.abs(x-currentSide*27)>3 then table.insert(points,{currentSide*27,0,z}) end
            table.insert(points,{currentSide*27,0,-18})
        end
        if targetSide~=0 then table.insert(points,{targetSide*27,0,-18}) end
    end
    table.insert(points,target)
    return points
end
return Path
