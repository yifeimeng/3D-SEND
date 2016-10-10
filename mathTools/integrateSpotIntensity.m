function intensity = integrateSpotIntensity(dp, sizeSlice, spotPos, radius)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

[cc, rr] = meshgrid(1:1:sizeSlice);
cc = double(cc);
rr = double(rr);
centerX = double(spotPos(1));
centerY = double(spotPos(2));
circularMask = sqrt((rr-centerX).^2+(cc-centerY).^2) <= radius;
%imshow(circularMask)
circularMask = int16(circularMask);

currDP = dp;
afterMaskDP = currDP.*circularMask;
intensity = sum(afterMaskDP(:));

end

