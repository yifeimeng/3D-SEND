function [flag, foundPeakList, peakCorr] = peakSearch(img, background, edge)
%This function return the peak postions in a image using the local maximum
%approach

height = size(img,1);
width = size(img,2);
count = 0;
flag = 0;

for i = 1+edge:1:height-edge
    for j = 1+edge:1:width-edge
        if img(i,j)>=img(i-1,j-1) &&...
                img(i,j)>img(i-1,j) &&...
                img(i,j)>img(i-1,j+1) &&...
                img(i,j)>img(i,j-1) && ...
                img(i,j)>img(i,j+1) && ...
                img(i,j)>img(i+1,j-1) && ...
                img(i,j)>img(i+1,j) && ...
                img(i,j)>img(i+1,j+1) && ...
                img(i,j)>=background
           
            count = count + 1;
            foundPeakList(count,:) = [i, j];%use the original coordinate of the image
            peakCorr(count) = img(i,j);
            flag = 1;
        end
        
    end
end

if flag == 0
    foundPeakList = [];
    peakCorr = [];
end


end

