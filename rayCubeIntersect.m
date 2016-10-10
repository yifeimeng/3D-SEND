function intersectPoint = rayCubeIntersect(gridSize, source, direction)
normOXY = [0;0;1];
normOYZ = [1;0;0];
normOZX = [0;1;0];
count = 0;
siList = [];
%Check with bottom face
if (direction*normOXY ~= 0)
    [sectPoint, si] = linePlaneIntersect([0,0,0],normOXY,source,direction);
    x = sectPoint(1);
    y = sectPoint(2);
    if (x>=0 && x<=gridSize && y>=0 && y<=gridSize)
        count = count + 1;
        pointList(count,:) = sectPoint;
        siList(count) = si;
    end
end

%Check with top face
if (direction*normOXY ~= 0)
    [sectPoint, si] = linePlaneIntersect([0,0,gridSize],normOXY,source,direction);
    x = sectPoint(1);
    y = sectPoint(2);
    if (x>=0 && x<=gridSize && y>=0 && y<=gridSize)
        count = count + 1;
        pointList(count,:) = sectPoint;
        siList(count) = si;
    end
end

%Check with left face
if (direction*normOZX ~= 0)
    [sectPoint, si] = linePlaneIntersect([0,0,0],normOZX,source,direction);
    x = sectPoint(1);
    z = sectPoint(3);
    if (x>=0 && x<=gridSize && z>=0 && z<=gridSize)
        count = count + 1;
        pointList(count,:) = sectPoint;
        siList(count) = si;
    end
end
    
%Check with right face
if (direction*normOZX ~= 0)
    [sectPoint, si] = linePlaneIntersect([0,gridSize,0],normOZX,source,direction);
    x = sectPoint(1);
    z = sectPoint(3);
    if (x>=0 && x<=gridSize && z>=0 && z<=gridSize)
        count = count + 1;
        pointList(count,:) = sectPoint;
        siList(count) = si;
    end
end

%Check with back face
if (direction*normOYZ ~= 0)
    [sectPoint, si] = linePlaneIntersect([0,0,0],normOYZ,source,direction);
    y = sectPoint(2);
    z = sectPoint(3);
    if (y>=0 && y<=gridSize && z>=0 && z<=gridSize)
        count = count + 1;
        pointList(count,:) = sectPoint;
        siList(count) = si;
    end
end

%Check with front face
if (direction*normOYZ ~= 0)
    [sectPoint, si] = linePlaneIntersect([gridSize,0,0],normOYZ,source,direction);
    y = sectPoint(2);
    z = sectPoint(3);
    if (y>=0 && y<=gridSize && z>=0 && z<=gridSize)
        count = count + 1;
        pointList(count,:) = sectPoint;
        siList(count) = si;
    end
end

if (~isempty(siList))
    [M, I] = min(siList);
    intersectPoint = pointList(I,:);
else
    intersectPoint = [NaN, NaN, NaN];
end

end

