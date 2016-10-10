function xcorrTwoRawCoords(fullName1,fullName2,width,height)
%This function give the cross-correlation result between two silhouettes.
%The first file is the reference.

%Acquire silhouette for raw coordList 1
load(fullName1,'roiList');
numLength = size(roiList,1);

silhouette1 = zeros(width,height);
for i=1:1:numLength
    silhouette1(roiList(i,2)+1,roiList(i,1)+1) = 1;%fix the coordinate system
end
figure;
imshow(silhouette1);

%Acquire silhouette for raw coordList 2

load(fullName2,'roiList');
numLength = size(roiList,1);

silhouette2 = zeros(width,height);
for i=1:1:numLength
    silhouette2(roiList(i,2)+1,roiList(i,1)+1) = 1;%fix the coordinate system
end
figure;
imshow(silhouette2);

%perform the cross-correlation
corrMatrix = normxcorr2(silhouette1,silhouette2);
[maxValueByColumn,maxIndexByColumn]=max(corrMatrix);
[c,maxIndexByRow]=max(maxValueByColumn);
position=[maxIndexByRow-size(silhouette1,2),maxIndexByColumn(maxIndexByRow)-size(silhouette1,1)];
display(position);

%test the alignRawCoords functin. Comment out for normal usage.
%{
shiftX = -position(1);
shiftY = -position(2);
[~,alignedSilhouette2] = alignRawCoords(fullName2,width,height,shiftX,shiftY);
figure;
imshow(alignedSilhouette2);

corrMatrix = normxcorr2(silhouette1,alignedSilhouette2);
[maxValueByColumn,maxIndexByColumn]=max(corrMatrix);
[c,maxIndexByRow]=max(maxValueByColumn);
positionAfterAlign=[maxIndexByColumn(maxIndexByRow)-size(silhouette1,1),maxIndexByRow-size(silhouette1,2)];
display(positionAfterAlign);
%}

end

