function [phi,theta,psi,M] = findDrawCubePara(p1,p2,angle1,angle2)
%UNTITLED Summary of this function goes here
%p1 and p2 contains pole figure coordinate; H1 and H2 contains 3D
%coordinate; angle 1 and 2 contains the rotated angle in the holder
%coordinate. Based on the Cryo 2100 setting, - sign is clockwise beam
%rotation. The 0 rotation is always the [0,0,1] direction.

%calculate the beam direction in the crystal coordinate
c1 = poleToBD(p1);
c2 = poleToBD(p2);

%calculate the beam direction in the holder coordinate
H1 = vectorRotate([0,0,1],angle1,[1,0,0]);
H2 = vectorRotate([0,0,1],angle2,[1,0,0]);

%calculate the transformation matrix. (H=Mc)
M = triad(c1,c2,H1,H2);

%calculate the direction of the cube norm
cubeNorm = M*[0;0;1];
phiRad = atan(cubeNorm(2)/cubeNorm(1));
thetaRad = acos(cubeNorm(3));
phi = radtodeg(phiRad);
theta = radtodeg(thetaRad);

%calculate the direction of the cube rotation alignment vector [1;0;0] to determine the psi
cubeAlignVector = M*[1;0;0];
cubeAlignOrigin = [cos(thetaRad)*cos(phiRad),cos(thetaRad)*sin(phiRad),-sin(thetaRad)];

angleBetween = acos(dot(cubeAlignVector',cubeAlignOrigin)/(norm(cubeAlignVector)*norm(cubeAlignOrigin)));
crossProduct = cross(cubeAlignOrigin,cubeAlignVector');

if (crossProduct(3)*cubeNorm(3))>0
    psi = radtodeg(angleBetween);
else
    psi = 360-radtodeg(angleBetween);
end



end

