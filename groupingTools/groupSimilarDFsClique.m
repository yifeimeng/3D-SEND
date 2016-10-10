function simiRelation = groupSimilarDFsClique(DFImageStack, matchImageThreshold)
%this function group DFs when any pair share a ncc larger than the
%treshold.

numImage = size(DFImageStack,1);
imgHeight = size(DFImageStack,2);
imgWidth = size(DFImageStack,3);

countPair = 0;
simiArray = zeros(numImage*(numImage-1)/2,3);
simiTable = zeros(numImage, numImage);
for i = 1:1:numImage-1
    for j = i+1:1:numImage
        
        imageA = squeeze(DFImageStack(i,:,:));
        imageB = squeeze(DFImageStack(j,:,:));
        currCI = ncc(imageA, imageB);
        %currHD = averageHash(imageA, imageB, 6);
        %simiTableHD(i,j) = currHD;
        simiTable(i,j) = currCI;
        
        countPair = countPair + 1;
        simiArray(countPair,1) = currCI;
        simiArray(countPair,2) = i;
        simiArray(countPair,3) = j;
        
    end
end

[sorted, arrange] = sort(simiArray(:,1),'descend');
sortedSimiArray = simiArray(arrange,:);

groupTag = zeros(numImage,1);
numImageInGroup = zeros(numImage,1);
index = 1;
CI = sortedSimiArray(index,1);
simiRelation = zeros(numImage,1);
while CI >= matchImageThreshold
    dfA = sortedSimiArray(index,2);
    dfB = sortedSimiArray(index,3);
    if groupTag(dfA) == 0 && groupTag(dfB) == 0
        groupTag(dfA) = dfA;
        groupTag(dfB) = dfA;
        numImageInGroup(dfA) = 2;
    end
    if groupTag(dfA) > 0 && groupTag(dfB) == 0
        flag = 1;
        for i=1:1:numImage
            if groupTag(i) == groupTag(dfA) && simiTable(i,dfB) < matchImageThreshold
                flag = 0;
                break;
            end
        end
        if flag           
            groupTag(dfB) = groupTag(dfA);
            numImageInGroup(groupTag(dfA)) = numImageInGroup(groupTag(dfA)) + 1;
        end
    end
    if groupTag(dfA) == 0 && groupTag(dfB) > 0
        flag = 1;
        for i=1:1:numImage
            if groupTag(i) == groupTag(dfB) && simiTable(i,dfA) < matchImageThreshold
                flag = 0;
                break;
            end
        end
        if flag
            groupTag(dfA) = groupTag(dfB);
            numImageInGroup(groupTag(dfB)) = numImageInGroup(groupTag(dfB)) + 1;
        end
    end
    if groupTag(dfA) > 0 && groupTag(dfB) > 0
        flag = 1;
        for i=1:1:numImage
            for j=1:1:numImage
                if groupTag(i) == groupTag(dfA) && groupTag(j) == groupTag(dfB) && simiTable(i,j) < matchImageThreshold
                    flag = 0;
                    break;
                end
            end
        end
        if flag
            for k=1:1:numImage
                if groupTag(k) == groupTag(dfB);
                    groupTag(dfB) = groupTag(dfA);
                    
                end
            end
            numImageInGroup(groupTag(dfA)) = numImageInGroup(groupTag(dfA)) + numImageInGroup(groupTag(dfB));
            numImageInGroup(groupTag(dfB)) = 0;
        end
                
    end
    index = index + 1;
    CI = sortedSimiArray(index,1);
end

%convert the groupTag to simiRelation
simiRelation = groupTag;
for i=1:1:numImage
    if simiRelation(i) == i
        simiRelation(i) = 0;
    end
end


end

