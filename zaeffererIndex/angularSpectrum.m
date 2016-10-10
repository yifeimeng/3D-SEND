function angularProfile = angularSpectrum(posList, intensityList, maxRadius, stepAngle, beamCenter)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

%intensityList = sqrt(intensityList);%modify the intensity as needed.

rMin = 0.1*maxRadius;
rMax = 0.9*maxRadius;

samplingPoints = 360/stepAngle;
angularProfile = zeros(1,samplingPoints);
numSpot = size(posList,1);

for i=1:1:numSpot
    posX = posList(i,1);
    posY = posList(i,2);
    dToCenter = sqrt(sum((posList(i,:)-beamCenter).^2));
    if dToCenter>=rMin && dToCenter<=rMax
        xComponent = posX - beamCenter(1);
        yComponent = posY - beamCenter(2);
        
        if yComponent >= 0
            theta = acos(xComponent/dToCenter);
        else
            theta = 2*pi - acos(xComponent/dToCenter);
        end
        slot = floor(radtodeg(theta)/stepAngle+1);
        angularProfile(slot) = angularProfile(slot) + intensityList(i);
    end
    
end




end

