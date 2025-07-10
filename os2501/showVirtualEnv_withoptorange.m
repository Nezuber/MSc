 
function showVirtualEnv_withoptorange(Task,Subtask)

% Use this function when you want to display the environment for
% demonstration to the participants and checking if markers are visible.
% task must be one of 'Perc', 'Grasp', 'ManEst'
% Subtask is needed to distinguish between practice ('PracWT'/'PracNT') 
% and actual trials ('') and different 'Perc' questions ('S'/'L')

try
   
    fprintf('Starting optorange...\n')
    
    daq.getDevices
    DIO = daq.createSession('dt');

    epar.DIO = DIO;

    addDigitalChannel(epar.DIO,'DT9812(00)','port0/line0','InputOnly');%left       
    addDigitalChannel(epar.DIO,'DT9812(00)','port0/line1','InputOnly');%right

    %goggles left eye
    addDigitalChannel(epar.DIO,'DT9812(00)','port0/line7','OutputOnly');
    %goggles right eye
    addDigitalChannel(epar.DIO,'DT9812(00)','port0/line0','OutputOnly');

    outputSingleScan(epar.DIO,[0,0]);%open
    
    % draw virtual environment
    % Subtask is needed to test Perc questions, for ExPerc/Grasp/ManEst giving in '' suffices
    % (optionally do 'PracWt'/'PracNT' for with/without tutorial
    drawVirtualEnv(Task,Subtask) 
    optorange(6)

    %%wait for keypress
    KbStrokeWait;
    fprintf('Leaving optorange...\n')
   
catch
end
    
sca;

end

