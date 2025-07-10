function [odata,eval]=util_eval(Sub,Task,Trial)

%Handle input:
if nargin~=3
  error('You must specify subject, task, trial');
else
  if ischar(Sub)   Sub  =str2double(Sub); end
  if ischar(Trial) Trial=str2double(Trial); end
end

%Settings: 
epar=expSettings;

%Load data:
SubFiles=expSubFileNames(Task,Sub,Trial);
load(SubFiles.PosFile  ,'-mat');
load(SubFiles.MatFile  ,'-mat');
if(contains(Task,'Perc'))
    odata=0;
end

%Prepare output-struct and set some general variables:
eval.Sub       = Sub;
eval.Trial     = Trial;
eval.GrTp      = GrTp;
eval.BlTp      = BlTp;
eval.TrTp      = TrTp;
eval.errorCount= errorCount;
if(contains(Task,'Grasp')||strcmp(Task,'ManEst'))
    eval.NumFrames      = odata.NumFrames;
    eval.Time           = odata.Time;
    eval.MinTime        = odata.Time(1);
    eval.MaxTime        = odata.Time(odata.NumFrames);
    eval.FingerPos      = odata.Markers{epar.RightFinger.Marker};
    eval.ThumbPos       = odata.Markers{epar.RightThumb.Marker};
    eval.Ap  = optotrakNorm(eval.ThumbPos-eval.FingerPos); % includes finger widths
end
eval.TypeString= sprintf('Sub %i Tr %i GrTp %s BlTp %s TrTp %s\n',Sub,Trial,GrTp,BlTp,TrTp);

%Print first info...:
fprintf(eval.TypeString)

if(contains(Task,'Grasp')||strcmp(Task,'ManEst'))
    %Velocity finger:
    eval.FingerVel =optoVelocity3(eval.Time,eval.FingerPos);
    eval.FingerYVel=optoVelocity1(eval.Time,eval.FingerPos(2,:));

    %Velocity thumb:
    eval.ThumbVel =optoVelocity3(eval.Time,eval.ThumbPos);
    eval.ThumbYVel=optoVelocity1(eval.Time,eval.ThumbPos(2,:));

    %Aperture:
    eval.ApVel=optoVelocity1(eval.Time,eval.Ap);
    eval.ApAcc=optoAcceleration1(eval.Time,eval.ApVel);
elseif(contains(Task,'Perc'))
    eval.FingerVel = NaN;
    eval.FingerYVel= NaN;
    eval.ThumbVel  = NaN;
    eval.ThumbYVel = NaN;
    eval.ApVel     = NaN;
    eval.ApAcc     = NaN;
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Time-events relative to opening of the goggles:
%NOTE: Most events are relative to StartSpooling because this is consistent with the optotrak data files
% eval.StartSpoolingTime = (TimeMeasure.StartSpoolingAFTER - TimeMeasure.OpenGogglesAFTER)*1000;   %msec
% eval.CloseGogglesTime  = (TimeMeasure.CloseGogglesAFTER  - TimeMeasure.StartSpoolingAFTER)*1000; %msec
% eval.StartBeepTime     = (TimeMeasure.StartBeepAFTER     - TimeMeasure.StartSpoolingAFTER)*1000; %msec
if(strcmp(Task,'ManEst'))
  eval.ManEstTime      = TimeMeasure.ManEstimatedAFTER*1000;%  - TimeMeasure.StartSpoolingAFTER)*1000; %msec
elseif(strcmp(Task,'Grasp')||contains(Task,'Perc'))
  eval.ManEstTime  = NaN;
end

%DELTA describes the insecurity in the measurements:
% eval.OpenGogglesDELTA    = (TimeMeasure.OpenGogglesAFTER    - TimeMeasure.OpenGogglesBEFORE  )*1000; %msec
% eval.StartSpoolingDELTA  = (TimeMeasure.StartSpoolingAFTER  - TimeMeasure.StartSpoolingBEFORE)*1000; %msec
% eval.CloseGogglesDELTA   = (TimeMeasure.CloseGogglesAFTER   - TimeMeasure.CloseGogglesBEFORE )*1000; %msec
% eval.StartBeepDELTA      = (TimeMeasure.StartBeepAFTER      - TimeMeasure.StartBeepBEFORE )*1000;    %msec

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if(contains(Task,'Grasp')||strcmp(Task,'ManEst'))
    %StartVF: start of movement:
    eval.FingerAboveVelCritFrame=nandata_val(min(find(eval.FingerVel>epar.StartVFVelCrit)));
    eval.ThumbAboveVelCritFrame =nandata_val(min(find( eval.ThumbVel>epar.StartVFVelCrit)));
    eval.StartVFFrame           =nandata_val(min(eval.FingerAboveVelCritFrame,eval.ThumbAboveVelCritFrame));
    %...corresponding times:
    eval.FingerAboveVelCritTime =nandata_indval(eval.Time,eval.FingerAboveVelCritFrame);
    eval.ThumbAboveVelCritTime  =nandata_indval(eval.Time,eval.ThumbAboveVelCritFrame);
    eval.StartVFTime            =nandata_indval(eval.Time,eval.StartVFFrame);
    eval.StartVFAp              =nandata_indval(eval.Ap,eval.StartVFFrame);
        % movement onset criterion ised by Ganel & Goodale 2014
    % Time point when Ap increases by more than 0.1 mm for more than 10
    % successive frames
    
    eval.ApChanges = diff(eval.Ap);
    eval.OnsetCrit = zeros(1,length(eval.ApChanges));
    for (i=1:length(eval.ApChanges)-10)
        if (all(abs(eval.ApChanges(i:(i+10)))>0.1))
            eval.OnsetCrit(i) = true;
        end
    end
    
    %find the first non-zero entry
%     eval.StartGGFrame = find(eval.OnsetCrit,1);
%     display(eval.StartGGFrame);
%     eval.StartGGTime            =nandata_indval(eval.Time,eval.StartGGFrame);
%     eval.StartGGAp              =nandata_indval(eval.Ap,eval.StartGGFrame);
    
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TouchedVF: touched target object:
if(contains(Task,'Grasp'))
  %Search only if fingers are in close vicinity of goal object:
  FingerDist  =optotrakNorm(eval.FingerPos-RightGoalPos*ones(1,odata.NumFrames));
  ThumbDist   =optotrakNorm(eval.ThumbPos -RightGoalPos*ones(1,odata.NumFrames));
  CloseToDisc =find(FingerDist<epar.GoalDistCrit | ThumbDist<epar.GoalDistCrit);
  eval.CloseToDiscStartFrame = nandata_val(min(CloseToDisc));
  eval.CloseToDiscEndFrame   = nandata_val(max(CloseToDisc));
  eval.CloseToDiscStartTime  = nandata_indval(eval.Time,eval.CloseToDiscStartFrame);
  eval.CloseToDiscEndTime    = nandata_indval(eval.Time,eval.CloseToDiscEndFrame);

  if ~isnan(eval.CloseToDiscStartFrame) && ~isnan(eval.CloseToDiscEndFrame)
    %Finger/thumb z-coordinates (height above table) restricted to close vicinity of goal:
    eval.FingerZgoal = eval.FingerPos(3,:);
    eval.ThumbZgoal  = eval.ThumbPos(3,:);
    eval.FingerZgoal(1,1:eval.CloseToDiscStartFrame) = NaN;
    eval.FingerZgoal(1,eval.CloseToDiscEndFrame:end) = NaN;
    eval.ThumbZgoal(1,1:eval.CloseToDiscStartFrame)  = NaN;
    eval.ThumbZgoal(1,eval.CloseToDiscEndFrame:end)  = NaN;

    %Determine TouchedVFFrame:
    TouchedVFRange = ...
        (eval.FingerZgoal < min(eval.FingerZgoal)+epar.ZTolerance) | ...
        (eval.ThumbZgoal  < min(eval.ThumbZgoal) +epar.ZTolerance);
    eval.TouchedVFFrame = min(find(TouchedVFRange));

    %...corresponding times:
    eval.TouchedVFTime       =nandata_indval(eval.Time,eval.TouchedVFFrame);
    eval.TouchedVFAp         =nandata_indval(eval.Ap,eval.TouchedVFFrame);
  else
    eval.FingerZgoal    = ones(1,eval.NumFrames)*NaN;
    eval.ThumbZgoal     = ones(1,eval.NumFrames)*NaN;
    eval.TouchedVFFrame = NaN;
    eval.TouchedVFTime  = NaN;
    eval.TouchedVFAp    = NaN;
  end  
  
elseif(strcmp(Task,'ManEst'))
  %TouchedVF not used in ManEst:
  eval.CloseToDiscStartFrame =NaN;
  eval.CloseToDiscEndFrame   =NaN;
  eval.CloseToDiscStartTime  =NaN;
  eval.CloseToDiscEndTime    =NaN;
  eval.DiscVelBaselineValues =NaN;
  eval.DiscVelBaseline       =NaN;
  eval.FingerZgoal           = ones(1,eval.NumFrames)*NaN;
  eval.ThumbZgoal            = ones(1,eval.NumFrames)*NaN;
  eval.TouchedVFFrame        =NaN;
  eval.TouchedVFTime         =NaN;
  eval.TouchedVFAp           =NaN;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%ManEst: time when key was pressed by experimenter:
if(contains(Task,'Grasp'))
  %not used in grasping:
  eval.ManEstFrame = NaN;
  eval.ManEstAp    = NaN;
elseif(strcmp(Task,'ManEst'))
  eval.ManEstFrame = min(find((odata.Time-eval.ManEstTime)>=0));
  eval.ManEstAp    = nandata_indval(eval.Ap,eval.ManEstFrame);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MTVF and RTVF:
%NOTE: We express RT relative to the end of the start-beep here!
% eval.RTVF = eval.StartVFTime - eval.StartBeepTime; 
if(contains(Task,'Grasp'))
  eval.MTVF = eval.TouchedVFTime-eval.StartVFTime;
elseif(strcmp(Task,'ManEst'))
  eval.MTVF = eval.ManEstTime-eval.StartVFTime;
%   eval.ManEstResp = ManEstResp.Resp;
elseif(contains(Task,'Perc'))
  eval.RTVF = TimeMeasure.PercTime*1000;
  eval.PercEst = PercEst.Resp;
  eval.Corr = PercEst.Corr;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% variables necessary for maximum grip aperture without finger widths
% according to Ganel et al 2012

if(strcmp(Task,'Grasp')||strcmp(Task,'ManEst'))
    if(any(ismember(who, 'approved')))
        eval.FGApApproved = approved.FGAp;
    end
end

if(strcmp(Task,'Grasp')||strcmp(Task,'ManEst'))
    
    eval.LeftDiscAreaTime  = TimeMeasure.LeftDiscAreaTime*1000;
    eval.LeftDiscAreaFrame = min(find((odata.Time-eval.LeftDiscAreaTime)>=0));
    
        if ~isempty(eval.LeftDiscAreaFrame)
            eval.LeftDiscAreaAp = nandata_indval(eval.Ap,eval.LeftDiscAreaFrame); 
        else 
            fprintf('G12 faulty! LeftDiscArea Frame missing.\n')
            eval.LeftDiscAreaAp = NaN;
        end    
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Maximum Aperture:
if(contains(Task,'Grasp'))
%CHANGEDHERE: changed from TouchedVFFrame to LeftDiscAreaFrame to catch all MaxAps with smaller discs !
%   if eval.StartVFFrame<eval.TouchedVFFrame 
%     eval.MaxAp     =nandata_val(max(eval.Ap(eval.StartVFFrame:eval.TouchedVFFrame)));
  if eval.StartVFFrame<eval.LeftDiscAreaFrame 
    eval.MaxAp     =nandata_val(max(eval.Ap(eval.StartVFFrame:eval.LeftDiscAreaFrame)));
  else
    eval.MaxAp     =NaN;
  end  
  eval.MaxApFrame=nandata_val(find(eval.Ap==eval.MaxAp));
  eval.MaxApTime =nandata_indval(eval.Time,eval.MaxApFrame);
elseif(strcmp(Task,'ManEst')||contains(Task,'Perc'))
  eval.MaxAp     =NaN;
  eval.MaxApFrame=NaN;
  eval.MaxApTime =NaN;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trying out Ganel & Goodale 2014 method for movement offset in ManEst
%"Movement offset ... was determined at the point in time where the Ap
% changed by not more than 0.2 mm for at least 20 successive frames (100ms)

%Time point is the first of 20 successive frames of last of 20 frames?
if(strcmp(Task,'ManEst'))
    eval.ApChanges = diff(eval.Ap);
    eval.stable = zeros(1,length(eval.ApChanges));
    for (i=1:(length(eval.ApChanges)-20))
        if (all(abs(eval.ApChanges(i:(i+20)))<0.2))
            eval.stable(i) = true;
        end
    end

    for(CritFrame=eval.ManEstFrame:-1:eval.StartVFFrame)
        if eval.stable(CritFrame)
            continue;
        else
            break;
        end
    end
    CritFrame = CritFrame + 1;
    eval.GGManEstTime = nandata_indval(eval.Time,CritFrame);
    eval.GGManEstAp = nandata_indval(eval.Ap,CritFrame);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Maybe exclude trial:
eval.excludeVF=false;
eval.excludeVFString=[];
if(strcmp(Task,'Perc'))
    if eval.RTVF < epar.MinRTVF
      eval.excludeVF=true;
      eval.excludeVFString=sprintf('ExclVF-MinRT-%s',eval.excludeVFString);
    end
    if eval.RTVF > epar.MaxRTVF
      eval.excludeVF=true;
      eval.excludeVFString=sprintf('ExclVF-MaxRT-%s',eval.excludeVFString);
    end
end
if(contains(Task,'Grasp')||strcmp(Task,'ManEst'))
    if eval.MTVF < epar.MinMTVF
      eval.excludeVF=true;
      eval.excludeVFString=sprintf('ExclVF-MinMT-%s',eval.excludeVFString);
    end
    if eval.MTVF > epar.MaxMTVF
      eval.excludeVF=true;
      eval.excludeVFString=sprintf('ExclVF-MaxMT-%s',eval.excludeVFString);
    end
end
if(contains(Task,'Grasp'))
  if isnan(eval.TouchedVFFrame)
    eval.excludeVF=true;
    eval.excludeVFString=sprintf('ExclVF-NoTouch-%s',eval.excludeVFString);
  end
elseif(strcmp(Task,'ManEst'))
  if isnan(eval.ManEstFrame)
    eval.excludeVF=true;
    eval.excludeVFString=sprintf('ExclVF-NoManEst-%s',eval.excludeVFString);
  end
end
%Set excludeString if there is no exclusion:
if ~eval.excludeVF
  eval.excludeVFString='InclVF';
end
  
%Print exclusion info: 
fprintf(' %-20s\n',eval.excludeVFString);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Sub--functions:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Value=nandata_val(InValue)
%Return InValue or NaN, if InValue is the empty matrix.
if isempty(InValue)
  Value=NaN;
else
  Value=InValue;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Value=nandata_indval(InValues,Index)
%Return InValues(Index) or NaN, if Index itself is NaN or the empty matrix.
if isnan(Index) || isempty(Index) || isempty(InValues)
  Value=NaN;
else
  Value=InValues(Index);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function yi = nandata_interp1(x,y,xi)
%Interpolate, ignoring NaNs in x, y (Matlab is to stupid for this!)

%Strip x, y from NaNs:
stripindices=find(~isnan(x) & ~isnan(y));
xstrip=x(stripindices);
ystrip=y(stripindices);

%Interpolate..:
yi = interp1(xstrip,ystrip,xi);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Vel=optoVelocity3(Time,Trajectory)
%Norm of velocity from 3d vector; INPUT: mm and msec, OUTPUT: m/sec

TimeStep=unique(diff(Time));
if(ncols(TimeStep)~=1) error('TimeSteps must be constant'); end
if(nrows(TimeStep)~=1) error('TimeSteps must be constant'); end
Vel3d     =diff(Trajectory')';
RawVel    =optotrakNorm(Vel3d)/TimeStep;%mm/msec==m/sec
RawVelTime=Time(2:end)-TimeStep/2;
Vel       =nandata_interp1(RawVelTime,RawVel,Time);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Vel=optoVelocity1(Time,Trajectory)
%Velocity from 1d vector; INPUT: mm and msec, OUTPUT: m/sec

TimeStep=unique(diff(Time));
if(ncols(TimeStep)~=1) error('TimeSteps must be constant'); end
if(nrows(TimeStep)~=1) error('TimeSteps must be constant'); end
Vel3d     =diff(Trajectory')';
RawVel    =Vel3d/TimeStep;%mm/msec==m/sec
RawVelTime=Time(2:end)-TimeStep/2;
Vel       =nandata_interp1(RawVelTime,RawVel,Time);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Acc=optoAcceleration1(Time,Velocity)
%Acceleration from 1d velocity vector; INPUT: m/sec and msec, OUTPUT: m/sec^2

TimeStep=unique(diff(Time));
if(ncols(TimeStep)~=1) error('TimeSteps must be constant'); end
if(nrows(TimeStep)~=1) error('TimeSteps must be constant'); end
Acc3d     =diff(Velocity')';
RawAcc    =Acc3d/(TimeStep/1000);%m/(sec*(msec/1000))==m/(sec*sec)
RawAccTime=Time(2:end)-TimeStep/2;
Acc       =nandata_interp1(RawAccTime,RawAcc,Time);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
