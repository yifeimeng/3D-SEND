function [posList, intensityList] = reduceExpPattern(expPattern, template, beamCenter, centerMaskWidth, spotThreshold)
%This function reduce a experimental DP into peak position and intensity
%profile

sizeTemplate = size(template,1);
sizeSlice = size(expPattern, 1);
dpBackground = 0.1;
edgeExcluded = 5;

%remove the direct beam
expPattern(beamCenter(1)-centerMaskWidth:beamCenter(1)+centerMaskWidth,beamCenter(2)-centerMaskWidth:beamCenter(2)+centerMaskWidth) = 0;
%show the expPattern
%figure;
%imshow(mat2gray(expPattern,[-15,5000]));

%get the pos list
normxcorrMatrix = getSpotList(template,expPattern,spotThreshold);
[peakExist, peakList, peakCorr] = peakSearch(normxcorrMatrix,dpBackground,edgeExcluded);%To match the original image coordinate, - template/2
posList = double(peakList-floor(sizeTemplate/2));

xcorrMatrix = xcorr2(expPattern,template);

numPeak = size(posList,1);
intensityList = zeros(numPeak,1);
for i=1:1:numPeak
    intensityList(i) = sqrt(xcorrMatrix(peakList(i,1),peakList(i,2)));%may change to get different scale
    %intensityList(i) = expPattern(posList(i,1),posList(i,2));
end

%Display peak search results
%{
figure;
plot(posList(:,1),posList(:,2),'r+');
axis equal;
axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
camroll(270);
%}

end

