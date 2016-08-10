function [status] = artificalBlockiness(video_input, num_frames, num_rows, num_columns, blocki_value,blocki_frame_percent,block_percent, output_name)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% artificalBlockiness, v.1.0
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   06/2015 All Rights Reserved
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    tStartblockFrame = tic;

    video_in = VideoReader(video_input);
    video_out = VideoWriter(output_name);
    video_out.FrameRate = 25;
    open(video_out);
    step = blocki_value;
    
    val_rows =  ceil(num_rows / blocki_value);
    val_columns =  ceil(num_columns / blocki_value);
    
    %% Checking if the Input-Values are no char
    testtype1 = isnumeric(blocki_value);
    if testtype1 == 0 
        error('Oops => Input Data Type Incorrect');
    end
        
    if blocki_value > 30 || blocki_value < 1
        error('ERROR => Degree Of Blockiness Incorrect')
    end
    %% Pattern For Not Homogeneous Blockiness Over All Frames
    if  blocki_frame_percent > 0;   
        pattern_all_frames = blockiFramePattern_d1(num_frames, blocki_frame_percent);
    else
        pattern_all_frames = zeros(1, num_frame);      
    end   

    %%
    for f = 1 : num_frames
        disp(['Frame: ' , int2str(f)])
        clear frame frame_block;
        frame = read(video_in, f);
        frame_block = frame;
        count_pattern = 1;   

        if f == 1 ||  mod(f,20) == 0            % Every x-th Frame New Error-Pattern
            % Pattern For Not Homogeneous Blockiness Within one Frames
            [pattern_within_Frame] = blockiFramePattern_d2(val_rows, val_columns, block_percent);
            pattern_within_Frame = [pattern_within_Frame(1 : end)];
        end

        if pattern_all_frames(f) == 0           % 0 Means Impair Next Frame
                for idx_r=1 : step : num_rows;  % Zeilen - INDEX_ROW
                    %disp(['IDX_row: ', num2str(idx_r)]);
                    if idx_r+step-1 <= num_rows
                        for idx_c=1 : step : num_columns; %Spalten - INDEX COLUMN
                            if pattern_within_Frame(count_pattern) == 0; % 0 Means Impair Next Block
                                %disp(['IDX_column: ', num2str(idx_c)]);%disp(idx_c);
                                %disp(['Count_Pattern: ', num2str(count_pattern)]);
                                if idx_c+step-1 <= num_columns        

                                   block_red = frame(idx_r:idx_r+step-1, idx_c:idx_c+step-1, 1);
                                   avg_red = mean(mean(block_red));
                                   block_green = frame(idx_r:idx_r+step-1, idx_c:idx_c+step-1, 2);
                                   avg_green = mean(mean(block_green));
                                   block_blue = frame(idx_r:idx_r+step-1, idx_c:idx_c+step-1, 3);
                                   avg_blue = mean(mean(block_blue));

                                   frame_block(idx_r : idx_r+step-1, idx_c : idx_c+step-1, 1) = avg_red;
                                   frame_block(idx_r : idx_r+step-1, idx_c : idx_c+step-1, 2) = avg_green;
                                   frame_block(idx_r : idx_r+step-1, idx_c : idx_c+step-1, 3) = avg_blue;

                                else
                                   block_red = frame(idx_r : idx_r+step-1, idx_c : end, 1);
                                   avg_red = mean(mean(block_red));
                                   block_green = frame(idx_r : idx_r+step-1, idx_c : end, 2);
                                   avg_green = mean(mean(block_green));
                                   block_blue = frame(idx_r : idx_r+step-1, idx_c : end, 3);
                                   avg_blue = mean(mean(block_blue));

                                   frame_block(idx_r : idx_r+step-1, idx_c : end, 1) = avg_red;
                                   frame_block(idx_r : idx_r+step-1, idx_c : end, 2) = avg_green;
                                   frame_block(idx_r : idx_r+step-1, idx_c : end, 3) = avg_blue;
                                end
                            end
                                count_pattern = count_pattern + 1;
                         end
                    else 
                        for idx_c = 1 : step : num_columns; %Spalten - INDEX COLUMN
                            if pattern_within_Frame(count_pattern) == 0; % 0 Means Impair Next Block
                                %disp(['IDX_column: ', num2str(idx_c)]);%disp(idx_c);
                                %disp(['Count_Pattern: ', num2str(count_pattern)]);    
                                if idx_c+step-1 <= num_columns        

                                   block_red = frame(idx_r : end, idx_c : idx_c+step-1, 1);
                                   avg_red = mean(mean(block_red));
                                   block_green = frame(idx_r : end, idx_c : idx_c+step-1, 2);
                                   avg_green = mean(mean(block_green));
                                   block_blue = frame(idx_r : end, idx_c : idx_c+step-1, 3);
                                   avg_blue = mean(mean(block_blue));

                                   frame_block(idx_r : end, idx_c : idx_c+step-1, 1) = avg_red;
                                   frame_block(idx_r : end, idx_c : idx_c+step-1, 2) = avg_green;
                                   frame_block(idx_r : end, idx_c : idx_c+step-1, 3) = avg_blue;

                                else
                                   block_red = frame(idx_r : end, idx_c : end,1);
                                   avg_red = mean(mean(block_red));
                                   block_green = frame(idx_r : end, idx_c : end,2);
                                   avg_green = mean(mean(block_green));
                                   block_blue = frame(idx_r : end, idx_c : end,3);
                                   avg_blue = mean(mean(block_blue));

                                   frame_block(idx_r : end, idx_c : end, 1) = avg_red;
                                   frame_block(idx_r : end, idx_c : end, 2) = avg_green;
                                   frame_block(idx_r : end, idx_c : end, 3) = avg_blue;
                                end
                            end
                                count_pattern = count_pattern + 1;
                         end
                    end

                 end
            else % ==> pattern_frame == 1 ==> Keep org. Frame
                frame_block = frame;
        end
        writeVideo(video_out, frame_block);
    end

    close(video_out);
    status = 'finished';
    tEndblockFrame = toc(tStartblockFrame);
    disp(['Processing Time: ' num2str(tEndblockFrame) 's']);
end
%%% E O F %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%