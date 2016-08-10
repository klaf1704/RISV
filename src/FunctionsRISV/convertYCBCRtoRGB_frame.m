function [rgb] = convertRGBtoYCBCR(frame)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% convertYCBCRtoRGB_frame, v.2
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   07/2015 All Rights Reserved
%
% This function converts YCBCR-Values to RGB
%          
%  |R|    | 1.000   0.000    1.400;  |   |Y|  
%  |G|  = | 1.000  -0.343    -0.711; | * |Cb-128|  
%  |B|    | 1.000   1.765    0.0000; |   |Cr-128|  
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 % Colorcorretion
 colorcorr = [1.000   0.000    1.400;     ...   
              1.000  -0.343    -0.711;    ...
              1.000   1.765    0.0000;];
 % Calculation
 R = colorcorr(1) * frame(:,:,1) + colorcorr(4) * (frame(:,:,2) - 128) + colorcorr(7) * (frame(:,:,3) - 128);  
 G = colorcorr(2) * frame(:,:,1) + colorcorr(5) * (frame(:,:,2) - 128) + colorcorr(8) * (frame(:,:,3) - 128);
 B = colorcorr(3) * frame(:,:,1) + colorcorr(6) * (frame(:,:,2) - 128) + colorcorr(9) * (frame(:,:,3) - 128);

 % Set output parameter
 rgb = cat( 3, R, G, B );
end

