function CI = xcc(imageA, imageB)
%This function calculate the normalized cross-correlation of two same size
%image

aveA = mean2(imageA);
aveB = mean2(imageB);

imageASubAve = imageA - aveA;
imageBSubAve = imageB - aveB;

innerDot = imageASubAve.*imageBSubAve;
CI = sum(innerDot(:));

end

