function [p1,p2,p3,peri,R,cosPoint1,orientation] = acquireTriangleInfo(pointA,pointB,pointC,indexA,indexB,indexC)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here
distanceAB = sqrt((pointA(1)-pointB(1))^2+(pointA(2)-pointB(2))^2);
distanceBC = sqrt((pointB(1)-pointC(1))^2+(pointB(2)-pointC(2))^2);
distanceAC = sqrt((pointA(1)-pointC(1))^2+(pointA(2)-pointC(2))^2);

peri = distanceAB + distanceBC + distanceAC; 

%define point 1,2,3
if distanceAB<=distanceBC && distanceBC<=distanceAC
    point1 = pointA;
    point2 = pointB;
    point3 = pointC;
    p1 = indexA;
    p2 = indexB;
    p3 = indexC;
end
if distanceAB<=distanceAC && distanceAC<=distanceBC
    point1 = pointB;
    point2 = pointA;
    point3 = pointC;
    p1 = indexB;
    p2 = indexA;
    p3 = indexC;
end
if distanceAC<=distanceBC && distanceBC<=distanceAB
    point1 = pointA;
    point2 = pointC;
    point3 = pointB;
    p1 = indexA;
    p2 = indexC;
    p3 = indexB;
end
if distanceBC<=distanceAB && distanceAB<=distanceAC
    point1 = pointC;
    point2 = pointB;
    point3 = pointA;
    p1 = indexC;
    p2 = indexB;
    p3 = indexA;
end
if distanceBC<=distanceAC && distanceAC<=distanceAB
    point1 = pointB;
    point2 = pointC;
    point3 = pointA;
    p1 = indexB;
    p2 = indexC;
    p3 = indexA;
end
if distanceAC<=distanceAB && distanceAB<=distanceBC
    point1 = pointC;
    point2 = pointA;
    point3 = pointB;
    p1 = indexC;
    p2 = indexA;
    p3 = indexB;
end

%determine the cosine
deltaX3 = point3(1)-point1(1);
deltaY3 = point3(2)-point1(2);
r3 = sqrt(deltaX3^2+deltaY3^2);
deltaX2 = point2(1)-point1(1);
deltaY2 = point2(2)-point1(2);
r2 = sqrt(deltaX2^2+deltaY2^2);

R = r3/r2;
cosPoint1 = (deltaX3*deltaX2+deltaY3*deltaY2)/(r3*r2);

%determine the rotation orientation
crossP = deltaY3*deltaX2-deltaX3*deltaY2;%cross product of V12 and V13
if crossP>0
    orientation = 1;%1 indicates counter-clockwise rotation of 1,2,3
else
    orientation = 0;
end


end

