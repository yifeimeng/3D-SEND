%This script extract the pole and BD information from manually picked
%position on the groth index pole figure

pickedX = 48;
pickedY = 32;

databaseX = pickedX - 2;
databaseY = 97 - pickedY;%this is correlated with the plotIndexMap

qedFileName = 'au_set2_medium.dat';
load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');

for i = 1:1:3482
    currX = patternDataMatrix(i).beam(1);
    currY = patternDataMatrix(i).beam(2);
    if currX == databaseX && currY == databaseY
        DPIndex = i;
        pole = patternDataMatrix(i).beam(3:4);
        beamDirection = patternDataMatrix(i).beam(8:10);
        break;
    end
end

display(DPIndex);
display(pole);
display(beamDirection);
