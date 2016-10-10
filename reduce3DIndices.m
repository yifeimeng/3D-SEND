function [indexRecord, grainRecord] = reduce3DIndices(expCondition,expResult)
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
%4-phi,567-uvw,89-gVector for the largest intensity spot
%extract the index results from the .txt image file into "patterns" matrix
%patterns matrix stores the uvw and phi for every DP in the i projection
for i=1:1:numProj
    indexResultFile = indexResList{i};
    numPattern = numPatternList(i);
    indexResult = extractUVW(indexResultFile, numPattern, patternDataMatrix);
    patternsWithSpot(i,1:numPattern,:) = indexResult;
end

CCDRotation = 6;
count = 0;
grainCount = 0;
gVector = zeros(3,1);
for i=1:1:numProj
    for j=1:1:numPatternList(i)
        beamDirection = patternsWithSpot(i,j,5:7);
        beamDirection = squeeze(beamDirection);
        if (beamDirection(1)>-1 && beamDirection(2)>-1 && beamDirection(3)>-1)
            gVector(1) = patternsWithSpot(i,j,8);
            gVector(2) = patternsWithSpot(i,j,9);
            gVector(3) = patternsWithSpot(i,j,10);
            phi = patternsWithSpot(i,j,4);
            currM = getMFromOneAngle(beamDirection,gVector,phi,CCDRotation);
            neutralDirection = vectorRotate([0,0,1],angleList(i),rotAxis);
            reducedIndex = currM*neutralDirection';
            count = count + 1;
            [resultUVW,~] = uvwProj(abs(reducedIndex));
            u = resultUVW(1);
            v = resultUVW(2);
            w = resultUVW(3);
            x = u/(1+w);%stereoprojection position of [u,v,w]
            y = v/(1+w);
            indexRecord(count,:) = [x,y];
            if withinTargetGrain(x,y) == true
                grainCount = grainCount + 1;
                grainRecord(grainCount,:) = [i,j]; 
            end
        end
    end
end

figure;
scatter(indexRecord(:,1),indexRecord(:,2),30);
axis([0,0.4,0,0.4]);

end

