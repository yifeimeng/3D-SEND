rotAxis = [0.996,0.087,0];
height = 60;%X axis length
width = 30;%Y, Z axis length

pillarSurface = zeros(height,width,width);
vp = zeros(width,height,height);
scatterPlot = [];
numPoints = 0;
for i = 1:1:height
    for j = 1:1:width
        for k = 1:1:width            
           currVoxel = [i,j,k];
           if spaceMask(currVoxel,rotAxis) == 1
               numPoints = numPoints + 1;
               pillarSurface(i,j,k) = 1;
               vp(j,i,k) = 1;%need a x-y swap
               scatterPlot(numPoints,:) = currVoxel;
           end
        end
    end
end

figure;
scatter3(scatterPlot(:,1),scatterPlot(:,2),scatterPlot(:,3));

save('vPillarSurface.mat','vp');


%sliceomatic(vp);
vps = smooth3(vp);%Smooth?
figure;
isovalueMid = 0.5;
surf_p = isosurface(vps, isovalueMid);
p_p = patch(surf_p);
isonormals(vps, p_p);
set(p_p,'FaceColor','yellow','EdgeColor','none','FaceAlpha',0.5);

daspect([1,1,1]);
%view([90,90]);
axis([1,60,1,30,1,30])
camlight; lighting gouraud