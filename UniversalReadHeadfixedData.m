
function UniversalReadHeadfixedData
%% This function
% 1) gets a list of BOX stat files from headfixed traiing boxes
% 2) Reads in the BOX stat file
% 3) Reads in the LOG file of the same name
% 4) puts the data in a common variable called task;
% 5) the fields for the respective data are: task.boxData AND task.logData
% 6) Saves a single .mat file with this information in the same directory to facilitate data analysis
addpath(genpath('Y:\HamidLab Matlab General Scripts DO NOT MODIFY\Arif_General_scripts'))
currdir = cd;


files = dir('*BOXSTAT.txt');

for n = 1:length(files)

    BOXfilename = files(n).name;
    try;
        %             disp(['..........Working on.......... ' cfn(1:20)])
        MATFileTitle = [BOXfilename(1:end-12) 'UNIVERSAL.mat'];
        if ~isfile(MATFileTitle)

            do_one_file(BOXfilename)
            disp(['..........Completed..... ' BOXfilename(1:20)])
        else
            disp(['THIS FILE IS ALREADY DONE!!! ----> ' BOXfilename(1:20)])
        end
    catch %% there was an error
        try
            findFile = dir([BOXfilename(1:end-21) '*LOGFILE.txt']);
            LOGfilename = findFile.name;
            %
        end
    end

end

end
function do_one_file(BOXfilename)
MATFileTitle = [BOXfilename(1:end-12) 'UNIVERSAL.mat'];
BOXfileLevel = determine_Headfixed_logfileType (BOXfilename);
BOXfID = fopen(BOXfilename);

%Lvl - 0
DataTypeList{1} = 'Subject: %s Time: %s  TrialNum: %f TrialType: %s %s BlockNumber: %f  Reward: %f  ChoiceLeft: %f  ChoiceRight: %f  PressReq: %f  TimeInTrial: %f  BallPosition: %f  Position: %f  Loadcell: %f  Lick: %f  VRworld: %f  VRBall: %f';


%Lvl - 1
DataTypeList{2} = ' Subject: %s Time: %s  TrialNum: %f TrialType: %s %s BlockNumber: %f  Reward: %f  ChoiceLeft: %f  ChoiceRight: %f  PressReq: %f  TimeInTrial: %f  BallPosition: %f  Position: %f  Loadcell: %f  Lick: %f  VRworld: %f  VRBall: %f';


%Lvl - 2
DataTypeList{3} = 'Subject: %s Time: %s  TrialNum: %f TrialType: %s %s BlockNumber: %f  Reward: %f  ChoiceLeft: %f  ChoiceRight: %f  PressReq: %f  TimeInTrial: %f  BallPosition: %f  Position: %f  Loadcell: %f  Lick: %f  VRworld: %f  VRBall: %f';

%Lvl - 3
DataTypeList{4} = ' Subject: %s Time: %s  TrialNum: %f TrialType: %s BlockNumber: %f  Reward: %f  ChoiceLeft: %f  ChoiceRight: %f  PressReq: %f  TimeInTrial: %f  BallPosition: %f  Position: %f  Loadcell: %f  Lick: %f  VRworld: %f  VRBall: %f';

%Lvl - 4
DataTypeList{5} = 'Subject: %s Time: %s  TrialNum: %f TrialType: %s BlockNumber: %f  Reward: %f  ChoiceLeft: %f  ChoiceRight: %f  PressReq: %f  TimeInTrial: %f  BallPosition: %f  Position: %f  Loadcell: %f  Lick: %f  VRworld: %f  VRBall: %f';

%phtometry v1
DataTypeList{6} = 'Subject: %s Time: %s  TrialNum: %f TrialType: %s BlockNumber: %f  Reward: %f  ChoiceLeft: %f  ChoiceRight: %f  PressReq: %f  TimeInTrial: %f  BallPosition: %f  Position: %f  Loadcell: %f  Lick: %f  VRworld: %f  VRBall: %f Fluo_1: %f  Fluo_2: %f';


BOXcellarray = textscan(BOXfID, DataTypeList{BOXfileLevel+1}, 'MultipleDelimsAsOne',1); % DONT FORGET TO DECRIMENT LEVEL INDEX (no zero index in matlab)
fclose(BOXfID);
offset = {1,1,1,0,0}; %the last two levels dont have a space in Trial Type input

boxData.fn = BOXfilename;
boxData.TraininLevel = BOXfileLevel-1;
boxData.Subject = BOXcellarray{1};
boxData.Time = BOXcellarray{2};boxData.time_s = make_etime(boxData.Time);
boxData.TrialNum = double(BOXcellarray{3});
boxData.TrialType = [BOXcellarray{4}  ];
boxData.BlockNumber = double(BOXcellarray{5 + offset{BOXfileLevel+1}});
boxData.Reward = double(BOXcellarray{6 + offset{BOXfileLevel+1}});
boxData.ChoiceLeft = double(BOXcellarray{7 + offset{BOXfileLevel+1}});
boxData.ChoiceRight = double(BOXcellarray{8 + offset{BOXfileLevel+1}});
boxData.PressReq = double(BOXcellarray{9 + offset{BOXfileLevel+1}});
boxData.TimeInTrial = double(BOXcellarray{10 + offset{BOXfileLevel+1}});
boxData.BallPosition = double(BOXcellarray{11 + offset{BOXfileLevel+1}});
boxData.Position = double(BOXcellarray{12 + offset{BOXfileLevel+1}});
boxData.Loadcell = double(BOXcellarray{13 + offset{BOXfileLevel+1}});
boxData.Lick = double(BOXcellarray{14 + offset{BOXfileLevel+1}});
boxData.VRworld = double(BOXcellarray{15 + offset{BOXfileLevel+1}});
boxData.VRBall = double(BOXcellarray{16 + offset{BOXfileLevel+1}});


% clf;plot(boxData.BallPosition./4);hold on; plot(boxData.Lick);plot((scale_this(boxData.Loadcell)*5+5))

% LOGfilename = [BOXfilename(1:end-11) 'LOGFILE.txt'];
findFile = dir([BOXfilename(1:end-21) '*LOGFILE.txt']);
LOGfilename = findFile.name;
if BOXfileLevel==4
LOGfileFormat = 'Subject:%s Date:%s Time:%s Attempt: %f Trial:  %f Rewarded:  %f BlockNum:  %f BlockTrial:  %f LeftChoice: %f RightChoice: %f LatencyToLick:     %f LoadcellPressMag:%f LatencyToPressWheele:    %f CurrTrITI:  %f WheeleTurnDuration:     %f FailiureToPressWheele: %f LeftITI:     %f RightITI:     %f';
else
LOGfileFormat = 'Subject:%s Date:%s Time:%s Attempt: %f Trial:  %f Rewarded:  %f BlockNum:  %f BlockTrial:  %f LeftChoice: %f RightChoice %f LatencyToLick:     %f LoadcellPressMag:%f LatencyToPressWheele:    %f CurrTrITI:  %f WheeleTurnDuration:     %f FailiureToPressWheele: %f LeftITI:     %f RightITI:     %f';
end
LOGfID = fopen(LOGfilename);
LOGcellarray = textscan(LOGfID, LOGfileFormat, 'MultipleDelimsAsOne',1) ;
fclose(LOGfID);

logData.fn = LOGfilename;
logData.TraininLevel = BOXfileLevel-1;
logData.Subject = LOGcellarray{1};
logData.Date = LOGcellarray{2};
logData.Time = LOGcellarray{3};
logData.Attempt = double(LOGcellarray{4});
logData.Trial = double(LOGcellarray{5});
logData.Rewarded = double(LOGcellarray{6});
logData.BlockNum = double(LOGcellarray{7});
logData.BlockTrial = double(LOGcellarray{8});
logData.LeftChoice = double(LOGcellarray{9});
logData.RightChoice = double(LOGcellarray{10});
logData.LatencytoLick = double(LOGcellarray{11});
logData.LoadcellPressMag = double(LOGcellarray{12});
logData.LatencyToPress = double(LOGcellarray{13});
logData.CurrTrITI = double(LOGcellarray{14});
logData.WheeleTurnDuration = double(LOGcellarray{15});
logData.FailiureToPress = double(LOGcellarray{16});
logData.LeftITI = double(LOGcellarray{17});
logData.RightITI = double(LOGcellarray{18});

task.boxData = boxData;
task.logData = logData;


if max(task.logData.Trial)>30

    save(MATFileTitle, 'logData','boxData')

else
    movefile (BOXfilename,[currdir '\Can not do\'])
    movefile(LOGfilename,[currdir '\Can not do\'])
end

end


%% supplemental file to determine what level this is
%

function logfileLevel = determine_Headfixed_logfileType (filename)

lvl = {'Lv 0','Lv 1','Lv 2','Lv3','Lv4'};

for c_lvl = 1:5
    typ(c_lvl) = contains(filename,lvl{c_lvl});
end
logfileLevel = find(typ==1,1,'first')-1;

end

