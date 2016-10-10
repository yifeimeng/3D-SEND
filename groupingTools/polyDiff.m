
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%expDpStack = readDMFilex86('SEND_+85.dm3','Log.txt','imgStack');
numDP = expDpStack.naviZDimSize;
sizeSlice = expDpStack.naviXDimSize;

%template = readDMFilex86('template.dm3','Log.txt','img');
sizeTemplate = template.naviXDimSize;

getSpotThreshold = 0.5;
dpBackground = 0.1;
edgeExcluded = 5;
maskRadius = 2;

scanningHeight = 26;
scanningWidth = 26;
polyDP = zeros(256, 256);

for i = 1:1:numDP
    currSlice = expDpStack.pureData(:,:,i);
    polyDP = polyDP + double(squeeze(currSlice));
end

polyDP(118:137,115:133) = 0;%Remove the center beam
polyDP(polyDP<0) = 0;

%display the polycrystalline diffraction pattern
%figure;
%imshow(mat2gray(polyDP, [0,80000]));

corrMatrix = getSpotList(double(template.pureData),polyDP,getSpotThreshold);
[foundPeakList, ~]=peakSearch(corrMatrix,dpBackground,edgeExcluded,sizeTemplate);%To match the original image coordinate, - template/2
numPeaks = size(foundPeakList,1);

%Display peak search results
%
figure;
plot(foundPeakList(:,1),foundPeakList(:,2),'r+');
axis equal;
axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
camroll(270);
%}

%group the virtual dark field images
%
DFImageStack = zeros(numPeaks,scanningHeight,scanningWidth);


for j = 1:1:numPeaks
    [cc, rr] = meshgrid(1:1:sizeSlice);
    cc = double(cc);
    rr = double(rr);
    centerX = double(foundPeakList(j,1));
    centerY = double(foundPeakList(j,2));
    circularMask = sqrt((rr-centerX).^2+(cc-centerY).^2) <= maskRadius;
    %imshow(circularMask)
    circularMask = int16(circularMask);
    
    
    for k = 1:1:numDP
        currDP = expDpStack.pureData(:,:,k);
        afterMaskDP = currDP.*circularMask;
        DFIntensity = sum(afterMaskDP(:));
        currX = mod(k-1, scanningHeight) + 1;
        currY = (k - currX)/scanningHeight + 1;
        DFImageStack(j, currX, currY) = DFIntensity;
    end
    
    
    %figure;
    %imshow(mat2gray(squeeze(DFImageStack(j,:,:))));
    
    
    
end

simiRelation = groupSimilarDFs(DFImageStack,0.5);
%}

%reconstruct the separated lattices
%
countGrain = 0;
for i = 1:1:numPeaks-1
    currPeak = simiRelation(i);
    if currPeak == 0
        countGrain = countGrain + 1;
        tempDPPeakList = foundPeakList(i,:);
        tempDFImg = DFImageStack(i,:,:);
        numGroupedPeaks = 1;
        %Search for other peaks belong to the same grain
        for j = i+1:1:numPeaks
            if simiRelation(j) == i
                currPeakPos = foundPeakList(j,:);
                tempDPPeakList = [tempDPPeakList;currPeakPos]; 
                tempDFImg = tempDFImg + DFImageStack(j,:,:);
                numGroupedPeaks = numGroupedPeaks + 1;
            end
        end
        grainInfo(countGrain).numPeaks = numGroupedPeaks;
        grainInfo(countGrain).DPPeakList = tempDPPeakList;
        grainInfo(countGrain).DFImg = squeeze(tempDFImg/numGroupedPeaks);
    end
end

%display the grouping results
%
for i = 1:1:countGrain
    fprintf('\nGrain #%d: %d peaks',i,grainInfo(i).numPeaks);
    
    figure;
    plot(grainInfo(i).DPPeakList(:,1),grainInfo(i).DPPeakList(:,2),'r+');
    axis equal;
    axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
    camroll(270);
    
    figure;
    imshow(mat2gray(grainInfo(i).DFImg));
end
%}
