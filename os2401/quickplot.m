function quickplot(Sub,Task)
%Plot all trials of one specific subject and task

%Settings:
Cycle=true;
epar=expSettings; 

%Handle input:
if nargin==0 | nargin==1
  error('You must specify subject and task');
elseif nargin==2
  if ischar(Sub) Sub=str2double(Sub); end
else
  error('Not more than 3 arguments allowed');
end

%Cycle through trials and plot them:
NoTrials=length(dir(['data/' subnos(Sub) '/' Task '/' epar.ExpName '_MAT3D.*']))
for Trial = 1:NoTrials
  fprintf('----------------------------------------------------------------------\n')
  util_plot(Sub,Task,Trial);
  if(Cycle) 
    pause(1)
  else
    pause
  end
end

