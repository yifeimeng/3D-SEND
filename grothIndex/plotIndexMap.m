function [indexMap] = plotIndexMap(gaugeArray)
%UNTITLED11 Summary of this function goes here
%   Detailed explanation goes here
qedFileName = 'au_set2_medium.dat';
load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');

numSimuPattern = 3482;
for i=1:1:numSimuPattern
    currPatternIndex = i;
    xDMCoord = patternDataMatrix(currPatternIndex).beam(1)+2;
    yDMCoord = 95-patternDataMatrix(currPatternIndex).beam(2)+2;
    indexMap(yDMCoord,xDMCoord) = gaugeArray(i);
end

maxGaugeValue = max(gaugeArray);
figure;
imshow(indexMap,'InitialMagnification',500);
colormap hot;
caxis([0,maxGaugeValue]);

end

