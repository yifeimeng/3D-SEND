function plotCube(p1,p2,angle1,angle2)
%UNTITLED3 Summary of this function goes here
%   This function plot a cube to show the orientation in the holder
%   coordinate

[phi,theta,psi] = findDrawCubePara(p1,p2,angle1,angle2);
display(phi);
display(theta);
display(psi);
drawCube([0,0,0,1,theta,phi,psi],'FaceAlpha',0.7,'LineWidth',3)
axis equal
axis([-1,1,-1,1,-1,1]);
camroll(270);%adjust the camera roll according to the holder position
end

