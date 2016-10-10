function simiRelation = groupSimilarDFsJim(DFImageStack, matchImageThreshold)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numImage = size(DFImageStack,1);
groupedFlag = zeros(numImage,1);
smx = randperm(numImage);

for i = 1:1:numImage
    index = smx(i);
    if groupedFlag(index) == 0
        for j = index+1:1:numImage
            imageA = squeeze(DFImageStack(index,:,:));
            imageB = squeeze(DFImageStack(j,:,:));
            currCI = ncc(imageA, imageB);
            if currCI >= matchImageThreshold
                groupedFlag(j) = index;
            end
        end
    end
end

simiRelation = groupedFlag;

end

