function calibpositions()

%Ask for rigid-body:
a=ask_and_get_answerchar('Did you connect the digitizer tool? (y=yes; q=quit) ','yq');
if a=='q'
  error('You are quitting, successfully, IGNORE THIS ERROR MESSAGE!!!');
end

epar=expSettings;

%Give Info: 
fprintf('----------------------------------------------------------------------\n');
fprintf('Number of markers for calibration: %3i\n',epar.DigitizeColl.NumMarkers);
fprintf('First marker of Digitizer Tool:    %3i\n',epar.Digitize.StartMarker);
fprintf('----------------------------------------------------------------------\n');

%Start optotrak:
optostart(epar.CAMFile,epar.DigitizeColl);
optotrak('RigidBodyAddFromFile',epar.Digitize);
pause(1);
optotrak('OptotrakActivateMarkers');

%Measure positions:
RightStartPos =optoMeasurePosition('Right Start Position',epar.calibpositionsNcollect,epar.calibpositionsMaxStd,epar.DigitizeColl.NumMarkers,epar.NumRigids);
RightGoalPos  =optoMeasurePosition('Right Goal Position' ,epar.calibpositionsNcollect,epar.calibpositionsMaxStd,epar.DigitizeColl.NumMarkers,epar.NumRigids);
% LeftStartPos =optoMeasurePosition('Left Start Position',epar.calibpositionsNcollect,epar.calibpositionsMaxStd,epar.DigitizeColl.NumMarkers,epar.NumRigids);
% LeftGoalPos  =optoMeasurePosition('Left Goal Position' ,epar.calibpositionsNcollect,epar.calibpositionsMaxStd,epar.DigitizeColl.NumMarkers,epar.NumRigids);


%Save positions:
disp(['Writing positions to: ',epar.GeneralPosFile]);
save(epar.GeneralPosFile,...
     'RightStartPos',...
     'RightGoalPos');
 %   'LeftStartPos',... 'LeftGoalPos');
optostop();
%sca;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Subfunctions:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function PosMean=optoMeasurePosition(Name,Ncollect,MaxStd,NumMarkers,NumRigids)
%We assume that one rigid body is initialized, which is at index RigidIndex.

%Settings:
RigidIndex = 1;%Index of RB in returned cell array:

%Measure experimental positions:
success=false;
while(~success)
  input(['Place rigid body at ',Name,' and press RETURN!']) 
  fprintf('Collecting data:\n')
  for i = 1:Ncollect
    odata=optotrak('DataGetNextTransforms',NumMarkers,NumRigids);
    Pos(:,i)=odata.Rigids{RigidIndex}.Trans;
  end
  PosMean=mean(Pos')'
  PosSD=std(Pos')'
  if(max(PosSD)>MaxStd)
    disp('Variability too large, try again')
  elseif(max(isnan(PosMean))==1)
    disp('Missing values not allowed, try again')
  else
    success=true;
  end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
