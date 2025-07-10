function instructions_ready(win)

xText = 400;
yText = 550;


% new text:

line13 = 'Das Experiment ist in 4 Abschnitte unterteilt mit jeweils 32 Runden.';
line14 = 'Wichtig: Versuchen Sie die Einschaetzung so kontrolliert wie moeglich zu machen.';
line15 = 'Sind Sie bereit?';

% Draw text:
% drawPositions(win)

% % Set a big text size:
Screen('TextSize', win, 25);

DrawFormattedText(win, line13, xText, yText+50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line14, xText, yText, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line15, xText, yText-100, [0 0 0],'',1,1,'','');


end