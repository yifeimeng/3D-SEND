selectAngle = -70;
folderName = 'grainProcess/021016TiN/grain6/';%change for different grains
fileName = 'roiList_';
load(strcat(folderName,fileName,num2str(selectAngle),'_indexResultsG.mat'),'indexResults');
load(strcat(folderName,fileName,num2str(selectAngle),'.mat'),'roiList');
pixelCount = size(roiList,1);
scanningHeight = 26;

qedFileName = 'au_set2_medium.dat';
load(strcat(qedFileName,'ForQuery.mat'),'patternDataMatrix');
numPattern = size(patternDataMatrix,2);

%find the beam direction details through the database
bestFitBeamG = patternDataMatrix(indexResults.currBestFit).beam;
beamDirectionG = bestFitBeamG(8:10);
poleG = bestFitBeamG(3:4);
display(beamDirectionG);
display(poleG);
poleFig = plotIndexMap(indexResults.gaugeArray);

%check index results from the zaefferer method
%{
load(strcat(folderName,fileName,num2str(selectAngle),'_indexResultsZ.mat'),'indexResults');
beamDirectionZ  = indexResults.bestMatchBeam(5:7);
display(beamDirectionZ);
figure;
imshow(mat2gray(indexResults.poleFig,[-0.5,1]));
colormap(hot);
%}

%get the averaged diffraction pattern over the selected DF image area
DPSize = 256;
load(strcat('voxelOrientation/021016TiN/send_',num2str(selectAngle,'%+d'),'.mat'),'expMatrix');
DPSum = zeros(DPSize,DPSize);
for i=1:1:pixelCount
   currX = roiList(i,1);
   currY = roiList(i,2);
   currDPIndex = currY * scanningHeight + currX + 1;
   DPSum = DPSum + double(squeeze(expMatrix(:,:,currDPIndex)));
end
DPAverage = DPSum./pixelCount;
figure;
imshow(mat2gray(DPAverage,[0,5000]));