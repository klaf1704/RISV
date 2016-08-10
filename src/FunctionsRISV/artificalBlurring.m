function [status] = artificalBlurring(video_input, output_name, impair_level, num_frames, num_rows)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% articlaBlurring.m, v.2.1
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   07/2015 All Rights Reserved
%
% Creating Blurring Effect with regards to the ITU-T Rec. 930
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tStartblurrFrame = tic;
    
    video_in = VideoReader(video_input);
    video_out = VideoWriter(output_name);
    video_out.FrameRate = 25;
    open(video_out);
    
    %% Impulsrespones for diffenrent Impairment Level (1-6) from ITU-T Rec. 930
    imp_res_level_1 = [-1, 1, 3, 6, 10, 13, 15, 16, 15, 13, 10, 6, 3, 1, -1];
    imp_res_level_2 = [-2, -1, 1, 5, 9, 14, 17, 19, 17, 14, 9, 5, 1, -1, -2];
    imp_res_level_3 = [-3, -3, -1, 3, 8, 15, 20, 22, 20, 15, 8, 3, -1, -3, -3];
    imp_res_level_4 = [0, -3, -5, -3, 5, 15, 24, 28, 24, 15, 5, -3, -5, -3, 0];
    imp_res_level_5 = [2, 1, -4, -6, -1, 13, 28, 34, 28, 13, -1, -6, -4, 1, 2];
    imp_res_level_6 = [-2, 2, 4, -3, -9, 3, 31, 47, 31, 3, -9, -3, 4, 2, -2];
    % Level-7==> own filter respones for "stronger" blurring effect
    imp_res_level_7 = [-1, 1, 3, 6, 6, 10, 10, 13, 15, 15, 16, 18, 18, 20, 18, 18, 16, 15, 15, 15, 13, 10, 10, 6, 6, 3, 1, -1]; 
    %%
    if impair_level == 1
        imp_res = imp_res_level_1;
    elseif impair_level == 2
        imp_res = imp_res_level_2;
    elseif impair_level == 3
        imp_res = imp_res_level_3;
    elseif impair_level == 4
        imp_res = imp_res_level_4;
    elseif impair_level == 5
        imp_res = imp_res_level_5;
    elseif impair_level == 6
        imp_res = imp_res_level_6;
    elseif impair_level == 7 
        imp_res = imp_res_level_7;
    
    else 
        error('ERROR => Level Of Impairment Incorrect (Only 1 to 7 is valid')
    end

    %% Zeropadding 
    zpad=zeros(1, length(imp_res)); 
    % Borders for cutting after convolution
    front = ceil(length(imp_res) / 2); 
    back = floor(length(imp_res) / 2); 
    
    frame = double(read(video_in, 1));
    frameycbcr = double(zeros(size(frame)));
    frame_conv  = double(zeros(size(frame)));
    framergb = double(zeros(size(frame)));
    
    [z, ~] = size(frame);
    padding = zeros(z , length(zpad));
    frame_conv_padded =  [padding frame_conv(:, :, 1) padding];
    
    
    for f = 1 : num_frames
        %disp(['Frame: ' , int2str(f)])
        clear frame frame_block;
        frame = double(read(video_in, f));

        %% Convert Frame to YCBCR whole Frame at once
        [frameycbcr] = convertRGBtoYCBCR_frame(frame);

        zpad_Y_front = fliplr(frameycbcr(:, 1 : length(zpad), 1));
        zpad_Y_back = fliplr(frameycbcr(:, end - length(zpad) + 1 : end, 1));
        frame_ycbcr_padded = [zpad_Y_front frameycbcr(:, :, 1) zpad_Y_back];
        %% CONVOLUTION WITH IMPULSRESPONSE Row by Row

        for count_row = 1 : 1 : num_rows
            %disp(count_row);
            frame_row_y_padded = frame_ycbcr_padded(count_row, :, 1);
            row_tmp_y = (1 / (sum(imp_res)) * conv(double(imp_res), double(frame_row_y_padded)));
            frame_conv_padded(count_row, :, 1)  = row_tmp_y(front : end - back);
        end
        
        frame_conv_cut(:, :, 1) = frame_conv_padded(:, 1 + length(zpad) : end - length(zpad), 1 );
        frame_conv(:, :, 1) = frame_conv_cut(:, :, 1);
        frame_conv(:, :, 2 : 3) = frameycbcr(:, :, 2 : 3);  
        %% Convert Frame Back to RGB
        [framergb] = convertYCBCRtoRGB_frame(frame_conv);

    writeVideo(video_out, uint8(framergb));
    end
    close(video_out);
    status = 'finished';
    tEndblurrFrame = toc(tStartblurrFrame);
    disp(['Processing Time: ' num2str(tEndblurrFrame) 's']);
end
%%% E O F %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
