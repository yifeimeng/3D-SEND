function voxelList = DDA2D(gridSize, startPos, direction)
%startPos is vector u
%directio is vector v
%the ray is u + t*v
%t>=0

%initilization
%X, Y are integer to identify the voxel position
if (direction(1) > 0)
    X = ceil(startPos(1));
    stepX = 1;
end
if (direction(1) < 0)
    X = floor(startPos(1));
    stepX = -1;
end
%calculate first boundary
tMaxX = abs((X - startPos(1))/direction(1));

if (direction(2) > 0)
    Y = ceil(startPos(2));
    stepY = 1;
end
if (direction(2) < 0)
    Y = floor(startPos(2));
    stepY = -1;
end
tMaxY = abs((Y - startPos(2))/direction(2));
%calculate tDelataX,Y
tDeltaX = abs(1/direction(1));
tDeltaY = abs(1/direction(2));

%traverse the grid along the ray
count = 1;
while (X <= gridSize(1) && Y <= gridSize(2))
    voxelList(count, 1) = X;
    voxelList(count, 2) = Y;
    if (tMaxX < tMaxY)
        tMaxX = tMaxX + tDeltaX;
        X = X + stepX;
    else
        tMaxY = tMaxY + tDeltaY;
        Y = Y + stepY;
    end
    count = count + 1;
end

end