function [status] = artificalEdgeBusyness(video_input, output_name, val_res, num_frames, num_rows, num_columns)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% artificialEdgeBusyness.m, v.1
%
% ? Technische Universit?t Berlin, Germany
%   10/2015 All Rights Reserved
%
% Creating Edge Busyness Effect with regards to the ITU-T Rec. 930
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tStartedgebFrame = tic;
video_in = VideoReader(video_input);
video_out = VideoWriter(output_name);
video_out.FrameRate = 50;
open(video_out);



%% Impulse respones for diffenrent Impairment Level from ITU-T Rec. 930
% The program will always apply the three layers of impairment.
% However, the user is requested to choose the level of its echo
% displacement through the impulse response value between -1 and -30.

imp_res_level_1 = [0, 0, 0, val_res, 0, 0, 175, 0, 0, val_res, 0, 0, 0]; %0.375 Echo Displacement (ms)
imp_res_level_2 = [0, 0, val_res, 0, 0, 0, 175, 0, 0, 0, val_res, 0, 0]; %0.5 Echo Displacement (ms)
imp_res_level_3 = [val_res, 0, 0, 0, 0, 0, 175, 0, 0, 0, 0, 0, val_res]; %0.75 Echo Displacement (ms)

%% Check if the input value is contained in -1 -30 and if its a char.

testtype1 = isnumeric(val_res);
if testtype1 == 0
    error('Oops => Input Data Type Incorrect');
end

if val_res > -1 || val_res < -30
    error('ERROR => Impairment Number Incorrect');
end
%%

effect = imp_res_level_1;
zpad = zeros(1, length(effect));
front = ceil(length(effect)/2);
back = floor(length(effect)/2);
frame = double(read(video_in, 1));
frameycbcr = double(zeros(size(frame)));
frame_conv  = double(zeros(size(frame)));
framergb = double(zeros(size(frame)));
frame_ycbcr_padded = frame_conv;

[z, ~] = size(frame);
padding = zeros(z, length(zpad));
padding2 = zeros(length(zpad), num_columns);
frame_conv_padded =  [padding frame_conv(:,:,1) padding];
frame_conv_padded2 =  [padding2; frame_conv(:,:,1); padding2];
frame_y_padded = [padding frame_conv(:,:,1) padding];
%%

for f = 1:num_frames
%<<<<<<< HEAD
    if mod(f,5) == 0
        k = k + 1;
        if k == 4
            k = 1;
        end
    end
    %disp(f)
    effectStr = 'imp_res_level_';
    effectStr = strcat(effectStr, int2str(k));
    %disp(effectStr);
%=======
    k = randi ([1 3]);
    effectStr = 'imp_res_level_';
    effectStr = strcat(effectStr, int2str(k));
%>>>>>>> 40564474cddcf90ed76b3a132bfbee7d66713e33
    effect = eval(effectStr);
    %% Frame Treatment
    
    frame = double(read(video_in, f));
    %% Convert Frame to YCBCR whole Frame at once
    
    [frameycbcr] = convertRGBtoYCBCR_frame(frame);
    zpad_Y_front = fliplr(frameycbcr(:, 1 : length(zpad), 1));
    zpad_Y_back  = fliplr(frameycbcr(:, (end - length(zpad)) + 1 : end, 1));
    zpad_Y_up    = fliplr(frameycbcr(1 : length(zpad), :, 1));
    zpad_Y_down  = fliplr(frameycbcr((end - length(zpad)) + 1 : end, :, 1));
    
    frame_ycbcr_padded = [zpad_Y_front frameycbcr(:, :, 1) zpad_Y_back];
    frame_ycbcr_padded2 = [zpad_Y_up; frameycbcr(:, :, 1); zpad_Y_down];
    %% Convolving Row by Row (480)
    
    for count_row = 1 : 1 : num_rows
        frame_y_padded = frame_ycbcr_padded(count_row, :, 1);
        row_tmp_y = (1 / (sum(effect)) * conv(double(effect), double(frame_y_padded)));
        frame_conv_padded(count_row, :, 1)  = row_tmp_y(front : end - back);
    end
    
    frame_conv_cut(:, :, 1) = frame_conv_padded(:, 1 + length(zpad) : end - length(zpad), 1 );
    frame_conv(:, :, 1) = frame_conv_cut(:, :, 1);
    frame_conv(:, :, 2 : 3) = frameycbcr(:, :, 2 : 3);
    %% Convert Frame Back to RGB
    
    [framergb] = convertYCBCRtoRGB_frame(frame_conv);
    writeVideo(video_out, uint8(framergb));
    %% Convolving Columm by Columm (640)
    
    for count_collum = 1 : 1 : num_columns
        frame_x_padded = frame_ycbcr_padded2(:, count_collum, 1);
        collum_tmp_y = (1 / (sum(effect)) * conv(double(effect), double(frame_x_padded)));
        frame_conv_padded2(:, count_collum, 1)  = collum_tmp_y(front : end - back);
    end
    
    frame_conv_cut2(:, :, 1) = frame_conv_padded2(1 + length(zpad) : end - length(zpad), :, 1 );
    frame_conv(:, :, 1) = frame_conv_cut2(:, :, 1);
    frame_conv(:, :, 2 : 3) = frameycbcr(:, :, 2 : 3);
    %% Convert Frame Back to RGB
    
    [framergb] = convertYCBCRtoRGB_frame(frame_conv);
    writeVideo(video_out, uint8(framergb));
end
%%
close(video_out);
status = 'finished';
tEndedgebFrame = toc(tStartedgebFrame);
disp(['Processing Time: ' num2str(tEndedgebFrame) 's']);
end