%plot the combined grains
%
v1s = smooth3(v1);
v2s = smooth3(v2);
v3s = smooth3(v3);
v4s = smooth3(v4);
v5s = smooth3(v5);


figure;
isovalueBot = 0.05;
surf_1 = isosurface(v1s, isovalueBot);
p_1 = patch(surf_1);
isonormals(v1s, p_1);
set(p_1,'FaceColor','red','EdgeColor','none','FaceAlpha',0.2);


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

isovalueTop = 0.05;
surfTop = isosurface(v4s, isovalueTop);
p_4 = patch(surfTop);
isonormals(v4s, p_4);
set(p_4,'FaceColor','magenta','EdgeColor','none','FaceAlpha',0.2);

isovalueTop = 0.05;
surfTop = isosurface(v5s, isovalueTop);
p_5 = patch(surfTop);
isonormals(v5s, p_5);
set(p_5,'FaceColor','blue','EdgeColor','none','FaceAlpha',0.2);

daspect([1,1,1]);

axis([0,26,0,26,0,26]);
view(90,90);
camlight; 
lighting gouraud