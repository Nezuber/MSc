 function epar=expSettings
%Returns ALL settings of experiment in struct epar. 

%General stuff:
epar.ExpName                 ='os2401';
epar.UseCatchLoop            = false;%true => for debugging (see: expdriver_RunTask)
epar.CAMFile                 = [epar.ExpName,'calibcoor'];
epar.GeneralPosFile          = './data/positions.mat';

%Optotrak-collection for experiment:
epar.ExpColl.NumMarkers             =  6;%2; %Number of markers in the collection.         
epar.ExpColl.FrameFrequency         =200; %Frequency to collect data frames at.          
epar.ExpColl.CollectionTime         =  3.5; %Number of seconds of data to collect.        
epar.ExpColl.Flags={'OPTOTRAK_BUFFER_RAW_FLAG'};
epar.RightFinger.Marker             =  2; %Finger marker
epar.RightThumb.Marker              =  1; %Thumb marker

%Optotrak-collection for calibcoor:
epar.CalibColl.NumMarkers        =  6; %Number of markers in the collection.         
epar.CalibColl.FrameFrequency    =100; %Frequency to collect data frames at.          
epar.TableMarkersOrigin          = 3; 
epar.TableMarkersxDir            = 4;
epar.TableMarkersxyPlane         = 5;
epar.calibcoorNcollect           = 100;
epar.calibcoorMaxStd             = 0.1;

%Optotrak-collection for calibpositions:
epar.DigitizeColl.NumMarkers     =  4; %Number of markers in the collection.         
epar.DigitizeColl.FrameFrequency =100; %Frequency to collect data frames at.          
epar.NumRigids                   =  1; %only change together with RigidBodyAddFromFile!!!
epar.Digitize.RigidBodyIndex     =  1; %only change together with RigidBodyAddFromFile!!!
epar.Digitize.StartMarker        =  1; %First marker in the rigid body
epar.Digitize.RigFile            = 'C:/cygwin64/home/Kriti/vflab/OptotrakToolbox/rigid-body-definitions/2010-12-17-digitizer-probe.rig';%RIG file containing rigid body coordinates
epar.Digitize.Flags              = {'OPTOTRAK_RETURN_MATRIX_FLAG'};
epar.calibpositionsNcollect      = 100;
epar.calibpositionsMaxStd        = 0.1;

%Settings for all tasks:
epar.PresentationTime        = 3; %sec, presentation of stimuli

%Grasp task:
epar.TooEarlyTime            = 100; %[msec]
epar.StartPosTolerance       =  40; %[mm], only used in experimental run
epar.GoalPosTolerance        =  80; %[mm], only used in experimental run

%%Settings for input/output during experiment:
%DataTranslation USB device:

epar.leftKeyIndex = 1;
epar.rightKeyIndex = 2;

%Settings for util_eval:
epar.StartVFVelCrit          =0.025;%[mm/msec=m/sec] Start of movement
epar.ZTolerance              =    5;%[mm] New way to determine when touched object
epar.GoalDistCrit            =   60;%[mm] ... needs also: distance to goal object
epar.MinRTVF                 = 100; %msec
epar.MaxRTVF                 =1000; %msec
epar.MinMTVF                 = 250; %msec
epar.MaxMTVF                 =2000; %msec % before os2401 1500

%Settings for evaluate:
epar.ManEstSubjects = [1:36]; 
% epar.GraspSubjects  = [20:24,27:36];
epar.GraspSubjects  = [1:36];
epar.PercSubjects = [1:36];

