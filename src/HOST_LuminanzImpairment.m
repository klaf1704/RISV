%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HELL und DUNKEL machen
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   12/2015 All Rights Reserved
%
% TO BE CONT....
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%B E G I N    C O D E 
%% HEAD
clc; clear all; close all

%% Add Source and Target Directories, Add "Function-Folder"
    tmp = dir('ProcessedFiles');
    if isempty(tmp)
        mkdir('ProcessedFiles');
    end
    
    tmp = dir('Sourcefiles');
    if isempty(tmp)
        mkdir('Sourcefiles');
    end
    
    addpath('Sourcefiles');
    addpath('ProcessedFiles');
    addpath('FunctionsRISV');
    clear tmp;
    %%
    addpath('Basteln und Beispiele')
    
%% Reading Source Files Names
    folder = ['*.avi'];
    videodata = dir(folder); 
    
%% Input Processing Parameter
    disp('------- Impairment Type --------');
    disp('--------------------------------');
    disp('Überbelichtet und Unterbelichtet');
    impairment = input('Please Input Type (''hell'' od ''dunkel''): ');

%% 
tStartOverall = tic;
        disp(' ');
        wait = waitbar(0,'Please Wait - File Processing ...');
        
        for i = 1:length(videodata)
            disp(['Processing File: ' num2str(i)]); 
            video_input = videodata(i).name;         
            tmpname = strrep(video_input, '.avi','');
            %output_name = ['ProcessedFiles\' tmpname , impairment '.avi'];             
            output_name = [tmpname , impairment '.avi'];             
            [num_frames, num_rows, num_columns] = readVideoInput(video_input);
            
            [status] = luminanz_impairment(video_input, num_frames, ...
                               num_rows, num_columns, impairment, output_name);
            disp(['Processing File: "', output_name ,'" ' status]);
            waitbar(i / length(videodata));
        end
        close(wait)    
    
%%
disp('File Processing Finished');
tEndOverall = toc(tStartOverall);
disp(['Processing Time: ' num2str(tEndOverall) 's']);

%%% E N D   O F   F I L E 