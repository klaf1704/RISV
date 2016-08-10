function [num_frames, num_rows, num_columns] = readVideoInput(input_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% readVideoInput v.1
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   06/2015 All Rights Reserved
%
% This function reads videofiles
%   Input   => Name of a videofile as string e.g. 'Testvideo.avi'
%
%   Output  =>  Number of Frames in the Video
%               Number of Rows (same as number of pixel vertical)
%               Number of Columns (same as number of pixel horizontal )
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Input Videofile
    video = VideoReader(input_name);

%% extract Videoinformations:
    num_frames  = video.NumberOfFrames;
    num_rows    = video.Height;
    num_columns = video.Width;
end

