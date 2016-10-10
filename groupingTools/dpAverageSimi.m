function [regionAveDp, countAveDp, numDps] = dpAverageSimi(simiRelation, expPattern)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numDp = size(expPattern,3);

countAveDp = 0;
for i = 1:1:numDp-1
    currDpIndex = simiRelation(i);
    if currDpIndex == i
        countAveDp = countAveDp + 1;
        tempDp = expPattern(:,:,i);
        numGroupedDps = 1;
        %Search for other peaks belong to the same grain
        for j = i+1:1:numDp
            if simiRelation(j) == i
                tempDp = tempDp + expPattern(:,:,j);
                numGroupedDps = numGroupedDps + 1;
            end
        end
        regionAveDp(:,:,countAveDp) = tempDp/numGroupedDps;
        numDps(countAveDp) = numGroupedDps;
    end
end


end

