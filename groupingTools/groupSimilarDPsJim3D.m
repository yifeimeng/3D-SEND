function simiRelation = groupSimilarDPsJim3D(DPSet, threshold, scanningHeight, scanningWidth)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

groupedFlag = zeros(scanningHeight, scanningHeight, scanningWidth);

numVoxels = scanningHeight*scanningHeight*scanningWidth;
smx = randperm(numVoxels);

for i=1:1:numVoxels
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


end

