function p = poleFigureEquiv(oV)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
t1 = [oV(1),oV(2),oV(3)];

p = zeros(24,3);
p(1,:) = [oV(1),oV(2),oV(3)];
p(2,:) = [oV(1),oV(3),oV(2)];
p(3,:) = [oV(2),oV(1),oV(3)];
p(4,:) = [oV(2),oV(3),oV(1)];
p(5,:) = [oV(3),oV(1),oV(2)];
p(6,:) = [oV(3),oV(2),oV(1)];

p(7,:) = [-oV(1),oV(2),oV(3)];
p(8,:) = [-oV(1),oV(3),oV(2)];
p(9,:) = [-oV(2),oV(1),oV(3)];
p(10,:) = [-oV(2),oV(3),oV(1)];
p(11,:) = [-oV(3),oV(1),oV(2)];
p(12,:) = [-oV(3),oV(2),oV(1)];

p(13,:) = [oV(1),-oV(2),oV(3)];
p(14,:) = [oV(1),-oV(3),oV(2)];
p(15,:) = [oV(2),-oV(1),oV(3)];
p(16,:) = [oV(2),-oV(3),oV(1)];
p(17,:) = [oV(3),-oV(1),oV(2)];
p(18,:) = [oV(3),-oV(2),oV(1)];

p(19,:) = [-oV(1),-oV(2),oV(3)];
p(20,:) = [-oV(1),-oV(3),oV(2)];
p(21,:) = [-oV(2),-oV(1),oV(3)];
p(22,:) = [-oV(2),-oV(3),oV(1)];
p(23,:) = [-oV(3),-oV(1),oV(2)];
p(24,:) = [-oV(3),-oV(2),oV(1)];

end

