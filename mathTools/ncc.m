function CI = ncc(imageA, imageB)
%This function calculate the normalized cross-correlation of two same size
%image

aveA = mean2(imageA);
aveB = mean2(imageB);

imageASubAve = imageA - aveA;
imageBSubAve = imageB - aveB;

innerDot = imageASubAve.*imageBSubAve;
cc = sum(innerDot(:));

Asquare = imageASubAve.^2;
Bsquare = imageBSubAve.^2;
normFactor = sqrt(sum(Asquare(:)))*sqrt(sum(Bsquare(:)));

CI = cc/normFactor;


end

