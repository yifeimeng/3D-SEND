expDpStruct = readDMFilex86('YSZ_250X_H2_0024.dm3','Log.txt','img');
expPattern = expDpStruct.pureData;
templateStruct = readDMFilex86('template_hitachi.dm3','Log.txt','img');
template = templateStruct.pureData;

qedFileName = 'au_set2_medium.dat';
spotThreshold = 0.6;
beamCenter = [977,1097];
centerMaskWidth = 140;
cc = 1052;%camera constant
stepRadius = 50;%in the unit of pixel
stepAngle = 20;%in the unit of degree
maxRadius = 900;

[bestMatchBeam, bestMatchSimuDP] = indexOneDP(expPattern', template, qedFileName, spotThreshold, beamCenter, centerMaskWidth, cc, stepRadius, stepAngle, maxRadius);
display(bestMatchBeam);

%Consider mirrored diffraction pattern