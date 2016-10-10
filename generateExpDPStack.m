expDPStack{1} = 'send_-75_grouped';
expDPStack{2} = 'send_-70_grouped';
expDPStack{3} = 'send_-65_grouped';
expDPStack{4} = 'send_-60_grouped';
expDPStack{5} = 'send_-55_grouped';
expDPStack{6} = 'send_-50_grouped';
expDPStack{7} = 'send_-45_grouped';
expDPStack{8} = 'send_-40_grouped';
expDPStack{9} = 'send_-35_grouped';
expDPStack{10} = 'send_-30_grouped';
expDPStack{11} = 'send_-25_grouped';
expDPStack{12} = 'send_-20_grouped';
expDPStack{13} = 'send_-15_grouped';
expDPStack{14} = 'send_-10_grouped';
expDPStack{15} = 'send_-5_grouped';
expDPStack{16} = 'send_+0_grouped';
expDPStack{17} = 'send_+5_grouped';
expDPStack{18} = 'send_+10_grouped';
expDPStack{19} = 'send_+15_grouped';
expDPStack{20} = 'send_+20_grouped';
expDPStack{21} = 'send_+25_grouped';
expDPStack{22} = 'send_+30_grouped';
expDPStack{23} = 'send_+35_grouped';
expDPStack{24} = 'send_+40_grouped';
expDPStack{25} = 'send_+45_grouped';
expDPStack{26} = 'send_+50_grouped';
expDPStack{27} = 'send_+55_grouped';
expDPStack{28} = 'send_+60_grouped';
expDPStack{29} = 'send_+65_grouped';
expDPStack{30} = 'send_+70_grouped';
expDPStack{31} = 'send_+75_grouped';


numProj = 31;
for i = 1:1:numProj
    pathName = 'send_data/021716FeMnSi/processing/';
    dm3FileName = strcat(pathName,expDPStack{i},'.dm3');
    expDpStack = readDMFilex86(dm3FileName,'Log.txt','imgStack');
    expMatrixGrouped = expDpStack.pureData;
    save(strcat(expDPStack{i},'.mat'),'expMatrixGrouped');
end

