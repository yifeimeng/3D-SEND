function contri = spaceMask(currVoxel, rotAxis)
%define a point on the axis, it's the pivot 
M1 = [38,16,13];
%define the target point
M0 = currVoxel;
%Calculate the distance between M0 and the line
M0M1 = M1 - M0;
distance = norm(cross(M0M1,rotAxis))/norm(rotAxis);
radLimit = getPillarRad(M0,M1,distance);
if (distance<radLimit) 
    contri = 1;
else
    contri = 0;
end
end

function rad = getPillarRad(currVoxel,pivot,distanceToLine)
pillarHeight = 36; %the height is 24 pixels
botRad = 12;
topRad = 6;
distanceToPivot = norm(currVoxel - pivot);
length = sqrt(distanceToPivot^2-distanceToLine^2);
if (length<pillarHeight) 
    rad = (length/pillarHeight)*topRad + (1-length/pillarHeight)*botRad;
else
    rad = 0;
end

end