%Note: keep this as independent from the experiment as possible...
%
%Connection of goggles: 
% green+black cables => ground
% two other cables   => ditigal output line
%
clear all
format compact

%Settings:
pinRightEye = 14;
pinLeftEye  = 15;
rightEye    = 1;
leftEye     = 2;


daq.getDevices
DIO = daq.createSession('dt');
%goggles left eye
addDigitalChannel(DIO,'DT9812(00)','port0/line7','OutputOnly');
%goggles right eye
addDigitalChannel(DIO,'DT9812(00)','port0/line0','OutputOnly');

numRepetitions = 2;
waitDuration = 0.5;

% Print info:
fprintf('We repeat the following test-sequence %i times!\n',numRepetitions);
fprintf('If you want to quit earlier, press Ctrl-C\n');
fprintf('Proceed with RETURN\n');
pause
% 
% %Open/close left/right eyes:
for i=1:numRepetitions
    outputSingleScan(DIO,[1,1])
    pause(waitDuration)
    outputSingleScan(DIO,[0,0])
    pause(waitDuration)
    outputSingleScan(DIO,[1,1])
    pause(waitDuration)
    outputSingleScan(DIO,[0,1]);
    pause(waitDuration)
    outputSingleScan(DIO,[1,1])
    pause(waitDuration)
    outputSingleScan(DIO,[1,0]);
    pause(waitDuration)
    outputSingleScan(DIO,[1,1])
    pause(waitDuration)
    outputSingleScan(DIO,[0,0])
    pause(waitDuration)
    outputSingleScan(DIO,[1,1])
end


