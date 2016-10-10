sampleName = '021016TiN/';

d1 = importdata(strcat('reconResults/',sampleName,'grain1_d.mat'));
d2 = importdata(strcat('reconResults/',sampleName,'grain2_d.mat'));
d3 = importdata(strcat('reconResults/',sampleName,'grain3_d.mat'));
d4 = importdata(strcat('reconResults/',sampleName,'grain4_d.mat'));
d5 = importdata(strcat('reconResults/',sampleName,'grain5_d.mat'));
d6 = importdata(strcat('reconResults/',sampleName,'grain6_d.mat'));
d7 = importdata(strcat('reconResults/',sampleName,'grain7_d.mat'));
%d8 = importdata(strcat('reconResults/',sampleName,'grain8_d.mat'));

v1 = importdata(strcat('reconResults/',sampleName,'grain1_v.mat'));
v2 = importdata(strcat('reconResults/',sampleName,'grain2_v.mat'));
v3 = importdata(strcat('reconResults/',sampleName,'grain3_v.mat'));
v4 = importdata(strcat('reconResults/',sampleName,'grain4_v.mat'));
v5 = importdata(strcat('reconResults/',sampleName,'grain5_v.mat'));
v6 = importdata(strcat('reconResults/',sampleName,'grain6_v.mat'));
v7 = importdata(strcat('reconResults/',sampleName,'grain7_v.mat'));
%d8 = importdata(strcat('reconResults/',sampleName,'grain8_d.mat'));

%
v1s = smooth3(v1);
figure;
isovalueMid = 0.03;
surf_1 = isosurface(v1s, isovalueMid);
p_1 = patch(surf_1);
isonormals(v1s, p_1);
set(p_1,'FaceColor','yellow','EdgeColor','none','FaceAlpha',0.5);
%}

%
v2s = smooth3(v2);
isovalueMid = 0.03;
surf_2 = isosurface(v2s, isovalueMid);
p_2 = patch(surf_2);
isonormals(v2s, p_2);
set(p_2,'FaceColor','red','EdgeColor','none','FaceAlpha',0.5);
%}

%
v3s = smooth3(v3);
isovalueMid = 0.03;
surf_3 = isosurface(v3s, isovalueMid);
p_3 = patch(surf_3);
isonormals(v3s, p_3);
set(p_3,'FaceColor','blue','EdgeColor','none','FaceAlpha',0.5);
%}

%
v4s = smooth3(v4);
isovalueMid = 0.03;
surf_4 = isosurface(v4s, isovalueMid);
p_4 = patch(surf_4);
isonormals(v4s, p_4);
set(p_4,'FaceColor','magenta','EdgeColor','none','FaceAlpha',0.5);
%}

%
v5s = smooth3(v5);
isovalueMid = 0.02;
surf_5 = isosurface(v5s, isovalueMid);
p_5 = patch(surf_5);
isonormals(v5s, p_5);
set(p_5,'FaceColor','green','EdgeColor','none','FaceAlpha',0.5);
%}

%
v6s = smooth3(v6);
isovalueMid = 0.05;
surf_6 = isosurface(v6s, isovalueMid);
p_6 = patch(surf_6);
isonormals(v6s, p_6);
set(p_6,'FaceColor','cyan','EdgeColor','none','FaceAlpha',0.5)
%}

%{
v7s = smooth3(v7);
isovalueMid = 0.05;
surf_7 = isosurface(v7s, isovalueMid);
p_7 = patch(surf_7);
isonormals(v7s, p_7);
set(p_7,'FaceColor','cyan','EdgeColor','none','FaceAlpha',0.5);
%}

%{
v8s = smooth3(v8);
isovalueMid = 0.05;
surf_8 = isosurface(v8s, isovalueMid);
p_8 = patch(surf_8);
isonormals(v8s, p_8);
set(p_8,'FaceColor','cyan','EdgeColor','none','FaceAlpha',0.5);
%}

%Draw the pillar outline(optional)
%{
vp = importdata('vPillarSurface.mat');
vps = smooth3(vp);%Smooth?
isovalueMid = 0.4;
surf_p = isosurface(vps, isovalueMid);
p_p = patch(surf_p);
isonormals(vps, p_p);
set(p_p,'FaceColor','green','EdgeColor','none','FaceAlpha',0.2);
%}

%light effects
daspect([1,1,1]);
view([0,0]);
axis([1,38,1,26,1,26])
camlight; lighting gouraud