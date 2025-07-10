function util_plot(Sub,Task,Trial)

%Handle input:
if nargin~=3
  error('You must specify subject, task, and trial');
else
  if ischar(Sub)   Sub  =str2double(Sub); end
  if ischar(Trial) Trial=str2double(Trial); end
end

%Settings: 
epar=expSettings;
showDimension=3; %topmost plot: 1=X, 2=Y, 3=Z
xRange      =[300,600];
yRange      =[ 50,450];
zRange      =[  0,150];
ApRange     =[  0,200];
MeRange     =[  0,150];
ApSurplus   =5;
VelRange    =[    0,1.5];
ApVelRange  =[-0.02,0.02];
FingerMissingOffset = 20;
ThumbMissingOffset  = 15;

%Evaluate data:
[odata,eval]=util_eval(Sub,Task,Trial);

if (contains(eval.excludeVFString,'Excl'))
    warning('Exclusion criteria met! Please exclude trial and repeat.')
end

%Determine when finger/thumb are missing:
FingerMissing=double(optotrakIsNaN(eval.FingerPos))*FingerMissingOffset;
FingerMissing(find(~FingerMissing))=NaN;
ThumbMissing=double(optotrakIsNaN(eval.ThumbPos))*ThumbMissingOffset;
ThumbMissing(find(~ThumbMissing))=NaN;

%Plot to current figure:
clf;

%Side view:
subplot(4,1,1,'align');
hold on;
hZ(1) =plot(eval.Time,eval.FingerPos(showDimension,:),'r.-');
hZ(2) =plot(eval.Time,eval.ThumbPos(showDimension,:) ,'b.-');
if(showDimension==1)
  ylabel([' X (mm)'])
  axis([eval.MinTime,eval.MaxTime,xRange]);
elseif(showDimension==2)
  ylabel([' Y (mm)'])
  axis([eval.MinTime,eval.MaxTime,yRange]);
elseif(showDimension==3)
  ylabel([' Z (mm)'])
  axis([eval.MinTime,eval.MaxTime,zRange]);
else
  error('showDimension not valid')
end

if(strcmp(Task,'ManEst'))
%   hZ(4) =NaN;
%   hZ(5) =NaN;
elseif(contains(Task,'Grasp'))
  hZ(4) =plot(eval.Time,eval.FingerZgoal,'g*');
  hZ(5) =plot(eval.Time,eval.ThumbZgoal ,'g*');
end
hZ(6) =ablineV(eval.StartVFTime     ,'b-' );
% hZ(7) =ablineV(eval.CloseGogglesTime,'k--');
% nandata_legend(hZ([1,2,4,5,6,7,10])',{'Finger';'Thumb';'FingerZgoal';'ThumbZgoal';'StartVF';'CloseGoggles';'TouchedVF'},1);
if(strcmp(Task,'ManEst'))
  hZ(9) =ablineV(eval.ManEstTime      ,'g-' ); 
  hZ(11) =ablineV(eval.LeftDiscAreaTime      ,'m-' ); 
  nandata_legend(hZ([1,2,6,9,11])',{'Finger';'Thumb';'StartVF';'ManEstTime';'LeftDiscAreaTime'});
  title('Manual Estimation');
elseif(contains(Task,'Grasp'))
  hZ(8) =ablineV(eval.MaxApTime       ,'g-' );
  hZ(10)=ablineV(eval.TouchedVFTime   ,'r-' );
  hZ(12) =ablineV(eval.LeftDiscAreaTime      ,'m-' ); 
  nandata_legend(hZ([1,2,4,5,6,10,12])',{'Finger';'Thumb';'FingerZgoal';'ThumbZgoal';'StartVF';'TouchedVF';'LeftDiscAreaTime'});
  title('Grasping');
end

%Aperture:
subplot(4,1,2,'align');
hold on;
plot(eval.Time,eval.Ap,'k.');
hAp(1)=plot(eval.Time,FingerMissing,'r.-');
hAp(2)=plot(eval.Time,ThumbMissing ,'b.-');
if isnumberVF(eval.MaxAp)
  hAp(5)=plot([eval.MaxApTime eval.MaxApTime],[0 eval.MaxAp],'g-');
  axis([eval.MinTime,eval.MaxTime,ApRange]);
end
if isnumberVF(eval.ManEstAp)
  hAp(5)=plot([eval.ManEstTime eval.ManEstTime],[0 eval.ManEstAp],'g-');
  axis([eval.MinTime,eval.MaxTime,MeRange]);
end
hAp( 6)=ablineV(eval.StartVFTime     ,'b-' );
hAp(9) =ablineV(eval.LeftDiscAreaTime      ,'m-' ); 
if(~strcmp(Task,'ManEst'))
    hAp( 8)=ablineV(eval.TouchedVFTime   ,'r-' );
end
nandata_legend(hAp([1 2 5])',{'Finger missing';'Thumb missing';'MGA/ManEst'});
ylabel([' Ap (mm)']);

%Aperture / magnified:
subplot(4,1,3,'align');
hold on;
plot(eval.Time,eval.Ap,'k.');
hAp(1)=plot(eval.Time,FingerMissing,'r.-');
hAp(2)=plot(eval.Time,ThumbMissing ,'b.-');
if isnumberVF(eval.MaxAp)
  hAp(3)=plot([eval.MaxApTime eval.MaxApTime],[0 eval.MaxAp],'g-');
  axis([eval.MinTime,eval.MaxTime,eval.MaxAp-ApSurplus,eval.MaxAp+ApSurplus]);
end
if isnumberVF(eval.ManEstAp)
  hAp(3)=plot([eval.ManEstTime eval.ManEstTime],[0 eval.ManEstAp],'g-');
  axis([eval.MinTime,eval.MaxTime,eval.ManEstAp-ApSurplus,eval.ManEstAp+ApSurplus]);
end
hAp(4)=ablineV(eval.StartVFTime     ,'b-' );
% hAp(5)=ablineV(eval.CloseGogglesTime,'k--');
if(~strcmp(Task,'ManEst'))
    hAp(6)=ablineV(eval.TouchedVFTime   ,'r-' );
end
ylabel([' Ap (mm)']);

%Aperture velocity:
subplot(4,1,4,'align');
hold on;
plot(eval.Time,eval.ApVel ,'k.-');
axis([eval.MinTime,eval.MaxTime ApVelRange]);
ablineH(0,'k-');
hAV(1)=ablineV(eval.StartVFTime     ,'b-' );
% hAV(2)=ablineV(eval.CloseGogglesTime,'k--');
if(~strcmp(Task,'ManEst'))
    hAV(3)=ablineV(eval.MaxApTime       ,'g-' );
else
    hAV(4)=ablineV(eval.ManEstTime      ,'g-' );
end
if(~strcmp(Task,'ManEst'))
    hAV(5)=ablineV(eval.TouchedVFTime   ,'r-' );
end

xlabel('Time (msec)');
ylabel([' Ap-vel (m/s)']);

%Print some information on this trial:
if(strcmp(Task,'ManEst'))
  fprintf('   ManEstAp        : %8.2f\n',eval.ManEstAp);
elseif(contains(Task,'Grasp'))
  fprintf('   MaxAp           : %8.2f\n',eval.MaxAp);
end
% fprintf('   CloseGogglesTime: %8.2f\n',eval.CloseGogglesTime);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Sub--functions:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function nandata_legend(handles,labels)
%Create legend for all entries that are valid handles:

% indices = find(~isempty(handles) & ~isnan(handles) & ~(handles==0));
indices = find(~isempty(handles) & ~(handles==0));
if(~isempty(indices))
  handles=handles(indices);
  labels =labels(indices);
  legend(handles,labels)
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function res=isnumberVF(value)
%%TODO: test and vectorize...

if(~isempty(value) & isfinite(value))
  res = true;
else
  res = false;
end
end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
