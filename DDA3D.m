function voxelList = DDA3D(xSize, ySize, zSize, startPos, direction)
%startPos is vector u
%directio is vector v
%the ray is u + t*v
%t>=0

%initilization
%X, Y, Z are integer to identify the voxel position
voxelList = [];
X = ceil(startPos(1));
Y = ceil(startPos(2));
Z = ceil(startPos(3));

if X == 0
    X = 1;
end

if Y == 0
    Y = 1;
end

if Z == 0
    Z = 1;
end



%initial step, tMax and tDelta for X
if (direction(1) ~= 0)
    if (direction(1) > 0)
        stepX = 1;
        firstXBound = floor(startPos(1)+1);
    else
        stepX = -1;
        firstXBound = ceil(startPos(1)-1);
    end
    tMaxX = (firstXBound - startPos(1))/direction(1);
    tDeltaX = abs(1/direction(1));
else
    stepX = 0;
    tMaxX = inf;
    tDeltaX = inf;
end
%initial step, tMax and tDelta for Y
if (direction(2) ~= 0)
    if (direction(2) > 0)
        stepY = 1;
        firstYBound = floor(startPos(2)+1);

    else
        stepY = -1;
        firstYBound = ceil(startPos(2)-1);
    end
    tMaxY = (firstYBound - startPos(2))/direction(2);
    tDeltaY = abs(1/direction(2));
else
    stepY = 0;
    tMaxY = inf;
    tDeltaY = inf;
end
%initial step, tMax and tDelta for Z
if (direction(3) ~= 0)
    if (direction(3) > 0)
        stepZ = 1;
        firstZBound = floor(startPos(3)+1);

    else
        stepZ = -1;
        firstZBound = ceil(startPos(3)-1);
    end
    tMaxZ = (firstZBound - startPos(3))/direction(3);
    tDeltaZ = abs(1/direction(3));
else
    stepZ = 0;
    tMaxZ = inf;
    tDeltaZ = inf;
end

%traverse the grid along the ray
count = 1;
while (X <= xSize && Y <= ySize && Z <= zSize && X >= 1 && Y >= 1 && Z >= 1)
    voxelList(count, 1) = X;
    voxelList(count, 2) = Y;
    voxelList(count, 3) = Z;
    if (tMaxX < tMaxY)
        if (tMaxX < tMaxZ)
            X = X + stepX;
            tMaxX = tMaxX + tDeltaX;
        else
            Z = Z + stepZ;
            tMaxZ = tMaxZ + tDeltaZ;
        end
    else
        if (tMaxY < tMaxZ)
            Y = Y + stepY;
            tMaxY = tMaxY + tDeltaY;
        else
            Z = Z + stepZ;
            tMaxZ = tMaxZ + tDeltaZ;
        end
    end
    count = count + 1;
end



end
