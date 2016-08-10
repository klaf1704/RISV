function [pattern] = blockiFramePattern_d2(num_rows, num_columns, block_percent)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% blockiFramePattern, v.1.0
%
% © Falk Schiffner M.Sc. Technische Universität Berlin, Germany
%   06/2015 All Rights Reserved
%
% - Function Creats Error Pattern For 2 Dimensional Matrix
%   Depending On The Percentage Of Random Errors 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
pattern = ones(num_rows, num_columns);
range = numel(pattern);

x_blocks = (range * block_percent)/100;
x_blocks = int32(x_blocks);

pattern(1:x_blocks)=0;
X=randperm(numel(pattern));
pattern=reshape(pattern(X),size(pattern));
    
end
 


