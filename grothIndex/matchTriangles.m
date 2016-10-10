function [matchList,matchCount,voteA] = matchTriangles(triangleListA,triangleListB,numTriangleA,numTriangleB,numSpotA)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here
torR = 0.05;
torC = 0.005;
upperM = 1.10;
lowerM = 0.90;

%[~,sortIndexR_A] = sort(triangleListA(:,5),'descend');
%[~,sortIndexR_B] = sort(triangleListB(:,5),'descend');

voteA = zeros(numSpotA,1);
matchCount = 0;
matchList = [];
for i=1:1:numTriangleA
    for j=1:1:numTriangleB
        if (triangleListA(i,5)-triangleListB(j,5))^2<torR^2 && (triangleListA(i,6)-triangleListB(j,6))^2<torC^2 && triangleListA(i,4)/triangleListB(j,4)<upperM && triangleListA(i,4)/triangleListB(j,4)>lowerM 
            matchCount = matchCount + 1;
            matchList(matchCount,:) = [i,j];
            voteA(triangleListA(i,1)) = voteA(triangleListA(i,1)) + 1;
            voteA(triangleListA(i,2)) = voteA(triangleListA(i,2)) + 1;
            voteA(triangleListA(i,3)) = voteA(triangleListA(i,3)) + 1;
            break;
        end
    end

end

end

