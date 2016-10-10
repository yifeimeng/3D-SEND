function [matchList,matchCount,voteA] = matchTrianglesV2(triangleListA,triangleListB,numTriangleA,numTriangleB,numSpotA)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
torR = 0.05;
torC = 0.005;
upperM = 1.10;
lowerM = 0.90;

%[~,sortIndexR_A] = sort(triangleListA(:,5),'descend');
%[~,sortIndexR_B] = sort(triangleListB(:,5),'descend');

voteA = zeros(numSpotA,1);
matchList = [];
matchCount = 0;
bestMatchFactor = 1;
for i=1:1:numTriangleA
    thisAMatchCount = 0;
    for j=1:1:numTriangleB
        if (triangleListA(i,5)-triangleListB(j,5))^2<torR^2 && (triangleListA(i,6)-triangleListB(j,6))^2<torC^2 && triangleListA(i,4)/triangleListB(j,4)<upperM && triangleListA(i,4)/triangleListB(j,4)>lowerM 
            thisAMatchCount = thisAMatchCount + 1;
            currMatchFactor = abs(triangleListA(i,5)-triangleListB(j,5));
            if currMatchFactor < bestMatchFactor
                bestMatchFactor = currMatchFactor;
                bestMatchIndex = j;
            end
            
        end
    end
    if thisAMatchCount > 0
        matchCount = matchCount + 1;
        matchList(matchCount,:) = [i,bestMatchIndex];
        voteA(triangleListA(i,1)) = voteA(triangleListA(i,1)) + 1;
        voteA(triangleListA(i,2)) = voteA(triangleListA(i,2)) + 1;
        voteA(triangleListA(i,3)) = voteA(triangleListA(i,3)) + 1;
    end
end

end

