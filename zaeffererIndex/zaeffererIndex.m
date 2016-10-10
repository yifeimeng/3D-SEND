function [bestMatchBeam, bestMatchSimuDP, matchCF, poleFig] = zaeffererIndex(stepAngle, beamCenter, cc, expRadialProfile,expAngularProfile,expPattern,simuRadialDatabase,simuAngularDatabase,simuPatternDatabase)
%This function index one pattern

%filter the simulated patterns based on the radial profile match
numSimuDP = size(simuRadialDatabase,1);
radialCF = zeros(numSimuDP,1);

for i = 1:1:numSimuDP
    radialCF(i) = ncc(expRadialProfile,simuRadialDatabase(i,:));
    if isnan(radialCF(i))
        radialCF(i) = -2;
    end
end

[radialSorted, radialArrange] = sort(radialCF,'descend');

%filter the simulated patterns based on the angular profile match
numAngleSearchDP = 200;
numRotation = length(expAngularProfile);
angularCF = zeros(numAngleSearchDP,1);
angularRotation = zeros(numAngleSearchDP,1);
for i = 1:1:numAngleSearchDP
    currDPIndex = radialArrange(i);
    currAngularSimu = simuAngularDatabase(currDPIndex,:);
    %consider the phi rotation
    maxAngularCF = -1;
    maxRotation = -1;
    for j = 1:1:numRotation;
        rotatedAngularSimu = circshift(currAngularSimu, [0,j-1]);
        currAngularCF = ncc(expAngularProfile,rotatedAngularSimu);
        if isnan(currAngularCF)
            currAngularCF = -2;
        end
        if currAngularCF > maxAngularCF
            maxAngularCF = currAngularCF;
            maxRotation = j-1;
        end
    end
    angularCF(i) = maxAngularCF;
    angularRotation(i) = maxRotation;
end

[angularSorted, angularArrange] = sort(angularCF,'descend');

%filter the simulated patterns based on the cross correlation match
numNCCSearchDP = 50;
nccCF = zeros(numNCCSearchDP,1);
[height, width] = size(expPattern);
peakWidth = 4;
for i=1:1:numNCCSearchDP
    currDPIndex = radialArrange(angularArrange(i));
    rotationAngle = angularRotation(angularArrange(i))*stepAngle;
    currSimuDP = generateSimuPattern(beamCenter, cc, height, width, simuPatternDatabase(currDPIndex), peakWidth, rotationAngle);
    nccCF(i) = ncc(expPattern,currSimuDP);
    if isnan(nccCF(i))
        nccCF(i) = -1;
    end
    %{
    if nccCF(i) >= 0.75
        figure;
        imshow(mat2gray(currSimuDP, [0,1e-5]));
        display(nccCF(i));
    end
    %}
end

[nccSorted, nccArrange] = sort(nccCF,'descend');

%display the index result based on certain values
numDisplayDP = 50;
poleFig = zeros(85,95);
poleFig(:) = -1;
for i=1:1:numDisplayDP
    currDPIndex = radialArrange(angularArrange(nccArrange(i)));
    currBeam = simuPatternDatabase(currDPIndex).beam;
    poleX = currBeam(1) + 2;%Compensate for the 1 off
    poleY = 95- (currBeam(2) + 2);
    nccValue = nccSorted(i);
    angularValue = angularSorted(nccArrange(i));
    radialValue = radialSorted(angularArrange(nccArrange(i)));
    poleFig(poleX,poleY) = nccValue;
end

%return the best match
matchCF = nccValue;
bestMatchIndex = radialArrange(angularArrange(nccArrange(1)));
bestMatchBeam = simuPatternDatabase(bestMatchIndex).beam;
bestMatchRotationAngle = angularRotation(angularArrange(nccArrange(1)))*stepAngle;
bestMatchSimuDP = generateSimuPattern(beamCenter, cc, height, width, simuPatternDatabase(bestMatchIndex), peakWidth, bestMatchRotationAngle);


end

