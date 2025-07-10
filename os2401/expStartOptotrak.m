function expStartOptotrak(Sub,Task)
%Note: Optotrak must be started in the same way called by the experiment 
%      as well as by the conversion routine.

%Settings:
epar=expSettings; 
SubFiles=expSubFileNames(Task,Sub);

%Start Optotrak:
optotrak('TransputerLoadSystem','system');
pause(1);
optotrak('TransputerInitializeSystem')
optotrak('OptotrakLoadCameraParameters',epar.CAMFile);
optotrak('OptotrakSetupCollection',epar.ExpColl);
pause(1);
optotrak('OptotrakActivateMarkers');

