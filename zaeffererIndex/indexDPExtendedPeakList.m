function [bestMatchBeam, bestMatchSimuDP, mirrorFlag, matchCF, poleFig] = indexDPExtendedPeakList(dpSize, posList, intensityList, beamCenter, qedFileName, cc, stepRadius, stepAngle, maxRadius)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
posList_I = posList;
[numPeaks,~] = size(posList);
posList_II = zeros(numPeaks,2);
posList_II(:,1) = posList(:,2);
posList_II(:,2) = posList(:,1);


[bestMatchBeam_I, bestMatchSimuDP_I, matchCF_I, poleFig_I] = indexOneDPPeakList(dpSize, posList_I, intensityList, beamCenter, qedFileName, cc, stepRadius, stepAngle, maxRadius);

[bestMatchBeam_II, bestMatchSimuDP_II, matchCF_II, poleFig_II] = indexOneDPPeakList(dpSize, posList_II, intensityList, beamCenter, qedFileName, cc, stepRadius, stepAngle, maxRadius);

%{
figure;
imshow(mat2gray(poleFig_I',[-0.5,0.5]));
colormap(hot);
%}

%{
figure;
imshow(mat2gray(poleFig_II',[-0.5,0.5]));
colormap(hot);
%}

if ~isempty(bestMatchBeam_I) && ~isempty(bestMatchBeam_II)
    if matchCF_I > matchCF_II
        bestMatchBeam = bestMatchBeam_I;
        bestMatchSimuDP = bestMatchSimuDP_I;
        mirrorFlag = 0;
        matchCF = matchCF_I;
        poleFig = poleFig_I;
    else
        bestMatchBeam = [1,1,1,1,-1,1,1,-1,1,1].*bestMatchBeam_II;
        bestMatchSimuDP = bestMatchSimuDP_II;
        mirrorFlag = 1;
        matchCF = matchCF_II;
        poleFig = poleFig_II;
    end
else
    bestMatchBeam = [];
    bestMatchSimuDP = [];
    mirrorFlag = -1;
    matchCF = -1;
    poleFig = [];
end

end

