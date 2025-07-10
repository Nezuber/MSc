function os2401(varargin)
%Main program to run the experiment. Expects as input: Sub,GrTp,Task
expdriver(varargin{:});
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%% Positions where you most likely have to change something are marked
%% with: CHANGEHERE
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PrintUsage()
%Settings:
epar = expSettings;

%%CHANGEHERE

%%%Balanced condition and task order using groups

fprintf('--------------------------------------------------\n')
fprintf(['USAGE: ',epar.ExpName,' SubNo Group Task\n']); 
fprintf('\n')
fprintf('   PGM-LS\n')
fprintf('   PMG-LS\n')
fprintf('   MPG-LS\n')
fprintf('   MGP-LS\n')
fprintf('   GPM-LS\n')
fprintf('   GMP-LS\n')
fprintf('   PGM-SL\n')
fprintf('   PMG-SL\n')
fprintf('   MPG-SL\n')
fprintf('   MGP-SL\n')
fprintf('   GPM-SL\n')
fprintf('   GMP-SL\n')
fprintf('   P=perceptual judgement task\n')
fprintf('   G=grasping task\n')
fprintf('   M=manual estimation\n')
fprintf('   S=perceptual judgement asking for "small"\n')
fprintf('   L=perceptual judgement asking for "large"\n')
fprintf('and Task being: \n')
fprintf('   ManEst\n') 
fprintf('   Grasp\n')  
fprintf('   Perc\n') 
fprintf('--------------------------------------------------\n')
fprintf('\n')


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function CheckTaskAndMaybeCreateIt(Sub,Task)
%Check whether the task is correct. If it is correct, then: 

% - If no calibration is needed, then create the task.
% - Otherwise create the task in a special calibration program. 

%CHANGEHERE

%Settings:
epar     = expSettings;
SubFiles = expSubFileNames(Task,Sub);

%Valid task?
if(~strcmp(Task,'ManEst') && ~strcmp(Task,'Perc') && ~strcmp(Task,'Grasp'))
  PrintUsage;
  error('Wrong task')
end

%Recalibrate the coordinates if not test-run:   
if Sub ~= 999
    if ~strcmp(Task,'Perc')
      fprintf('We recalibrate the coordinates...\n')
      calibcoor
      fprintf('Done with calibrating the coordinates!!!\n')
      fprintf('----------------------------------------------------------------------\n')
    end
end

%No calibration needed:
if(strcmp(Task,'ManEst') || strcmp(Task,'Perc') || strcmp(Task,'Grasp'))
  %Create task:
  expCreateTaskForSubject(Sub,Task) 
  %Copy position file to subject's directory and load it:
  copyfile(epar.GeneralPosFile,SubFiles.PosFile)
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function CheckGrTp(epar)
%%CHANGEHERE
if( ~strcmp(epar.GrTp,'PGM-LS') && ~strcmp(epar.GrTp,'PMG-LS')...
        && ~strcmp(epar.GrTp,'MPG-LS') && ~strcmp(epar.GrTp,'MGP-LS')...
        && ~strcmp(epar.GrTp,'GPM-LS') && ~strcmp(epar.GrTp,'GMP-LS')...
        && ~strcmp(epar.GrTp,'PGM-SL') && ~strcmp(epar.GrTp,'PMG-SL')...
        && ~strcmp(epar.GrTp,'MPG-SL') && ~strcmp(epar.GrTp,'MGP-SL')...
        && ~strcmp(epar.GrTp,'GPM-SL') && ~strcmp(epar.GrTp,'GMP-SL'))
  PrintUsage;
  error('... you specified the wrong group type')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function epar=SetBlTpVector(epar)

if(epar.Sub==999)
  %No practise trials for test-runs:
  if(strcmp(epar.Task,'ManEst')) 
    epar.BlTpVector=['M']; 
  elseif(strcmp(epar.Task,'Perc')) 
      epar.BlTpVector=['P-L'
                       'P-S'];
  elseif(strcmp(epar.Task,'Grasp')) 
      epar.BlTpVector=['G'];
  else
    error('Wrong task')
  end
else
    if(contains(epar.GrTp,'P') && contains(epar.GrTp,'G') && contains(epar.GrTp,'M') && contains(epar.GrTp,'LS'))
        if(strcmp(epar.Task,'ManEst')) 
            epar.BlTpVector=['M-Prac'
                             'M-1   '
                             'M-2   '
                             'M-3   '
                             'M-4   ']; 
            
        elseif(strcmp(epar.Task,'Perc')) 
            epar.BlTpVector=['P-L-Prac'
                             'P-L1    '
                             'P-L2    '
                             'P-S-Prac'
                             'P-S1    '
                             'P-S2    '];
        elseif(strcmp(epar.Task,'Grasp')) 
            epar.BlTpVector=['G-Prac'
                             'G-1   '
                             'G-2   '
                             'G-3   '
                             'G-4   '];
        end
    elseif(contains(epar.GrTp,'P') && contains(epar.GrTp,'G') && contains(epar.GrTp,'M') && contains(epar.GrTp,'SL'))
        if(strcmp(epar.Task,'ManEst')) 
            epar.BlTpVector=['M-Prac'
                             'M-1   '
                             'M-2   '
                             'M-3   '
                             'M-4   ']; 
        elseif(strcmp(epar.Task,'Perc')) 
            epar.BlTpVector=['P-S-Prac'
                             'P-S1    '
                             'P-S2    '
                             'P-L-Prac'
                             'P-L1    '
                             'P-L2    '];
        elseif(strcmp(epar.Task,'Grasp')) 
            epar.BlTpVector=['G-Prac'
                             'G-1   '
                             'G-2   '
                             'G-3   '
                             'G-4   '];
        end
    else
        error('Wrong task')
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=SetTrTpVector(epar)

%%CHANGEHERE
% D1 = 40mm
% D2 = 40.5mm
% A/B 2nd version of disk

ptrials  = 4; % for 32trials (128 total) do 4 (half S, half L)
gmtrials = 8; % for 32trials (128 total) do 8

pTrTpVector = char('R:D1A-L:D2A','R:D1A-L:D2B',...
                   'R:D1B-L:D2A','R:D1B-L:D2B',...
                   'R:D2A-L:D1A','R:D2A-L:D1B',...
                   'R:D2B-L:D1A','R:D2B-L:D1B');
gmTrTpVector=char('D1A',...
                   'D1B',...
                   'D2A',...                       
                   'D2B');
               
if(strfind(epar.BlTp,'Prac'))
    if(strfind(epar.BlTp,'L'))
        epar.TrTpVector=exputil_IncreaseTpVector(1,pTrTpVector);
    elseif(strfind(epar.BlTp,'S'))
        epar.TrTpVector=exputil_IncreaseTpVector(1,pTrTpVector);
    else
        epar.TrTpVector=exputil_IncreaseTpVector(3,gmTrTpVector); 
    end
else  
  if(strfind(epar.BlTp,'P-L'))  
    epar.TrTpVector=exputil_IncreaseTpVector(ptrials,pTrTpVector);
  elseif(strfind(epar.BlTp,'P-S'))
    epar.TrTpVector=exputil_IncreaseTpVector(ptrials,pTrTpVector);
  elseif(strfind(epar.BlTp,'G'))
    epar.TrTpVector=exputil_IncreaseTpVector(gmtrials,gmTrTpVector);
  elseif(strfind(epar.BlTp,'M'))
    epar.TrTpVector=exputil_IncreaseTpVector(gmtrials,gmTrTpVector);
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=DoAtBeginningOfExpAndProceeding(epar)

%Open data-translation DT9812 USB module

daq.getDevices
DIO = daq.createSession('dt');

epar.DIO = DIO;

addDigitalChannel(epar.DIO,'DT9812(00)','port0/line0','InputOnly');%left       
addDigitalChannel(epar.DIO,'DT9812(00)','port0/line1','InputOnly');%right

%goggles left eye
addDigitalChannel(epar.DIO,'DT9812(00)','port0/line7','OutputOnly');
%goggles right eye
addDigitalChannel(epar.DIO,'DT9812(00)','port0/line0','OutputOnly');

closeGoggles(epar);

%Make keys fairly independent of operating system (Windows/Mac):
KbName('UnifyKeyNames');

%Open figure before PsychToolbox grasps mouse pointer: 
if(strcmp(epar.Task,'ManEst'))
  fprintf('\nIs the active figure placed correctly?:\n');
  a=ask_and_get_answerchar('y=yes; o=open new figure; q=quit) ','yoq');
  if a=='o'
    close all
    figure
    fprintf('Please adjust the figure and proceed with RETURN\n');
    pause
  elseif a=='q'
    error('You are quitting, successfully, IGNORE THIS ERROR MESSAGE!!!');
  end
  clc
  pause(0.1)%DELAY!!! Needed for clc :-(
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=DoAtBeginningOfExp(epar)
%count the errors per task (P/G/M): Use containers. Map for a
%dictionary-like structure (dictionaries are only support since MatLab
%version R2022b.
%Use explicit types

epar.errorCount = containers.Map('KeyType','char','ValueType','uint32'); 
epar.errorCount('P') = 0;
epar.errorCount('G') = 0;
epar.errorCount('M') = 0;

openGoggles(epar);

%Handle subject files: 
SubFiles=expSubFileNames(epar.Task,epar.Sub);
if(strcmp(epar.Task,'Grasp') || strcmp(epar.Task,'ManEst'))
  %Get positions:
  load(SubFiles.PosFile);
  epar.RightStartPos=RightStartPos;
  epar.RightGoalPos =RightGoalPos;
  %%Start Optotrak:
  fprintf('Starting Optotrak...\n')
  expStartOptotrak(epar.Sub,epar.Task);
  drawInstructions(epar.Task);
elseif(strcmp(epar.Task,'Perc'))
  drawInstructions(epar.Task);
  fprintf('Please keep fingers of right hand on buttons...\n')
else
   error(['Wrong task (',epar.Task,')'])
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=DoAtBeginningOfProceeding(epar)

SubFiles=expSubFileNames(epar.Task,epar.Sub,epar.Trial);
disp(SubFiles)
if(strcmp(epar.Task,'ManEst') || strcmp(epar.Task,'Grasp'))
  %%Remove datafiles of this trial if they exist:
  deleteSilently(SubFiles.RawFile  );
  deleteSilently(SubFiles.PC3DFile );
  deleteSilently(SubFiles.MatFile  );
  %%Start Optotrak:
  fprintf('Starting Optotrak...\n')
  expStartOptotrak(epar.Sub,epar.Task);
elseif(strcmp(epar.Task,'Perc'))
    %%Remove datafiles of this trial if they exist:
 	deleteSilently(SubFiles.MatFile  );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=DoAtBeginningOfBlock(epar)
openGoggles(epar);
fprintf('----------------------------------------------------------------------\n');
fprintf('                   New block: %s\n\n',epar.BlTp);
fprintf('                                               ...proceed with RETURN!\n');
fprintf('----------------------------------------------------------------------\n');
drawRepInstructions(epar.BlTp);
drawVirtualEnv(epar.Task, epar.BlTp);
closeGoggles(epar);
pause

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function epar=DoAtEndOfBlock(epar)
 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function epar=DoAtEndOfTask(epar)

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function epar=DoAtEndOfExperiment(epar)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function DoAtExit(epar)
sca; %clear virtual env screen
%Stop Optotrak:
if(strcmp(epar.Task,'ManEst') || strcmp(epar.Task,'Grasp'))
  optostop;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=DoTrial(epar)

if(strcmp(epar.Task,'ManEst')||strcmp(epar.Task,'Grasp')) 
    epar=doGraspOrManEstTrial(epar);
elseif(strcmp(epar.Task,'Perc')) 
    epar=DoPercTrial(epar);
else
  error('Wrong task');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=DoPercTrial(epar)
    TooEarly=false;
    PercError=false;
    SaveTrial=true;
    epar.TimeMeasure=struct();
    epar.PercEst=struct();

    clf; 
    exputil_clcWithTrialInfo(epar);
    a=ptb_ask_and_get_answerchar('Please prepare trial and then proceed with * (q=quit) ','*q',true);
    if a=='q'
      DoAtExit(epar);
      error('You are quitting, successfully, IGNORE THIS ERROR MESSAGE!!!');
    end
    clc
    pause(0)%Needed for clc
    SubFiles=expSubFileNames_orig(epar.Task,epar.Sub,epar.Trial);
    fprintf('... running trial!\n')

    TimeatTrialStart = GetSecs;
    openGoggles(epar);

    while(1)
       TrialTimer=GetSecs;
  
       if (TrialTimer-TimeatTrialStart)>epar.PresentationTime
           fprintf('Took too long to respond! Trial marked as error.\n ');
           closeGoggles(epar);
           PercError=true;
           fprintf('Proceed with RETURN...\n')
           pause
           break
       end
       currstatus=inputSingleScan(epar.DIO);
       if(currstatus(epar.leftKeyIndex)==0||currstatus(epar.rightKeyIndex)==0)
            TimeatButtonPress=GetSecs;
            fprintf('Pressed PercEst button!!!\n');
            closeGoggles(epar);
            epar.TimeMeasure.PercTime=TimeatButtonPress-TimeatTrialStart;
            
            fprintf('\nBlock: ');
            fprintf(epar.BlTp);
            
            fprintf('\nTrial: ');
            fprintf(epar.TrTp);
                        
            correctness = '';
            if(currstatus(epar.leftKeyIndex)==0)
                epar.PercEst.Resp = 'SubjLeft';
                if(contains(epar.BlTp,'S') && contains(epar.TrTp,'R:D2') && contains(epar.TrTp,'L:D1'))
                    correctness = 'C';
                elseif(contains(epar.BlTp,'S') && contains(epar.TrTp,'R:D1') && contains(epar.TrTp,'L:D2'))
                    correctness = 'F';
                elseif(contains(epar.BlTp,'L') && contains(epar.TrTp,'R:D2') && contains(epar.TrTp,'L:D1'))
                    correctness = 'F';
                elseif(contains(epar.BlTp,'L') && contains(epar.TrTp,'R:D1') && contains(epar.TrTp,'L:D2'))
                    correctness = 'C';
                else
                    fprintf('Something very wrong!! Stop experiment and fix/ask for help!\n');               
                end
                epar.PercEst.Corr = correctness;
            elseif(currstatus(epar.rightKeyIndex)==0)
                epar.PercEst.Resp = 'SubjRight';  
                if(contains(epar.BlTp,'S') && contains(epar.TrTp,'R:D2') && contains(epar.TrTp,'L:D1'))
                    correctness = 'F';
                elseif(contains(epar.BlTp,'S') && contains(epar.TrTp,'R:D1') && contains(epar.TrTp,'L:D2'))
                    correctness = 'C';
                elseif(contains(epar.BlTp,'L') && contains(epar.TrTp,'R:D2') && contains(epar.TrTp,'L:D1'))
                    correctness = 'C';
                elseif(contains(epar.BlTp,'L') && contains(epar.TrTp,'R:D1') && contains(epar.TrTp,'L:D2'))
                    correctness = 'F';
                else
                    fprintf('Something very wrong!! Stop experiment and fix/ask for help!\n');               
                end
                epar.PercEst.Corr = correctness;
            end
        break
       end
    end

    %Automatic check for errors:
    if(TooEarly)      
        PercError=true; 
    end
    
    fprintf('\n');
    fprintf('\n');
    if ~PercError
        a=ptb_ask_and_get_answerchar('Trial correct or error? (+-) ','+-');
        if(a=='-') 
            PercError=true; 
        end
    end

    %Evaluate possible errors:
    if(PercError)
      SaveTrial=false;
      
      %Increase error counter
      block = extractBefore(epar.BlTp,'-');
      if(~contains(epar.BlTp,'Prac') && epar.Sub ~= 999)
        epar.errorCount(block) = epar.errorCount(block) + 1;
      end
    
      clc
      pause(0)%Needed for clc :-(
      fprintf('Trial classified as error!\n')
      if(TooEarly)                ,fprintf('  Response was too early\n')     , end
      fprintf('Trial will be repeated...\n')
      fprintf('\n\nFailed trial: %s\n\n\n',epar.TrTp)
      fprintf('Proceed with RETURN...\n')
      pause
    else  
      epar.TrTpVector=epar.TrTpVector(2:end,:);
      if strfind(epar.BlTp,'Prac')
        SaveTrial=false;
      end
    end

    if SaveTrial
      epar.Trial=epar.Trial+1;
    else
      deleteSilently(SubFiles.MatFile);
    end
    
    savePercFiles(SubFiles,epar);
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function savePercFiles(SubFiles,epar)
    GrTp =epar.GrTp;
    BlTp =epar.BlTp;
    TrTp =epar.TrTp;
    errorCount = epar.errorCount;
    TimeMeasure=epar.TimeMeasure;
    PercEst = epar.PercEst;
    save(SubFiles.MatFile,'GrTp','BlTp','TrTp','errorCount','TimeMeasure','PercEst','-mat');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=doGraspOrManEstTrial(epar)

FirstRun=true;
TooEarly=false;
StartedGrip=false;
ReachedDiscBeforeManEst=false;
ReachedDisc=false;
LeftDiscArea=false;
ManEstimated=false;
GraspError=false;
SaveTrial=true;
epar.TimeMeasure=struct();
%epar.ManEstResp=struct();


%ManEst or Grasp trial?
if(strcmp(epar.Task,'ManEst')) 
    ManEst=true;
else
    ManEst=false;
end

%Prepare spooling:
SubFiles=expSubFileNames(epar.Task,epar.Sub,epar.Trial);

%Check if files already exist:
if(~contains(epar.BlTp,'Prac') && epar.Sub ~= 999 && ~epar.FirstTrialOfProceeding)
  exputil_FileShouldNotExist(SubFiles.RawFile);
  exputil_FileShouldNotExist(SubFiles.PC3DFile);
  exputil_FileShouldNotExist(SubFiles.MatFile);
end

%Prepare Optotrak:
optotrak('DataBufferInitializeFile',{'OPTOTRAK'},SubFiles.RawFile);
         
%Check resting position:
checkRestingPosition(epar);

%Display Info, clear figure and wait for signal to start:
clf;
exputil_clcWithTrialInfo(epar);
a=ptb_ask_and_get_answerchar('Please prepare trial and then proceed with * (q=quit) ','*q',true);
if a=='q'
  DoAtExit(epar);
  error('You are quitting, successfully, IGNORE THIS ERROR MESSAGE!!!');
end
clc
pause(0)%Needed for clc :-(
fprintf('... running trial!\n')

%Open goggles and present stimuli for presentation time:
[~,epar.TimeMeasure.OpenGogglesBEFORE,~] = KbCheck;
openGoggles(epar);
[~,epar.TimeMeasure.OpenGogglesAFTER ,~] = KbCheck;

%Start spooling:
[~,epar.TimeMeasure.StartSpoolingBEFORE,~] = KbCheck;
optotrak('DataBufferStart')
[~,epar.TimeMeasure.StartSpoolingAFTER ,~] = KbCheck;

%Spool:
SpoolComplete=0;
TimeatTrialStart = GetSecs;
while(~SpoolComplete)
  %Write data if there is any to write.
  [~,SpoolComplete,SpoolStatus,~]=...
      optotrak('DataBufferWriteData');
  
  %Check grip status:
   odata=optotrak('DataGetNext3D',epar.ExpColl.NumMarkers);   
   
   currstatus=inputSingleScan(epar.DIO);
   
   odataTimeAFTER = GetSecs;
   
   if(FirstRun)
    FirstRun=false;
   end
  
  if(~TooEarly && ...
     1000*(odataTimeAFTER-epar.TimeMeasure.StartSpoolingAFTER) < epar.TooEarlyTime && ...
     oneFingerFarFrom(epar.RightStartPos,epar.StartPosTolerance,odata,epar))
    TooEarly=true;
  end
  
  if(~StartedGrip && ...
    oneFingerFarFrom(epar.RightStartPos,epar.StartPosTolerance,odata,epar))
    StartedGrip=true;
  end
  
  if(ManEst && ~ManEstimated && ...
     ~ReachedDiscBeforeManEst && ...
     StartedGrip  && ...
     oneFingerCloseTo(epar.RightGoalPos,epar.GoalPosTolerance,odata,epar))
        fprintf('Reached disc before ManEst!!!\n');
        ReachedDiscBeforeManEst=true;
  end
      
  if(~ManEst || (ManEst && ManEstimated))
      if(~ReachedDisc && ...
         StartedGrip  && ...
         oneFingerCloseTo(epar.RightGoalPos,epar.GoalPosTolerance,odata,epar))
        fprintf('Reached disc!!!\n');
        ReachedDisc=true;
      end

      if(~LeftDiscArea && ...
         ReachedDisc && ...
         allFingersFarFrom(epar.RightGoalPos,epar.GoalPosTolerance,odata,epar))
        LeftDiscAreaTime = GetSecs;
        fprintf('Left disc area!!!\n');
        LeftDiscArea=true;
        epar.TimeMeasure.LeftDiscAreaTime = LeftDiscAreaTime-TimeatTrialStart;
      end
  end
  
  if(ManEst && ~ManEstimated && StartedGrip)
        if(currstatus(epar.leftKeyIndex)==0||currstatus(epar.rightKeyIndex)==0)
            ManEstTime = GetSecs;
            fprintf('Pressed ManEst button!!!\n'); 
            ManEstimated=true;
            epar.TimeMeasure.ManEstimatedAFTER=ManEstTime-TimeatTrialStart;
        end
  end
end

if SpoolStatus~=0 
    GraspError=true; 
end

% close goggles after trial
closeGoggles(epar); 

%Convert & save existing Optotrak data-files:
saveOptoFiles(epar,SubFiles);

%Plot data:
fprintf('Plotting:\n');
try
  clf
  util_plot(epar.Sub,epar.Task,epar.Trial)
  pause(0.5)
catch
  disp('----------------------------------------------------------------------')
  disp('Problems with the evaluation. Please do: ')
  disp(' - mark trial as error trial')
  disp(' - after finishing the experiment, tell Volker about it...')
end
fprintf('----------------------------------------------------------------------\n');
fprintf('\n');

%Automatic check for errors:
if(TooEarly)      
    GraspError=true; 
end
if(~LeftDiscArea) 
    GraspError=true; 
end
if(~StartedGrip)  
    GraspError=true; 
end

if(ManEst && ~ManEstimated) 
    GraspError=true;  
end

if(ReachedDiscBeforeManEst)
    GraspError=true;
end

%If no error sofar, then ask experimenter:
if(~GraspError)
  if ManEst
    fprintf('\n');
    fprintf('Check: \n');
    fprintf('   - ''normal'' manual estimation?\n');
    fprintf('   - aperture no missing data?\n');
    fprintf('   - velocity criterion ok?\n');
    a=ptb_ask_and_get_answerchar('Trial correct or error? (+-) ','+-');
    if(a=='-') 
        GraspError=true; 
    end
  else
    fprintf('\n');
    fprintf('Check: \n');
    fprintf('   - ''normal'' grasp?\n');
    fprintf('   - aperture no missing data?\n');
    fprintf('   - velocity criterion ok?\n');
    a=ptb_ask_and_get_answerchar('Trial correct or error? (+-) ','+-');
    if(a=='-') 
        GraspError=true; 
    end
  end 
end

%Evaluate possible errors:
if(GraspError)
  SaveTrial=false;
  
  %Increase error counter
  block = extractBefore(epar.BlTp,'-');
  if(~contains(epar.BlTp,'Prac') && epar.Sub ~= 999)
      epar.errorCount(block) = epar.errorCount(block) + 1;
  end
  
  clc
  pause(0)%Needed for clc :-(
  fprintf('Trial classified as error:\n')
  if(TooEarly)                ,fprintf('  Response was too early\n')     , end
  if(~StartedGrip)            ,fprintf('  Did not start grip/man-est\n') , end
  if(ReachedDiscBeforeManEst) ,fprintf('  Grasped disk before ManEst\n') , end
  if( ManEst && ~ManEstimated),fprintf('  Did not press ManEst-Button\n'), end
  if(~ReachedDisc)            ,fprintf('  Did not reach disc\n')         , end
  if(~LeftDiscArea)           ,fprintf('  Did not leave disc area\n')    , end
  if(SpoolStatus~=0)          ,fprintf('  Problems with data spooling')  , end
  fprintf('Trial will be repeated...\n')
  fprintf('\n\nFailed trial: %s\n\n\n',epar.TrTp)
  fprintf('Proceed with RETURN...\n')
  pause
  
else  
  epar.TrTpVector=epar.TrTpVector(2:end,:);
  if contains(epar.BlTp,'Prac')
    SaveTrial=false;
  end
end

if SaveTrial
  epar.Trial=epar.Trial+1;
else
  deleteSilently(SubFiles.MatFile  );
  deleteSilently(SubFiles.RawFile  );
  deleteSilently(SubFiles.PC3DFile );
 
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function saveOptoFiles(epar,SubFiles)
%Note: If there is an error in the trial, these files will be removed again!

fprintf('\n');
fprintf('----------------------------------------------------------------------\n');
fprintf('saveOptoFiles:\n');

%Convert and save data: 
fprintf('----------------------------------------------------------------------\n');
fprintf('Converting:  %s -> %s\n',SubFiles.RawFile,SubFiles.PC3DFile);
optotrak('FileConvert',SubFiles.RawFile,SubFiles.PC3DFile,{'OPTOTRAK_RAW'});

%Read to Matlab...:
fprintf('Converting:  %s -> %s\n',SubFiles.PC3DFile,SubFiles.MatFile);
odata=optotrak('Read3DFileToMatlab',SubFiles.PC3DFile);

%...and save as MAT file with all relevant paramters:
%%CHANGEHERE
%Goggles conditions: FV, OL etc.
GrTp =epar.GrTp;
BlTp =epar.BlTp;
TrTp =epar.TrTp;
errorCount = epar.errorCount;
TimeMeasure=epar.TimeMeasure;
if(contains(epar.Task,'ManEst'))
    save(SubFiles.MatFile,'odata','GrTp','BlTp','TrTp','errorCount','TimeMeasure','-mat');
else
    save(SubFiles.MatFile,'odata','GrTp','BlTp','TrTp','errorCount','TimeMeasure','-mat');
end

%Delete raw optotrak and PC3D-files if everything seems OK:
if(exist(SubFiles.PC3DFile,'file') && exist(SubFiles.MatFile,'file'))
  deleteSilently(SubFiles.RawFile  );
  deleteSilently(SubFiles.PC3DFile );
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Utility functions (typically need not be changed):

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function openGoggles(epar)
outputSingleScan(epar.DIO,[0,0]);%open
% putvalue(DIO.Line(leftEye ),0);
% putvalue(DIO.Line(rightEye),0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function closeGoggles(epar)
outputSingleScan(epar.DIO,[1,1]);%close 

% putvalue(DIO.Line(leftEye),1);
% putvalue(DIO.Line(rightEye),1);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res=oneFingerFarFrom(RightPos,Tolerance,odata,epar)
if( norm(odata.Markers{epar.RightThumb.Marker}  - RightPos) > Tolerance || ...
    norm(odata.Markers{epar.RightFinger.Marker} - RightPos) > Tolerance )
  res=true;
else
  res=false;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res=oneFingerCloseTo(RightPos,Tolerance,odata,epar)
if( norm(odata.Markers{epar.RightThumb.Marker}  - RightPos) < Tolerance || ...
    norm(odata.Markers{epar.RightFinger.Marker} - RightPos) < Tolerance )
  res=true;
else
  res=false;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res=allFingersFarFrom(RightPos,Tolerance,odata,epar)
if( norm(odata.Markers{epar.RightThumb.Marker}  - RightPos) > Tolerance && ...
    norm(odata.Markers{epar.RightFinger.Marker} - RightPos) > Tolerance )
  res=true;
else
  res=false;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function res=allFingersCloseTo(RightPos,Tolerance,odata,epar)
if( norm(odata.Markers{epar.RightThumb.Marker}  - RightPos) < Tolerance && ...
    norm(odata.Markers{epar.RightFinger.Marker} - RightPos) < Tolerance )
  res=true;
else
  res=false;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=checkRestingPosition(epar)

done=false;
while ~done
  odata=optotrak('DataGetNext3D',epar.ExpColl.NumMarkers);
  if(allFingersCloseTo(epar.RightStartPos,epar.StartPosTolerance,odata,epar))
    done=true;
  else
    clc
    fprintf('Subject should put Fingers in resting position! (q=quit)\n');
    fprintf('   right thumb  deviation: %5.2f\n',norm(odata.Markers{epar.RightThumb.Marker}  - epar.RightStartPos));
    fprintf('   right finger deviation: %5.2f\n',norm(odata.Markers{epar.RightFinger.Marker} - epar.RightStartPos));
    [~,~,keyCode] = KbCheck;
    if keyCode(KbName('q'))
      FlushEvents('keyDown'); %discard chars from event queue.
      DoAtExit(epar);
      error('You are quitting, successfully, IGNORE THIS ERROR MESSAGE!!!');
    end
    pause(0.2)
  end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function deleteSilently(filename)
%Delete a file without giving any distracting warning-messages if it
%doesn't exist or if it is locked. We need to do this the UNIX-way:
% disp(exist(filename ,'file')) 
% disp(filename)
system(['bash -c "rm -f ',filename,' > /dev/null 2>&1" ']);
% 
% Windows version of silent delete. 
% del filename deletes the thing and the output is directed to nul (first
% >) and warning messages are directed to nul as well (thats 2>).

% system(['del ',filename,' > nul 2> nul']);


%NOTE: The Matlab built-in command "delete" gives all kinds of warnings 
%that distract. Even a construction like: 
%
% if(exist(filename ,'file')) 
%     delete(filename); 
% end
%
%... does not help!

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function exputil_clcWithTrialInfo(epar)
clc
pause(0.1)%DELAY!!! Needed for clc :-(
fprintf('GrTp: %s\n',epar.GrTp);
fprintf('Block: %s ',epar.BlTp);
fprintf('Trial number: %i\n',epar.Trial);
fprintf('\n\nTrial: %s\n\n\n',epar.TrTp);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Experiment driver functions (typically need not be changed):

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function expdriver(Sub,GrTp,Task)

%Handle input:
if nargin~=3
  PrintUsage;
  error('Input must be: Sub,GrTp,Task')
end
if ischar(Sub) 
    Sub=str2double(Sub); 
end
if ~ischar(Task) 
    error('Task must be a string'); 
end

%Set random number generator to arbitrary state: 
% rng('default')
rand('state',sum(100*clock))
%Clear functions from cache (e.g., PsychToolbox; to prevent crashes):
clear functions

%Check task and maybe create the task for this subject:
CheckTaskAndMaybeCreateIt(Sub,Task);

%Get settings:
if expdriver_AreWeProceeding(Sub,Task)
  %Get settings:
  SubFiles=expSubFileNames(Task,Sub);
  load(SubFiles.StatusFile) 
  epar.FirstTrialOfProceeding=true;
  %Check command-line for consistency:
  if epar.Sub~=Sub           
      error(['Sub  not consistent with status file:',epar.Sub]); 
  end
  if ~strcmp(epar.GrTp,GrTp) 
      error(['GrTp not consistent with status file:',epar.GrTp]); 
  end
  if ~strcmp(epar.Task,Task) 
      error(['Task not consistent with status file:',epar.Task]); 
  end
  drawVirtualEnv(epar.Task,epar.BlTp)
else
  %Get settings:
  epar=expSettings; 
  epar.FirstTrialOfProceeding=false;
  %Evaluate and check command-line:
  epar.Sub   = Sub;
  epar.GrTp  = GrTp;
  epar.Task  = Task;
  CheckGrTp(epar);
end

%If using the catch loop, you make sure everything is switched off at the end...:
%(BUT you lose the informative error-messages! => blame Matlab!)
if epar.UseCatchLoop
  try
    expdriver_RunTask(epar);
  catch ME
    DoAtExit(epar);
    disp('----------------------------------------------------------------------')
    disp('Something seems to have gone wrong. The last error message was:')
    disp(ME)
  end
else
  expdriver_RunTask(epar);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function Proceeding=expdriver_AreWeProceeding(Sub,Task)

Status=expStatus(Sub,Task);
if    strcmp(Status,'STATUS_TASK_FOR_SUBJECT_NONEXISTENT') 
  fprintf('-------------------------------------------\n');
  fprintf('\n');
  fprintf('You must calibrate the subject for this task \n');
  fprintf('\n');
  fprintf('-------------------------------------------\n');
  error('You must calibrate the subject for this task')
elseif strcmp(Status,'STATUS_DATA_COLLECTION_NOT_STARTED')
  Proceeding=false;
elseif strcmp(Status,'STATUS_DATA_COLLECTION_IN_PROGRESS')
  fprintf('-------------------------------------------\n');
  fprintf('\n');
  fprintf('             !!!ATTENTION!!!               \n');
  fprintf('\n');
  fprintf('       Data collection for this task \n');
  fprintf('    and subject seems to be in progress!\n');
  fprintf('\n');
  fprintf('If you don''t know EXACTLY what this means,\n');
  fprintf('then please QUIT and ask somebody who knows\n');
  fprintf('\n');
  fprintf('-------------------------------------------\n');
  fprintf('What do you want to do?:\n');
  if Sub == 999
    a=ask_and_get_answerchar('p=proceed with saved status; n=new start (only subject 999); q=quit ','pnq');
  else
    a=ask_and_get_answerchar('p=proceed with saved status; q=quit ','pq');
  end
  if a=='p'
    Proceeding=true;
    disp('OK, proceeding with the saved status');
    pause(1)
  elseif a=='n'
    if Sub ~= 999
      error('You cannot do a new start if it is not subject 999')
    end
    Proceeding=false;
    SubFiles=expSubFileNames(Task,Sub);
    %Reset status file to initial state:
    epar.Status='STATUS_DATA_COLLECTION_NOT_STARTED';
    save(SubFiles.StatusFile,'epar','-mat');
    disp('Reset status file, now re-starting the task');
    pause(1)
    return
  elseif a=='q'
    error('Quitting successfully, IGNORE THIS ERROR MESSAGE!!!');
  end
elseif strcmp(Status,'STATUS_DATA_COLLECTION_FINISHED')
  fprintf('-------------------------------------------\n');
  fprintf('\n');
  fprintf('Task: "%s" for subject %i is finished!\n',Task, Sub);
  fprintf('Nothing is done\n');
  fprintf('\n');
  fprintf('-------------------------------------------\n');
  error('Subject seems to be finished!');
else
  error('Wrong status')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function epar=expdriver_RunTask(epar)

%Start task:
SubFiles=expSubFileNames(epar.Task,epar.Sub);
epar=DoAtBeginningOfExpAndProceeding(epar);
if epar.FirstTrialOfProceeding
  epar=DoAtBeginningOfProceeding(epar);
else
  epar=DoAtBeginningOfExp(epar);
end

%Run trials:
if ~epar.FirstTrialOfProceeding 
  epar.Trial=1;
  epar=SetBlTpVector(epar); 
end
while nrows(epar.BlTpVector)>=1
  %Block -- loop:
  epar.BlTp=deblank(epar.BlTpVector(1,:)); %Extracts current BlTp
  if ~isfield(epar,'TrTpVector') || nrows(epar.TrTpVector)==0
    epar=SetTrTpVector(epar);
    epar=DoAtBeginningOfBlock(epar);
  end
  while nrows(epar.TrTpVector)>=1
    %Trial -- loop:
    %Randomize trials BEFORE EACH TRIAL:
    epar.TrTpVector=epar.TrTpVector(randperm(nrows(epar.TrTpVector)),:);
    
    %Extracts current TrTp
    epar.TrTp =deblank(epar.TrTpVector(1,:)); 
    epar=DoTrial(epar);
    
    %Save current status:
    epar.Status='STATUS_DATA_COLLECTION_IN_PROGRESS';
    save(SubFiles.StatusFile,'epar','-mat');
    
    %Reset proceeding flag:
    epar.FirstTrialOfProceeding = false;
  end
  epar.BlTpVector=epar.BlTpVector(2:end,:);
  % added in os2401: previously leaving in the first trial of a block and proceeding caused the entire previous block to be repeated
  save(SubFiles.StatusFile,'epar','-mat'); 
  epar=DoAtEndOfBlock(epar);
end
epar=DoAtEndOfTask(epar);

%Handle status:
if epar.Sub == 999
  %For sub 999, just reset status to initial state, such that we can simply start again:
  epar.Status='STATUS_DATA_COLLECTION_NOT_STARTED';
  save(SubFiles.StatusFile,'epar','-mat');
else
  %For normal subjects, set status to finished:
  epar.Status='STATUS_DATA_COLLECTION_FINISHED';
  save(SubFiles.StatusFile,'epar','-mat');
end

DoAtExit(epar);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
