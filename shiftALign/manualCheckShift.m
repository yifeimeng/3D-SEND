%manually check the shift between two angles
scanningHeight = 26;
scanningWidth = 26;

selectAngle_1 = 30;
selectAngle_2 = 40;
folderName = '070415_DF_grain_v2/grain2/';%change for different grains
fileName = 'roiList_';

fullName_1 = strcat(folderName,fileName,num2str(selectAngle_1),'.mat');
fullName_2 = strcat(folderName,fileName,num2str(selectAngle_2),'.mat');

xcorrTwoRawCoords(fullName_1,fullName_2,scanningWidth,scanningHeight);