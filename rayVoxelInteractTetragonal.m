function A = rayVoxelInteractTetragonal(scanningWidth, scanningHeight, angleList, numProj, rotAxis)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

A = int8(zeros((scanningWidth*scanningHeight)*numProj, scanningWidth*scanningWidth*scanningHeight)); 
%create an plane of sources above the cube
numSource = scanningWidth*scanningHeight;
centerVector = [scanningHeight/2, scanningWidth/2, scanningWidth/2];
iniSPOriginVector = [0, 0 ,scanningWidth*2];
cToIniOVector = iniSPOriginVector - centerVector;
iniXVector = [1,0,0];
iniYVector = [0,1,0];
iniDirection = [0,0,-1];

%calculate intersection for every angle
for i=1:1:numProj
    currDirection = vectorRotate(iniDirection, angleList(i), rotAxis);%modify + and - to change the rotation direction
    sourcePlane = zeros(numSource, 3);
    %calculate the sourcePlane
    for ii=1:1:scanningHeight
        for jj=1:1:scanningWidth
            currCtoOVector = vectorRotate(cToIniOVector, angleList(i), rotAxis);
            currOrigin = centerVector + currCtoOVector;
            currXVector = vectorRotate(iniXVector, angleList(i), rotAxis);
            currYVector = vectorRotate(iniYVector, angleList(i), rotAxis);
            currSource = (ii-0.5)*currXVector + (jj-0.5)*currYVector + currOrigin;
            sourcePlane((ii-1)*scanningWidth+jj,:) = currSource;
        end
    end
    for j=1:1:numSource
        currSource = sourcePlane(j,:);
        currIntersect = rayTetragonalIntersect(scanningHeight, scanningWidth, currSource, currDirection);
        if (~isnan(currIntersect))
            voxelList = DDA3D(scanningHeight, scanningWidth, scanningWidth, currIntersect, currDirection);
            if (~isempty(voxelList))
                %This part define the contribution of each voxel
                numVoxel = size(voxelList,1);
                touchedCount = 0;
                for k=1:1:numVoxel
                    indexA = (voxelList(k,1)-1)*scanningWidth + voxelList(k,2) + (voxelList(k,3)-1)*(scanningWidth*scanningHeight);
                    currVoxel = voxelList(k,:);
                    
                    %Use mask confinement
                    if spaceMask(currVoxel, rotAxis) == 1
                        %Use exp decay by count
                        A((i-1)*(scanningWidth*scanningHeight)+j, indexA) = 1*spaceMask(currVoxel, rotAxis)*exp(-0*touchedCount);
                        touchedCount = touchedCount + 1;
                    end
         
                end
            end
        else
            A((i-1)*(scanningWidth*scanningHeight)+j, :) = int8(0);
        end
        %check the intersection points
        %intersectList(j,:) = currIntersect;
    end
    %plot the intersection points at this projection
    %figure;
    %scatter3(intersectList(:,1),intersectList(:,2),intersectList(:,3));
end



end

