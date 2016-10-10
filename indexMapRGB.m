%This script accept a correlation image, a indexing result (.txt) and the
%database the generate the image with rgb index
function indexMapRGB()
[fileName1, pathName1] = uigetfile('*.dm3', 'Open a correlation image');
[fileName2, pathName2] = uigetfile('*.txt', 'Open a index result file');
[fileName3, pathName3] = uigetfile('*.mat', 'Open a DP database');
prompt = 'What is the number of the DP patterns after correlation?';
answer = inputdlg(prompt);
numPattern = str2num(answer{1});
prompt = 'Please input the height of the correlation image';
answer = inputdlg(prompt);
height = str2num(answer{1});
prompt = 'Please input the width of the correlation image';
answer = inputdlg(prompt);
width = str2num(answer{1});
fullName1 = strcat(pathName1, fileName1);
fullName2 = strcat(pathName2, fileName2);
fullName3 = strcat(pathName3, fileName3);

load(fullName3, 'patternDataMatrix');
patterns = extractUVW(fullName2, numPattern, patternDataMatrix);
signalDetails=readDMFilex86(fullName1,'Log.txt','img');
corrImg = signalDetails.pureData;


indexMap = zeros(width, height, 3);
for j = 1:1:height
    for k = 1:1:width
        patternOrder = corrImg(j, k) + 1;%the order is offset by one
        u = patterns(patternOrder, 5);
        v = patterns(patternOrder, 6);
        w = patterns(patternOrder, 7);
        if (u>-1 && v>-1 && w>-1)
            indexMap(k,j,:) = getRGB([u,v,w]);
        else
            indexMap(k,j,:) = [0,0,0];
        end
    end
end

figure;
imshow(indexMap, 'InitialMagnification', 'fit');
imwrite(indexMap,'indexMap.bmp');
end
