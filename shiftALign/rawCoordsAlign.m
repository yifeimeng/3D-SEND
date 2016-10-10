function [ output_args ] = rawCoordsAlign(grainInfo,shiftList, width, height)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = 1:1:grainInfo.numUsefulProj
    fullName = strcat(grainInfo.roiFolderName,grainInfo.roiFileName,num2str(grainInfo.angleList(i)),'.mat');
    load(fullName,'roiList');
    numLength = size(roiList,1);
    angleOrder = (grainInfo.angleList(i)+75)/5+1;
    
    shiftX = shiftList(angleOrder,1);
    shiftY = shiftList(angleOrder,2);
    
    alignMatrix = zeros(numLength,2);
    alignMatrix(:,1) = shiftX;
    alignMatrix(:,2) = shiftY;
    
    alignedRoiList = roiList +alignMatrix;%alignedCoordList should be saved for processing
    alignedRoiList(alignedRoiList<0) = 0;%for large shift use, may be deleted
    alignedRoiList(alignedRoiList>(height-1)) = height - 1;
    saveFileName = strcat(grainInfo.roiFolderName,grainInfo.roiSaveFileName,num2str(grainInfo.angleList(i)),'.mat');
    save(saveFileName,'alignedRoiList');
    
    %Create image for the alignedCoordList
    alignedSilhouette = zeros(height,width);
    for k=1:1:numLength
        alignedSilhouette(alignedRoiList(k,2)+1,alignedRoiList(k,1)+1) = 1;%fix the coordinate system
    end
    figure;
    imshow(alignedSilhouette);
end
 




end

