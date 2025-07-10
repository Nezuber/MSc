function [SubFiles]=expSubFileNames(Task,Sub,Trial)
%Generates filenames for all files of subject (Sub) and Trial. 
%If only Sub is specified, returns those files which are relevant 
%for the subject independent of the Trial. 

%Handle input:
if nargin<1
  error('You must specify at least one argument')
elseif nargin==1
  SubSpecified  =false;
  TrialSpecified=false;
elseif nargin==2
  SubSpecified  =true;
  TrialSpecified=false;
elseif nargin==3
  SubSpecified  =true;
  TrialSpecified=true;
else
  error('More than three arguments not allowed')
end
if(SubSpecified)
  if ischar(Sub) Sub=str2double(Sub); end
end
if(TrialSpecified)
  if ischar(Trial) Trial=str2double(Trial); end
end
if ~ischar(Task) error('Task must be string'); end

%Get settings:
epar=expSettings; 

%Task specific files:
%Files that collect the results of the evaluation. For example, if the 
%task is 'Grasp', this will generate a field: SubFiles.Grasp=...
SubFiles.EvalDir = ['./analyses'];

if(contains(Task,'Grasp'))
    SubFiles=setfield(SubFiles,['EvalGrasp'],[SubFiles.EvalDir,'/',epar.ExpName,'_',Task,'.txt']);
else
    SubFiles=setfield(SubFiles,['Eval' Task],[SubFiles.EvalDir,'/',epar.ExpName,'_',Task,'.txt']);
end

%Subject specific files:
if(SubSpecified)
  SubFiles.SubDir        = ['./data/',subnos(Sub),'/',Task];
  SubFiles.StatusFile    = [SubFiles.SubDir,'/expstatus.mat'];
  SubFiles.PosFile       = [SubFiles.SubDir,'/positions.mat'];
%change here for positions_new file
end

if(strcmp(Task,'Grasp')||strcmp(Task,'ManEst'))
%Trial specific files:
    if(TrialSpecified)
      SubFiles.RawFile   =[SubFiles.SubDir,'/',epar.ExpName,'_raw.'  ,subnos(Sub),'.',subnos(Trial)];
      SubFiles.PC3DFile  =[SubFiles.SubDir,'/',epar.ExpName,'_PC3D.' ,subnos(Sub),'.',subnos(Trial)];
      SubFiles.MatFile   =[SubFiles.SubDir,'/',epar.ExpName,'_MAT3D.',subnos(Sub),'.',subnos(Trial)];
    end
elseif(strcmp(Task,'Perc')||strcmp(Task,'ExPerc'))
    if(TrialSpecified)
        SubFiles.MatFile   =[SubFiles.SubDir,'/',epar.ExpName,'_MAT.',subnos(Sub),'.',subnos(Trial)];
    end
end

