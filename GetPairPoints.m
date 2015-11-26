function [img4d,orig,xy_size] = GetPairPoints (gps_points, accuracy)

[gps_points,orig,direction] = PointsFloor(gps_points,accuracy);

removed_points = direction > 9;

gps_points(removed_points,:) = [];
direction(removed_points,:) = [];

img2d = accumarray(gps_points,1);
gps_points_1d = sub2ind(size(img2d),gps_points(:,1),gps_points(:,2));

gps_pairs = [gps_points_1d(1:end-1), direction];

img4d = accumarray(gps_pairs,1,[],[],[],true);

xy_size = size(img2d);