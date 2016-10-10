function [] = draw3dDistri(gridSize, x, threshold)
count = 0;
for i=0:1:(length(x)-1)
    if x(i+1)>threshold
        count = count + 1;
        zPos = floor(i/(gridSize^2))+1;
        zRem = mod(i, gridSize^2);
        xPos = floor(zRem/gridSize)+1;
        xRem = mod(zRem, gridSize);
        yPos = xRem+1;
        distri(count,:) = [xPos, yPos, zPos];
    end
end
figure;
axis([1,25,1,25,1,25]);
scatter3(distri(:,1),distri(:,2),distri(:,3),'filled');

end

