function [status, mergedFilename] = mergeAV_ffmpeg(impaired, source)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% mergeAV_ffmpeg, v.1.0
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   08/2015 All Rights Reserved
%
%   This Function is for merging a video signal and an audio signal
%   via ffmpeg.
%
%   It builds a string that contains all needed ffmpeg commandos and
%   runs ffmpeg. 
%
%   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    impaired_file = ['ProcessedFiles\',impaired];
    source_file = ['Sourcefiles\',source];
    
    ffmpeg_string_AVmerge = ['ffmpeg -i ', impaired_file ,' -i ' ,source_file ,' -c:v copy -c:a copy -map 0:v:0 -map 1:a:0 ' , ' AV', impaired];
    dos(ffmpeg_string_AVmerge);
    
    mergedFilename = ['AV', impaired];
    status = 'd o n e';
end
%%% E O F %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%