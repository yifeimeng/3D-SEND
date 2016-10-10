function ringMask = createMask(beamCenter, expGroupedPattern, template, outerDiameter, innerDiameter, getSpotThreshold)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numGroupedDP = size(expGroupedPattern,3);
sizeTemplate = size(template,1);
sizeSlice = size(expGroupedPattern,1);
centerMaskWidth = 12;
dpBackground = 0.1;
edgeExcluded = 10;

expGroupedPattern(beamCenter(1)-centerMaskWidth:beamCenter(1)+centerMaskWidth,beamCenter(2)-centerMaskWidth:beamCenter(2)+centerMaskWidth,:) = 0;
numTotalPeaks = 0;
totalPeakList = zeros(0,2);

for i = 1:1:numGroupedDP
    targetPattern = expGroupedPattern(:,:,i);
    corrMatrix = getSpotList(template,targetPattern,getSpotThreshold);
    [peakExist, peakList, ~] = peakSearch(corrMatrix,dpBackground,edgeExcluded);%To match the original image coordinate, - template/2
    
    if peakExist == 1
        foundPeakList = peakList - double(floor(sizeTemplate/2));
        numPeaks = size(foundPeakList,1);
        
        
        for j = 1:1:numPeaks
            overlapFlag = 0;
            thisPeak = foundPeakList(j,:);
            for k = 1:1:numTotalPeaks
                thatPeak = totalPeakList(k,:);
                peakDistance = sqrt(sum((double(thisPeak)-double(thatPeak)).^2));
                if peakDistance < 5
                    overlapFlag = 1;
                    break;
                end
            end
            if ~overlapFlag
                numTotalPeaks = numTotalPeaks + 1;
                totalPeakList = [totalPeakList;thisPeak];
            end
        end
        fprintf('\nDP#%d processed. %d peaks found. Total %d peaks.',i,numPeaks,numTotalPeaks);
    end
end


%Display peak search results
figure;
plot(totalPeakList(:,2),totalPeakList(:,1),'r+');%exactly like the DM display
axis equal;
axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
camroll(270);

%Create the ring mask
dpSize = 256;
dpSpotWidth = 3;
ringMask = ones(dpSize);


%Mask the peaks
%Mask out martensite peaks (BCC)
%{
load('w_set_medium.DSpacingList.mat');
numDSpacing = size(DSpacing,2);
error = 2;
for j = 1:1:numTotalPeaks
    centerX = double(totalPeakList(j,1));
    centerY = double(totalPeakList(j,2));
    currDSpacing = sqrt((centerX-beamCenter(1)).^2+(centerY-beamCenter(2)).^2);
    for k = 1:1:numDSpacing
        if abs(currDSpacing-DSpacing(k)) < error
            ringMask(centerX-dpSpotWidth:centerX+dpSpotWidth,centerY-dpSpotWidth:centerY+dpSpotWidth) = 0;
        end
    end
    
end
%}

%Mask out all peaks
%
for j = 1:1:numTotalPeaks
    centerX = double(totalPeakList(j,1));
    centerY = double(totalPeakList(j,2));
    ringMask(centerX-dpSpotWidth:centerX+dpSpotWidth,centerY-dpSpotWidth:centerY+dpSpotWidth) = 0;
    
end
%}


%Create the ring
%
for s = 1:1:dpSize
    for t = 1:1:dpSize
        dist2Center = sqrt((s-beamCenter(1)).^2+(t-beamCenter(2)).^2);
        if dist2Center > outerDiameter || dist2Center < innerDiameter
            ringMask(s,t) = 0;
        end
    end
end
%}

ringMask = int16(ringMask);
figure;
imshow(mat2gray(ringMask));


end

