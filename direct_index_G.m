%
currFileGroupedName = 'huyang/tilt-159.dm3';
templateFileName = 'huyang/template.dm3';

expStruct = readDMFilex86(currFileGroupedName,'Log.txt','imgStack');
templateStruct = readDMFilex86(templateFileName,'Log.txt','img');


spotThreshold = 0.6;
beamCenter = [982,669];
centerMaskWidth = 40;
cc = 675;%camera constant
currTargetPattern = expStruct.pureData;
template = templateStruct.pureData;

[currBestFit, bestGauge, gaugeArray] = autoIndexGroth(beamCenter, centerMaskWidth, currTargetPattern, template, spotThreshold);

%}
poleFig = plotIndexMap(gaugeArray);

indexResults.currBestFit = currBestFit;
indexResults.bestGauge = bestGauge;
indexResults.gaugeArray = gaugeArray;
indexResults.poleFig = poleFig;