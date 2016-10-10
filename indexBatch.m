function [ output_args ] = indexBatch()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

angleList = [-15,-10,-5,0,5,10,15,20,35,40,45,50,55,60,65,70];
numRuns = size(angleList,2);

for i=1:1:numRuns
    indexG(angleList(i));
end

end

