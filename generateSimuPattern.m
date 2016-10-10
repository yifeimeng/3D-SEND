function simuDP = generateSimuPattern(expBeamCenter, cc, height, width, simuPatternData, peakWidth, rotationAngle)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
simuDP = zeros(height, width);
numSpot = simuPatternData.numSpot;

for i=1:1:numSpot
    simuDPCurrLayer = zeros(height, width);
    vanillaSpotVector = (simuPatternData.spot(i,5:6))'*cc;%consider the camera constant
    centerIntensity = simuPatternData.spot(i,7);
    theta = degtorad(rotationAngle); %Compensation for the different coordinates of matlab and qed?
    rotationMatrix = [cos(theta),-sin(theta);sin(theta),cos(theta)];
    rotatedSpotVector = rotationMatrix*vanillaSpotVector;
    spotPos = round(expBeamCenter' + rotatedSpotVector);
    %create gaussian peaks for the simu pattern
    peakSize = peakWidth*3;
    spotGaussian = fspecial('gaussian',peakSize,peakWidth)*centerIntensity;
    if mod(peakSize, 2) == 0
        xStart = spotPos(1)-peakSize/2;
        xEnd = spotPos(1)+peakSize/2-1;
        yStart = spotPos(2)-peakSize/2;
        yEnd = spotPos(2)+peakSize/2-1;
        if xStart>=1 && xEnd<=width && yStart>=1 && yEnd<=height
            simuDPCurrLayer(xStart:xEnd,yStart:yEnd) = spotGaussian;
        end
    else
        xStart = spotPos(1)-floor(peakSize/2);
        xEnd = spotPos(1)+floor(peakSize/2);
        yStart = spotPos(2)-floor(peakSize/2);
        yEnd = spotPos(2)+floor(peakSize/2);
        if xStart>=1 && xEnd<=width && yStart>=1 && yEnd<=height
            simuDPCurrLayer(xStart:xEnd,yStart:yEnd) = spotGaussian;
        end
    end
    
    simuDP = simuDP + simuDPCurrLayer;
end

end

