%{
%GRAIN_1
grainID = 'grain1';
grainInfo.numUsefulProj = 27;
grainInfo.angleList = [-75,-70,-60,-55,-45,-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,20,25,30,35,40,45,50,55,60,65];
grainInfo.roiFolderName = 'grainProcess/021016TiN/grain1/';
%}

%{
%GRAIN_2
grainInfo.numUsefulProj = 27;
grainInfo.angleList = [-70,-65,-60,-55,-50,-45,-40,-35,-30,-25,-20,-15,-10,-5,0,5,10,15,35,40,45,50,55,60,65,70,75];
grainInfo.roiFolderName = 'grainProcess/021016TiN/grain2/';
%}

%{
%GRAIN_3
grainInfo.numUsefulProj = 24;
grainInfo.angleList = [-75,-70,-65,-60,-55,-50,-45,-40,-35,-30,10,15,20,25,30,35,40,45,50,55,60,65,70,75];
grainInfo.roiFolderName = 'grainProcess/021016TiN/grain3/';
%}

%{
%GRAIN_4
grainInfo.numUsefulProj = 28;
grainInfo.angleList = [-75,-70,-65,-60,-55,-50,-40,-35,-30,-25,-20,-15,-5,0,5,10,20,25,30,35,40,45,50,55,60,65,70,75];
grainInfo.roiFolderName = 'grainProcess/021016TiN/grain4/';
%}

%{
%GRAIN_5
grainInfo.numUsefulProj = 15;
grainInfo.angleList = [-55,-35,-20,-15,0,5,10,15,25,35,40,50,65,70,75];
grainInfo.roiFolderName = 'grainProcess/021016TiN/grain5/';
%}

%
%GRAIN_6
grainInfo.numUsefulProj = 22;
grainInfo.angleList = [-70,-60,-55,-50,-40,-35,-30,-25,-20,-15,-10,-5,0,10,15,25,30,35,40,60,65,75];
grainInfo.roiFolderName = 'grainProcess/021016TiN/grain6/';
%}

roiFileName = 'alignedRoiList_';
scanInfo.scanWidth = 26;
scanInfo.scanHeight = 38;

for i = 1:1:grainInfo.numUsefulProj
    DFCoord{i} = strcat(grainInfo.roiFolderName,roiFileName,num2str(grainInfo.angleList(i)),'.mat');
end

count = 0;
for i=1:1:grainInfo.numUsefulProj
    coordListStruct = load(DFCoord{i});
    coordList = coordListStruct.alignedRoiList;%this name "alignedRoiList" may change when creating the matrix
    majorIndex = i;
    for k=1:1:size(coordList,1)
        count = count + 1;
        plotDistri(count,:) = [majorIndex,coordList(k,2)+1,coordList(k,1)+1];%fix the coordination
    end
end

%plot the results for examination purpose
figure;
scatter3(plotDistri(:,1),plotDistri(:,2),plotDistri(:,3),30,'filled');
axis([1,grainInfo.numUsefulProj,1,scanInfo.scanWidth,1,scanInfo.scanWidth]);

