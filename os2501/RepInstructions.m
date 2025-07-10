function RepInstructions(win, BlTp)

xText = 400;
yText = 550;

% % Set a big text size:
Screen('TextSize', win, 25);

% new text:

line13 = 'Ein Abschnitt ist fertig. Sie koennen eine Pause machen.';

if(contains(BlTp,'G')||contains(BlTp,'M'))
    line14 = 'Wichtig: Versuchen Sie die Bewegung so kontrolliert wie moeglich zu machen.';
else
    line14 = '';
end
line15 = 'Sind Sie bereit?';

% Draw text:
% drawPositions(win)
DrawFormattedText(win, line13, xText, yText+50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line14, xText, yText-50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line15, xText, yText-150, [0 0 0],'',1,1,'','');


end