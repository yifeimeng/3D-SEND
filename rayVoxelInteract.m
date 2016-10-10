function A = rayVoxelInteract(gridSize, angleList, numProj, rotAxis)
A = zeros((gridSize^2)*numProj, gridSize^3); 
%create an plane of sources above the cube
numSource = gridSize^2;
centerVector = [gridSize/2, gridSize/2, gridSize/2];
iniSPOriginVector = [0, 0 ,gridSize*2];
cToIniOVector = iniSPOriginVector - centerVector;
iniXVector = [1,0,0];
iniYVector = [0,1,0];
iniDirection = [0,0,-1];

%calculate intersection for every angle
for i=1:1:numProj
    currDirection = vectorRotate(iniDirection, angleList(i), rotAxis);%modify + and - to change the rotation direction
    sourcePlane = zeros(numSource, 3);
    %calculate the sourcePlane
    for ii=1:1:gridSize
        for jj=1:1:gridSize
            currCtoOVector = vectorRotate(cToIniOVector, angleList(i), rotAxis);
            currOrigin = centerVector + currCtoOVector;
            currXVector = vectorRotate(iniXVector, angleList(i), rotAxis);
            currYVector = vectorRotate(iniYVector, angleList(i), rotAxis);
            currSource = (ii-0.5)*currXVector + (jj-0.5)*currYVector + currOrigin;
            sourcePlane((ii-1)*gridSize+jj,:) = currSource;
        end
    end
    for j=1:1:numSource
        currSource = sourcePlane(j,:);
        currIntersect = rayCubeIntersect(gridSize, currSource, currDirection);
        if (~isnan(currIntersect))
            voxelList = DDA3D(gridSize, currIntersect, currDirection);
            if (~isempty(voxelList))
                %This part define the contribution of each voxel
                numVoxel = size(voxelList,1);
                touchedCount = 0;
                for k=1:1:numVoxel
                    indexA = (voxelList(k,1)-1)*gridSize + voxelList(k,2) + (voxelList(k,3)-1)*(gridSize^2);
                    currVoxel = voxelList(k,:);
                   
                    %Use exp decay by whole
                    %decayConstant = 4/numVoxel;
                    %A((i-1)*(gridSize^2)+j, indexA) = 1*spaceMask(currVoxel, rotAxis)*exp(-decayConstant*k);
                    
                    %Use exp decay by count
                    %
                    if spaceMask(currVoxel, rotAxis) == 1
                        A((i-1)*(gridSize^2)+j, indexA) = 1*spaceMask(currVoxel, rotAxis)*exp(-0.2*touchedCount);
                        touchedCount = touchedCount + 1;
                    end
                    %}
                    
                end
            end
        else
            A((i-1)*(gridSize^2)+j, :) = 0;
        end
        %check the intersection points
        %intersectList(j,:) = currIntersect;
    end
    %plot the intersection points at this projection
    %figure;
    %scatter3(intersectList(:,1),intersectList(:,2),intersectList(:,3));
end



end

