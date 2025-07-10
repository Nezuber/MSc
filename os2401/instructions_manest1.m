function instructions_manest1(win)

xText = 400;
yText = 550;

line1 = 'Vor jeder Runde wird eine Scheibe auf die Position "Object" gelegt.';
line2 = 'Die Start und Endposition ist immer am schwarzen Zylinder, an dem Sie';
line3 = 'Zeigefinger und Daumen zu Beginn und Ende jeder Runde ablegen sollen.'; 
line4 = 'Eine Runde beginnt mit dem Oeffnen der Brille. Sobald die Brille aufgeht, sollen Sie sich'; 
line5 = 'den Durchmesser der Scheibe einpraegen und anschliessend so genau wie moeglich mit dem'; 
line6 = 'Zeigefinger und Daumen eine Einschaetzung machen, wie breit das Objekt ist.';

% % Set a big text size:
Screen('TextSize', win, 25);

DrawFormattedText(win, line1, xText, yText+100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line2, xText, yText+50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line3, xText, yText, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line4, xText, yText-50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line5, xText, yText-100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line6, xText, yText-150, [0 0 0],'',1,1,'','');
end