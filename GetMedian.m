function [ median_vec ] = GetMedian( input_vec, median_size )
%GETRMS 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   author:     Markus Lüken
%   date:       30.09.2013
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%   calculates root mean squared vector from windows with size rms_size of 
%   given input vector
%
%

len = length(input_vec);
median_vec = zeros(1, len);

for j=median_size : len
   median_vec(j) = median(input_vec(j-(median_size-1):j)); 
end

median_vec(1:median_size-1) = ones(1,median_size-1)*median_vec(median_size);

end

