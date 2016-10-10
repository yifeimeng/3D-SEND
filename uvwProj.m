function [resultUVW,axisSwitch] = uvwProj(originalVector)
%calculate permutation of p
o = originalVector;
p = zeros(6,3);
p(1,:) = [o(2),o(1),o(3)];
p(2,:) = [o(3),o(2),o(1)];
p(3,:) = [o(1),o(3),o(2)];
p(4,:) = [o(3),o(1),o(2)];
p(5,:) = [o(2),o(3),o(1)];
p(6,:) = [o(1),o(2),o(3)];
%001 -- red -- A
%011 -- green -- B
%111 -- blue -- C
OCB = [0, -0.408, 0.408];%inside the tetrahedron
OAC = [-0.577, 0.577, 0];%inside the tetrahedron
OAB = [0.707, 0, 0];%inside the tetrahedron

projIndex = 0;
axisSwitch = 0;
for i=1:1:size(p,1)
    product_1 = p(i,:)*OCB';
    product_2 = p(i,:)*OAC';
    product_3 = p(i,:)*OAB';
    if (product_1>=0 && product_2>=0 && product_3>=0)
        projIndex = i;
    end
end

if (projIndex > 0) 
    resultUVW = p(projIndex,:);
end

if (projIndex == 1 || projIndex == 2 || projIndex == 3)
    axisSwitch = 1;
end
if (projIndex == 4 || projIndex == 5)
    axisSwitch = 2;
end
if (projIndex == 6)
    axisSwitch = 0;
end

end

