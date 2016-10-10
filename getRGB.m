function result = getRGB(vector)
%the r,g,b value is based on the distance to three corners
%001 -- red -- A
%011 -- green -- B
%111 -- blue -- C

%get UVW fro the input
u=vector(1);
v=vector(2);
w=vector(3);

%define the norm of three planes
OBC = [0, -0.408, 0.408];%norm of the plane formed by [011] and [111] vector
OAC = [-0.577, 0.577, 0];%norm of the plane formed by [001] and [111] vector
OAB = [0.707, 0, 0];%norm of the plane formed by [001] and [011] vector

%calculate the angle between the input vector and the three plane norms
angleOBCNorm = acos((u*0 + v*-0.408 + w*0.408)/0.577);
angleOACNorm = acos((u*-0.577 + v*0.577 + w*0)/0.816);
angleOABNorm = acos((u*0.707 + v*0 + w*0)/0.707);

%calculate the angle between the input vector and the three planes
angleOBC = pi/2 - angleOBCNorm;
angleOAC = pi/2 - angleOACNorm;
angleOAB = pi/2 - angleOABNorm;

%Fix the rounding error
if (angleOBC<0) angleOBC = 0; end
if (angleOAC<0) angleOAC = 0; end
if (angleOAB<0) angleOAB = 0; end
    

%convert the three angles into chromaticity graph
scale = 1/max([angleOBC, angleOAC, angleOAB]);
r = angleOBC*scale;
g = angleOAC*scale;
b = angleOAB*scale;

result = [r,g,b];


end