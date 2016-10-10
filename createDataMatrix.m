%This script convert the QED database file into a matlab matrix
[fileName, pathName] = uigetfile('*.dat', 'Select the database file created by QED');
fullFileName = strcat(pathName, fileName);
fid = fopen(fullFileName);

currLine = fgets(fid);
lineCount = 0;
while ischar(currLine)
    lineCount = lineCount + 1;
    currLine = fgets(fid);
    iniTwoChar = currLine(1); 
    if strcmp(iniTwoChar, 'D') 
        patternKey = sscanf(currLine, 'DP %d');
        nextLine = fgets(fid);
        if patternKey > 0
            %Get the beam direction information
            beamInfo = sscanf(nextLine, '%f %f %f %f %f %f %f %f %f %f');
            patternDataMatrix(patternKey).beam = beamInfo';
            %Get the g vector for the strongest spot
            nextLine = fgets(fid);
            numSpot = sscanf(nextLine,'%d');
            patternDataMatrix(patternKey).numSpot = numSpot;
                        
            for index = 1:1:numSpot
                nextLine = fgets(fid);
                spotInfo = sscanf(nextLine, '%f %f %f %f %f %f %f %f');
                
                patternDataMatrix(patternKey).spot(index,:) = spotInfo';

            end
        end
    end
end

save(strcat(fileName, 'ForQuery.mat'), 'patternDataMatrix');
fclose(fid);