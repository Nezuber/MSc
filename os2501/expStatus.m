function Status=expStatus(Sub,Task)
%Return status of current task and subject.

%Handle input:
if nargin~=2
  error('Exactly two arguments needed')
end
if ischar(Sub) Sub=str2double(Sub); end
if ~ischar(Task) error('Task must be string'); end

SubFiles=expSubFileNames(Task,Sub);
if ~file_exists(SubFiles.SubDir)
  %Subject does not exist if there is not the corresponding directory:
  Status='STATUS_TASK_FOR_SUBJECT_NONEXISTENT'; 
else
  if ~file_exists(SubFiles.StatusFile)
    %Error if there exists a subject directory but no status file:
    error('Statusfile must exist if subject directory exists!')
  end
  load(SubFiles.StatusFile)
  %Check for allowed Status values (Status is set by other programs...):
  if    ~strcmp(epar.Status,'STATUS_DATA_COLLECTION_NOT_STARTED') & ...
        ~strcmp(epar.Status,'STATUS_DATA_COLLECTION_IN_PROGRESS') & ...
        ~strcmp(epar.Status,'STATUS_DATA_COLLECTION_FINISHED')
    error('Internal error: Wrong status')
  end
  %Return the current status:
  Status=epar.Status;
end
