function [status] = Blurring_RowColumnsMovAverage(video_input, output_name, num_frames, num_rows,  num_columns, smooth_val)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Blurring_RowColumnsMovAverage.m, v.2.0
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   07/2015 All Rights Reserved
%
% Creating Blurring Effect with a moving average over rows 1st and columns
% 2nd. The Blurring Effect is created in all three layers (Red, Green, Blue)
% 
% smooth_val is number of pixel over which will be averaged 
% 
%   ToDo => Value Position after Average wrong stored, Image therefore
%   shifted!!!
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tStartblurrFrame = tic;

    video_in = VideoReader(video_input);
    video_out = VideoWriter(output_name);
    video_out.FrameRate = 25;
    open(video_out);

    %%
    frame = double(read(video_in, 1));
    framesmoo = double(zeros(size(frame)));
    framesmoo_vert = double(zeros(size(frame)));

    zpad=zeros(1, smooth_val-1); 

    for idx = 1 : 1 : num_frames
        %disp(['Frame ', num2str(idx)]);
        frame = double(read(video_in, idx));

        for count_row = 1 : 1 : num_rows % horizontal moving average
            %disp(count_row);
            zpad_red_front = fliplr(frame(count_row, 1 : length(zpad), 1));
            zpad_red_back = fliplr(frame(count_row, num_columns - length(zpad) + 1 : end, 1));
            pel_red = [zpad_red_front frame(count_row, :, 1) zpad_red_back];

            zpad_green_front = fliplr(frame(count_row, 1 : length(zpad), 2));
            zpad_green_back = fliplr(frame(count_row, num_columns - length(zpad) + 1 : end, 3));
            pel_green = [zpad_green_front frame(count_row, :, 2) zpad_green_back];

            zpad_blue_front = fliplr(frame(count_row, 1 : length(zpad), 3));
            zpad_blue_back = fliplr(frame(count_row, num_columns - length(zpad) + 1 : end, 3));
            pel_blue = [zpad_blue_front frame(count_row, :, 3) zpad_blue_back];

            ave_pel_red = filterung(pel_red, smooth_val); % Calling Filter Function
            ave_pel_green = filterung(pel_green, smooth_val);
            ave_pel_blue = filterung(pel_blue, smooth_val);

            framesmoo(count_row, :, 1) = ave_pel_red(1 + length(zpad) : length(ave_pel_red) - length(zpad));
            framesmoo(count_row, :, 2) = ave_pel_green(1 + length(zpad) : length(ave_pel_green) - length(zpad));
            framesmoo(count_row, :, 3) = ave_pel_blue(1 + length(zpad) : length(ave_pel_blue) - length(zpad));


        end
        for count_column = 1 : 1 : num_columns % vertical moving average
            %disp(count_row);
            zpad_red_front = fliplr(framesmoo(1 : length(zpad), count_column, 1));
            zpad_red_back = fliplr(frame(num_rows - length(zpad) + 1 : end, count_column, 1));
            pel_red = [zpad_red_front' framesmoo(:, count_column, 1)' zpad_red_back'];

            zpad_green_front = fliplr(framesmoo(1 : length(zpad), count_column, 2));
            zpad_green_back = fliplr(frame(num_rows - length(zpad) + 1 : end, count_column, 2));
            pel_green = [zpad_green_front' framesmoo(:, count_column, 2)' zpad_green_back'];

            zpad_blue_front = fliplr(framesmoo(1 : length(zpad), count_column, 3));
            zpad_blue_back = fliplr(frame(num_rows - length(zpad) + 1 : end, count_column, 3));
            pel_blue = [zpad_blue_front' framesmoo(:, count_column, 3)' zpad_blue_back'];

            ave_pel_red = filterung(pel_red, smooth_val);
            ave_pel_green = filterung(pel_green, smooth_val);
            ave_pel_blue = filterung(pel_blue, smooth_val);
            
%              framestest(:, count_column, 1) = ave_pel_red';
%              framestest(:, count_column, 2) = ave_pel_green';
%              framestest(:, count_column, 3) = ave_pel_blue';
            
            framesmoo_vert(:, count_column, 1) = ave_pel_red(1 + length(zpad) : length(ave_pel_red) - length(zpad))';
            framesmoo_vert(:, count_column, 2) = ave_pel_green(1 + length(zpad) : length(ave_pel_red) - length(zpad))';
            framesmoo_vert(:, count_column, 3) = ave_pel_blue(1 + length(zpad) : length(ave_pel_red) - length(zpad))';

        end
%        writeVideo(video_out, uint8(framestest));
        writeVideo(video_out, uint8(framesmoo_vert));
    end
    close(video_out);
    status = 'File   Finished';
    tEndblurrFrame = toc(tStartblurrFrame);
    disp(['Processing Time: ' num2str(tEndblurrFrame) 's']);
end
%% E O F

