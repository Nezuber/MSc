function instructions_grasp(win)

xText = 400;
yText = 550;

line1 = 'Vor jeder Runde wird eine Scheibe auf die Position "Object" gelegt.'; 
line2 = 'Die Start und Endposition ist immer am schwarzen Zylinder, an dem Sie'; 
line3 = 'Zeigefinger und Daumen zu Beginn und Ende jeder Runde ablegen sollen.'; 
line4 = 'Eine Runde beginnt mit dem Oeffnen der Brille.';
line5 = 'Sobald die Brille aufgeht, sollen Sie die Scheibe mit'; 
line6 = 'Zeigefinger und Daumen kontrolliert greifen und auf den Zielpunkt "Goal" legen.'; 
line7 = 'Eine Runde endet damit, dass Sie immer wieder zu dem';
line8 = 'Startpunkt zurueckkehren und die Brille sich schliesst.';
line9 = 'Eine Runde dauert 2 Sekunden und endet mit dem Schliessen der Brille.';

% % Set a big text size:
Screen('TextSize', win, 25);

DrawFormattedText(win, line1, xText, yText+100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line2, xText, yText+50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line3, xText, yText, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line4, xText, yText-50, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line5, xText, yText-100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line6, xText, yText-150, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line7, xText, yText-200, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line8, xText, yText-250, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line9, xText, yText-300, [0 0 0],'',1,1,'','');


end