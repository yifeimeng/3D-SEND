%this script geenerate the radial and angular profiles for a experimental
%pattern

%read the experimental data
expDpStack = readDMFilex86('+85_DP1.dm3','Log.txt','img');
sizeSlice = expDpStack.naviXDimSize;
expPattern = expDpStack.pureData;

template = readDMFilex86('template.dm3','Log.txt','img');
sizeTemplate = template.naviXDimSize;

getSpotThreshold = 0.6;
dpBackground = 0.1;
edgeExcluded = 5;
maskRadius = 2;

scanningHeight = 26;
scanningWidth = 26;

%remove the direct beam
beamCenter = [128,123];
centerMaskWidth = 10;
expPattern(beamCenter(1)-centerMaskWidth:beamCenter(1)+centerMaskWidth,beamCenter(2)-centerMaskWidth:beamCenter(2)+centerMaskWidth) = 0;
%show the expPattern
figure;
imshow(mat2gray(expPattern,[-15,300]));

%get the pos list
corrMatrix = getSpotList(template.pureData,expPattern,getSpotThreshold);
posList = double(peakSearch(corrMatrix,dpBackground,edgeExcluded,sizeTemplate));%To match the original image coordinate, - template/2
numPeaks = size(posList,1);
intensityList = zeros(numPeaks,1);
%get the intensity list
for i = 1:1:numPeaks
    intensityList(i) = expPattern(posList(i,1),posList(i,2));   
end

%Display peak search results

figure;
plot(posList(:,1),posList(:,2),'r+');
axis equal;
axis([1,sizeSlice+sizeTemplate-1,1,sizeSlice+sizeTemplate-1]);
camroll(270);
%}




%create the radial and angular profile
height = 256;
width = 256;
cc = 46.4;%camera constant
stepRadius = 2;%in the unit of pixel
stepAngle = 2;%in the unit of degree
maxRadius = 100;

expRadialProfile = powderSpectrum(posList, intensityList, maxRadius, stepRadius, beamCenter);
expAngularProfile = angularSpectrum(posList, intensityList, maxRadius, stepAngle, beamCenter);

figure;
plot(expRadialProfile);
figure;
plot(expAngularProfile);

%load simuated database
qedFileName = 'au_set2_medium.dat';
load(strcat(qedFileName,'radialProfiles.mat'),'simuRadialProfiles');
load(strcat(qedFileName,'angularProfiles.mat'),'simuAngularProfiles');
load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');

indexOneDP(stepAngle, beamCenter, cc, expRadialProfile, expAngularProfile, expPattern, simuRadialProfiles, simuAngularProfiles, patternDataMatrix);



