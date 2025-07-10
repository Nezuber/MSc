

function drawVirtualEnv(task, block)
%this function creates a virtual environment on the additional monitor
% task must be one of 'Perc', 'Grasp', 'ManEst'
% block is needed to distinguish between practice ('PracWT'/'PracNT') 
% and actual trials ('') and different 'Perc' questions ('S'/'L')

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
win = PsychImaging('Openwindow', screenid, 0);

% Define colors
txtcol = [1 1 1];
objcol = [1, 1, 1];

% Define locations
% inverted screen for participant monitor
xStart = 815;
yStart = 200;
distStartStimuli = 527; %=15c,
dist = yStart + distStartStimuli; 
devLR = 177; % = 5cm -> for 10cm distance between left and right
% xME = xStart - distStartStimuli/2 - 100; % last value is to move it a bit out of the way / touched radius
% yME = yStart + distStartStimuli/2 - 100; % last value is to move it a bit out of the way / touched radius
xME = xStart + distStartStimuli/2 + 100; 
yME = yStart + distStartStimuli/2 - 100; 
xPR = xStart - devLR;
yPR = dist;
xPL = xStart + devLR;
yPL = dist;
xObj = xStart;
yObj= dist;
xGGoal = xStart - distStartStimuli;
% yGGoal = dist; 
yGGoal = dist-150; 

% for 5 cm distance, x = 400, y = 300
% for 4 cm distance, x = 375, y = 275
% for 3 cm distance, x = 350, y = 250

% % Set a big text size:
Screen('TextSize', win, 35);
Screen('TextStyle', win, 0);

% Show it on the display:
Screen('Flip', win); 

% Draw some framed rects. We define the bounding rectangles
% [left, top, right, bottom] of the rectangles:
rct_size_big = 50;
rct_size_tiny = 3;
rct_size_diff_shift = (rct_size_big - rct_size_tiny) / 2;

rct=[0 0 rct_size_big rct_size_big];
rct_tiny=[0 0 rct_size_tiny rct_size_tiny];

% Helper functions (help PsychRects) allow to manipulate rectangles,
% e.g., shift a rect around by an x,y offset:

start = OffsetRect(rct, xStart, yStart);
percR = OffsetRect(rct, xPR, yPR);
percL = OffsetRect(rct, xPL, yPL);
obj = OffsetRect(rct, xObj, yObj);
manest = OffsetRect(rct, xME,yME);
manest_tiny = OffsetRect(rct_tiny, xME + rct_size_diff_shift,yME + rct_size_diff_shift); 
maxDiameter = max(rct);

% Draw shapes and text:
if (~strcmp(task,'Grasp') && ~strcmp(task,'ManEst') && ~strcmp(task,'Perc') && ~strcmp(task,'ExPerc'))
   fprintf('Wrong task!!!!\n')
end

if strcmp(task,'Perc')
    Screen('FrameOval',win, objcol, start, maxDiameter);
    Screen('FrameOval',win, objcol, percR, maxDiameter);
    Screen('FrameOval',win, objcol, percL, maxDiameter);
    DrawFormattedText(win, 'R', xPR-200, yPR, txtcol,'',1,1,'','');
    DrawFormattedText(win, 'L', xPL+180, yPL, txtcol,'',1,1,'','');
    if(contains(block,'L'))
        DrawFormattedText(win, 'Welche Scheibe ist groesser?', xStart-200, yStart-100, txtcol,'',1,1,'','');
    elseif(contains(block,'S'))
        DrawFormattedText(win, 'Welche Scheibe ist kleiner?', xStart-200, yStart-100, txtcol,'',1,1,'','');
    end
elseif strcmp(task,'ExPerc')
    if(contains(block,'PracWT'))
        DrawFormattedText(win, 'Object', xObj+150, yObj, txtcol,'',1,1,'','');
    end
    Screen('FrameOval',win, objcol, start, maxDiameter);
    Screen('FrameOval',win, objcol, obj, maxDiameter);
    DrawFormattedText(win, 'Ist die Scheibe eher gross oder eher klein?', xStart-300, yStart-100, txtcol,'',1,1,'','');
elseif strcmp(task,'Grasp')
    if(contains(block,'PracWT'))
        DrawFormattedText(win, 'Start', xStart, yStart-100, txtcol,'',1,1,'','');
        DrawFormattedText(win, 'Object', xObj+150, yObj, txtcol,'',1,1,'','');
%         DrawFormattedText(win, 'Goal', xGGoal-150, yGGoal, txtcol,'',1,1,'','');
        DrawFormattedText(win, 'Goal', xGGoal-150, yGGoal+100-150, txtcol,'',1,1,'','');
    end
    Screen('FrameOval',win, objcol, start, maxDiameter);
    Screen('FrameOval',win, objcol, obj, maxDiameter);
    % change settings to draw goal 
    Screen('TextSize', win, 100); 
    Screen('TextStyle', win, 1);
    DrawFormattedText(win, 'X', xGGoal-9, yGGoal-84, txtcol,'',1,1,'','');
elseif strcmp(task,'ManEst')    
    if(contains(block,'PracWT'))
        Screen('FrameOval',win, objcol, manest, maxDiameter);
        
        DrawFormattedText(win, 'Start', xStart, yStart-100, txtcol,'',1,1,'','');
%         DrawFormattedText(win, 'Manual Estimate', xME-255, yME-55, txtcol,'',1,1,'','');
        DrawFormattedText(win, 'Manual Estimate', xME+155, yME-55, txtcol,'',1,1,'','');
        DrawFormattedText(win, 'Object', xObj+150, yObj, txtcol,'',1,1,'','');
%         DrawFormattedText(win, 'Goal', xGGoal-150, yGGoal+100, txtcol,'',1,1,'',''); 
        DrawFormattedText(win, 'Goal', xGGoal-150, yGGoal+100-150, txtcol,'',1,1,'',''); 
    else
        Screen('FrameOval',win, objcol, manest_tiny, maxDiameter);
    end
    Screen('FrameOval',win, objcol, start, maxDiameter);
    Screen('FrameOval',win, objcol, obj, maxDiameter);
    % change settings to draw goal 
    Screen('TextSize', win, 100); 
    Screen('TextStyle', win, 1);
    DrawFormattedText(win, 'X', xGGoal-9, yGGoal-84, txtcol,'',1,1,'','');
end


% Show it on the display:
Screen('Flip', win);


% %wait for keypress - only uncomment for testing 
% KbStrokeWait;
% 
% sca;

end

