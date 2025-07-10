function calibcoor

%Ask for normal, experiment-markers:
a=ask_and_get_answerchar('Did you connect the normal experiment-markers? (y=yes; q=quit) ','yq');
if a=='q'
  error('You are quitting, successfully, IGNORE THIS ERROR MESSAGE!!!');
end

%Settings:
OldCAMFile ='standard';

%Read general settings of experiments:
epar=expSettings;

%Give Info: 
fprintf('----------------------------------------------------------------------\n');
fprintf('Old camera parameter file: c:\\ndigital\\realtime\\%s\n',OldCAMFile);
fprintf('We attempt to generate   : c:\\ndigital\\realtime\\%s\n',epar.CAMFile);
fprintf('Number of markers for calibration: %3i\n',epar.CalibColl.NumMarkers);
fprintf('   new origin is marker:      %3i\n',epar.TableMarkersOrigin);
fprintf('   new x-direction is marker: %3i\n',epar.TableMarkersxDir);
fprintf('   new xy-plane is marker:    %3i\n',epar.TableMarkersxyPlane);
fprintf('----------------------------------------------------------------------\n');

%Start optotrak:
optostart(OldCAMFile,epar.CalibColl);
optotrak('OptotrakActivateMarkers');

%Measure positions:
[OriginMean,xDirMean,xyPlaneMean]=...
    optoMeasureTableMarkers(epar.calibcoorNcollect,epar.calibcoorMaxStd,epar.CalibColl.NumMarkers,...
                            epar.TableMarkersOrigin,epar.TableMarkersxDir,epar.TableMarkersxyPlane);

%Transform the frame of reference: OldCAMFile -> epar.CAMFile:
result=optotrakEasyChangeCameraFOR(OldCAMFile,epar.CAMFile,OriginMean,xDirMean,xyPlaneMean);
disp(['RmsError: ',num2str(result.RmsError)]);

%... finish
optostop;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Subfunctions:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [OriginMean,xDirMean,xyPlaneMean]=optoMeasureTableMarkers(Ncollect,MaxStd,NumMarkers,OriginNo,xDirNo,xyPlaneNo)

%Measure table-markers:
success=false;
while(~success)
  input(['To measure the table markers, press RETURN!']) 
  for i = 1:Ncollect
    data=optotrak('DataGetNext3D',NumMarkers);
    Origin(:,i)=data.Markers{OriginNo};
    xDir(:,i)=data.Markers{xDirNo};
    xyPlane(:,i)=data.Markers{xyPlaneNo};
  end
  OriginMean=mean(Origin')'
  xDirMean=mean(xDir')'
  xyPlaneMean=mean(xyPlane')'
  OriginSD=std(Origin')'
  xDirSD=std(xDir')'
  xyPlaneSD=std(xyPlane')'
  if(max([OriginSD;xDirSD;xyPlaneSD])>MaxStd)
    disp('Variability too large, try again')
  elseif(max(isnan([OriginMean;xDirMean;xyPlaneMean]))==1)
    disp('Missing values not allowed, try again')
  else
    success=true;
  end
end

