function expCreateTaskForSubject(Sub,Task)
%Create task for subject if status is: 
%STATUS_TASK_FOR_SUBJECT_NONEXISTENT. Otherwise do nothing.

%Handle input:
if nargin~=2
  error('Exactly two arguments needed')
end
if ischar(Sub) Sub=str2double(Sub); end
if ~ischar(Task) error('Task must be string'); end

Status=expStatus(Sub,Task);
if strcmp(Status,'STATUS_TASK_FOR_SUBJECT_NONEXISTENT') 
  %Create subject directory:
  SubFiles=expSubFileNames(Task,Sub);
  mkdir(SubFiles.SubDir)
  
  %Save an initial status file:
  epar.Status='STATUS_DATA_COLLECTION_NOT_STARTED';
  save(SubFiles.StatusFile,'epar','-mat');

  fprintf('Created task: "%s" for subject: %i \n',Task,Sub)
end


