function pAfterRP = allPossibleUVW(oV,angle,axis)
t1 = [oV(1),oV(2),oV(3)];
t2 = [-oV(1),oV(2),oV(3)];
t3 = [oV(1),-oV(2),oV(3)];
t4 = [oV(1),oV(2),-oV(3)];
t5 = [oV(1),-oV(2),-oV(3)];
t6 = [-oV(1),oV(2),-oV(3)];
t7 = [-oV(1),-oV(2),oV(3)];
t8 = [-oV(1),-oV(2),-oV(3)];
p = zeros(48,3);
p(1:6,:) = perms(t1);
p(7:12,:) = perms(t2);
p(13:18,:) = perms(t3);
p(19:24,:) = perms(t4);
p(25:30,:) = perms(t5);
p(31:36,:) = perms(t6);
p(37:42,:) = perms(t7);
p(43:48,:) = perms(t8);
pAfterRP = zeros(48,3);
for i=1:1:48
    pAfterRP(i,:) = uvwProj(abs(uvwRotate(p(i,:),angle,axis)));
end
end

