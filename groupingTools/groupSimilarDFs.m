function simiRelation = groupSimilarDFs(DFImageStack, matchImageThreshold)
%This function tries to group similar dark field images 

numImage = size(DFImageStack,1);
simiTable = zeros(numImage, numImage);
imgHeight = size(DFImageStack,2);
imgWidth = size(DFImageStack,3);

countPair = 0;
simiArray = zeros(numImage*(numImage-1)/2,3);
for i = 1:1:numImage-1
    for j = i+1:1:numImage
        
        imageA = squeeze(DFImageStack(i,:,:));
        imageB = squeeze(DFImageStack(j,:,:));
        currCI = ncc(imageA, imageB);
        %currHD = averageHash(imageA, imageB, 6);
        %simiTableHD(i,j) = currHD;
        if isnan(currCI)
            currCI = -1;
        end
        simiTable(i,j) = currCI;
        
        countPair = countPair + 1;
        simiArray(countPair,1) = currCI;
        simiArray(countPair,2) = i;
        simiArray(countPair,3) = j;
        
    end
    %fprintf('\nGenerate ncc for %d',i);
end

[sorted, arrange] = sort(simiArray(:,1),'descend');
sortedSimiArray = simiArray(arrange,:);

index = 1;
CI = sortedSimiArray(index,1);
simiRelation = zeros(numImage,1);
while CI >= matchImageThreshold
    simiRelation(sortedSimiArray(index,3)) = sortedSimiArray(index,2);
    index = index + 1;
    if index > countPair
        break;
    end
    CI = sortedSimiArray(index,1);
end

%Reduce the simiRelation tree
for i = 1:1:numImage;
    if simiRelation(i) ~= 0
        root = simiRelation(i);
        while simiRelation(root) ~= 0
            root = simiRelation(root);
        end
        simiRelation(i) = root;
    end
end



end

