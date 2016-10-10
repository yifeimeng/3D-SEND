function [usefulGrainCount, usefulGrainDF] = polyDiffPreAverageExcludePhase(expStruct, expGroupedStruct, templateStruct, beamCenter, groupDFsThreshold, getSpotThreshold, scanningArea, DFImageRange)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numDP = expStruct.naviZDimSize;
sizeSlice = expStruct.naviXDimSize;
expPattern = expStruct.pureData;

numGroupedDP = expGroupedStruct.naviZDimSize;
sizeSlice = expGroupedStruct.naviXDimSize;
expGroupedPattern = expGroupedStruct.pureData;

sizeTemplate = templateStruct.naviXDimSize;
template = templateStruct.pureData;

dpBackground = 0.1;
edgeExcluded = 10;
maskRadius = 3;

scanningHeight = scanningArea.height;
scanningWidth = scanningArea.width;

%remove the direct beam
centerMaskWidth = 15;
expGroupedPattern(beamCenter(1)-centerMaskWidth:beamCenter(1)+centerMaskWidth,beamCenter(2)-centerMaskWidth:beamCenter(2)+centerMaskWidth,:) = 0;

%
numTotalPeaks = 0;
totalPeakList = zeros(0,2);
load('w_set_medium.DSpacingList.mat');
numDSpacing = size(DSpacing,2);
error = 3;

for i = 1:1:numGroupedDP
    corrMatrix = getSpotList(template,expGroupedPattern(:,:,i),getSpotThreshold);
    [peakExist, peakList, ~] = peakSearch(corrMatrix,dpBackground,edgeExcluded);%To match the original image coordinate, - template/2
    if peakExist == 1
        foundPeakList = peakList - double(floor(sizeTemplate/2));
        numPeaks = size(foundPeakList,1);
        for j = 1:1:numPeaks
            overlapFlag = 0;
            excludePhase = 0;
            thisPeak = foundPeakList(j,:);
            thisPeakX = thisPeak(1);
            thisPeakY = thisPeak(2);
            currDSpacing = sqrt((thisPeakX-beamCenter(1)).^2+(thisPeakY-beamCenter(2)).^2);
            for k = 1:1:numDSpacing
                if abs(currDSpacing-DSpacing(k)) < error
                    excludePhase = 1;
                end
            end
            for k = 1:1:numTotalPeaks
                thatPeak = totalPeakList(k,:);
                peakDistance = sqrt(sum((double(thisPeak)-double(thatPeak)).^2));
                if peakDistance < 6
                    overlapFlag = 1;
                    break;
                end
            end
            if ~overlapFlag && ~excludePhase
                numTotalPeaks = numTotalPeaks + 1;
                totalPeakList = [totalPeakList;thisPeak];
            end
        end
        
        fprintf('\nDP#%d processed. %d peaks found. Total %d peaks.',i,numPeaks,numTotalPeaks);
    end
end
%Display peak search results

figure;
plot(totalPeakList(:,1),totalPeakList(:,2),'r+');
axis equal;
axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
camroll(270);
%}


%generate the virtual dark field images
%

DFImageHeight = scanningHeight;
DFImageWidth = (DFImageRange.end - DFImageRange.start + 1)/scanningHeight;
DFImageStack = zeros(numTotalPeaks,DFImageHeight,DFImageWidth);%modified


for j = 1:1:numTotalPeaks
    [cc, rr] = meshgrid(1:1:sizeSlice);
    cc = double(cc);
    rr = double(rr);
    centerX = double(totalPeakList(j,1));
    centerY = double(totalPeakList(j,2));
    circularMask = sqrt((rr-centerX).^2+(cc-centerY).^2) <= maskRadius;
    %imshow(circularMask)
    circularMask = int16(circularMask);
    
    %Generate the dark field image
    currDFImage = zeros(DFImageHeight, DFImageWidth);
    for k = DFImageRange.start:1:DFImageRange.end %for the whole scanning area use numDP
        currDP = expPattern(:,:,k);
        afterMaskDP = currDP.*circularMask;
        DFIntensity = sum(afterMaskDP(:));
        currX = mod(k-DFImageRange.start, scanningHeight) + 1;
        currY = (k - (DFImageRange.start - 1) -currX)/scanningHeight + 1;
        currDFImage(currX, currY) = DFIntensity;
    end
    
    
    %figure;
    %imshow(mat2gray(squeeze(DFImageStack(j,:,:))));
    
    %try remove the background ----------- tricky!
    maxPixelIntensity = max(currDFImage(:));
    minCutoff = maxPixelIntensity*0.10;
    maxCutoff = maxPixelIntensity*0.90;
    DFImageStack(j,:,:) = mat2gray(currDFImage,[minCutoff,maxCutoff]);
    
    fprintf('\ndark-field image generated for peak %d',j);
end
%}

%group all virtual dark field images
%
simiRelation = groupSimilarDFs(DFImageStack,groupDFsThreshold);
%}


%reconstruct the separated lattices
%
countGrain = 0;
SecondDFStack = [];
for i = 1:1:numTotalPeaks-1
    currPeak = simiRelation(i);
    if currPeak == 0
        countGrain = countGrain + 1;
        tempDPPeakList = totalPeakList(i,:);
        tempDFImg = DFImageStack(i,:,:);
        numGroupedPeaks = 1;
        %Search for other peaks belong to the same grain
        for j = i+1:1:numTotalPeaks
            if simiRelation(j) == i
                currPeakPos = totalPeakList(j,:);
                tempDPPeakList = [tempDPPeakList;currPeakPos]; 
                tempDFImg = tempDFImg + DFImageStack(j,:,:);
                numGroupedPeaks = numGroupedPeaks + 1;
            end
        end
        grainInfo(countGrain).numPeaks = numGroupedPeaks;
        grainInfo(countGrain).DPPeakList = tempDPPeakList;
        grainInfo(countGrain).DFImg = squeeze(tempDFImg/numGroupedPeaks);
        
        SecondDFStack(countGrain,:,:) = squeeze(tempDFImg/numGroupedPeaks);
    end
end

fprintf('\n%d grain reconstructed.',countGrain);
%display the grouping results
%
numRecordedPeaks = 0;
plotIndex = 0;
figure;
usefulGrainCount = 0;
for i = 1:1:countGrain
    fprintf('\nGrain #%d: %d peaks',i,grainInfo(i).numPeaks);
    
    if grainInfo(i).numPeaks > 3
        
        usefulGrainCount = usefulGrainCount + 1;
        usefulGrainDF(usefulGrainCount).DFImg = grainInfo(i).DFImg;  
        
        plotIndex = plotIndex + 1;
        subplot(7,6,plotIndex);
        plot(grainInfo(i).DPPeakList(:,1),grainInfo(i).DPPeakList(:,2),'r+');
        axis equal;
        axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
        camroll(270);
        
        plotIndex = plotIndex + 1;
        subplot(7,6,plotIndex);
        imshow(mat2gray(grainInfo(i).DFImg));
        
        numRecordedPeaks = numRecordedPeaks + grainInfo(i).numPeaks;
    end
end
fprintf('\nTotal %d peaks. Record %d peaks.',numTotalPeaks,numRecordedPeaks);

end

