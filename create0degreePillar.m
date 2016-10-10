gridSize = 25;
rotAxis = [0.993,-0.115,0];
proj = zeros(gridSize,gridSize);
for i=1:1:gridSize
    for j=1:1:gridSize
        voxel = [i,j,12.5];
        exist = spaceMask(voxel, rotAxis);
        if (exist==1)
            proj(i,j) = 1;
        end
    end
end

proj = proj';
imshow(proj);