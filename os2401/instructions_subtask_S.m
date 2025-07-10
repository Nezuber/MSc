function instructions_subtask_S(win)

xText = 400;
yText = 550;

line1 = 'Die Fragestellung lautet:'; 
line2 = 'Welche Scheibe ist kleiner?'; 

% % Set a big text size:
Screen('TextSize', win, 25);

DrawFormattedText(win, line1, xText, yText+100, [0 0 0],'',1,1,'','');
DrawFormattedText(win, line2, xText, yText+50, [0 0 0],'',1,1,'','');

end