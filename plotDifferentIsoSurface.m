sampleName = '021016TiN/';

d = importdata(strcat('reconResults/',sampleName,'grain4_d.mat'));

v = importdata(strcat('reconResults/',sampleName,'grain4_v.mat'));

vs = smooth3(v);
figure;
isovalue_1 = 0.03;
surf_1 = isosurface(vs, isovalue_1);
p_1 = patch(surf_1);
isonormals(vs, p_1);
set(p_1,'FaceColor','magenta','EdgeColor','none','FaceAlpha',0.2);

isovalue_2 = 0.04;
surf_2 = isosurface(vs, isovalue_2);
p_2 = patch(surf_2);
isonormals(vs, p_2);
set(p_2,'FaceColor','magenta','EdgeColor','none','FaceAlpha',0.7);

%{
isovalue_3 = 0.04;
surf_3 = isosurface(vs, isovalue_3);
p_3 = patch(surf_3);
isonormals(vs, p_3);
set(p_3,'FaceColor','yellow','EdgeColor','none','FaceAlpha',0.8);
%}

daspect([1,1,1]);
%view([90,90]);
axis([1,36,1,26,1,26])
camlight; lighting gouraud