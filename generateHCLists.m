function [phi,theta,psi,T] = generateHCLists()
grainID = 'grain1';
%the num of projection and the angle list here may differ from what is used
%for sendTomo reconstruction
grainInfo.numUsefulProj = 18;
grainInfo.angleList = [-85,-80,-75,-70,-65,-55,-50,-45,-40,-35,-30,-25,-20,-15,-10,-5,0,5];

hList = zeros(grainInfo.numUsefulProj,3);
cList = zeros(grainInfo.numUsefulProj,3);
poleList = importdata('poleListGrain1.txt');

for i = 1:1:grainInfo.numUsefulProj
    currh = vectorRotate([0,0,1],grainInfo.angleList(i),[1,0,0]);
    hList(i,:) = currh;
    currc = poleToBD(poleList(i,:));
    cList(i,:) = currc;
end

T = calculateTMatrix(hList,cList,grainInfo.numUsefulProj);
%calculate the direction of the cube norm
cubeNorm = T*[0;0;1];
phiRad = atan(cubeNorm(2)/cubeNorm(1));
thetaRad = acos(cubeNorm(3));
phi = radtodeg(phiRad);
theta = radtodeg(thetaRad);

%calculate the direction of the cube rotation alignment vector [1;0;0] to determine the psi
cubeAlignVector = T*[1;0;0];
cubeAlignOrigin = [cos(thetaRad)*cos(phiRad),cos(thetaRad)*sin(phiRad),-sin(thetaRad)];

angleBetween = acos(dot(cubeAlignVector',cubeAlignOrigin)/(norm(cubeAlignVector)*norm(cubeAlignOrigin)));
crossProduct = cross(cubeAlignOrigin,cubeAlignVector');

if (crossProduct(3)*cubeNorm(3))>0
    psi = radtodeg(angleBetween);
else
    psi = 360-radtodeg(angleBetween);
end

end


