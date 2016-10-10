function rho = checkAngleTwoBD(bd1,bd2)
%The beam direction is (x,y) in the stereoprojection.

X1 = bd1(1);
Y1 = bd1(2);
x1 = 2*X1/(1+X1^2+Y1^2);
y1 = 2*Y1/(1+X1^2+Y1^2);
z1 = (-1+X1^2+Y1^2)/(1+X1^2+Y1^2);

X2 = bd2(1);
Y2 = bd2(2);
x2 = 2*X2/(1+X2^2+Y2^2);
y2 = 2*Y2/(1+X2^2+Y2^2);
z2 = (-1+X2^2+Y2^2)/(1+X2^2+Y2^2);

p1 = [x1,y1,z1];
p2 = [x2,y2,z2];
product = p1*p2';
normalizedProduct = product/(norm(p1)*norm(p2));
rho = radtodeg(acos(normalizedProduct));
display(rho);

end

