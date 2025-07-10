function evaluate()
%Generate for each task an output file with the result of the evaluation:
%Containing for each trial one line.

%General settings of experiments:
epar=expSettings;

t='';
cond ='';
block='';

%Run for each task:
for Task = {'ManEst','Grasp','Perc','ExPerc'}
    Task=char(Task);
    SubFiles=expSubFileNames(Task);

    %Determine subjects and output file for evaluation:
    if(contains(Task,'Grasp'))
        EvalFile=SubFiles.EvalGrasp;
        Subjects=epar.GraspSubjects;
    elseif(strcmp(Task,'ManEst'))
        EvalFile=SubFiles.EvalManEst;
        Subjects=epar.ManEstSubjects; 
    elseif(strcmp(Task, 'Perc'))
        EvalFile=SubFiles.EvalPerc;
        Subjects=epar.PercSubjects;
    elseif(strcmp(Task, 'ExPerc'))
        EvalFile=SubFiles.EvalExPerc;
        Subjects=epar.ExPercSubjects;
    else
        error('Wrong task')
    end 

    %Open EvalFile for output:
    fid = fopen(EvalFile,'w');

    %%Write header line:
    fprintf(fid,'Sub  Trial   Group    Task  Block  Errors      Stimuli');
    if(strcmp(Task,'ManEst'))
        fprintf(fid,'      ManEst');
%         fprintf(fid,'    ManEstTime');
%         fprintf(fid,'    G12FGAp');
        fprintf(fid,'        RT');
%         fprintf(fid,'       MT');
%         fprintf(fid,'    GGManEst');
%         fprintf(fid,'    GGManEstTime');
%         fprintf(fid,'      GGRT');
        fprintf(fid,'   G12ManEst');
%         fprintf(fid,'    G12GGManEst');
        fprintf(fid,' FGApApproved');
    elseif(strcmp(Task,'Grasp'))
        fprintf(fid,'    MaxAp');
%         fprintf(fid,'     MaxApTime');
%         fprintf(fid,'       G12FGAp');
        fprintf(fid,'        RT');
%         fprintf(fid,'  TouchedAp');
%         fprintf(fid,'  TouchedTime');
%         fprintf(fid,'       GGRT');
        fprintf(fid,'  G12MaxAp');
%         fprintf(fid,'  G12TouchedAp');
        fprintf(fid,' FGApApproved');
    elseif(strcmp(Task,'Perc'))
        fprintf(fid,'  Subtask');
        fprintf(fid,'       RT');
        fprintf(fid,'   Response');
        fprintf(fid,'  Accuracy');
    elseif(strcmp(Task,'ExPerc'))
        fprintf(fid,'       RT');
        fprintf(fid,'   Response');
        fprintf(fid,'  Accuracy');
    else
        error('Wrong task')
    end
    
    fprintf(fid,'\n');

    %%Write for each subject and trial one data line:
    for Sub = Subjects
        if(strcmp(Task,'Grasp')||strcmp(Task,'ManEst'))
            CurrNoTrials=length(dir(['data/' subnos(Sub) '/' Task '/' epar.ExpName '_MAT3D.*']));
        elseif (strcmp(Task,'Perc')||strcmp(Task,'ExPerc'))
            CurrNoTrials=length(dir(['data/' subnos(Sub) '/' Task '/' epar.ExpName '_MAT.*']));
        end
        
        % average final grip per block for calculating aperture without
        % fingers (as described in Ganel et al. 2012)
        % CHANGEHERE: if number of blocks changes, adapt this!
        if(contains(Task,'Grasp')||strcmp(Task,'ManEst'))
            sumFGApBl1 = 0; % summation of (not nan) final grip apertures for block 1
            sumFGApBl2 = 0;
            sumFGApBl3 = 0;
            sumFGApBl4 = 0;
            c1 = 0;
            c2 = 0;
            c3 = 0;
            c4 = 0;
            for Trial = 1:CurrNoTrials
                fprintf('===PRE-CALCULATION===\n')
                [odata,eval]=util_eval(Sub,Task,Trial);
                
                disp(eval.LeftDiscAreaAp) 
                    if (contains(eval.BlTp,'1') && ~isnan(eval.LeftDiscAreaAp)) && eval.FGApApproved
                        sumFGApBl1 = sumFGApBl1 + eval.LeftDiscAreaAp;
                        c1 = c1 + 1;
                    elseif (contains(eval.BlTp,'2') && ~isnan(eval.LeftDiscAreaAp)) && eval.FGApApproved
                        sumFGApBl2 = sumFGApBl2 + eval.LeftDiscAreaAp;
                        c2 = c2 + 1;
                    elseif (contains(eval.BlTp,'3') && ~isnan(eval.LeftDiscAreaAp)) && eval.FGApApproved
                        sumFGApBl3 = sumFGApBl3 + eval.LeftDiscAreaAp;
                        c3 = c3 + 1;
                    elseif (contains(eval.BlTp,'4') && ~isnan(eval.LeftDiscAreaAp)) && eval.FGApApproved
                        sumFGApBl4 = sumFGApBl4 + eval.LeftDiscAreaAp;
                        c4 = c4 + 1;
                    else
                        disp('!')
                    end       
            end
            avgFGApBl1 = sumFGApBl1 / c1;
            avgFGApBl2 = sumFGApBl2 / c2;
            avgFGApBl3 = sumFGApBl3 / c3;
            sumFGApBl4 = sumFGApBl4 / c4;
            
            % subtract smaller disk size to get finger width
            G12FWBl1 = avgFGApBl1 - 40; 
            G12FWBl2 = avgFGApBl2 - 40;
            G12FWBl3 = avgFGApBl3 - 40;
            G12FWBl4 = sumFGApBl4 - 40;
        end
        
        for Trial = 1:CurrNoTrials
            fprintf('======================================================================\n')
            [odata,eval]=util_eval(Sub,Task,Trial);
            %get task, subtask and error count
            if strfind(eval.BlTp,'P')
                tsk='Perc';
                errors = eval.errorCount('P');
                if strfind(eval.BlTp,'S')
                    subtsk='S';
                elseif strfind(eval.BlTp,'L')
                    subtsk='L';
                end
            elseif strfind(eval.BlTp,'E')
                tsk='ExPerc';
                errors = eval.errorCount('E');
            elseif strfind(eval.BlTp,'G')
                tsk='Grasp';
                errors = eval.errorCount('G');
            elseif strfind(eval.BlTp,'M')
                tsk='ManEst';
                errors = eval.errorCount('M');
            end

            %get block number
            if strfind(eval.BlTp,'1')
                block='1';
                G12FW = G12FWBl1;
            elseif strfind(eval.BlTp,'2')
                block='2';
                G12FW = G12FWBl2;
            elseif strfind(eval.BlTp,'3')
                block='3';
                G12FW = G12FWBl3;
            elseif strfind(eval.BlTp,'4')
                block='4';
                G12FW = G12FWBl4;                
            end
            
            %Write evaluation to outfile:
            fprintf(fid,'%3i %6i %7s %7s %6s %7i %12s',Sub,Trial,eval.GrTp,tsk,block,errors,eval.TrTp);
            if(strcmp(Task,'ManEst'))
                fprintf(fid,'     %7.2f', eval.ManEstAp);                   %ManEst
                fprintf(fid,'   %11.2f', eval.ManEstTime);                  %ManEstTime
%                 fprintf(fid,'   %8.2f',  eval.LeftDiscAreaAp);              %G12FGAp
                fprintf(fid,' %9.2f', eval.StartVFTime);                    %RT
%                 fprintf(fid,' %8.2f', eval.MTVF);                           %MT
%                 fprintf(fid,'    %8.2f', eval.GGManEstAp);                  %GGManEst
%                 fprintf(fid,'     %11.2f', eval.GGManEstTime);              %GGManEstTime
%                 fprintf(fid,' %9.2f', eval.StartGGTime);                    %GGRT
                fprintf(fid,'     %7.2f', eval.ManEstAp - G12FW);           %G12ManEst
%                 fprintf(fid,'       %8.2f',  eval.GGManEstAp - G12FW);      %G12GGManEst
                fprintf(fid,'            %1s',  eval.FGApApproved);         %FGApApproved
            elseif(strcmp(Task,'Grasp'))
                fprintf(fid,'   %6.2f', eval.MaxAp);                        %MaxAp
%                 fprintf(fid,'      %8.2f', eval.MaxApTime);                 %MaxApTime
%                 fprintf(fid,'      %8.2f',  eval.LeftDiscAreaAp);           %G12FGAp
                fprintf(fid,' %9.2f', eval.StartVFTime);                    %RT
%                 fprintf(fid,'  %9.2f', eval.TouchedVFAp);                   %TouchedAp
%                 fprintf(fid,'  %11.2f', eval.TouchedVFTime);                %TouchedTime
%                 fprintf(fid,' %10.2f', eval.StartGGTime);                   %GGRT
                fprintf(fid,'   %7.2f', eval.MaxAp - G12FW);                %G12MaxAp
%                 fprintf(fid,'     %9.2f', eval.TouchedVFAp - G12FW);        %G12TouchedAp
                fprintf(fid,'            %1s',  eval.FGApApproved);         %FGApApproved
            elseif(strcmp(Task,'Perc'))
                fprintf(fid,'        %1s', subtsk);
                fprintf(fid,'  %7.2f', eval.RTVF);
                fprintf(fid,'  %9s', eval.PercEst); 
                fprintf(fid,'  %8s', eval.Corr); 
            elseif(strcmp(Task,'ExPerc'))
                fprintf(fid,'  %7.2f', eval.RTVF);
                fprintf(fid,'  %9s', eval.PercEst); 
                fprintf(fid,'  %8s', eval.Corr); 
            end
            fprintf(fid,'\n');
        end
    end

%Close EvalFile:
fclose(fid);
end
