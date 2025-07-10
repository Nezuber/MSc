clear all
format compact

%Settings:
%manEstUSBIndex = 0;
leftKeyIndex = 1;
rightKeyIndex = 2;
numRepetitions = 10;

%Open port:
daq.getDevices
DIO = daq.createSession('dt');    

addDigitalChannel(DIO,'DT9812(00)','port0/line0','InputOnly'); %left  key        
addDigitalChannel(DIO,'DT9812(00)','port0/line1','InputOnly'); %right  key
% DIO=digitalio('dtol');
% addline(DIO,manEstUSBIndex ,'in');

%Print info:
fprintf('We repeat the following test-sequence %i times!\n',numRepetitions);
fprintf('If you want to quit earlier, press Ctrl-C\n');
fprintf('Proceed with RETURN\n');
pause

%Test keys:
for i=1:numRepetitions
  fprintf('Please press a key\n')
  while 1
    currstatus=inputSingleScan(DIO);
    if(currstatus(leftKeyIndex)==0)
      fprintf('LEFT\n')
      break
    elseif(currstatus(rightKeyIndex)==0)
      fprintf('RIGHT\n')
      break
    end
  end
  WaitSecs(0.5);
end

fprintf('Test over\n');





