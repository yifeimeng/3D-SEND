function [bestMatchBeam, bestMatchSimuDP, mirrorFlag, matchFactor, poleFig] = indexDPExtended(expPattern, template, qedFileName, spotThreshold, beamCenter, centerMaskWidth, cc, stepRadius, stepAngle, maxRadius)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

[bestMatchBeam_I, bestMatchSimuDP_I, matchFactor_I, poleFig_I] = indexOneDP(expPattern, template, qedFileName, spotThreshold, beamCenter, centerMaskWidth, cc, stepRadius, stepAngle, maxRadius);
%{
figure;
imshow(mat2gray(poleFig_I',[-0.5,0.5]));
colormap(hot);
%}

[bestMatchBeam_II, bestMatchSimuDP_II, matchFactor_II, poleFig_II] = indexOneDP(expPattern', template, qedFileName, spotThreshold, fliplr(beamCenter), centerMaskWidth, cc, stepRadius, stepAngle, maxRadius);
%{
figure;
imshow(mat2gray(poleFig_II',[-0.5,0.5]));
colormap(hot);
%}

if ~isempty(bestMatchBeam_I) && ~isempty(bestMatchBeam_II)
    if matchFactor_I > matchFactor_II
        bestMatchBeam = bestMatchBeam_I;
        bestMatchSimuDP = bestMatchSimuDP_I;
        mirrorFlag = 0;
        matchFactor = matchFactor_I;
        poleFig = poleFig_I;
    else
        bestMatchBeam = [1,1,1,1,-1,1,1,-1,1,1].*bestMatchBeam_II;
        bestMatchSimuDP = bestMatchSimuDP_II;
        mirrorFlag = 1;
        matchFactor = matchFactor_II;
        poleFig = poleFig_II;
    end
else
    bestMatchBeam = [];
    bestMatchSimuDP = [];
    mirrorFlag = -1;
    matchFactor = -1;
    poleFig = [];
end

end

