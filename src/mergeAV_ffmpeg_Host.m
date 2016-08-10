%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mergeAV_ffmpeg_Host, v.1.0
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   08/2015 All Rights Reserved
%
%   This Script is the host script for merging 
%   a video signal and an audio signal via ffmpeg
%   
%   It compare the files to find the matching ones
%   And calls the "merging-function" => mergeAV_ffmpeg
%
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% E.G.: WORKS FINE FOR ONE FILE:
% !ffmpeg -i testfile_jerki_7_blocki_20_framesimp_35_blocksimp_30.avi -i testfile.avi -c:v copy -c:a aac -strict experimental -map 0:v:0 -map 1:a:0 output_Q1.mp4 
%% Clean up!
clc; clear all; close all;

%% Add Path to find Files
addpath('Sourcefiles');
addpath('ProcessedFiles');
 
data_source = dir('Sourcefiles');
data_impaired = dir('ProcessedFiles');
%data_impaired = dir('SET_YOUR_PATH_HEAR');

dataname_source = {data_source.name};
dataname_source = dataname_source(3 : end);
dataname_impaired = {data_impaired.name};
dataname_impaired = dataname_impaired(3 : end);

%% Loops for searching through the Filenames to find Sourcefile of the Imp.-File
for n = 1 : length(dataname_impaired)
    tmpname_imp = cellstr(dataname_impaired{1, n});
    tmpname_imp = tmpname_imp{1, 1};
    tmpname_imp_full = tmpname_imp;
    tmpname_imp = tmpname_imp(1 : 6);
    
    for i = 1:length(dataname_source)
        tmpname_source = cellstr(dataname_source{1, i});
        tmpname_source = tmpname_source{1, 1};
        tmpname_source_full = tmpname_source;
        tmpname_source = tmpname_source(1 : 6);
    
        q = strcmp(tmpname_imp, tmpname_source); % equal ==> q = 1
        if q == 1
            % call merge-function 
            [status, mergedFilename] = mergeAV_ffmpeg(tmpname_imp_full, tmpname_source_full);
            target = ['ProcessedFiles\', mergedFilename];
            movefile(mergedFilename, target);
            disp(status);
        end
    end
end
disp('Coding Finished ==> J O B   D O N E')

%%% E O F %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%