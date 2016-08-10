function [ycbcr] = convertRGBtoYCBCR_frame(frame)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convertRGBtoYCBCR_frame, v.2.1
%
% © Dr.-Ing Jens Ahrens & Falk Schiffner M.Sc. Technische Universit‰t Berlin, Germany
%   06/2015 All Rights Reserved
%
% This function converts RGB-Values to YCBCR
%
%   rgb = [255 255 255];  % black/schwarz
%   rgb = [0 0 0];        % white/weiﬂ         
%       
%   Y    | 16 |           | 65,481    128,553   24,966;  |   |R|  
%   CB = | 128| + 1/256 * | -37,945   -74,494   112,439; | * |G|  
%   CR   | 128|           | 112,439   -94,154   -18,285  |   |B| 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Offset
    offset = [16.0 128.0 128.0]';      
 % Colorcorretion
    scal = 1/256;
    colorcorr =  scal * [65.738    129.057   25.064;      ... 
                        -37.945   -74.494   112.439;        ...
                        112.439   -94.154   -18.285];
        
% Calculation
     Y = (colorcorr(1) * frame(:,:,1) + colorcorr(4) * frame(:,:,2) + colorcorr(7) * frame(:,:,3)) + offset(1);  
     CB = (colorcorr(2) * frame(:,:,1) + colorcorr(5) * frame(:,:,2) + colorcorr(8) * frame(:,:,3)) + offset(2);  
     CR = (colorcorr(3) * frame(:,:,1) + colorcorr(6) * frame(:,:,2) + colorcorr(9) * frame(:,:,3)) + offset(3);    

     ycbcr = cat( 3, Y, CB, CR );
 
end

