function [bestMatchBeam, bestMatchSimuDP, matchCF, poleFig] = indexOneDP(expPattern, template, qedFileName, spotThreshold, beamCenter, centerMaskWidth, cc, stepRadius, stepAngle, maxRadius)
%this function geenerate the radial and angular profiles for a experimental
%pattern

%reduce the experimental data
[expPosList, expIntensityList] = reduceExpPattern(expPattern, template, beamCenter, centerMaskWidth, spotThreshold);
numPoints = size(expPosList,1);

if numPoints > 1
    %create the radial and angular profile
    expRadialProfile = powderSpectrum(expPosList, expIntensityList, maxRadius, stepRadius, beamCenter);
    expAngularProfile = angularSpectrum(expPosList, expIntensityList, maxRadius, stepAngle, beamCenter);
    
    %{
figure;
plot(expRadialProfile);
figure;
plot(expAngularProfile);
    %}
    
    %load simuated database
    
    load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');
    [simuRadialProfiles, simuAngularProfiles] = createSimuRadialAngular(patternDataMatrix, cc, stepRadius, stepAngle, maxRadius);
    
    %Use improved zaefferer method
    [bestMatchBeam, bestMatchSimuDP, matchCF, poleFig] = zaeffererIndex(stepAngle, beamCenter, cc, expRadialProfile, expAngularProfile, expPattern, simuRadialProfiles, simuAngularProfiles, patternDataMatrix);
    
else
    bestMatchBeam = [];
    bestMatchSimuDP = [];
    matchCF = -1;
    poleFig = [];
end

end



