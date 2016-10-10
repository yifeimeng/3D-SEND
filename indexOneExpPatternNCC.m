selectAngle = 0;
selectPattern = 316;
load(strcat('voxelOrientation/1115TiN/send_',num2str(selectAngle,'%+d'),'.mat'),'expMatrix');
currTargetPattern = double(expMatrix(:,:,selectPattern));
figure;
imshow(mat2gray(currTargetPattern,[0,2000]));

%index the corresponding diffraction pattern
load('template.mat','signalDetails');
template = signalDetails.pureData;

qedFileName = 'tin_set_medium.dat';
spotThreshold = 0.6;
beamCenter = [128,128];
centerMaskWidth = 10;
cc = 74.8;%camera constant
stepRadius = 5;%in the unit of pixel
stepAngle = 10;%in the unit of degree
maxRadius = 100;

[bestMatchBeam, bestMatchSimuDP, mirrorFlag, matchFactor, poleFig] = indexDPExtended(currTargetPattern, template, qedFileName, spotThreshold, beamCenter, centerMaskWidth, cc, stepRadius, stepAngle, maxRadius);
simuDPMask = (sqrt(bestMatchSimuDP)>0) == 0;
display(bestMatchBeam);
figure;
imshow(mat2gray(simuDPMask));

indexResults.bestMatchBeam = bestMatchBeam;
indexResults.bestMatchSimuDP = bestMatchSimuDP;
indexResults.matchFactor = matchFactor;
indexResults.poleFig = poleFig;

figure;
imshow(poleFig','InitialMagnification',500);
colormap(hot);
caxis([-1,1]);