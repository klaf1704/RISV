function [status] = luminanz_impairment(video_input, num_frames, num_rows, num_columns, impairment, output_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   12/2015 All Rights Reserved
%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tStartblurrFrame = tic;
    
    video_in = VideoReader(video_input);
    video_out = VideoWriter(output_name);
    video_out.FrameRate = 25;
    open(video_out);
            
    %%
    if strcmp(impairment, 'light') 
        imp_val = 90;
    elseif strcmp(impairment, 'dark')
        imp_val = -90;
    else 
        error('ERROR => Impairment Type Incorrect, check if "light" or "dark" ')
    end

    %%
    imp_res = 15;
    zpad=zeros(1, length(imp_res)); 
    front = ceil(length(imp_res)/2); % Borders fro cutting after convolution
    back = floor(length(imp_res)/2); 
    
    frame = double(read(video_in, 1));
    frameycbcr = double(zeros(size(frame)));
    frame_imp  = double(zeros(size(frame)));
    framergb = double(zeros(size(frame)));
    
    [z, ~] = size(frame);
    padding = zeros(z, length(zpad));
    frame_imp_padded =  [padding frame_imp(:,:,1) padding];
    
    
    for f = 1 : num_frames
        %disp(['Frame: ' , int2str(f)])
        clear frame frame_block;
        frame = double(read(video_in, f));

        %% Convert Frame to YCBCR whole Frame at once
        [frameycbcr] = convertRGBtoYCBCR_frame(frame);

        zpad_Y_front = fliplr(frameycbcr(:, 1 : length(zpad), 1));
        zpad_Y_back = fliplr(frameycbcr(: , end - length(zpad) + 1 : end, 1));
        frame_ycbcr_padded = [zpad_Y_front frameycbcr(:, :, 1) zpad_Y_back];
        
        frame_imp_padded = imp_val + frame_ycbcr_padded; % Impair Lumiance Layer adding light/dark value

        frame_imp_cut(:, :, 1) = frame_imp_padded(:, 1 + length(zpad) : end - length(zpad), 1 );
        frame_imp(:, :, 1) = frame_imp_cut(:, :, 1);
        frame_imp(:, :, 2 : 3) = frameycbcr(:, :, 2 : 3);  
        %% Convert Frame Back to RGB
        [framergb] = convertYCBCRtoRGB_frame(frame_imp);

    writeVideo(video_out, uint8(framergb));
    end
    close(video_out);
    status = 'finished';
    tEndblurrFrame = toc(tStartblurrFrame);
    disp(['Processing Time: ' num2str(tEndblurrFrame) 's']);
end
%%% E O F

