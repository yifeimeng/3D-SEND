shiftAlignment = 'grainProcess/021016TiN/shiftAlignment.txt';%shift alignment file
fidAlignment = fopen(shiftAlignment);
numArrary = fscanf(fidAlignment,'%d');
numLength = size(numArrary,1);
shiftList = zeros(numLength/2,2);
for j=1:1:numLength
    shiftList(ceil(j/2),2-mod(j,2))=numArrary(j);
end
fclose(fidAlignment);

%GRAIN_6
grainInfo.numUsefulProj = 22;
grainInfo.angleList = [-70,-60,-55,-50,-40,-35,-30,-25,-20,-15,-10,-5,0,10,15,25,30,35,40,60,65,75];
grainInfo.roiFolderName = 'grainProcess/021016TiN/grain6/';


width = 26;
height = 38;
grainInfo.roiFileName = 'roiList_';
grainInfo.roiSaveFileName = 'alignedRoiList_';
rawCoordsAlign(grainInfo,shiftList,width,height);

