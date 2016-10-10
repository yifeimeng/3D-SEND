function pp = vectorRotate(p, rotationAngle, rotationAxis)
%the rotation used the Rodrigues Formula
%the rotation axis is a unit vector
ax = rotationAxis(1);
ay = rotationAxis(2);
az = rotationAxis(3);
A = [0,-az,ay;az,0,-ax;-ay,ax,0];
%the rotation angle is theta, plus roation is counter clockwise
theta = degtorad(rotationAngle);
%calculate the rotation matrix Q
Q = eye(3) + A*sin(theta) + A*A*(1-cos(theta));
%the original vector is p
pp = Q*p';
pp = pp';

end

