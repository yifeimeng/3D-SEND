function grainDistri = DFGrainCollect(exp,res)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

height = exp.scanHeight;
width = exp.scanWidth;
numUsefulProj = exp.numUsefulProj;

DFCoord = res.DFCoord;
count = 0;
grainDistri=zeros(height*width*numUsefulProj,1);

for i=1:1:numUsefulProj
    coordListStruct = load(DFCoord{i});
    coordList = coordListStruct.alignedRoiList;%this name "alignedRoiList" may change when creating the matrix
    majorIndex = i;
    for k=1:1:size(coordList,1)
        currIndex = (majorIndex-1)*height*width+coordList(k,2)*width+(coordList(k,1)+1);%fix the coordination
        grainDistri(currIndex) = 1;
        count = count + 1;
        plotDistri(count,:) = [majorIndex,coordList(k,2)+1,coordList(k,1)+1];%fix the coordination
    end
end

grainSize = count;
%plot the results for examination purpose
figure;
scatter3(plotDistri(:,1),plotDistri(:,2),plotDistri(:,3),30,'filled');
axis([1,35,1,60,1,30]);
end

