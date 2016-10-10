selectAngle = 15;
selectDF = 11;
DFPathName = 'send_data/1115TiN/';%change for a different experiment
savePathName = 'grainProcess/1115TiN/grain4/';%change for a different grain
fileName = 'roiList_';

selectAngleIndex = (selectAngle+75)/5+1;
load(strcat(DFPathName, 'sendAnalyzed.mat'),'sendAnalyzed');
currDFImage = sendAnalyzed(selectAngleIndex).usefulGrainDF(selectDF).DFImg;

maxPixelIntensity = max(currDFImage(:));
minCutoff = maxPixelIntensity*0.1;%modify the intensity cutoff here
maxCutoff = maxPixelIntensity*0.9;
grayScaleImg = mat2gray(currDFImage,[minCutoff,maxCutoff]);
 
figure;
imshow(grayScaleImg,'InitialMagnification',1000);
hPolyRoi = impoly(gca);
mask = hPolyRoi.createMask();

figure;
imshow(mask);

%Convert the mask into the selected pixels list
scanningHeight = 26;
scanningWidth = 26;
pixelCount = 0;
roiList = [];
for i=1:1:scanningHeight
    for j=1:1:scanningWidth
        if mask(i,j) == 1
            pixelCount = pixelCount + 1;
            roiList(pixelCount,:) = [i-1,j-1];
        end
    end
end

save(strcat(savePathName,fileName,num2str(selectAngle),'.mat'),'roiList');
    