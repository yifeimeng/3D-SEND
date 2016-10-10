function [sectPoint, si] = linePlaneIntersect(planeOrigin, planeNorm, source, direction)
n = planeNorm;
w = source - planeOrigin;
u = direction;
si = -(w*n)/(u*n);%multiple two vectors to get a value
sectPoint = source + si.*direction;

end

