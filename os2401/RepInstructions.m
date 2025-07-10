function RepInstructions(win)

xText = 400;
yText = 550;


% new text:

line13 = 'Ein Abschnitt ist fertig. Sie koennen eine Pause machen.';
line14 = 'Wichtig: Versuchen Sie die Einschaetzung so kontrolliert wie moeglich zu machen.';
line15 = 'Sind Sie bereit?';

% Draw text:
% drawPositions(win)

% % Set a big text size:
Screen('TextSize', win, 25);

DrawFormattedText(win, line13, xText, yText+50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line14, xText, yText-50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line15, xText, yText-150, [0 0 0],'',1,1,'','');


end