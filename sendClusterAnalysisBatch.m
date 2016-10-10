function [ output_args ] = sendClusterAnalysisBatch()
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

pathName = 'send_data/021716FeMnSi/';
fileNameTemplate = 'send_';
numAngle = 31;
scanningArea.height = 30;
scanningArea.width = 60;


%1st  coloumn -- rotation angle
%2nd coloumn -- DF threshold 
%3rd coloumn -- spot threshold
paraList = zeros(numAngle,5);

paraList(1,:) = [-75,124,130,0.5,0.8];
paraList(2,:) = [-70,124,130,0.5,0.8];
paraList(3,:) = [-65,124,130,0.5,0.8];
paraList(4,:) = [-60,124,130,0.5,0.8];
paraList(5,:) = [-55,124,130,0.5,0.8];
paraList(6,:) = [-50,124,130,0.5,0.8];
paraList(7,:) = [-45,126,131,0.5,0.8];
paraList(8,:) = [-40,126,131,0.5,0.8];
paraList(9,:) = [-35,126,131,0.5,0.8];
paraList(10,:) = [-30,126,131,0.5,0.8];
paraList(11,:) = [-25,126,133,0.5,0.8];
paraList(12,:) = [-20,126,133,0.5,0.8];
paraList(13,:) = [-15,126,133,0.5,0.8];
paraList(14,:) = [-10,126,133,0.5,0.8];
paraList(15,:) = [-5,126,133,0.5,0.8];
paraList(16,:) = [+0,123,133,0.5,0.8];
paraList(17,:) = [+5,123,133,0.5,0.8];
paraList(18,:) = [+10,123,133,0.5,0.8];
paraList(19,:) = [+15,123,133,0.5,0.8];
paraList(20,:) = [+20,123,133,0.5,0.8];
paraList(21,:) = [+25,123,133,0.5,0.8];
paraList(22,:) = [+30,123,133,0.5,0.8];
paraList(23,:) = [+35,123,133,0.5,0.8];
paraList(24,:) = [+40,123,133,0.5,0.8];
paraList(25,:) = [+45,123,133,0.5,0.8];
paraList(26,:) = [+50,123,133,0.5,0.8];
paraList(27,:) = [+55,123,133,0.5,0.8];
paraList(28,:) = [+60,123,133,0.5,0.8];
paraList(29,:) = [+65,123,133,0.5,0.8];
paraList(30,:) = [+70,123,133,0.5,0.8];
paraList(31,:) = [+75,123,133,0.5,0.8];

templateFileName = 'template.dm3';
for i=1:1:numAngle
    currFileName = strcat(pathName, fileNameTemplate,num2str(paraList(i,1),'%+d'),'.dm3');
    currFileGroupedName = strcat(pathName, 'processing/', fileNameTemplate, num2str(paraList(i,1),'%+d'),'_grouped','.dm3');
    expStruct = readDMFilex86(currFileName,'Log.txt','imgStack');
    expGroupedStruct = readDMFilex86(currFileGroupedName,'Log.txt','imgStack');
    templateStruct = readDMFilex86(templateFileName,'Log.txt','img');
    numDP = expStruct.naviZDimSize;
    DFImageRange.start = 1;
    DFImageRange.end = numDP;
    
    beamCenter = [paraList(i,2), paraList(i,3)];
    [usefulGrainCount, usefulGrainDF] = polyDiffPreAverage(expStruct, expGroupedStruct, templateStruct, beamCenter, paraList(i,4), paraList(i,5),scanningArea,DFImageRange);
    sendAnalyzed(i).usefulGrainDF = usefulGrainDF;
    sendAnalyzed(i).usefulGrainCount = usefulGrainCount;
    
    
end

save(strcat(pathName, 'sendAnalyzed_1_1800.mat'),'sendAnalyzed');


end

