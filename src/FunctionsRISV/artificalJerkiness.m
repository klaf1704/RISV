function [status] = artificalJerkiness(video_input, num_frames, holdframe, output_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% artificalJerkiness, v.1.0
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   06/2015 All Rights Reserved
%
%   Jerkiness:  holdframe => Number of frame to be skipped
%               
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    video_in = VideoReader(video_input);
    video_out = VideoWriter(output_name);
    video_out.FrameRate = 25;
    open(video_out);

    %% Checking if the Input-Values are no char

    testtype1 = isnumeric(holdframe);
    if testtype1 == 0 
        error('Oops => Input Data Type Incorrect');
    end

    if holdframe > num_frames 
        error('ERROR => Number Of Frames To Skip, Larger Than Number Of Frames In The File')
    end
    %%
    for idx_frame = 1 : holdframe : num_frames
        if idx_frame+holdframe > num_frames
            break;
        end

        %disp(['Frame ', num2str(idx_frame)]);
        frame = read(video_in, idx_frame);

        for count_frame = 1 : holdframe
            writeVideo(video_out, frame);
        end    
        idx_nextstep = idx_frame + holdframe;
    end

    frame_last = read(video_in, idx_nextstep);

    while idx_nextstep <= num_frames
        %disp(['Frame ', num2str(idx_nextstep)]);
        writeVideo(video_out, frame_last);
        idx_nextstep = idx_nextstep + 1;
    end        

    close(video_out)
    status = 'finished';
end