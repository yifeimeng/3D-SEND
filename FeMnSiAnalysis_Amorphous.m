expStruct = readDMFilex86('send_data/021616FeMnSi/send_+75.dm3','Log.txt','imgStack');
expGroupedStruct = readDMFilex86('send_data/021616FeMnSi/processing/send_+75_grouped.dm3','Log.txt','imgStack');
templateStruct = readDMFilex86('template.dm3','Log.txt','img');

beamCenter = [125,125];%do not transpose from DM

expPattern = expStruct.pureData;
expGroupedPattern = expGroupedStruct.pureData;
template = templateStruct.pureData;
sizeSlice = expStruct.naviXDimSize;
sizeTemplate = templateStruct.naviXDimSize;
numGroupedDP = expGroupedStruct.naviZDimSize;

centerMaskWidth = 14;
getSpotThreshold = 0.80;
dpBackground = 0.1;
edgeExcluded = 10;

expGroupedPattern(beamCenter(1)-centerMaskWidth:beamCenter(1)+centerMaskWidth,beamCenter(2)-centerMaskWidth:beamCenter(2)+centerMaskWidth,:) = 0;
expPattern(beamCenter(1)-centerMaskWidth:beamCenter(1)+centerMaskWidth,beamCenter(2)-centerMaskWidth:beamCenter(2)+centerMaskWidth,:) = 0;

outerDiameter = 31;
innerDiameter = 20;
ringMask = createMask(beamCenter, expGroupedPattern,template,outerDiameter,innerDiameter,getSpotThreshold);



%generate the virtual dark field images
%initilalization
scanningHeight = 30;
DFImageRange.end = 1800;
DFImageRange.start = 1;

DFImageHeight = scanningHeight;
DFImageWidth = (DFImageRange.end - DFImageRange.start + 1)/scanningHeight;

%Generate the dark field image
currDFImage = zeros(DFImageHeight, DFImageWidth);
for k = DFImageRange.start:1:DFImageRange.end %for the whole scanning area use numDP
    currDP = expPattern(:,:,k);
    afterMaskDP = currDP.*ringMask;
    DFIntensity = sum(afterMaskDP(:));
    currX = mod(k-DFImageRange.start, scanningHeight) + 1;
    currY = (k - (DFImageRange.start - 1) -currX)/scanningHeight + 1;
    currDFImage(currX, currY) = DFIntensity;
end

figure;
imshow(mat2gray(currDFImage),'InitialMagnification',300);
%}
