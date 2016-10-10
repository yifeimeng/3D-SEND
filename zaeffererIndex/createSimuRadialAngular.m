function [simuRadialProfiles, simuAngularProfiles] = createSimuRadialAngular(patternDataMatrix, cc, stepRadius, stepAngle, maxRadius)
%this function creates the radial and angular profiles of all dps in the database.
beamCenter = [0,0];%in the unit of pixel

numDP = length(patternDataMatrix);
simuRadialProfiles = zeros(numDP,maxRadius/stepRadius);
simuAngularProfiles = zeros(numDP,360/stepAngle);
for i = 1:1:numDP
    numSpot = patternDataMatrix(i).numSpot;
    posList = zeros(numSpot,2);
    intensityList = zeros(numSpot,1);
    for j = 1:1:numSpot
        posList(j,:) = patternDataMatrix(i).spot(j,5:6)*cc;
        intensityList(j) = sqrt(patternDataMatrix(i).spot(j,7));%may change to different scale
    end
    simuRadialProfiles(i,:) = powderSpectrum(posList, intensityList, maxRadius, stepRadius, beamCenter);
    simuAngularProfiles(i,:) = angularSpectrum(posList, intensityList, maxRadius, stepAngle, beamCenter);
    
end


end
