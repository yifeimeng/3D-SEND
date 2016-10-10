function rho = angleTwoVector(p1,p2)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
product = p1*p2';
normalizedProduct = product/(norm(p1)*norm(p2));
rho = radtodeg(acos(normalizedProduct));

end

