
function showVirtualEnv_withcalibpositions()

% Use this function when you want to display the environment for
% demonstration to the participants. In that case, press 'q' to quit the
% calibpositions. When setting positions, continue with calibpositions as
% usual.

% BEFORE CALIBPOSITIONS YOU NEED TO RUN CALIBCOOR
try
   
    drawVirtualEnv('Grasp','')
    calibpositions()

    %%wait for keypress
    KbStrokeWait;
catch
end
    
sca;

end

