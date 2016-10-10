function radialProfile = powderSpectrum(posList, intensityList, maxRadius, stepRadius, beamCenter)
%The function calculate the powderSpectrum (radial profile) of a
%diffraction pattern with the given sampling points.

%intensityList = sqrt(intensityList);%modify the intensity as needed.

samplingPoints = maxRadius/stepRadius;

radialProfile = zeros(1,samplingPoints);
numSpot = size(posList,1);
for i = 1:1:numSpot 
    dToCenter = sqrt(sum((posList(i,:)-beamCenter).^2));
    if dToCenter <= maxRadius
        slot = ceil(dToCenter/stepRadius);
        radialProfile(slot) = radialProfile(slot) + intensityList(i);
    end
end

end

