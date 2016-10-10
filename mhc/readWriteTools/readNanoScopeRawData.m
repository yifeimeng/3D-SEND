function rawData=readNanoScopeRawData(fileName)
%this method read the raw data from the NanoScope LSB file. The data is in
%2 byte interger type (int16)
%   Detailed explanation goes here
    
    fileID=fopen(fileName,'r');
    rawData=get_image_data(fileID);
    fclose(fileID);
    
end

    function Data = get_image_data(fileID)


    %scal_data = di_header_find(fileID,'\@2:Z scale: V [Sens.');
    pos_spl = di_header_find(fileID,'\Samps');
    pos_data = di_header_find(fileID,'\Data offset');
    file_type_data = di_header_find(fileID,'Image Data:');


    L = length(pos_data);

    %image_position = ones(1,L);

    fseek(fileID, pos_spl(1),-1);
    line = fgets(fileID);
    spl = extract_num(line);
    line = fgets(fileID);
    linno = extract_num(line);



    for i = 1:L 
       % figure
       fseek(fileID,pos_data(i),-1);
       line = fgets(fileID);
       imag_pos = extract_num(line);   

       %fseek(fileID,scal_data(i),-1);
       %line = fgets(fileID);
       %scaling = extract_num(line);   

       fseek(fileID,imag_pos,-1);
       A = fread(fileID, [spl linno],'int16');
       Data(:,:,i) = rot90(A);
       %image(Data(:,:,i));
       % fseek(fid,file_type_data(i),-1);
       % tl = fgetl(fid);
       % title(tl);
       % axis image;
    end

    end
    
    
    
    function position = di_header_find(fileID,find_string)

    % Define End of file identifier



    % Opend the file given in argument and reference as
    % fileID.  Also if there was an error output error
    % number and error message to screen

    header_end=0;
    eof = 0;
    counter = 1;


    byte_location = 0;


    while( and( ~eof, ~header_end ) )

       byte_location = ftell(fileID);
       line = fgets(fileID);


       if( (-1)==line )
          eof  = 1;
          break
       end


       if( ~isempty( strfind(line,find_string) ) )
          position(counter) = byte_location;
          counter = counter + 1;
       end


       if ~isempty( strfind( line, '\*File list end' ) )
          header_end = 1;
       end


    end
    
    frewind(fileID);

    end
    
       
    function val = extract_num(str)

    %Ascii table of relevant numbers
    %character    ascii code
    %  e          101
    %  E          69
    %  0          48
    %  1          49
    %  2          50
    %  3          51 
    %  4          52
    %  5          53
    %  6          54 
    %  7          55 
    %  8          56
    %  9          57

    eos = 0;
    R = str;

    while(~eos)
   
    [T,R] = strtok(str);
    if( length(R) == 0) eos = 1; end
    I = find( (T>=48) & (T<=57) | 101==T | 69==T | T==173 | T== 45 | T==46 | T==40);
  
       LT = length(T);
       LI = length(I);

       if( LI == LT )
          J = find(T~='(');
          val = str2num(T(J));
          break
       end
          str =R;
    end

    end
