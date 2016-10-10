function [grainDistri, grainSize, grainToken, vacuumDistri, vacuumSize] = grainFinder(threshold)
%threshold is in degree
numProj = 17;
angleList = [0,10,20,30,40,50,60,70,80,90,100,110,120,130,140,150,160];

height = 25;
width = 25;
rotAxis = [-0.707,0.707,0];
poolSize = 1;

b = collectProjDataMAT();
grainDistri = zeros(height*width*numProj, poolSize);
grainSize = zeros(poolSize, 1);
numGrain = 0;
vacuumDistri = zeros(height*width*numProj,1);
vacuumSize = 0;

for i=1:1:numProj
    for m=1:1:numGrain
        grainPool(m,:,:) = allPossibleUVW(grainToken(m,:),angleList(i),rotAxis);
    end
    for j=1:1:height
        for k=1:1:width
            currIndex = (i-1)*height*width+(j-1)*height+k;
            currUVW = b(currIndex,:);
            if (currUVW(1)<0 && currUVW(2)<0 && currUVW(3)<0) 
                vacuumDistri(currIndex) = 1;
                vacuumSize = vacuumSize + 1;
            else
                minDiff = 90;
                if (numGrain>0)
                    diff = zeros(numGrain,48);
                    for m=1:1:numGrain
                        for n=1:1:48
                            diff(m,n) = radtodeg(acos(reshape(grainPool(m,n,:),[1,3])*currUVW'));
                        end
                    end
                    minEachGrain = min(diff,[],2);
                    [minDiff,minIndex] = min(minEachGrain);
                end
                if (minDiff <= threshold)
                    grainDistri(currIndex,minIndex) = 1;
                    grainSize(minIndex) = grainSize(minIndex) + 1;
                else
                    numGrain = numGrain + 1;
                    grainToken(numGrain,:) = uvwProj(abs(uvwRotate(currUVW,-angleList(i),rotAxis)));
                    grainDistri(:,numGrain) = 0;
                    grainDistri(currIndex,numGrain) = 1;
                    grainSize(numGrain) = 1;
                    grainPool(numGrain,:,:) = allPossibleUVW(grainToken(numGrain,:),angleList(i),rotAxis);
                end
            end
            fprintf('\npixel %d',currIndex);
        end
    end
end


end

