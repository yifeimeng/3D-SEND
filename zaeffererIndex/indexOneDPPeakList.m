function [bestMatchBeam, bestMatchSimuDP, matchCF, poleFig] = indexOneDPPeakList(dpSize, posList, intensityList, beamCenter, qedFileName, cc, stepRadius, stepAngle, maxRadius)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numPeaks = size(posList,1);

if numPeaks > 1
    %create the radial and angular profile
    expRadialProfile = powderSpectrum(posList, intensityList, maxRadius, stepRadius, beamCenter);
    expAngularProfile = angularSpectrum(posList, intensityList, maxRadius, stepAngle, beamCenter);
    
    %{
figure;
plot(expRadialProfile);
figure;
plot(expAngularProfile);
    %}
    
    %load simuated database
    
    load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');
    [simuRadialProfiles, simuAngularProfiles] = createSimuRadialAngular(patternDataMatrix, cc, stepRadius, stepAngle, maxRadius);
    %Create the virtual experimental DP from the filtered DP
    peakWidth = 4;%Use the same number in zaeffererIndex
    expPattern = generateVirtualPattern(posList, intensityList, dpSize, peakWidth);
    figure;
    imshow(mat2gray(expPattern));
    
    %Use improved zaefferer method
    [bestMatchBeam, bestMatchSimuDP, matchCF, poleFig] = zaeffererIndex(stepAngle, beamCenter, cc, expRadialProfile, expAngularProfile, expPattern, simuRadialProfiles, simuAngularProfiles, patternDataMatrix);
else
    bestMatchBeam = [];
    bestMatchSimuDP = [];
    matchCF = -1;
    poleFig = [];
end

end

