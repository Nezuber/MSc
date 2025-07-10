function instructions_experc(win)

xText = 400;
yText = 550;

line1 = 'Vor jeder Runde wird eine Scheibe auf die Position "Object" gelegt.';
line2 = 'Eine Runde beginnt mit dem Oeffnen der Brille. Sobald die Brille aufgeht, ';
line3 = 'sollen Sie einschaetzen ob das Objekt eher groess oder eher klein ist im';
line4 = 'Vergleich zu den bisher gesehenen Objekten. Diese Einschaetzung';
line5 = 'machen Sie mit den entsprechenden Knoepfen (Links "klein", Rechts "gross").';
line6 = 'Eine Runde dauert maximal 2 Sekunden und endet mit dem Schliessen der Brille.';


% Draw text:
% drawPositions(win)

% % Set a big text size:
Screen('TextSize', win, 25);

DrawFormattedText(win, line1, xText, yText+100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line2, xText, yText+50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line3, xText, yText, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line4, xText, yText-50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line5, xText, yText-100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line6, xText, yText-150, [0 0 0],'',1,1,'','');
end