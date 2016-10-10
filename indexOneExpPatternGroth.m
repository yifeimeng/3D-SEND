selectAngle = 0;
selectPattern = 283;
cc = 74.8;%camera constant
beamCenter = [128,128];
spotThreshold = 0.85;
load(strcat('voxelOrientation/1115TiN/SEND_',num2str(selectAngle,'%+d'),'.mat'),'expMatrix');

%index the corresponding diffraction pattern
load('template.mat','signalDetails');
template = signalDetails.pureData;

centerMaskWidth = 15;

currTargetPattern = double(expMatrix(:,:,selectPattern));
figure;
imshow(mat2gray(currTargetPattern,[0,2000]));

[currBestFit, bestGauge, gaugeArray] = autoIndexGroth(beamCenter, centerMaskWidth, currTargetPattern, template, spotThreshold);
poleFig = plotIndexMap(gaugeArray);

indexResults.currBestFit = currBestFit;
indexResults.bestGauge = bestGauge;
indexResults.gaugeArray = gaugeArray;
indexResults.poleFig = poleFig;

%save(strcat(pathName,fileName,num2str(selectAngle),'_indexResultsG.mat'),'indexResults');