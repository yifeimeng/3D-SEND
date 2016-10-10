function [ output_args ] = indexG(selectAngle)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here

scanningHeight = 26;
scanningWidth = 26;

pathName = 'grainProcess/1115TiN/grain6/';%change for different grains
fileName = 'roiList_';
load(strcat(pathName,fileName,num2str(selectAngle),'.mat'),'roiList');
pixelCount = size(roiList,1);

spotThreshold = 0.85;

%get the averaged diffraction pattern over the selected DF image area
DPSize = 256;
load(strcat('voxelOrientation/1115TiN/send_',num2str(selectAngle,'%+d'),'.mat'),'expMatrix');
DPSum = zeros(DPSize,DPSize);
for i=1:1:pixelCount
   currX = roiList(i,1);
   currY = roiList(i,2);
   currDPIndex = currY * scanningHeight + currX + 1;
   DPSum = DPSum + double(squeeze(expMatrix(:,:,currDPIndex)));
end
DPAverage = DPSum./pixelCount;
figure;
imshow(mat2gray(DPAverage,[0,5000]));

%index the corresponding diffraction pattern
load('template.mat','signalDetails');
template = signalDetails.pureData;

beamCenter = [128,128];
centerMaskWidth = 10;
cc = 46.6;%camera constant
currTargetPattern = DPAverage;

[currBestFit, bestGauge, gaugeArray] = autoIndexGroth(beamCenter, centerMaskWidth, currTargetPattern, template, spotThreshold);
poleFig = plotIndexMap(gaugeArray);

indexResults.currBestFit = currBestFit;
indexResults.bestGauge = bestGauge;
indexResults.gaugeArray = gaugeArray;
indexResults.poleFig = poleFig;

save(strcat(pathName,fileName,num2str(selectAngle),'_indexResultsG.mat'),'indexResults');




end

