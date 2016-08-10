%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HOST_RISV_Processing
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   1st version: 06/2015 
%   latest version: 08/2016 
%   All Rights Reserved
%
% This Script allows to create video impairments to video input files
% according to the ITU-T P.930 Rec.
%
%=> artifical Blockiness    => 'block' => insert block artefacts into the 
%                                         image
%=> artifical Blurring      => 'blurr' => blurring filter to reduce the 
%                                         sharpness ot the image
%=> artifical Edge Busyness => 'edgeB' => 
%=> artifical Noise (quant) => 'noiseQ'=> simulated Salt'n'Pepper Noise
%=> artifical Jerkiness     => 'jerki' => insert "stop'n'go" / jerki motion
%                                         in the video file
%
% ==>   All impairments can be further specified.
%       For more details, please have a look into the descriptions of the 
%       functions.
%
% => The source files need to be avi-Files 
% => There is NO support for audio, since only video in regarded
% => The output files are stored as motion-jpeg in an avi container 
% => The output files has NO audio
% => To insert audio you need e.g. ffmpeg
%    ==> there is an example ("mergeAV_ffmpeg_Host.m" and "mergeAV_ffmpeg.m")
%        of merging the impaired video with the audio of the source file, 
%        but this is no part of the toolbox, since ffmpeg need to be setup 
%        seperatly but can be run out of matlab
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%%% B E G I N    C O D E %%%
%
%% HEAD
% clean up!
clc; clear all; close all

%% Add Source and Target Directories, Add "Function-Folder"
    tmp = dir('ProcessedFiles');
    if isempty(tmp)
        mkdir('ProcessedFiles');
    end
    
    tmp = dir('Sourcefiles');
    if isempty(tmp)
        mkdir('Sourcefiles');
    end
    
    addpath('Sourcefiles');
    addpath('ProcessedFiles');
    addpath('FunctionsRISV');
    clear tmp;
    
%% Reading Source Files Names
    folder = 'Sourcefiles/*.avi';
    videodata = dir(folder); 
    
%% Input Processing Parameter
    disp('--- Select desired Impairment Type --- ');
    disp('---------------------------------------');
    disp('artifical Blockiness      => ''block'' ');
    disp('artifical Blurring        => ''blurr'' ');
    disp('artifical Edge Busyness   => ''edgeB'' ');
    disp('artifical Noise (quant)   => ''noiseQ'' ');
    disp('artifical Jerkiness       => ''jerki'' ');
    disp('---------------------------------------');
    impairment = input('Please Input Impairment Type From The List Above: ');
    
%% 
tStartOverall = tic;
switch impairment
    %%
    case 'block'
        disp(' ');
        disp('--- Artifical Blockiness Starts ---'); 
        disp('Select Size Of Blocks (in Pixel):' )
        blocki_value = input('1 = No Blockniess => 30 = Insane Big Blocks: ');
        disp('Select Percent Of Frames To Be Blocki:' )
        blocki_frame_percent = input('0 - 100%: ');
        disp('Select Percent Of Blocks Within A Frame To Be Impaired:' )
        block_percent = input('0 - 100%: ');
        
        wait = waitbar(0,'Please Wait - File Processing ...');
        
        for i = 1:length(videodata)
            disp(['Processing File: ' num2str(i)]); 
            video_input = videodata(i).name;         
            tmpname = strrep(video_input, '.avi','');
            output_name = ['ProcessedFiles\' tmpname '_blocki_' , num2str(blocki_value),'_framesimp_',num2str(blocki_frame_percent),...
                '_blocksimp_',num2str(block_percent) '.avi'];             
            [num_frames, num_rows, num_columns] = readVideoInput(video_input);
            
            [status] = artificalBlockiness(video_input, num_frames, ...
                               num_rows, num_columns, blocki_value,blocki_frame_percent, block_percent, output_name);
            disp(['Processing File: "', output_name ,'" ' status]);
            waitbar(i / length(videodata));
        end
        close(wait)    
    %%    
    case 'blurr'
        disp(' ');
        disp('--- Artifical Blurring Starts ---'); 
        disp('Select Methode for Blurring: ');
        disp('Blurr via Moving Average: ''MovAve'' ');
        disp('Blurr via ITU-T Rec.930 Filter: ''ITU930'' ');
        blurrmeth = input('Methode: ');
        switch blurrmeth
            case 'MovAve'
                disp('Select Smoothing Value (Nummer Of Pixel To Average):' )
                smooth_val = input('1 = No Blurring => xx = Number of Pixel: ');
            case 'ITU930'
                disp('Select Degree of Impairment :' )
                smooth_val = input('1 highest ==> 6 lowest: ');
            otherwise
                error('ERROR => Impairment Type Unknown ==> False Input');     
        end
        
        wait = waitbar(0,'Please Wait - File Processing ...');
        
        for i = 1:length(videodata)
            disp(['Processing File: ' num2str(i)]); 
            video_input = videodata(i).name;         
            tmpname = strrep(video_input, '.avi','');
            output_name = ['ProcessedFiles\' tmpname '_blurr_' , num2str(smooth_val), num2str(blurrmeth),'.avi'];             
            [num_frames, num_rows, num_columns] = readVideoInput(video_input);
            switch blurrmeth
                case 'MovAve'
                    [status] = Blurring_RowColumnsMovAverage(video_input, output_name, num_frames, num_rows,  num_columns, smooth_val);
                case 'ITU930'
                    [status] = artificalBlurring(video_input, output_name, smooth_val, num_frames, num_rows);
            end
            disp(['Processing File: "', output_name ,'" ' status]);
            waitbar(i / length(videodata));
        end
        close(wait)    
    %%    
    case 'noiseQ'
        disp(' ');
        disp('--- Artifical Quantization Noise  ---'); 
        disp('Select Percent Of Frames To Be Noisy:' )
        procent_noise = input('0 - 100% (Note: 10% already very high Noise): ');
        
        wait = waitbar(0,'Please Wait - File Processing ...');
        
        for i = 1:length(videodata)
            disp(['Processing File: ' num2str(i)]); 
            video_input = videodata(i).name;         
            tmpname = strrep(video_input, '.avi','');
            output_name = ['ProcessedFiles\' tmpname '_noiseQ_' , num2str(procent_noise),'.avi'];             
            [num_frames, num_rows, num_columns] = readVideoInput(video_input);
            
            [status] = artificalQuantNoise(video_input, output_name, procent_noise, num_frames, num_rows, num_columns);
            disp(['Processing File: "', output_name ,'" ' status]);
            waitbar(i / length(videodata));
        end
        close(wait)  
    %%  
    case 'edgeB'
        disp(' ');
        disp('--- Artifical Edge Busyness  ---'); 
        disp('Select Level of Impairment To Be Created:' )
        val_res = input ('-1 ... -30: ');
         
        wait = waitbar(0,'Please Wait - File Processing ...');
        
        for i = 1:length(videodata)
            disp(['Processing File: ' num2str(i)]); 
            video_input = videodata(i).name;         
            tmpname = strrep(video_input, '.avi','');
            output_name = ['ProcessedFiles\' tmpname '_edgeB_' , num2str(val_res),'.avi'];             
            [num_frames, num_rows, num_columns] = readVideoInput(video_input);
            
            [status] = artificalEdgeBusyness(video_input, output_name, val_res, num_frames, num_rows, num_columns);
            disp(['Processing File: "', output_name ,'" ' status]);
            waitbar(i / length(videodata));
        end        
        close(wait)
    %%
     case 'jerki'
        disp(' ');
        disp('--- Artifical Jerkiness Starts ---'); 
        disp('Select Nummer Of Frames To Skip:' )
        holdframe = input('1 = No Skip => xx = Number of Frames: ');
        
        wait = waitbar(0,'Please Wait - File Processing ...');
        
        for i = 1:length(videodata)
            disp(['Processing File: ' num2str(i)]); 
            video_input = videodata(i).name;         
            tmpname = strrep(video_input, '.avi','');
            output_name = ['ProcessedFiles\' tmpname '_jerki_' , num2str(holdframe),'.avi'];             
            [num_frames, num_rows, num_columns] = readVideoInput(video_input);
            
            [status] = artificalJerkiness(video_input, num_frames, holdframe, output_name);
            disp(['Processing File: "', output_name ,'" ' status]);
            waitbar(i / length(videodata));
        end
        close(wait)    
        
    otherwise
        error('ERROR => Impairment Type Unknown ==> False Input'); 
end

disp('File Processing Finished');
tEndOverall = toc(tStartOverall);
disp(['Processing Time: ' num2str(tEndOverall) 's']);

%%% E N D   O F   F I L E %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%