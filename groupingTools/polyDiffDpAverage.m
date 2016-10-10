%
expStruct = readDMFilex86('1115TiN/send_+10.dm3','Log.txt','imgStack');
numDP = expStruct.naviZDimSize;
sizeSlice = expStruct.naviXDimSize;
expPattern = expStruct.pureData;

%remove the direct beam
beamCenter = [126,130];
centerMaskWidth = 20;
expPattern(beamCenter(1)-centerMaskWidth:beamCenter(1)+centerMaskWidth,beamCenter(2)-centerMaskWidth:beamCenter(2)+centerMaskWidth,:) = 0;

%group the diffraction patterns
dpSimiRelation = groupSimilarDPsJim(expPattern,0.6);
[regionAveDp, countAveDp, numDpsInOneAve] = dpAverageSimi(dpSimiRelation, expPattern);
fprintf('\n%d DPs are grouped into %d averaged DPs.', numDP, countAveDp);

%{
plotIndex = 0;
numRecordedDps = 0;
for i = 1:1:numAveDp
    fprintf('\nAveraged DP #%d: %d dps',i,aveDpInfo(i).numDps);
    
    if aveDpInfo(i).numDps > 5
        
        plotIndex = plotIndex + 1;
        subplot(6,6,plotIndex);
        imshow(mat2gray(aveDpInfo(i).aveDp));
        
        numRecordedDps = numRecordedDps + aveDpInfo(i).numDps;
    end
end

fprintf('\nTotal %d Dps. Record %d dps.',numDP,numRecordedDps);
%}

%}

templateStruct = readDMFilex86('template.dm3','Log.txt','img');
sizeTemplate = templateStruct.naviXDimSize;
template = templateStruct.pureData;

getSpotThreshold = 0.9;
dpBackground = 0.4;
edgeExcluded = 10;
maskRadius = 5;

scanningHeight = 26;
scanningWidth = 26;

%
numTotalPeaks = 0;
totalPeakList = zeros(0,2);
for i = 1:1:countAveDp
    corrMatrix = getSpotList(template,regionAveDp(:,:,i),getSpotThreshold);
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
                if peakDistance < 10
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
plot(totalPeakList(:,1),totalPeakList(:,2),'r+');
axis equal;
axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
camroll(270);
%}

%generate the virtual dark field images
%
DFImageStack = zeros(numTotalPeaks,scanningHeight,scanningWidth);


for j = 1:1:numTotalPeaks
    [cc, rr] = meshgrid(1:1:sizeSlice);
    cc = double(cc);
    rr = double(rr);
    centerX = double(totalPeakList(j,1));
    centerY = double(totalPeakList(j,2));
    circularMask = sqrt((rr-centerX).^2+(cc-centerY).^2) <= maskRadius;
    %imshow(circularMask)
    circularMask = int16(circularMask);
    
    currDFImage = zeros(scanningHeight,scanningWidth);
    for k = 1:1:numDP
        currDP = expPattern(:,:,k);
        afterMaskDP = currDP.*circularMask;
        DFIntensity = sum(afterMaskDP(:));
        currX = mod(k-1, scanningHeight) + 1;
        currY = (k - currX)/scanningHeight + 1;
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
simiRelation = groupSimilarDFsJim(DFImageStack,0.4);
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
for i = 1:1:countGrain
    fprintf('\nGrain #%d: %d peaks',i,grainInfo(i).numPeaks);
    
    if grainInfo(i).numPeaks > 5
        
        plotIndex = plotIndex + 1;
        subplot(7,4,plotIndex);
        plot(grainInfo(i).DPPeakList(:,1),grainInfo(i).DPPeakList(:,2),'r+');
        axis equal;
        axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
        camroll(270);
        
        plotIndex = plotIndex + 1;
        subplot(7,4,plotIndex);
        imshow(mat2gray(grainInfo(i).DFImg));
        
        numRecordedPeaks = numRecordedPeaks + grainInfo(i).numPeaks;
    end
end
fprintf('\nTotal %d peaks. Record %d peaks.',numTotalPeaks,numRecordedPeaks);
%}

