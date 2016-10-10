function T = calculateTMatrix(hList, cList, numPoints)
%This function calculates the transformation matrix
%c is the crystal coord, h is the holder coordinate, h = Tc

%calculate the error function
B = zeros(3);
for i = 1:1:numPoints
    currh = hList(i,:);
    currc = cList(i,:);
    B = B + currh'*currc;
end

[U,S,V] = svd(B);
M = zeros(3);
M(1,1) = 1;
M(2,2) = 1;
M(3,3) = det(U)*det(V);

T = (U*M)*V';


end

