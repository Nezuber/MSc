function drawInstructions(Task)
%this function creates a virtual environment on the additional monitor

% Make sure Psychtoolbox is properly installed and set it up for use at
% feature level 2: Normalized 0-1 color range and unified key mapping.
sca;
PsychDefaultSetup(2);

%%% add these lines to prevent visual errors and program halting due to 
%%% errors in screen tests of PTB on Castor

Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference','VisualDebugLevel', 0);

% Select the display screen on which to show our window:
screenid = 1;
%max(Screen('Screens'));

% Open a window on display screen 'screenid'. We choose a 50% gray
% background by specifying a luminance level of 0.5:
win = PsychImaging('Openwindow', screenid, 1);

% Show it on the display:
Screen('Flip', win); 

if(strcmp(Task,'Grasp'))
    % new text
    instructions_grasp(win)
    
    % Show it on the display:
    Screen('Flip', win);

    % %wait for keypress
    KbStrokeWait;
elseif(strcmp(Task,'ManEst'))
    % new text
    instructions_manest1(win)
    
    % Show it on the display:
    Screen('Flip', win);

    % %wait for keypress
    KbStrokeWait;
    
    instructions_manest2(win)
    
    % Show it on the display:
    Screen('Flip', win);

    % %wait for keypress
    KbStrokeWait;
elseif(strcmp(Task,'Perc'))
    % new text
    instructions_perc(win)
    
    % Show it on the display:
    Screen('Flip', win);

    % %wait for keypress
    KbStrokeWait;
end

% new text
instructions_ready(win)

% Show it on the display:
Screen('Flip', win);

% %wait for keypress
KbStrokeWait;
% clear screen
sca;

end

