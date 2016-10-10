function CI = ncc3D(shapeA, shapeB)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

numElements = numel(shapeA);
sumA = sum(shapeA(:));
sumB = sum(shapeB(:));

aveA = sumA./numElements;
aveB = sumB./numElements;

imageASubAve = shapeA - aveA;
imageBSubAve = shapeB - aveB;

innerDot = imageASubAve.*imageBSubAve;
cc = sum(innerDot(:));

Asquare = imageASubAve.^2;
Bsquare = imageBSubAve.^2;
normFactor = sqrt(sum(Asquare(:)))*sqrt(sum(Bsquare(:)));

CI = cc/normFactor;

end

