function result = getMFromOneAngle(beamDirection,gVector,phi,CCDrotation)
%phi and CCDrotation is in the angle of degree

%Laboratory coordinate xyz
%crystalgraphic coordinate abc
%alpha = angle between z and a
%beta = angle between z and b
%gamma = angle between z and c
alpha = acos(beamDirection(1));
beta  = acos(beamDirection(2));
gamma = acos(beamDirection(3));
%thetaA is the angle between x and the projection of a on the x-y plane,
%plus is clockwise. We need to consider the CCD rotation error
iniThetaA = 0;
[iniAbcToXyz,~,~] = generateM(alpha,beta,gamma,iniThetaA);
iniG = iniAbcToXyz*gVector;
iniG2D = [iniG(1);iniG(2)];
refG2D = [0,-1;1,0]*[gVector(1);gVector(2)];
alignRot = acos(dot(iniG2D,refG2D)/(norm(iniG2D)*norm(refG2D)));
RforAlign = [cos(alignRot),-sin(alignRot);sin(alignRot),cos(alignRot)];%counter clockwise rotation
predRefG2D = RforAlign*iniG2D;

if (norm(predRefG2D-refG2D)<1e-2)
    thetaA = mod((alignRot + degtorad(CCDrotation+phi)),2*pi);
else
    thetaA = mod((2*pi - alignRot + degtorad(CCDrotation+phi)),2*pi);
end

[~,realXyzToAbc,~] = generateM(alpha,beta,gamma,thetaA);
result = realXyzToAbc;

end

function [abcToxyz,xyzToabc,REP]=generateM(alpha,beta,gamma,thetaA)
%follow the right-thumb rule for abc and xyz
thetaBminusA = acos(-(cos(alpha)*cos(beta))/(sin(alpha)*sin(beta)));
thetaCminusA = -acos(-(cos(alpha)*cos(gamma))/(sin(alpha)*sin(gamma)));
thetaB = thetaA + thetaBminusA;
thetaC = thetaA + thetaCminusA;
%Use angles to calculate the transformation matrix
xa = sin(alpha)*cos(thetaA);
ya = sin(alpha)*sin(thetaA);
za = cos(alpha);

xb = sin(beta)*cos(thetaB);
yb = sin(beta)*sin(thetaB);
zb = cos(beta);

xc = sin(gamma)*cos(thetaC);
yc = sin(gamma)*sin(thetaC);
zc = cos(gamma);

REP = [xa,ya,za;xb,yb,zb;xc,yc,zc];

abcToxyz = REP';
xyzToabc = inv(REP');
end

