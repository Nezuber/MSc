function quickrandomplot(task)
%Choose subject randomly from list of subjects used by evaluate and
%also choose randomly one of this subjects trials and plot them

%Settings:
Cycle=true;
epar=expSettings; 

%Handle input:
if nargin~=1
  error('You must specify the task');
end
if(strcmp(task,'GraspCL')||strcmp(task,'GraspOL'))
  Subjects=epar.GraspSubjects; 
elseif(strcmp(task,'ManEst'))
  Subjects=epar.ManEstSubjects;
else
  error('Wrong task')
end

%Select randomly subject + trials and plot them:
datadir=dir(['data']);
while(true)
  fprintf('----------------------------------------------------------------------\n')
  %Randomly select subject:
  CurrNoSubs=length(Subjects);
  subindex = floor(random('unif',1,CurrNoSubs));
  sub=Subjects(subindex);

  %Randomly select trial:
  CurrNoTrials=length(dir(['data/' subnos(sub) '/' task '/' epar.ExpName '_MAT3D.*']));
  trial = floor(random('unif',1,CurrNoTrials));
  
  %Plot it:
  util_plot(sub,task,trial);
  if(Cycle) 
    pause(1)
  else
    pause
  end
end

