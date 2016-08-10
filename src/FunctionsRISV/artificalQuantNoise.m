function [status] = artificalQuantNoise(video_input, output_name, procent_noise, num_frames, num_rows, num_columns)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% articalQuantNoise.m, v.1.0
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   07/2015 All Rights Reserved
%
% Creating "Salt/Pepper" Noise (ITU-T Rec. 930)
% Only the Luminance Values are considered
% procent_noise ==> Procent of Pixel in a Frame to be replaced by 
% a random value (from 16 to 255)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tStartQuantNoiseFrame = tic;

    video_in = VideoReader(video_input);
    video_out = VideoWriter(output_name);
    video_out.FrameRate = 25;
    %video_out.FileFormat = 'mp4';
    open(video_out);

    %%
    frame = double(read(video_in, 1));
    frameycbcr = double(zeros(size(frame)));
    framergb = double(zeros(size(frame)));
    frame_quant_noise = double(zeros(size(frame)));

    for f = 1 : num_frames    
        frame = double(read(video_in, f));
        %% Noise Pattern
        pattern = zeros(num_rows, num_columns);
        range = numel(pattern);

        x_pro = int32(procent_noise * range) / 100;
        rand_luminance_values = randi([16 255], 1, x_pro);

        pattern(1:x_pro) = rand_luminance_values;
        X=randperm(numel(pattern));
        pattern=reshape(pattern(X), size(pattern));

        idx_val = find(pattern)';
        % Convert Frame to YCBCR 
        [frameycbcr] = convertRGBtoYCBCR_frame(frame);
        
        % Match Noise Pattern on Y-Layer 
        frame_y = frameycbcr(:, :, 1);              % Luminanz Layer
        frame_y(idx_val) = pattern(idx_val);
        frame_quant_noise(:, :, 1)  = frame_y;
        frame_quant_noise(:, :, 2:3) = frameycbcr(:, :, 2:3);

        % Convert Frame back to RGB
        [framergb] = convertYCBCRtoRGB_frame(frame_quant_noise);
        writeVideo(video_out, uint8(framergb));
    end
    close(video_out);
    status = 'finished';
    tEndQuantNoiseFrame = toc(tStartQuantNoiseFrame);
    disp(['Processing Time: ' num2str(tEndQuantNoiseFrame) 's']);
end