function pickDP(poleX, poleY)
qedFileName = 'au_set2_medium.dat';
load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');
numDPTotal = size(patternDataMatrix,2);
x = poleX - 2;
y = 93 - poleY;

height = 256;
width = 256;
beamCenter = [127,123];
centerMaskWidth = 10;
cc = 46.4;%camera constant
peakWidth = 4;
bestMatchRotationAngle = 0;

for i=1:1:numDPTotal
    if patternDataMatrix(i).beam(1) == x && patternDataMatrix(i).beam(2) == y
        bestMatchSimuDP = generateSimuPattern(beamCenter, cc, height, width, patternDataMatrix(i), peakWidth, bestMatchRotationAngle);
        simuDPMask = (sqrt(bestMatchSimuDP)>0) == 0;
        figure;
        imshow(mat2gray(simuDPMask));
    end

end

end