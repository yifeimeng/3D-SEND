function xytobd(xDMCoord, yDMCoord)
qedFileName = 'au_set2_medium.dat';
load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');
targetX = xDMCoord - 2;
targetY = 97 - yDMCoord;

numSimuPattern = 3482;
for i=1:1:numSimuPattern
    if patternDataMatrix(i).beam(1) == targetX && patternDataMatrix(i).beam(2) == targetY
        currPatternIndex = i;
        bestFitBeamG = patternDataMatrix(currPatternIndex).beam;
        beamDirectionG = bestFitBeamG(5:7);
        display(beamDirectionG);
    end
end