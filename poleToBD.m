function bd = poleToBD(p)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
X1 = p(1);
Y1 = p(2);
x1 = 2*X1/(1+X1^2+Y1^2);
y1 = 2*Y1/(1+X1^2+Y1^2);
z1 = -1*(-1+X1^2+Y1^2)/(1+X1^2+Y1^2);%projection from the south pole

bd = [x1,y1,z1];


end

