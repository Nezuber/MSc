function instructions_perc(win)

xText = 400;
yText = 550;

line1 = 'Vor jeder Runde werden zwei Scheiben auf die Positionen "L" und "R" gelegt.';
line2 = 'Eine Runde beginnt mit dem Oeffnen der Brille. Sobald die Brille aufgeht, ';
line3 = 'sollen Sie entsprechend der Fragestellung einschaetzen welches der Objekte groesser (oder kleiner) ist.';
line4 = 'Diese Einschaetzung machen Sie anhand der Position der Objekte und den entsprechenden Knoepfen.';
line5 = 'Eine Runde dauert maximal 2 Sekunden und endet mit dem Schliessen der Brille.';


% Draw text:
% drawPositions(win)

% % Set a big text size:
Screen('TextSize', win, 25);

DrawFormattedText(win, line1, xText, yText+100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line2, xText, yText+50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line3, xText, yText, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line4, xText, yText-50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line5, xText, yText-100, [0 0 0],'',1,1,'','');
end