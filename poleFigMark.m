function [] = poleFigMark(expCondition,expResult,projNum,DPNum)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
width = expCondition.scanWidth;
height = expCondition.scanHeight;
numProj = expCondition.numProj;
angleList = expCondition.angleList;
rotAxis = expCondition.specimenRotAxis;

numPatternList = expResult.numPatternList;
corrImgList = expResult.corrImgList;
indexResList = expResult.indexResList;


[fileName2, pathName2] = uigetfile('*.mat', 'Select the query matrix');
fullFileName2 = strcat(pathName2, fileName2);
load(fullFileName2, 'patternDataMatrix');

patternsWithSpot = zeros(numProj, max(numPatternList),10);
%extract the index results from the .txt image file into "patterns" matrix
%patterns matrix stores the uvw and phi for every DP in the i projection
for i=1:1:numProj
    indexResultFile = indexResList{i};
    numPattern = numPatternList(i);
    indexResult = extractUVW(indexResultFile, numPattern, patternDataMatrix);
    patternsWithSpot(i,1:numPattern,:) = indexResult;
end


count = 0;

xlim([-1,+1]);
ylim([-1,+1]);
hold on;

u = patternsWithSpot(projNum,DPNum, 5);
v = patternsWithSpot(projNum,DPNum, 6);
w = patternsWithSpot(projNum,DPNum, 7);
phi = patternsWithSpot(projNum, DPNum, 4);
gVector = zeros(3,1);
gVector(1) = patternsWithSpot(projNum,DPNum,8);
gVector(2) = patternsWithSpot(projNum,DPNum,9);
gVector(3) = patternsWithSpot(projNum,DPNum,10);
CCDRotation = 6;
if (u>-1 && v>-1 && w>-1)
    beamDirection = [u,v,w];
    resultUVW = beamDirection;
    
    %currM = getMFromOneAngle(beamDirection,gVector,phi,CCDRotation);
    %neutralDirection = vectorRotate([0,0,1],angleList(i),rotAxis);
    %reducedIndex = currM*neutralDirection';
    %[resultUVW,~] = uvwProj(abs(reducedIndex));
    
    %rotatedUVW = abs(vectorRotate([u,v,w],angleList(projNum),rotAxis));
    equiv = poleFigureEquiv(resultUVW);
    X = equiv(:,1)./(1+equiv(:,3));
    Y = equiv(:,2)./(1+equiv(:,3));
    markerColor = getRGB(abs(resultUVW));
    scatter(X,Y,30,markerColor);
    display(phi);
    display(u);
    display(v);
    display(w);
end


hold off;

end

