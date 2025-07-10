function instructions_manest2(win)

xText = 400;
yText = 550;

line1 = 'Diese Einschaetzung machen Sie, indem Sie mit den Zeigefinger und Daumen die Breite';
line2 = 'an dem Punkt "Manual Estimation" aufspannen und Ihre Einschaetzung mit dem Druecken';
line3 = 'einer der Knoepfe bestaetigen. Anschliessend sollen Sie die Scheibe mit Zeigefinger';
line4 = 'und Daumen kontrolliert greifen und auf den Zielpunkt "Goal" legen.';
line5 = 'Eine Runde endet damit, dass Sie immer wieder zu dem';
line6 = 'Startpunkt zurueckkehren und die Brille sich schliesst.';
line7 = 'Eine Runde dauert 2 Sekunden und endet mit dem Schliessen der Brille.';


% % Set a big text size:
Screen('TextSize', win, 25);

DrawFormattedText(win, line1, xText, yText+100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line2, xText, yText+50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line3, xText, yText, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line4, xText, yText-50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line5, xText, yText-100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line6, xText, yText-150, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line7, xText, yText-200, [0 0 0],'',1,1,'','');
end