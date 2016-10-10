sampleName = '021016TiN/';

%GRAIN_5
grainID = 'grain5';
grainInfo.numUsefulProj = 15;
grainInfo.angleList = [-55,-35,-20,-15,0,5,10,15,25,35,40,50,65,70,75];
grainInfo.roiFolderName = 'autoDF/grainProcess/021016TiN/grain5/';

%
roiFileName = 'alignedRoiList_';
scanInfo.scanHeight = 38;
scanInfo.scanWidth = 26;
scanInfo.specimenRotAxis = [0.985,0.173,0];

for i = 1:1:grainInfo.numUsefulProj
    res.DFCoord{i} = strcat(grainInfo.roiFolderName,roiFileName,num2str(grainInfo.angleList(i)),'.mat');
end
grainInfo.resultFileNames = res;
[d1,v1] = sendTomoProcessDF(scanInfo,grainInfo);
save(strcat('reconResults/',sampleName,grainID,'_d.mat'),'d1');
save(strcat('reconResults/',sampleName,grainID,'_v.mat'),'v1')
%}

%
sliceomatic(v1);
v1s = smooth3(v1);
figure;
isovalueMid = 0.03;
surf_1 = isosurface(v1s, isovalueMid);
p_1 = patch(surf_1);
isonormals(v1s, p_1);
set(p_1,'FaceColor','yellow','EdgeColor','none','FaceAlpha',0.2);
daspect([1,1,1]);
view(3);axis([0,38,0,26,0,26])
camlight; lighting gouraud
%}

%{
figure;
isovalueBot = 0.05;
surf_1 = isosurface(v1s, isovalueBot);
p_1 = patch(surf_1);
isonormals(v1s, p_1);
set(p_1,'FaceColor','red','EdgeColor','none','FaceAlpha',0.2);
daspect([1,1,1]);
view(3);axis([0,26,0,26,0,26])
camlight; lighting gouraud
%isosurface(DNew,1);

isovalueMid = 0.05;
surf_2 = isosurface(v2s, isovalueMid);
p_2 = patch(surf_2);
isonormals(v2s, p_2);
set(p_2,'FaceColor','yellow','EdgeColor','none','FaceAlpha',0.2);

%
isovalueTop = 0.05;
surfTop = isosurface(v3s, isovalueTop);
p_3 = patch(surfTop);
isonormals(v3s, p_3);
set(p_3,'FaceColor','cyan','EdgeColor','none','FaceAlpha',0.2);

%}

