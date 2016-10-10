function simiRelation = groupSimilarDPsJim(DPImageStack, matchImageThreshold)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

numImage = size(DPImageStack,3);
groupedFlag = zeros(numImage,1);
smx = randperm(numImage);

for i = 1:1:numImage
    index = smx(i);
    if groupedFlag(index) == 0
        groupedFlag(index) = index;
        for j = index+1:1:numImage
            imageA = squeeze(DPImageStack(:,:,index));
            imageB = squeeze(DPImageStack(:,:,j));
            currCI = ncc(double(imageA), double(imageB));
            if currCI >= matchImageThreshold
                groupedFlag(j) = index;
            end
        end
    end
end

simiRelation = groupedFlag;
end

