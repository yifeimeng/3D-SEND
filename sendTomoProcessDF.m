function [markerDistri, voxelValue] = sendTomoProcessDF(scanInfo,grainInfo)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
exp.scanHeight = scanInfo.scanHeight;
exp.scanWidth = scanInfo.scanWidth;
exp.specimenRotAxis = scanInfo.specimenRotAxis;
exp.numUsefulProj = grainInfo.numUsefulProj;
exp.angleList = grainInfo.angleList;

res = grainInfo.resultFileNames;

%threshold is in the unit of degree
plotT = 0.01;
scanningHeight = exp.scanHeight;
scanningWidth = exp.scanWidth;
grainDistri = DFGrainCollect(exp,res);
%numGrain = size(grainToken,1);
numGrain = 1;
for i=1:1:numGrain
    xCombine(:,i) = uvwRecon(exp,grainDistri(:,i));
    fprintf('\nGrain %d recon complete.',i);
end

%Plot scattered graph for the grain
count = 0;
voxelValue = zeros(scanningHeight,scanningWidth,scanningWidth);
for i=0:1:(scanningHeight*scanningWidth*scanningWidth-1)
    voxelExist = 0;
    for k=1:1:numGrain
        if xCombine(i+1,k)>=plotT
            voxelExist = 1;
            currContribution = xCombine(i+1,k);
        end
    end
    if voxelExist==1
        count = count + 1;
        zPos = floor(i/(scanningHeight*scanningWidth))+1;
        zRem = mod(i, scanningHeight*scanningWidth);
        xPos = floor(zRem/scanningWidth)+1;
        xRem = mod(zRem, scanningWidth);
        yPos = xRem+1;
        markerDistri(count,:) = [xPos, yPos, zPos];
        %% 
        voxelValue(yPos, xPos, zPos) = currContribution;%the meshgrid of isosurface is [1:y,1:x,1:z]
    end
end
figure;

scatter3(markerDistri(:,1),markerDistri(:,2),markerDistri(:,3),30,'filled');
axis([1,scanningHeight,1,scanningWidth,1,scanningWidth]);
%surface(markerDistri(:,1),markerDistri(:,2),markerDistri(:,3),markerColor);
%plotGrainV2(markerDistri(:,1),markerDistri(:,2),markerDistri(:,3),gridSize,voxelValue);
%plotGrainV3(voxelValue);


end

