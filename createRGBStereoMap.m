[fileName2, pathName2] = uigetfile('*.mat', 'Select the query matrix');
fullFileName2 = strcat(pathName2, fileName2);
load(fullFileName2, 'patternDataMatrix');
numTotalPattern = 3482;

for i = 1:1:numTotalPattern
    xCoord = patternDataMatrix(i, 1) + 3;
    yCoord = patternDataMatrix(i, 2) + 3;
    u = patternDataMatrix(i, 8);  
    v = patternDataMatrix(i, 9);
    w = patternDataMatrix(i, 10);
    vector = [u,v,w];
    rgbResult = getRGB(vector);
    stereoMap(xCoord, yCoord, 1) = rgbResult(1);  
    stereoMap(xCoord, yCoord, 2) = rgbResult(2);
    stereoMap(xCoord, yCoord, 3) = rgbResult(3);
end
%special treatment for key = 0
specialRGBResult = getRGB([-0.01, -0.02, 0.99975]);
stereoMap(2, 1, 1) = specialRGBResult(1);
stereoMap(2, 1, 2) = specialRGBResult(2);
stereoMap(2, 1, 3) = specialRGBResult(3);

figure;
imshow(stereoMap, 'InitialMagnification', 'fit');
imwrite(stereoMap,'stereoMapRGB.bmp');