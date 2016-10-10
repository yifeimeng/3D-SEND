%this script creates the radial and angular profiles of all dps in the database.
qedFileName = 'au_set2_medium.dat';
load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');

height = 256;
width = 256;
cc = 46.4;%camera constant
stepRadius = 2;%in the unit of pixel
stepAngle = 2;%in the unit of degree
beamCenter = [0,0];%in the unit of pixel
maxRadius = 100;%in the unit of pixel

numDP = length(patternDataMatrix);
simuRadialProfiles = zeros(numDP,maxRadius/stepRadius);
simuAngularProfiles = zeros(numDP,360/stepAngle);
for i = 1:1:numDP
    numSpot = patternDataMatrix(i).numSpot;
    posList = zeros(numSpot,2);
    intensityList = zeros(numSpot,1);
    for j = 1:1:numSpot
        posList(j,:) = patternDataMatrix(i).spot(j,5:6)*cc;
        intensityList(j) = patternDataMatrix(i).spot(j,7);
    end
    simuRadialProfiles(i,:) = powderSpectrum(posList, intensityList, maxRadius, stepRadius, beamCenter);
    simuAngularProfiles(i,:) = angularSpectrum(posList, intensityList, maxRadius, stepAngle, beamCenter);
    
end

save(strcat(qedFileName,'radialProfiles.mat'),'simuRadialProfiles');
save(strcat(qedFileName,'angularProfiles.mat'),'simuAngularProfiles');
