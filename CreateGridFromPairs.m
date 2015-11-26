function [grid, orig] = CreateGridFromPairs (gps_list, accuracy, thickness)

if ~exist('thickness','var')
    thickness = 3;
end

[gps_list,orig] = PointsFloor(gps_list,accuracy);

% Calc thin grid
grid00 = accumarray(gps_list,1);

% Make the grid thicker
grid = zeros(size(grid00)+thickness-1);
orig = orig - floor(thickness/2);
orig = double(orig)*accuracy;

for i = 1:thickness
    for j = 1:thickness
        grid(i:end-thickness+i,j:end-thickness+j) = grid00;
    end
end