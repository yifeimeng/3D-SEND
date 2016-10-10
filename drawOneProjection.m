function [] = drawOneProjection(corrImgFile, indexResultFile, numPattern, angle)
%DRAWONEPROJECTION Summary of this function goes here
%   Detailed explanation goes here

%extract information from the .dm3 image file
signalDetails=readDMFilex86(corrImgFile,strcat(corrImgFile(1:end-4),'Log','.txt'),'img');
patterns = extractUVW(indexResultFile, numPattern);
%initialize a rgbMap
corrImg = signalDetails.pureData;
%transpose the correlation image to match the DM display
corrImg = transpose(corrImg);
imgSize = size(corrImg);
height = imgSize(1);
width = imgSize(2);
rgbMap = zeros(imgSize(1), imgSize(2), 3);%3 channels
%rotation axis
rotAxis = [0.599, -0.323, 0];
%set the rgb values
for i = 1:1:height
    for j = 1:1:width
        patternOrder = corrImg(i, j) + 1;%the order is offset by one
        u = patterns(patternOrder, 5);
        v = patterns(patternOrder, 6);
        w = patterns(patternOrder, 7);
        if (u>-1 && v>-1 && w>-1)
            newUVW = [u,v,w];
            [r, g, b] = getRGB(newUVW(1), newUVW(2), newUVW(3));
            rgbMap(i, j, 1) = r;
            rgbMap(i, j, 2) = g;
            rgbMap(i, j, 3) = b;
        else
            rgbMap(i, j, 1) = 0;
            rgbMap(i, j, 2) = 0;
            rgbMap(i, j, 3) = 0;
        end
    end
end

%display the rgb map
%image(rgbMap);
figure;
imshow(rgbMap, 'InitialMagnification', 'fit');

end

