 
function showVirtualEnv_withoptorange(Task,Subtask)

% Use this function when you want to display the environment for
% demonstration to the participants and checking if markers are visible.
% task must be one of 'Perc', 'Grasp', 'ManEst'
% Subtask is needed to test Perc questions, for Grasp/ManEst giving in '' suffices

try
   
    fprintf('Starting optorange...\n')
    drawVirtualEnv(Task,Subtask) 
    optorange(6)

    %%wait for keypress
    KbStrokeWait;
    fprintf('Leaving optorange...\n')
catch
end
    
sca;

end

