function indexOverlappedDP()
%This function index a exp diffraction pattern with 

expDpStruct = readDMFilex86('feg_+20_slice_478.dm3','Log.txt','img');
expPattern = expDpStruct.pureData;
templateStruct = readDMFilex86('template.dm3','Log.txt','img');
template = templateStruct.pureData;

qedFileName = 'au_set2_medium.dat';
spotThreshold = 0.7;
beamCenter = [128,130];
centerMaskWidth = 10;
cc = 74.8;%camera constant
stepRadius = 5;%in the unit of pixel
stepAngle = 10;%in the unit of degree
maxRadius = 100;

numOverlappedDP = 4;
currTargetPattern = expPattern;
for i=1:1:numOverlappedDP
    
    [bestMatchBeam, bestMatchSimuDP, mirrorFlag] = indexDPExtended(currTargetPattern, template, qedFileName, spotThreshold, beamCenter, centerMaskWidth, cc, stepRadius, stepAngle, maxRadius);
    simuDPMask = (sqrt(bestMatchSimuDP)>0) == 0;
    
    display(bestMatchBeam);
    figure;
    imshow(mat2gray(simuDPMask));
    
    if mirrorFlag == 0
        currTargetPattern = currTargetPattern.*simuDPMask;
    else
        currTargetPattern = (currTargetPattern').*simuDPMask;
        beamCenter = fliplr(beamCenter);
    end
    
end

end

