

function drawVirtualEnv(task, block)
%this function creates a virtual environment on the additional monitor
% task must be one of 'Perc', 'Grasp', 'ManEst'
% block is needed to test 'Perc' questions ('S', 'L'), for 'Grasp'/'ManEst' giving in '' suffices

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
% Goal and ManEst position were merged and moved due to chinrest 
% & goggles together obstructing view otherwise
% (changed due to this are xME, yME, xGGoal, manest & commenting out same
% values for drawing)
% xME = xStart - distStartStimuli/2 - 100; % last value is to move it a bit out of the way / touched radius
% yME = yStart + distStartStimuli/2 - 100; % last value is to move it a bit out of the way / touched radius
xPR = xStart - devLR;
yPR = dist;
xPL = xStart + devLR;
yPL = dist;
xObj = xStart;
yObj= dist;
xGGoal = xStart - distStartStimuli + 100; % last value changed due to view obstruction
yGGoal = dist - 100; 

% for 5 cm distance, x = 400, y = 300
% for 4 cm distance, x = 375, y = 275
% for 3 cm distance, x = 350, y = 250

% % Set a big text size:
Screen('TextSize', win, 35);

% Show it on the display:
Screen('Flip', win); 

% Draw some framed rects. We define the bounding rectangles
% [left, top, right, bottom] of the rectangles:
rct=[0 0 50 50];

% Helper functions (help PsychRects) allow to manipulate rectangles,
% e.g., shift a rect around by an x,y offset:

start = OffsetRect(rct, xStart, yStart);
percR = OffsetRect(rct, xPR, yPR);
percL = OffsetRect(rct, xPL, yPL);
obj = OffsetRect(rct, xObj, yObj);
graspGoal = OffsetRect(rct, xGGoal, yGGoal);
% manest = OffsetRect(rct, xME,yME);
maxDiameter = max(rct);

% Draw shapes and text:
if (~strcmp(task,'Perc') && ~strcmp(task,'ManEst') && ~contains(task,'Grasp'))
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
elseif strcmp(task,'Grasp')
    Screen('FrameOval',win, objcol, start, maxDiameter);
    Screen('FrameOval',win, objcol, obj, maxDiameter);
    Screen('FrameOval',win, objcol, graspGoal, maxDiameter);
    DrawFormattedText(win, 'Start', xStart, yStart-100, txtcol,'',1,1,'','');
    DrawFormattedText(win, 'Object', xObj+150, yObj, txtcol,'',1,1,'','');
    DrawFormattedText(win, 'Goal', xGGoal-150, yGGoal, txtcol,'',1,1,'','');
elseif strcmp(task,'ManEst')    
    Screen('FrameOval',win, objcol, start, maxDiameter);
%     Screen('FrameOval',win, objcol, manest, maxDiameter);
    Screen('FrameOval',win, objcol, obj, maxDiameter);
    Screen('FrameOval',win, objcol, graspGoal, maxDiameter);
    DrawFormattedText(win, 'Start', xStart, yStart-100, txtcol,'',1,1,'','');
%     DrawFormattedText(win, 'Manual Estimate', xME-255, yME-55, txtcol,'',1,1,'','');
    DrawFormattedText(win, 'Object', xObj+150, yObj, txtcol,'',1,1,'','');
    DrawFormattedText(win, 'ManEst + Goal', xGGoal-150, yGGoal+100, txtcol,'',1,1,'',''); 
end


% Show it on the display:
Screen('Flip', win);


% %wait for keypress - only uncomment for testing 
% KbStrokeWait;
% 
% sca;

end

