function tileSeriesProcess()
gui=figure('Units','normalized','Position',[0.2,0.1,0.45,0.6],'MenuBar','none','Name','fixIndex','NumberTitle','off','Tag','mainUI','KeyPressFcn',@keyPress);
axes('Parent',gui,'Units','normalized','Position',[0.01,0.01,0.45,0.6],'Tag','indexMapDisplay','Visible','on');
axes('Parent',gui,'Units','normalized','Position',[0.50,0.01,0.45,0.6],'Tag','DPDisplay','Visible','on');
uicontrol('Parent',gui,'Style','pushbutton','String','Load DP database','FontSize',10,'Units','normalized','Position',[0.01,0.96,0.16,0.03],'Tag','loadDataBaseButton','Callback',@loadDataBaseButtonCB);
uicontrol('Parent',gui,'Style','pushbutton','String','Load corr image','FontSize',10,'Units','normalized','Position',[0.01,0.92,0.16,0.03],'Tag','loadCorrImgButton','Callback',@loadCorrImgButtonCB);
uicontrol('Parent',gui,'Style','pushbutton','String','Load index reslt','FontSize',10,'Units','normalized','Position',[0.01,0.88,0.16,0.03],'Tag','loadIndexResultButton','Callback',@loadIndexResultButtonCB);
uicontrol('Parent',gui,'Style','pushbutton','String','Load DP stack','FontSize',10,'Units','normalized','Position',[0.01,0.84,0.16,0.03],'Tag','loadDPStackButton','Callback',@loadDPStackButtonCB);
drawIndexMap = uicontrol('Parent',gui,'Style','pushbutton','String','Draw index map','FontSize',10,'Units','normalized','Position',[0.01,0.80,0.16,0.03],'Tag','drawIndexMapButton','Callback',@drawIndexMapButtonCB);
getDP = uicontrol('Parent',gui,'Style','pushbutton','String','Get DP','FontSize',12,'Units','normalized','Position',[0.01,0.70,0.16,0.05],'Tag','DPCursorButton','Callback',@DPCursorButtonCB);
setDP = uicontrol('Parent',gui,'Style','pushbutton','String','Set DP','FontSize',12,'Units','normalized','Position',[0.20,0.70,0.16,0.05],'Tag','setDPButton','Callback',@setDPButtonCB);
uicontrol('Parent',gui,'Style','pushbutton','String','Export fixed corr image','FontSize',12,'Units','normalized','Position',[0.01,0.64,0.30,0.05],'Tag','exportCorrImgButton','Callback',@exportCorrImgButtonCB);
uicontrol('Parent',gui,'Style','pushbutton','String','Line Shift Right','FontSize',12,'Units','normalized','Position',[0.40,0.70,0.16,0.05],'Tag','shiftRightButton','Callback',@shiftRightButtonCB);
uicontrol('Parent',gui,'Style','pushbutton','String','Line Shift Left','FontSize',12,'Units','normalized','Position',[0.60,0.70,0.16,0.05],'Tag','shiftLeftButton','Callback',@shiftLeftButtonCB);
uicontrol('Parent',gui,'Style','text','String','No database loaded.','FontSize',10,'Units','normalized','Position',[0.20,0.96,0.80,0.03],'Tag','isDatabaseText');
uicontrol('Parent',gui,'Style','text','String','No corr img loaded.','FontSize',10,'Units','normalized','Position',[0.20,0.92,0.80,0.03],'Tag','isCorrImgText');
uicontrol('Parent',gui,'Style','text','String','No index result loaded.','FontSize',10,'Units','normalized','Position',[0.20,0.88,0.80,0.03],'Tag','isIndexResultText');
uicontrol('Parent',gui,'Style','text','String','No DP stack loaded.','FontSize',10,'Units','normalized','Position',[0.20,0.84,0.80,0.03],'Tag','isDPStackText');
uicontrol('Parent',gui,'Style','text','String','','FontSize',10,'Units','normalized','Position',[0.50,0.65,0.40,0.04],'Tag','currDPinCorrText');
    function keyPress(src, eventdata)
        switch eventdata.Key
            case 'g'
                DPCursorButtonCB(getDP, []);
            case 's'
                setDPButtonCB(setDP, []);
            case 'd'
                drawIndexMapButtonCB(drawIndexMap, []);
        end
    end

handles=guihandles(gui);
guidata(gui,handles);
end


function loadDataBaseButtonCB(hObject,eventdata)
handles=guidata(gcbf);
[fileName, pathName] = uigetfile('*.mat', 'Open a DP database');
fullName = strcat(pathName,fileName);
load(fullName, 'patternDataMatrix');
handles.model.DPdatabase = patternDataMatrix;
set(handles.isDatabaseText,'String',fullName);
guidata(gcbf,handles);
end

function loadCorrImgButtonCB(hObject,eventdata)
handles = guidata(gcbf);
[fileName, pathName] = uigetfile('*.dm3', 'Open a correlation image');
fullName = strcat(pathName,fileName);
%acquire the width and height of the corr image
prompt = 'Please input the height of the correlation image';
answer = inputdlg(prompt);
height = str2num(answer{1});
prompt = 'Please input the width of the correlation image';
answer = inputdlg(prompt);
width = str2num(answer{1});
signalDetails=readDMFilex86(fullName,'Log.txt','img');
corrImg = signalDetails.pureData;
handles.model.corrImg = corrImg;
handles.model.corrImgHeight = height;
handles.model.corrImgWidth = width;
set(handles.isCorrImgText,'String',fullName);
guidata(gcbf,handles);

end

function loadIndexResultButtonCB(hObject, eventdata)
handles = guidata(gcbf);
[fileName, pathName] = uigetfile('*.txt', 'Open a index result file');
fullName = strcat(pathName,fileName);
prompt = 'What is the number of the DP patterns after correlation?';
answer = inputdlg(prompt);
numPattern = str2num(answer{1});
handles.model.numPattern = numPattern;
handles.model.patterns = extractUVW(fullName, numPattern, handles.model.DPdatabase);
set(handles.isIndexResultText,'String',fullName);
guidata(gcbf,handles);
end

function drawIndexMapButtonCB(hObject, eventdata)
handles = guidata(gcbf);
width = handles.model.corrImgWidth;
height = handles.model.corrImgHeight;
indexMap = zeros(width, height, 3);
for j = 1:1:height
    for k = 1:1:width
        patternOrder = handles.model.corrImg(j, k) + 1;%the order is offset by one
        u = handles.model.patterns(patternOrder, 5);
        v = handles.model.patterns(patternOrder, 6);
        w = handles.model.patterns(patternOrder, 7);
        if (u>-1 && v>-1 && w>-1)
            indexMap(k,j,:) = getRGB([u,v,w]);
        else
            indexMap(k,j,:) = [0,0,0];
        end
    end
end
imshow(indexMap,'Parent',handles.indexMapDisplay);
handles.model.indexMap = indexMap;
guidata(gcbf,handles);
end

function loadDPStackButtonCB(hObject, eventdata)
handles = guidata(gcbf);
[fileName, pathName] = uigetfile('*.dm3', 'Open a .dm3 DP stack');
fullName = strcat(pathName,fileName);
signalDetails=readDMFilex86(fullName,'Log.txt','imgStack');
handles.model.DPStack = signalDetails.pureData;
set(handles.isDPStackText,'String',fullName);
guidata(gcbf,handles);
end

function DPCursorButtonCB(hObject, eventdata)
handles = guidata(gcbf);
[currX,currY] = ginput(1);
currX = ceil(currX-0.5);
currY = ceil(currY-0.5);
display(currX);
display(currY);
DPOrder = uint16(currX+(currY-1)*handles.model.corrImgWidth);
currDP = handles.model.DPStack(:,:,DPOrder);
handles.model.currDPinCorr = handles.model.corrImg(currX, currY);
set(handles.currDPinCorrText,'String',sprintf('DP %d after grouping',handles.model.currDPinCorr));
%display the first image in the axe
sigma=std2(currDP);
average=mean2(currDP);
grayMin=average-3*sigma;grayMax=average+3*sigma;
currDisplay=mat2gray(currDP,[grayMin,grayMax]);
imshow(currDisplay,'Parent',handles.DPDisplay);
guidata(gcbf,handles);
end

function setDPButtonCB(hObject, eventdata)
handles = guidata(gcbf);
[currX,currY] = ginput(1);
currX = ceil(currX-0.5);
currY = ceil(currY-0.5);
handles.model.corrImg(currX, currY) = handles.model.currDPinCorr;
guidata(gcbf,handles);
end

function exportCorrImgButtonCB(hObject, eventdata)
handles = guidata(gcbf);
image = handles.model.corrImg;
uisave('image');
guidata(gcbf,handles);
end

function shiftRightButtonCB(hObject, eventdata)
handles = guidata(gcbf);
width = handles.model.corrImgWidth;
[currX,currY] = ginput(1);
currX = ceil(currX-0.5);
currY = ceil(currY-0.5);
shift_vector = zeros(1,width);
shift_vector(currY) = 1;%1 is downward, that is rightward for the transposed image
result = circshift_columns(handles.model.corrImg,shift_vector);
handles.model.corrImg = result;
guidata(gcbf,handles);
end

function shiftLeftButtonCB(hObject, eventdata)
handles = guidata(gcbf);
width = handles.model.corrImgWidth;
[currX,currY] = ginput(1);
currX = ceil(currX-0.5);
currY = ceil(currY-0.5);
shift_vector = zeros(1,width);
shift_vector(currY) = -1;%-1 is upward, that is leftward for the transposed image
result = circshift_columns(handles.model.corrImg,shift_vector);
handles.model.corrImg = result;
guidata(gcbf,handles);
end
