function result = extractUVW(fileName, numPattern, patternDataMatrix)


currLine = fgets(fid);
lineCount = 0;
while ischar(currLine)
    lineCount = lineCount + 1;
    textArray{lineCount, 1} = currLine;
    currLine = fgets(fid);
end

%the pattern order has one offset related to the image stack
patterns = zeros(numPattern, 10);%pattern order, CC factor, pattern query key, rotation angle, u, v, w, spotGvector 
patterns = patterns - 1;
numMatch = 0;
sliceNum = 0;
for i = 1:1:lineCount
    currLine = textArray{i};
    firstChar = currLine(1);
    if (firstChar == 'X')
        numMatch = numMatch + 1;
        sliceNum = sliceNum + 1;
        temp(1:6) = sscanf(currLine, 'XP: %f , correlation = %f with DP %f at angle %f : %f %f');
        patterns(sliceNum,1:4) = temp(1:4);
    end
    if (firstChar == 'N')
        sliceNum = sliceNum + 1;
    end
    %branch for old result format
    if (isstrprop(firstChar,'digit'))
        numMatch = numMatch + 1;
        sliceNum = sliceNum + 1;
        patterns(sliceNum,1:4) = sscanf(currLine, '%f best match, correlation = %f with DP %f at angle %f');
    end
    
end

fclose(fid);
fprintf('\n%d patterns are processed', sliceNum);
fprintf('\n%d patterns are matched', numMatch);

numQuery = 0;

for i = 1:1:numPattern
    queryKey = patterns(i, 3);
    if queryKey > 0
        xSphere = patternDataMatrix(queryKey, 8);
        ySphere = patternDataMatrix(queryKey, 9);
        zSphere = patternDataMatrix(queryKey, 10);
        gVector = patternDataMatrix(queryKey, 11:13);
        numQuery = numQuery + 1;
    end
    %special case for key = 0
    if queryKey == 0
        xSphere = -0.01;
        ySphere = -0.02;
        zSphere = 0.99975;
        gVector = [-2,0,0];
        numQuery = numQuery + 1;
    end
    %for unsuccessful match, keep x, y, z as -1
    if queryKey < 0
        xSphere = -1;
        ySphere = -1;
        zSphere = -1;
        gVector = [0,0,0];
    end
    %for cubic crystal, uvw is equal to xyz
    patterns(i, 5) = xSphere;
    patterns(i, 6) = ySphere;
    patterns(i, 7) = zSphere;
    patterns(i, 8:10) = gVector;
end
fprintf('\n%d queries are performed', numQuery);
fprintf('\n');

result = patterns;
end