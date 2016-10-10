function groupSimilarDFItr(DFImageStack)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

numImage = size(DFImageStack,1);
iniRepAmount = ones(numImage,1);
threshold = 0.6;
res_goFlag = 1;
is = DFImageStack;
ra = iniRepAmount;
count = 0;

while res_goFlag == 1
    [res_is, res_ra, res_goFlag] = oneStepGroup(is, ra, threshold);
    is = res_is;
    ra = res_ra;
    count = count + 1;
    fprintf('\nIteration %d.',count);
end

numFinalImg = size(is,1);
for i = 1:1:numFinalImg
    figure;
    imshow(mat2gray(squeeze(res_is(i,:,:))));
end

end

