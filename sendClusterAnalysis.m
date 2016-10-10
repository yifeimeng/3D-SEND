function [ output_args ] = sendClusterAnalysis()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

expStruct = readDMFilex86('send_data/1115TiN/send_-30.dm3','Log.txt','imgStack');
expGroupedStruct = readDMFilex86('send_data/1115TiN/processing/send_-30_grouped.dm3','Log.txt','imgStack');
templateStruct = readDMFilex86('template.dm3','Log.txt','img');

numDP = expStruct.naviZDimSize;
beamCenter = [130,128];%do not transpose from DM
groupDFsThreshold = 0.6;
getSpotThreshold = 0.8;
scanningArea.height = 26;
scanningArea.width = 26;
DFImageRange.start = 1;
DFImageRange.end = numDP;

[usefulGrainCount, usefulGrainDF] = polyDiffPreAverage(expStruct, expGroupedStruct, templateStruct, beamCenter, groupDFsThreshold, getSpotThreshold, scanningArea, DFImageRange);
%[usefulGrainCount, usefulGrainDF] = polyDiffPreAverageExcludePhase(expStruct, expGroupedStruct, templateStruct, beamCenter, groupDFsThreshold, getSpotThreshold, scanningArea, DFImageRange);

%{
for i=1:1:usefulGrainCount

    currDFImage = usefulGrainDF(i).DFImg;
    maxPixelIntensity = max(currDFImage(:));
    minCutoff = maxPixelIntensity*0.20;
    maxCutoff = maxPixelIntensity*1.00;
    figure;
    imshow(mat2gray(currDFImage,[minCutoff,maxCutoff]));
    
    
end
%}

end

