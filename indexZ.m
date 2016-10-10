function [ output_args ] = indexZ()
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

scanningHeight = 26;
scanningWidth = 26;
selectAngle = -45;%change for a different angle
folderName = '070415_DF_grain_v2/grain5/';%change for different grains
fileName = 'roiList_';
load(strcat(folderName,fileName,num2str(selectAngle),'.mat'),'roiList');
pixelCount = size(roiList,1);

%get the averaged diffraction pattern over the selected DF image area
DPSize = 256;
load(strcat('voxelOrientation/SEND_',num2str(selectAngle),'.mat'),'expMatrix');
DPSum = zeros(DPSize,DPSize);
for i=1:1:pixelCount
   currX = roiList(i,1);
   currY = roiList(i,2);
   currDPIndex = currY * scanningWidth + currX + 1;
   DPSum = DPSum + double(squeeze(expMatrix(:,:,currDPIndex)));
end
DPAverage = DPSum./pixelCount;
figure;
imshow(mat2gray(DPAverage,[0,200]));

%index the corresponding diffraction pattern
load('template.mat','signalDetails');
template = signalDetails.pureData;

qedFileName = 'au_set2_medium.dat';
spotThreshold = 0.7;
beamCenter = [127,123];
centerMaskWidth = 10;
cc = 46.4;%camera constant
stepRadius = 5;%in the unit of pixel
stepAngle = 10;%in the unit of degree
maxRadius = 100;
currTargetPattern = DPAverage;

[bestMatchBeam, bestMatchSimuDP, mirrorFlag, matchFactor, poleFig] = indexDPExtended(currTargetPattern, template, qedFileName, spotThreshold, beamCenter, centerMaskWidth, cc, stepRadius, stepAngle, maxRadius);
simuDPMask = (sqrt(bestMatchSimuDP)>0) == 0;
display(bestMatchBeam);
figure;
imshow(mat2gray(simuDPMask));

indexResults.bestMatchBeam = bestMatchBeam;
indexResults.bestMatchSimuDP = bestMatchSimuDP;
indexResults.matchFactor = matchFactor;
indexResults.poleFig = poleFig;

save(strcat(folderName,fileName,num2str(selectAngle),'_indexResultsZ.mat'),'indexResults');

end

