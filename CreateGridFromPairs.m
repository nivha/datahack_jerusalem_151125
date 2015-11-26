function [grid, orig] = CreateGridFromPairs (gps_list, accuracy)

% Get the list up to accurate point
gps_list = floor(gps_list/accuracy);

% Start from (0,0)
orig = min(gps_list)-1;
gps_list = bsxfun(@minus,gps_list,orig);

% Calc thin grid
grid00 = accumarray(gps_list,1);

% Make the grid thicker
grid = zeros(size(grid00)+1);
grid(1:end-1,1:end-1) = grid00;
grid(2:end,1:end-1) = grid00;
grid(1:end-1,2:end) = grid00;
grid(2:end,2:end) = grid00;
