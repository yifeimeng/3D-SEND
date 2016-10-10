function [simuNumTriangleList,simuTriangleList] = generateSimuDPTriangleLists(CCDSize,cameraConstant)
%UNTITLED6 Summary of this function goes here
%   Detailed explanation goes here

qedFileName = 'tin_set_medium.dat';
load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');
numPattern = size(patternDataMatrix,2);

%generate a point list
for i=1:1:numPattern
    spotCount = 0;
    for j=1:1:patternDataMatrix(i).numSpot
        x = patternDataMatrix(i).spot(j,5)*cameraConstant;
        y = patternDataMatrix(i).spot(j,6)*cameraConstant;
        if abs(x)<=CCDSize(1)/2 && abs(y)<=CCDSize(2)/2
            spotCount = spotCount + 1;
            spotList(spotCount,:,i) = [x,y]; 
        end
    end
    spotCountList(i) = spotCount;
end

%generate a triangle list from the spotList
numSpotLimit = 20;
for i=1:1:numPattern
    currPoints = spotList(:,:,i);
    currNumSpots = spotCountList(i);
    if currNumSpots>numSpotLimit
        numSelectedSpots = numSpotLimit;
    else
        numSelectedSpots = currNumSpots;
    end
    triangleCount = 0;
    for j=1:1:numSelectedSpots-2
        for k=j+1:1:numSelectedSpots-1
            for l=k+1:1:numSelectedSpots
                triangleCount = triangleCount + 1;
                pointA = currPoints(j,:);
                pointB = currPoints(k,:);
                pointC = currPoints(l,:);
                [p1,p2,p3,peri,R,cosPoint1,orientation] = acquireTriangleInfo(pointA,pointB,pointC,j,k,l);
                simuTriangleList(triangleCount,:,i) =  [p1,p2,p3,peri,R,cosPoint1,orientation];
            end
        end
    end
    simuNumSelectedSpots(i) = numSelectedSpots;
    simuNumTriangleList(i) = triangleCount;
    fprintf('\nProcess pattern %d',i);
end 

save('simuTriangleList_1115TiN.mat','simuTriangleList');
save('simuNumTriangle_1115TiN.mat', 'simuNumTriangleList');
save('simuNumSelectedSpots_1115TiN.mat','simuNumSelectedSpots');

end

