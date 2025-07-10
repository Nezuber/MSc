function optostart(CAMFile,Collection)
%Simple starter for Optotrak. 
%For the experiment use: expStartOptotrak.m

optotrak('TransputerLoadSystem','system');
pause(1);
optotrak('TransputerInitializeSystem')
optotrak('OptotrakLoadCameraParameters',CAMFile);
optotrak('OptotrakSetupCollection',Collection);
pause(1);
