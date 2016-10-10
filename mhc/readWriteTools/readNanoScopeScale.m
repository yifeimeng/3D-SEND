function scale=readNanoScopeScale(fileName)

fid = fopen(fileName,'r');

header = readHeader(fid);

%Get number of channels
channelIndex = findstr(header, upper('\*Ciao image list'));
channelN = length(channelIndex);

lineSpec = ['r';'g';'b';'m']; %maximum 4 channels
%clf;
%hold on;
for i = 1 : channelN
   dataOffset = getKeyVal(header(channelIndex(i) : end), 'Data offset', '%d', 0);
   dataLengthBytes = getKeyVal(header(channelIndex(i) : end), 'Data length', '%d', 0);
   bytesPerPixel = getKeyVal(header(channelIndex(i) : end), 'Bytes/pixel', '%d', 0);
   dataLength = dataLengthBytes / bytesPerPixel;
   
   [typeStr, softScaleKey, hardScale, hardValue] = getCiaoParm(header(channelIndex(i) : end), '2:Z scale', 0);
   if (length(softScaleKey) > 0)
       [typeStr, temp1, temp2, softScale] = getCiaoParm(header(1 : end), softScaleKey, 0);
   end
   
   hardValue = hardValue * 2^(-16);
   fprintf(1, 'scaling: %e x %e = %e (soft x hard = total)\n', softScale, hardValue, softScale * hardValue);
   
   scale(i)=softScale*hardValue;

   %fseek(fid, dataOffset, -1);
   %data = fread(fid, dataLength, 'int16');
   %plot(data, 'DisplayName', 'data', 'YDataSource', 'data'); figure(gcf) %to display the graph to compare it with NanoScope analysis
   %plot(data, lineSpec(i));
end

fclose(fid);
end


function [header] = readHeader(fid)

fseek(fid, 0, -1);
[header, headerLength] = fread(fid, 1024, 'char=>char');
header = upper(header');
headerLength = getKeyVal(header, 'Data length', '%d', 0);

fseek(fid, 0, -1);
[header, headerLengthActual] = fread(fid, headerLength, 'char=>char');
header = upper(header');

end

function [keyVal] = getKeyVal(header, keyStr, formatStr, skipCount)


totalKeyStr = upper(['\', keyStr, ':']);
keyIndex = findstr(header, totalKeyStr);

if (length(keyIndex) <= skipCount)
    fprintf(1, 'cannot find key %s with skip count = %d, total key found = %d', totalKeyStr, skipCount, length(keyIndex));
    keyVal = 0;
else
    i = keyIndex(skipCount + 1);

    totalFormatStr = [upper(['\\', keyStr, ':']), formatStr];

    keyVal = sscanf(header(i:end), totalFormatStr);
end

end


function [TypeStr, softScaleKey, hardScale, hardValue] = getCiaoParm(header, keyStr, skipCount)

valid = 1;

totalKeyStr = upper(['\@', keyStr, ':']);
keyIndex = findstr(header, totalKeyStr);

if (length(keyIndex) <= skipCount)
    fprintf(1, 'cannot find key %s with skip count = %d, total key found = %d', totalKeyStr, skipCount, length(keyIndex));
    valid = 0;
else
    i = keyIndex(skipCount + 1) + length(totalKeyStr) + 1;
    % extract this one line from header
    lineEnd = findstr(header(i:end), '\') + i;
    if (length(lineEnd) == 0)
        valid = 0;
    end
    
    header = header(i:lineEnd(1) - 2);
    i = 1;
    
    TypeStr = header(i:i);
    
    i = i + 1;

    % find the softScaleKey [Sens. ZsensSens]
    keyStart = findstr(header(i:end), '[') + i;
    keyEnd = findstr(header(i:end), ']') + i;
    if ( (length(keyStart) == 0) | (length(keyEnd) == 0) )
        % no key available
        softScaleKey = '';
    else
        softScaleKey = header(keyStart(1):(keyEnd(1) - 2));
        i = keyEnd(1);
    end
        

    % find the hard scale (0.0003750000 V/LSB)
    keyStart = findstr(header(i:end), '(') + i;
    keyEnd = findstr(header(i:end), ')') + i;
    if ( (length(keyStart) == 0) | (length(keyEnd) == 0) )
        hardScale = 0;
    else
        hardScale = sscanf(header(keyStart(1):keyEnd(1)), '%f');
        i = keyEnd(1) + 1;
    end
        
    % find the hard value 0.452757 V
    hardValue = sscanf(header(i:end), '%f');

end

if (valid == 0)
    softScaleKey = '';
    hardScale = 0;
    hardValue = 0;
end

end