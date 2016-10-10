function [groupedImgStack, newRepAmount, goFlag] = oneStepGroup(imgStack, repAmount, threshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numImage = size(imgStack,1);

maxCI = 0;
for i = 1:1:numImage-1
    for j = i+1:1:numImage
        
        imageA = squeeze(imgStack(i,:,:));
        imageB = squeeze(imgStack(j,:,:));
        currCI = ncc(imageA, imageB);
        
        if currCI > maxCI
            maxCI = currCI;
            maxMatchI = i;
            maxMatchJ = j;
        end
        
        
    end
end

if maxCI >= threshold
    
    totalRepAmount = repAmount(i) + repAmount(j);
    averagedImg = (imgStack(i,:,:)*repAmount(i) + imgStack(j,:,:)*repAmount(j))/totalRepAmount;
    
    tempImgStack = imgStack;
    tempImgStack(j,:,:) = [];
    tempImgStack(i,:,:) = [];
    groupedImgStack = [tempImgStack;averagedImg];
    
    tempRepAmount = repAmount;
    tempRepAmount(j) = [];
    tempRepAmount(i) = [];
    newRepAmount = [tempRepAmount;totalRepAmount];
    
    goFlag = 1;
else
    groupedImgStack = imgStack;
    newRepAmount = repAmount;
    goFlag = 0;
end

end

