%This script create a matlab database containing the simulated DP patterns
%This script read the file generated by QED

[fileName, pathName] = uigetfile('*.dat', 'Select the database file created by QED');
fullFileName = strcat(pathName, fileName);
fid = fopen(fullFileName);

currLine = fgets(fid);
lineCount = 0;
while ischar(currLine)
    currLine = fgets(fid);
    iniChar = currLine(1);
    lineCount = lineCount + 1;
    if strcmp(iniChar, 'D')
        %Get the DP key
        patternKey = sscanf(currLine, 'DP %d');
        if patternKey > 0
            %Get the beam direction information
            currLine = fgets(fid);
            lineCount = lineCount + 1;
            beamInfo = sscanf(currLine, '%f %f %f %f %f %f %f %f %f %f');
            dpOrientationMatrix(patternKey, 1:10) = beamInfo';
            %Get the number of spots
            currLine = fgets(fid);
            lineCount = lineCount + 1;
            numOfSpots = sscanf(currLine, '%d');
            dpNumberSpotsMatrix(patternKey) = numOfSpots;
            %Get the spot position details
            currLine = fgets(fid);
            lineCount = lineCount + 1;
            spotCount = 1;
            while spotCount<=numOfSpots
                spotInfo = sscanf(currLine, '%f %f %f %f %f %f %f %f');
                dpSpotMatrix(patternKey,spotCount,1:8) = spotInfo';
                currLine = fgets(fid);
                lineCount = lineCount + 1;
                spotCount = spotCount + 1;
            end
        end
    end
end

save(strcat(fileName, 'OrientForQuery.mat'), 'dpOrientationMatrix');
save(strcat(fileName, 'NumberSpotsForQuery.mat'), 'dpNumberSpotsMatrix');
save(strcat(fileName, 'SpotsForQuery.mat'), 'dpSpotMatrix');
fclose(fid);