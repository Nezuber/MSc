function drawPositions(win)
screenid = 1;
[width, height] = Screen('WindowSize', win);                % in pixel
[realWidth, realHeight] = Screen('DisplaySize', screenid);  % in mm

% fprintf('width      = %d pixel\n',width)      % in pixel
% fprintf('height     = %d pixel\n',height)     % in pixel
% fprintf('\n')
% fprintf('realWidth  = %d mm\n',realWidth)     % in mm
% fprintf('realHeight = %d mm\n',realHeight)    % in mm
% fprintf('\n')

% Set distances
objDistance = 100; % in mm from start point
objRadius = mm2pixel(objDistance, width, realWidth);

goalDistance = objDistance + 120; % in mm from start point
goalRadius = mm2pixel(goalDistance, width, realWidth);

% fprintf('objRadius  = %d pixel\n',objRadius)    % in pixel
% fprintf('goalRadius = %d pixel\n',goalRadius)   % in pixel
% fprintf('\n')

% Define locations
xStart = 2*width/5;
yStart = mm2pixel(40, width, realWidth); 

degObjA = 0;
[xObjA, yObjA] = polar2cartesian(degObjA, objRadius, xStart, yStart);
[xGoalA, yGoalA] = polar2cartesian(degObjA, goalRadius, xStart, yStart);

degObjB = 45;
[xObjB, yObjB] = polar2cartesian(degObjB, objRadius, xStart, yStart);
[xGoalB, yGoalB] = polar2cartesian(degObjB, goalRadius, xStart, yStart);

degObjC = 90;
[xObjC, yObjC] = polar2cartesian(degObjC, objRadius, xStart, yStart);
[xGoalC, yGoalC] = polar2cartesian(degObjC, goalRadius, xStart, yStart);


% Set a big text size:
Screen('TextSize', win, 35);

% Draw shapes and text:
objSize  = 25;                 % in pixel
objColor = [0.3, 0.3, 0.3, 1]; % rgba

textColor = objColor; %[0.3, 0.3, 0.3, 1]; % rgba
objATextOffset = mm2pixel(25, width, realWidth);
goalATextOffset = mm2pixel(34, width, realWidth);
bTextOffset = mm2pixel(28, width, realWidth);
cTextOffset = mm2pixel(25, width, realWidth);

% Start
start = getSquare(xStart, yStart, 5);
Screen('FillRect', win, [0, 0, 0], start);
DrawFormattedText(win, 'Start', xStart, yStart, textColor, '', 1, 1, '', '');

% Object & Goal A
objA = getStar(xObjA, yObjA, objSize);
Screen('FillPoly', win, objColor, objA);
%[xTextObjA, yTextObjA] = polar2cartesian(degObjA, objRadius+textOffset, xStart, yStart);
drawText(win, 'A', xObjA+objATextOffset, yObjA, textColor);

goalA = getStar(xGoalA, yGoalA, objSize);
Screen('FillPoly', win, objColor, goalA);
%[xTextGoalA, yTextGoalA] = polar2cartesian(degObjA, goalRadius+textOffset, xStart, yStart);
drawText(win, 'Goal A', xGoalA+goalATextOffset, yGoalA, textColor);

% Object & Goal B
objB = getSquare(xObjB, yObjB, 3*objSize/4);
Screen('FillOval', win, objColor, objB);
[xTextObjB, yTextObjB] = polar2cartesian(degObjB, objRadius+bTextOffset, xStart, yStart);
drawText(win, 'B', xTextObjB, yTextObjB, textColor);

goalB = getSquare(xGoalB, yGoalB, 3*objSize/4);
Screen('FillOval', win, objColor, goalB);
[xTextGoalB, yTextGoalB] = polar2cartesian(degObjB, goalRadius+bTextOffset, xStart, yStart);
drawText(win, 'Goal B', xTextGoalB, yTextGoalB, textColor);

% Object & Goal C
objC = getDiamond(xObjC, yObjC, objSize);
Screen('FillPoly', win, objColor, objC);
%[xTextObjC, yTextObjC] = polar2cartesian(degObjC, objRadius+textOffset, xStart, yStart);
drawText(win, 'C', xObjC, yObjC+cTextOffset, textColor);

goalC = getDiamond(xGoalC, yGoalC, objSize);
Screen('FillPoly', win, objColor, goalC);
%[xTextGoalC, yTextGoalC] = polar2cartesian(degObjC, goalRadius+textOffset, xStart, yStart);
drawText(win, 'Goal C', xGoalC, yGoalC+cTextOffset, textColor);

end

%%% Helper functions
function pixel = mm2pixel(mm, totalWidthPx, totalWidthMm)

pixel = round(totalWidthPx / totalWidthMm * mm);

end

function [x, y] = polar2cartesian(degree, radius, offsetX, offsetY)
% Like pol2cart but with an offset built in

rad = deg2rad(degree);

[x,y] = pol2cart(rad, radius);
x = x + offsetX;
y = y + offsetY;

end

function triangle = getTriangle(xPos, yPos, size)

triangle = [...
    xPos      yPos+size;...
    xPos+size yPos-size;...
    xPos-size yPos-size];

end

function diamond = getDiamond(xPos, yPos, size)

diamond = [...
    xPos      yPos+size ;...
    xPos-size yPos      ;...
    xPos      yPos-size ;...
    xPos+size yPos      ];

end

function star = getStar(xPos, yPos, size)

half = (size - size/2) / 2;

star = [...
    xPos        yPos+size ;...
    xPos-half   yPos+half ;...
    xPos-size   yPos      ;...
    xPos-half   yPos-half ;...
    xPos        yPos-size ;...
    xPos+half   yPos-half ;...
    xPos+size   yPos      ;...
    xPos+half   yPos+half ];

end

function square = getSquare(xPos, yPos, size)

rct = [-size, -size, size, size]; % [left, top, right, bottom]
square = OffsetRect(rct, xPos, yPos);

end

function drawText(win, text, xPos, yPos, color)
% Draws the text such that xPos and yPos are the coordinates of the center
% of the texts bounding box. See: https://peterscarfe.com/boundingBox.html
% Does not quite work, because of the horizontal and vertical flipping.
% The height was off and adjusted using trial and error.

[~, ~, textBounds] = DrawFormattedText(win, text, 0, 0, color);
textWidth = range([textBounds(1) textBounds(3)]);
textHeight = range([textBounds(2) textBounds(4)]);

xPosCorrected = xPos - textWidth / 2;
yPosCorrected = yPos - textHeight - 3*textHeight/7;

DrawFormattedText(win, text, xPosCorrected, yPosCorrected, color, '',1,1,'','');

end