function [currBestFit, bestGauge, gaugeArray] = autoIndexGroth(beamCenter, centerMaskWidth, currTargetPattern, template, spotThreshold)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here

sizeTemplate = size(template,1);
sizeSlice = size(currTargetPattern,1);
%remove the direct beam
currTargetPattern(beamCenter(1)-centerMaskWidth:beamCenter(1)+centerMaskWidth,beamCenter(2)-centerMaskWidth:beamCenter(2)+centerMaskWidth) = 0;
%show the expPattern
%figure;
%imshow(mat2gray(currTargetPattern,[-15,500]));

%get the pos list
dpBackground = 0.1;
edgeExcluded = 5;
normxcorrMatrix = getSpotList(template,currTargetPattern,spotThreshold);
[peakExist, peakList, peakCorr] = peakSearch(normxcorrMatrix,dpBackground,edgeExcluded);%To match the original image coordinate, - template/2
rawPosList = double(peakList-floor(sizeTemplate/2));

%Display peak search results
%{
figure;
plot(posList(:,1),posList(:,2),'r+');
axis equal;
axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
camroll(270);
%}

%rank the spots based on intensities
numPeaksMaximum = 20;
if size(rawPosList,1)>numPeaksMaximum
    posList = rawPosList(1:numPeaksMaximum,:);
else
    posList = rawPosList;
end

%Create the point list for experiment
numPoints = size(posList,1);

if numPoints >= 3
    %Create the triangle list for the experiment data
    expTriangleCount = 0;
    for i=1:1:numPoints-2
        for j=i+1:1:numPoints-1
            for k=j+1:1:numPoints
                expTriangleCount = expTriangleCount + 1;
                pointA = posList(i,:);
                pointB = posList(j,:);
                pointC = posList(k,:);
                [p1,p2,p3,peri,R,cosPoint1,orientation] = acquireTriangleInfo(pointA,pointB,pointC,i,j,k);
                expTriangleList(expTriangleCount,:) = [p1,p2,p3,peri,R,cosPoint1,orientation];
            end
        end
    end
    
    %load the simulated patterns from the database
    load('simuTriangleList_021016TiN.mat', 'simuTriangleList');
    load('simuNumTriangle_021016TiN.mat', 'simuNumTriangleList');
    load('simuNumSelectedSpots_021016TiN.mat', 'simuNumSelectedSpots');
    
    
    %Match the exp triangle list with each simu triangle list
    numSimuPattern = 3482;
    bestGauge = 0;
    currBestFit = 1;%initialization
    for i=1:1:numSimuPattern
        spotMatchMatrix = zeros(numPoints,simuNumSelectedSpots(i));
        [matchList,matchCount,vote]=matchTrianglesV2(expTriangleList,simuTriangleList(:,:,i),expTriangleCount,simuNumTriangleList(i),numPoints);
        if matchCount > 0
            %Create the 2D spot match matrix
            for k=1:1:matchCount
                triangleIndexA = matchList(k,1);
                triangleIndexB = matchList(k,2);
                triangleA = expTriangleList(triangleIndexA,:);
                triangleB = simuTriangleList(triangleIndexB,:,i);
                spotMatchMatrix(triangleA(1),triangleB(1)) = spotMatchMatrix(triangleA(1),triangleB(1)) + 1;
                spotMatchMatrix(triangleA(2),triangleB(2)) = spotMatchMatrix(triangleA(2),triangleB(2)) + 1;
                spotMatchMatrix(triangleA(3),triangleB(3)) = spotMatchMatrix(triangleA(3),triangleB(3)) + 1;
            end
            
            thisGauge = max(max(spotMatchMatrix));
        else
            thisGauge = 0;
        end
        if thisGauge>bestGauge
            currBestFit = i;
            bestGauge = thisGauge;
        end
        gaugeArray(i) = thisGauge;
        fprintf('\nmatch of pattern %d is %d',i,thisGauge);
    end
    
    fprintf('\nBest fit is %d w/ max parameter %d',currBestFit,bestGauge);
    
else
    fprintf('\nToo few spots. Fail to index.');
    currBestFit = [];
    bestGauge = [];
    gaugeArray = [];
end



end

